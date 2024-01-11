// To parse this JSON data, do
//
//     final fileUploadResponse = fileUploadResponseFromJson(jsonString);

import 'dart:convert';

FileUploadResponse fileUploadResponseFromJson(String str) => FileUploadResponse.fromJson(json.decode(str));

String fileUploadResponseToJson(FileUploadResponse data) => json.encode(data.toJson());

class FileUploadResponse {
    int? statusCode;
    String? statusMessage;

    FileUploadResponse({
        this.statusCode,
        this.statusMessage,
    });

    factory FileUploadResponse.fromJson(Map<String, dynamic> json) => FileUploadResponse(
        statusCode: json["statusCode"],
        statusMessage: json["statusMessage"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "statusMessage": statusMessage,
    };
}
