import 'package:flutter/material.dart';
import '../core/theme.dart';

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({super.key});

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  // TODO: Replace with real cart data from backend
  final Map<String, dynamic> _cartData = {
    'messName': 'Maa\'s Kitchen',
    'items': [
      {'name': 'Veg Thali', 'price': 80, 'quantity': 1},
      {'name': 'Dal Rice', 'price': 50, 'quantity': 2},
    ],
    'subtotal': 180,
    'delivery': 20,
    'total': 200,
  };

  @override
  Widget build(BuildContext context) {
    final items = _cartData['items'] as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mess Name
                  Text(
                    _cartData['messName'] as String? ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cart Items
                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return _buildCartItem(item, index);
                  }),

                  const SizedBox(height: 24),

                  // Bill Details
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildBillRow('Subtotal', '₹${_cartData['subtotal']}'),
                        const SizedBox(height: 12),
                        _buildBillRow('Delivery', '₹${_cartData['delivery']}'),
                        const Divider(height: 24),
                        _buildBillRow(
                          'Total',
                          '₹${_cartData['total']}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Checkout Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to checkout screen
                },
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String? ?? '',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${item['price']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: () {
                        setState(() {
                          if (item['quantity'] as int > 1) {
                            item['quantity'] = (item['quantity'] as int) - 1;
                          }
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${item['quantity']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () {
                        setState(() {
                          item['quantity'] = (item['quantity'] as int) + 1;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
