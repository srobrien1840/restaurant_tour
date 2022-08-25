part of 'restaurant_bloc.dart';

enum RestaurantStatus { initial, loading, success, failure }

class RestaurantState extends Equatable {
  const RestaurantState({
    this.status = RestaurantStatus.initial,
    this.allRestaurants = const [],
    this.favorites = const [],
  });

  final RestaurantStatus status;
  final List<String> favorites;
  final List<Restaurant> allRestaurants;

  RestaurantState copyWith({
    RestaurantStatus Function()? status,
    List<String> Function()? favorites,
    List<Restaurant> Function()? allRestaurants,
  }) {
    return RestaurantState(
      status: status != null ? status() : this.status,
      allRestaurants:
          allRestaurants != null ? allRestaurants() : this.allRestaurants,
      favorites: favorites != null ? favorites() : this.favorites,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allRestaurants,
        favorites,
      ];
}
