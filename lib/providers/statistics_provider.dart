import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:public_issue_reporter/data_models/statistics.dart';

class StatisticsProvider with ChangeNotifier {
  Statistics _overallStatistics = Statistics();
  Statistics _localStatistics = Statistics();

  Statistics get localStatistics => _localStatistics;

  Statistics get overallStatistics => _overallStatistics;

  updateOverallStatistics({Statistics statistics}) {
    _overallStatistics.all_issues =
        statistics.all_issues ?? _overallStatistics.all_issues;
    _overallStatistics.pending_issues =
        statistics.pending_issues ?? _overallStatistics.pending_issues;
    _overallStatistics.rejected_issues =
        statistics.rejected_issues ?? _overallStatistics.rejected_issues;
    _overallStatistics.solved_issues =
        statistics.solved_issues ?? _overallStatistics.solved_issues;
    notifyListeners();
  }

  updateLocalStatistics({Statistics statistics}) {
    _localStatistics.all_issues =
        statistics.all_issues ?? _localStatistics.all_issues;
    _localStatistics.pending_issues =
        statistics.pending_issues ?? _localStatistics.pending_issues;
    _localStatistics.rejected_issues =
        statistics.rejected_issues ?? _localStatistics.rejected_issues;
    _localStatistics.solved_issues =
        statistics.solved_issues ?? _localStatistics.solved_issues;
    notifyListeners();
  }
}
