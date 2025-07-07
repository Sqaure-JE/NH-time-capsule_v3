class Milestone {
  final String id;
  final String emoji;
  final String text;
  final int bonusPoints;
  final String description;

  Milestone({
    required this.id,
    required this.emoji,
    required this.text,
    required this.bonusPoints,
    required this.description,
  });

  // Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emoji': emoji,
      'text': text,
      'bonusPoints': bonusPoints,
      'description': description,
    };
  }

  // Map에서 생성
  factory Milestone.fromMap(Map<String, dynamic> map) {
    return Milestone(
      id: map['id'],
      emoji: map['emoji'],
      text: map['text'],
      bonusPoints: map['bonusPoints'],
      description: map['description'],
    );
  }

  // 기본 이정표들
  static List<Milestone> get defaultMilestones => [
    Milestone(
      id: 'saving',
      emoji: '💰',
      text: '저축했어요',
      bonusPoints: 10,
      description: '목표 금액을 저축했습니다.',
    ),
    Milestone(
      id: 'sacrifice',
      emoji: '🚫',
      text: '참았어요',
      bonusPoints: 15,
      description: '불필요한 지출을 참았습니다.',
    ),
    Milestone(
      id: 'progress',
      emoji: '📈',
      text: '목표에 가까워졌어요',
      bonusPoints: 20,
      description: '목표 달성에 한 걸음 더 가까워졌습니다.',
    ),
    Milestone(
      id: 'challenge',
      emoji: '💪',
      text: '어려움을 극복했어요',
      bonusPoints: 25,
      description: '어려운 상황을 극복했습니다.',
    ),
  ];

  // ID로 이정표 찾기
  static Milestone? findById(List<Milestone> milestones, String id) {
    try {
      return milestones.firstWhere((milestone) => milestone.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'Milestone(id: $id, text: $text, bonusPoints: $bonusPoints)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Milestone && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
