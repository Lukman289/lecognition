import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lecognition/core/constant/api_urls.dart';
import 'package:lecognition/core/network/dio_client.dart';
import 'package:lecognition/service_locator.dart';

abstract class HistoryApiService {
  Future<Either> getUserHistories();
}

class HistoryApiServiceImpl extends HistoryApiService {
  @override
  Future<Either> getUserHistories() async {
    try {
      var response = await sl<DioClient>().get(
        ApiUrls.scanByUser,
        options: Options(
          validateStatus: (status) {
            // Mengizinkan semua status code agar tidak dianggap sebagai exception
            return status != null && status <= 500;
          },
        ),
      );
      if (response.statusCode! >= 400) {
        print(response.data);
        return Left(response.data.toString());
      }
      return Right(response.data);
    } on DioException catch (error) {
      return Left(
        error.response!.data["message"] ?? "An unknown error occured",
      );
    }
  }
}