import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/wish_button_widget.dart';
import 'package:provider/provider.dart';

class ProductImageWidget extends StatelessWidget {
  final Product? productModel;
  const ProductImageWidget({super.key, required this.productModel});


  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context,listen: false);
    final bool hasImage = productModel?.image != null && productModel!.image!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(children: [
          InkWell(
            onTap: () => RouteHelper.getProductImagesRoute(
              productModel?.name ?? '',
              jsonEncode(productModel?.image ?? []),
              splashProvider.baseUrls?.productImageUrl ?? '',
            ),
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: ResponsiveHelper.isDesktop(context) ? 350 : MediaQuery.of(context).size.height * 0.4,
                  child: PageView.builder(
                    itemCount: hasImage ? productModel!.image!.length : 1,
                    itemBuilder: (context, index) {
                      String imagePath = '';
                      if (hasImage) {
                        final selectedIndex = cartProvider.productSelect;
                        if (selectedIndex >= 0 && selectedIndex < productModel!.image!.length) {
                          imagePath = '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productModel!.image![selectedIndex]}';
                        } else {
                          imagePath = '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productModel!.image![0]}';
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CustomImageWidget(
                            image: imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      if (hasImage) {
                        Provider.of<CartProvider>(context, listen: false).onSelectProductStatus(index, true);
                        Provider.of<ProductProvider>(context, listen: false).setImageSliderSelectedIndex(index);
                      }
                    },
                  ),
                );
              }
            ),
          ),

          Positioned(
            top: 26, right: 26,
            child: WishButtonWidget(product: productModel, edgeInset: const EdgeInsets.all(Dimensions.paddingSizeSmall)),
          )

        ]),
      ],
    );
  }

}
