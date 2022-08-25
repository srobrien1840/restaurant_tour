part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class GetRestaurantsRequested extends RestaurantEvent {
  const GetRestaurantsRequested();
}

class AddRestaurantToFavoritesRequested extends RestaurantEvent {
  final String restaurant;

  const AddRestaurantToFavoritesRequested(this.restaurant);

  @override
  List<Object> get props => [restaurant];
}

class RemoveRestaurantFromFavoritesRequested extends RestaurantEvent {
  final String restaurant;

  const RemoveRestaurantFromFavoritesRequested(this.restaurant);

  @override
  List<Object> get props => [restaurant];
}
