import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/l10n/gallery_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();

    // Check authentication status after animation starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(CheckAuthStatusEvent());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            context.goNamed(AppRouter.dashboard);
          });
        } else if (state is AuthLoggedOut) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            context.goNamed(AppRouter.login);
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: isSmallScreen ? 100 : 120,
                      height: isSmallScreen ? 100 : 120,
                      decoration: BoxDecoration(
                        color: AppTheme.AppPrimary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.AppPrimary.withValues(alpha: 0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.school_rounded,
                          color: AppTheme.AppPrimary,
                          size: isSmallScreen ? 50 : 60,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // App name text animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  AppLocalizations.of(context)?.studentPortal ??
                      "Student Portal",
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: isSmallScreen ? 28 : 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle text animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: isSmallScreen ? 14 : 16,
                    color:
                        theme.brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Loading indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.AppPrimary,
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
