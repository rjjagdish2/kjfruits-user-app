
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

class MenuWidget extends StatefulWidget {
  final CustomDrawerController? drawerController;

  const MenuWidget({super.key, this.drawerController});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  bool _isPoliciesExpanded = false;

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 18.0, bottom: 6.0),
      child: Text(
        title.toUpperCase(),
        style: poppinsBold.copyWith(
          fontSize: 11,
          color: textColor.withValues(alpha: 0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuGroup(
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: InkWell(
            onTap: () {
              if (!ResponsiveHelper.isDesktop(context)) {
                splash.setPageIndex(splashProvider.screenList.indexOf(model));
              }
              widget.drawerController!.toggle();
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? activeTileBg : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (isSelected)
                    Container(
                      width: 4,
                      height: 20,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: activeTextColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                  else
                    const SizedBox(width: 12),
                  CustomAssetImageWidget(
                    model.icon,
                    color: isSelected ? activeTextColor : textPrimaryColor.withValues(alpha: 0.8),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      getTranslated(model.title, context),
                      style: poppinsMedium.copyWith(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? activeTextColor : textPrimaryColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: activeTextColor,
                    ),
                ],
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

    // Premium modern backgrounds and gradients
    final backgroundGradient = isDark 
        ? const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : const LinearGradient(
            colors: [Color(0xFFE6F7F4), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

    final profileCardGradient = isDark 
        ? LinearGradient(
            colors: [
              const Color(0xFF0F172A).withValues(alpha: 0.8),
              Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              const Color(0xFF00D0AF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final profileCardColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final textPrimaryColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondaryColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final activeTileBg = isDark ? Theme.of(context).primaryColor.withValues(alpha: 0.15) : const Color(0xFFE6F7F4);
    final activeTextColor = isDark ? const Color(0xFF00D0AF) : const Color(0xFF01937C);

    final cardTextPrimaryColor = isDark ? const Color(0xFFF8FAFC) : Colors.white;
    final cardTextSecondaryColor = isDark ? const Color(0xFF94A3B8) : Colors.white.withValues(alpha: 0.8);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if(!ResponsiveHelper.isDesktop(context) && widget.drawerController?.isOpen()) {
          widget.drawerController?.toggle();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : null,
        body: Container(
          decoration: BoxDecoration(gradient: backgroundGradient),
          child: SafeArea(
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
                      final activeScreens = splashProvider.screenList.where((model) => model.isActive).toList();

                      final List<String> shopExploreTitles = ['home', 'all_categories', 'shopping_bag', 'favourite'];
                      final List<String> ordersOffersTitles = ['my_order', 'order_track', 'address', 'coupon', 'wallet', 'loyalty_point', 'referAndEarn'];
                      final List<String> supportSettingsTitles = ['live_chat', 'settings'];
                      final List<String> policyTitles = [
                        'about_us',
                        'faq',
                        'terms_and_condition',
                        'privacy_policy',
                        'return_policy',
                        'refund_policy',
                        'cancellation_policy'
                      ];

                      final shopExploreItems = activeScreens.where((m) => shopExploreTitles.contains(m.title)).toList();
                      final ordersOffersItems = activeScreens.where((m) => ordersOffersTitles.contains(m.title)).toList();
                      final supportSettingsItems = activeScreens.where((m) => supportSettingsTitles.contains(m.title)).toList();
                      final policyItems = activeScreens.where((m) => policyTitles.contains(m.title)).toList();

                      final allKnownTitles = [...shopExploreTitles, ...ordersOffersTitles, ...supportSettingsTitles, ...policyTitles];
                      final otherItems = activeScreens.where((m) => !allKnownTitles.contains(m.title)).toList();
                      if (otherItems.isNotEmpty) {
                        supportSettingsItems.addAll(otherItems);
                      }

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
                                 Image.asset(Images.appLogo, width: 36, height: 36),
                                 const SizedBox(width: 10),
                                 Text(
                                   'KJ Fruits',
                                   style: poppinsBold.copyWith(
                                     fontSize: 20,
                                     color: textPrimaryColor,
                                     letterSpacing: 0.5,
                                   ),
                                 ),
                               ],
                             ),
                             Container(
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: profileCardColor,
                                 border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
                               ),
                               child: IconButton(
                                 icon: Icon(Icons.close_rounded, color: textPrimaryColor, size: 18),
                                 padding: EdgeInsets.zero,
                                 constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                 onPressed: () => widget.drawerController!.toggle(),
                               ),
                             ),
                           ],
                         ),
                       ) : const SizedBox(),

                        // Profile Info Section Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: profileCardGradient,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: (isDark ? Colors.black : Theme.of(context).primaryColor).withValues(alpha: 0.15),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                )
                              ],
                              border: Border.all(color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.15)),
                            ),
                            child: Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) => Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: isLoggedIn ? splashProvider.baseUrls != null ?
                                      CustomImageWidget(
                                        placeholder: Images.profile,
                                        image: '${splashProvider.baseUrls?.customerImageUrl}/${profileProvider.userInfoModel?.image}',
                                        height: 52, width: 52, fit: BoxFit.cover,
                                      ) : const SizedBox() : Image.asset(Images.profile, height: 52, width: 52, fit: BoxFit.cover),
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
                                          style: poppinsSemiBold.copyWith(color: cardTextPrimaryColor, fontSize: Dimensions.fontSizeLarge),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ) : Container(height: 12, width: 120, color: cardTextSecondaryColor.withValues(alpha: 0.2)) : Text(
                                          getTranslated('guest', context),
                                          style: poppinsSemiBold.copyWith(color: cardTextPrimaryColor, fontSize: Dimensions.fontSizeLarge),
                                        ),
                                        const SizedBox(height: 4),
                                        if(isLoggedIn && profileProvider.userInfoModel != null ) Text(
                                          profileProvider.userInfoModel!.phone ?? '',
                                          style: poppinsRegular.copyWith(color: cardTextSecondaryColor, fontSize: Dimensions.fontSizeSmall),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.15),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.notifications_none_rounded, color: cardTextPrimaryColor, size: 22),
                                      onPressed: () {
                                        RouteHelper.getNotificationScreen();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Shop & Explore Group
                        if (shopExploreItems.isNotEmpty && !ResponsiveHelper.isDesktop(context)) ...[
                          _buildSectionHeader('Shop & Explore', activeTextColor),
                          _buildMenuGroup(
                            context,
                            items: shopExploreItems,
                            splash: splash,
                            splashProvider: splashProvider,
                            activeTileBg: activeTileBg,
                            activeTextColor: activeTextColor,
                            textPrimaryColor: textPrimaryColor,
                            textSecondaryColor: textSecondaryColor,
                          ),
                        ],

                        // Orders & Offers Group
                        if (ordersOffersItems.isNotEmpty && !ResponsiveHelper.isDesktop(context)) ...[
                          _buildSectionHeader('Orders & Offers', activeTextColor),
                          _buildMenuGroup(
                            context,
                            items: ordersOffersItems,
                            splash: splash,
                            splashProvider: splashProvider,
                            activeTileBg: activeTileBg,
                            activeTextColor: activeTextColor,
                            textPrimaryColor: textPrimaryColor,
                            textSecondaryColor: textSecondaryColor,
                          ),
                        ],

                        // Support & Settings Group
                        if (supportSettingsItems.isNotEmpty && !ResponsiveHelper.isDesktop(context)) ...[
                          _buildSectionHeader('Support & Settings', activeTextColor),
                          _buildMenuGroup(
                            context,
                            items: supportSettingsItems,
                            splash: splash,
                            splashProvider: splashProvider,
                            activeTileBg: activeTileBg,
                            activeTextColor: activeTextColor,
                            textPrimaryColor: textPrimaryColor,
                            textSecondaryColor: textSecondaryColor,
                          ),
                        ],

                        // Policies & Info Collapsible Group
                        if (policyItems.isNotEmpty && !ResponsiveHelper.isDesktop(context)) ...[
                          _buildSectionHeader('Policies & Info', activeTextColor),
                          Builder(
                            builder: (context) {
                              final isAnyPolicySelected = policyItems.any((m) => splash.pageIndex == splashProvider.screenList.indexOf(m));
                              final String policiesLabel = getTranslated('policies_and_info', context) == 'policies_and_info'
                                  ? 'Policies & Info'
                                  : getTranslated('policies_and_info', context);
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isPoliciesExpanded = !_isPoliciesExpanded;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isAnyPolicySelected ? activeTileBg : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            if (isAnyPolicySelected)
                                              Container(
                                                width: 4,
                                                height: 20,
                                                margin: const EdgeInsets.only(right: 8),
                                                decoration: BoxDecoration(
                                                  color: activeTextColor,
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              )
                                            else
                                              const SizedBox(width: 12),
                                            Icon(
                                              Icons.policy_outlined,
                                              color: isAnyPolicySelected ? activeTextColor : textPrimaryColor.withValues(alpha: 0.8),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                policiesLabel,
                                                style: poppinsMedium.copyWith(
                                                  fontSize: 15,
                                                  fontWeight: isAnyPolicySelected ? FontWeight.w600 : FontWeight.w500,
                                                  color: isAnyPolicySelected ? activeTextColor : textPrimaryColor.withValues(alpha: 0.8),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              _isPoliciesExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                              color: isAnyPolicySelected ? activeTextColor : textSecondaryColor,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_isPoliciesExpanded)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: Column(
                                        children: policyItems.map((model) {
                                          final isSelected = splash.pageIndex == splashProvider.screenList.indexOf(model);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                            child: InkWell(
                                              onTap: () {
                                                if (!ResponsiveHelper.isDesktop(context)) {
                                                  splash.setPageIndex(splashProvider.screenList.indexOf(model));
                                                }
                                                widget.drawerController!.toggle();
                                              },
                                              borderRadius: BorderRadius.circular(12),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: isSelected ? activeTileBg : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 16),
                                                    CustomAssetImageWidget(
                                                      model.icon,
                                                      color: isSelected ? activeTextColor : textPrimaryColor.withValues(alpha: 0.6),
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        getTranslated(model.title, context),
                                                        style: poppinsMedium.copyWith(
                                                          fontSize: 14,
                                                          color: isSelected ? activeTextColor : textPrimaryColor.withValues(alpha: 0.7),
                                                        ),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(
                                                        Icons.arrow_forward_ios_rounded,
                                                        size: 10,
                                                        color: activeTextColor,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],

                        // Bottom Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Divider(
                            color: textSecondaryColor.withValues(alpha: 0.15),
                            height: 1,
                          ),
                        ),

                        // Login/Logout Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: InkWell(
                            onTap: () {
                              if(isLoggedIn) {
                                showDialog(context: context, barrierDismissible: false, builder: (context) => const SignOutDialogWidget());
                              }else {
                                splashProvider.setPageIndex(0);
                                RouteHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isLoggedIn ? Colors.redAccent.withValues(alpha: 0.08) : activeTileBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isLoggedIn ? Colors.redAccent.withValues(alpha: 0.2) : activeTextColor.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  CustomAssetImageWidget(isLoggedIn ? Images.logOut : Images.logIn,
                                    width: 20, height: 20,
                                    color: isLoggedIn ? Colors.redAccent : activeTextColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      getTranslated(isLoggedIn ? 'log_out' : 'login', context),
                                      style: poppinsMedium.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isLoggedIn ? Colors.redAccent : activeTextColor,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                    color: isLoggedIn ? Colors.redAccent : activeTextColor,
                                  ),
                                ],
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