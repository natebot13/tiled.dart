part of tiled;

class TiledProjectParser {
  static TiledProject parseJson(String json) {
    final parser = JsonParser(jsonDecode(json) as Map<String, dynamic>);
    return _$TiledProjectFromJson(parser.json);
  }
}
