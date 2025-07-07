import 'package:flutter/material.dart';

class EmotionCharacter {
  final String id;
  final String emoji;
  final String name;
  final Color color;
  final String description;
  int level;
  int exp;
  int maxExp;

  EmotionCharacter({
    required this.id,
    required this.emoji,
    required this.name,
    required this.color,
    required this.description,
    this.level = 1,
    this.exp = 0,
    required this.maxExp,
  });

  // 레벨업 가능 여부 확인
  bool get canLevelUp => exp >= maxExp;

  // 현재 레벨에서의 진행률 (0.0 ~ 1.0)
  double get progress => exp / maxExp;

  // 경험치 추가
  void addExp(int amount) {
    exp += amount;
    while (canLevelUp) {
      levelUp();
    }
  }

  // 레벨업
  void levelUp() {
    if (canLevelUp) {
      level++;
      exp -= maxExp;
      maxExp = calculateNextLevelExp();
    }
  }

  // 다음 레벨까지 필요한 경험치 계산
  int calculateNextLevelExp() {
    // 레벨이 올라갈수록 필요한 경험치 증가
    return (level * 100) + (level * 50);
  }

  // 캐릭터 정보를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emoji': emoji,
      'name': name,
      'color': color.value,
      'description': description,
      'level': level,
      'exp': exp,
      'maxExp': maxExp,
    };
  }

  // Map에서 캐릭터 정보 생성
  factory EmotionCharacter.fromMap(Map<String, dynamic> map) {
    return EmotionCharacter(
      id: map['id'],
      emoji: map['emoji'],
      name: map['name'],
      color: Color(map['color']),
      description: map['description'],
      level: map['level'] ?? 1,
      exp: map['exp'] ?? 0,
      maxExp: map['maxExp'],
    );
  }

  // 기본 감정 캐릭터들 생성
  static List<EmotionCharacter> get defaultCharacters => [
    EmotionCharacter(
      id: 'joy',
      emoji: '😊',
      name: '기쁨이',
      color: const Color(0xFFFFD700),
      description: '목표에 한 걸음 더 가까워졌어요!',
      level: 3,
      exp: 100,
      maxExp: 150,
    ),
    EmotionCharacter(
      id: 'sadness',
      emoji: '😢',
      name: '슬픔이',
      color: const Color(0xFF4A90E2),
      description: '힘든 순간도 성장의 기회예요.',
      level: 5,
      exp: 120,
      maxExp: 150,
    ),
    EmotionCharacter(
      id: 'anger',
      emoji: '😡',
      name: '분노',
      color: const Color(0xFFFF4444),
      description: '불합리한 지출에 단호하게 대처해요.',
      level: 2,
      exp: 75,
      maxExp: 150,
    ),
    EmotionCharacter(
      id: 'fear',
      emoji: '😰',
      name: '불안이',
      color: const Color(0xFF9B59B6),
      description: '신중한 계획으로 안전하게 진행해요.',
      level: 7,
      exp: 130,
      maxExp: 150,
    ),
    EmotionCharacter(
      id: 'disgust',
      emoji: '🤢',
      name: '까칠이',
      color: const Color(0xFF2ECC71),
      description: '완벽한 목표 달성을 위해 꼼꼼히!',
      level: 4,
      exp: 110,
      maxExp: 150,
    ),
  ];

  // ID로 캐릭터 찾기
  static EmotionCharacter? findById(
    List<EmotionCharacter> characters,
    String id,
  ) {
    try {
      return characters.firstWhere((char) => char.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'EmotionCharacter(id: $id, name: $name, level: $level, exp: $exp/$maxExp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmotionCharacter && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
