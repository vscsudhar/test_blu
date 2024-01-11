import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:test_blu/core/model/fileUpload_model.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService init() {
    final dio = Dio();
    dio.options.baseUrl = 'https://b4ac-2401-4900-4845-f9fb-310d-c5c7-af15-a569.ngrok-free.app';

    return ApiService(dio);
  }

  // @POST('/Api/CenterData/File')
  // Future<FileUploadResponse> uploadFile(
  //   @Part(name: 'File') FormData file,
  // );
}
