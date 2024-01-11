import 'package:stacked_services/stacked_services.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/enum/dialog_type.dart';
import 'package:test_blu/ui/common/widgets/dialogs/custom_dialog.dart';
import 'package:test_blu/ui/common/widgets/dialogs/error_dialog.dart';
import 'package:test_blu/ui/common/widgets/dialogs/message_dialog.dart';
import 'package:test_blu/ui/common/widgets/dialogs/success_dialog.dart';

void setupDialogUi() {
  locator<DialogService>().registerCustomDialogBuilders(
    {
      null: (context, dialogRequest, completer) => MessageDialog(
            title: dialogRequest.title,
            description: dialogRequest.description,
            mainButtonTitle: dialogRequest.mainButtonTitle,
            onMainButtonClick: () => completer(
              DialogResponse(confirmed: true),
            ),
          ),
      DialogType.error: (context, dialogRequest, completer) => ErrorDialog(
            title: dialogRequest.title,
            description: dialogRequest.description,
            mainButtonTitle: dialogRequest.mainButtonTitle,
            onMainButtonClick: () => completer(
              DialogResponse(confirmed: true),
            ),
          ),
      DialogType.custom: (context, dialogRequest, completer) => CustomDialog(
            title: dialogRequest.title,
            description: dialogRequest.description,
            mainButtonTitle: dialogRequest.mainButtonTitle,
            onMainButtonClick: () => completer(
              DialogResponse(confirmed: true),
            ),
          ),
      DialogType.success: (context, dialogRequest, completer) => SuccessDialog(
            title: dialogRequest.title,
            description: dialogRequest.description,
            mainButtonTitle: dialogRequest.mainButtonTitle,
            onMainButtonClick: () => completer(
              DialogResponse(confirmed: true)
            ),
          ),
    },
  );
}
