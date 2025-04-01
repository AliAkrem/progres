import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepositoryImpl(),
        ),
        RepositoryProvider(
          create: (context) => StudentRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepositoryImpl>(),
            )..add(CheckAuthStatusEvent()),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              studentRepository: context.read<StudentRepositoryImpl>(),
              authRepository: context.read<AuthRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => AcademicsBloc(
              studentRepository: context.read<StudentRepositoryImpl>(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            final appRouter = AppRouter(context: context);
            return MaterialApp.router(
              title: 'Student Portal',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              routerConfig: appRouter.router,
            );
          },
        ),
      ),
    );
  }
}