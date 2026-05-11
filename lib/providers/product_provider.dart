import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final _repo = ProductRepository();

  List<ProductModel> _all = [];
  List<ProductModel> _featured = [];
  List<ProductModel> _bestSellers = [];
  List<ProductModel> _searchResults = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;

  StreamSubscription<List<ProductModel>>? _allSub;
  StreamSubscription<List<ProductModel>>? _featuredSub;
  StreamSubscription<List<ProductModel>>? _bestSellersSub;
  Timer? _debounce;

  List<ProductModel> get all => _selectedCategory == 'All'
      ? _all
      : _all.where((p) => p.category == _selectedCategory).toList();
  List<ProductModel> get featured => _featured;
  List<ProductModel> get bestSellers => _bestSellers;
  List<ProductModel> get searchResults => _searchResults;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;

  void initialize() {
    _isLoading = true;
    _allSub = _repo.watchAll().listen(
      (products) {
        _all = products;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load products.';
        _isLoading = false;
        notifyListeners();
      },
    );

    _featuredSub = _repo.watchFeatured().listen((products) {
      _featured = products;
      notifyListeners();
    });

    _bestSellersSub = _repo.watchBestSellers().listen((products) {
      _bestSellers = products;
      notifyListeners();
    });
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void search(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }
    _isSearching = true;
    notifyListeners();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      _searchResults = await _repo.search(query);
      _isSearching = false;
      notifyListeners();
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  Future<ProductModel?> getProduct(String id) => _repo.getById(id);

  ProductRepository get repository => _repo;

  @override
  void dispose() {
    _allSub?.cancel();
    _featuredSub?.cancel();
    _bestSellersSub?.cancel();
    _debounce?.cancel();
    super.dispose();
  }
}
