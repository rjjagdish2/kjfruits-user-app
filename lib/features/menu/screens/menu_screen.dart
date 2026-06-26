
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/features/menu/domain/models/custom_drawer_controller_model.dart';
import 'package:flutter_grocery/features/menu/domain/models/main_screen_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/menu/screens/main_screen.dart';
import 'package:flutter_grocery/features/menu/widgets/menu_list_web_widget.dart';
import 'package:flutter_grocery/features/menu/widgets/custom_drawer_widget.dart';
import 'package:flutter_grocery/features/menu/widgets/sign_out_dialog_widget.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final bool isReload;
  final bool fromIntro;
  const MenuScreen({super.key, this.isReload = true, this.fromIntro = false});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CustomDrawerController _drawerController = CustomDrawerController();

  @override
  void initState() {
    super.initState();
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(isLoggedIn && widget.isReload) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(true);
      Provider.of<LocationProvider>(context, listen: false).initAddressList();
    } else{
      Provider.of<CartProvider>(context, listen: false).getCartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeProvider>(context).darkTheme;

    return CustomDrawerWidget(
      controller: _drawerController,
      menuScreen: MenuWidget(drawerController: _drawerController),
      mainScreen: MainScreen(drawerController: _drawerController, isReload: widget.isReload, fromIntro: widget.fromIntro),
      showShadow: true,
      angle: -8.0,
      borderRadius: 24,
      slideWidth: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE6F7F4),
    );
  }
}

class MenuWidget extends StatelessWidget {
  final CustomDrawerController? drawerController;

  const MenuWidget({super.key, this.drawerController});

  Widget _buildMenuList(
    BuildContext context, {
    required List<MainScreenModel> items,
    required SplashProvider splash,
    required SplashProvider splashProvider,
    required Color activeTileBg,
    required Color activeTextColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
  }) {
    return Column(
      children: items.map((model) {
        final isSelected = splash.pageIndex == splashProvider.screenList.indexOf(model);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? activeTileBg : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: InkWell(
              onTap: () {
                if (!ResponsiveHelper.isDesktop(context)) {
                  splash.setPageIndex(splashProvider.screenList.indexOf(model));
                }
                drawerController!.toggle();
              },
              borderRadius: BorderRadius.circular(100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    CustomAssetImageWidget(
                      model.icon,
                      color: isSelected ? activeTextColor : textSecondaryColor,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        getTranslated(model.title, context),
                        style: poppinsMedium.copyWith(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? activeTextColor : textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final bool isDark = Provider.of<ThemeProvider>(context).darkTheme;

    // Theme Colors
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
    final textPrimaryColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondaryColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final activeTextColor = isDark ? const Color(0xFF00D0AF) : const Color(0xFF01937C);
    final activeTileBg = isDark ? const Color(0xFF00D0AF).withValues(alpha: 0.1) : const Color(0xFF01937C).withValues(alpha: 0.08);

    // Filter Screens
    final activeScreens = splashProvider.screenList.where((model) => model.isActive).toList();

    final List<String> generalTitles = ['home', 'all_categories', 'shopping_bag', 'favourite'];
    final List<String> accountTitles = ['my_order', 'order_track', 'address', 'wallet', 'loyalty_point', 'coupon', 'live_chat', 'referAndEarn', 'settings'];
    final List<String> infoTitles = ['about_us', 'faq', 'terms_and_condition', 'privacy_policy', 'return_policy', 'refund_policy', 'cancellation_policy'];

    final generalItems = activeScreens.where((m) => generalTitles.contains(m.title)).toList();
    final accountItems = activeScreens.where((m) => accountTitles.contains(m.title)).toList();
    final infoItems = activeScreens.where((m) => infoTitles.contains(m.title)).toList();

    // Fallback for uncategorized items
    final List<String> categorizedTitles = [...generalTitles, ...accountTitles, ...infoTitles];
    final otherItems = activeScreens.where((m) => !categorizedTitles.contains(m.title)).toList();
    if (otherItems.isNotEmpty) {
      accountItems.addAll(otherItems);
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if(!ResponsiveHelper.isDesktop(context) && drawerController?.isOpen()) {
          drawerController?.toggle();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : null,
        body: SafeArea(
          child: ResponsiveHelper.isDesktop(context)? Consumer<SplashProvider>(
              builder: (context, splashProvider, _) {
                return MenuListWebWidget(isLoggedIn: isLoggedIn);
              }
          ) : SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Consumer<SplashProvider>(
                  builder: (context, splash, child) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       !ResponsiveHelper.isDesktop(context) ? Padding(
                         padding: const EdgeInsets.only(left: 20.0, right: 16.0, top: 16.0, bottom: 8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Image.asset(Images.appLogo, width: 28, height: 28),
                                 const SizedBox(width: 10),
                                 Text(
                                   'KJ Fruits',
                                   style: poppinsBold.copyWith(
                                     fontSize: 18,
                                     color: textPrimaryColor,
                                   ),
                                 ),
                               ],
                             ),
                             IconButton(
                               icon: Icon(Icons.close_rounded, color: textSecondaryColor, size: 20),
                               padding: EdgeInsets.zero,
                               constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                               onPressed: () => drawerController!.toggle(),
                             ),
                           ],
                         ),
                       ) : const SizedBox(),

                        // Compact Profile Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: InkWell(
                            onTap: () {
                              if(isLoggedIn) {
                                RouteHelper.getProfileScreen();
                              } else {
                                RouteHelper.getLoginRoute();
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              child: Consumer<ProfileProvider>(
                                builder: (context, profileProvider, child) => Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.15), width: 1),
                                      ),
                                      child: ClipOval(
                                        child: isLoggedIn ? splashProvider.baseUrls != null ?
                                        CustomImageWidget(
                                          placeholder: Images.profile,
                                          image: '${splashProvider.baseUrls?.customerImageUrl}/${profileProvider.userInfoModel?.image}',
                                          height: 44, width: 44, fit: BoxFit.cover,
                                        ) : const SizedBox() : Image.asset(Images.profile, height: 44, width: 44, fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                                            '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                            style: poppinsMedium.copyWith(color: textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w600),
                                            maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ) : Container(height: 12, width: 120, color: textSecondaryColor.withValues(alpha: 0.1)) : Text(
                                            getTranslated('guest', context),
                                            style: poppinsMedium.copyWith(color: textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            isLoggedIn 
                                                ? (profileProvider.userInfoModel?.email ?? profileProvider.userInfoModel?.phone ?? '') 
                                                : 'Please login to your account',
                                            style: poppinsRegular.copyWith(color: textSecondaryColor, fontSize: 12),
                                            maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.notifications_none_rounded, color: textSecondaryColor, size: 20),
                                      onPressed: () {
                                        RouteHelper.getNotificationScreen();
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Section 1: General Items
                        if (generalItems.isNotEmpty && !ResponsiveHelper.isDesktop(context))
                          _buildMenuList(
                            context,
                            items: generalItems,
                            splash: splash,
                            splashProvider: splashProvider,
                            activeTileBg: activeTileBg,
                            activeTextColor: activeTextColor,
                            textPrimaryColor: textPrimaryColor,
                            textSecondaryColor: textSecondaryColor,
                          ),

                        // Lightweight Divider 1
                        if (generalItems.isNotEmpty && accountItems.isNotEmpty && !ResponsiveHelper.isDesktop(context))
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                            child: Divider(
                              height: 1,
                              color: textSecondaryColor.withValues(alpha: 0.15),
                            ),
                          ),

                        // Section 2: Account Items
                        if (accountItems.isNotEmpty && !ResponsiveHelper.isDesktop(context))
                          _buildMenuList(
                            context,
                            items: accountItems,
                            splash: splash,
                            splashProvider: splashProvider,
                            activeTileBg: activeTileBg,
                            activeTextColor: activeTextColor,
                            textPrimaryColor: textPrimaryColor,
                            textSecondaryColor: textSecondaryColor,
                          ),

                        // Lightweight Divider 2
                        if (accountItems.isNotEmpty && infoItems.isNotEmpty && !ResponsiveHelper.isDesktop(context))
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                            child: Divider(
                              height: 1,
                              color: textSecondaryColor.withValues(alpha: 0.15),
                            ),
                          ),

                        // Section 3: Policies & Info Items
                        if (infoItems.isNotEmpty && !ResponsiveHelper.isDesktop(context))
                          _buildMenuList(
                            context,
                            items: infoItems,
                            splash: splash,
                            splashProvider: splashProvider,
                            activeTileBg: activeTileBg,
                            activeTextColor: activeTextColor,
                            textPrimaryColor: textPrimaryColor,
                            textSecondaryColor: textSecondaryColor,
                          ),

                        // Lightweight Bottom Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          child: Divider(
                            height: 1,
                            color: textSecondaryColor.withValues(alpha: 0.15),
                          ),
                        ),

                        // Login/Logout Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isLoggedIn ? Colors.redAccent.withValues(alpha: 0.08) : activeTileBg,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: InkWell(
                              onTap: () {
                                if(isLoggedIn) {
                                  showDialog(context: context, barrierDismissible: false, builder: (context) => const SignOutDialogWidget());
                                }else {
                                  splashProvider.setPageIndex(0);
                                  RouteHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);
                                }
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    CustomAssetImageWidget(isLoggedIn ? Images.logOut : Images.logIn,
                                      width: 20, height: 20,
                                      color: isLoggedIn ? Colors.redAccent : activeTextColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        getTranslated(isLoggedIn ? 'log_out' : 'login', context),
                                        style: poppinsMedium.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isLoggedIn ? Colors.redAccent : activeTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

class MenuButton {
  final String routeName;
  final String icon;
  final String title;
  final IconData? iconData;
  MenuButton({required this.routeName, required this.icon, required this.title, this.iconData});
}