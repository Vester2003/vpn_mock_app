import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../models/connection_model.dart';

// VPN State
class VpnState extends Equatable {
  final bool isConnected;
  final ConnectionModel? currentConnection;
  final List<ConnectionModel> connectionHistory;
  final Duration elapsedTime;

  const VpnState({
    this.isConnected = false,
    this.currentConnection,
    this.connectionHistory = const [],
    this.elapsedTime = Duration.zero,
  });

  VpnState copyWith({
    bool? isConnected,
    ConnectionModel? currentConnection,
    List<ConnectionModel>? connectionHistory,
    Duration? elapsedTime,
  }) {
    return VpnState(
      isConnected: isConnected ?? this.isConnected,
      currentConnection:
          isConnected == false ? null : (currentConnection ?? this.currentConnection),
      connectionHistory: connectionHistory ?? this.connectionHistory,
      elapsedTime: elapsedTime ?? this.elapsedTime,
    );
  }

  @override
  List<Object?> get props => [
        isConnected,
        currentConnection,
        connectionHistory,
        elapsedTime,
      ];
}

class VpnCubit extends Cubit<VpnState> {
  static const String _prefs_key = 'vpn_connection_history';

  final SharedPreferences _prefs;
  final FirebaseAnalytics? _analytics;
  Timer? _timer;

  VpnCubit({
    required SharedPreferences prefs,
    FirebaseAnalytics? analytics,
  })  : _prefs = prefs,
        _analytics = analytics,
        super(const VpnState()) {
    _loadConnectionHistory();
  }

  Future<void> _loadConnectionHistory() async {
    try {
      final jsonList = _prefs.getStringList(_prefs_key);
      if (jsonList != null) {
        final List<ConnectionModel> history = jsonList
            .map((jsonString) =>
                ConnectionModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>))
            .toList();

        // Sort by start time (most recent first)
        history.sort((a, b) => b.startTime.compareTo(a.startTime));

        // Keep only the last 5 connections
        final latestConnections = history.length > 5 ? history.sublist(0, 5) : history;

        emit(state.copyWith(connectionHistory: latestConnections));
      }
    } catch (e) {
      // Handle error silently - no previous data
    }
  }

  Future<void> _saveConnectionHistory() async {
    try {
      final jsonList = state.connectionHistory.map((conn) => jsonEncode(conn.toJson())).toList();
      await _prefs.setStringList(_prefs_key, jsonList);
    } catch (e) {
      // Error saving data - handle silently or log
    }
  }

  void connect() {
    if (state.isConnected) return;

    final newConnection = ConnectionModel.start();

    // Log analytics event if available
    _analytics?.logEvent(name: 'vpn_connected');

    emit(state.copyWith(
      isConnected: true,
      currentConnection: newConnection,
      elapsedTime: Duration.zero,
    ));

    // Start timer to update elapsed time
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.currentConnection != null) {
        final elapsedTime = DateTime.now().difference(state.currentConnection!.startTime);
        emit(state.copyWith(elapsedTime: elapsedTime));
      }
    });
  }

  void disconnect() {
    if (!state.isConnected) return;

    // Cancel timer
    _timer?.cancel();
    _timer = null;

    // Update current connection with end time
    final endedConnection = state.currentConnection!.end();

    // Log analytics event with duration if available
    _analytics?.logEvent(
      name: 'vpn_disconnected',
      parameters: {'duration_seconds': endedConnection.duration.inSeconds},
    );

    // Add to history (most recent first)
    final updatedHistory = [
      endedConnection,
      ...state.connectionHistory,
    ];

    // Keep only the last 5 connections
    final latestConnections =
        updatedHistory.length > 5 ? updatedHistory.sublist(0, 5) : updatedHistory;

    emit(state.copyWith(
      isConnected: false,
      currentConnection: null,
      connectionHistory: latestConnections,
      elapsedTime: Duration.zero,
    ));

    // Save updated history
    _saveConnectionHistory();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
