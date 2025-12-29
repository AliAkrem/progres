import 'package:progres/features/auth/domain/repositories/auth_repository.dart';

class GetEstablishmentIdUseCase {
  final AuthRepository repository;

  GetEstablishmentIdUseCase(this.repository);

  Future<String?> call() {
    return repository.getEstablishmentId();
  }
}
