import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vpn_cubit.dart';
import '../widgets/connection_animation.dart';
import '../widgets/connection_button.dart';
import '../widgets/connection_status.dart';
import 'analytics_screen.dart';

class VpnScreen extends StatelessWidget {
  const VpnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VPN Connection',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VpnCubit, VpnState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Connection animation
                            ConnectionAnimation(
                              isConnected: state.isConnected,
                            ),

                            const SizedBox(height: 40),

                            // Connection status
                            ConnectionStatus(
                              isConnected: state.isConnected,
                              elapsedTime: state.elapsedTime,
                            ),

                            const SizedBox(height: 60),

                            // Connection button
                            ConnectionButton(
                              isConnected: state.isConnected,
                              onPressed: () {
                                if (state.isConnected) {
                                  context.read<VpnCubit>().disconnect();
                                } else {
                                  context.read<VpnCubit>().connect();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // History button at the bottom
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.history),
                          label: const Text('View Connection History'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AnalyticsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
