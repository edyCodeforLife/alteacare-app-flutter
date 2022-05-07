// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/data/model/article.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

enum ArticleDetailState { ok, loading, error }

class ArticleDetailController extends GetxController {
  final String slug;
  ArticleDetailController({required this.slug});

  @override
  void onReady() {
    getArticleDetail(slug);
    super.onReady();
  }

  setToLoading() {
    _state.value = ArticleDetailState.loading;
  }

  final http.Client client = http.Client();
  final Rx<DatumArticleV2> _articleDetail = DatumArticleV2().obs;

  final Rx<ArticleDetailState> _state = ArticleDetailState.ok.obs;
  ArticleDetailState get state => _state.value;

  DatumArticleV2 get articleDetail => _articleDetail.value;

  Future<void> getArticleDetail(String slug) async {
    _state.value = ArticleDetailState.loading;
    try {
      final response = await client.get(Uri.parse("$alteaURLAPIAPP/article/detail/$slug"));
      if (response.statusCode == 200) {
        _articleDetail.value = DatumArticleV2.fromJson(jsonDecode(response.body)['data']['articles'][0] as Map<String, dynamic>);
        if (_articleDetail.value.category != null) {
          getArticlesFromTag(_articleDetail.value.category.toString());
        }
        _state.value = ArticleDetailState.ok;
      } else {
        Get.toNamed("/err_404");
        // print(response.body);
        _state.value = ArticleDetailState.error;
      }
    } catch (e) {
      Get.toNamed("/err_404");

      // print(e.toString());
      _state.value = ArticleDetailState.error;
    }
  }

  final RxList<DatumArticleV2> _articlesFromTag = <DatumArticleV2>[].obs;
  List<DatumArticleV2> get articlesFromTag => _articlesFromTag.toList();
  Future<void> getArticlesFromTag(String tag) async {
    try {
      final response = await client.get(Uri.parse("$alteaURLAPIAPP/article/category/$tag"));
      if (response.statusCode == 200) {
        _articlesFromTag.value =
            (jsonDecode(response.body)['data']['articles'] as List).map((e) => DatumArticleV2.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _articlesFromTag.value = [];
      }
    } catch (e) {
      // print(e.toString());
      _articlesFromTag.value = [];
    }
  }

  String formattedDate(String date) {
    DateTime stringToIsoString = DateTime.parse(date);
    return DateFormat("EEEE, dd MMMM yyyy").format(stringToIsoString);
  }
}
