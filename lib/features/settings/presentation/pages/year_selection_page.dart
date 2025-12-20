import 'package:flutter/material.dart';
import 'package:progres/core/services/year_selection_service.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/enrollment/data/repositories/enrollment_repository_impl.dart';
import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/profile/data/services/profile_cache_service.dart';
import 'package:progres/l10n/app_localizations.dart';
import 'package:restart_app/restart_app.dart';

class YearSelectionPage extends StatefulWidget {
  const YearSelectionPage({super.key});

  @override
  State<YearSelectionPage> createState() => _YearSelectionPageState();
}

class _YearSelectionPageState extends State<YearSelectionPage> {
  final YearSelectionService _yearService = YearSelectionService();
  final ProfileCacheService _cacheService = ProfileCacheService();
  final EnrollmentRepositoryImpl _enrollmentRepo = EnrollmentRepositoryImpl(
    apiClient: ApiClient(),
  );

  List<Enrollment>? _enrollments;
  bool _isLoading = true;
  String? _error;
  int? _selectedYearId;

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  Future<void> _loadEnrollments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get currently selected year if any
      final currentSelectedYearId = await _yearService.getSelectedYearId();

      final enrollments = await _enrollmentRepo.getStudentEnrollments();

      // Sort by year ID descending (most recent first)
      enrollments.sort(
        (a, b) => b.anneeAcademiqueId.compareTo(a.anneeAcademiqueId),
      );

      setState(() {
        _enrollments = enrollments;
        // Pre-select the currently selected year
        _selectedYearId = currentSelectedYearId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmSelection() async {
    if (_selectedYearId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectYear)),
      );
      return;
    }

    final selectedEnrollment = _enrollments!.firstWhere(
      (e) => e.anneeAcademiqueId == _selectedYearId,
    );

    await _yearService.saveSelectedYear(
      selectedEnrollment.anneeAcademiqueId,
      selectedEnrollment.anneeAcademiqueCode,
    );

    await _cacheService.clearCache();

    await Restart.restartApp();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.selectAcademicYear),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.errorLoadingData,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _loadEnrollments,
                      icon: const Icon(Icons.refresh),
                      label: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              )
            : _enrollments == null || _enrollments!.isEmpty
            ? Center(
                child: Text(
                  AppLocalizations.of(context)!.noEnrollmentsFound,
                  style: theme.textTheme.titleMedium,
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                    child: Text(
                      AppLocalizations.of(context)!.selectYearDescription,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 24,
                      ),
                      itemCount: _enrollments!.length,
                      itemBuilder: (context, index) {
                        final enrollment = _enrollments![index];
                        final isSelected =
                            _selectedYearId == enrollment.anneeAcademiqueId;
                        final locale = Localizations.localeOf(context);
                        final localizedEnrollment = LocalizedEnrollment(
                          deviceLocale: locale,
                          enrollment: enrollment,
                        );

                        return Card(
                          margin: EdgeInsets.only(
                            bottom: isSmallScreen ? 12 : 16,
                          ),
                          elevation: isSelected ? 4 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedYearId = enrollment.anneeAcademiqueId;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              child: Row(
                                children: [
                                  Radio<int>(
                                    value: enrollment.anneeAcademiqueId,
                                    groupValue: _selectedYearId,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedYearId = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          enrollment.anneeAcademiqueCode,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: isSmallScreen
                                                    ? 14
                                                    : 16,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          localizedEnrollment.niveauLibelleLong,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontSize: isSmallScreen
                                                    ? 12
                                                    : 14,
                                              ),
                                        ),
                                        if (localizedEnrollment
                                            .ofLlSpecialite
                                            .isNotEmpty)
                                          Text(
                                            localizedEnrollment.ofLlSpecialite,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  fontSize: isSmallScreen
                                                      ? 11
                                                      : 13,
                                                ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedYearId != null
                            ? _confirmSelection
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 16,
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.confirm,
                          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
