import 'package:flutter/material.dart';

enum DiaryType { general, personalCapsule, groupCapsule }

class FinancialDiary {
  final String id;
  final DiaryType type;
  final DateTime date;
  final String? emotionCharacterId;
  final int? amount;
  final String? content;
  final String? imagePath;
  final String? milestoneId;
  final String? capsuleId; // 타임캡슐 연결 (개인형/모임형)
  final List<String>? memberIds; // 모임형인 경우
  final Map<String, int>? memberAmounts; // 모임형인 경우
  final int points;
  final DateTime createdAt;

  FinancialDiary({
    required this.id,
    required this.type,
    required this.date,
    this.emotionCharacterId,
    this.amount,
    this.content,
    this.imagePath,
    this.milestoneId,
    this.capsuleId,
    this.memberIds,
    this.memberAmounts,
    required this.points,
    required this.createdAt,
  });

  // 감정 캐릭터 정보
  String? get emotionEmoji {
    if (emotionCharacterId == null) return null;
    const emotionEmojis = {
      'joy': '😊',
      'sadness': '😢',
      'anger': '😡',
      'fear': '😰',
      'disgust': '🤢',
    };
    return emotionEmojis[emotionCharacterId];
  }

  // 이정표 정보
  String? get milestoneEmoji {
    if (milestoneId == null) return null;
    const milestoneEmojis = {
      'saving': '💰',
      'sacrifice': '🚫',
      'progress': '📈',
      'challenge': '💪',
    };
    return milestoneEmojis[milestoneId];
  }

  // 이정표 텍스트
  String? get milestoneText {
    if (milestoneId == null) return null;
    const milestoneTexts = {
      'saving': '저축했어요',
      'sacrifice': '참았어요',
      'progress': '목표에 가까워졌어요',
      'challenge': '어려움을 극복했어요',
    };
    return milestoneTexts[milestoneId];
  }

  // 모임형 여부
  bool get isGroup => type == DiaryType.groupCapsule;

  // 개인형 타임캡슐 여부
  bool get isPersonalCapsule => type == DiaryType.personalCapsule;

  // 일반형 여부
  bool get isGeneral => type == DiaryType.general;

  // 사진 포함 여부
  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;

  // 이정표 포함 여부
  bool get hasMilestone => milestoneId != null;

  // 금액 포함 여부
  bool get hasAmount => amount != null && amount! > 0;

  // 총 금액 (모임형인 경우 멤버 금액 합계)
  int get totalAmount {
    if (amount != null) return amount!;
    if (memberAmounts != null) {
      return memberAmounts!.values.fold(0, (sum, amount) => sum + amount);
    }
    return 0;
  }

  // 멤버 수
  int get memberCount {
    if (memberIds != null) return memberIds!.length;
    return 0;
  }

  // Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'date': date.millisecondsSinceEpoch,
      'emotionCharacterId': emotionCharacterId,
      'amount': amount,
      'content': content,
      'imagePath': imagePath,
      'milestoneId': milestoneId,
      'capsuleId': capsuleId,
      'memberIds': memberIds,
      'memberAmounts': memberAmounts,
      'points': points,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Map에서 생성
  factory FinancialDiary.fromMap(Map<String, dynamic> map) {
    return FinancialDiary(
      id: map['id'],
      type: DiaryType.values[map['type']],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      emotionCharacterId: map['emotionCharacterId'],
      amount: map['amount'],
      content: map['content'],
      imagePath: map['imagePath'],
      milestoneId: map['milestoneId'],
      capsuleId: map['capsuleId'],
      memberIds: map['memberIds'] != null
          ? List<String>.from(map['memberIds'])
          : null,
      memberAmounts: map['memberAmounts'] != null
          ? Map<String, int>.from(map['memberAmounts'])
          : null,
      points: map['points'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  // 복사본 생성 (수정용)
  FinancialDiary copyWith({
    String? id,
    DiaryType? type,
    DateTime? date,
    String? emotionCharacterId,
    int? amount,
    String? content,
    String? imagePath,
    String? milestoneId,
    String? capsuleId,
    List<String>? memberIds,
    Map<String, int>? memberAmounts,
    int? points,
    DateTime? createdAt,
  }) {
    return FinancialDiary(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      emotionCharacterId: emotionCharacterId ?? this.emotionCharacterId,
      amount: amount ?? this.amount,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      milestoneId: milestoneId ?? this.milestoneId,
      capsuleId: capsuleId ?? this.capsuleId,
      memberIds: memberIds ?? this.memberIds,
      memberAmounts: memberAmounts ?? this.memberAmounts,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'FinancialDiary(id: $id, type: $type, date: $date, points: $points)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FinancialDiary && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
