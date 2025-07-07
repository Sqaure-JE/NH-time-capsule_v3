import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class GeneralDiaryListScreen extends StatelessWidget {
  const GeneralDiaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 샘플 데이터
    final List<Map<String, dynamic>> diaries = [
      {
        'date': '2025-07-06',
        'emotion': '😊',
        'amount': '15,000',
        'type': 'expense',
        'category': '식비',
        'content': '오늘은 친구들과 맛있는 점심을 먹었어요. 기분이 좋았습니다!',
        'points': 45,
      },
      {
        'date': '2025-07-05',
        'emotion': '😢',
        'amount': '50,000',
        'type': 'expense',
        'category': '쇼핑',
        'content': '예상보다 많은 돈을 써서 속상했어요. 다음엔 더 신중하게 써야겠어요.',
        'points': 30,
      },
      {
        'date': '2025-07-04',
        'emotion': '😊',
        'amount': '2,450,000',
        'type': 'income',
        'category': '급여',
        'content': '월급이 들어왔어요! 이번 달도 열심히 일한 보람이 있네요.',
        'points': 45,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('일반 금융일기 목록'),
        backgroundColor: NHColors.primary,
      ),
      body: ListView.separated(
        itemCount: diaries.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final diary = diaries[index];
          return ListTile(
            leading: Text(
              diary['emotion'],
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(
              diary['content'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${diary['date']} | ${diary['category']} | ${diary['amount']}원',
            ),
            trailing: Text(
              '+${diary['points']}P',
              style: const TextStyle(color: NHColors.primary),
            ),
            onTap: () {
              // 상세보기 등 추가 가능
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('${diary['date']} ${diary['emotion']}'),
                  content: Text(diary['content']),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('닫기'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
