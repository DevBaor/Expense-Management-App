import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class IntroductionSlide extends StatefulWidget {
  const IntroductionSlide({super.key});

  @override
  State<IntroductionSlide> createState() => _IntroductionSlideState();
}

class _IntroductionSlideState extends State<IntroductionSlide> {
  List<String>? imgList; // Danh sách path ảnh JPG
  final List<String> description = [
    "Tui là một con ong 🐝 chăm chỉ sẽ giúp bạn quản lý chi tiêu."
    "Theo dõi thu nhập và chi tiêu hằng ngày của bạn.",
    "Giúp bạn đạt được các mục tiêu tài chính dễ dàng hơn.",
  ];

  int _currentIndex = 0;

  // Hàm load ảnh JPG từ assets
  Future<void> _initImages() async {
    setState(() {
      imgList = [
        'assets/images/ongtron.jpg', // Đường dẫn tới ảnh JPEG
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return imgList != null
        ? Column(
          children: [
            CarouselSlider(
              items:
                  imgList!.asMap().entries.map<Widget>((entry) {
                    final index = entry.key;
                    final element = entry.value;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          element,
                          width: 200.0,
                          height: 200.0,
                        ), // Hiển thị ảnh JPG
                        index == 0
                            ? const Text(
                              'MONEY GROUP 4',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                                fontSize: 24.0,
                              ),
                              textAlign: TextAlign.center,
                            )
                            : const SizedBox(height: 30.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 40.0,
                          ),
                          child: Text(
                            description[index],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
              options: CarouselOptions(
                scrollPhysics: const BouncingScrollPhysics(),
                autoPlay: false,
                aspectRatio: 0.8,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  imgList!.asMap().entries.map<Widget>((entry) {
                    final index = entry.key;
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 2.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentIndex == index
                                ? const Color.fromRGBO(255, 255, 255, 0.9)
                                : const Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                    );
                  }).toList(),
            ),
          ],
        )
        : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty,
                color: Colors.white.withOpacity(0.12),
                size: 100,
              ),
              const SizedBox(height: 10),
              Text(
                'Loading',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.24),
                ),
              ),
            ],
          ),
        );
  }
}
