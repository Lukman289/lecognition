import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lecognition/core/constant/api_urls.dart';
import 'package:lecognition/core/network/dio_client.dart';
import 'package:lecognition/data/user/models/update_user_profile_params.dart';
import 'package:lecognition/service_locator.dart';

abstract class UserApiService {
  Future<Either> getUserProfile();
  Future<Either> updateUserProfile(UpdateUserProfileParams params);
}

class UserApiServiceImpl extends UserApiService {
  @override
  Future<Either> getUserProfile() async {
    try {
      var response = await sl<DioClient>().get(
        ApiUrls.getUserById,
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
      return Left(error.response!.data["message"]);
    }
  }

  @override
  Future<Either> updateUserProfile(UpdateUserProfileParams params) async {
    try {
      var response = await sl<DioClient>().put(
        ApiUrls.getUserById,
        data: params.toMap(),
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
      return Left(error.response!.data["message"]);
    }
  }
}
