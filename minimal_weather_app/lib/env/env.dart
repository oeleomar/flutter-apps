// ignore_for_file: non_constant_identifier_names

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'WEATHER_KEY', obfuscate: true)
  static final String WEATHER_KEY = _Env.WEATHER_KEY;
}
