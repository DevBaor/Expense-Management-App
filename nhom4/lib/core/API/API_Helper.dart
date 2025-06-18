import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  static const String baseUrl = "http://192.168.67.251:8000";
  static Future<void> openHotroPage() async {
    final Uri url = Uri.parse("$baseUrl/hotro");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Không thể mở trang $url';
    }
  }

  // ----------------------- WALLETS -----------------------
  Future<List<dynamic>> getWallets() async {
    final response = await http.get(Uri.parse("$baseUrl/wallets"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi khi lấy wallets: ${response.statusCode}");
    }
  }

  Future<List<dynamic>> getWalletsByUser(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/wallets/user/$userId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null) {
        // Trả về list rỗng thay vì null để tránh lỗi
        return [];
      }
      if (data is List && data.isEmpty) {
        return [];
      }
      return data as List<dynamic>;
    } else {
      throw Exception(
        "Lỗi khi lấy wallets của user $userId: ${response.statusCode}",
      );
    }
  }

  Future<dynamic> createWallet(Map<String, dynamic> walletData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/wallets"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(walletData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi khi tạo wallet: ${response.statusCode}");
    }
  }

  Future<dynamic> getWalletById(String walletId) async {
    final response = await http.get(Uri.parse("$baseUrl/wallets/$walletId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi khi lấy wallet theo ID: ${response.statusCode}");
    }
  }

  Future<dynamic> updateWallet(
    String walletId,
    Map<String, dynamic> walletData,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/wallets/$walletId"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(walletData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi khi cập nhật wallet: ${response.statusCode}");
    }
  }

  Future<void> deleteWallet(String walletId) async {
    final response = await http.delete(Uri.parse("$baseUrl/wallets/$walletId"));
    if (response.statusCode != 200) {
      throw Exception("Lỗi khi xóa wallet: ${response.statusCode}");
    }
  }

  // ----------------------- USERS -----------------------
  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi khi lấy users: ${response.statusCode}");
    }
  }

  Future<dynamic> getUser(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$id"));
    print("Lấy user với ID: $id");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Lỗi khi lấy user: ${response.statusCode}");
    }
  }

  Future<dynamic> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi khi tạo user: ${response.statusCode}");
    }
  }

  Future<dynamic> updateUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users/$userId"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi khi cập nhật user: ${response.statusCode}");
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse("$baseUrl/users/$userId"));
    if (response.statusCode != 200) {
      throw Exception("Lỗi khi xóa user: ${response.statusCode}");
    }
  }

  // ------------- CATEGORIES -------------
  Future<List<dynamic>> getCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy categories: ${response.statusCode}");
  }

  Future<dynamic> getCategory(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/categories/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy category: ${response.statusCode}");
  }

  Future<List<dynamic>?> getCategoriesByUser(String userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/categories/user/$userId"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null) {
        return null;
      }
      if (data is List && data.isEmpty) {
        return null;
      }
      return data as List<dynamic>;
    }

    throw Exception("Lỗi lấy categories theo user: ${response.statusCode}");
  }

  Future<dynamic> createCategory(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/categories"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi tạo category: ${response.statusCode}");
  }

  Future<dynamic> updateCategory(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/categories/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi cập nhật category: ${response.statusCode}");
  }

  Future<void> deleteCategory(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/categories/$id"));
    if (response.statusCode != 200) {
      throw Exception("Lỗi xóa category: ${response.statusCode}");
    }
  }

  // ------------- TRANSACTIONS -------------
  Future<List<dynamic>> getTransactions() async {
    final response = await http.get(Uri.parse("$baseUrl/transactions"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy transactions: ${response.statusCode}");
  }

  Future<dynamic> getTransaction(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/transactions/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy transaction: ${response.statusCode}");
  }

  Future<List<dynamic>?> getTransactionsByUser(String userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/transactions/user/$userId"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null) {
        return null;
      }
      if (data is List && data.isEmpty) {
        return null;
      }
      return data as List<dynamic>;
    }

    throw Exception("Lỗi lấy transactions theo user: ${response.statusCode}");
  }

  Future<dynamic> createTransaction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/transactions"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi tạo transaction: ${response.statusCode}");
  }

  Future<dynamic> updateTransaction(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/transactions/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final body = jsonDecode(response.body);
        throw Exception("Lỗi cập nhật: ${body['message'] ?? response.body}");
      }
    } catch (e) {
      print("Lỗi khi cập nhật transaction: $e");
      rethrow; // giữ nguyên lỗi để UI xử lý
    }
  }

  Future<void> deleteTransaction(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/transactions/$id"));
    if (response.statusCode != 200) {
      throw Exception("Lỗi xóa transaction: ${response.statusCode}");
    }
  }

  // ------------- BUDGETS -------------
  Future<List<dynamic>> getBudgets() async {
    final response = await http.get(Uri.parse("$baseUrl/budgets"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy budgets: ${response.statusCode}");
  }

  Future<dynamic> getBudget(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/budgets/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy budget: ${response.statusCode}");
  }

  Future<dynamic> createBudget(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/budgets"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi tạo budget: ${response.statusCode}");
  }

  Future<List<dynamic>> getBudgetsByUser(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/budgets/user/$userId"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy budgets theo userId: ${response.statusCode}");
  }

  Future<dynamic> updateBudget(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/budgets/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi cập nhật budget: ${response.statusCode}");
  }

  Future<void> deleteBudget(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/budgets/$id"));
    if (response.statusCode != 200) {
      throw Exception("Lỗi xóa budget: ${response.statusCode}");
    }
  }

  // ------------- BILLS -------------
  Future<List<dynamic>> getBills() async {
    final response = await http.get(Uri.parse("$baseUrl/bills"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy bills: ${response.statusCode}");
  }

  Future<dynamic> getBill(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/bills/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy bill: ${response.statusCode}");
  }

  Future<dynamic> createBill(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/bills"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi tạo bill: ${response.statusCode}");
  }

  Future<dynamic> updateBill(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/bills/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi cập nhật bill: ${response.statusCode}");
  }

  Future<void> deleteBill(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/bills/$id"));
    if (response.statusCode != 200) {
      throw Exception("Lỗi xóa bill: ${response.statusCode}");
    }
  }

  // ------------- REPEATOPTIONS -------------
  Future<List<dynamic>> getRepeatOptions() async {
    final response = await http.get(Uri.parse("$baseUrl/repeatoptions"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy repeatoptions: ${response.statusCode}");
  }

  Future<dynamic> getRepeatOption(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/repeatoptions/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy repeatoption: ${response.statusCode}");
  }

  Future<dynamic> createRepeatOption(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/repeatoptions"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi tạo repeatoption: ${response.statusCode}");
  }

  Future<dynamic> updateRepeatOption(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/repeatoptions/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi cập nhật repeatoption: ${response.statusCode}");
  }

  Future<void> deleteRepeatOption(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/repeatoptions/$id"));
    if (response.statusCode != 200) {
      throw Exception("Lỗi xóa repeatoption: ${response.statusCode}");
    }
  }

  // ------------- RECURRINGTRANSACTIONS -------------
  Future<List<dynamic>> getRecurringTransactions() async {
    final response = await http.get(
      Uri.parse("$baseUrl/recurringtransactions"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy recurringtransactions: ${response.statusCode}");
  }

  Future<dynamic> getRecurringTransaction(String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/recurringtransactions/$id"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy recurringtransaction: ${response.statusCode}");
  }

  Future<dynamic> createRecurringTransaction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/recurringtransactions"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi tạo recurringtransaction: ${response.statusCode}");
  }

  Future<dynamic> updateRecurringTransaction(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/recurringtransactions/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(
      "Lỗi cập nhật recurringtransaction: ${response.statusCode}",
    );
  }

  Future<void> deleteRecurringTransaction(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/recurringtransactions/$id"),
    );
    if (response.statusCode != 200) {
      throw Exception("Lỗi xóa recurringtransaction: ${response.statusCode}");
    }
  }

  // ------------- EVENTS -------------
  Future<List<dynamic>> getEvents() async {
    final response = await http.get(Uri.parse("$baseUrl/events"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy events: ${response.statusCode}");
  }

  Future<dynamic> getEvent(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/events/$id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi lấy event: ${response.statusCode}");
  }

  Future<List> getEventsByUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/events/user/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về List<dynamic>
    } else {
      throw Exception('Lỗi khi lấy danh sách sự kiện: ${response.statusCode}');
    }
  }

  Future<dynamic> createEvent(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/events"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi tạo event: ${response.statusCode}");
  }

  Future<dynamic> updateEvent(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/events/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Lỗi cập nhật event: ${response.statusCode}");
  }

  Future<void> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/events/$id"));
    if (response.statusCode != 200) {
      throw Exception("Lỗi xóa event: ${response.statusCode}");
    }
  }
}
