import 'dart:io';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/uploaded_file_list_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../custom/buttons.dart';
import '../../../custom/device_info.dart';
import '../../../custom/m_decoration.dart';
import '../../../custom/my_widget.dart';
import '../../../helpers/shimmer_helper.dart';
import '../../../helpers/styles_helpers.dart';
import '../../../helpers/text_style_helpers.dart';
import '../../../my_theme.dart';
import '../../../repositories/upload_repository.dart';
import '../../classified_ads/classified_product_add.dart';

class UploadFileSeller extends StatefulWidget {
  const UploadFileSeller(
      {Key? key,
      this.fileType = "",
      this.canSelect = false,
      this.canMultiSelect = false,
      this.prevData})
      : super(key: key);
  final String fileType;
  final bool canSelect;
  final bool canMultiSelect;
  final List<FileInfo>? prevData;

  @override
  State<UploadFileSeller> createState() => _UploadFileSellerState();
}

class _UploadFileSellerState extends State<UploadFileSeller> {
  // VideoPlayerController? _videoController;
  ScrollController mainScrollController = ScrollController();
  TextEditingController searchEditingController = TextEditingController();
  String searchTxt = "";

  //for image uploading

  CommonDropDownItem? sortBy;
  List<CommonDropDownItem> sortList = [
    CommonDropDownItem("newest", "Newest"),
    CommonDropDownItem("oldest", "Oldest"),
    CommonDropDownItem("smallest", "Smallest"),
    CommonDropDownItem("largest", "Largest")
  ];

  List<FileInfo> _images = [];
  List<FileInfo>? _selectedImages = [];
  bool _faceData = false;
  int currentPage = 1;
  int? lastPage = 1;

  Future<FilePickerResult?> pickSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.fileType == "image"
            ? ["jpg", "jpeg", "png", "svg"]
            : ["mp4", "mov", "avi", "mkv", "flv"]);

    if (result != null && widget.fileType == "video") {
      String? path = result.files.single.path;

      if (path != null) {
        VideoPlayerController videoController =
            VideoPlayerController.file(File(path));
        await videoController.initialize();

        final duration = videoController.value.duration;

        if (duration.inSeconds > 30) {
          final snackBar = SnackBar(
            content: Text(
              'Video duration exceeds 30 seconds. Please select a shorter video',
              textAlign: TextAlign.center,
            ),
            backgroundColor: MyTheme.accent_color,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return null;
        }
      }
    }

    return result;
  }

  chooseAndUploadFile(context) async {
    FilePickerResult? file = await pickSingleFile();
    if (file == null) {
      ToastComponent.showDialog(LangText(context).local.no_file_is_chosen,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    _faceData = false;
    var fileUploadResponse =
        await FileUploadRepository().fileUploadSeller(File(file.paths.first!));
    resetData();
    if (fileUploadResponse.result == false) {
      ToastComponent.showDialog(fileUploadResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else {
      ToastComponent.showDialog(fileUploadResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  getImageList() async {
    var response = await FileUploadRepository()
        .getFilesSeller(currentPage, searchTxt, widget.fileType, sortBy!.key);
    if (widget.fileType == "video" && response.data!.isNotEmpty) {
      for (int i = 0; i < response.data!.length; i++) {
        String? thumbnail =
            await generateThumbnail(response.data![i].url ?? '');

        _images.add(FileInfo(
          id: response.data![i].id,
          fileOriginalName: response.data![i].fileOriginalName,
          fileName: response.data![i].fileName,
          url: response.data![i].url,
          fileSize: response.data![i].fileSize,
          extension: response.data![i].extension,
          type: response.data![i].type,
          thumbnail: thumbnail,
        ));
      }
    } else {
      _images.addAll(response.data!);
    }
    _faceData = true;
    lastPage = response.meta!.lastPage;
    setState(() {});
  }

  Future<bool> fetchData() async {
    getImageList();
    return true;
  }

  _tabOption(int index, imageId, listIndex) {
    switch (index) {
      case 0:
        delete(imageId);
        break;
      default:
        break;
    }
  }

  delete(id) async {
    var response = await FileUploadRepository().deleteFileSeller(id);

    if (response.result) {
      resetData();
    }

    ToastComponent.showDialog(response.message);
  }

  Future<bool> clearData() async {
    _images = [];
    _faceData = false;
    if (mounted) {
      setState(() {});
    }

    return true;
  }

  sorted() {
    refresh();
  }

  search() {
    searchTxt = searchEditingController.text.trim();
    refresh();
  }

  Future<bool> resetData() async {
    await clearData();
    await fetchData();
    return true;
  }

  Future<void> refresh() async {
    await resetData();
    return Future.delayed(Duration(seconds: 1));
  }

  scrollControllerPosition() {
    mainScrollController.addListener(() {
      if (mainScrollController.position.pixels ==
          mainScrollController.position.maxScrollExtent) {
        if (currentPage >= lastPage!) {
          currentPage++;
          getImageList();
        }
      }
    });
  }

  Future<String?> generateThumbnail(String url) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 100,
        quality: 75,
      );

      return thumbnail;
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.canMultiSelect && widget.prevData != null) {
      _selectedImages = widget.prevData;
      setState(() {});
    }
    sortBy = sortList.first;
    fetchData();
    scrollControllerPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _selectedImages);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.white,
          iconTheme: IconThemeData(color: MyTheme.dark_grey),
          title: Text(
            LangText(context).local.upload_file_ucf,
            style: MyTextStyle().appbarText(),
          ),
          // bottom: PreferredSize(child: buildUploadFileContainer(context),preferredSize: Size(DeviceInfo(context).getWidth(),75)),
          actions: [
            if (widget.canSelect && _selectedImages!.isNotEmpty)
              Buttons(
                onPressed: () {
                  Navigator.pop(context, _selectedImages);
                },
                child: Text(
                  LangText(context).local.select_ucf,
                  style:
                      MyTextStyle().appbarText().copyWith(color: MyTheme.green),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: refresh,
            child: Stack(
              children: [
                _faceData
                    ? _images.isEmpty
                        ? Center(
                            child: Text(
                                LangText(context).local.no_data_is_available),
                          )
                        : buildImageListView()
                    : buildShimmerList(context),
                Container(
                  child: buildFilterSection(context),
                )
              ],
            )),
      ),
    );
  }

  Widget buildShimmerList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
            5,
            (index) => Container(
                margin: EdgeInsets.only(bottom: 20),
                child: ShimmerHelper().buildBasicShimmer(
                    height: 96, width: DeviceInfo(context).width!))),
      ),
    );
  }

  Widget buildImageListView() {
    return Padding(
      padding: const EdgeInsets.only(top: 145.0),
      child: GridView.builder(
          controller: mainScrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: AppStyles.itemMargin),
          padding: EdgeInsets.all(10),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return buildImageItem(index);
          }),
    );
  }

  int findIndex(id) {
    int index = 0;
    _selectedImages!.forEach((element) {
      if (element.id == id) {
        index = _selectedImages!.indexOf(element);
      }
    });
    return index;
  }

  Widget buildImageItem(int index) {
    return InkWell(
      splashColor: MyTheme.noColor,
      onTap: () {
        if (widget.canSelect) {
          if (widget.canMultiSelect) {
            if (_selectedImages!
                .any((element) => element.id == _images[index].id)) {
              int getIndex = findIndex(_images[index].id);
              _selectedImages!.removeAt(getIndex);
            } else {
              _selectedImages!.add(_images[index]);
            }
          } else {
            if (_selectedImages!
                .any((element) => element.id == _images[index].id)) {
              _selectedImages!.removeWhere((element) => _selectedImages!
                  .any((element) => element.id == _images[index].id));
            } else {
              _selectedImages = [];
              _selectedImages!.add(_images[index]);
            }
          }
        }
        setState(() {});
      },
      child: Stack(
        children: [
          MyWidget().productContainer(
            width: DeviceInfo(context).width!,
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 170,
            borderColor: MyTheme.grey_153,
            borderRadius: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _images[index].type != "video"
                    ? MyWidget.imageWithPlaceholder(
                        url: _images[index].url, height: 100.0, width: 100.0)
                    : _images[index].thumbnail != null &&
                            File(_images[index].thumbnail!).existsSync()
                        ? Image.file(File(_images[index].thumbnail ?? ''))
                        : SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: Image.asset(
                              'assets/placeholder.png',
                              fit: BoxFit.cover,
                            )),
                Text(
                  "${_images[index].fileOriginalName}.${_images[index].extension}",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          if (_selectedImages!
              .any((element) => element.id == _images[index].id))
            Positioned(top: 10, right: 10, child: buildCheckContainer()),
          if (!widget.canMultiSelect && !widget.canSelect)
            Positioned(
                top: 10,
                right: 10,
                child:
                    showOptions(imageId: _images[index].id, listIndex: index))
        ],
      ),
    );
  }

  Widget buildUploadFileContainer(BuildContext context) {
    return InkWell(
      onTap: () {
        chooseAndUploadFile(context);
      },
      child: MyWidget().myContainer(
          marginY: 10.0,
          marginX: 5,
          height: 75,
          width: DeviceInfo(context).width!,
          borderRadius: 10,
          bgColor: MyTheme.app_accent_color_extra_light,
          borderColor: MyTheme.accent_color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                LangText(context).local.upload_file_ucf,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: MyTheme.accent_color),
              ),
              Icon(
                Icons.upload_file,
                size: 18,
                color: MyTheme.accent_color,
              )
              /*
              Image.asset(
                'assets/icon/add.png',
                width: 18,
                height: 18,
                color: MyTheme.app_accent_color,
              )*/
            ],
          )),
    );
  }

  buildFilterSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        buildUploadFileContainer(context),
        Container(
            height: 40,
            margin: EdgeInsets.only(top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: DeviceInfo(context).width! / 2 -
                        AppStyles.layoutMargin * 1.5,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: MDecoration.decoration1(),
                    child: DropdownButton<CommonDropDownItem>(
                      isDense: true,
                      underline: Container(),
                      isExpanded: true,
                      onChanged: (value) {
                        sortBy = value;
                        sorted();
                        //onchange(value);
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                      value: sortBy,
                      items: sortList
                          .map(
                            (value) => DropdownMenuItem<CommonDropDownItem>(
                              value: value,
                              child: Text(
                                value.value!,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const Spacer(),
                  Container(
                      decoration: MDecoration.decoration1(),
                      width: DeviceInfo(context).width! / 2 -
                          AppStyles.layoutMargin * 1.5,
                      child: Row(
                        children: [
                          buildFlatEditTextFiled(),
                          InkWell(
                            onTap: () {
                              search();
                            },
                            child: const SizedBox(
                              width: 40,
                              child: Icon(Icons.search_sharp),
                            ),
                          )
                        ],
                      ))
                  // SizedBox(width: 10,)
                ],
              ),
            )),
      ],
    );
  }

  Widget buildFlatEditTextFiled() {
    return Container(
      width:
          DeviceInfo(context).width! / 2 - (AppStyles.layoutMargin * 1.5 + 50),
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 45,
      alignment: Alignment.center,
      child: TextField(
        controller: searchEditingController,
        decoration: InputDecoration.collapsed(
            hintText: LangText(context).local.search_here_ucf),
      ),
    );
  }

  Widget buildCheckContainer() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: 1,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(Icons.check, color: Colors.white, size: 10),
        ),
      ),
    );
  }

  Widget showOptions({listIndex, imageId}) {
    return Container(
      width: 35,
      child: PopupMenuButton<MenuOptions>(
        offset: Offset(-12, 0),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Container(
            width: 35,
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.topRight,
            child: Image.asset("assets/icon/more.png",
                width: 3,
                height: 15,
                fit: BoxFit.contain,
                color: MyTheme.grey_153),
          ),
        ),
        onSelected: (MenuOptions result) {
          _tabOption(result.index, imageId, listIndex);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Delete,
            child: Text(LangText(context).local.delete_ucf),
          ),
        ],
      ),
    );
  }
}

enum MenuOptions { Delete }
