import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/Home/presentation/cubit/home_cubit.dart';
class PopularShoesList extends StatelessWidget {
  const PopularShoesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      // الاستماع للبيانات من الكيوبت
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeError) {
            return Center(child: Text(state.errorMessage));
          } else if (state is HomeLoaded) {
            
            if (state.products.isEmpty) {
              return const Center(child: Text("لا توجد منتجات لهذه الماركة حالياً."));
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ShoeCard(product: state.products[index]); 
              },
            );
          }
          return const SizedBox(); 
        },
      ),
    );
  }
}

class ShoeCard extends StatelessWidget {
  final ProductModel product;
  const ShoeCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Image.network(
                product.imageUrl, // استخدام رابط الصورة من فايربيس
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (product.isBestSeller)
            const Text('BEST SELLER', style: TextStyle(color: Color(0xFF5A9AE5), fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${product.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF5A9AE5),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class BrandsList extends StatelessWidget {
  const BrandsList({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم BlocBuilder للاستماع لتغيرات HomeCubit
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        return SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.brands.length,
            itemBuilder: (context, index) {
              final brand = cubit.brands[index];
              final isSelected = cubit.selectedBrand == brand;

              return GestureDetector(
                onTap: () {
                  cubit.changeBrand(brand); // استدعاء دالة التغيير عند الضغط
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 16),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5A9AE5) : Colors.white,
                    borderRadius: BorderRadius.circular(
                      30,
                    ), // راديوس ثابت للاثنين
                    // امسح سطر الـ shape خالص من هنا
                  ),
                  child: Row(
                    children: [
                      // 💡 يمكنك استبدال هذه الأيقونة بصورة (Image.asset) لشعار الماركة الفعلي
                      Icon(
                        Icons.sports_baseball,
                        color: isSelected ? Colors.white : Colors.black87,
                        size: 24,
                      ),
                      // إظهار اسم الماركة فقط إذا كانت محددة
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          brand,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class NewArrivalsCard extends StatelessWidget {
  const NewArrivalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BEST CHOICE',
                  style: TextStyle(
                    color: Color(0xFF5A9AE5),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Nike Air Jordan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2832),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '\$849.69',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E2832),
                  ),
                ),
              ],
            ),
          ),
          // صورة الحذاء
          Image.network(
            'https://freepngimg.com/thumb/shoes/28530-3-nike-shoes-transparent.png', // رابط صورة مؤقت
            width: 120,
            height: 90,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
