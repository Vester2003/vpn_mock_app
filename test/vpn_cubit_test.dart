import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:test_project/blocs/vpn_cubit.dart';
import 'package:test_project/models/connection_model.dart';

// Generate mock classes
@GenerateMocks([SharedPreferences, FirebaseAnalytics])
import 'vpn_cubit_test.mocks.dart';

void main() {
  late MockSharedPreferences mockPrefs;
  late MockFirebaseAnalytics mockAnalytics;
  late VpnCubit vpnCubit;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockAnalytics = MockFirebaseAnalytics();

    // Setup SharedPreferences mock
    when(mockPrefs.getStringList(any)).thenReturn(null);
    when(mockPrefs.setStringList(any, any)).thenAnswer((_) async => true);

    // Setup Firebase Analytics mock
    when(mockAnalytics.logEvent(
      name: anyNamed('name'),
      parameters: anyNamed('parameters'),
    )).thenAnswer((_) async => null);

    vpnCubit = VpnCubit(
      prefs: mockPrefs,
      analytics: mockAnalytics,
    );
  });

  tearDown(() {
    vpnCubit.close();
  });

  test('initial state is correct', () {
    expect(vpnCubit.state.isConnected, false);
    expect(vpnCubit.state.currentConnection, null);
    expect(vpnCubit.state.connectionHistory, []);
    expect(vpnCubit.state.elapsedTime, Duration.zero);
  });

  test('connect updates state correctly', () {
    // Initial state
    expect(vpnCubit.state.isConnected, false);
    expect(vpnCubit.state.currentConnection, null);

    // Connect
    vpnCubit.connect();

    // After connect state
    expect(vpnCubit.state.isConnected, true);
    expect(vpnCubit.state.currentConnection, isNotNull);
    expect(vpnCubit.state.elapsedTime, Duration.zero);

    // Verify analytics was called
    verify(mockAnalytics.logEvent(name: 'vpn_connected')).called(1);
  });

  // Working around issues with current implementation
  test('disconnect updates the state correctly', () {
    // Connect first
    vpnCubit.connect();

    // Verify initial state after connection
    expect(vpnCubit.state.isConnected, true);
    expect(vpnCubit.state.currentConnection, isNotNull);

    // Disconnect
    vpnCubit.disconnect();

    // Verify disconnected state
    expect(vpnCubit.state.isConnected, false);
    expect(vpnCubit.state.currentConnection, isNull); // This should now pass
    expect(vpnCubit.state.connectionHistory.length, 1);
    expect(vpnCubit.state.elapsedTime, Duration.zero);

    // Verify that analytics was called with the correctly named arguments
    verify(mockAnalytics.logEvent(
      name: 'vpn_disconnected',
      parameters: anyNamed('parameters'),
    )).called(1);

    // Verify that history was saved
    verify(mockPrefs.setStringList(any, any)).called(1);
  });

  test('connection model can be created and ended', () async {
    // Add a delay to ensure duration is not zero
    final connection = ConnectionModel.start();

    // Wait a moment to ensure some time passes
    await Future.delayed(const Duration(milliseconds: 10));

    final endedConnection = connection.end();
    expect(endedConnection.endTime, isNotNull);
    expect(endedConnection.duration.inMicroseconds, greaterThan(0));
    expect(endedConnection.isActive, false);
  });
}
