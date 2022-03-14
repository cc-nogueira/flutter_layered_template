import 'package:flutter/material.dart';

import '../common/page/message_page.dart';
import '../routes/routes.dart';

/// Template App is this application MaterialApp.
///
/// Besides the regular constructor there is TemplateApp.error constructor to
/// handle initialization errors.
class TemplateApp extends StatelessWidget {
  const TemplateApp({Key? key})
      : error = null,
        super(key: key);

  const TemplateApp.error(this.error, {Key? key}) : super(key: key);

  final _routes = const Routes();
  final Object? error;

  @override
  Widget build(BuildContext context) => error == null ? _app : _errorApp;

  Widget get _app => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Layered Template',
        theme: ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: _routes.onGenerateRoute,
        initialRoute: Routes.home,
      );

  Widget get _errorApp => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Layered Template',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MessagePage(title: 'Error', message: error!.toString()),
      );
}
