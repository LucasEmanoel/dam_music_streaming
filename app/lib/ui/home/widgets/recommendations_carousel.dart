import 'dart:async';
import 'package:flutter/material.dart';

class RecItem {
  final String titleLine1;
  final String titleLine2;
  final String caption;
  final String meta;
  final List<Color> gradient;

  const RecItem({
    required this.titleLine1,
    required this.titleLine2,
    required this.caption,
    required this.meta,
    required this.gradient,
  });
}

class RecommendationsCarousel extends StatefulWidget {
  final List<RecItem> items;
  final Duration interval;
  final Duration animDuration;
  const RecommendationsCarousel({
    super.key,
    required this.items,
    this.interval = const Duration(seconds: 3),
    this.animDuration = const Duration(milliseconds: 450),
  });

  @override
  State<RecommendationsCarousel> createState() => _RecommendationsCarouselState();
}

class _RecommendationsCarouselState extends State<RecommendationsCarousel> {
  late final PageController _page = PageController(viewportFraction: 0.86);
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted || widget.items.isEmpty) return;
      final next = (_page.page?.round() ?? 0) + 1;
      _page.animateToPage(
        next % (widget.items.length * 1000),
        duration: widget.animDuration,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _page,
            onPageChanged: (i) => setState(() => _index = i % items.length),
            itemBuilder: (_, i) {
              final item = items[i % items.length];
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _RecCard(item: item),
              );
            },
            itemCount: items.length * 1000,
          ),
        ),
        const SizedBox(height: 10),
        // indicadores
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (i) {
            final active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? Colors.black87 : Colors.black26,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(items[_index].caption,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(items[_index].meta,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}

class _RecCard extends StatelessWidget {
  final RecItem item;
  const _RecCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(item.titleLine1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    )),
                Text(item.titleLine2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
