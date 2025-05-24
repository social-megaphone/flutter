class Platform {
  static bool get isIOS => false;
  static bool get isAndroid => false;
}

class File {
  final String path;
  File(this.path);
  Future<bool> exists() async => false;
  Future<File> copy(String path) async => File(path);
}

class Directory {
  final String path;
  Directory(this.path);
}

Future<Directory> getTemporaryDirectory() async {
  throw UnsupportedError('웹에서는 임시 디렉토리를 사용할 수 없습니다.');
}