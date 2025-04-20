import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor:
          theme.brightness == Brightness.dark
              ? const Color(0xFF2D2B21)
              : AppTheme.AppBackground,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Trigger profile data loading
            context.read<ProfileBloc>().add(LoadProfileEvent());
            context.goNamed(AppRouter.dashboard);
          } else if (state is AuthError) {
            // Display a user-friendly error message
            String userFriendlyMessage =
                GalleryLocalizations.of(context)!.unableToSignIn;

            // Handle specific errors if we can identify them
            if (state.message.contains('403')) {
              userFriendlyMessage =
                  GalleryLocalizations.of(context)!.incorrectCredentials;
            } else if (state.message.contains('timeout') ||
                state.message.contains('connect')) {
              userFriendlyMessage =
                  GalleryLocalizations.of(context)!.networkError;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(userFriendlyMessage),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
              ),
            );
          }
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16.0 : 24.0,
                    vertical: 24.0,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo and header
                            Hero(
                              tag: 'app_logo',
                              child: Container(
                                width: isSmallScreen ? 72 : 88,
                                height: isSmallScreen ? 72 : 88,
                                decoration: BoxDecoration(
                                  color: AppTheme.AppPrimary.withValues(
                                    alpha: 0.15,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.AppPrimary.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.school_rounded,
                                    color: AppTheme.AppPrimary,
                                    size: isSmallScreen ? 36 : 44,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 28 : 32),
                            Text(
                              GalleryLocalizations.of(context)!.studentPortal,
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: isSmallScreen ? 28 : 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              GalleryLocalizations.of(context)!.signInToAccount,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: isSmallScreen ? 14 : 16,
                                color:
                                    theme.brightness == Brightness.dark
                                        ? Colors.white70
                                        : Colors.black54,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 36 : 44),

                            // Student code field
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText:
                                    GalleryLocalizations.of(
                                      context,
                                    )!.studentCode,
                                hintText:
                                    GalleryLocalizations.of(
                                      context,
                                    )!.enterStudentCode,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color:
                                      theme
                                          .inputDecorationTheme
                                          .prefixIconColor,
                                  size: isSmallScreen ? 20 : 24,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color:
                                        theme.brightness == Brightness.dark
                                            ? Colors.white30
                                            : Colors.black12,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 16 : 20,
                                  horizontal: isSmallScreen ? 16 : 20,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return GalleryLocalizations.of(
                                    context,
                                  )!.pleaseEnterStudentCode;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 24),

                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText:
                                    GalleryLocalizations.of(context)!.password,
                                hintText:
                                    GalleryLocalizations.of(
                                      context,
                                    )!.enterPassword,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color:
                                      theme
                                          .inputDecorationTheme
                                          .prefixIconColor,
                                  size: isSmallScreen ? 20 : 24,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                        theme.brightness == Brightness.dark
                                            ? Colors.white60
                                            : Colors.black45,
                                    size: isSmallScreen ? 20 : 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color:
                                        theme.brightness == Brightness.dark
                                            ? Colors.white30
                                            : Colors.black12,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 16 : 20,
                                  horizontal: isSmallScreen ? 16 : 20,
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return GalleryLocalizations.of(
                                    context,
                                  )!.pleaseEnterPassword;
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: isSmallScreen ? 28 : 36),

                            // Sign in button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        state is AuthLoading
                                            ? null
                                            : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context.read<AuthBloc>().add(
                                                  LoginEvent(
                                                    username:
                                                        _usernameController
                                                            .text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                  ),
                                                );
                                              }
                                            },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: isSmallScreen ? 16 : 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child:
                                        state is AuthLoading
                                            ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                            : Text(
                                              GalleryLocalizations.of(
                                                context,
                                              )!.signIn,
                                              style: TextStyle(
                                                fontSize:
                                                    isSmallScreen ? 16 : 18,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: isSmallScreen ? 24 : 28),
                          ],
                        ),
                      ),
                    ),
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
