<?php

include "../connect.php";

$username = filterRequest("username");
$email    = filterRequest("email");
$password = sha1($_POST["password"]); // Consistent with your login
$phone    = filterRequest("phone");

// 1. Check if user already exists
$stmt = $con->prepare("SELECT * FROM users WHERE user_email = ? OR user_phone = ?");
$stmt->execute(array($email, $phone));
$count = $stmt->rowCount();

if ($count > 0) {
    echo json_encode([
        "status" => "failure",
        "message" => "Email or Phone already exists"
    ]);
} else {
    // 2. Insert new user
    // Note: I added user_approve = 1 so they can login immediately
    $stmt = $con->prepare("
        INSERT INTO `users` (`user_name`, `user_email`, `user_password`, `user_phone`, `user_approve`) 
        VALUES (?, ?, ?, ?, 1)
    ");
    
    $stmt->execute(array($username, $email, $password, $phone));
    $count = $stmt->rowCount();

    if ($count > 0) {
        $userId = $con->lastInsertId();
        echo json_encode([
            "status" => "success",
            "data" => [
                "user_id"    => $userId,
                "user_name"  => $username,
                "user_email" => $email,
                "user_phone" => $phone
            ]
        ]);
    } else {
         echo json_encode(["status" => "failure", "message" => "Database error"]);
    }
}

////////
<?php

include "../connect.php";

// Filter inputs using your existing function
$email    = filterRequest("username"); // Flutter sends email in the 'username' key
$password = $_POST["password"];       // Don't hash it yet, we use password_verify

// Prepare the statement to prevent SQL Injection
$stmt = $con->prepare("SELECT * FROM users WHERE user_email = ? AND user_approve = 1");
$stmt->execute(array($email));
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    // Check password (using sha1 because your current db uses it, but see optimization below)
    if (sha1($password) == $user['user_password']) {
        
        // Remove password from response for security
        unset($user['user_password']);
        
        echo json_encode([
            "status" => "success",
            "data"   => $user
        ]);
    } else {
        echo json_encode([
            "status"  => "failure",
            "message" => "Password incorrect"
        ]);
    }
} else {
    echo json_encode([
        "status"  => "failure",
        "message" => "Account not found or not approved"
    ]);
}
///////
<?php
include "../connect.php";
include "../functions.php";

$username = filterRequest("username");
$email    = filterRequest("email");
$password = filterRequest("password");
$phone    = filterRequest("phone");

// 1. Check if email or phone already exists
$stmt = $con->prepare("SELECT * FROM users WHERE user_email = ? OR user_phone = ?");
$stmt->execute([$email, $phone]);
$count = $stmt->rowCount();

if ($count > 0) {
    sendResponse("failure", "Email or Phone already registered");
} else {
    // 2. Hash the password for security
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // 3. Insert user
    $stmt = $con->prepare("
        INSERT INTO `users` (`user_name`, `user_email`, `user_password`, `user_phone`) 
        VALUES (?, ?, ?, ?)
    ");
    
    $insert = $stmt->execute([$username, $email, $hashed_password, $phone]);

    if ($insert) {
        // Return the newly created user (excluding password)
        $userId = $con->lastInsertId();
        sendResponse("success", "Account created", [
            "user_id" => $userId,
            "user_name" => $username,
            "user_email" => $email,
            "user_phone" => $phone
        ]);
    } else {
        sendResponse("failure", "Internal Server Error");
    }
}
/////
import 'dart:convert';
import 'package:get/get.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/model/user_model.dart';
import 'package:maneger/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/linkapi.dart';

class AuthController extends GetxController {
  final Crud _crud = Crud();
  
  // Observables
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<StatusRequest> statusRequest = StatusRequest.success.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  /// Checks if a user session exists and restores it
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userData = prefs.getString('current_user');

    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      if (userData != null) {
        currentUser.value = User.fromJson(jsonDecode(userData));
      }
    }
  }

  /// Handles user login
  Future<void> login(String email, String password) async {
    statusRequest.value = StatusRequest.loading;
    errorMessage.value = '';

    final response = await _crud.postData(AppLink.login, {
      'username': email,
      'password': password,
    });

    response.fold(
      (failure) {
        statusRequest.value = failure;
        errorMessage.value = _mapRequestToMessage(failure);
      },
      (data) async {
        if (data['status'] == 'success') {
          // 💡 Suggestion: Use actual token from data['token'] or similar
          final token = data['token'] ?? 'authenticated'; 
          
          await _persistAuth(token, data['data']); // Pass user object from API if available
          
          statusRequest.value = StatusRequest.success;
          Get.offAllNamed(AppRoutes.home);
        } else {
          statusRequest.value = StatusRequest.failure;
          errorMessage.value = data['message'] ?? 'Invalid credentials';
          Get.snackbar('Login Status', errorMessage.value);
        }
      },
    );
  }

  /// Handles user registration
  Future<void> signup(String username, String email, String password, String phone) async {
    statusRequest.value = StatusRequest.loading;
    errorMessage.value = '';

    final response = await _crud.postData(AppLink.signup, {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone, // Pass dynamically
    });

    response.fold(
      (failure) {
        statusRequest.value = failure;
        errorMessage.value = _mapRequestToMessage(failure);
      },
      (data) async {
        if (data['status'] == 'success') {
          final token = data['token'] ?? 'registered';
          await _persistAuth(token, data['data']);
          
          statusRequest.value = StatusRequest.success;
          Get.offAllNamed(AppRoutes.home);
        } else {
          statusRequest.value = StatusRequest.failure;
          errorMessage.value = data['message'] ?? 'Signup failed';
        }
      },
    );
  }

  /// Helper to save auth state and user data
  Future<void> _persistAuth(String token, Map<String, dynamic>? userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    
    if (userData != null) {
      final user = User.fromJson(userData);
      await prefs.setString('current_user', jsonEncode(user.toJson()));
      currentUser.value = user;
    }
    
    isLoggedIn.value = true;
  }

  /// Logs the user out and clears cache
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('current_user');
    
    isLoggedIn.value = false;
    currentUser.value = null;
    Get.offAllNamed('/login');
  }

  /// Helper getter for userId
  String? get userId => currentUser.value?.userId;

  /// Helper method to format error messages
  String _mapRequestToMessage(StatusRequest status) {
    switch (status) {
      case StatusRequest.offline:
        return 'No internet connection';
      case StatusRequest.serverfailure:
        return 'Server error, please try again later';
      case StatusRequest.timeout:
        return 'Connection timed out';
      default:
        return 'Something went wrong';
    }
  }
}

<?php
/**
 * Clean data for XSS protection and general cleanup
 */
function sanitizeInput($input) {
    if (is_array($input)) {
        return array_map('sanitizeInput', $input);
    }
    // strip_tags() removes HTML tags
    // htmlspecialchars() escapes special characters for XSS protection
    // ENT_QUOTES ensures both ' and " are handled
    return trim(htmlspecialchars(strip_tags((string)$input), ENT_QUOTES, 'UTF-8'));
}
/**
 * Helper to get and sanitize POST data quickly
 */
function filterRequest($requestName) {
    if (isset($_POST[$requestName])) {
        return sanitizeInput($_POST[$requestName]);
    }
    return null; // Return null if the POST field is missing
}