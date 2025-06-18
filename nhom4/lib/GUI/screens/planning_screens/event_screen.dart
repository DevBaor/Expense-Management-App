import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/EventModel.dart';
import 'add_even.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() {
        _errorMessage = 'Chưa đăng nhập';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await apiService.getEventsByUser(userId);

      // Chuyển đổi list map -> list event
      final List<Event> events =
          (data as List<dynamic>)
              .map((item) => Event.fromJson(item as Map<String, dynamic>))
              .toList();

      setState(() {
        _events = events;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải sự kiện: $e';
        print('Lỗi khi tải sự kiện: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Không có ngày kết thúc';
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2526),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3338),
        title: const Text('Danh sách sự kiện'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEventScreen()),
              ).then((value) => _fetchEvents());
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : _errorMessage != null
              ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : RefreshIndicator(
                onRefresh: _fetchEvents,
                color: Colors.white,
                backgroundColor: Colors.black,
                child:
                    _events.isEmpty
                        ? const Center(
                          child: Text(
                            "Chưa có sự kiện nào",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: _events.length,
                          itemBuilder: (context, index) {
                            final event = _events[index];
                            return Card(
                              color: const Color(0xFF2D3338),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Image.asset(
                                  event.iconPath ?? 'assets/icons/default.svg',
                                  width: 30,
                                  height: 30,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.event,
                                            color: Colors.white,
                                          ),
                                ),
                                title: Text(
                                  event.name ?? "Không tên",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "Kết thúc: ${formatDate(event.endDate)}\nChi tiêu: ${event.spent?.toStringAsFixed(0) ?? '0'}đ",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Icon(
                                  event.isFinished == 1
                                      ? Icons.check_circle
                                      : Icons.access_time,
                                  color:
                                      event.isFinished == 1
                                          ? Colors.green
                                          : Colors.orange,
                                ),
                              ),
                            );
                          },
                        ),
              ),
    );
  }
}
