// ignore_for_file: non_constant_identifier_names

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_API_MAPS', obfuscate: true)
  static final String GOOGLE_API_MAPS = _Env.GOOGLE_API_MAPS;
}
