// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/data/model/article.dart';

class ArticleController extends GetxController {
  final http.Client client = http.Client();

  RxList<String> menus = <String>["Beranda"].obs;
  RxList<DatumArticle> articleList = <DatumArticle>[].obs;
  Rx<Meta> dataPagination = Meta().obs;

  RxList<DatumArticle> listPopularArticle = <DatumArticle>[].obs;
  RxList<DatumArticle> listAllArticleNewAndPopular = <DatumArticle>[].obs;
  RxString searchText = "".obs;

  /// this function is for sort which article are popular or not
  void checkAndSortArticles() {
    listPopularArticle.clear();
    listAllArticleNewAndPopular.clear();

    for (final DatumArticle item in articleList) {
      listPopularArticle.add(item);
      listAllArticleNewAndPopular.add(item);
    }
  }

  /// will use this function when tap the number in pagination
  Future<Article> getArticlesPerPage(String page) async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/articles?page=$page&per_page=20&sort=createdAt:DESC"),
      );

      if (response.statusCode == 200) {
        return Article.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return Article.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Article.fromJsonErrorCatch(e.toString());
    }
  }

  final RxList<DatumArticleV2> _popularArticles = <DatumArticleV2>[].obs;
  List<DatumArticleV2> get popularArticles => _popularArticles.toList();
  Future<List<DatumArticleV2>> getPopularArticles() async {
    try {
      final response = await client.get(Uri.parse("$alteaURLAPIAPP/article?is_popular=true"));
      // print("res get article ==> ${response.body}");
      if (response.statusCode == 200) {
        _popularArticles.value =
            (jsonDecode(response.body)['data']['article'] as List).map((e) => DatumArticleV2.fromJson(e as Map<String, dynamic>)).toList();
        return (jsonDecode(response.body)['data']['article'] as List).map((e) => DatumArticleV2.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        return [];
      }
    } catch (e) {
      // print("artikel kok " + e.toString());
      return [];
    }
  }

  final RxList<DatumArticleV2> _articlesFromSearch = <DatumArticleV2>[].obs;
  List<DatumArticleV2> get articlesFromSearch => _articlesFromSearch.toList();
  Future<List<DatumArticleV2>> getArticlesFromSearch({required String tag}) async {
    try {
      final response = await client.get(Uri.parse("$alteaURLAPIAPP/article/category/$tag"));
      if (response.statusCode == 200) {
        _articlesFromSearch.value =
            (jsonDecode(response.body)['data']['articles'] as List).map((e) => DatumArticleV2.fromJson(e as Map<String, dynamic>)).toList();
        return _articlesFromSearch.toList();
      } else {
        return [];
      }
    } catch (e) {
      // print(e.toString());
      return [];
    }
  }

  final RxList<ArticleCategory> _articleCategories = <ArticleCategory>[].obs;
  List<ArticleCategory> get articleCategories => _articleCategories.toList();
  Future<void> getArticleCategories() async {
    try {
      final response = await client.get(Uri.parse("$alteaURLAPIAPP/article"));
      if (response.statusCode == 200) {
        _articleCategories.value =
            (jsonDecode(response.body)['data']['categories'] as List).map((e) => ArticleCategory.fromJson(e as Map<String, dynamic>)).toList();
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  final Rx<DatumArticleV2> _articleDetail = DatumArticleV2().obs;
  DatumArticleV2 get articleDetail => _articleDetail.value;
  Future<void> getArticleDetail(String slug) async {
    try {
      final response = await client.get(Uri.parse("$alteaURLAPIAPP/article/detail/$slug"));
      if (response.statusCode == 200) {
        _articleDetail.value = DatumArticleV2.fromJson(jsonDecode(response.body)['data']['articles'][0] as Map<String, dynamic>);
        if (_articleDetail.value.category != null) {
          getArticlesFromSearch(tag: _articleDetail.value.category.toString());
        }
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  String formattedDate(String date) {
    DateTime stringToIsoString = DateTime.parse(date);
    return DateFormat("EEEE, dd MMMM yyyy").format(stringToIsoString);
  }

  goToMainScreenFromHome() {
    menus.add("Article");
    getPopularArticles();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getPopularArticles();
    super.onReady();
  }

  @override
  void onClose() {}
}
