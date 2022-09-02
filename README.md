# movement_recognition_frontend

Flutter project for Android to recognize hand movements has to be used combined with aws lambda function (movement-recognition-lambda)

## Getting Started

#### set aws url
add settings.dart file to lib folder with content:

abstract class HttpSettings {
  static String awsUrl =
      '...';
  static String localUrl = '...';
}
