import 'package:flutter/material.dart';

import '../theme/com_theme.dart';

extension ContextExtension on BuildContext {
  ComTheme get comTheme =>
      Theme.of(this).extension<ComTheme>() ?? ComTheme.light();
}
