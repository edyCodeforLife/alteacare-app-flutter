// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';

TextField buildSearchArticleTextField() {
  return TextField(
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: kButtonColor, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: kLightGray, width: 2.0),
      ),
      suffixIcon: const Icon(Icons.search_rounded),
      hintText: 'Cari Artikel Berdasarkan judul,kategori,topik',
    ),
  );
}
