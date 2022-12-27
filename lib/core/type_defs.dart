import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/faliure.dart';

//there can be failure and succes(t)
typedef FutureEither<T> = Future<Either<Failure, T>>;
//there can be failure but succes returns void
typedef FutureVoid<T> = FutureEither<void>;
