// ============================================================
// Experiment 2: Adaptive and Responsive UI Design
// App     : ShopEasy – product catalog
// Widgets : LayoutBuilder, GridView.builder, ChoiceChip, TextField
// Rule    : width < 600 -> 2 columns, 600-899 -> 3, >= 900 -> 4
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const ShopEasyApp());
}

// -------------------------------------------------------
// Palette
// -------------------------------------------------------
const Color kBackground = Color(0xFF14102B); // midnight indigo
const Color kSurface = Color(0xFF221B44);
const Color kAccent = Color(0xFF2EC4B6); // teal
const Color kHighlight = Color(0xFFFFBF69); // warm gold
const Color kTextSoft = Color(0xFFADA6CF);

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEasy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const CatalogPage(),
    );
  }
}

// -------------------------------------------------------
// Data Model
// -------------------------------------------------------
class Product {
  final String name;
  final String category;
  final int price;
  final double rating;
  final String icon;
  final Color tint;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.icon,
    required this.tint,
  });
}

const List<Product> products = [
  Product(name: 'Laptop', category: 'Electronics', price: 54999, rating: 4.5, icon: '💻', tint: Color(0xFF4CC9F0)),
  Product(name: 'Smartphone', category: 'Electronics', price: 29999, rating: 4.7, icon: '📱', tint: Color(0xFF2EC4B6)),
  Product(name: 'Headphones', category: 'Electronics', price: 4499, rating: 4.3, icon: '🎧', tint: Color(0xFFB388EB)),
  Product(name: 'Smart Watch', category: 'Accessories', price: 9999, rating: 4.6, icon: '⌚', tint: Color(0xFFFFBF69)),
  Product(name: 'Camera', category: 'Electronics', price: 39999, rating: 4.4, icon: '📷', tint: Color(0xFFEF476F)),
  Product(name: 'Sneakers', category: 'Fashion', price: 3999, rating: 4.2, icon: '👟', tint: Color(0xFF06D6A0)),
  Product(name: 'Backpack', category: 'Fashion', price: 2499, rating: 4.1, icon: '🎒', tint: Color(0xFFFF5D8F)),
  Product(name: 'Tablet', category: 'Electronics', price: 24999, rating: 4.5, icon: '📟', tint: Color(0xFF7B8CDE)),
];

const List<String> categories = ['All', 'Electronics', 'Fashion', 'Accessories'];

String formatPrice(int value) {
  final s = value.toString();
  if (s.length <= 3) return '₹ $s';
  final head = s.substring(0, s.length - 3);
  final withCommas = head.replaceAllMapped(
    RegExp(r'(\d)(?=(\d\d)+$)'),
    (m) => '${m[1]},',
  );
  return '₹ $withCommas,${s.substring(s.length - 3)}';
}

// -------------------------------------------------------
// Catalog page – search + chips + responsive grid
// -------------------------------------------------------
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String _category = 'All';
  String _query = '';
  int _cartCount = 0;

  List<Product> get _visible => products.where((p) {
        final byCat = _category == 'All' || p.category == _category;
        final byName = p.name.toLowerCase().contains(_query.toLowerCase());
        return byCat && byName;
      }).toList();

  // Breakpoint rule used by LayoutBuilder
  int _columnsFor(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  String _deviceFor(double width) {
    if (width >= 900) return 'Desktop';
    if (width >= 600) return 'Tablet';
    return 'Mobile';
  }

  void _addToCart(Product p) {
    setState(() => _cartCount++);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${p.icon} ${p.name} added to cart'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: kAccent,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackground,
        title: const Text(
          'ShopEasy',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: kAccent,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAccent.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, size: 18, color: kAccent),
                const SizedBox(width: 6),
                Text('$_cartCount',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      // LayoutBuilder gives us the available width to pick the column count
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = _columnsFor(width);
          final items = _visible;

          return Column(
            children: [
              // -- Banner shows the live layout decision --
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kAccent, Color(0xFF5E60CE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EXPERIMENT 2',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Adaptive & Responsive UI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_deviceFor(width)} · ${width.toInt()}px · $columns columns',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Text('📐', style: TextStyle(fontSize: 44)),
                  ],
                ),
              ),

              // -- Search --
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, color: kAccent),
                    filled: true,
                    fillColor: kSurface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // -- Category chips --
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final c = categories[i];
                    return ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      selectedColor: kAccent,
                      backgroundColor: kSurface,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _category == c ? kBackground : Colors.white,
                      ),
                      side: BorderSide.none,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _category = c),
                    );
                  },
                ),
              ),

              // -- Responsive grid --
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text('No products found',
                            style: TextStyle(color: kTextSoft)),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, i) => ProductCard(
                          product: items[i],
                          onAdd: () => _addToCart(items[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------
// Reusable ProductCard
// -------------------------------------------------------
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: product.tint.withValues(alpha: 0.18),
              child: Center(
                child: Text(product.icon, style: const TextStyle(fontSize: 46)),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: product.tint),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: kHighlight),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 13, color: kHighlight),
                      const SizedBox(width: 2),
                      Text('${product.rating}',
                          style: const TextStyle(
                              fontSize: 11, color: kTextSoft)),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: FilledButton.icon(
                      onPressed: onAdd,
                      style: FilledButton.styleFrom(
                        backgroundColor: kAccent,
                        foregroundColor: kBackground,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.add_shopping_cart, size: 14),
                      label: const Text('Add',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
