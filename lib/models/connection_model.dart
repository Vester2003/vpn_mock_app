import 'package:equatable/equatable.dart';

class ConnectionModel extends Equatable {
  final DateTime startTime;
  final DateTime? endTime;
  final Duration duration;

  const ConnectionModel({required this.startTime, this.endTime, this.duration = Duration.zero});

  factory ConnectionModel.start() {
    return ConnectionModel(startTime: DateTime.now());
  }

  ConnectionModel copyWith({DateTime? startTime, DateTime? endTime, Duration? duration}) {
    return ConnectionModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime,
      duration: duration ?? this.duration,
    );
  }

  ConnectionModel end() {
    final now = DateTime.now();
    final duration = now.difference(startTime);
    return copyWith(endTime: now, duration: duration);
  }

  bool get isActive => endTime == null;

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'duration': duration.inSeconds,
    };
  }

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int),
      endTime:
          json['endTime'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['endTime'] as int)
              : null,
      duration: Duration(seconds: json['duration'] as int),
    );
  }

  @override
  List<Object?> get props => [startTime, endTime, duration];
}
