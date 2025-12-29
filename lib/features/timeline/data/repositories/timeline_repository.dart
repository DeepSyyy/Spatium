import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/timeline/data/datasources/timeline_remote_data_source.dart';
import 'package:spatium/features/timeline/data/models/post_model.dart';

/// Timeline Repository
/// Handles data operations for timeline/posts functionality
abstract class TimelineRepository {
  Future<Either<Failure, List<PostModel>>> getAllPosts();
  Future<Either<Failure, PostModel>> getPostDetail(String postId);
  Future<Either<Failure, PostModel>> createPost(String content, int moodTagId);
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, List<CommentModel>>> getPostComments(String postId);
  Future<Either<Failure, CommentModel>> createComment(String postId, String content);
  Future<Either<Failure, void>> deleteComment(String commentId);
  Future<Either<Failure, void>> reactToPost(String postId, String emoji);
  Future<Either<Failure, List<ReactionSummaryModel>>> getReactionSummary(String postId);
}

class TimelineRepositoryImpl implements TimelineRepository {
  final TimelineRemoteDataSource remoteDataSource;

  TimelineRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PostModel>>> getAllPosts() async {
    try {
      final posts = await remoteDataSource.getAllPosts();
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException {
      return Left(ServerFailure(message: 'Unauthorized', statusCode: 401));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PostModel>> getPostDetail(String postId) async {
    try {
      final post = await remoteDataSource.getPostDetail(postId);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PostModel>> createPost(String content, int moodTagId) async {
    try {
      final post = await remoteDataSource.createPost(content, moodTagId);
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> getPostComments(String postId) async {
    try {
      final comments = await remoteDataSource.getPostComments(postId);
      return Right(comments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, CommentModel>> createComment(String postId, String content) async {
    try {
      final comment = await remoteDataSource.createComment(postId, content);
      return Right(comment);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await remoteDataSource.deleteComment(commentId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> reactToPost(String postId, String emoji) async {
    try {
      await remoteDataSource.reactToPost(postId, emoji);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ReactionSummaryModel>>> getReactionSummary(String postId) async {
    try {
      final reactions = await remoteDataSource.getReactionSummary(postId);
      return Right(reactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
