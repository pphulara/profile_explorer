import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'core/utils/network_info.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/usecases/get_users.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NetworkInfo>(
          create: (_) => NetworkInfoImpl(Connectivity()),
        ),
        Provider<UserRemoteDataSource>(
          create: (_) => UserRemoteDataSourceImpl(client: http.Client()),
        ),
        ProxyProvider2<UserRemoteDataSource, NetworkInfo, UserRepositoryImpl>(
          update: (_, remoteDataSource, networkInfo, __) => UserRepositoryImpl(
            remoteDataSource: remoteDataSource,
            networkInfo: networkInfo,
          ),
        ),
        ProxyProvider<UserRepositoryImpl, GetUsers>(
          update: (_, repository, __) => GetUsers(repository),
        ),
        ChangeNotifierProxyProvider<GetUsers, UserProvider>(
          create: (context) => UserProvider(
            getUsers: context.read<GetUsers>(),
          ),
          update: (_, getUsers, previous) =>
              previous ?? UserProvider(getUsers: getUsers),
        ),
      ],
      child: MaterialApp(
        title: 'Profile Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}