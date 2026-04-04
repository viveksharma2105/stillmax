import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeWidgetView extends StatelessWidget {
  const HomeWidgetView({super.key, required this.widgetId});

  final int widgetId;

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'com.stillmax/widget_view',
      creationParamsCodec: const StandardMessageCodec(),
      creationParams: <String, dynamic>{'widgetId': widgetId},
    );
  }
}
