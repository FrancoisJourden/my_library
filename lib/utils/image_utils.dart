import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageUtils{
  static Widget errorBuilder(BuildContext context) {
    return Text(
      AppLocalizations.of(context)?.image_loading_error ?? "Error",
      style: const TextStyle(color: Colors.red),
    );
  }

  static Widget loadingBuilder(BuildContext context, Widget child, ImageChunkEvent? progress) {
    if (progress == null) {
      return child;
    }
    return Column(children: [
      CircularProgressIndicator(
          value: progress.expectedTotalBytes != null
              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
              : null)
    ]);
  }
}