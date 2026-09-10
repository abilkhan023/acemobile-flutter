// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Zone {

 String get id; String? get name;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(fromJson: numFromJson) num? get x;@JsonKey(fromJson: numFromJson) num? get y;@JsonKey(name: 'x_len', fromJson: numFromJson) num? get xLen;@JsonKey(name: 'y_len', fromJson: numFromJson) num? get yLen;
/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneCopyWith<Zone> get copyWith => _$ZoneCopyWithImpl<Zone>(this as Zone, _$identity);

  /// Serializes this Zone to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Zone;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Zone&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y)&&(identical(other.xLen, _this.xLen) || other.xLen == _this.xLen)&&(identical(other.yLen, _this.yLen) || other.yLen == _this.yLen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Zone;
  return Object.hash(runtimeType,_this.id,_this.name,_this.branchId,_this.x,_this.y,_this.xLen,_this.yLen);
}

@override
String toString() {
  final _this = this as Zone;
  return 'Zone(id: ${_this.id}, name: ${_this.name}, branchId: ${_this.branchId}, x: ${_this.x}, y: ${_this.y}, xLen: ${_this.xLen}, yLen: ${_this.yLen})';
}


}

/// @nodoc
abstract mixin class $ZoneCopyWith<$Res>  {
  factory $ZoneCopyWith(Zone value, $Res Function(Zone) _then) = _$ZoneCopyWithImpl;
@useResult
$Res call({
 String id, String? name,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(fromJson: numFromJson) num? x,@JsonKey(fromJson: numFromJson) num? y,@JsonKey(name: 'x_len', fromJson: numFromJson) num? xLen,@JsonKey(name: 'y_len', fromJson: numFromJson) num? yLen
});




}
/// @nodoc
class _$ZoneCopyWithImpl<$Res>
    implements $ZoneCopyWith<$Res> {
  _$ZoneCopyWithImpl(this._self, this._then);

  final Zone _self;
  final $Res Function(Zone) _then;

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? branchId = freezed,Object? x = freezed,Object? y = freezed,Object? xLen = freezed,Object? yLen = freezed,}) {
  return _then(Zone(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,x: freezed == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as num?,y: freezed == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as num?,xLen: freezed == xLen ? _self.xLen : xLen // ignore: cast_nullable_to_non_nullable
as num?,yLen: freezed == yLen ? _self.yLen : yLen // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [Zone].
extension ZonePatterns on Zone {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Zone value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Zone() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Zone value)  $default,){
final _that = this;
switch (_that) {
case _Zone():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Zone value)?  $default,){
final _that = this;
switch (_that) {
case _Zone() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(fromJson: numFromJson)  num? x, @JsonKey(fromJson: numFromJson)  num? y, @JsonKey(name: 'x_len', fromJson: numFromJson)  num? xLen, @JsonKey(name: 'y_len', fromJson: numFromJson)  num? yLen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Zone() when $default != null:
return $default(_that.id,_that.name,_that.branchId,_that.x,_that.y,_that.xLen,_that.yLen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(fromJson: numFromJson)  num? x, @JsonKey(fromJson: numFromJson)  num? y, @JsonKey(name: 'x_len', fromJson: numFromJson)  num? xLen, @JsonKey(name: 'y_len', fromJson: numFromJson)  num? yLen)  $default,) {final _that = this;
switch (_that) {
case _Zone():
return $default(_that.id,_that.name,_that.branchId,_that.x,_that.y,_that.xLen,_that.yLen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(fromJson: numFromJson)  num? x, @JsonKey(fromJson: numFromJson)  num? y, @JsonKey(name: 'x_len', fromJson: numFromJson)  num? xLen, @JsonKey(name: 'y_len', fromJson: numFromJson)  num? yLen)?  $default,) {final _that = this;
switch (_that) {
case _Zone() when $default != null:
return $default(_that.id,_that.name,_that.branchId,_that.x,_that.y,_that.xLen,_that.yLen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Zone implements Zone {
  const _Zone({required this.id, this.name, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(fromJson: numFromJson) this.x, @JsonKey(fromJson: numFromJson) this.y, @JsonKey(name: 'x_len', fromJson: numFromJson) this.xLen, @JsonKey(name: 'y_len', fromJson: numFromJson) this.yLen});
  factory _Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);

@override final  String id;
@override final  String? name;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(fromJson: numFromJson) final  num? x;
@override@JsonKey(fromJson: numFromJson) final  num? y;
@override@JsonKey(name: 'x_len', fromJson: numFromJson) final  num? xLen;
@override@JsonKey(name: 'y_len', fromJson: numFromJson) final  num? yLen;

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZoneCopyWith<_Zone> get copyWith => __$ZoneCopyWithImpl<_Zone>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZoneToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Zone&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.xLen, xLen) || other.xLen == xLen)&&(identical(other.yLen, yLen) || other.yLen == yLen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,branchId,x,y,xLen,yLen);
}

@override
String toString() {
    return 'Zone(id: $id, name: $name, branchId: $branchId, x: $x, y: $y, xLen: $xLen, yLen: $yLen)';
}


}

/// @nodoc
abstract mixin class _$ZoneCopyWith<$Res> implements $ZoneCopyWith<$Res> {
  factory _$ZoneCopyWith(_Zone value, $Res Function(_Zone) _then) = __$ZoneCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(fromJson: numFromJson) num? x,@JsonKey(fromJson: numFromJson) num? y,@JsonKey(name: 'x_len', fromJson: numFromJson) num? xLen,@JsonKey(name: 'y_len', fromJson: numFromJson) num? yLen
});




}
/// @nodoc
class __$ZoneCopyWithImpl<$Res>
    implements _$ZoneCopyWith<$Res> {
  __$ZoneCopyWithImpl(this._self, this._then);

  final _Zone _self;
  final $Res Function(_Zone) _then;

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? branchId = freezed,Object? x = freezed,Object? y = freezed,Object? xLen = freezed,Object? yLen = freezed,}) {
  return _then(_Zone(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,x: freezed == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as num?,y: freezed == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as num?,xLen: freezed == xLen ? _self.xLen : xLen // ignore: cast_nullable_to_non_nullable
as num?,yLen: freezed == yLen ? _self.yLen : yLen // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$Computer {

 String get id; String? get name; String? get state;@JsonKey(fromJson: numFromJson) num? get x;@JsonKey(fromJson: numFromJson) num? get y;@JsonKey(name: 'zone_id') String? get zoneId;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(name: 'mac_address') String? get macAddress;
/// Create a copy of Computer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComputerCopyWith<Computer> get copyWith => _$ComputerCopyWithImpl<Computer>(this as Computer, _$identity);

  /// Serializes this Computer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Computer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Computer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y)&&(identical(other.zoneId, _this.zoneId) || other.zoneId == _this.zoneId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.macAddress, _this.macAddress) || other.macAddress == _this.macAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Computer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.state,_this.x,_this.y,_this.zoneId,_this.branchId,_this.macAddress);
}

@override
String toString() {
  final _this = this as Computer;
  return 'Computer(id: ${_this.id}, name: ${_this.name}, state: ${_this.state}, x: ${_this.x}, y: ${_this.y}, zoneId: ${_this.zoneId}, branchId: ${_this.branchId}, macAddress: ${_this.macAddress})';
}


}

/// @nodoc
abstract mixin class $ComputerCopyWith<$Res>  {
  factory $ComputerCopyWith(Computer value, $Res Function(Computer) _then) = _$ComputerCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? state,@JsonKey(fromJson: numFromJson) num? x,@JsonKey(fromJson: numFromJson) num? y,@JsonKey(name: 'zone_id') String? zoneId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'mac_address') String? macAddress
});




}
/// @nodoc
class _$ComputerCopyWithImpl<$Res>
    implements $ComputerCopyWith<$Res> {
  _$ComputerCopyWithImpl(this._self, this._then);

  final Computer _self;
  final $Res Function(Computer) _then;

/// Create a copy of Computer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? state = freezed,Object? x = freezed,Object? y = freezed,Object? zoneId = freezed,Object? branchId = freezed,Object? macAddress = freezed,}) {
  return _then(Computer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,x: freezed == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as num?,y: freezed == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as num?,zoneId: freezed == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,macAddress: freezed == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Computer].
extension ComputerPatterns on Computer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Computer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Computer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Computer value)  $default,){
final _that = this;
switch (_that) {
case _Computer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Computer value)?  $default,){
final _that = this;
switch (_that) {
case _Computer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String? state, @JsonKey(fromJson: numFromJson)  num? x, @JsonKey(fromJson: numFromJson)  num? y, @JsonKey(name: 'zone_id')  String? zoneId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'mac_address')  String? macAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Computer() when $default != null:
return $default(_that.id,_that.name,_that.state,_that.x,_that.y,_that.zoneId,_that.branchId,_that.macAddress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String? state, @JsonKey(fromJson: numFromJson)  num? x, @JsonKey(fromJson: numFromJson)  num? y, @JsonKey(name: 'zone_id')  String? zoneId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'mac_address')  String? macAddress)  $default,) {final _that = this;
switch (_that) {
case _Computer():
return $default(_that.id,_that.name,_that.state,_that.x,_that.y,_that.zoneId,_that.branchId,_that.macAddress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String? state, @JsonKey(fromJson: numFromJson)  num? x, @JsonKey(fromJson: numFromJson)  num? y, @JsonKey(name: 'zone_id')  String? zoneId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'mac_address')  String? macAddress)?  $default,) {final _that = this;
switch (_that) {
case _Computer() when $default != null:
return $default(_that.id,_that.name,_that.state,_that.x,_that.y,_that.zoneId,_that.branchId,_that.macAddress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Computer implements Computer {
  const _Computer({required this.id, this.name, this.state, @JsonKey(fromJson: numFromJson) this.x, @JsonKey(fromJson: numFromJson) this.y, @JsonKey(name: 'zone_id') this.zoneId, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(name: 'mac_address') this.macAddress});
  factory _Computer.fromJson(Map<String, dynamic> json) => _$ComputerFromJson(json);

@override final  String id;
@override final  String? name;
@override final  String? state;
@override@JsonKey(fromJson: numFromJson) final  num? x;
@override@JsonKey(fromJson: numFromJson) final  num? y;
@override@JsonKey(name: 'zone_id') final  String? zoneId;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(name: 'mac_address') final  String? macAddress;

/// Create a copy of Computer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComputerCopyWith<_Computer> get copyWith => __$ComputerCopyWithImpl<_Computer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComputerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Computer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.state, state) || other.state == state)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,state,x,y,zoneId,branchId,macAddress);
}

@override
String toString() {
    return 'Computer(id: $id, name: $name, state: $state, x: $x, y: $y, zoneId: $zoneId, branchId: $branchId, macAddress: $macAddress)';
}


}

/// @nodoc
abstract mixin class _$ComputerCopyWith<$Res> implements $ComputerCopyWith<$Res> {
  factory _$ComputerCopyWith(_Computer value, $Res Function(_Computer) _then) = __$ComputerCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String? state,@JsonKey(fromJson: numFromJson) num? x,@JsonKey(fromJson: numFromJson) num? y,@JsonKey(name: 'zone_id') String? zoneId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'mac_address') String? macAddress
});




}
/// @nodoc
class __$ComputerCopyWithImpl<$Res>
    implements _$ComputerCopyWith<$Res> {
  __$ComputerCopyWithImpl(this._self, this._then);

  final _Computer _self;
  final $Res Function(_Computer) _then;

/// Create a copy of Computer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? state = freezed,Object? x = freezed,Object? y = freezed,Object? zoneId = freezed,Object? branchId = freezed,Object? macAddress = freezed,}) {
  return _then(_Computer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,x: freezed == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as num?,y: freezed == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as num?,zoneId: freezed == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,macAddress: freezed == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TariffAvailability {

@JsonKey(name: 'weekday_from', fromJson: numFromJson) num? get weekdayFrom;@JsonKey(name: 'weekday_to', fromJson: numFromJson) num? get weekdayTo;@JsonKey(name: 'available_from') String? get availableFrom;@JsonKey(name: 'available_to') String? get availableTo;
/// Create a copy of TariffAvailability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TariffAvailabilityCopyWith<TariffAvailability> get copyWith => _$TariffAvailabilityCopyWithImpl<TariffAvailability>(this as TariffAvailability, _$identity);

  /// Serializes this TariffAvailability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TariffAvailability;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TariffAvailability&&(identical(other.weekdayFrom, _this.weekdayFrom) || other.weekdayFrom == _this.weekdayFrom)&&(identical(other.weekdayTo, _this.weekdayTo) || other.weekdayTo == _this.weekdayTo)&&(identical(other.availableFrom, _this.availableFrom) || other.availableFrom == _this.availableFrom)&&(identical(other.availableTo, _this.availableTo) || other.availableTo == _this.availableTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TariffAvailability;
  return Object.hash(runtimeType,_this.weekdayFrom,_this.weekdayTo,_this.availableFrom,_this.availableTo);
}

@override
String toString() {
  final _this = this as TariffAvailability;
  return 'TariffAvailability(weekdayFrom: ${_this.weekdayFrom}, weekdayTo: ${_this.weekdayTo}, availableFrom: ${_this.availableFrom}, availableTo: ${_this.availableTo})';
}


}

/// @nodoc
abstract mixin class $TariffAvailabilityCopyWith<$Res>  {
  factory $TariffAvailabilityCopyWith(TariffAvailability value, $Res Function(TariffAvailability) _then) = _$TariffAvailabilityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'weekday_from', fromJson: numFromJson) num? weekdayFrom,@JsonKey(name: 'weekday_to', fromJson: numFromJson) num? weekdayTo,@JsonKey(name: 'available_from') String? availableFrom,@JsonKey(name: 'available_to') String? availableTo
});




}
/// @nodoc
class _$TariffAvailabilityCopyWithImpl<$Res>
    implements $TariffAvailabilityCopyWith<$Res> {
  _$TariffAvailabilityCopyWithImpl(this._self, this._then);

  final TariffAvailability _self;
  final $Res Function(TariffAvailability) _then;

/// Create a copy of TariffAvailability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekdayFrom = freezed,Object? weekdayTo = freezed,Object? availableFrom = freezed,Object? availableTo = freezed,}) {
  return _then(TariffAvailability(
weekdayFrom: freezed == weekdayFrom ? _self.weekdayFrom : weekdayFrom // ignore: cast_nullable_to_non_nullable
as num?,weekdayTo: freezed == weekdayTo ? _self.weekdayTo : weekdayTo // ignore: cast_nullable_to_non_nullable
as num?,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as String?,availableTo: freezed == availableTo ? _self.availableTo : availableTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TariffAvailability].
extension TariffAvailabilityPatterns on TariffAvailability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TariffAvailability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TariffAvailability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TariffAvailability value)  $default,){
final _that = this;
switch (_that) {
case _TariffAvailability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TariffAvailability value)?  $default,){
final _that = this;
switch (_that) {
case _TariffAvailability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'weekday_from', fromJson: numFromJson)  num? weekdayFrom, @JsonKey(name: 'weekday_to', fromJson: numFromJson)  num? weekdayTo, @JsonKey(name: 'available_from')  String? availableFrom, @JsonKey(name: 'available_to')  String? availableTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TariffAvailability() when $default != null:
return $default(_that.weekdayFrom,_that.weekdayTo,_that.availableFrom,_that.availableTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'weekday_from', fromJson: numFromJson)  num? weekdayFrom, @JsonKey(name: 'weekday_to', fromJson: numFromJson)  num? weekdayTo, @JsonKey(name: 'available_from')  String? availableFrom, @JsonKey(name: 'available_to')  String? availableTo)  $default,) {final _that = this;
switch (_that) {
case _TariffAvailability():
return $default(_that.weekdayFrom,_that.weekdayTo,_that.availableFrom,_that.availableTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'weekday_from', fromJson: numFromJson)  num? weekdayFrom, @JsonKey(name: 'weekday_to', fromJson: numFromJson)  num? weekdayTo, @JsonKey(name: 'available_from')  String? availableFrom, @JsonKey(name: 'available_to')  String? availableTo)?  $default,) {final _that = this;
switch (_that) {
case _TariffAvailability() when $default != null:
return $default(_that.weekdayFrom,_that.weekdayTo,_that.availableFrom,_that.availableTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TariffAvailability implements TariffAvailability {
  const _TariffAvailability({@JsonKey(name: 'weekday_from', fromJson: numFromJson) this.weekdayFrom, @JsonKey(name: 'weekday_to', fromJson: numFromJson) this.weekdayTo, @JsonKey(name: 'available_from') this.availableFrom, @JsonKey(name: 'available_to') this.availableTo});
  factory _TariffAvailability.fromJson(Map<String, dynamic> json) => _$TariffAvailabilityFromJson(json);

@override@JsonKey(name: 'weekday_from', fromJson: numFromJson) final  num? weekdayFrom;
@override@JsonKey(name: 'weekday_to', fromJson: numFromJson) final  num? weekdayTo;
@override@JsonKey(name: 'available_from') final  String? availableFrom;
@override@JsonKey(name: 'available_to') final  String? availableTo;

/// Create a copy of TariffAvailability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TariffAvailabilityCopyWith<_TariffAvailability> get copyWith => __$TariffAvailabilityCopyWithImpl<_TariffAvailability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TariffAvailabilityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TariffAvailability&&(identical(other.weekdayFrom, weekdayFrom) || other.weekdayFrom == weekdayFrom)&&(identical(other.weekdayTo, weekdayTo) || other.weekdayTo == weekdayTo)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.availableTo, availableTo) || other.availableTo == availableTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weekdayFrom,weekdayTo,availableFrom,availableTo);
}

@override
String toString() {
    return 'TariffAvailability(weekdayFrom: $weekdayFrom, weekdayTo: $weekdayTo, availableFrom: $availableFrom, availableTo: $availableTo)';
}


}

/// @nodoc
abstract mixin class _$TariffAvailabilityCopyWith<$Res> implements $TariffAvailabilityCopyWith<$Res> {
  factory _$TariffAvailabilityCopyWith(_TariffAvailability value, $Res Function(_TariffAvailability) _then) = __$TariffAvailabilityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'weekday_from', fromJson: numFromJson) num? weekdayFrom,@JsonKey(name: 'weekday_to', fromJson: numFromJson) num? weekdayTo,@JsonKey(name: 'available_from') String? availableFrom,@JsonKey(name: 'available_to') String? availableTo
});




}
/// @nodoc
class __$TariffAvailabilityCopyWithImpl<$Res>
    implements _$TariffAvailabilityCopyWith<$Res> {
  __$TariffAvailabilityCopyWithImpl(this._self, this._then);

  final _TariffAvailability _self;
  final $Res Function(_TariffAvailability) _then;

/// Create a copy of TariffAvailability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekdayFrom = freezed,Object? weekdayTo = freezed,Object? availableFrom = freezed,Object? availableTo = freezed,}) {
  return _then(_TariffAvailability(
weekdayFrom: freezed == weekdayFrom ? _self.weekdayFrom : weekdayFrom // ignore: cast_nullable_to_non_nullable
as num?,weekdayTo: freezed == weekdayTo ? _self.weekdayTo : weekdayTo // ignore: cast_nullable_to_non_nullable
as num?,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as String?,availableTo: freezed == availableTo ? _self.availableTo : availableTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TariffAvailabilities {

@JsonKey(name: 'to_buy') List<TariffAvailability> get toBuy;@JsonKey(name: 'to_use') List<TariffAvailability> get toUse;
/// Create a copy of TariffAvailabilities
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TariffAvailabilitiesCopyWith<TariffAvailabilities> get copyWith => _$TariffAvailabilitiesCopyWithImpl<TariffAvailabilities>(this as TariffAvailabilities, _$identity);

  /// Serializes this TariffAvailabilities to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TariffAvailabilities;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TariffAvailabilities&&const DeepCollectionEquality().equals(other.toBuy, _this.toBuy)&&const DeepCollectionEquality().equals(other.toUse, _this.toUse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TariffAvailabilities;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.toBuy),const DeepCollectionEquality().hash(_this.toUse));
}

@override
String toString() {
  final _this = this as TariffAvailabilities;
  return 'TariffAvailabilities(toBuy: ${_this.toBuy}, toUse: ${_this.toUse})';
}


}

/// @nodoc
abstract mixin class $TariffAvailabilitiesCopyWith<$Res>  {
  factory $TariffAvailabilitiesCopyWith(TariffAvailabilities value, $Res Function(TariffAvailabilities) _then) = _$TariffAvailabilitiesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'to_buy') List<TariffAvailability> toBuy,@JsonKey(name: 'to_use') List<TariffAvailability> toUse
});




}
/// @nodoc
class _$TariffAvailabilitiesCopyWithImpl<$Res>
    implements $TariffAvailabilitiesCopyWith<$Res> {
  _$TariffAvailabilitiesCopyWithImpl(this._self, this._then);

  final TariffAvailabilities _self;
  final $Res Function(TariffAvailabilities) _then;

/// Create a copy of TariffAvailabilities
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toBuy = null,Object? toUse = null,}) {
  return _then(TariffAvailabilities(
toBuy: null == toBuy ? _self.toBuy : toBuy // ignore: cast_nullable_to_non_nullable
as List<TariffAvailability>,toUse: null == toUse ? _self.toUse : toUse // ignore: cast_nullable_to_non_nullable
as List<TariffAvailability>,
  ));
}

}


/// Adds pattern-matching-related methods to [TariffAvailabilities].
extension TariffAvailabilitiesPatterns on TariffAvailabilities {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TariffAvailabilities value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TariffAvailabilities() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TariffAvailabilities value)  $default,){
final _that = this;
switch (_that) {
case _TariffAvailabilities():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TariffAvailabilities value)?  $default,){
final _that = this;
switch (_that) {
case _TariffAvailabilities() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'to_buy')  List<TariffAvailability> toBuy, @JsonKey(name: 'to_use')  List<TariffAvailability> toUse)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TariffAvailabilities() when $default != null:
return $default(_that.toBuy,_that.toUse);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'to_buy')  List<TariffAvailability> toBuy, @JsonKey(name: 'to_use')  List<TariffAvailability> toUse)  $default,) {final _that = this;
switch (_that) {
case _TariffAvailabilities():
return $default(_that.toBuy,_that.toUse);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'to_buy')  List<TariffAvailability> toBuy, @JsonKey(name: 'to_use')  List<TariffAvailability> toUse)?  $default,) {final _that = this;
switch (_that) {
case _TariffAvailabilities() when $default != null:
return $default(_that.toBuy,_that.toUse);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TariffAvailabilities implements TariffAvailabilities {
  const _TariffAvailabilities({@JsonKey(name: 'to_buy')  List<TariffAvailability> toBuy = const [], @JsonKey(name: 'to_use')  List<TariffAvailability> toUse = const []}): _toBuy = toBuy,_toUse = toUse;
  factory _TariffAvailabilities.fromJson(Map<String, dynamic> json) => _$TariffAvailabilitiesFromJson(json);

 final  List<TariffAvailability> _toBuy;
@override@JsonKey(name: 'to_buy') List<TariffAvailability> get toBuy {
  if (_toBuy is EqualUnmodifiableListView) return _toBuy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toBuy);
}

 final  List<TariffAvailability> _toUse;
@override@JsonKey(name: 'to_use') List<TariffAvailability> get toUse {
  if (_toUse is EqualUnmodifiableListView) return _toUse;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toUse);
}


/// Create a copy of TariffAvailabilities
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TariffAvailabilitiesCopyWith<_TariffAvailabilities> get copyWith => __$TariffAvailabilitiesCopyWithImpl<_TariffAvailabilities>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TariffAvailabilitiesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TariffAvailabilities&&const DeepCollectionEquality().equals(other.toBuy, _toBuy)&&const DeepCollectionEquality().equals(other.toUse, _toUse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_toBuy),const DeepCollectionEquality().hash(_toUse));
}

@override
String toString() {
    return 'TariffAvailabilities(toBuy: $toBuy, toUse: $toUse)';
}


}

/// @nodoc
abstract mixin class _$TariffAvailabilitiesCopyWith<$Res> implements $TariffAvailabilitiesCopyWith<$Res> {
  factory _$TariffAvailabilitiesCopyWith(_TariffAvailabilities value, $Res Function(_TariffAvailabilities) _then) = __$TariffAvailabilitiesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'to_buy') List<TariffAvailability> toBuy,@JsonKey(name: 'to_use') List<TariffAvailability> toUse
});




}
/// @nodoc
class __$TariffAvailabilitiesCopyWithImpl<$Res>
    implements _$TariffAvailabilitiesCopyWith<$Res> {
  __$TariffAvailabilitiesCopyWithImpl(this._self, this._then);

  final _TariffAvailabilities _self;
  final $Res Function(_TariffAvailabilities) _then;

/// Create a copy of TariffAvailabilities
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toBuy = null,Object? toUse = null,}) {
  return _then(_TariffAvailabilities(
toBuy: null == toBuy ? _self._toBuy : toBuy // ignore: cast_nullable_to_non_nullable
as List<TariffAvailability>,toUse: null == toUse ? _self._toUse : toUse // ignore: cast_nullable_to_non_nullable
as List<TariffAvailability>,
  ));
}


}


/// @nodoc
mixin _$TariffProperty {

@JsonKey(name: 'tariff_id') String? get tariffId; TariffAvailabilities? get availabilities;
/// Create a copy of TariffProperty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TariffPropertyCopyWith<TariffProperty> get copyWith => _$TariffPropertyCopyWithImpl<TariffProperty>(this as TariffProperty, _$identity);

  /// Serializes this TariffProperty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TariffProperty;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TariffProperty&&(identical(other.tariffId, _this.tariffId) || other.tariffId == _this.tariffId)&&(identical(other.availabilities, _this.availabilities) || other.availabilities == _this.availabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TariffProperty;
  return Object.hash(runtimeType,_this.tariffId,_this.availabilities);
}

@override
String toString() {
  final _this = this as TariffProperty;
  return 'TariffProperty(tariffId: ${_this.tariffId}, availabilities: ${_this.availabilities})';
}


}

/// @nodoc
abstract mixin class $TariffPropertyCopyWith<$Res>  {
  factory $TariffPropertyCopyWith(TariffProperty value, $Res Function(TariffProperty) _then) = _$TariffPropertyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tariff_id') String? tariffId, TariffAvailabilities? availabilities
});


$TariffAvailabilitiesCopyWith<$Res>? get availabilities;

}
/// @nodoc
class _$TariffPropertyCopyWithImpl<$Res>
    implements $TariffPropertyCopyWith<$Res> {
  _$TariffPropertyCopyWithImpl(this._self, this._then);

  final TariffProperty _self;
  final $Res Function(TariffProperty) _then;

/// Create a copy of TariffProperty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tariffId = freezed,Object? availabilities = freezed,}) {
  return _then(TariffProperty(
tariffId: freezed == tariffId ? _self.tariffId : tariffId // ignore: cast_nullable_to_non_nullable
as String?,availabilities: freezed == availabilities ? _self.availabilities : availabilities // ignore: cast_nullable_to_non_nullable
as TariffAvailabilities?,
  ));
}
/// Create a copy of TariffProperty
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TariffAvailabilitiesCopyWith<$Res>? get availabilities {
    if (_self.availabilities == null) {
    return null;
  }

  return $TariffAvailabilitiesCopyWith<$Res>(_self.availabilities!, (value) {
    return _then(_self.copyWith(availabilities: value));
  });
}
}


/// Adds pattern-matching-related methods to [TariffProperty].
extension TariffPropertyPatterns on TariffProperty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TariffProperty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TariffProperty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TariffProperty value)  $default,){
final _that = this;
switch (_that) {
case _TariffProperty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TariffProperty value)?  $default,){
final _that = this;
switch (_that) {
case _TariffProperty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tariff_id')  String? tariffId,  TariffAvailabilities? availabilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TariffProperty() when $default != null:
return $default(_that.tariffId,_that.availabilities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tariff_id')  String? tariffId,  TariffAvailabilities? availabilities)  $default,) {final _that = this;
switch (_that) {
case _TariffProperty():
return $default(_that.tariffId,_that.availabilities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tariff_id')  String? tariffId,  TariffAvailabilities? availabilities)?  $default,) {final _that = this;
switch (_that) {
case _TariffProperty() when $default != null:
return $default(_that.tariffId,_that.availabilities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TariffProperty implements TariffProperty {
  const _TariffProperty({@JsonKey(name: 'tariff_id') this.tariffId, this.availabilities});
  factory _TariffProperty.fromJson(Map<String, dynamic> json) => _$TariffPropertyFromJson(json);

@override@JsonKey(name: 'tariff_id') final  String? tariffId;
@override final  TariffAvailabilities? availabilities;

/// Create a copy of TariffProperty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TariffPropertyCopyWith<_TariffProperty> get copyWith => __$TariffPropertyCopyWithImpl<_TariffProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TariffPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TariffProperty&&(identical(other.tariffId, tariffId) || other.tariffId == tariffId)&&(identical(other.availabilities, availabilities) || other.availabilities == availabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tariffId,availabilities);
}

@override
String toString() {
    return 'TariffProperty(tariffId: $tariffId, availabilities: $availabilities)';
}


}

/// @nodoc
abstract mixin class _$TariffPropertyCopyWith<$Res> implements $TariffPropertyCopyWith<$Res> {
  factory _$TariffPropertyCopyWith(_TariffProperty value, $Res Function(_TariffProperty) _then) = __$TariffPropertyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tariff_id') String? tariffId, TariffAvailabilities? availabilities
});


@override $TariffAvailabilitiesCopyWith<$Res>? get availabilities;

}
/// @nodoc
class __$TariffPropertyCopyWithImpl<$Res>
    implements _$TariffPropertyCopyWith<$Res> {
  __$TariffPropertyCopyWithImpl(this._self, this._then);

  final _TariffProperty _self;
  final $Res Function(_TariffProperty) _then;

/// Create a copy of TariffProperty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tariffId = freezed,Object? availabilities = freezed,}) {
  return _then(_TariffProperty(
tariffId: freezed == tariffId ? _self.tariffId : tariffId // ignore: cast_nullable_to_non_nullable
as String?,availabilities: freezed == availabilities ? _self.availabilities : availabilities // ignore: cast_nullable_to_non_nullable
as TariffAvailabilities?,
  ));
}

/// Create a copy of TariffProperty
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TariffAvailabilitiesCopyWith<$Res>? get availabilities {
    if (_self.availabilities == null) {
    return null;
  }

  return $TariffAvailabilitiesCopyWith<$Res>(_self.availabilities!, (value) {
    return _then(_self.copyWith(availabilities: value));
  });
}
}


/// @nodoc
mixin _$Tariff {

 String get id; String? get name;@JsonKey(name: 'base_price') Object? get basePrice;@JsonKey(fromJson: numFromJson) num? get duration; String? get type;@JsonKey(name: 'zone_id') String? get zoneId; TariffProperty? get property;
/// Create a copy of Tariff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TariffCopyWith<Tariff> get copyWith => _$TariffCopyWithImpl<Tariff>(this as Tariff, _$identity);

  /// Serializes this Tariff to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Tariff;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tariff&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.basePrice, _this.basePrice)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.zoneId, _this.zoneId) || other.zoneId == _this.zoneId)&&(identical(other.property, _this.property) || other.property == _this.property));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Tariff;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.basePrice),_this.duration,_this.type,_this.zoneId,_this.property);
}

@override
String toString() {
  final _this = this as Tariff;
  return 'Tariff(id: ${_this.id}, name: ${_this.name}, basePrice: ${_this.basePrice}, duration: ${_this.duration}, type: ${_this.type}, zoneId: ${_this.zoneId}, property: ${_this.property})';
}


}

/// @nodoc
abstract mixin class $TariffCopyWith<$Res>  {
  factory $TariffCopyWith(Tariff value, $Res Function(Tariff) _then) = _$TariffCopyWithImpl;
@useResult
$Res call({
 String id, String? name,@JsonKey(name: 'base_price') Object? basePrice,@JsonKey(fromJson: numFromJson) num? duration, String? type,@JsonKey(name: 'zone_id') String? zoneId, TariffProperty? property
});


$TariffPropertyCopyWith<$Res>? get property;

}
/// @nodoc
class _$TariffCopyWithImpl<$Res>
    implements $TariffCopyWith<$Res> {
  _$TariffCopyWithImpl(this._self, this._then);

  final Tariff _self;
  final $Res Function(Tariff) _then;

/// Create a copy of Tariff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? basePrice = freezed,Object? duration = freezed,Object? type = freezed,Object? zoneId = freezed,Object? property = freezed,}) {
  return _then(Tariff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,basePrice: freezed == basePrice ? _self.basePrice : basePrice ,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as num?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,zoneId: freezed == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String?,property: freezed == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as TariffProperty?,
  ));
}
/// Create a copy of Tariff
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TariffPropertyCopyWith<$Res>? get property {
    if (_self.property == null) {
    return null;
  }

  return $TariffPropertyCopyWith<$Res>(_self.property!, (value) {
    return _then(_self.copyWith(property: value));
  });
}
}


/// Adds pattern-matching-related methods to [Tariff].
extension TariffPatterns on Tariff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tariff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tariff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tariff value)  $default,){
final _that = this;
switch (_that) {
case _Tariff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tariff value)?  $default,){
final _that = this;
switch (_that) {
case _Tariff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name, @JsonKey(name: 'base_price')  Object? basePrice, @JsonKey(fromJson: numFromJson)  num? duration,  String? type, @JsonKey(name: 'zone_id')  String? zoneId,  TariffProperty? property)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tariff() when $default != null:
return $default(_that.id,_that.name,_that.basePrice,_that.duration,_that.type,_that.zoneId,_that.property);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name, @JsonKey(name: 'base_price')  Object? basePrice, @JsonKey(fromJson: numFromJson)  num? duration,  String? type, @JsonKey(name: 'zone_id')  String? zoneId,  TariffProperty? property)  $default,) {final _that = this;
switch (_that) {
case _Tariff():
return $default(_that.id,_that.name,_that.basePrice,_that.duration,_that.type,_that.zoneId,_that.property);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name, @JsonKey(name: 'base_price')  Object? basePrice, @JsonKey(fromJson: numFromJson)  num? duration,  String? type, @JsonKey(name: 'zone_id')  String? zoneId,  TariffProperty? property)?  $default,) {final _that = this;
switch (_that) {
case _Tariff() when $default != null:
return $default(_that.id,_that.name,_that.basePrice,_that.duration,_that.type,_that.zoneId,_that.property);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tariff implements Tariff {
  const _Tariff({required this.id, this.name, @JsonKey(name: 'base_price') this.basePrice, @JsonKey(fromJson: numFromJson) this.duration, this.type, @JsonKey(name: 'zone_id') this.zoneId, this.property});
  factory _Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);

@override final  String id;
@override final  String? name;
@override@JsonKey(name: 'base_price') final  Object? basePrice;
@override@JsonKey(fromJson: numFromJson) final  num? duration;
@override final  String? type;
@override@JsonKey(name: 'zone_id') final  String? zoneId;
@override final  TariffProperty? property;

/// Create a copy of Tariff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TariffCopyWith<_Tariff> get copyWith => __$TariffCopyWithImpl<_Tariff>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TariffToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tariff&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.basePrice, basePrice)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.type, type) || other.type == type)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.property, property) || other.property == property));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(basePrice),duration,type,zoneId,property);
}

@override
String toString() {
    return 'Tariff(id: $id, name: $name, basePrice: $basePrice, duration: $duration, type: $type, zoneId: $zoneId, property: $property)';
}


}

/// @nodoc
abstract mixin class _$TariffCopyWith<$Res> implements $TariffCopyWith<$Res> {
  factory _$TariffCopyWith(_Tariff value, $Res Function(_Tariff) _then) = __$TariffCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name,@JsonKey(name: 'base_price') Object? basePrice,@JsonKey(fromJson: numFromJson) num? duration, String? type,@JsonKey(name: 'zone_id') String? zoneId, TariffProperty? property
});


@override $TariffPropertyCopyWith<$Res>? get property;

}
/// @nodoc
class __$TariffCopyWithImpl<$Res>
    implements _$TariffCopyWith<$Res> {
  __$TariffCopyWithImpl(this._self, this._then);

  final _Tariff _self;
  final $Res Function(_Tariff) _then;

/// Create a copy of Tariff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? basePrice = freezed,Object? duration = freezed,Object? type = freezed,Object? zoneId = freezed,Object? property = freezed,}) {
  return _then(_Tariff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,basePrice: freezed == basePrice ? _self.basePrice : basePrice ,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as num?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,zoneId: freezed == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String?,property: freezed == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as TariffProperty?,
  ));
}

/// Create a copy of Tariff
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TariffPropertyCopyWith<$Res>? get property {
    if (_self.property == null) {
    return null;
  }

  return $TariffPropertyCopyWith<$Res>(_self.property!, (value) {
    return _then(_self.copyWith(property: value));
  });
}
}


/// @nodoc
mixin _$Wallet {

 String? get id; Object? get balance; Object? get bonuses;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'game_center_id') String? get gameCenterId;@JsonKey(name: 'game_center') Object? get gameCenter; String? get username;
/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletCopyWith<Wallet> get copyWith => _$WalletCopyWithImpl<Wallet>(this as Wallet, _$identity);

  /// Serializes this Wallet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Wallet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wallet&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.balance, _this.balance)&&const DeepCollectionEquality().equals(other.bonuses, _this.bonuses)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.gameCenterId, _this.gameCenterId) || other.gameCenterId == _this.gameCenterId)&&const DeepCollectionEquality().equals(other.gameCenter, _this.gameCenter)&&(identical(other.username, _this.username) || other.username == _this.username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Wallet;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.balance),const DeepCollectionEquality().hash(_this.bonuses),_this.userId,_this.gameCenterId,const DeepCollectionEquality().hash(_this.gameCenter),_this.username);
}

@override
String toString() {
  final _this = this as Wallet;
  return 'Wallet(id: ${_this.id}, balance: ${_this.balance}, bonuses: ${_this.bonuses}, userId: ${_this.userId}, gameCenterId: ${_this.gameCenterId}, gameCenter: ${_this.gameCenter}, username: ${_this.username})';
}


}

/// @nodoc
abstract mixin class $WalletCopyWith<$Res>  {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) _then) = _$WalletCopyWithImpl;
@useResult
$Res call({
 String? id, Object? balance, Object? bonuses,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'game_center_id') String? gameCenterId,@JsonKey(name: 'game_center') Object? gameCenter, String? username
});




}
/// @nodoc
class _$WalletCopyWithImpl<$Res>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._self, this._then);

  final Wallet _self;
  final $Res Function(Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? balance = freezed,Object? bonuses = freezed,Object? userId = freezed,Object? gameCenterId = freezed,Object? gameCenter = freezed,Object? username = freezed,}) {
  return _then(Wallet(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,balance: freezed == balance ? _self.balance : balance ,bonuses: freezed == bonuses ? _self.bonuses : bonuses ,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,gameCenterId: freezed == gameCenterId ? _self.gameCenterId : gameCenterId // ignore: cast_nullable_to_non_nullable
as String?,gameCenter: freezed == gameCenter ? _self.gameCenter : gameCenter ,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Wallet].
extension WalletPatterns on Wallet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wallet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wallet value)  $default,){
final _that = this;
switch (_that) {
case _Wallet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wallet value)?  $default,){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  Object? balance,  Object? bonuses, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'game_center')  Object? gameCenter,  String? username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.id,_that.balance,_that.bonuses,_that.userId,_that.gameCenterId,_that.gameCenter,_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  Object? balance,  Object? bonuses, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'game_center')  Object? gameCenter,  String? username)  $default,) {final _that = this;
switch (_that) {
case _Wallet():
return $default(_that.id,_that.balance,_that.bonuses,_that.userId,_that.gameCenterId,_that.gameCenter,_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  Object? balance,  Object? bonuses, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'game_center_id')  String? gameCenterId, @JsonKey(name: 'game_center')  Object? gameCenter,  String? username)?  $default,) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.id,_that.balance,_that.bonuses,_that.userId,_that.gameCenterId,_that.gameCenter,_that.username);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Wallet implements Wallet {
  const _Wallet({this.id, this.balance, this.bonuses, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'game_center_id') this.gameCenterId, @JsonKey(name: 'game_center') this.gameCenter, this.username});
  factory _Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

@override final  String? id;
@override final  Object? balance;
@override final  Object? bonuses;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'game_center_id') final  String? gameCenterId;
@override@JsonKey(name: 'game_center') final  Object? gameCenter;
@override final  String? username;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletCopyWith<_Wallet> get copyWith => __$WalletCopyWithImpl<_Wallet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wallet&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.balance, balance)&&const DeepCollectionEquality().equals(other.bonuses, bonuses)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.gameCenterId, gameCenterId) || other.gameCenterId == gameCenterId)&&const DeepCollectionEquality().equals(other.gameCenter, gameCenter)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(balance),const DeepCollectionEquality().hash(bonuses),userId,gameCenterId,const DeepCollectionEquality().hash(gameCenter),username);
}

@override
String toString() {
    return 'Wallet(id: $id, balance: $balance, bonuses: $bonuses, userId: $userId, gameCenterId: $gameCenterId, gameCenter: $gameCenter, username: $username)';
}


}

/// @nodoc
abstract mixin class _$WalletCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$WalletCopyWith(_Wallet value, $Res Function(_Wallet) _then) = __$WalletCopyWithImpl;
@override @useResult
$Res call({
 String? id, Object? balance, Object? bonuses,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'game_center_id') String? gameCenterId,@JsonKey(name: 'game_center') Object? gameCenter, String? username
});




}
/// @nodoc
class __$WalletCopyWithImpl<$Res>
    implements _$WalletCopyWith<$Res> {
  __$WalletCopyWithImpl(this._self, this._then);

  final _Wallet _self;
  final $Res Function(_Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? balance = freezed,Object? bonuses = freezed,Object? userId = freezed,Object? gameCenterId = freezed,Object? gameCenter = freezed,Object? username = freezed,}) {
  return _then(_Wallet(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,balance: freezed == balance ? _self.balance : balance ,bonuses: freezed == bonuses ? _self.bonuses : bonuses ,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,gameCenterId: freezed == gameCenterId ? _self.gameCenterId : gameCenterId // ignore: cast_nullable_to_non_nullable
as String?,gameCenter: freezed == gameCenter ? _self.gameCenter : gameCenter ,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
