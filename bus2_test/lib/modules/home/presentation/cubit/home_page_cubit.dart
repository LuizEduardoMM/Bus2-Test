import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/entities/user.dart';
import '../../domain/use_cases/fetch_user_usecase.dart';

part 'home_page_state.dart';

@singleton
class HomePageCubit extends Cubit<HomeState> {
  final FetchNewUserUseCase _fetchNewUserUseCase;
  Ticker? _ticker;
  int _tickCount = 0;

  HomePageCubit(this._fetchNewUserUseCase) : super(HomeInitial());

  void startFetchingUsers(TickerProvider tickerProvider) async {
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
    _ticker?.dispose();
    _ticker = null;
  }

  Future<void> getNextUser() async {
    try {
      final newUser = await _fetchNewUserUseCase();

      final currentState = state;
      List<User> currentList = [];

      if (currentState is HomeSuccess) {
        currentList = currentState.users;
      }

      final newList = [newUser, ...currentList];

      emit(HomeSuccess(newList));
    } catch (e) {
      emit(HomeError("Falha ao buscar novo usuário: $e"));
    }
  }

  @override
  Future<void> close() {
    stopFetchingUsers();
    return super.close();
  }
}
