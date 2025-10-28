import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/entities/user.dart';

@injectable
class SearchHomeUseCase {
  List<User> call(SearchHomeParams params) {
    final allUsers = params.allUsers;
    final query = params.query.toLowerCase();

    if (query.isEmpty) {
      return allUsers;
    }

    return allUsers.where((user) {
      final name = '${user.firstName} ${user.lastName}'.toLowerCase();
      final email = user.email.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }
}

class SearchHomeParams extends Equatable {
  final List<User> allUsers;
  final String query;

  const SearchHomeParams({required this.allUsers, required this.query});

  @override
  List<Object?> get props => [allUsers, query];
}
