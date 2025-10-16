import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../core/error/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();
}