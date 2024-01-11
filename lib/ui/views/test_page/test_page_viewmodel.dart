import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/enum/dialog_type.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:test_blu/core/model/fileUpload_model.dart';
import 'package:test_blu/core/model/user.model.dart';
import 'package:test_blu/services/api_service.dart';
import 'package:test_blu/services/user_service.dart';
import 'package:test_blu/ui/common/widgets/dialogs/custom_dialog.dart';
import 'package:test_blu/ui/views/home/home_view.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:xml/xml.dart' as xml;

class TestPageViewModel extends BaseViewModel with NavigationMixin {
  TestPageViewModel() {
    requestPermissions();
    // showDialog('message');
    _fileUploadResponse = FileUploadResponse();
  }

  final _sharedPreference = locator<SharedPreferences>();
  final _apiService = ApiService.init();
  final _dialogService = locator<DialogService>();

  FileUploadResponse? _fileUploadResponse;
  FileUploadResponse? get fileUploadResponse => _fileUploadResponse;

  final focusNode = FocusNode();
  DateTime? date = DateTime.now();
  DateTime? _pickDate;
  DateTime get pickDate => _pickDate ?? DateTime.now();
  String? get fDate => DateFormat('dd-MM-yyyy').format(pickDate);
  String? csvData = '';
  String? xmlData = '';
  String? _filePath;
  String? _xmlPath;
  String? get csvFilePath => _filePath;
  String? get xmlPath => _xmlPath;
  String? get Date1 => DateFormat('ddMMyyyy').format(pickDate);
  String get session => DateFormat('a').format(DateTime.now());
  FormData? formData;
  String? fileName;
  String? api = 'https://cowma.vewinpro.com';

  DateTime get tenDaysAgo => pickDate.subtract(const Duration(days: 10));
  String? get fDate10DaysAgo => DateFormat('dd-MM-yyyy').format(tenDaysAgo);

  String? get locationId => _sharedPreference.getString('locationId') ?? "01";

  late final List<User> _userList = [];
  final _userService = UserService();
  List<User> get userList => _userList ?? [];

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? fromDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (fromDate != null) {
      _pickDate = fromDate;
      notifyListeners();
    }
    _sharedPreference.setString('fromdate', fDate ?? '');
  }

  Future<void> getDate(context) async {
    _userList.clear();
    var users1 = await _userService.readDate(fDate);
    notifyListeners();
    users1.forEach((user) {
      notifyListeners();
      var userModel = User();
      userModel.id = user['id'];
      userModel.center = user['center'];
      userModel.customerId = user['customerId'];
      userModel.dateTime = user['dateTime'];
      userModel.session = user['session'];
      userModel.weight = user['weight'];
      userModel.time = user['time'];
      _userList.add(userModel);
    });
    var usersList = users1.map((user) => user.values.toList()).toSet().toList();
    print(usersList);
    csvData = const ListToCsvConverter().convert(usersList.cast<List<dynamic>>());
    print(csvData);
    notifyListeners();
    // xmlData = await convertCsvToXml(csvData!);
    await writeToInternalStorage(context);

    await copyToUsbPendrive();
    await writeToPenDrive();

    // csvData = flatUsersList.join(',');
    print(csvData);
  }

  Future<String> getExternalStorageDirectoryPath() async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  Future<void> writeToPenDrive() async {
    try {
      final externalDir = await getExternalStorageDirectoryPath();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$Date1-$session-($locationId).csv';

      final filePath = '$externalDir/$fileName';

      final file = File(filePath);

      await file.writeAsString(csvData!);

      // _filePath = filePath;

      print('CSV data written to pen drive: $filePath');
    } catch (e) {
      print('Error writing to pen drive: $e');
    }
  }

  Future<String> getInternalStorageDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> writeToInternalStorage(context) async {
    try {
      final internalDir = await getInternalStorageDirectoryPath();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      fileName = '$Date1-$session-$locationId.csv';

      final filePath = '$internalDir/$fileName';

      final file = File(filePath);
      csvData = 'id,dateTime,center,customerId,weight,session,time\n${csvData!}';

      await file.writeAsString(csvData!);
      notifyListeners();
      _filePath = filePath;
      notifyListeners();
      await sendFormData(context);

      print('CSV data written to internal storage: $filePath');
    } catch (e) {
      print('Error writing to internal storage: $e');
    }
  }

  Future<void> sendFormData(context) async {
    var dio = Dio();

    if (csvData != null) {
      File file = File(_filePath.toString());
      String filePath = file.path;

      FormData data = FormData.fromMap({
        'File': await MultipartFile.fromFile(filePath, filename: fileName),
        'CreatedOn': DateTime.now().toIso8601String(),
        'CreatedBy': 'user',
      });
      FormData data1 = FormData.fromMap({
        // 'key': '0963360015cf3b081b5bf1cf7867a707',
        'File': await MultipartFile.fromFile(filePath, filename: fileName),
        'ModifiedOn': DateTime.now().toIso8601String(),
        'ModifiedBy': 'user',
      });

      print(data);
      print(data.toString());

      var response = await dio.post('$api/Api/CenterData/File', data: data, onSendProgress: (int sent, int total) {
        print('$sent , $total');
        print(data.toString());
      }).catchError((err) {
        showErrDialog('something went Wrong Please check your internet');
      });

      print(response.data);

      if (response.data != null) {
        if (response.data['statusMessage'] == 'File Already Exist') {
          dialog1(context);
        } else {
          response.data['statusMessage'] == 'Inserted File';
          showSuccessDialog('Exported Successfully'); //response.data['statusMessage']);
        }
        //  if (response.data['statusMessage'] == 'Inserted File') {
        //     showSuccessDialog(response.data['statusMessage']);
        //   } else
      } else {
        showErrDialog('Export Failed');
      }
    }
  }

  Future<void> sendFormData1() async {
    var dio = Dio();

    if (csvData != null) {
      File file = File(_filePath.toString());
      String filePath = file.path;

      FormData data1 = FormData.fromMap({
        // 'key': '0963360015cf3b081b5bf1cf7867a707',
        'File': await MultipartFile.fromFile(filePath, filename: fileName),
        'ModifiedOn': DateTime.now().toIso8601String(),
        'ModifiedBy': 'user',
      });

      print(data1);
      print(data1.toString());

      var responseUpdate = await dio.post('$api/Api/CenterData/UpdateFile', data: data1, onSendProgress: (int sent, int total) {
        print('$sent , $total');
        print(data1.toString());
      });

      print(responseUpdate.data);

      if (responseUpdate.statusCode == 200) {
        showSuccessDialog('Updated SuccessFully'); //responseUpdate.data['statusMessage']);
      } else {}
    }
  }

  Future<void> copyToUsbPendrive() async {
    try {
      String csvFilePath = _filePath.toString();

      List<UsbDevice> devices = await UsbSerial.listDevices();

      if (devices.isEmpty) {
        print('No USB devices found.');
        return;
      }

      UsbDevice pendrive = devices.first;

      UsbPort? port = await pendrive.create();

      await port?.write(Uint8List.fromList(await File(csvFilePath).readAsBytes()));

      await port?.close();

      print('CSV file copied to USB pendrive successfully.');
    } catch (e) {
      print('Error copying CSV file to USB pendrive: $e');
    }
  }

  Future<void> submitData(context) async {
    await getDate(context);
    print(csvData);
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.manageExternalStorage, // For Android 10+
    ].request();

    // Check the status of requested permissions
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      // Storage permission granted, you can now write to external storage
    } else {
      // Permission denied
    }
  }

  Future<void> requestExternalStoragePermission() async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        print('External storage permission granted');
      } else {
        print('External storage permission denied');
      }
    } else {
      print('External storage permission already granted');
    }
  }

  void goBack() {
    notifyListeners();
    goToBack();
  }

  void dialog1(context) {
    notifyListeners();
    showUpdateDialog(context);
  }

  void showSuccessDialog(String message) {
    _dialogService.showCustomDialog(variant: DialogType.success, title: "", description: message, mainButtonTitle: 'OK');
  }

  void showErrDialog(String message) {
    _dialogService.showCustomDialog(variant: DialogType.custom, title: "Error", description: message, mainButtonTitle: 'OK');
  }

  void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Message',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'File Already Exist',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                goToBack();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the "OK" button press
                notifyListeners();
                sendFormData1();
                goToBack();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// class CustomDialog extends StatelessWidget {
//   const CustomDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.blue, // Set the background color here
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 0, // No shadow
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Custom Dialog',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'This is a custom dialog with a blue background.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
