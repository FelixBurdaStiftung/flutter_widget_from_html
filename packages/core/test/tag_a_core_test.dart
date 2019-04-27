import 'package:flutter_test/flutter_test.dart';

import '_.dart';

const kHref = 'http://domain.com/href';
const kImgSrc = 'http://domain.com/image.png';

void main() {
  testWidgets('renders underline', (WidgetTester tester) async {
    final html = '<a href="$kHref">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(+u+onTap:Foo)]'));
  });

  testWidgets('renders inline stylings', (WidgetTester tester) async {
    final html = '<a href="$kHref" style="color: #f00">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FFFF0000+u+onTap:Foo)]'));
  });

  testWidgets('renders inner stylings', (WidgetTester tester) async {
    final html = '<a href="$kHref"><b><i>Foo</i></b></a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(+u+i+b+onTap:Foo)]'));
  });

  testWidgets('renders DIV tag inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[GestureDetector:child=[RichText:(+u:Foo)]]'),
    );
  });

  testWidgets('renders DIV tags inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div><div>Bar</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Column:children='
        '[GestureDetector:child=[RichText:(+u:Foo)]],'
        '[GestureDetector:child=[RichText:(+u:Bar)]]]',
      ),
    );
  });

  testWidgets('renders IMG tag inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><img src="$kImgSrc" /></a>';
    final explained = await explain(tester, html, imageUrlToPrecache: kImgSrc);
    expect(
        explained,
        equals('[GestureDetector:child=[Image:image='
            '[NetworkImage:url=http://domain.com/image.png]]]'));
  });

  testWidgets('renders margin inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div style="margin: 5px">Foo</div></a>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[Padding:(5,5,5,5),child='
            '[GestureDetector:child=[RichText:(+u:Foo)]]]'));
  });
}