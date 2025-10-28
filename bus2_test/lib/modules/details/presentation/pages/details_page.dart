import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/user.dart';
import '../../../core/presentation/cubit/favorites_cubit.dart';
import '../../../core/presentation/theme/app_colors.dart';
import '../../../core/presentation/theme/app_sizes.dart';
import '../../../core/presentation/theme/app_text_styles.dart';
import '../widgets/info_row.dart';
import '../widgets/info_section.dart';

class DetailsPage extends StatefulWidget {
  final User user;
  final String? heroTag;

  const DetailsPage({super.key, required this.user, this.heroTag});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _heartController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _heartController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  void _playHeartAnimation() {
    _heartController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColors.primaryShadow, blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: CircleAvatar(
        radius: avatarRadius,
        backgroundColor: AppColors.avatarBackground,
        backgroundImage: NetworkImage(widget.user.pictureLarge),
      ),
    );

    if (widget.heroTag != null) {
      avatar = Hero(tag: widget.heroTag!, child: avatar);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundLight,
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              bool isFav = false;

              if (state is FavoritesSuccess) {
                isFav = state.allFavorites.any((u) => u.uuid == widget.user.uuid);
              }

              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.8,
                  end: 1.0,
                ).animate(CurvedAnimation(parent: _heartController, curve: Curves.elasticOut)),
                child: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                  color: isFav ? AppColors.favorite : AppColors.textLabel,
                  iconSize: iconSizeMedium,
                  onPressed: () {
                    _playHeartAnimation();
                    if (isFav) {
                      context.read<FavoritesCubit>().removeFavorite(widget.user.uuid);
                    } else {
                      context.read<FavoritesCubit>().addFavorite(widget.user);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.backgroundLight, AppColors.backgroundDark],
            ),
          ),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: orientation == Orientation.portrait
                      ? _buildPortraitLayout(context, avatar)
                      : _buildLandscapeLayout(context, avatar),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, Widget avatar) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          avatar,
          gapH28,
          Text(
            '${widget.user.firstName} ${widget.user.lastName}',
            style: AppTextStyles.getHeadlineDetails(textTheme),
            textAlign: TextAlign.center,
          ),
          gapH12,
          _buildGenderAgeBadge(context),
          gapH32,
          _buildInfoSections(),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, Widget avatar) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                avatar,
                gapH28,
                Text(
                  '${widget.user.firstName} ${widget.user.lastName}',
                  style: AppTextStyles.getHeadlineDetails(textTheme),
                  textAlign: TextAlign.center,
                ),
                gapH12,
                _buildGenderAgeBadge(context),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(padding: landscapeInfoPadding, child: _buildInfoSections()),
        ),
      ],
    );
  }

  Widget _buildGenderAgeBadge(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: badgePadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.badgeGradientStart, AppColors.badgeGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: br20,
        border: Border.all(color: AppColors.badgeBorder, width: borderSmall),
        boxShadow: [BoxShadow(color: AppColors.badgeShadow, blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: badgeIconPadding,
            decoration: BoxDecoration(color: AppColors.badgeIconBackground, borderRadius: br8),
            child: Icon(
              widget.user.gender.toLowerCase() == 'male' ? Icons.male : Icons.female,
              size: iconSizeSmall,
              color: AppColors.primary,
            ),
          ),
          gapW10,
          Text(
            '${widget.user.gender.toUpperCase()} • ${widget.user.age} anos',
            style: AppTextStyles.getBadgeText(textTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSections() {
    return Column(
      children: [
        InfoSection(
          icon: Icons.email_outlined,
          title: 'Contato',
          children: [
            InfoRow(label: 'Email:', value: widget.user.email),
            InfoRow(label: 'Telefone:', value: widget.user.phone),
            InfoRow(label: 'Usuário:', value: widget.user.username),
          ],
        ),
        gapH16,
        InfoSection(
          icon: Icons.location_on_outlined,
          title: 'Localização',
          children: [
            InfoRow(label: 'Rua:', value: '${widget.user.street}, nº ${widget.user.streetNumber}'),
            InfoRow(label: 'Cidade:', value: widget.user.city),
            InfoRow(label: 'Estado:', value: widget.user.state),
            InfoRow(label: 'País:', value: widget.user.country),
            InfoRow(label: 'Nacionalidade:', value: widget.user.nationality),
          ],
        ),
        gapH16,
        InfoSection(
          icon: Icons.badge_outlined,
          title: 'Identificação',
          children: [InfoRow(label: 'UUID:', value: widget.user.uuid)],
        ),
        gapH24,
      ],
    );
  }
}
