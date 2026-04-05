// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_list_provider.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppInfoDbCollection on Isar {
  IsarCollection<AppInfoDb> get appInfoDbs => this.collection();
}

const AppInfoDbSchema = CollectionSchema(
  name: r'AppInfoDb',
  id: -5190285282580564121,
  properties: {
    r'appName': PropertySchema(
      id: 0,
      name: r'appName',
      type: IsarType.string,
    ),
    r'icon': PropertySchema(
      id: 1,
      name: r'icon',
      type: IsarType.longList,
    ),
    r'packageName': PropertySchema(
      id: 2,
      name: r'packageName',
      type: IsarType.string,
    ),
    r'position': PropertySchema(
      id: 3,
      name: r'position',
      type: IsarType.long,
    )
  },
  estimateSize: _appInfoDbEstimateSize,
  serialize: _appInfoDbSerialize,
  deserialize: _appInfoDbDeserialize,
  deserializeProp: _appInfoDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'packageName': IndexSchema(
      id: -3211024755902609907,
      name: r'packageName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'packageName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _appInfoDbGetId,
  getLinks: _appInfoDbGetLinks,
  attach: _appInfoDbAttach,
  version: '3.1.0+1',
);

int _appInfoDbEstimateSize(
  AppInfoDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appName.length * 3;
  bytesCount += 3 + object.icon.length * 8;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _appInfoDbSerialize(
  AppInfoDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appName);
  writer.writeLongList(offsets[1], object.icon);
  writer.writeString(offsets[2], object.packageName);
  writer.writeLong(offsets[3], object.position);
}

AppInfoDb _appInfoDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppInfoDb();
  object.appName = reader.readString(offsets[0]);
  object.icon = reader.readLongList(offsets[1]) ?? [];
  object.id = id;
  object.packageName = reader.readString(offsets[2]);
  object.position = reader.readLong(offsets[3]);
  return object;
}

P _appInfoDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appInfoDbGetId(AppInfoDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appInfoDbGetLinks(AppInfoDb object) {
  return [];
}

void _appInfoDbAttach(IsarCollection<dynamic> col, Id id, AppInfoDb object) {
  object.id = id;
}

extension AppInfoDbByIndex on IsarCollection<AppInfoDb> {
  Future<AppInfoDb?> getByPackageName(String packageName) {
    return getByIndex(r'packageName', [packageName]);
  }

  AppInfoDb? getByPackageNameSync(String packageName) {
    return getByIndexSync(r'packageName', [packageName]);
  }

  Future<bool> deleteByPackageName(String packageName) {
    return deleteByIndex(r'packageName', [packageName]);
  }

  bool deleteByPackageNameSync(String packageName) {
    return deleteByIndexSync(r'packageName', [packageName]);
  }

  Future<List<AppInfoDb?>> getAllByPackageName(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'packageName', values);
  }

  List<AppInfoDb?> getAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'packageName', values);
  }

  Future<int> deleteAllByPackageName(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'packageName', values);
  }

  int deleteAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'packageName', values);
  }

  Future<Id> putByPackageName(AppInfoDb object) {
    return putByIndex(r'packageName', object);
  }

  Id putByPackageNameSync(AppInfoDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'packageName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPackageName(List<AppInfoDb> objects) {
    return putAllByIndex(r'packageName', objects);
  }

  List<Id> putAllByPackageNameSync(List<AppInfoDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'packageName', objects, saveLinks: saveLinks);
  }
}

extension AppInfoDbQueryWhereSort
    on QueryBuilder<AppInfoDb, AppInfoDb, QWhere> {
  QueryBuilder<AppInfoDb, AppInfoDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppInfoDbQueryWhere
    on QueryBuilder<AppInfoDb, AppInfoDb, QWhereClause> {
  QueryBuilder<AppInfoDb, AppInfoDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterWhereClause> packageNameEqualTo(
      String packageName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'packageName',
        value: [packageName],
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterWhereClause> packageNameNotEqualTo(
      String packageName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AppInfoDbQueryFilter
    on QueryBuilder<AppInfoDb, AppInfoDb, QFilterCondition> {
  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> appNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition>
      appNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> iconElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition>
      iconElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> iconElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> iconElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> iconLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> iconLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition>
      iconLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> iconLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> packageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition>
      packageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> packageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> packageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> packageNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> packageNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> positionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> positionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> positionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterFilterCondition> positionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppInfoDbQueryObject
    on QueryBuilder<AppInfoDb, AppInfoDb, QFilterCondition> {}

extension AppInfoDbQueryLinks
    on QueryBuilder<AppInfoDb, AppInfoDb, QFilterCondition> {}

extension AppInfoDbQuerySortBy on QueryBuilder<AppInfoDb, AppInfoDb, QSortBy> {
  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> sortByAppName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.asc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> sortByAppNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.desc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension AppInfoDbQuerySortThenBy
    on QueryBuilder<AppInfoDb, AppInfoDb, QSortThenBy> {
  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> thenByAppName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.asc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> thenByAppNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.desc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension AppInfoDbQueryWhereDistinct
    on QueryBuilder<AppInfoDb, AppInfoDb, QDistinct> {
  QueryBuilder<AppInfoDb, AppInfoDb, QDistinct> distinctByAppName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QDistinct> distinctByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon');
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QDistinct> distinctByPackageName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppInfoDb, AppInfoDb, QDistinct> distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }
}

extension AppInfoDbQueryProperty
    on QueryBuilder<AppInfoDb, AppInfoDb, QQueryProperty> {
  QueryBuilder<AppInfoDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppInfoDb, String, QQueryOperations> appNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appName');
    });
  }

  QueryBuilder<AppInfoDb, List<int>, QQueryOperations> iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<AppInfoDb, String, QQueryOperations> packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }

  QueryBuilder<AppInfoDb, int, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDockAppCollection on Isar {
  IsarCollection<DockApp> get dockApps => this.collection();
}

const DockAppSchema = CollectionSchema(
  name: r'DockApp',
  id: 5210878916053945134,
  properties: {
    r'appName': PropertySchema(
      id: 0,
      name: r'appName',
      type: IsarType.string,
    ),
    r'icon': PropertySchema(
      id: 1,
      name: r'icon',
      type: IsarType.longList,
    ),
    r'packageName': PropertySchema(
      id: 2,
      name: r'packageName',
      type: IsarType.string,
    ),
    r'position': PropertySchema(
      id: 3,
      name: r'position',
      type: IsarType.long,
    )
  },
  estimateSize: _dockAppEstimateSize,
  serialize: _dockAppSerialize,
  deserialize: _dockAppDeserialize,
  deserializeProp: _dockAppDeserializeProp,
  idName: r'id',
  indexes: {
    r'packageName': IndexSchema(
      id: -3211024755902609907,
      name: r'packageName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'packageName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dockAppGetId,
  getLinks: _dockAppGetLinks,
  attach: _dockAppAttach,
  version: '3.1.0+1',
);

int _dockAppEstimateSize(
  DockApp object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appName.length * 3;
  bytesCount += 3 + object.icon.length * 8;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _dockAppSerialize(
  DockApp object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appName);
  writer.writeLongList(offsets[1], object.icon);
  writer.writeString(offsets[2], object.packageName);
  writer.writeLong(offsets[3], object.position);
}

DockApp _dockAppDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DockApp();
  object.appName = reader.readString(offsets[0]);
  object.icon = reader.readLongList(offsets[1]) ?? [];
  object.id = id;
  object.packageName = reader.readString(offsets[2]);
  object.position = reader.readLong(offsets[3]);
  return object;
}

P _dockAppDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dockAppGetId(DockApp object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dockAppGetLinks(DockApp object) {
  return [];
}

void _dockAppAttach(IsarCollection<dynamic> col, Id id, DockApp object) {
  object.id = id;
}

extension DockAppByIndex on IsarCollection<DockApp> {
  Future<DockApp?> getByPackageName(String packageName) {
    return getByIndex(r'packageName', [packageName]);
  }

  DockApp? getByPackageNameSync(String packageName) {
    return getByIndexSync(r'packageName', [packageName]);
  }

  Future<bool> deleteByPackageName(String packageName) {
    return deleteByIndex(r'packageName', [packageName]);
  }

  bool deleteByPackageNameSync(String packageName) {
    return deleteByIndexSync(r'packageName', [packageName]);
  }

  Future<List<DockApp?>> getAllByPackageName(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'packageName', values);
  }

  List<DockApp?> getAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'packageName', values);
  }

  Future<int> deleteAllByPackageName(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'packageName', values);
  }

  int deleteAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'packageName', values);
  }

  Future<Id> putByPackageName(DockApp object) {
    return putByIndex(r'packageName', object);
  }

  Id putByPackageNameSync(DockApp object, {bool saveLinks = true}) {
    return putByIndexSync(r'packageName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPackageName(List<DockApp> objects) {
    return putAllByIndex(r'packageName', objects);
  }

  List<Id> putAllByPackageNameSync(List<DockApp> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'packageName', objects, saveLinks: saveLinks);
  }
}

extension DockAppQueryWhereSort on QueryBuilder<DockApp, DockApp, QWhere> {
  QueryBuilder<DockApp, DockApp, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DockAppQueryWhere on QueryBuilder<DockApp, DockApp, QWhereClause> {
  QueryBuilder<DockApp, DockApp, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterWhereClause> packageNameEqualTo(
      String packageName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'packageName',
        value: [packageName],
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterWhereClause> packageNameNotEqualTo(
      String packageName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DockAppQueryFilter
    on QueryBuilder<DockApp, DockApp, QFilterCondition> {
  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appName',
        value: '',
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> appNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appName',
        value: '',
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> iconLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> positionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> positionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> positionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterFilterCondition> positionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DockAppQueryObject
    on QueryBuilder<DockApp, DockApp, QFilterCondition> {}

extension DockAppQueryLinks
    on QueryBuilder<DockApp, DockApp, QFilterCondition> {}

extension DockAppQuerySortBy on QueryBuilder<DockApp, DockApp, QSortBy> {
  QueryBuilder<DockApp, DockApp, QAfterSortBy> sortByAppName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.asc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> sortByAppNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.desc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension DockAppQuerySortThenBy
    on QueryBuilder<DockApp, DockApp, QSortThenBy> {
  QueryBuilder<DockApp, DockApp, QAfterSortBy> thenByAppName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.asc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> thenByAppNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.desc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<DockApp, DockApp, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension DockAppQueryWhereDistinct
    on QueryBuilder<DockApp, DockApp, QDistinct> {
  QueryBuilder<DockApp, DockApp, QDistinct> distinctByAppName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DockApp, DockApp, QDistinct> distinctByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon');
    });
  }

  QueryBuilder<DockApp, DockApp, QDistinct> distinctByPackageName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DockApp, DockApp, QDistinct> distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }
}

extension DockAppQueryProperty
    on QueryBuilder<DockApp, DockApp, QQueryProperty> {
  QueryBuilder<DockApp, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DockApp, String, QQueryOperations> appNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appName');
    });
  }

  QueryBuilder<DockApp, List<int>, QQueryOperations> iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<DockApp, String, QQueryOperations> packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }

  QueryBuilder<DockApp, int, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsDbCollection on Isar {
  IsarCollection<SettingsDb> get settingsDbs => this.collection();
}

const SettingsDbSchema = CollectionSchema(
  name: r'SettingsDb',
  id: 8417282985539613480,
  properties: {
    r'clockSpacing': PropertySchema(
      id: 0,
      name: r'clockSpacing',
      type: IsarType.double,
    ),
    r'clockStyle': PropertySchema(
      id: 1,
      name: r'clockStyle',
      type: IsarType.string,
    ),
    r'dockIconCount': PropertySchema(
      id: 2,
      name: r'dockIconCount',
      type: IsarType.long,
    ),
    r'doubleTapAction': PropertySchema(
      id: 3,
      name: r'doubleTapAction',
      type: IsarType.long,
    ),
    r'favoritesSpacing': PropertySchema(
      id: 4,
      name: r'favoritesSpacing',
      type: IsarType.double,
    ),
    r'fontScaleFactor': PropertySchema(
      id: 5,
      name: r'fontScaleFactor',
      type: IsarType.double,
    ),
    r'fontSize': PropertySchema(
      id: 6,
      name: r'fontSize',
      type: IsarType.long,
    ),
    r'gridColumns': PropertySchema(
      id: 7,
      name: r'gridColumns',
      type: IsarType.long,
    ),
    r'hapticsEnabled': PropertySchema(
      id: 8,
      name: r'hapticsEnabled',
      type: IsarType.bool,
    ),
    r'iconShape': PropertySchema(
      id: 9,
      name: r'iconShape',
      type: IsarType.long,
    ),
    r'iconSize': PropertySchema(
      id: 10,
      name: r'iconSize',
      type: IsarType.long,
    ),
    r'iconTheme': PropertySchema(
      id: 11,
      name: r'iconTheme',
      type: IsarType.long,
    ),
    r'leftWidgetSlotId': PropertySchema(
      id: 12,
      name: r'leftWidgetSlotId',
      type: IsarType.long,
    ),
    r'pinchAction': PropertySchema(
      id: 13,
      name: r'pinchAction',
      type: IsarType.long,
    ),
    r'rightWidgetSlotId': PropertySchema(
      id: 14,
      name: r'rightWidgetSlotId',
      type: IsarType.long,
    ),
    r'showDockLabels': PropertySchema(
      id: 15,
      name: r'showDockLabels',
      type: IsarType.bool,
    ),
    r'showLabels': PropertySchema(
      id: 16,
      name: r'showLabels',
      type: IsarType.bool,
    ),
    r'showRecents': PropertySchema(
      id: 17,
      name: r'showRecents',
      type: IsarType.bool,
    ),
    r'sidebarSpacing': PropertySchema(
      id: 18,
      name: r'sidebarSpacing',
      type: IsarType.double,
    ),
    r'swipeLeftAction': PropertySchema(
      id: 19,
      name: r'swipeLeftAction',
      type: IsarType.long,
    )
  },
  estimateSize: _settingsDbEstimateSize,
  serialize: _settingsDbSerialize,
  deserialize: _settingsDbDeserialize,
  deserializeProp: _settingsDbDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingsDbGetId,
  getLinks: _settingsDbGetLinks,
  attach: _settingsDbAttach,
  version: '3.1.0+1',
);

int _settingsDbEstimateSize(
  SettingsDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.clockStyle.length * 3;
  return bytesCount;
}

void _settingsDbSerialize(
  SettingsDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.clockSpacing);
  writer.writeString(offsets[1], object.clockStyle);
  writer.writeLong(offsets[2], object.dockIconCount);
  writer.writeLong(offsets[3], object.doubleTapAction);
  writer.writeDouble(offsets[4], object.favoritesSpacing);
  writer.writeDouble(offsets[5], object.fontScaleFactor);
  writer.writeLong(offsets[6], object.fontSize);
  writer.writeLong(offsets[7], object.gridColumns);
  writer.writeBool(offsets[8], object.hapticsEnabled);
  writer.writeLong(offsets[9], object.iconShape);
  writer.writeLong(offsets[10], object.iconSize);
  writer.writeLong(offsets[11], object.iconTheme);
  writer.writeLong(offsets[12], object.leftWidgetSlotId);
  writer.writeLong(offsets[13], object.pinchAction);
  writer.writeLong(offsets[14], object.rightWidgetSlotId);
  writer.writeBool(offsets[15], object.showDockLabels);
  writer.writeBool(offsets[16], object.showLabels);
  writer.writeBool(offsets[17], object.showRecents);
  writer.writeDouble(offsets[18], object.sidebarSpacing);
  writer.writeLong(offsets[19], object.swipeLeftAction);
}

SettingsDb _settingsDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsDb();
  object.clockSpacing = reader.readDouble(offsets[0]);
  object.clockStyle = reader.readString(offsets[1]);
  object.dockIconCount = reader.readLong(offsets[2]);
  object.doubleTapAction = reader.readLong(offsets[3]);
  object.favoritesSpacing = reader.readDouble(offsets[4]);
  object.fontScaleFactor = reader.readDouble(offsets[5]);
  object.fontSize = reader.readLong(offsets[6]);
  object.gridColumns = reader.readLong(offsets[7]);
  object.hapticsEnabled = reader.readBool(offsets[8]);
  object.iconShape = reader.readLong(offsets[9]);
  object.iconSize = reader.readLong(offsets[10]);
  object.iconTheme = reader.readLong(offsets[11]);
  object.id = id;
  object.leftWidgetSlotId = reader.readLongOrNull(offsets[12]);
  object.pinchAction = reader.readLong(offsets[13]);
  object.rightWidgetSlotId = reader.readLongOrNull(offsets[14]);
  object.showDockLabels = reader.readBool(offsets[15]);
  object.showLabels = reader.readBool(offsets[16]);
  object.showRecents = reader.readBool(offsets[17]);
  object.sidebarSpacing = reader.readDouble(offsets[18]);
  object.swipeLeftAction = reader.readLong(offsets[19]);
  return object;
}

P _settingsDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingsDbGetId(SettingsDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsDbGetLinks(SettingsDb object) {
  return [];
}

void _settingsDbAttach(IsarCollection<dynamic> col, Id id, SettingsDb object) {
  object.id = id;
}

extension SettingsDbQueryWhereSort
    on QueryBuilder<SettingsDb, SettingsDb, QWhere> {
  QueryBuilder<SettingsDb, SettingsDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsDbQueryWhere
    on QueryBuilder<SettingsDb, SettingsDb, QWhereClause> {
  QueryBuilder<SettingsDb, SettingsDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettingsDbQueryFilter
    on QueryBuilder<SettingsDb, SettingsDb, QFilterCondition> {
  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockSpacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> clockStyleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockStyleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockStyleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> clockStyleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockStyle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockStyleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clockStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockStyleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clockStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockStyleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clockStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> clockStyleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clockStyle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockStyleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockStyle',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      clockStyleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clockStyle',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      dockIconCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dockIconCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      dockIconCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dockIconCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      dockIconCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dockIconCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      dockIconCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dockIconCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      doubleTapActionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doubleTapAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      doubleTapActionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'doubleTapAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      doubleTapActionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'doubleTapAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      doubleTapActionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'doubleTapAction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      favoritesSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoritesSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      favoritesSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoritesSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      favoritesSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoritesSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      favoritesSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoritesSpacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      fontScaleFactorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontScaleFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      fontScaleFactorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontScaleFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      fontScaleFactorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontScaleFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      fontScaleFactorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontScaleFactor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> fontSizeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      fontSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> fontSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> fontSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      gridColumnsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gridColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      gridColumnsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gridColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      gridColumnsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gridColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      gridColumnsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gridColumns',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      hapticsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hapticsEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconShapeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconShape',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      iconShapeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconShape',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconShapeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconShape',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconShapeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconShape',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconSizeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      iconSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconThemeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconTheme',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      iconThemeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconTheme',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconThemeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconTheme',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> iconThemeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconTheme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      leftWidgetSlotIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'leftWidgetSlotId',
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      leftWidgetSlotIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'leftWidgetSlotId',
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      leftWidgetSlotIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leftWidgetSlotId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      leftWidgetSlotIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leftWidgetSlotId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      leftWidgetSlotIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leftWidgetSlotId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      leftWidgetSlotIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leftWidgetSlotId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      pinchActionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinchAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      pinchActionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pinchAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      pinchActionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pinchAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      pinchActionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pinchAction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      rightWidgetSlotIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rightWidgetSlotId',
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      rightWidgetSlotIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rightWidgetSlotId',
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      rightWidgetSlotIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rightWidgetSlotId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      rightWidgetSlotIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rightWidgetSlotId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      rightWidgetSlotIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rightWidgetSlotId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      rightWidgetSlotIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rightWidgetSlotId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      showDockLabelsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showDockLabels',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition> showLabelsEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showLabels',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      showRecentsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showRecents',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      sidebarSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sidebarSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      sidebarSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sidebarSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      sidebarSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sidebarSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      sidebarSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sidebarSpacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      swipeLeftActionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'swipeLeftAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      swipeLeftActionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'swipeLeftAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      swipeLeftActionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'swipeLeftAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterFilterCondition>
      swipeLeftActionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'swipeLeftAction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettingsDbQueryObject
    on QueryBuilder<SettingsDb, SettingsDb, QFilterCondition> {}

extension SettingsDbQueryLinks
    on QueryBuilder<SettingsDb, SettingsDb, QFilterCondition> {}

extension SettingsDbQuerySortBy
    on QueryBuilder<SettingsDb, SettingsDb, QSortBy> {
  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByClockSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockSpacing', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByClockSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockSpacing', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByClockStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockStyle', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByClockStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockStyle', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByDockIconCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dockIconCount', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByDockIconCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dockIconCount', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByDoubleTapAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doubleTapAction', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortByDoubleTapActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doubleTapAction', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByFavoritesSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritesSpacing', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortByFavoritesSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritesSpacing', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByFontScaleFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontScaleFactor', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortByFontScaleFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontScaleFactor', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByGridColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridColumns', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByGridColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridColumns', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByHapticsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticsEnabled', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortByHapticsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticsEnabled', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByIconShape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconShape', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByIconShapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconShape', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByIconSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconSize', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByIconSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconSize', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByIconTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconTheme', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByIconThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconTheme', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByLeftWidgetSlotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leftWidgetSlotId', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortByLeftWidgetSlotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leftWidgetSlotId', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByPinchAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinchAction', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByPinchActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinchAction', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByRightWidgetSlotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rightWidgetSlotId', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortByRightWidgetSlotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rightWidgetSlotId', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByShowDockLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDockLabels', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortByShowDockLabelsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDockLabels', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByShowLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLabels', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByShowLabelsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLabels', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByShowRecents() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showRecents', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortByShowRecentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showRecents', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortBySidebarSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sidebarSpacing', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortBySidebarSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sidebarSpacing', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> sortBySwipeLeftAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swipeLeftAction', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      sortBySwipeLeftActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swipeLeftAction', Sort.desc);
    });
  }
}

extension SettingsDbQuerySortThenBy
    on QueryBuilder<SettingsDb, SettingsDb, QSortThenBy> {
  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByClockSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockSpacing', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByClockSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockSpacing', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByClockStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockStyle', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByClockStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockStyle', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByDockIconCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dockIconCount', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByDockIconCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dockIconCount', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByDoubleTapAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doubleTapAction', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenByDoubleTapActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doubleTapAction', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByFavoritesSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritesSpacing', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenByFavoritesSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritesSpacing', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByFontScaleFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontScaleFactor', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenByFontScaleFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontScaleFactor', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByGridColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridColumns', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByGridColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridColumns', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByHapticsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticsEnabled', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenByHapticsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticsEnabled', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByIconShape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconShape', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByIconShapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconShape', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByIconSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconSize', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByIconSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconSize', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByIconTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconTheme', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByIconThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconTheme', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByLeftWidgetSlotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leftWidgetSlotId', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenByLeftWidgetSlotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leftWidgetSlotId', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByPinchAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinchAction', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByPinchActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinchAction', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByRightWidgetSlotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rightWidgetSlotId', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenByRightWidgetSlotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rightWidgetSlotId', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByShowDockLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDockLabels', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenByShowDockLabelsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDockLabels', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByShowLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLabels', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByShowLabelsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLabels', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByShowRecents() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showRecents', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenByShowRecentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showRecents', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenBySidebarSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sidebarSpacing', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenBySidebarSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sidebarSpacing', Sort.desc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy> thenBySwipeLeftAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swipeLeftAction', Sort.asc);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QAfterSortBy>
      thenBySwipeLeftActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swipeLeftAction', Sort.desc);
    });
  }
}

extension SettingsDbQueryWhereDistinct
    on QueryBuilder<SettingsDb, SettingsDb, QDistinct> {
  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByClockSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockSpacing');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByClockStyle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockStyle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByDockIconCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dockIconCount');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByDoubleTapAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doubleTapAction');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByFavoritesSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoritesSpacing');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByFontScaleFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontScaleFactor');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontSize');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByGridColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gridColumns');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByHapticsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hapticsEnabled');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByIconShape() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconShape');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByIconSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconSize');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByIconTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconTheme');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByLeftWidgetSlotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leftWidgetSlotId');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByPinchAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinchAction');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct>
      distinctByRightWidgetSlotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rightWidgetSlotId');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByShowDockLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showDockLabels');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByShowLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showLabels');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctByShowRecents() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showRecents');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctBySidebarSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sidebarSpacing');
    });
  }

  QueryBuilder<SettingsDb, SettingsDb, QDistinct> distinctBySwipeLeftAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'swipeLeftAction');
    });
  }
}

extension SettingsDbQueryProperty
    on QueryBuilder<SettingsDb, SettingsDb, QQueryProperty> {
  QueryBuilder<SettingsDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsDb, double, QQueryOperations> clockSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockSpacing');
    });
  }

  QueryBuilder<SettingsDb, String, QQueryOperations> clockStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockStyle');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> dockIconCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dockIconCount');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> doubleTapActionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doubleTapAction');
    });
  }

  QueryBuilder<SettingsDb, double, QQueryOperations>
      favoritesSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoritesSpacing');
    });
  }

  QueryBuilder<SettingsDb, double, QQueryOperations> fontScaleFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontScaleFactor');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> fontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontSize');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> gridColumnsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gridColumns');
    });
  }

  QueryBuilder<SettingsDb, bool, QQueryOperations> hapticsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hapticsEnabled');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> iconShapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconShape');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> iconSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconSize');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> iconThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconTheme');
    });
  }

  QueryBuilder<SettingsDb, int?, QQueryOperations> leftWidgetSlotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leftWidgetSlotId');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> pinchActionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinchAction');
    });
  }

  QueryBuilder<SettingsDb, int?, QQueryOperations> rightWidgetSlotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rightWidgetSlotId');
    });
  }

  QueryBuilder<SettingsDb, bool, QQueryOperations> showDockLabelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showDockLabels');
    });
  }

  QueryBuilder<SettingsDb, bool, QQueryOperations> showLabelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showLabels');
    });
  }

  QueryBuilder<SettingsDb, bool, QQueryOperations> showRecentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showRecents');
    });
  }

  QueryBuilder<SettingsDb, double, QQueryOperations> sidebarSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sidebarSpacing');
    });
  }

  QueryBuilder<SettingsDb, int, QQueryOperations> swipeLeftActionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'swipeLeftAction');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPageLayoutDbCollection on Isar {
  IsarCollection<PageLayoutDb> get pageLayoutDbs => this.collection();
}

const PageLayoutDbSchema = CollectionSchema(
  name: r'PageLayoutDb',
  id: -3066444622894311573,
  properties: {
    r'packageNames': PropertySchema(
      id: 0,
      name: r'packageNames',
      type: IsarType.stringList,
    ),
    r'pageIndex': PropertySchema(
      id: 1,
      name: r'pageIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _pageLayoutDbEstimateSize,
  serialize: _pageLayoutDbSerialize,
  deserialize: _pageLayoutDbDeserialize,
  deserializeProp: _pageLayoutDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'pageIndex': IndexSchema(
      id: -6792988718546572558,
      name: r'pageIndex',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'pageIndex',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _pageLayoutDbGetId,
  getLinks: _pageLayoutDbGetLinks,
  attach: _pageLayoutDbAttach,
  version: '3.1.0+1',
);

int _pageLayoutDbEstimateSize(
  PageLayoutDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.packageNames.length * 3;
  {
    for (var i = 0; i < object.packageNames.length; i++) {
      final value = object.packageNames[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _pageLayoutDbSerialize(
  PageLayoutDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.packageNames);
  writer.writeLong(offsets[1], object.pageIndex);
}

PageLayoutDb _pageLayoutDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PageLayoutDb();
  object.id = id;
  object.packageNames = reader.readStringList(offsets[0]) ?? [];
  object.pageIndex = reader.readLong(offsets[1]);
  return object;
}

P _pageLayoutDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pageLayoutDbGetId(PageLayoutDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pageLayoutDbGetLinks(PageLayoutDb object) {
  return [];
}

void _pageLayoutDbAttach(
    IsarCollection<dynamic> col, Id id, PageLayoutDb object) {
  object.id = id;
}

extension PageLayoutDbByIndex on IsarCollection<PageLayoutDb> {
  Future<PageLayoutDb?> getByPageIndex(int pageIndex) {
    return getByIndex(r'pageIndex', [pageIndex]);
  }

  PageLayoutDb? getByPageIndexSync(int pageIndex) {
    return getByIndexSync(r'pageIndex', [pageIndex]);
  }

  Future<bool> deleteByPageIndex(int pageIndex) {
    return deleteByIndex(r'pageIndex', [pageIndex]);
  }

  bool deleteByPageIndexSync(int pageIndex) {
    return deleteByIndexSync(r'pageIndex', [pageIndex]);
  }

  Future<List<PageLayoutDb?>> getAllByPageIndex(List<int> pageIndexValues) {
    final values = pageIndexValues.map((e) => [e]).toList();
    return getAllByIndex(r'pageIndex', values);
  }

  List<PageLayoutDb?> getAllByPageIndexSync(List<int> pageIndexValues) {
    final values = pageIndexValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'pageIndex', values);
  }

  Future<int> deleteAllByPageIndex(List<int> pageIndexValues) {
    final values = pageIndexValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'pageIndex', values);
  }

  int deleteAllByPageIndexSync(List<int> pageIndexValues) {
    final values = pageIndexValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'pageIndex', values);
  }

  Future<Id> putByPageIndex(PageLayoutDb object) {
    return putByIndex(r'pageIndex', object);
  }

  Id putByPageIndexSync(PageLayoutDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'pageIndex', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPageIndex(List<PageLayoutDb> objects) {
    return putAllByIndex(r'pageIndex', objects);
  }

  List<Id> putAllByPageIndexSync(List<PageLayoutDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'pageIndex', objects, saveLinks: saveLinks);
  }
}

extension PageLayoutDbQueryWhereSort
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QWhere> {
  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhere> anyPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'pageIndex'),
      );
    });
  }
}

extension PageLayoutDbQueryWhere
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QWhereClause> {
  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause> pageIndexEqualTo(
      int pageIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pageIndex',
        value: [pageIndex],
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause>
      pageIndexNotEqualTo(int pageIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageIndex',
              lower: [],
              upper: [pageIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageIndex',
              lower: [pageIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageIndex',
              lower: [pageIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageIndex',
              lower: [],
              upper: [pageIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause>
      pageIndexGreaterThan(
    int pageIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pageIndex',
        lower: [pageIndex],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause> pageIndexLessThan(
    int pageIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pageIndex',
        lower: [],
        upper: [pageIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterWhereClause> pageIndexBetween(
    int lowerPageIndex,
    int upperPageIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pageIndex',
        lower: [lowerPageIndex],
        includeLower: includeLower,
        upper: [upperPageIndex],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PageLayoutDbQueryFilter
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QFilterCondition> {
  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageNames',
        value: '',
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageNames',
        value: '',
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'packageNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'packageNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'packageNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'packageNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'packageNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      packageNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'packageNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      pageIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      pageIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      pageIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterFilterCondition>
      pageIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PageLayoutDbQueryObject
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QFilterCondition> {}

extension PageLayoutDbQueryLinks
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QFilterCondition> {}

extension PageLayoutDbQuerySortBy
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QSortBy> {
  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterSortBy> sortByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageIndex', Sort.asc);
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterSortBy> sortByPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageIndex', Sort.desc);
    });
  }
}

extension PageLayoutDbQuerySortThenBy
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QSortThenBy> {
  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterSortBy> thenByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageIndex', Sort.asc);
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QAfterSortBy> thenByPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageIndex', Sort.desc);
    });
  }
}

extension PageLayoutDbQueryWhereDistinct
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QDistinct> {
  QueryBuilder<PageLayoutDb, PageLayoutDb, QDistinct> distinctByPackageNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageNames');
    });
  }

  QueryBuilder<PageLayoutDb, PageLayoutDb, QDistinct> distinctByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageIndex');
    });
  }
}

extension PageLayoutDbQueryProperty
    on QueryBuilder<PageLayoutDb, PageLayoutDb, QQueryProperty> {
  QueryBuilder<PageLayoutDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PageLayoutDb, List<String>, QQueryOperations>
      packageNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageNames');
    });
  }

  QueryBuilder<PageLayoutDb, int, QQueryOperations> pageIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageIndex');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFolderDbCollection on Isar {
  IsarCollection<FolderDb> get folderDbs => this.collection();
}

const FolderDbSchema = CollectionSchema(
  name: r'FolderDb',
  id: -2672994465490664779,
  properties: {
    r'folderId': PropertySchema(
      id: 0,
      name: r'folderId',
      type: IsarType.string,
    ),
    r'inDock': PropertySchema(
      id: 1,
      name: r'inDock',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'pageIndex': PropertySchema(
      id: 3,
      name: r'pageIndex',
      type: IsarType.long,
    ),
    r'x': PropertySchema(
      id: 4,
      name: r'x',
      type: IsarType.double,
    ),
    r'y': PropertySchema(
      id: 5,
      name: r'y',
      type: IsarType.double,
    )
  },
  estimateSize: _folderDbEstimateSize,
  serialize: _folderDbSerialize,
  deserialize: _folderDbDeserialize,
  deserializeProp: _folderDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'folderId': IndexSchema(
      id: 6340065978996931043,
      name: r'folderId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'folderId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _folderDbGetId,
  getLinks: _folderDbGetLinks,
  attach: _folderDbAttach,
  version: '3.1.0+1',
);

int _folderDbEstimateSize(
  FolderDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.folderId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _folderDbSerialize(
  FolderDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.folderId);
  writer.writeBool(offsets[1], object.inDock);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.pageIndex);
  writer.writeDouble(offsets[4], object.x);
  writer.writeDouble(offsets[5], object.y);
}

FolderDb _folderDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FolderDb();
  object.folderId = reader.readString(offsets[0]);
  object.id = id;
  object.inDock = reader.readBool(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.pageIndex = reader.readLong(offsets[3]);
  object.x = reader.readDouble(offsets[4]);
  object.y = reader.readDouble(offsets[5]);
  return object;
}

P _folderDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _folderDbGetId(FolderDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _folderDbGetLinks(FolderDb object) {
  return [];
}

void _folderDbAttach(IsarCollection<dynamic> col, Id id, FolderDb object) {
  object.id = id;
}

extension FolderDbByIndex on IsarCollection<FolderDb> {
  Future<FolderDb?> getByFolderId(String folderId) {
    return getByIndex(r'folderId', [folderId]);
  }

  FolderDb? getByFolderIdSync(String folderId) {
    return getByIndexSync(r'folderId', [folderId]);
  }

  Future<bool> deleteByFolderId(String folderId) {
    return deleteByIndex(r'folderId', [folderId]);
  }

  bool deleteByFolderIdSync(String folderId) {
    return deleteByIndexSync(r'folderId', [folderId]);
  }

  Future<List<FolderDb?>> getAllByFolderId(List<String> folderIdValues) {
    final values = folderIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'folderId', values);
  }

  List<FolderDb?> getAllByFolderIdSync(List<String> folderIdValues) {
    final values = folderIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'folderId', values);
  }

  Future<int> deleteAllByFolderId(List<String> folderIdValues) {
    final values = folderIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'folderId', values);
  }

  int deleteAllByFolderIdSync(List<String> folderIdValues) {
    final values = folderIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'folderId', values);
  }

  Future<Id> putByFolderId(FolderDb object) {
    return putByIndex(r'folderId', object);
  }

  Id putByFolderIdSync(FolderDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'folderId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFolderId(List<FolderDb> objects) {
    return putAllByIndex(r'folderId', objects);
  }

  List<Id> putAllByFolderIdSync(List<FolderDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'folderId', objects, saveLinks: saveLinks);
  }
}

extension FolderDbQueryWhereSort on QueryBuilder<FolderDb, FolderDb, QWhere> {
  QueryBuilder<FolderDb, FolderDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FolderDbQueryWhere on QueryBuilder<FolderDb, FolderDb, QWhereClause> {
  QueryBuilder<FolderDb, FolderDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterWhereClause> folderIdEqualTo(
      String folderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'folderId',
        value: [folderId],
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterWhereClause> folderIdNotEqualTo(
      String folderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'folderId',
              lower: [],
              upper: [folderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'folderId',
              lower: [folderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'folderId',
              lower: [folderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'folderId',
              lower: [],
              upper: [folderId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FolderDbQueryFilter
    on QueryBuilder<FolderDb, FolderDb, QFilterCondition> {
  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'folderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folderId',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> folderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'folderId',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> inDockEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inDock',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> pageIndexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> pageIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> pageIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> pageIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> xEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> xGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> xLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> xBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'x',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> yEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> yGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> yLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterFilterCondition> yBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'y',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension FolderDbQueryObject
    on QueryBuilder<FolderDb, FolderDb, QFilterCondition> {}

extension FolderDbQueryLinks
    on QueryBuilder<FolderDb, FolderDb, QFilterCondition> {}

extension FolderDbQuerySortBy on QueryBuilder<FolderDb, FolderDb, QSortBy> {
  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByInDock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inDock', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByInDockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inDock', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageIndex', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageIndex', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'x', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'x', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'y', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> sortByYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'y', Sort.desc);
    });
  }
}

extension FolderDbQuerySortThenBy
    on QueryBuilder<FolderDb, FolderDb, QSortThenBy> {
  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByInDock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inDock', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByInDockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inDock', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageIndex', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageIndex', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'x', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'x', Sort.desc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'y', Sort.asc);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QAfterSortBy> thenByYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'y', Sort.desc);
    });
  }
}

extension FolderDbQueryWhereDistinct
    on QueryBuilder<FolderDb, FolderDb, QDistinct> {
  QueryBuilder<FolderDb, FolderDb, QDistinct> distinctByFolderId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QDistinct> distinctByInDock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inDock');
    });
  }

  QueryBuilder<FolderDb, FolderDb, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FolderDb, FolderDb, QDistinct> distinctByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageIndex');
    });
  }

  QueryBuilder<FolderDb, FolderDb, QDistinct> distinctByX() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'x');
    });
  }

  QueryBuilder<FolderDb, FolderDb, QDistinct> distinctByY() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'y');
    });
  }
}

extension FolderDbQueryProperty
    on QueryBuilder<FolderDb, FolderDb, QQueryProperty> {
  QueryBuilder<FolderDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FolderDb, String, QQueryOperations> folderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folderId');
    });
  }

  QueryBuilder<FolderDb, bool, QQueryOperations> inDockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inDock');
    });
  }

  QueryBuilder<FolderDb, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FolderDb, int, QQueryOperations> pageIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageIndex');
    });
  }

  QueryBuilder<FolderDb, double, QQueryOperations> xProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'x');
    });
  }

  QueryBuilder<FolderDb, double, QQueryOperations> yProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'y');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFolderAppDbCollection on Isar {
  IsarCollection<FolderAppDb> get folderAppDbs => this.collection();
}

const FolderAppDbSchema = CollectionSchema(
  name: r'FolderAppDb',
  id: 4018114632738021624,
  properties: {
    r'appName': PropertySchema(
      id: 0,
      name: r'appName',
      type: IsarType.string,
    ),
    r'folderId': PropertySchema(
      id: 1,
      name: r'folderId',
      type: IsarType.string,
    ),
    r'icon': PropertySchema(
      id: 2,
      name: r'icon',
      type: IsarType.longList,
    ),
    r'packageName': PropertySchema(
      id: 3,
      name: r'packageName',
      type: IsarType.string,
    ),
    r'position': PropertySchema(
      id: 4,
      name: r'position',
      type: IsarType.long,
    )
  },
  estimateSize: _folderAppDbEstimateSize,
  serialize: _folderAppDbSerialize,
  deserialize: _folderAppDbDeserialize,
  deserializeProp: _folderAppDbDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _folderAppDbGetId,
  getLinks: _folderAppDbGetLinks,
  attach: _folderAppDbAttach,
  version: '3.1.0+1',
);

int _folderAppDbEstimateSize(
  FolderAppDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appName.length * 3;
  bytesCount += 3 + object.folderId.length * 3;
  bytesCount += 3 + object.icon.length * 8;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _folderAppDbSerialize(
  FolderAppDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appName);
  writer.writeString(offsets[1], object.folderId);
  writer.writeLongList(offsets[2], object.icon);
  writer.writeString(offsets[3], object.packageName);
  writer.writeLong(offsets[4], object.position);
}

FolderAppDb _folderAppDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FolderAppDb();
  object.appName = reader.readString(offsets[0]);
  object.folderId = reader.readString(offsets[1]);
  object.icon = reader.readLongList(offsets[2]) ?? [];
  object.id = id;
  object.packageName = reader.readString(offsets[3]);
  object.position = reader.readLong(offsets[4]);
  return object;
}

P _folderAppDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _folderAppDbGetId(FolderAppDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _folderAppDbGetLinks(FolderAppDb object) {
  return [];
}

void _folderAppDbAttach(
    IsarCollection<dynamic> col, Id id, FolderAppDb object) {
  object.id = id;
}

extension FolderAppDbQueryWhereSort
    on QueryBuilder<FolderAppDb, FolderAppDb, QWhere> {
  QueryBuilder<FolderAppDb, FolderAppDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FolderAppDbQueryWhere
    on QueryBuilder<FolderAppDb, FolderAppDb, QWhereClause> {
  QueryBuilder<FolderAppDb, FolderAppDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FolderAppDbQueryFilter
    on QueryBuilder<FolderAppDb, FolderAppDb, QFilterCondition> {
  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> appNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      appNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> appNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> appNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      appNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> appNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> appNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> appNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      appNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appName',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      appNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appName',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> folderIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      folderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      folderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> folderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      folderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      folderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      folderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'folderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> folderIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'folderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      folderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folderId',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      folderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'folderId',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      iconLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> positionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      positionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition>
      positionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterFilterCondition> positionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FolderAppDbQueryObject
    on QueryBuilder<FolderAppDb, FolderAppDb, QFilterCondition> {}

extension FolderAppDbQueryLinks
    on QueryBuilder<FolderAppDb, FolderAppDb, QFilterCondition> {}

extension FolderAppDbQuerySortBy
    on QueryBuilder<FolderAppDb, FolderAppDb, QSortBy> {
  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> sortByAppName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> sortByAppNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.desc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> sortByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> sortByFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.desc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension FolderAppDbQuerySortThenBy
    on QueryBuilder<FolderAppDb, FolderAppDb, QSortThenBy> {
  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByAppName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByAppNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.desc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.desc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension FolderAppDbQueryWhereDistinct
    on QueryBuilder<FolderAppDb, FolderAppDb, QDistinct> {
  QueryBuilder<FolderAppDb, FolderAppDb, QDistinct> distinctByAppName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QDistinct> distinctByFolderId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QDistinct> distinctByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon');
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QDistinct> distinctByPackageName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FolderAppDb, FolderAppDb, QDistinct> distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }
}

extension FolderAppDbQueryProperty
    on QueryBuilder<FolderAppDb, FolderAppDb, QQueryProperty> {
  QueryBuilder<FolderAppDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FolderAppDb, String, QQueryOperations> appNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appName');
    });
  }

  QueryBuilder<FolderAppDb, String, QQueryOperations> folderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folderId');
    });
  }

  QueryBuilder<FolderAppDb, List<int>, QQueryOperations> iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<FolderAppDb, String, QQueryOperations> packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }

  QueryBuilder<FolderAppDb, int, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecentAppDbCollection on Isar {
  IsarCollection<RecentAppDb> get recentAppDbs => this.collection();
}

const RecentAppDbSchema = CollectionSchema(
  name: r'RecentAppDb',
  id: 1917192517113961573,
  properties: {
    r'appName': PropertySchema(
      id: 0,
      name: r'appName',
      type: IsarType.string,
    ),
    r'icon': PropertySchema(
      id: 1,
      name: r'icon',
      type: IsarType.longList,
    ),
    r'packageName': PropertySchema(
      id: 2,
      name: r'packageName',
      type: IsarType.string,
    ),
    r'position': PropertySchema(
      id: 3,
      name: r'position',
      type: IsarType.long,
    )
  },
  estimateSize: _recentAppDbEstimateSize,
  serialize: _recentAppDbSerialize,
  deserialize: _recentAppDbDeserialize,
  deserializeProp: _recentAppDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'packageName': IndexSchema(
      id: -3211024755902609907,
      name: r'packageName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'packageName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _recentAppDbGetId,
  getLinks: _recentAppDbGetLinks,
  attach: _recentAppDbAttach,
  version: '3.1.0+1',
);

int _recentAppDbEstimateSize(
  RecentAppDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appName.length * 3;
  bytesCount += 3 + object.icon.length * 8;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _recentAppDbSerialize(
  RecentAppDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appName);
  writer.writeLongList(offsets[1], object.icon);
  writer.writeString(offsets[2], object.packageName);
  writer.writeLong(offsets[3], object.position);
}

RecentAppDb _recentAppDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecentAppDb();
  object.appName = reader.readString(offsets[0]);
  object.icon = reader.readLongList(offsets[1]) ?? [];
  object.id = id;
  object.packageName = reader.readString(offsets[2]);
  object.position = reader.readLong(offsets[3]);
  return object;
}

P _recentAppDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recentAppDbGetId(RecentAppDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recentAppDbGetLinks(RecentAppDb object) {
  return [];
}

void _recentAppDbAttach(
    IsarCollection<dynamic> col, Id id, RecentAppDb object) {
  object.id = id;
}

extension RecentAppDbByIndex on IsarCollection<RecentAppDb> {
  Future<RecentAppDb?> getByPackageName(String packageName) {
    return getByIndex(r'packageName', [packageName]);
  }

  RecentAppDb? getByPackageNameSync(String packageName) {
    return getByIndexSync(r'packageName', [packageName]);
  }

  Future<bool> deleteByPackageName(String packageName) {
    return deleteByIndex(r'packageName', [packageName]);
  }

  bool deleteByPackageNameSync(String packageName) {
    return deleteByIndexSync(r'packageName', [packageName]);
  }

  Future<List<RecentAppDb?>> getAllByPackageName(
      List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'packageName', values);
  }

  List<RecentAppDb?> getAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'packageName', values);
  }

  Future<int> deleteAllByPackageName(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'packageName', values);
  }

  int deleteAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'packageName', values);
  }

  Future<Id> putByPackageName(RecentAppDb object) {
    return putByIndex(r'packageName', object);
  }

  Id putByPackageNameSync(RecentAppDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'packageName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPackageName(List<RecentAppDb> objects) {
    return putAllByIndex(r'packageName', objects);
  }

  List<Id> putAllByPackageNameSync(List<RecentAppDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'packageName', objects, saveLinks: saveLinks);
  }
}

extension RecentAppDbQueryWhereSort
    on QueryBuilder<RecentAppDb, RecentAppDb, QWhere> {
  QueryBuilder<RecentAppDb, RecentAppDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecentAppDbQueryWhere
    on QueryBuilder<RecentAppDb, RecentAppDb, QWhereClause> {
  QueryBuilder<RecentAppDb, RecentAppDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterWhereClause> packageNameEqualTo(
      String packageName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'packageName',
        value: [packageName],
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterWhereClause>
      packageNameNotEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RecentAppDbQueryFilter
    on QueryBuilder<RecentAppDb, RecentAppDb, QFilterCondition> {
  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> appNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      appNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> appNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> appNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      appNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> appNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> appNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> appNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      appNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appName',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      appNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appName',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      iconLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'icon',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> positionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      positionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition>
      positionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterFilterCondition> positionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RecentAppDbQueryObject
    on QueryBuilder<RecentAppDb, RecentAppDb, QFilterCondition> {}

extension RecentAppDbQueryLinks
    on QueryBuilder<RecentAppDb, RecentAppDb, QFilterCondition> {}

extension RecentAppDbQuerySortBy
    on QueryBuilder<RecentAppDb, RecentAppDb, QSortBy> {
  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> sortByAppName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.asc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> sortByAppNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.desc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension RecentAppDbQuerySortThenBy
    on QueryBuilder<RecentAppDb, RecentAppDb, QSortThenBy> {
  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> thenByAppName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.asc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> thenByAppNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appName', Sort.desc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension RecentAppDbQueryWhereDistinct
    on QueryBuilder<RecentAppDb, RecentAppDb, QDistinct> {
  QueryBuilder<RecentAppDb, RecentAppDb, QDistinct> distinctByAppName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QDistinct> distinctByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon');
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QDistinct> distinctByPackageName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentAppDb, RecentAppDb, QDistinct> distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }
}

extension RecentAppDbQueryProperty
    on QueryBuilder<RecentAppDb, RecentAppDb, QQueryProperty> {
  QueryBuilder<RecentAppDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecentAppDb, String, QQueryOperations> appNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appName');
    });
  }

  QueryBuilder<RecentAppDb, List<int>, QQueryOperations> iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<RecentAppDb, String, QQueryOperations> packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }

  QueryBuilder<RecentAppDb, int, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCustomAppNameDbCollection on Isar {
  IsarCollection<CustomAppNameDb> get customAppNameDbs => this.collection();
}

const CustomAppNameDbSchema = CollectionSchema(
  name: r'CustomAppNameDb',
  id: -4761565340618534775,
  properties: {
    r'customName': PropertySchema(
      id: 0,
      name: r'customName',
      type: IsarType.string,
    ),
    r'packageName': PropertySchema(
      id: 1,
      name: r'packageName',
      type: IsarType.string,
    )
  },
  estimateSize: _customAppNameDbEstimateSize,
  serialize: _customAppNameDbSerialize,
  deserialize: _customAppNameDbDeserialize,
  deserializeProp: _customAppNameDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'packageName': IndexSchema(
      id: -3211024755902609907,
      name: r'packageName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'packageName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _customAppNameDbGetId,
  getLinks: _customAppNameDbGetLinks,
  attach: _customAppNameDbAttach,
  version: '3.1.0+1',
);

int _customAppNameDbEstimateSize(
  CustomAppNameDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.customName.length * 3;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _customAppNameDbSerialize(
  CustomAppNameDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.customName);
  writer.writeString(offsets[1], object.packageName);
}

CustomAppNameDb _customAppNameDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomAppNameDb();
  object.customName = reader.readString(offsets[0]);
  object.id = id;
  object.packageName = reader.readString(offsets[1]);
  return object;
}

P _customAppNameDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _customAppNameDbGetId(CustomAppNameDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _customAppNameDbGetLinks(CustomAppNameDb object) {
  return [];
}

void _customAppNameDbAttach(
    IsarCollection<dynamic> col, Id id, CustomAppNameDb object) {
  object.id = id;
}

extension CustomAppNameDbByIndex on IsarCollection<CustomAppNameDb> {
  Future<CustomAppNameDb?> getByPackageName(String packageName) {
    return getByIndex(r'packageName', [packageName]);
  }

  CustomAppNameDb? getByPackageNameSync(String packageName) {
    return getByIndexSync(r'packageName', [packageName]);
  }

  Future<bool> deleteByPackageName(String packageName) {
    return deleteByIndex(r'packageName', [packageName]);
  }

  bool deleteByPackageNameSync(String packageName) {
    return deleteByIndexSync(r'packageName', [packageName]);
  }

  Future<List<CustomAppNameDb?>> getAllByPackageName(
      List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'packageName', values);
  }

  List<CustomAppNameDb?> getAllByPackageNameSync(
      List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'packageName', values);
  }

  Future<int> deleteAllByPackageName(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'packageName', values);
  }

  int deleteAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'packageName', values);
  }

  Future<Id> putByPackageName(CustomAppNameDb object) {
    return putByIndex(r'packageName', object);
  }

  Id putByPackageNameSync(CustomAppNameDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'packageName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPackageName(List<CustomAppNameDb> objects) {
    return putAllByIndex(r'packageName', objects);
  }

  List<Id> putAllByPackageNameSync(List<CustomAppNameDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'packageName', objects, saveLinks: saveLinks);
  }
}

extension CustomAppNameDbQueryWhereSort
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QWhere> {
  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CustomAppNameDbQueryWhere
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QWhereClause> {
  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterWhereClause>
      packageNameEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'packageName',
        value: [packageName],
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterWhereClause>
      packageNameNotEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CustomAppNameDbQueryFilter
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QFilterCondition> {
  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      customNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }
}

extension CustomAppNameDbQueryObject
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QFilterCondition> {}

extension CustomAppNameDbQueryLinks
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QFilterCondition> {}

extension CustomAppNameDbQuerySortBy
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QSortBy> {
  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy>
      sortByCustomName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.asc);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy>
      sortByCustomNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.desc);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy>
      sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy>
      sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }
}

extension CustomAppNameDbQuerySortThenBy
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QSortThenBy> {
  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy>
      thenByCustomName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.asc);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy>
      thenByCustomNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.desc);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy>
      thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QAfterSortBy>
      thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }
}

extension CustomAppNameDbQueryWhereDistinct
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QDistinct> {
  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QDistinct>
      distinctByCustomName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomAppNameDb, CustomAppNameDb, QDistinct>
      distinctByPackageName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }
}

extension CustomAppNameDbQueryProperty
    on QueryBuilder<CustomAppNameDb, CustomAppNameDb, QQueryProperty> {
  QueryBuilder<CustomAppNameDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CustomAppNameDb, String, QQueryOperations> customNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customName');
    });
  }

  QueryBuilder<CustomAppNameDb, String, QQueryOperations>
      packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIconPackDbCollection on Isar {
  IsarCollection<IconPackDb> get iconPackDbs => this.collection();
}

const IconPackDbSchema = CollectionSchema(
  name: r'IconPackDb',
  id: -6292859978061545034,
  properties: {
    r'selectedPackLabel': PropertySchema(
      id: 0,
      name: r'selectedPackLabel',
      type: IsarType.string,
    ),
    r'selectedPackageName': PropertySchema(
      id: 1,
      name: r'selectedPackageName',
      type: IsarType.string,
    )
  },
  estimateSize: _iconPackDbEstimateSize,
  serialize: _iconPackDbSerialize,
  deserialize: _iconPackDbDeserialize,
  deserializeProp: _iconPackDbDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _iconPackDbGetId,
  getLinks: _iconPackDbGetLinks,
  attach: _iconPackDbAttach,
  version: '3.1.0+1',
);

int _iconPackDbEstimateSize(
  IconPackDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.selectedPackLabel.length * 3;
  bytesCount += 3 + object.selectedPackageName.length * 3;
  return bytesCount;
}

void _iconPackDbSerialize(
  IconPackDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.selectedPackLabel);
  writer.writeString(offsets[1], object.selectedPackageName);
}

IconPackDb _iconPackDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IconPackDb();
  object.id = id;
  object.selectedPackLabel = reader.readString(offsets[0]);
  object.selectedPackageName = reader.readString(offsets[1]);
  return object;
}

P _iconPackDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _iconPackDbGetId(IconPackDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _iconPackDbGetLinks(IconPackDb object) {
  return [];
}

void _iconPackDbAttach(IsarCollection<dynamic> col, Id id, IconPackDb object) {
  object.id = id;
}

extension IconPackDbQueryWhereSort
    on QueryBuilder<IconPackDb, IconPackDb, QWhere> {
  QueryBuilder<IconPackDb, IconPackDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IconPackDbQueryWhere
    on QueryBuilder<IconPackDb, IconPackDb, QWhereClause> {
  QueryBuilder<IconPackDb, IconPackDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IconPackDbQueryFilter
    on QueryBuilder<IconPackDb, IconPackDb, QFilterCondition> {
  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedPackLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedPackLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedPackLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedPackLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedPackLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedPackLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedPackLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedPackLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedPackLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedPackLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedPackageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedPackageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedPackageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedPackageName',
        value: '',
      ));
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterFilterCondition>
      selectedPackageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedPackageName',
        value: '',
      ));
    });
  }
}

extension IconPackDbQueryObject
    on QueryBuilder<IconPackDb, IconPackDb, QFilterCondition> {}

extension IconPackDbQueryLinks
    on QueryBuilder<IconPackDb, IconPackDb, QFilterCondition> {}

extension IconPackDbQuerySortBy
    on QueryBuilder<IconPackDb, IconPackDb, QSortBy> {
  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy> sortBySelectedPackLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPackLabel', Sort.asc);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy>
      sortBySelectedPackLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPackLabel', Sort.desc);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy>
      sortBySelectedPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPackageName', Sort.asc);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy>
      sortBySelectedPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPackageName', Sort.desc);
    });
  }
}

extension IconPackDbQuerySortThenBy
    on QueryBuilder<IconPackDb, IconPackDb, QSortThenBy> {
  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy> thenBySelectedPackLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPackLabel', Sort.asc);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy>
      thenBySelectedPackLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPackLabel', Sort.desc);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy>
      thenBySelectedPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPackageName', Sort.asc);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QAfterSortBy>
      thenBySelectedPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPackageName', Sort.desc);
    });
  }
}

extension IconPackDbQueryWhereDistinct
    on QueryBuilder<IconPackDb, IconPackDb, QDistinct> {
  QueryBuilder<IconPackDb, IconPackDb, QDistinct> distinctBySelectedPackLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedPackLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IconPackDb, IconPackDb, QDistinct> distinctBySelectedPackageName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedPackageName',
          caseSensitive: caseSensitive);
    });
  }
}

extension IconPackDbQueryProperty
    on QueryBuilder<IconPackDb, IconPackDb, QQueryProperty> {
  QueryBuilder<IconPackDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IconPackDb, String, QQueryOperations>
      selectedPackLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedPackLabel');
    });
  }

  QueryBuilder<IconPackDb, String, QQueryOperations>
      selectedPackageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedPackageName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOnboardingDbCollection on Isar {
  IsarCollection<OnboardingDb> get onboardingDbs => this.collection();
}

const OnboardingDbSchema = CollectionSchema(
  name: r'OnboardingDb',
  id: 4930647531332821210,
  properties: {
    r'hasOnboarded': PropertySchema(
      id: 0,
      name: r'hasOnboarded',
      type: IsarType.bool,
    )
  },
  estimateSize: _onboardingDbEstimateSize,
  serialize: _onboardingDbSerialize,
  deserialize: _onboardingDbDeserialize,
  deserializeProp: _onboardingDbDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _onboardingDbGetId,
  getLinks: _onboardingDbGetLinks,
  attach: _onboardingDbAttach,
  version: '3.1.0+1',
);

int _onboardingDbEstimateSize(
  OnboardingDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _onboardingDbSerialize(
  OnboardingDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.hasOnboarded);
}

OnboardingDb _onboardingDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OnboardingDb();
  object.hasOnboarded = reader.readBool(offsets[0]);
  object.id = id;
  return object;
}

P _onboardingDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _onboardingDbGetId(OnboardingDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _onboardingDbGetLinks(OnboardingDb object) {
  return [];
}

void _onboardingDbAttach(
    IsarCollection<dynamic> col, Id id, OnboardingDb object) {
  object.id = id;
}

extension OnboardingDbQueryWhereSort
    on QueryBuilder<OnboardingDb, OnboardingDb, QWhere> {
  QueryBuilder<OnboardingDb, OnboardingDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OnboardingDbQueryWhere
    on QueryBuilder<OnboardingDb, OnboardingDb, QWhereClause> {
  QueryBuilder<OnboardingDb, OnboardingDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OnboardingDbQueryFilter
    on QueryBuilder<OnboardingDb, OnboardingDb, QFilterCondition> {
  QueryBuilder<OnboardingDb, OnboardingDb, QAfterFilterCondition>
      hasOnboardedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasOnboarded',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OnboardingDbQueryObject
    on QueryBuilder<OnboardingDb, OnboardingDb, QFilterCondition> {}

extension OnboardingDbQueryLinks
    on QueryBuilder<OnboardingDb, OnboardingDb, QFilterCondition> {}

extension OnboardingDbQuerySortBy
    on QueryBuilder<OnboardingDb, OnboardingDb, QSortBy> {
  QueryBuilder<OnboardingDb, OnboardingDb, QAfterSortBy> sortByHasOnboarded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasOnboarded', Sort.asc);
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterSortBy>
      sortByHasOnboardedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasOnboarded', Sort.desc);
    });
  }
}

extension OnboardingDbQuerySortThenBy
    on QueryBuilder<OnboardingDb, OnboardingDb, QSortThenBy> {
  QueryBuilder<OnboardingDb, OnboardingDb, QAfterSortBy> thenByHasOnboarded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasOnboarded', Sort.asc);
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterSortBy>
      thenByHasOnboardedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasOnboarded', Sort.desc);
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OnboardingDb, OnboardingDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension OnboardingDbQueryWhereDistinct
    on QueryBuilder<OnboardingDb, OnboardingDb, QDistinct> {
  QueryBuilder<OnboardingDb, OnboardingDb, QDistinct> distinctByHasOnboarded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasOnboarded');
    });
  }
}

extension OnboardingDbQueryProperty
    on QueryBuilder<OnboardingDb, OnboardingDb, QQueryProperty> {
  QueryBuilder<OnboardingDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OnboardingDb, bool, QQueryOperations> hasOnboardedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasOnboarded');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStarredAppDbCollection on Isar {
  IsarCollection<StarredAppDb> get starredAppDbs => this.collection();
}

const StarredAppDbSchema = CollectionSchema(
  name: r'StarredAppDb',
  id: -4728369602037383409,
  properties: {
    r'packageName': PropertySchema(
      id: 0,
      name: r'packageName',
      type: IsarType.string,
    ),
    r'position': PropertySchema(
      id: 1,
      name: r'position',
      type: IsarType.long,
    )
  },
  estimateSize: _starredAppDbEstimateSize,
  serialize: _starredAppDbSerialize,
  deserialize: _starredAppDbDeserialize,
  deserializeProp: _starredAppDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'packageName': IndexSchema(
      id: -3211024755902609907,
      name: r'packageName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'packageName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _starredAppDbGetId,
  getLinks: _starredAppDbGetLinks,
  attach: _starredAppDbAttach,
  version: '3.1.0+1',
);

int _starredAppDbEstimateSize(
  StarredAppDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _starredAppDbSerialize(
  StarredAppDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.packageName);
  writer.writeLong(offsets[1], object.position);
}

StarredAppDb _starredAppDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StarredAppDb();
  object.id = id;
  object.packageName = reader.readString(offsets[0]);
  object.position = reader.readLong(offsets[1]);
  return object;
}

P _starredAppDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _starredAppDbGetId(StarredAppDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _starredAppDbGetLinks(StarredAppDb object) {
  return [];
}

void _starredAppDbAttach(
    IsarCollection<dynamic> col, Id id, StarredAppDb object) {
  object.id = id;
}

extension StarredAppDbByIndex on IsarCollection<StarredAppDb> {
  Future<StarredAppDb?> getByPackageName(String packageName) {
    return getByIndex(r'packageName', [packageName]);
  }

  StarredAppDb? getByPackageNameSync(String packageName) {
    return getByIndexSync(r'packageName', [packageName]);
  }

  Future<bool> deleteByPackageName(String packageName) {
    return deleteByIndex(r'packageName', [packageName]);
  }

  bool deleteByPackageNameSync(String packageName) {
    return deleteByIndexSync(r'packageName', [packageName]);
  }

  Future<List<StarredAppDb?>> getAllByPackageName(
      List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'packageName', values);
  }

  List<StarredAppDb?> getAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'packageName', values);
  }

  Future<int> deleteAllByPackageName(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'packageName', values);
  }

  int deleteAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'packageName', values);
  }

  Future<Id> putByPackageName(StarredAppDb object) {
    return putByIndex(r'packageName', object);
  }

  Id putByPackageNameSync(StarredAppDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'packageName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPackageName(List<StarredAppDb> objects) {
    return putAllByIndex(r'packageName', objects);
  }

  List<Id> putAllByPackageNameSync(List<StarredAppDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'packageName', objects, saveLinks: saveLinks);
  }
}

extension StarredAppDbQueryWhereSort
    on QueryBuilder<StarredAppDb, StarredAppDb, QWhere> {
  QueryBuilder<StarredAppDb, StarredAppDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StarredAppDbQueryWhere
    on QueryBuilder<StarredAppDb, StarredAppDb, QWhereClause> {
  QueryBuilder<StarredAppDb, StarredAppDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterWhereClause>
      packageNameEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'packageName',
        value: [packageName],
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterWhereClause>
      packageNameNotEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension StarredAppDbQueryFilter
    on QueryBuilder<StarredAppDb, StarredAppDb, QFilterCondition> {
  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      positionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      positionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      positionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterFilterCondition>
      positionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StarredAppDbQueryObject
    on QueryBuilder<StarredAppDb, StarredAppDb, QFilterCondition> {}

extension StarredAppDbQueryLinks
    on QueryBuilder<StarredAppDb, StarredAppDb, QFilterCondition> {}

extension StarredAppDbQuerySortBy
    on QueryBuilder<StarredAppDb, StarredAppDb, QSortBy> {
  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy> sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy>
      sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension StarredAppDbQuerySortThenBy
    on QueryBuilder<StarredAppDb, StarredAppDb, QSortThenBy> {
  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy> thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy>
      thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }
}

extension StarredAppDbQueryWhereDistinct
    on QueryBuilder<StarredAppDb, StarredAppDb, QDistinct> {
  QueryBuilder<StarredAppDb, StarredAppDb, QDistinct> distinctByPackageName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StarredAppDb, StarredAppDb, QDistinct> distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }
}

extension StarredAppDbQueryProperty
    on QueryBuilder<StarredAppDb, StarredAppDb, QQueryProperty> {
  QueryBuilder<StarredAppDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StarredAppDb, String, QQueryOperations> packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }

  QueryBuilder<StarredAppDb, int, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeatherCacheDbCollection on Isar {
  IsarCollection<WeatherCacheDb> get weatherCacheDbs => this.collection();
}

const WeatherCacheDbSchema = CollectionSchema(
  name: r'WeatherCacheDb',
  id: 2954648514871894258,
  properties: {
    r'city': PropertySchema(
      id: 0,
      name: r'city',
      type: IsarType.string,
    ),
    r'condition': PropertySchema(
      id: 1,
      name: r'condition',
      type: IsarType.string,
    ),
    r'conditionCode': PropertySchema(
      id: 2,
      name: r'conditionCode',
      type: IsarType.string,
    ),
    r'lastFetched': PropertySchema(
      id: 3,
      name: r'lastFetched',
      type: IsarType.dateTime,
    ),
    r'temperature': PropertySchema(
      id: 4,
      name: r'temperature',
      type: IsarType.double,
    )
  },
  estimateSize: _weatherCacheDbEstimateSize,
  serialize: _weatherCacheDbSerialize,
  deserialize: _weatherCacheDbDeserialize,
  deserializeProp: _weatherCacheDbDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _weatherCacheDbGetId,
  getLinks: _weatherCacheDbGetLinks,
  attach: _weatherCacheDbAttach,
  version: '3.1.0+1',
);

int _weatherCacheDbEstimateSize(
  WeatherCacheDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.city.length * 3;
  bytesCount += 3 + object.condition.length * 3;
  bytesCount += 3 + object.conditionCode.length * 3;
  return bytesCount;
}

void _weatherCacheDbSerialize(
  WeatherCacheDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.city);
  writer.writeString(offsets[1], object.condition);
  writer.writeString(offsets[2], object.conditionCode);
  writer.writeDateTime(offsets[3], object.lastFetched);
  writer.writeDouble(offsets[4], object.temperature);
}

WeatherCacheDb _weatherCacheDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeatherCacheDb();
  object.city = reader.readString(offsets[0]);
  object.condition = reader.readString(offsets[1]);
  object.conditionCode = reader.readString(offsets[2]);
  object.id = id;
  object.lastFetched = reader.readDateTime(offsets[3]);
  object.temperature = reader.readDouble(offsets[4]);
  return object;
}

P _weatherCacheDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weatherCacheDbGetId(WeatherCacheDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weatherCacheDbGetLinks(WeatherCacheDb object) {
  return [];
}

void _weatherCacheDbAttach(
    IsarCollection<dynamic> col, Id id, WeatherCacheDb object) {
  object.id = id;
}

extension WeatherCacheDbQueryWhereSort
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QWhere> {
  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WeatherCacheDbQueryWhere
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QWhereClause> {
  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeatherCacheDbQueryFilter
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QFilterCondition> {
  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'condition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'condition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'condition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'condition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'condition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'condition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'condition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'condition',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'condition',
        value: '',
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'condition',
        value: '',
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'conditionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'conditionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'conditionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'conditionCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'conditionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'conditionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'conditionCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'conditionCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'conditionCode',
        value: '',
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      conditionCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'conditionCode',
        value: '',
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      lastFetchedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      lastFetchedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      lastFetchedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      lastFetchedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFetched',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      temperatureEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      temperatureGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      temperatureLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterFilterCondition>
      temperatureBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'temperature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension WeatherCacheDbQueryObject
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QFilterCondition> {}

extension WeatherCacheDbQueryLinks
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QFilterCondition> {}

extension WeatherCacheDbQuerySortBy
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QSortBy> {
  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy> sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy> sortByCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      sortByConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      sortByConditionCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conditionCode', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      sortByConditionCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conditionCode', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      sortByLastFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetched', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      sortByLastFetchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetched', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      sortByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      sortByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }
}

extension WeatherCacheDbQuerySortThenBy
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QSortThenBy> {
  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy> thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy> thenByCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      thenByConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      thenByConditionCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conditionCode', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      thenByConditionCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conditionCode', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      thenByLastFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetched', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      thenByLastFetchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetched', Sort.desc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      thenByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QAfterSortBy>
      thenByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }
}

extension WeatherCacheDbQueryWhereDistinct
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QDistinct> {
  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QDistinct> distinctByCondition(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'condition', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QDistinct>
      distinctByConditionCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'conditionCode',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QDistinct>
      distinctByLastFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFetched');
    });
  }

  QueryBuilder<WeatherCacheDb, WeatherCacheDb, QDistinct>
      distinctByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'temperature');
    });
  }
}

extension WeatherCacheDbQueryProperty
    on QueryBuilder<WeatherCacheDb, WeatherCacheDb, QQueryProperty> {
  QueryBuilder<WeatherCacheDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeatherCacheDb, String, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<WeatherCacheDb, String, QQueryOperations> conditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'condition');
    });
  }

  QueryBuilder<WeatherCacheDb, String, QQueryOperations>
      conditionCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'conditionCode');
    });
  }

  QueryBuilder<WeatherCacheDb, DateTime, QQueryOperations>
      lastFetchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFetched');
    });
  }

  QueryBuilder<WeatherCacheDb, double, QQueryOperations> temperatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'temperature');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHomeWidgetDbCollection on Isar {
  IsarCollection<HomeWidgetDb> get homeWidgetDbs => this.collection();
}

const HomeWidgetDbSchema = CollectionSchema(
  name: r'HomeWidgetDb',
  id: -1784676009397706744,
  properties: {
    r'appWidgetId': PropertySchema(
      id: 0,
      name: r'appWidgetId',
      type: IsarType.long,
    ),
    r'label': PropertySchema(
      id: 1,
      name: r'label',
      type: IsarType.string,
    ),
    r'minHeight': PropertySchema(
      id: 2,
      name: r'minHeight',
      type: IsarType.long,
    ),
    r'minWidth': PropertySchema(
      id: 3,
      name: r'minWidth',
      type: IsarType.long,
    ),
    r'position': PropertySchema(
      id: 4,
      name: r'position',
      type: IsarType.long,
    ),
    r'providerClass': PropertySchema(
      id: 5,
      name: r'providerClass',
      type: IsarType.string,
    ),
    r'providerPackage': PropertySchema(
      id: 6,
      name: r'providerPackage',
      type: IsarType.string,
    )
  },
  estimateSize: _homeWidgetDbEstimateSize,
  serialize: _homeWidgetDbSerialize,
  deserialize: _homeWidgetDbDeserialize,
  deserializeProp: _homeWidgetDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'appWidgetId': IndexSchema(
      id: 5958672586778374851,
      name: r'appWidgetId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'appWidgetId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _homeWidgetDbGetId,
  getLinks: _homeWidgetDbGetLinks,
  attach: _homeWidgetDbAttach,
  version: '3.1.0+1',
);

int _homeWidgetDbEstimateSize(
  HomeWidgetDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.providerClass.length * 3;
  bytesCount += 3 + object.providerPackage.length * 3;
  return bytesCount;
}

void _homeWidgetDbSerialize(
  HomeWidgetDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.appWidgetId);
  writer.writeString(offsets[1], object.label);
  writer.writeLong(offsets[2], object.minHeight);
  writer.writeLong(offsets[3], object.minWidth);
  writer.writeLong(offsets[4], object.position);
  writer.writeString(offsets[5], object.providerClass);
  writer.writeString(offsets[6], object.providerPackage);
}

HomeWidgetDb _homeWidgetDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HomeWidgetDb();
  object.appWidgetId = reader.readLong(offsets[0]);
  object.id = id;
  object.label = reader.readString(offsets[1]);
  object.minHeight = reader.readLong(offsets[2]);
  object.minWidth = reader.readLong(offsets[3]);
  object.position = reader.readLong(offsets[4]);
  object.providerClass = reader.readString(offsets[5]);
  object.providerPackage = reader.readString(offsets[6]);
  return object;
}

P _homeWidgetDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _homeWidgetDbGetId(HomeWidgetDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _homeWidgetDbGetLinks(HomeWidgetDb object) {
  return [];
}

void _homeWidgetDbAttach(
    IsarCollection<dynamic> col, Id id, HomeWidgetDb object) {
  object.id = id;
}

extension HomeWidgetDbByIndex on IsarCollection<HomeWidgetDb> {
  Future<HomeWidgetDb?> getByAppWidgetId(int appWidgetId) {
    return getByIndex(r'appWidgetId', [appWidgetId]);
  }

  HomeWidgetDb? getByAppWidgetIdSync(int appWidgetId) {
    return getByIndexSync(r'appWidgetId', [appWidgetId]);
  }

  Future<bool> deleteByAppWidgetId(int appWidgetId) {
    return deleteByIndex(r'appWidgetId', [appWidgetId]);
  }

  bool deleteByAppWidgetIdSync(int appWidgetId) {
    return deleteByIndexSync(r'appWidgetId', [appWidgetId]);
  }

  Future<List<HomeWidgetDb?>> getAllByAppWidgetId(List<int> appWidgetIdValues) {
    final values = appWidgetIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'appWidgetId', values);
  }

  List<HomeWidgetDb?> getAllByAppWidgetIdSync(List<int> appWidgetIdValues) {
    final values = appWidgetIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'appWidgetId', values);
  }

  Future<int> deleteAllByAppWidgetId(List<int> appWidgetIdValues) {
    final values = appWidgetIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'appWidgetId', values);
  }

  int deleteAllByAppWidgetIdSync(List<int> appWidgetIdValues) {
    final values = appWidgetIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'appWidgetId', values);
  }

  Future<Id> putByAppWidgetId(HomeWidgetDb object) {
    return putByIndex(r'appWidgetId', object);
  }

  Id putByAppWidgetIdSync(HomeWidgetDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'appWidgetId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAppWidgetId(List<HomeWidgetDb> objects) {
    return putAllByIndex(r'appWidgetId', objects);
  }

  List<Id> putAllByAppWidgetIdSync(List<HomeWidgetDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'appWidgetId', objects, saveLinks: saveLinks);
  }
}

extension HomeWidgetDbQueryWhereSort
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QWhere> {
  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhere> anyAppWidgetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'appWidgetId'),
      );
    });
  }
}

extension HomeWidgetDbQueryWhere
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QWhereClause> {
  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause>
      appWidgetIdEqualTo(int appWidgetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'appWidgetId',
        value: [appWidgetId],
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause>
      appWidgetIdNotEqualTo(int appWidgetId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'appWidgetId',
              lower: [],
              upper: [appWidgetId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'appWidgetId',
              lower: [appWidgetId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'appWidgetId',
              lower: [appWidgetId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'appWidgetId',
              lower: [],
              upper: [appWidgetId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause>
      appWidgetIdGreaterThan(
    int appWidgetId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'appWidgetId',
        lower: [appWidgetId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause>
      appWidgetIdLessThan(
    int appWidgetId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'appWidgetId',
        lower: [],
        upper: [appWidgetId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterWhereClause>
      appWidgetIdBetween(
    int lowerAppWidgetId,
    int upperAppWidgetId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'appWidgetId',
        lower: [lowerAppWidgetId],
        includeLower: includeLower,
        upper: [upperAppWidgetId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HomeWidgetDbQueryFilter
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QFilterCondition> {
  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      appWidgetIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appWidgetId',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      appWidgetIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appWidgetId',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      appWidgetIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appWidgetId',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      appWidgetIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appWidgetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> labelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition> labelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      minHeightEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minHeight',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      minHeightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minHeight',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      minHeightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minHeight',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      minHeightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minHeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      minWidthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      minWidthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      minWidthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minWidth',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      minWidthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      positionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      positionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      positionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      positionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerClass',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'providerClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'providerClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'providerClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'providerClass',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerClass',
        value: '',
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerClassIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providerClass',
        value: '',
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerPackage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'providerPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'providerPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'providerPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'providerPackage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerPackage',
        value: '',
      ));
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterFilterCondition>
      providerPackageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providerPackage',
        value: '',
      ));
    });
  }
}

extension HomeWidgetDbQueryObject
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QFilterCondition> {}

extension HomeWidgetDbQueryLinks
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QFilterCondition> {}

extension HomeWidgetDbQuerySortBy
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QSortBy> {
  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByAppWidgetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appWidgetId', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy>
      sortByAppWidgetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appWidgetId', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByMinHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minHeight', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByMinHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minHeight', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByMinWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minWidth', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByMinWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minWidth', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> sortByProviderClass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerClass', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy>
      sortByProviderClassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerClass', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy>
      sortByProviderPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerPackage', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy>
      sortByProviderPackageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerPackage', Sort.desc);
    });
  }
}

extension HomeWidgetDbQuerySortThenBy
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QSortThenBy> {
  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByAppWidgetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appWidgetId', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy>
      thenByAppWidgetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appWidgetId', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByMinHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minHeight', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByMinHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minHeight', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByMinWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minWidth', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByMinWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minWidth', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy> thenByProviderClass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerClass', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy>
      thenByProviderClassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerClass', Sort.desc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy>
      thenByProviderPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerPackage', Sort.asc);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QAfterSortBy>
      thenByProviderPackageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerPackage', Sort.desc);
    });
  }
}

extension HomeWidgetDbQueryWhereDistinct
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QDistinct> {
  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QDistinct> distinctByAppWidgetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appWidgetId');
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QDistinct> distinctByMinHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minHeight');
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QDistinct> distinctByMinWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minWidth');
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QDistinct> distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QDistinct> distinctByProviderClass(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerClass',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HomeWidgetDb, HomeWidgetDb, QDistinct> distinctByProviderPackage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerPackage',
          caseSensitive: caseSensitive);
    });
  }
}

extension HomeWidgetDbQueryProperty
    on QueryBuilder<HomeWidgetDb, HomeWidgetDb, QQueryProperty> {
  QueryBuilder<HomeWidgetDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HomeWidgetDb, int, QQueryOperations> appWidgetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appWidgetId');
    });
  }

  QueryBuilder<HomeWidgetDb, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<HomeWidgetDb, int, QQueryOperations> minHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minHeight');
    });
  }

  QueryBuilder<HomeWidgetDb, int, QQueryOperations> minWidthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minWidth');
    });
  }

  QueryBuilder<HomeWidgetDb, int, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }

  QueryBuilder<HomeWidgetDb, String, QQueryOperations> providerClassProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerClass');
    });
  }

  QueryBuilder<HomeWidgetDb, String, QQueryOperations>
      providerPackageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerPackage');
    });
  }
}
