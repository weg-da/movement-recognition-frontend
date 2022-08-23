import 'package:dio/dio.dart' as dio;
import 'package:movement_recognition_frontend/model_data.dart';

class HttpMovement {
  // http post request for sending data to backend svm model
  Future postSensorData({required ModelData modelData}) async {
    Map data = modelData.createMap();

    var dios = dio.Dio();

    dios.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    // dios.options.headers["Authorization"] = "Bearer $accessToken";

    dio.Response<String> res;
    try {
      res =
          await dios.post('http://192.168.178.192:8000/movement/', data: data);
    } on dio.DioError catch (e) {
      return Future.error(e.message);
    }

    if (res.statusCode == 200 && res.data != null) {
      // print(res.data.toString() + " " + res.statusMessage.toString());
      modelData.result = res.data.toString();
    } else {
      return Future.error(res.statusCode.toString());
    }
  }

  Future postSensorDataAWS({required ModelData modelData}) async {
    Map data = modelData.createMap();

    var dios = dio.Dio();

    dios.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    // dios.options.headers["Authorization"] = "Bearer $accessToken";

    dio.Response<String> res;
    try {
      res = await dios.post(
          'https://dl2v11mnrc.execute-api.eu-central-1.amazonaws.com/default/first',
          data: data);
    } on dio.DioError catch (e) {
      return Future.error(e.message);
    }

    if (res.statusCode == 200 && res.data != null) {
      modelData.result = res.data.toString().substring(17, 18);
    } else {
      return Future.error(res.statusCode.toString());
    }
  }
}
