import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_card.dart';
import '../widgets/loading_widget.dart' as loading;
import '../widgets/error_widget.dart' as error_widget;
import 'profile_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<UserProvider>().fetchUsers();
  }

  void _showFilterDialog() {
    final provider = context.read<UserProvider>();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Filter by Country'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('All Countries'),
                  leading: Radio<String?>(
                    value: null,
                    groupValue: provider.selectedCountry,
                    onChanged: (value) {
                      provider.filterByCountry(value);
                      Navigator.pop(dialogContext);
                    },
                  ),
                  onTap: () {
                    provider.filterByCountry(null);
                    Navigator.pop(dialogContext);
                  },
                ),
                ...provider.availableCountries.map((country) {
                  return ListTile(
                    title: Text(country),
                    leading: Radio<String?>(
                      value: country,
                      groupValue: provider.selectedCountry,
                      onChanged: (value) {
                        provider.filterByCountry(value);
                        Navigator.pop(dialogContext);
                      },
                    ),
                    onTap: () {
                      provider.filterByCountry(country);
                      Navigator.pop(dialogContext);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Home screen',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Consumer<UserProvider>(
            builder: (context, provider, child) {
              if (provider.status == UserStateStatus.loaded) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.black87),
                      onPressed: _showFilterDialog,
                    ),
                    if (provider.selectedCountry != null)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.status == UserStateStatus.loading) {
            return const loading.LoadingWidget();
          } else if (provider.status == UserStateStatus.error) {
            return error_widget.ErrorDisplayWidget(
              message: provider.errorMessage,
              onRetry: _handleRefresh,
            );
          } else if (provider.status == UserStateStatus.loaded) {
            if (provider.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No profiles found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try changing your filters',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: provider.users.length,
                itemBuilder: (context, index) {
                  final user = provider.users[index];
                  return UserCard(
                    user: user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDetailScreen(userId: user.id),
                        ),
                      );
                    },
                    onLikeTap: () {
                      provider.toggleLike(user.id);
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
