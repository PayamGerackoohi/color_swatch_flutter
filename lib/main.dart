import 'package:color_swatch/data/entity/color_data.dart';
import 'package:color_swatch/data/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

int columnOf(double width) {
  return 1 + (width / 400.0).floor();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<ColorData> colorsOf(int columnCount) {
    var size = palette[0].length;
    List<ColorData> list = [];
    var hasRow = true;
    for (int row = 0; row < palette.length / columnCount; row++) {
      for (int i = 0; i < size; i++) {
        hasRow = false;
        for (int column = 0; column < columnCount; column++) {
          int c = columnCount * row + column;
          if (c < palette.length && i < palette[c].length) {
            list.add(palette[c][i]);
            hasRow = true;
          } else {
            if (!hasRow) break;
            list.add(emptyColor);
          }
        }
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var columnCount = columnOf(width);
    // TODO inefficient: should be calculated, just when `columnCount` is changed. Also could be cached.
    var colors = colorsOf(columnCount);
    return Scaffold(
        appBar: AppBar(title: const Text('Color Swatch')),
        body: GridView.builder(
            itemCount: colors.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              childAspectRatio: width / 70.0 / columnCount,
            ),
            itemBuilder: (_, int index) => Swatch(colors[index])));
  }
}

SnackBar makeSnackBar(String message) =>
    SnackBar(duration: const Duration(seconds: 1), content: Text(message));

void showSnackBar(context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(makeSnackBar(message));

void copyToClipboard(BuildContext context, String data) {
  Clipboard.setData(ClipboardData(text: data));
  showSnackBar(context, '$data copied to clipboard.');
}

class Swatch extends StatelessWidget {
  final ColorData color;
  const Swatch(this.color, {super.key});

  Widget makeLabel(TextStyle textStyle) => Text(
        color.label,
        style: textStyle,
      );

  Widget makeColorCode(TextStyle textStyle) => Text(
        '#${color.colorCode}',
        style: textStyle,
      );

  @override
  Widget build(BuildContext context) {
    var textStyle = DefaultTextStyle.of(context)
        .style
        .apply(fontSizeFactor: 1.5, color: color.textColor);
    if (color.isHeader) {
      return Container(
          color: color.color,
          child: Align(
            alignment: Alignment.center,
            child: makeLabel(textStyle),
          ));
    } else {
      return InkWell(
          onTap: () => copyToClipboard(context, '#${color.colorCode}'),
          child: Ink(
            color: color.color,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    makeLabel(textStyle),
                    makeColorCode(textStyle),
                  ],
                )),
          ));
    }
  }
}
