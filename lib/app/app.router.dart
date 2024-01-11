// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i11;
import 'package:flutter/material.dart' as _i10;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i12;
import 'package:test_blu/ui/views/data_view/data_view_view.dart' as _i5;
import 'package:test_blu/ui/views/home/home_view.dart' as _i2;
import 'package:test_blu/ui/views/locatio_id/locatio_id_view.dart' as _i7;
import 'package:test_blu/ui/views/login/login_view.dart' as _i8;
import 'package:test_blu/ui/views/startup/startup_view.dart' as _i3;
import 'package:test_blu/ui/views/test_page/test_page_view.dart' as _i4;
import 'package:test_blu/ui/views/thermal_print/thermal_print_view.dart' as _i9;
import 'package:test_blu/ui/views/weight/weight_view.dart' as _i6;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const testPageView = '/test-page-view';

  static const dataViewView = '/data-view-view';

  static const weightView = '/weight-view';

  static const locatioIdView = '/locatio-id-view';

  static const loginView = '/login-view';

  static const thermalPrintView = '/thermal-print-view';

  static const all = <String>{
    homeView,
    startupView,
    testPageView,
    dataViewView,
    weightView,
    locatioIdView,
    loginView,
    thermalPrintView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.testPageView,
      page: _i4.TestPageView,
    ),
    _i1.RouteDef(
      Routes.dataViewView,
      page: _i5.DataViewView,
    ),
    _i1.RouteDef(
      Routes.weightView,
      page: _i6.WeightView,
    ),
    _i1.RouteDef(
      Routes.locatioIdView,
      page: _i7.LocatioIdView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i8.LoginView,
    ),
    _i1.RouteDef(
      Routes.thermalPrintView,
      page: _i9.ThermalPrintView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.StartupView(),
        settings: data,
      );
    },
    _i4.TestPageView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.TestPageView(),
        settings: data,
      );
    },
    _i5.DataViewView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.DataViewView(),
        settings: data,
      );
    },
    _i6.WeightView: (data) {
      final args = data.getArgs<WeightViewArguments>(nullOk: false);
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i6.WeightView(args.isPrintButtonVisible, key: args.key),
        settings: data,
      );
    },
    _i7.LocatioIdView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.LocatioIdView(),
        settings: data,
      );
    },
    _i8.LoginView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.LoginView(),
        settings: data,
      );
    },
    _i9.ThermalPrintView: (data) {
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.ThermalPrintView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class WeightViewArguments {
  const WeightViewArguments({
    required this.isPrintButtonVisible,
    this.key,
  });

  final bool isPrintButtonVisible;

  final _i11.Key? key;

  @override
  String toString() {
    return '{"isPrintButtonVisible": "$isPrintButtonVisible", "key": "$key"}';
  }

  @override
  bool operator ==(covariant WeightViewArguments other) {
    if (identical(this, other)) return true;
    return other.isPrintButtonVisible == isPrintButtonVisible &&
        other.key == key;
  }

  @override
  int get hashCode {
    return isPrintButtonVisible.hashCode ^ key.hashCode;
  }
}

extension NavigatorStateExtension on _i12.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTestPageView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.testPageView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDataViewView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.dataViewView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWeightView({
    required bool isPrintButtonVisible,
    _i11.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.weightView,
        arguments: WeightViewArguments(
            isPrintButtonVisible: isPrintButtonVisible, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLocatioIdView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.locatioIdView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToThermalPrintView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.thermalPrintView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTestPageView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.testPageView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDataViewView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.dataViewView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWeightView({
    required bool isPrintButtonVisible,
    _i11.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.weightView,
        arguments: WeightViewArguments(
            isPrintButtonVisible: isPrintButtonVisible, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLocatioIdView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.locatioIdView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithThermalPrintView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.thermalPrintView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
