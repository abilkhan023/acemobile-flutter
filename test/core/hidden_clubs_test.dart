import 'package:ace_mobile/core/api/hidden_clubs.dart';
import 'package:ace_mobile/core/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gc = Env.hiddenGameCenterIds.first;
  final br = Env.hiddenBranchIds.first;

  test('strips hidden club from plain lists and paged responses', () {
    final list = [
      {'id': gc, 'name': 'test'},
      {'id': 'x', 'name': 'Next Level'},
    ];
    expect((stripHiddenClubs(list) as List).length, 1);
    final paged = {'data': [{'branch_id': br}, {'branch_id': 'y'}, {'game_center_id': gc}], 'items': 3, 'pages': 1};
    final out = stripHiddenClubs(paged) as Map;
    expect((out['data'] as List).length, 1);
    expect(out['items'], 1);
  });

  test('matches nested game_center and slug', () {
    expect(isHiddenClubItem({'game_center': {'id': gc}}), isTrue);
    expect(isHiddenClubItem({'game_center': {'slug': 'test'}}), isTrue);
    expect(isHiddenClubItem({'slug': 'test'}), isTrue);
    expect(isHiddenClubItem({'id': 'other', 'slug': 'nlvl'}), isFalse);
    expect(isHiddenClubItem('string'), isFalse);
  });

  test('detects hidden ids in route paths', () {
    expect(isHiddenClubPath('/clubs/$br'), isTrue);
    expect(isHiddenClubPath('/balance/$gc'), isTrue);
    expect(isHiddenClubPath('/clubs/other'), isFalse);
  });
}
