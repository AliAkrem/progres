import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/discharge/presentation/bloc/discharge_bloc.dart';
import 'package:progres/features/discharge/presentation/widgets/error.dart';
import 'package:progres/features/discharge/presentation/widgets/discharge.dart';
import 'package:progres/l10n/app_localizations.dart';

class DischargePage extends StatefulWidget {
  const DischargePage({super.key});

  @override
  State<DischargePage> createState() => _DischargePageState();
}

class _DischargePageState extends State<DischargePage> {
  @override
  void initState() {
    super.initState();
    _loadDischarge();
  }

  void _loadDischarge() {
    context.read<StudentDischargeBloc>().add(LoadStudentDischarge());
  }

  Future<void> _refreshDischarge() async {
    // Reload fresh data from API
    context.read<StudentDischargeBloc>().add(LoadStudentDischarge());
    // Simulating network delay for better UX
    return Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myDischarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDischarge,
            tooltip: AppLocalizations.of(context)!.refreshDischarge,
          ),
        ],
      ),
      body: BlocBuilder<StudentDischargeBloc, StudentDischargeState>(
        builder: (context, state) {
          if (state is StudentDischargeLoading) {
            return _buildLoadingState();
          } else if (state is StudentDischargeError) {
            return ErrorState(state: state);
          } else if (state is StudentDischargeLoaded) {
            return RefreshIndicator(
              onRefresh: _refreshDischarge,
              child: DischargeContent(discharge: state.studentDischarge),
            );
          } else if (state is StudentDischargeNotRequired) {
            return RefreshIndicator(
              onRefresh: _refreshDischarge,
              child: const DischargeNotRequired(),
            );
          } else {
            return _buildInitialState();
          }
        },
      ),
    );
  }

  Widget _buildInitialState() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.noDischargeData,
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDischarge,
            child: Text(AppLocalizations.of(context)!.loadDischarge),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }
}
