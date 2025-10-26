import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;
import 'package:restaurant_app/widgets/restaurant_card_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigasi dari halaman list ke detail', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 8));
    expect(find.text('Restaurant List'), findsOneWidget);

    final restaurantCard = find.byType(RestaurantCard).first;
    expect(restaurantCard, findsOneWidget);
    await tester.tap(restaurantCard);

    await tester.pumpAndSettle(const Duration(seconds: 8));

    expect(find.text('Detail Restaurant'), findsOneWidget);

  });
}
