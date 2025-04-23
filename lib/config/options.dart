import 'package:intl/intl.dart' show Bidi;

import 'package:flutter/material.dart';

const String localeKey = 'app_locale';

enum CustomTextDirection { localeBased, ltr, rtl }

// Fake locale to represent the system Locale option.
const systemLocaleOption = Locale('system');

Locale? _deviceLocale;

Locale? get deviceLocale => _deviceLocale;

set deviceLocale(Locale? locale) {
  _deviceLocale ??= locale;
}

class AppOptions {
  AppOptions({required this.customTextDirection, Locale? locale})
    : _locale = locale;

  final CustomTextDirection customTextDirection;
  final Locale? _locale;

  AppOptions copyWith({
    CustomTextDirection? customTextDirection,
    Locale? locale,
  }) {
    return AppOptions(
      customTextDirection: customTextDirection ?? this.customTextDirection,
      locale: locale ?? this.locale,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppOptions &&
      customTextDirection == other.customTextDirection &&
      locale == other.locale;

  @override
  int get hashCode => Object.hash(customTextDirection, locale);

  Locale? get locale => _locale ?? deviceLocale;

  /// Returns a text direction based on the [CustomTextDirection] setting.
  /// If it is based on locale and the locale cannot be determined, returns
  /// null.
  TextDirection? resolvedTextDirection() {
    switch (customTextDirection) {
      case CustomTextDirection.localeBased:
        final language = locale?.languageCode.toLowerCase();
        if (language == null) return null;
        return Bidi.isRtlLanguage(locale!.languageCode)
            ? TextDirection.rtl
            : TextDirection.ltr;
      case CustomTextDirection.rtl:
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }

  static AppOptions of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>();
    return scope!.modelBindingState.currentModel;
  }

  static void update(BuildContext context, AppOptions newModel) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>();
    scope!.modelBindingState.updateModel(newModel);
  }
}

/// Applies text direction [AppOptions] to a widget
class ApplyTextOptions extends StatelessWidget {
  const ApplyTextOptions({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final options = AppOptions.of(context);
    final textDirection = options.resolvedTextDirection();

    return textDirection == null
        ? child
        : Directionality(textDirection: textDirection, child: child);
  }
}

class _ModelBindingScope extends InheritedWidget {
  const _ModelBindingScope({
    required this.modelBindingState,
    required super.child,
  });

  final _ModelBindingState modelBindingState;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}

class ModelBinding extends StatefulWidget {
  const ModelBinding({
    super.key,
    required this.initialModel,
    required this.child,
  });

  final AppOptions initialModel;
  final Widget child;

  @override
  _ModelBindingState createState() => _ModelBindingState();
}

class _ModelBindingState extends State<ModelBinding> {
  late AppOptions currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.initialModel;
  }

  void updateModel(AppOptions newModel) {
    if (newModel != currentModel) {
      setState(() {
        currentModel = newModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ModelBindingScope(modelBindingState: this, child: widget.child);
  }
}
