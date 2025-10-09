import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Category && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

final List<Category> categories = [
  Category(
    id: 'c1',
    name: 'Kebutuhan Pokok',
    icon: Icons.shopping_basket,
    color: Colors.green,
  ),
  Category(
    id: 'c2',
    name: 'Produk Segar',
    icon: Icons.local_grocery_store,
    color: Colors.orange,
  ),
  Category(
    id: 'c3',
    name: 'Produk Kebersihan',
    icon: Icons.cleaning_services,
    color: Colors.purple,
  ),
  Category(
    id: 'c4',
    name: 'Produk Bernilai Tinggi',
    icon: Icons.star,
    color: Colors.red,
  ),
];
