import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello',
          'counter_text': 'You have pushed the button this many times:',
          'increment': 'Increment',
        },
        'es_ES': {
          'hello': 'Hola',
          'counter_text': 'Has presionado el botón estas veces:',
          'increment': 'Incrementar',
        },
      };
} 