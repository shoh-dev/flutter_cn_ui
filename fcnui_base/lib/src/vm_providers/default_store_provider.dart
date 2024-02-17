import 'package:fcnui_base/src/store/f_action.dart';
import 'package:flutter/material.dart';
import 'package:fcnui_base/src/dependency_injection/init.dart';
import 'package:fcnui_base/src/store/store.dart';
import 'package:flutter/scheduler.dart';

class DefaultStoreProvider extends StatelessWidget {
  final Widget child;

  /// List of actions that will be dispatched when the store is initialized
  final List<FAction> initActions;
  DefaultStoreProvider(
      {super.key, required this.child, this.initActions = const []}) {
    initDependency();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("DefaultStoreProvider.build complete");
    return StoreProvider(
        store: fcnGetIt.get<Store<AppState>>(),
        child: StoreConnector<AppState, void>(
            rebuildOnChange: false,
            converter: (store) {},
            onInit: (store) {
              for (var action in initActions) {
                store.dispatch(action);
              }
            },
            builder: (context, vm) => child));
  }
}
