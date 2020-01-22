import 'package:flutter/foundation.dart';

class Statistics with ChangeNotifier {
  int all_issues;
  int solved_issues;
  int rejected_issues;
  int pending_issues;

  Statistics(
      {this.all_issues = 0,
      this.solved_issues = 0,
      this.rejected_issues = 0,
      this.pending_issues = 0});
}
