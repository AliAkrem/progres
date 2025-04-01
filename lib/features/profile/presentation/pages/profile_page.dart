import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile data if not already loaded
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is! ProfileLoaded) {
      context.read<ProfileBloc>().add(LoadProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.goNamed(AppRouter.settings);
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else if (state is ProfileLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Profile image
                if (state.profileImage != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(
                      _decodeBase64Image(state.profileImage!),
                    ),
                  )
                else
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                const SizedBox(height: 16),
                Text(
                  '${state.basicInfo.prenomLatin} ${state.basicInfo.nomLatin}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${state.basicInfo.prenomArabe} ${state.basicInfo.nomArabe}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                _buildInfoCard(
                  title: 'Personal Information',
                  children: [
                    _buildInfoRow('Student Code', state.detailedInfo.numeroInscription),
                    _buildInfoRow('Full Name (Latin)', '${state.basicInfo.prenomLatin} ${state.basicInfo.nomLatin}'),
                    _buildInfoRow('Full Name (Arabic)', '${state.basicInfo.prenomArabe} ${state.basicInfo.nomArabe}'),
                    _buildInfoRow('Birth Date', state.basicInfo.dateNaissance),
                    _buildInfoRow('Birth Place', state.basicInfo.lieuNaissance),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  title: 'Academic Information',
                  children: [
                    _buildInfoRow('Current Year', state.academicYear.code),
                    _buildInfoRow('Level', state.detailedInfo.niveauLibelleLongLt),
                    _buildInfoRow('Cycle', state.detailedInfo.refLibelleCycle),
                    _buildInfoRow('Registration Number', state.detailedInfo.numeroInscription),
                    _buildInfoRow('Transport Paid', state.detailedInfo.transportPaye ? 'Yes' : 'No'),
                  ],
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No profile data available'),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to decode base64 image
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
} 