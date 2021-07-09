

import 'package:weapp_1/Screens/Api/POST/Data.dart';

class AddUser {
    Data data;
    String message;
    bool status;
    int code;

    AddUser({this.data, this.message, this.status, this.code});

    factory AddUser.fromJson(Map<String, dynamic> json) {
        return AddUser(
            data: json['data'] != null ? Data.fromJson(json['data']) : null,
            message: json['message'], 
            status: json['status'], 
            code: json['statusCode'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        data['statusCode'] = this.code;
        if (this.data != null) {
            data['data'] = this.data.toJson();
        }
        return data;
    }
}