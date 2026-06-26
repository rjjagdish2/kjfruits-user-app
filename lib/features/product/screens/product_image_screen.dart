import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_handel_deep_link_widget.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:flutter_grocery/utill/images.dart';


class ProductImageScreen extends StatefulWidget {
  final String? title;
  final String? baseUrl;
  final List<dynamic>? imageList;
  const ProductImageScreen({super.key, required this.title, required this.imageList, required this.baseUrl});

  @override
  State<ProductImageScreen> createState() => _ProductImageScreenState();
}

class _ProductImageScreenState extends State<ProductImageScreen> {
  int? pageIndex;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    pageIndex = Provider.of<ProductProvider>(context, listen: false).imageSliderIndex;
    _pageController = PageController(initialPage: pageIndex = 0);
    //NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImages = widget.imageList != null && widget.imageList!.isNotEmpty;

    return CustomPopScopeHandelDeepLinkWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Center(
          child: SizedBox(
            width: 1170,
            child: Column(children: [
      
              CustomAppBarWidget(title: widget.title),
      
              Expanded(
                child: Stack(
                  children: [
                    PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          onScaleEnd: (context, scaleEndDetails, photoViewControllerValue){
                          },
                          imageProvider: hasImages 
                              ? NetworkImage('${widget.baseUrl}/${widget.imageList![index]}')
                              : const AssetImage(Images.placeHolder) as ImageProvider,
                          initialScale: PhotoViewComputedScale.contained,
                        );
                      },
                      backgroundDecoration: BoxDecoration(color: Theme.of(context).cardColor),
                      itemCount: hasImages ? widget.imageList!.length : 1,
                      loadingBuilder: (context, event) => Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      pageController: _pageController,
                      onPageChanged: (int index) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                    ),
      
                    if (hasImages && widget.imageList!.length > 1) ...[
                      Positioned(
                        left: 5, top: 0, bottom: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: pageIndex != 0 ? Theme.of(context).textTheme.bodyMedium!.color! : ColorResources.cartShadowColor, width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () {
                              if(pageIndex! > 0) {
                                _pageController!.animateToPage(pageIndex!-1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                              }
                            },
                            child: Icon(Icons.arrow_back_sharp, size: 40, color: pageIndex != 0 ? Theme.of(context).textTheme.bodyMedium!.color! : ColorResources.cartShadowColor),
                          ),
                        ),
                      ) ,
        
                       Positioned(
                        right: 5, top: 0, bottom: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: pageIndex != widget.imageList!.length-1 ? Theme.of(context).textTheme.bodyMedium!.color! : ColorResources.cartShadowColor, width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () {
                              if(pageIndex! < widget.imageList!.length) {
                                _pageController!.animateToPage(pageIndex!+1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                              }
                            },
                            child: Icon(Icons.arrow_forward_rounded, size: 40, color: pageIndex != widget.imageList!.length-1 ? Theme.of(context).textTheme.bodyMedium!.color! : ColorResources.cartShadowColor),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      
            ]),
          ),
        ),
      ),
    );
  }
}

