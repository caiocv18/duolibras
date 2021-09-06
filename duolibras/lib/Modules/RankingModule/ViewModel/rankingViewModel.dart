import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:rxdart/subjects.dart';

abstract class RankingViewModelProtocol {
  Stream<List<User>>? usersRank;
  bool loading = false;
  bool firstTime = true;
  Future<void> fetchUsersRank();
  String formatUserName(String name);

  void disposeStreams();
}

class RankingViewModel extends RankingViewModelProtocol {
  BehaviorSubject<List<User>> _controller = BehaviorSubject<List<User>>();

  RankingViewModel() {
    usersRank = _controller.stream;
  }

  @override
  void disposeStreams() {
    _controller.close();
  }

  @override
  Future<void> fetchUsersRank() async {
    loading = true;
    await Service.instance.getUsersRanking().then((rankings) {
      loading = false;
      firstTime = false;
      _controller.sink.add(rankings);
    }).onError((_, __) {
      loading = false;
      firstTime = false;
      _controller.sink.add([]);
    });
  }

  @override
  String formatUserName(String name) {
    final arr = name.split("@");
    return arr[0];
  }
}
