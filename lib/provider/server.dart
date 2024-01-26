class Server {
  static final Server _instance = Server._internal();
  String _url = 'http://3.84.121.212';
  Server._internal();
  factory Server() {
    return _instance;
  }
  String get url => _url;
  set url(String newUrl) {
    _url = newUrl;
  }
}
