import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryProducts extends StatefulWidget {
  CategoryProducts({Key? key, required this.slug, this.isFood = false})
      : super(key: key);
  final String slug;
  final bool isFood;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  List<dynamic> _productList = [];
  List<dynamic> _searchProductList = [];
  List<Category> _subCategoryList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int? _totalData = 0;
  bool _showLoadingContainer = false;
  bool _showSearchBar = false;
  Category? categoryInfo;
  String? selectedSlug;

  getSubCategory(String slug) async {
    // _subCategoryList.clear();
    var res = await CategoryRepository().getCategories(parent_id: slug);
    _subCategoryList.addAll(res.categories!);
    setState(() {});
  }

  getCategoryInfo(String slug) async {
    var res = await CategoryRepository().getCategoryInfo(slug);
    if (res.categories?.isNotEmpty ?? false) {
      categoryInfo = res.categories?.first ?? null;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryInfo(widget.slug);
    fetchAllDate(widget.slug);

    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData(widget.slug);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchData(String slug) async {
    var productResponse = await ProductRepository()
        .getCategoryProducts(id: slug, page: _page, name: _searchKey);
    _productList.addAll(productResponse.products!);
    _isInitial = false;
    _totalData = productResponse.meta!.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  void searchProduct(String txt) {
    _searchProductList = _productList
        .where(
            (product) => product.name.toLowerCase().contains(txt.toLowerCase()))
        .toList();
    setState(() {});
  }

  fetchAllDate(String slug) {
    fetchData(slug);
    getSubCategory(slug);
  }

  reset() {
    _subCategoryList.clear();
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAllDate(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            buildProductList(),
            Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())
          ],
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _productList.length
            ? AppLocalizations.of(context)!.no_more_products_ucf
            : AppLocalizations.of(context)!.loading_more_products_ucf),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      flexibleSpace: Container(
        height: DeviceInfo(context).height! / 4,
        width: DeviceInfo(context).width,
        color: MyTheme.accent_color,
        alignment: Alignment.topRight,
        child: Image.asset(
          "assets/background_1.png",
        ),
      ),
      title: CustomText(
          text: categoryInfo?.name ?? "",
          fontSize: 16,
          maxLines: 1,
          color: MyTheme.white,
          fontWeight: FontWeight.bold),
      // title: buildAppBarTitle(context),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Filter();
            }));
          },
          icon: Icon(Icons.search),
        ),
      ],
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: buildAppBarTitleOption(context),
        secondChild: buildAppBarSearchOption(context),
        firstCurve: Curves.fastOutSlowIn,
        secondCurve: Curves.fastOutSlowIn,
        crossFadeState: _showSearchBar
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 500));
  }

  Container buildAppBarTitleOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            width: 20,
            child: UsefulElements.backButton(context, color: "white"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            width: DeviceInfo(context).width! / 2,
            child: Text(
              categoryInfo?.name ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          SizedBox(
            width: 20,
            child: IconButton(
                onPressed: () {
                  _showSearchBar = true;
                  setState(() {});
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.search,
                  size: 25,
                )),
          ),
        ],
      ),
    );
  }

  Container buildAppBarSearchOption(BuildContext context) {
    final slug = selectedSlug != null ? selectedSlug : widget.slug;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      width: DeviceInfo(context).width,
      height: 40,
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {
          _searchKey = txt;
          searchProduct(txt);
        },
        autofocus: false,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () async {
              _showSearchBar = false;
              reset();
              _searchController.text = "";
              _searchKey = "";
              await getCategoryInfo(slug!);
              await fetchAllDate(slug);
              setState(() {});
            },
            icon: Icon(
              Icons.clear,
              color: MyTheme.grey_153,
            ),
          ),
          filled: true,
          fillColor: MyTheme.white.withOpacity(0.6),
          hintText:
              "${AppLocalizations.of(context)!.search_products_from} : " + ""
          //widget.category_name!
          ,
          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.font_grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  ListView buildSubCategory() {
    return ListView.separated(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final slug = _subCategoryList[index].slug;
          return InkWell(
            onTap: () async {
              _searchController.text = "";
              _searchKey = "";
              _showSearchBar = false;
              reset();
              selectedSlug = slug;
              await getCategoryInfo(slug!);
              await fetchAllDate(slug);
            },
            child: Container(
              height: _subCategoryList.isEmpty ? 0 : 46,
              width: _subCategoryList.isEmpty ? 0 : 150,
              decoration: BoxDecoration(
                  color: MyTheme.iconContainerColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
              child: Row(
                children: [
                  categoryProfileContainer(img: _subCategoryList[index]),
                  SizedBox(width: 5),
                  Expanded(
                      child: CustomText(
                    text: _subCategoryList[index].name!,
                    maxLines: 2,
                    fontWeight: FontWeight.w600,
                  ))
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: _subCategoryList.length);
  }

  buildProductList() {
    if (_isInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_searchKey != "" && _searchProductList.isEmpty) {
      return Center(child: Text("No Search Product Found"));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            itemCount: _searchKey == ""
                ? _productList.length
                : _searchProductList.length,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = _searchKey == ""
                  ? _productList[index]
                  : _searchProductList[index];
              return ProductCard(
                product: data,
                isFood: widget.isFood,
              );
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_data_is_available));
    } else {
      return Container(); // should never be happening
    }
  }
}
