import 'dart:convert';
import 'dart:io';

import 'package:json_conv/json_conv.dart';
import 'package:json_god/json_god.dart' as god;
import 'package:dartson/dartson.dart' as d;

@d.Entity()
class Simple {
  int id;
  String text;

  Simple();
  Simple.w(this.id, this.text);

  @override
  String toString() {
    return "$id: $text";
  }
}

@d.Entity()
class Test6 {
  List<Simple> simple;

  Test6();

  @override
  String toString() {
    return simple.fold("Test6: \n", (a, b) => a + b.toString() + "\n");
  }
}

String list;

void main(List<String> args) {
  final file = new File("test.json");
  list = file.readAsStringSync();
  print("starting benchmark");
  print("benching Encoding:");
  testEncoding();
  print("benching Decoding:");
  testDecoding();
}

void testEncoding() {
  List<Test6> l = new List<Test6>();
  for (int i = 0; i < 30000; i++) {
    Test6 t = new Test6();
    t.simple = new List<Simple>();
    t.simple.add(new Simple.w(i, "first $i"));
    t.simple.add(new Simple.w(i + 1, "second $i"));
    t.simple.add(new Simple.w(i + 2, "third $i"));
    l.add(t);
  }
  int its = 30;
  Stopwatch w = new Stopwatch();

  w.reset();
  w.start();
  for (int i = 0; i < its; i++) {
    var b = encode(l);
  }
  w.stop();
  print("json_conv took: ${w.elapsedMilliseconds}");

  w.reset();
  w.start();
  for (int i = 0; i < its; i++) {
    var b = god.serialize(l);
  }
  w.stop();
  print("json_god took: ${w.elapsedMilliseconds}");

  w.reset();
  w.start();
  var dson = new d.Dartson.JSON();
  for (int i = 0; i < its; i++) {
    var b = dson.encode(l);
  }
  w.stop();
  print("dartson took: ${w.elapsedMilliseconds}");
}

void testDecoding() {
  int its = 20;
  Stopwatch w = new Stopwatch();
  w.start();
  for (int i = 0; i < its; i++) {
    var b = JSON.decode(list);
  }
  w.stop();
  print("JSON.decode took: ${w.elapsedMilliseconds}");

  w.reset();
  w.start();
  for (int i = 0; i < its; i++) {
    var b = decode<List<Test6>>(list, new List<Test6>().runtimeType);
  }
  w.stop();
  print("json_conv decode took: ${w.elapsedMilliseconds}");

  w.reset();
  w.start();
  for (int i = 0; i < its; i++) {
    var b = decodeObj<List<Test6>>(
        JSON.decode(list), new List<Test6>().runtimeType);
  }
  w.stop();
  print("json_conv decodeObj took: ${w.elapsedMilliseconds}");

  w.reset();
  w.start();
  for (int i = 0; i < its; i++) {
    var b = god.deseriaizeJson(list, outputType: new List<Test6>().runtimeType);
  }
  w.stop();
  print("json_god took: ${w.elapsedMilliseconds}");

  w.reset();
  w.start();
  var dson = new d.Dartson.JSON();
  for (int i = 0; i < its; i++) {
    var b = dson.decode(list, new Test6(), true);
  }
  w.stop();
  print("dartson took: ${w.elapsedMilliseconds}");
}
