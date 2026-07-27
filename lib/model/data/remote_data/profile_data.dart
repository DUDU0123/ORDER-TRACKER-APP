import 'package:order_tracker_app/model/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileData {
  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  ProfileData({SupabaseClient? client}) : _client = client;

  Future<ProfileModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .eq('password', password)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}