import 'package:flutter/material.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:progres/l10n/gallery_localizations.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutPage),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Title
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: isSmallScreen ? 72 : 88,
                      height: isSmallScreen ? 72 : 88,
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
                          size: isSmallScreen ? 36 : 44,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 28 : 32),
                  Text(
                    AppLocalizations.of(context)!.studentPortal,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: isSmallScreen ? 28 : 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.version(_version),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Description
            Text(
              AppLocalizations.of(context)!.description,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.descriptionText),
            const SizedBox(height: 24),

            // Purpose
            Text(
              AppLocalizations.of(context)!.purpose,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.purposeText),
            const SizedBox(height: 24),

            // License
            Text(
              AppLocalizations.of(context)!.license,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(AppLocalizations.of(context)!.licenseText),
                ),
                TextButton(
                  onPressed:
                      () => _launchUrl(
                        'https://github.com/AliAkrem/progres/blob/master/LICENSE',
                      ),
                  child: Text(AppLocalizations.of(context)!.viewLicense),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Contribution
            Text(
              AppLocalizations.of(context)!.contribution,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.projectStatusText),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.code),
                label: Text(AppLocalizations.of(context)!.viewonGitHub),
                onPressed:
                    () => _launchUrl('https://github.com/AliAkrem/progres'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launchI $url');
    }
  }
}
