import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/widgets/cached_product_image.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart';

class ProductMediaViewer extends StatefulWidget {
  final ProductModel product;
  final PageController pageController;

  const ProductMediaViewer({
    super.key,
    required this.product,
    required this.pageController,
  });

  @override
  State<ProductMediaViewer> createState() => _ProductMediaViewerState();
}

class _ProductMediaViewerState extends State<ProductMediaViewer> {
  static const _dragSensitivity = 15.0;
  double _dragPosition = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final url in [
      ...widget.product.rotationImages,
      ...widget.product.images,
    ]) {
      if (url.isNotEmpty) {
        precacheImage(CachedNetworkImageProvider(url), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final has3D = widget.product.rotationImages.isNotEmpty;

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        final is3DMode = has3D && state.selectedColorIndex == 0;
        return Column(
          children: [
            SizedBox(
              height: 250,
              child: is3DMode
                  ? _ThreeDimensionalView(
                      product: widget.product,
                      onDrag: _handleDrag,
                    )
                  : widget.product.images.isEmpty
                  ? Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : _RegularImagePageView(
                      product: widget.product,
                      pageController: widget.pageController,
                      has3D: has3D,
                    ),
            ),
            const SizedBox(height: 16),
            if (is3DMode)
              _CurvedRotationSlider(
                selectedImageIndex: state.selectedImageIndex,
                imageCount: widget.product.rotationImages.length,
              )
            else
              const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  void _handleDrag(DragUpdateDetails details) {
    if (widget.product.rotationImages.isEmpty) return;
    _dragPosition += details.delta.dx;
    final imageCount = widget.product.rotationImages.length;
    final currentIndex = context
        .read<ProductDetailsCubit>()
        .state
        .selectedImageIndex;

    if (_dragPosition > _dragSensitivity) {
      _dragPosition = 0;
      context.read<ProductDetailsCubit>().changeImage(
        (currentIndex - 1 + imageCount) % imageCount,
      );
    } else if (_dragPosition < -_dragSensitivity) {
      _dragPosition = 0;
      context.read<ProductDetailsCubit>().changeImage(
        (currentIndex + 1) % imageCount,
      );
    }
  }
}

class _ThreeDimensionalView extends StatelessWidget {
  final ProductModel product;
  final ValueChanged<DragUpdateDetails> onDrag;

  const _ThreeDimensionalView({required this.product, required this.onDrag});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) => GestureDetector(
        onPanUpdate: onDrag,
        child: Center(
          child: CachedProductImage(
            imageUrl: product.rotationImages[state.selectedImageIndex],
            height: 250,
            fit: BoxFit.contain,
            errorIconSize: 100,
          ),
        ),
      ),
    );
  }
}

class _RegularImagePageView extends StatelessWidget {
  final ProductModel product;
  final PageController pageController;
  final bool has3D;

  const _RegularImagePageView({
    required this.product,
    required this.pageController,
    required this.has3D,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: product.images.length,
      onPageChanged: (index) => context.read<ProductDetailsCubit>().changeColor(
        has3D ? index + 1 : index,
      ),
      itemBuilder: (context, index) => Center(
        child: CachedProductImage(
          imageUrl: product.images[index],
          height: 250,
          fit: BoxFit.contain,
          errorIconSize: 100,
        ),
      ),
    );
  }
}

class _CurvedRotationSlider extends StatelessWidget {
  final int selectedImageIndex;
  final int imageCount;

  const _CurvedRotationSlider({
    required this.selectedImageIndex,
    required this.imageCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        selectedImageIndex / (imageCount - 1 == 0 ? 1 : imageCount - 1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: SizedBox(
        height: 40,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            const height = 40.0;
            final thumbX = progress * width;
            final thumbY = 4 * progress * (1 - progress) * (height / 2);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(width, height),
                  painter: _CurvedLinePainter(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Positioned(
                  left: thumbX - 20,
                  top: thumbY - 12,
                  child: Container(
                    width: 40,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(102),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_left_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 18,
                        ),
                        Icon(
                          Icons.arrow_right_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CurvedLinePainter extends CustomPainter {
  final Color color;

  _CurvedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(128)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, 0);
    canvas.drawPath(path, paint);
    final dotPaint = Paint()..color = color;
    canvas.drawCircle(const Offset(0, 0), 2.5, dotPaint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 2.5, dotPaint);
    canvas.drawCircle(Offset(size.width, 0), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
