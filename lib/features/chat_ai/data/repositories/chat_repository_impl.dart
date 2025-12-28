import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/chat_ai/data/datasources/chat_remote_data_source.dart';
import 'package:spatium/features/chat_ai/data/models/chat_message_model.dart';
import 'package:spatium/features/chat_ai/data/models/chat_session_model.dart';

/// Chat Repository
/// Handles data operations for chat functionality
abstract class ChatRepository {
  Future<Either<Failure, List<ChatSessionModel>>> getUserSessions();
  Future<Either<Failure, ChatSessionModel>> createSession(String title);
  Future<Either<Failure, void>> deleteSession(String sessionId);
  Future<Either<Failure, List<ChatMessageModel>>> getSessionMessages(
    String sessionId, {
    int limit = 20,
  });
  Future<Either<Failure, ChatMessageModel>> sendMessage(
    String sessionId,
    String content,
  );
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatSessionModel>>> getUserSessions() async {
    try {
      final sessions = await remoteDataSource.getUserSessions();
      return Right(sessions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException {
      return Left(ServerFailure(message: 'Unauthorized', statusCode: 401));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatSessionModel>> createSession(String title) async {
    try {
      final session = await remoteDataSource.createSession(title);
      return Right(session);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException {
      return Left(ServerFailure(message: 'Unauthorized', statusCode: 401));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String sessionId) async {
    try {
      await remoteDataSource.deleteSession(sessionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException {
      return Left(ServerFailure(message: 'Unauthorized', statusCode: 401));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getSessionMessages(
    String sessionId, {
    int limit = 20,
  }) async {
    try {
      final messages = await remoteDataSource.getSessionMessages(
        sessionId,
        limit: limit,
      );
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException {
      return Left(ServerFailure(message: 'Unauthorized', statusCode: 401));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage(
    String sessionId,
    String content,
  ) async {
    try {
      final message = await remoteDataSource.sendMessage(sessionId, content);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException {
      return Left(ServerFailure(message: 'Unauthorized', statusCode: 401));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
