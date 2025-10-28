import 'package:equatable/equatable.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/entities/user.dart';
import '../../domain/use_cases/fetch_user_usecase.dart';
import '../../domain/use_cases/search_user_usecase.dart';

part 'home_page_state.dart';

@singleton
class HomePageCubit extends Cubit<HomeState> {
  final FetchNewUserUseCase _fetchNewUserUseCase;
  final SearchHomeUseCase _searchHomeUseCase;
  Ticker? _ticker;
  int _tickCount = 0;
  String _currentQuery = '';

  HomePageCubit(this._fetchNewUserUseCase, this._searchHomeUseCase) : super(HomeInitial());

  void startFetchingUsers(TickerProvider tickerProvider) async {
    _ticker?.dispose();
    await getNextUser();
    _ticker = tickerProvider.createTicker((elapsed) async {
      _tickCount++;

      if (_tickCount * 16 >= 5000) {
        _tickCount = 0;
        await getNextUser();
      }
    });
    _ticker?.start();
  }

  void stopFetchingUsers() {
    _ticker?.stop();
  }

  Future<void> getNextUser() async {
    try {
      final newUser = await _fetchNewUserUseCase();

      final currentState = state;
      List<User> currentList = [];

      if (currentState is HomeSuccess) {
        currentList = currentState.allUsers;
      }

      final newAllList = [newUser, ...currentList];

      final newFilteredList = _searchHomeUseCase(SearchHomeParams(allUsers: newAllList, query: _currentQuery));

      emit(HomeSuccess(allUsers: newAllList, filteredUsers: newFilteredList));
    } catch (e) {
      emit(HomeError("Falha ao buscar novo usuário: $e"));
    }
  }

  void searchUsers(String query, TickerProvider tickerProvider) {
    _currentQuery = query;

    if (state is! HomeSuccess) return;

    final currentState = state as HomeSuccess;

    if (query.isEmpty) {
      startFetchingUsers(tickerProvider);
    } else {
      stopFetchingUsers();
    }

    final newFilteredList = _searchHomeUseCase(SearchHomeParams(allUsers: currentState.allUsers, query: _currentQuery));

    emit(currentState.copyWith(filteredUsers: newFilteredList));
  }

  @override
  Future<void> close() {
    _ticker?.dispose();
    return super.close();
  }
}
