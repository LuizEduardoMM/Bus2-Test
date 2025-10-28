part of 'home_page_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<User> allUsers;
  final List<User> filteredUsers;

  const HomeSuccess({required this.allUsers, required this.filteredUsers});

  @override
  List<Object> get props => [allUsers, filteredUsers];

  HomeSuccess copyWith({List<User>? allUsers, List<User>? filteredUsers}) {
    return HomeSuccess(allUsers: allUsers ?? this.allUsers, filteredUsers: filteredUsers ?? this.filteredUsers);
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
