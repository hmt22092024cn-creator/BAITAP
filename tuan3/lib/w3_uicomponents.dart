import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const UTHCampusApp(),
      ),
    );

class UTHCampusApp extends StatelessWidget {
  const UTHCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTH Student Hub',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        primaryColor: const Color(0xFF1E3A5F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A5F),
          primary: const Color(0xFF1E3A5F),
          secondary: const Color(0xFF00A8CC),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E3A5F),
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF1E3A5F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ==========================================
// 1. MÀN HÌNH CHÀO (WELCOME / READY SCREEN)
// ==========================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Column(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E3A5F).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 60,
                      color: Color(0xFF00A8CC),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'UTH Student Hub',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A5F),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Trường Đại Học Giao Thông Vận Tải TP.HCM',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00A8CC),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cổng tiện ích tích hợp đầy đủ các thành phần UI cơ bản và điều hướng màn hình phục vụ học tập & quản lý sinh viên.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ComponentListScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Khám phá ngay",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. MÀN HÌNH DANH SÁCH COMPONENT (LIST SCREEN)
// ==========================================
class ComponentListScreen extends StatelessWidget {
  const ComponentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTH Utility Components'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategoryGroup(
            context: context,
            categoryTitle: 'Display (Hiển thị)',
            items: [
              {
                'title': 'Text Detail',
                'desc': 'Quy chế & Thông báo Đào tạo UTH',
                'icon': Icons.article_outlined,
                'target': const TextDetailScreen(),
              },
              {
                'title': 'Image Showcase',
                'desc': 'Hình ảnh cơ sở vật chất & Hoạt động sinh viên',
                'icon': Icons.image_outlined,
                'target': const ImageDetailScreen(),
              },
            ],
          ),
          _buildCategoryGroup(
            context: context,
            categoryTitle: 'Input (Nhập liệu)',
            items: [
              {
                'title': 'TextField Generator',
                'desc': 'Tạo thẻ Sinh viên trực tuyến theo thời gian thực',
                'icon': Icons.badge_outlined,
                'target': const TextFieldDetailScreen(),
              },
              {
                'title': 'Toggle & Slider Controls',
                'desc': 'Cài đặt cấu hình ứng dụng & Nhắc nhở',
                'icon': Icons.tune_outlined,
                'target': const InputControlsDetailScreen(),
              },
            ],
          ),
          _buildCategoryGroup(
            context: context,
            categoryTitle: 'Layout (Bố cục)',
            items: [
              {
                'title': 'Row & Column Schedule',
                'desc': 'Bảng thời khóa biểu & Lịch học tuần',
                'icon': Icons.grid_view_rounded,
                'target': const RowLayoutDetailScreen(),
              },
            ],
          ),
          _buildCategoryGroup(
            context: context,
            categoryTitle: 'Selection & Content (Lựa chọn & Nội dung)',
            items: [
              {
                'title': 'Selection Options',
                'desc': 'Đăng ký học phần (Checkbox, Radio, Button)',
                'icon': Icons.check_box_outlined,
                'target': const SelectionDetailScreen(),
              },
              {
                'title': 'Card & List Content',
                'desc': 'Bản tin Sự kiện & Thông báo mới nhất',
                'icon': Icons.view_day_outlined,
                'target': const ContentDetailScreen(),
              },
            ],
          ),

          // Thẻ Tự Tìm Hiểu theo slide 63 & 64
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OverviewComponentsScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFC62828),
                    child: Icon(Icons.explore, color: Colors.white),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tự tìm hiểu & Nâng cao',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFB71C1C)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tổng hợp toàn bộ hệ thống UI Core Widgets',
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFFC62828)),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Color(0xFFB71C1C)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGroup({
    required BuildContext context,
    required String categoryTitle,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
          child: Text(
            categoryTitle,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF1E3A5F)),
          ),
        ),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => item['target']));
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(item['icon'] as IconData,
                          color: const Color(0xFF00A8CC)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E3A5F)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['desc'],
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            )),
        const SizedBox(height: 4),
      ],
    );
  }
}

// ==========================================
// 3. CHI TIẾT: TEXT DETAIL SCREEN (QUY CHẾ UTH)
// ==========================================
class TextDetailScreen extends StatelessWidget {
  const TextDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Text Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'THÔNG BÁO QUY CHẾ ĐÀO TẠO',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F)),
              ),
              const Divider(height: 24),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black87, height: 1.7),
                  children: [
                    const TextSpan(text: 'Trường '),
                    const TextSpan(
                      text: 'Đại học Giao thông vận tải TP.HCM ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F)),
                    ),
                    const TextSpan(
                        text:
                            'thông báo quy định đăng ký tín chỉ năm học 2026. Tất cả sinh viên lưu ý '),
                    const TextSpan(
                      text: 'không được nợ học phí ',
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red),
                    ),
                    const TextSpan(text: ' trước ngày mở cổng hệ thống.\n\n'),
                    const TextSpan(
                      text: 'Cơ sở chính: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'Số 2, Đường Võ Oanh, P.25, Q.Bình Thạnh.\n',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFF00A8CC)),
                    ),
                    const TextSpan(
                      text: 'Hạn chót hoàn thành thủ tục: ',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const TextSpan(
                      text: '17:00 - 30/10/2026.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. CHI TIẾT: IMAGE DETAIL SCREEN (CƠ SỞ UTH)
// ==========================================
class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Images Showcase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildImageCard(
            title: 'Cơ sở chính Võ Oanh - UTH',
            imageUrl: 'https://picsum.photos/600/350?random=1',
            caption:
                'Khu giảng đường trung tâm và khu phức hợp học tập sinh viên.',
          ),
          const SizedBox(height: 16),
          _buildImageCard(
            title: 'Phòng Thí Nghệ & Thực Hành CNTT',
            imageUrl: 'https://picsum.photos/600/350?random=2',
            caption:
                'Trang thiết bị hiện đại phục vụ nghiên cứu và phát triển phần mềm.',
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(
      {required String title,
      required String imageUrl,
      required String caption}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E3A5F))),
                const SizedBox(height: 4),
                Text(caption,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. CHI TIẾT: TEXTFIELD (TẠO THẺ SV TRỰC TUYẾN)
// ==========================================
class TextFieldDetailScreen extends StatefulWidget {
  const TextFieldDetailScreen({super.key});

  @override
  State<TextFieldDetailScreen> createState() => _TextFieldDetailScreenState();
}

class _TextFieldDetailScreenState extends State<TextFieldDetailScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Nguyễn Văn An');
  final TextEditingController _idController =
      TextEditingController(text: '2251120001');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tạo Thẻ Sinh Viên'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // KHU VỰC NHẬP DỮ LIỆU
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Họ và tên sinh viên',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Mã số sinh viên (MSSV)',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // PREVIEW THẺ SINH VIÊN TỰ ĐỘNG CẬP NHẬT REAL-TIME
            const Text('XEM TRƯỚC THẺ SINH VIÊN (REAL-TIME)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A5F), Color(0xFF00A8CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('UTH STUDENT CARD',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                      Icon(Icons.contactless,
                          color: Colors.white.withOpacity(0.8)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white24,
                        child:
                            Icon(Icons.person, size: 36, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text.isEmpty
                                ? 'Chưa nhập tên'
                                : _nameController.text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MSSV: ${_idController.text.isEmpty ? '-----------' : _idController.text}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                          const Text(
                            'Khoa Công Nghệ Thông Tin',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 6. CHI TIẾT: ROW & COLUMN LAYOUT (THỜI KHÓA BIỂU)
// ==========================================
class RowLayoutDetailScreen extends StatelessWidget {
  const RowLayoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> schedule = [
      {
        'time': '07:30 - 09:30',
        'subject': 'Lập trình Flutter',
        'room': 'Phòng A2.04'
      },
      {
        'time': '09:40 - 11:40',
        'subject': 'Cơ sở dữ liệu SQL',
        'room': 'Phòng B1.02'
      },
      {
        'time': '13:00 - 15:00',
        'subject': 'Mạng máy tính',
        'room': 'Phòng C3.01'
      },
      {
        'time': '15:10 - 17:10',
        'subject': 'Kỹ thuật phần mềm',
        'room': 'Phòng A1.01'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Thời Khóa Biểu Tuần'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final item = schedule[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 18, color: Color(0xFF0284C7)),
                      const SizedBox(height: 4),
                      Text(item['time']!,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0284C7))),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['subject']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1E3A5F))),
                      const SizedBox(height: 4),
                      Text(item['room']!,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const Icon(Icons.bookmark_border, color: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 7. CHI TIẾT: TOGGLE & SLIDER (CÀI ĐẶT ỨNG DỤNG)
// ==========================================
class InputControlsDetailScreen extends StatefulWidget {
  const InputControlsDetailScreen({super.key});

  @override
  State<InputControlsDetailScreen> createState() =>
      _InputControlsDetailScreenState();
}

class _InputControlsDetailScreenState extends State<InputControlsDetailScreen> {
  bool _notifyExam = true;
  bool _notifySchedule = false;
  double _fontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cài Đặt Ứng Dụng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Thông báo Lịch thi',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Nhận thông báo khi có lịch thi mới'),
                    value: _notifyExam,
                    onChanged: (v) => setState(() => _notifyExam = v),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Nhắc nhở Thời khóa biểu',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Nhắc nhở trước 15 phút khi bắt đầu tiết học'),
                    value: _notifySchedule,
                    onChanged: (v) => setState(() => _notifySchedule = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kích thước chữ hiển thị: ${_fontSize.toInt()} pt',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _fontSize,
                    min: 12,
                    max: 22,
                    divisions: 10,
                    label: '${_fontSize.toInt()} pt',
                    onChanged: (v) => setState(() => _fontSize = v),
                  ),
                  Text(
                    'Mẫu chữ xem trước nội dung thông báo UTH.',
                    style: TextStyle(
                        fontSize: _fontSize, color: const Color(0xFF1E3A5F)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 8. CHI TIẾT: SELECTION (ĐĂNG KÝ HỌC PHẦN)
// ==========================================
class SelectionDetailScreen extends StatefulWidget {
  const SelectionDetailScreen({super.key});

  @override
  State<SelectionDetailScreen> createState() => _SelectionDetailScreenState();
}

class _SelectionDetailScreenState extends State<SelectionDetailScreen> {
  bool _m1 = true;
  bool _m2 = false;
  int _shift = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Đăng Ký Học Phần'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CHỌN MÔN HỌC (CHECKBOX)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Lập trình Di động Flutter (3 Tín chỉ)'),
                    value: _m1,
                    onChanged: (v) => setState(() => _m1 = v!),
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    title: const Text('Thực tập Doanh nghiệp (2 Tín chỉ)'),
                    value: _m2,
                    onChanged: (v) => setState(() => _m2 = v!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('CHỌN CA HỌC (RADIO)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  RadioListTile<int>(
                    title: const Text('Ca Sáng (07:30 - 11:30)'),
                    value: 1,
                    groupValue: _shift,
                    onChanged: (v) => setState(() => _shift = v!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<int>(
                    title: const Text('Ca Chiều (13:00 - 17:00)'),
                    value: 2,
                    groupValue: _shift,
                    onChanged: (v) => setState(() => _shift = v!),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Đã ghi nhận Đăng ký Học phần thành công!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F)),
                child: const Text('Xác nhận đăng ký',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 9. CHI TIẾT: CONTENT (TIN TỨC & SỰ KIỆN UTH)
// ==========================================
class ContentDetailScreen extends StatelessWidget {
  const ContentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tin Tức & Sự Kiện'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Text('SỰ KIỆN',
                            style: TextStyle(
                                color: Color(0xFF0284C7),
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text('19/10/2026',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Lễ Khai Mạc Giải Bóng Đá Sinh Viên UTH 2026',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A5F)),
                  ),
                  const Divider(height: 20),
                  const Text(
                    'Chào mừng kỷ niệm thành lập trường, Hội sinh viên tổ chức giải bóng đá thường niên dành cho tất cả các khoa...',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
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

// ==========================================
// 10. CHI TIẾT: TỰ TÌM HIỂU OVERVIEW
// ==========================================
class OverviewComponentsScreen extends StatelessWidget {
  const OverviewComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('UI Components System'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoSection(
              'Display', ['Text', 'RichText', 'Image.network', 'Icon']),
          _buildInfoSection('Input',
              ['TextField', 'TextEditingController', 'Switch', 'Slider']),
          _buildInfoSection('Selection',
              ['ElevatedButton', 'CheckboxListTile', 'RadioListTile']),
          _buildInfoSection('Navigation',
              ['MaterialPageRoute', 'Navigator.push', 'Navigator.pop']),
          _buildInfoSection('Layout & Content',
              ['Scaffold', 'Column', 'Row', 'Card', 'Divider', 'ListView']),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1E3A5F))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: items
                .map((item) => Chip(
                      label: Text(item,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF1E3A5F))),
                      backgroundColor: const Color(0xFFF1F5F9),
                      padding: EdgeInsets.zero,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
