class GreenAction {
  final String action;
  final String emotion;
  final String reflection;
  final bool isAnonymous;
  final int earnedPoints;
  final DateTime timestamp;

  GreenAction({
    required this.action,
    required this.emotion,
    required this.reflection,
    required this.isAnonymous,
    required this.earnedPoints,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'action': action,
        'emotion': emotion,
        'reflection': reflection,
        'isAnonymous': isAnonymous,
        'earnedPoints': earnedPoints,
        'timestamp': timestamp.toIso8601String(),
      };

  factory GreenAction.fromJson(
    Map<String, dynamic> json,
  ) =>
      GreenAction(
        action: json['action'],
        emotion: json['emotion'],
        reflection: json['reflection'],
        isAnonymous: json['isAnonymous'],
        earnedPoints: json['earnedPoints'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}