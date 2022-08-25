import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurantour/models/restaurant.dart';
import 'package:restaurantour/repositories/yelp_repository.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends HydratedBloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc({required this.yelpRepository})
      : super(const RestaurantState()) {
    on<GetRestaurantsRequested>(_onRandomCoffeeRequested);
    on<AddRestaurantToFavoritesRequested>(_onAddFavoriteRequested);
    on<RemoveRestaurantFromFavoritesRequested>(_onRemoveFavoriteRequested);
  }
  final YelpRepository yelpRepository;

  Future<void> _onRandomCoffeeRequested(
      GetRestaurantsRequested event, Emitter<RestaurantState> emit) async {
    emit(state.copyWith(status: () => RestaurantStatus.loading));
    try {
      RestaurantQueryResult? restaurantQueryResult =
          await yelpRepository.getRestaurants();
      List<Restaurant> restaurants = restaurantQueryResult?.restaurants ?? [];
      emit(
        state.copyWith(
          status: () => RestaurantStatus.success,
          allRestaurants: () => restaurants,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: (() => RestaurantStatus.failure)));
    }
  }

  Future<void> _onAddFavoriteRequested(
    AddRestaurantToFavoritesRequested event,
    Emitter<RestaurantState> emit,
  ) async {
    List<String> favorites = [];
    favorites.addAll([...state.favorites, event.restaurant]);
    emit(
      state.copyWith(
        favorites: () => favorites,
      ),
    );
  }

  Future<void> _onRemoveFavoriteRequested(
    RemoveRestaurantFromFavoritesRequested event,
    Emitter<RestaurantState> emit,
  ) async {
    List<String> favorites = [];
    favorites.addAll(state.favorites);
    favorites.remove(event.restaurant);
    emit(
      state.copyWith(
        favorites: (() => favorites),
      ),
    );
  }

  @override
  RestaurantState? fromJson(Map<String, dynamic> json) {
    RestaurantStatus status = RestaurantStatus.values.byName(json['status']);
    List<Restaurant> restaurants = (json['restaurants'] ?? [])
        .map<Restaurant>((e) => Restaurant.fromJson(e))
        .toList();
    List<String> favorites =
        (json['favorites'] ?? []).map<String>((e) => e as String).toList();

    return RestaurantState(
        status: status, allRestaurants: restaurants, favorites: favorites);
  }

  @override
  Map<String, dynamic>? toJson(RestaurantState state) {
    return <String, dynamic>{
      'status': state.status.name,
      'restaurants': state.allRestaurants
          .map((restaurant) => restaurant.toJson())
          .toList(),
      'favorites': jsonEncode(state.favorites),
    };
  }
}
