import 'package:flutter/material.dart';

class CardCurhat extends StatelessWidget {
  const CardCurhat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      'https://example.com/avatar.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('2 Jam yang lalu', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 6, right: 6, top: 1, bottom: 1),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.5),
                ),
                child: Row(
                  children: [
                    CircleAvatar(radius: 11, backgroundColor: Colors.yellow),
                    SizedBox(width: 8),
                    Text('Senang', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 21),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF0F4FF), // Warna background biru muda
              borderRadius: BorderRadius.circular(8), // Kelengkungan sudut
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Header: Ikon dan Judul
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E7FF), // Background ikon agak gelap
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.smart_toy_outlined, // Ikon robot
                        color: Color(0xFF5B58E7),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Respon AI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B58E7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Teks Deskripsi dengan "lainnya"
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF4A44A3), // Warna teks ungu gelap
                      height: 1.5, // Spasi antar baris
                    ),
                    children: [
                      TextSpan(
                        text:
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the... ",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.favorite, size: 24),
              SizedBox(width: 4),
              Text('24', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 12),
              Icon(Icons.chat_bubble, size: 24),
              SizedBox(width: 4),
              Text('8', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
