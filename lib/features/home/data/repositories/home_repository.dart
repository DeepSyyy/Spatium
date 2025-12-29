import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/home/data/datasources/home_remote_data_source.dart';
import 'package:spatium/features/home/data/models/daily_mood_model.dart';

/// Home Repository Interface
abstract class HomeRepository {
  Future<Either<Failure, DailyMoodModel?>> getTodayMood();
  Future<Either<Failure, List<MoodStatModel>>> getMoodStatistics(int days);
  Future<Either<Failure, DailyMoodModel>> saveDailyMood(int moodTagId, String note);
  Future<Either<Failure, List<ChatActivityModel>>> getChatSessions();
}

/// Home Repository Implementation
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DailyMoodModel?>> getTodayMood() async {
    try {
      final mood = await remoteDataSource.getTodayMood();
      return Right(mood);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MoodStatModel>>> getMoodStatistics(int days) async {
    try {
      final stats = await remoteDataSource.getMoodStatistics(days);
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DailyMoodModel>> saveDailyMood(int moodTagId, String note) async {
    try {
      final mood = await remoteDataSource.saveDailyMood(moodTagId, note);
      return Right(mood);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatActivityModel>>> getChatSessions() async {
    try {
      final sessions = await remoteDataSource.getChatSessions();
      return Right(sessions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
