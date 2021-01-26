import 'package:tiled/src/json/framejson.dart';
import 'package:tiled/src/json/layerjson.dart';
import 'package:tiled/src/json/propertyjson.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

class TileJson {
  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  List<FrameJson> animation = [];
  int id;
  Image image;
  LayerJson objectgroup;
  double probability;
  List<PropertyJson> properties = [];
  List<int> terrain = []; // index of the terrain
  String type;

  //Additionaly
  bool flippedHorizontally;
  bool flippedVertically;
  bool flippedDiagonally;

  TileJson(
      {this.animation,
      this.id,
      this.image,
      this.objectgroup,
      this.probability,
      this.properties,
      this.terrain,
      this.type});

  TileJson.fromXML(XmlElement xmlElement) {
    id = int.tryParse(xmlElement.getAttribute('id') ?? '');
    // get flips from id
    flippedHorizontally = (id & FLIPPED_HORIZONTALLY_FLAG) == FLIPPED_HORIZONTALLY_FLAG; //TODO Test
    flippedVertically = (id & FLIPPED_VERTICALLY_FLAG) == FLIPPED_VERTICALLY_FLAG;
    flippedDiagonally = (id & FLIPPED_DIAGONALLY_FLAG) == FLIPPED_DIAGONALLY_FLAG;
    //clear id from flips
    id &= ~(FLIPPED_HORIZONTALLY_FLAG | FLIPPED_VERTICALLY_FLAG | FLIPPED_DIAGONALLY_FLAG);

    probability = double.tryParse(xmlElement.getAttribute('probability') ?? '0');
    type = xmlElement.getAttribute('type');
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'image':
          image = Image.fromXML(element);
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {properties.add(PropertyJson.fromXML(element));});
          break;
        case 'terrain':
          element.nodes.whereType<XmlElement>().forEach((element) {terrain.add(int.tryParse(element.getAttribute('id') ?? ''));}); // TODO int? is this ok?  // comma-separated indexes
          break;
        case 'animation':
          element.nodes.whereType<XmlElement>().forEach((element) {animation.add(FrameJson.fromXML(element));});
          break;
        case 'objectgroup':
          objectgroup = LayerJson.fromXML(element); //TODO explicit ObjectGroup instead of Layer
          break;
      }
    });
  }

  TileJson.fromJson(Map<String, dynamic> json) {
    if (json['animation'] != null) {
      animation = <FrameJson>[];
      json['animation'].forEach((v) {
        animation.add(FrameJson.fromJson(v));
      });
    }
    id = json['id'];
    if(json['image'] != null){
      image = Image(json['image'], json['imageheight'], json['imagewidth']);
    }
    objectgroup = json['objectgroup'];
    probability = json['probability'] ?? 0;
    if (json['properties'] != null) {
      properties = <PropertyJson>[];
      json['properties'].forEach((v) {
        properties.add(PropertyJson.fromJson(v));
      });
    }
    if (json['terrain'] != null) {
      terrain = <int>[];
      json['terrain'].forEach((v) {
        terrain.add(v);
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (animation != null) {
      data['animation'] = animation.map((v) => v).toList();
    }
    data['id'] = id;
    data['image'] = image.source;
    data['imageheight'] = image.height;
    data['imagewidth'] = image.width;
    data['objectgroup'] = objectgroup;
    data['probability'] = probability;
    if (properties != null) {
      data['properties'] = properties.map((v) => v.toJson()).toList();
    }
    if (terrain != null) {
      data['terrain'] = terrain.map((v) => v).toList();
    }
    data['type'] = type;
    return data;
  }

  Tile toTile(Tileset tileset) {
    final Tile tile = Tile(id, tileset);

    tile.image = image;
    tile.properties = <String, dynamic>{};
    properties.forEach((element) {
      tile.properties.putIfAbsent(element.name, () => element.value);
    });

    // TODO not converted
    // tile.animation = animation;
    // tile.objectgroup = objectgroup;
    // tile.probability = probability;
    // tile.terrain = terrain;
    // tile.type = type;

    // TODO not filled
    // // Tile global IDs aren't 1-based, but start from "1" (0 being an "null tile").
    // int gid;
    // int spacing;
    // int margin;
    // int height;
    // int width;
    // Flips flips;
    // int x, y;
    // int px, py;

    return tile;
  }
}
