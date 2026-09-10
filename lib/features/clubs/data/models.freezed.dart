// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Branch {

 String get id; String? get name; String? get address;@JsonKey(name: 'game_center_id') String? get gameCenterId;@JsonKey(name: 'is_available') bool? get isAvailable;@JsonKey(fromJson: numFromJson) num? get latitude;@JsonKey(fromJson: numFromJson) num? get longitude; String? get description; String? get phone;@JsonKey(name: 'work_time') String? get workTime;@JsonKey(fromJson: numFromJson) num? get rating;
/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchCopyWith<Branch> get copyWith => _$BranchCopyWithImpl<Branch>(this as Branch, _$identity);

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Branch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Branch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.gameCenterId, _this.gameCenterId) || other.gameCenterId == _this.gameCenterId)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.workTime, _this.workTime) || other.workTime == _this.workTime)&&(identical(other.rating, _this.rating) || other.rating == _this.rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Branch;
  return Object.hash(runtimeType,_this.id,_this.name,_this.address,_this.gameCenterId,_this.isAvailable,_this.latitude,_this.longitude,_this.description,_this.phone,_this.workTime,_this.rating);
}

@override
String toString() {
  final _this = this as Branch;
  return 'Branch(id: ${_this.id}, name: ${_this.name}, address: ${_this.address}, gameCenterId: ${_this.gameCenterId}, isAvailable: ${_this.isAvailable}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, description: ${_this.description}, phone: ${_this.phone}, workTime: ${_this.workTime}, rating: ${_this.rating})';
}


}

/// @nodoc
abstract mixin class $BranchCopyWith<$Res>  {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) _then) = _$BranchCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? address,@JsonKey(name: 'game_center_id') String? gameCenterId,@JsonKey(name: 'is_available') bool? isAvailable,@JsonKey(fromJson: numFromJson) num? latitude,@JsonKey(fromJson: numFromJson) num? longitude, String? description, String? phone,@JsonKey(name: 'work_time') String? workTime,@JsonKey(fromJson: numFromJson) num? rating
});




}
/// @nodoc
class _$BranchCopyWithImpl<$Res>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._self, this._then);

  final Branch _self;
  final $Res Function(Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? address = freezed,Object? gameCenterId = freezed,Object? isAvailable = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? description = freezed,Object? phone = freezed,Object? workTime = freezed,Object? rating = freezed,}) {
  return _then(Branch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,gameCenterId: freezed == gameCenterId ? _self.gameCenterId : gameCenterId // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,workTime: freezed == workTime ? _self.workTime : workTime // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [Branch].
extension BranchPatterns on Branch {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Branch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Branch value)  $default,){
final _that = this;
switch (_that) {
case _Branch():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Branch value)?  $default,){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String? address, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'is_available')  bool? isAvailable, @JsonKey(fromJson: numFromJson)  num? latitude, @JsonKey(fromJson: numFromJson)  num? longitude,  String? description,  String? phone, @JsonKey(name: 'work_time')  String? workTime, @JsonKey(fromJson: numFromJson)  num? rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.gameCenterId,_that.isAvailable,_that.latitude,_that.longitude,_that.description,_that.phone,_that.workTime,_that.rating);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String? address, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'is_available')  bool? isAvailable, @JsonKey(fromJson: numFromJson)  num? latitude, @JsonKey(fromJson: numFromJson)  num? longitude,  String? description,  String? phone, @JsonKey(name: 'work_time')  String? workTime, @JsonKey(fromJson: numFromJson)  num? rating)  $default,) {final _that = this;
switch (_that) {
case _Branch():
return $default(_that.id,_that.name,_that.address,_that.gameCenterId,_that.isAvailable,_that.latitude,_that.longitude,_that.description,_that.phone,_that.workTime,_that.rating);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String? address, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'is_available')  bool? isAvailable, @JsonKey(fromJson: numFromJson)  num? latitude, @JsonKey(fromJson: numFromJson)  num? longitude,  String? description,  String? phone, @JsonKey(name: 'work_time')  String? workTime, @JsonKey(fromJson: numFromJson)  num? rating)?  $default,) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.gameCenterId,_that.isAvailable,_that.latitude,_that.longitude,_that.description,_that.phone,_that.workTime,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Branch implements Branch {
  const _Branch({required this.id, this.name, this.address, @JsonKey(name: 'game_center_id') this.gameCenterId, @JsonKey(name: 'is_available') this.isAvailable, @JsonKey(fromJson: numFromJson) this.latitude, @JsonKey(fromJson: numFromJson) this.longitude, this.description, this.phone, @JsonKey(name: 'work_time') this.workTime, @JsonKey(fromJson: numFromJson) this.rating});
  factory _Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

@override final  String id;
@override final  String? name;
@override final  String? address;
@override@JsonKey(name: 'game_center_id') final  String? gameCenterId;
@override@JsonKey(name: 'is_available') final  bool? isAvailable;
@override@JsonKey(fromJson: numFromJson) final  num? latitude;
@override@JsonKey(fromJson: numFromJson) final  num? longitude;
@override final  String? description;
@override final  String? phone;
@override@JsonKey(name: 'work_time') final  String? workTime;
@override@JsonKey(fromJson: numFromJson) final  num? rating;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchCopyWith<_Branch> get copyWith => __$BranchCopyWithImpl<_Branch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.gameCenterId, gameCenterId) || other.gameCenterId == gameCenterId)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.description, description) || other.description == description)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.workTime, workTime) || other.workTime == workTime)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,address,gameCenterId,isAvailable,latitude,longitude,description,phone,workTime,rating);
}

@override
String toString() {
    return 'Branch(id: $id, name: $name, address: $address, gameCenterId: $gameCenterId, isAvailable: $isAvailable, latitude: $latitude, longitude: $longitude, description: $description, phone: $phone, workTime: $workTime, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$BranchCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$BranchCopyWith(_Branch value, $Res Function(_Branch) _then) = __$BranchCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String? address,@JsonKey(name: 'game_center_id') String? gameCenterId,@JsonKey(name: 'is_available') bool? isAvailable,@JsonKey(fromJson: numFromJson) num? latitude,@JsonKey(fromJson: numFromJson) num? longitude, String? description, String? phone,@JsonKey(name: 'work_time') String? workTime,@JsonKey(fromJson: numFromJson) num? rating
});




}
/// @nodoc
class __$BranchCopyWithImpl<$Res>
    implements _$BranchCopyWith<$Res> {
  __$BranchCopyWithImpl(this._self, this._then);

  final _Branch _self;
  final $Res Function(_Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? address = freezed,Object? gameCenterId = freezed,Object? isAvailable = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? description = freezed,Object? phone = freezed,Object? workTime = freezed,Object? rating = freezed,}) {
  return _then(_Branch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,gameCenterId: freezed == gameCenterId ? _self.gameCenterId : gameCenterId // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,workTime: freezed == workTime ? _self.workTime : workTime // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$GameCenter {

 String get id; String? get name; String? get logo; String? get slug; String? get address; String? get description;@JsonKey(fromJson: numFromJson) num? get latitude;@JsonKey(fromJson: numFromJson) num? get longitude;@JsonKey(name: 'is_available') bool? get isAvailable;
/// Create a copy of GameCenter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameCenterCopyWith<GameCenter> get copyWith => _$GameCenterCopyWithImpl<GameCenter>(this as GameCenter, _$identity);

  /// Serializes this GameCenter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GameCenter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameCenter&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.logo, _this.logo) || other.logo == _this.logo)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GameCenter;
  return Object.hash(runtimeType,_this.id,_this.name,_this.logo,_this.slug,_this.address,_this.description,_this.latitude,_this.longitude,_this.isAvailable);
}

@override
String toString() {
  final _this = this as GameCenter;
  return 'GameCenter(id: ${_this.id}, name: ${_this.name}, logo: ${_this.logo}, slug: ${_this.slug}, address: ${_this.address}, description: ${_this.description}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, isAvailable: ${_this.isAvailable})';
}


}

/// @nodoc
abstract mixin class $GameCenterCopyWith<$Res>  {
  factory $GameCenterCopyWith(GameCenter value, $Res Function(GameCenter) _then) = _$GameCenterCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? logo, String? slug, String? address, String? description,@JsonKey(fromJson: numFromJson) num? latitude,@JsonKey(fromJson: numFromJson) num? longitude,@JsonKey(name: 'is_available') bool? isAvailable
});




}
/// @nodoc
class _$GameCenterCopyWithImpl<$Res>
    implements $GameCenterCopyWith<$Res> {
  _$GameCenterCopyWithImpl(this._self, this._then);

  final GameCenter _self;
  final $Res Function(GameCenter) _then;

/// Create a copy of GameCenter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? logo = freezed,Object? slug = freezed,Object? address = freezed,Object? description = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isAvailable = freezed,}) {
  return _then(GameCenter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameCenter].
extension GameCenterPatterns on GameCenter {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameCenter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameCenter() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameCenter value)  $default,){
final _that = this;
switch (_that) {
case _GameCenter():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameCenter value)?  $default,){
final _that = this;
switch (_that) {
case _GameCenter() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String? logo,  String? slug,  String? address,  String? description, @JsonKey(fromJson: numFromJson)  num? latitude, @JsonKey(fromJson: numFromJson)  num? longitude, @JsonKey(name: 'is_available')  bool? isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameCenter() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.slug,_that.address,_that.description,_that.latitude,_that.longitude,_that.isAvailable);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String? logo,  String? slug,  String? address,  String? description, @JsonKey(fromJson: numFromJson)  num? latitude, @JsonKey(fromJson: numFromJson)  num? longitude, @JsonKey(name: 'is_available')  bool? isAvailable)  $default,) {final _that = this;
switch (_that) {
case _GameCenter():
return $default(_that.id,_that.name,_that.logo,_that.slug,_that.address,_that.description,_that.latitude,_that.longitude,_that.isAvailable);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String? logo,  String? slug,  String? address,  String? description, @JsonKey(fromJson: numFromJson)  num? latitude, @JsonKey(fromJson: numFromJson)  num? longitude, @JsonKey(name: 'is_available')  bool? isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _GameCenter() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.slug,_that.address,_that.description,_that.latitude,_that.longitude,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameCenter implements GameCenter {
  const _GameCenter({required this.id, this.name, this.logo, this.slug, this.address, this.description, @JsonKey(fromJson: numFromJson) this.latitude, @JsonKey(fromJson: numFromJson) this.longitude, @JsonKey(name: 'is_available') this.isAvailable});
  factory _GameCenter.fromJson(Map<String, dynamic> json) => _$GameCenterFromJson(json);

@override final  String id;
@override final  String? name;
@override final  String? logo;
@override final  String? slug;
@override final  String? address;
@override final  String? description;
@override@JsonKey(fromJson: numFromJson) final  num? latitude;
@override@JsonKey(fromJson: numFromJson) final  num? longitude;
@override@JsonKey(name: 'is_available') final  bool? isAvailable;

/// Create a copy of GameCenter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameCenterCopyWith<_GameCenter> get copyWith => __$GameCenterCopyWithImpl<_GameCenter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameCenterToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameCenter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.address, address) || other.address == address)&&(identical(other.description, description) || other.description == description)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,logo,slug,address,description,latitude,longitude,isAvailable);
}

@override
String toString() {
    return 'GameCenter(id: $id, name: $name, logo: $logo, slug: $slug, address: $address, description: $description, latitude: $latitude, longitude: $longitude, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$GameCenterCopyWith<$Res> implements $GameCenterCopyWith<$Res> {
  factory _$GameCenterCopyWith(_GameCenter value, $Res Function(_GameCenter) _then) = __$GameCenterCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String? logo, String? slug, String? address, String? description,@JsonKey(fromJson: numFromJson) num? latitude,@JsonKey(fromJson: numFromJson) num? longitude,@JsonKey(name: 'is_available') bool? isAvailable
});




}
/// @nodoc
class __$GameCenterCopyWithImpl<$Res>
    implements _$GameCenterCopyWith<$Res> {
  __$GameCenterCopyWithImpl(this._self, this._then);

  final _GameCenter _self;
  final $Res Function(_GameCenter) _then;

/// Create a copy of GameCenter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? logo = freezed,Object? slug = freezed,Object? address = freezed,Object? description = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isAvailable = freezed,}) {
  return _then(_GameCenter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Reservation {

 String get id;@JsonKey(name: 'date_time') String? get dateTime;@JsonKey(name: 'is_active') bool? get isActive;@JsonKey(name: 'computer_id') String? get computerId;@JsonKey(name: 'user_tariff_id') String? get userTariffId;@JsonKey(name: 'game_center_id') String? get gameCenterId;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(name: 'game_center') Object? get gameCenter; Object? get computer; Object? get tariff;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationCopyWith<Reservation> get copyWith => _$ReservationCopyWithImpl<Reservation>(this as Reservation, _$identity);

  /// Serializes this Reservation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Reservation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reservation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.dateTime, _this.dateTime) || other.dateTime == _this.dateTime)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.computerId, _this.computerId) || other.computerId == _this.computerId)&&(identical(other.userTariffId, _this.userTariffId) || other.userTariffId == _this.userTariffId)&&(identical(other.gameCenterId, _this.gameCenterId) || other.gameCenterId == _this.gameCenterId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&const DeepCollectionEquality().equals(other.gameCenter, _this.gameCenter)&&const DeepCollectionEquality().equals(other.computer, _this.computer)&&const DeepCollectionEquality().equals(other.tariff, _this.tariff)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Reservation;
  return Object.hash(runtimeType,_this.id,_this.dateTime,_this.isActive,_this.computerId,_this.userTariffId,_this.gameCenterId,_this.branchId,const DeepCollectionEquality().hash(_this.gameCenter),const DeepCollectionEquality().hash(_this.computer),const DeepCollectionEquality().hash(_this.tariff),_this.createdAt);
}

@override
String toString() {
  final _this = this as Reservation;
  return 'Reservation(id: ${_this.id}, dateTime: ${_this.dateTime}, isActive: ${_this.isActive}, computerId: ${_this.computerId}, userTariffId: ${_this.userTariffId}, gameCenterId: ${_this.gameCenterId}, branchId: ${_this.branchId}, gameCenter: ${_this.gameCenter}, computer: ${_this.computer}, tariff: ${_this.tariff}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ReservationCopyWith<$Res>  {
  factory $ReservationCopyWith(Reservation value, $Res Function(Reservation) _then) = _$ReservationCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'date_time') String? dateTime,@JsonKey(name: 'is_active') bool? isActive,@JsonKey(name: 'computer_id') String? computerId,@JsonKey(name: 'user_tariff_id') String? userTariffId,@JsonKey(name: 'game_center_id') String? gameCenterId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'game_center') Object? gameCenter, Object? computer, Object? tariff,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$ReservationCopyWithImpl<$Res>
    implements $ReservationCopyWith<$Res> {
  _$ReservationCopyWithImpl(this._self, this._then);

  final Reservation _self;
  final $Res Function(Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dateTime = freezed,Object? isActive = freezed,Object? computerId = freezed,Object? userTariffId = freezed,Object? gameCenterId = freezed,Object? branchId = freezed,Object? gameCenter = freezed,Object? computer = freezed,Object? tariff = freezed,Object? createdAt = freezed,}) {
  return _then(Reservation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dateTime: freezed == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,computerId: freezed == computerId ? _self.computerId : computerId // ignore: cast_nullable_to_non_nullable
as String?,userTariffId: freezed == userTariffId ? _self.userTariffId : userTariffId // ignore: cast_nullable_to_non_nullable
as String?,gameCenterId: freezed == gameCenterId ? _self.gameCenterId : gameCenterId // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,gameCenter: freezed == gameCenter ? _self.gameCenter : gameCenter ,computer: freezed == computer ? _self.computer : computer ,tariff: freezed == tariff ? _self.tariff : tariff ,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Reservation].
extension ReservationPatterns on Reservation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reservation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reservation value)  $default,){
final _that = this;
switch (_that) {
case _Reservation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reservation value)?  $default,){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'date_time')  String? dateTime, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'computer_id')  String? computerId, @JsonKey(name: 'user_tariff_id')  String? userTariffId, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'game_center')  Object? gameCenter,  Object? computer,  Object? tariff, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.dateTime,_that.isActive,_that.computerId,_that.userTariffId,_that.gameCenterId,_that.branchId,_that.gameCenter,_that.computer,_that.tariff,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'date_time')  String? dateTime, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'computer_id')  String? computerId, @JsonKey(name: 'user_tariff_id')  String? userTariffId, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'game_center')  Object? gameCenter,  Object? computer,  Object? tariff, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Reservation():
return $default(_that.id,_that.dateTime,_that.isActive,_that.computerId,_that.userTariffId,_that.gameCenterId,_that.branchId,_that.gameCenter,_that.computer,_that.tariff,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'date_time')  String? dateTime, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'computer_id')  String? computerId, @JsonKey(name: 'user_tariff_id')  String? userTariffId, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'game_center')  Object? gameCenter,  Object? computer,  Object? tariff, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.dateTime,_that.isActive,_that.computerId,_that.userTariffId,_that.gameCenterId,_that.branchId,_that.gameCenter,_that.computer,_that.tariff,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reservation implements Reservation {
  const _Reservation({required this.id, @JsonKey(name: 'date_time') this.dateTime, @JsonKey(name: 'is_active') this.isActive, @JsonKey(name: 'computer_id') this.computerId, @JsonKey(name: 'user_tariff_id') this.userTariffId, @JsonKey(name: 'game_center_id') this.gameCenterId, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(name: 'game_center') this.gameCenter, this.computer, this.tariff, @JsonKey(name: 'created_at') this.createdAt});
  factory _Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

@override final  String id;
@override@JsonKey(name: 'date_time') final  String? dateTime;
@override@JsonKey(name: 'is_active') final  bool? isActive;
@override@JsonKey(name: 'computer_id') final  String? computerId;
@override@JsonKey(name: 'user_tariff_id') final  String? userTariffId;
@override@JsonKey(name: 'game_center_id') final  String? gameCenterId;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(name: 'game_center') final  Object? gameCenter;
@override final  Object? computer;
@override final  Object? tariff;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationCopyWith<_Reservation> get copyWith => __$ReservationCopyWithImpl<_Reservation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reservation&&(identical(other.id, id) || other.id == id)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.computerId, computerId) || other.computerId == computerId)&&(identical(other.userTariffId, userTariffId) || other.userTariffId == userTariffId)&&(identical(other.gameCenterId, gameCenterId) || other.gameCenterId == gameCenterId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&const DeepCollectionEquality().equals(other.gameCenter, gameCenter)&&const DeepCollectionEquality().equals(other.computer, computer)&&const DeepCollectionEquality().equals(other.tariff, tariff)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,dateTime,isActive,computerId,userTariffId,gameCenterId,branchId,const DeepCollectionEquality().hash(gameCenter),const DeepCollectionEquality().hash(computer),const DeepCollectionEquality().hash(tariff),createdAt);
}

@override
String toString() {
    return 'Reservation(id: $id, dateTime: $dateTime, isActive: $isActive, computerId: $computerId, userTariffId: $userTariffId, gameCenterId: $gameCenterId, branchId: $branchId, gameCenter: $gameCenter, computer: $computer, tariff: $tariff, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReservationCopyWith<$Res> implements $ReservationCopyWith<$Res> {
  factory _$ReservationCopyWith(_Reservation value, $Res Function(_Reservation) _then) = __$ReservationCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'date_time') String? dateTime,@JsonKey(name: 'is_active') bool? isActive,@JsonKey(name: 'computer_id') String? computerId,@JsonKey(name: 'user_tariff_id') String? userTariffId,@JsonKey(name: 'game_center_id') String? gameCenterId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'game_center') Object? gameCenter, Object? computer, Object? tariff,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$ReservationCopyWithImpl<$Res>
    implements _$ReservationCopyWith<$Res> {
  __$ReservationCopyWithImpl(this._self, this._then);

  final _Reservation _self;
  final $Res Function(_Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dateTime = freezed,Object? isActive = freezed,Object? computerId = freezed,Object? userTariffId = freezed,Object? gameCenterId = freezed,Object? branchId = freezed,Object? gameCenter = freezed,Object? computer = freezed,Object? tariff = freezed,Object? createdAt = freezed,}) {
  return _then(_Reservation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dateTime: freezed == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,computerId: freezed == computerId ? _self.computerId : computerId // ignore: cast_nullable_to_non_nullable
as String?,userTariffId: freezed == userTariffId ? _self.userTariffId : userTariffId // ignore: cast_nullable_to_non_nullable
as String?,gameCenterId: freezed == gameCenterId ? _self.gameCenterId : gameCenterId // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,gameCenter: freezed == gameCenter ? _self.gameCenter : gameCenter ,computer: freezed == computer ? _self.computer : computer ,tariff: freezed == tariff ? _self.tariff : tariff ,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
