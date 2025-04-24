import 'package:flutter/material.dart';
import 'package:pregnancy_health_tracker/constants/colors.dart';
import 'package:pregnancy_health_tracker/constants/styles.dart';
import 'package:pregnancy_health_tracker/services/auth_service.dart';
import 'package:pregnancy_health_tracker/utils/fade_animation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final AuthService _authService = AuthService();
  
  // Mock user data - in a real app, this would come from a user service
  final String _userName = "Anish";
  final String _userEmail = "anishchwdhree@gmail.com";
  final String _memberSince = "June 2023";
  final String _profileImageUrl = ""; // Empty for now, will use initials instead
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header with gradient background
              _buildProfileHeader(),
              
              // Profile sections
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account settings section
                    FadeAnimation(
                      delay: 0.3,
                      child: _buildSectionTitle("Account Settings"),
                    ),
                    const SizedBox(height: 12),
                    FadeAnimation(
                      delay: 0.4,
                      child: _buildSettingsSection(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Health data section
                    FadeAnimation(
                      delay: 0.5,
                      child: _buildSectionTitle("Health Data"),
                    ),
                    const SizedBox(height: 12),
                    FadeAnimation(
                      delay: 0.6,
                      child: _buildHealthDataSection(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // App settings section
                    FadeAnimation(
                      delay: 0.7,
                      child: _buildSectionTitle("App Settings"),
                    ),
                    const SizedBox(height: 12),
                    FadeAnimation(
                      delay: 0.8,
                      child: _buildAppSettingsSection(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Support section
                    FadeAnimation(
                      delay: 0.9,
                      child: _buildSectionTitle("Support"),
                    ),
                    const SizedBox(height: 12),
                    FadeAnimation(
                      delay: 1.0,
                      child: _buildSupportSection(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Sign out button
                    FadeAnimation(
                      delay: 1.1,
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: _signOut,
                          icon: const Icon(Icons.logout),
                          label: const Text("Sign Out"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.error,
                            elevation: 0,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // App version
                    FadeAnimation(
                      delay: 1.2,
                      child: Center(
                        child: Text(
                          "Ivy Flow v1.0.0",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileHeader() {
    return FadeAnimation(
      delay: 0.2,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withAlpha(40),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Profile image or initials
                  _profileImageUrl.isEmpty
                      ? CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white.withAlpha(100),
                          child: Text(
                            _userName.isNotEmpty ? _userName[0] : "A",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(_profileImageUrl),
                        ),
                  const SizedBox(width: 20),
                  
                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Member since $_memberSince",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Edit profile button
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // Navigate to edit profile screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Edit profile feature coming soon!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Cycles Tracked", "12"),
                  _buildStatItem("Avg. Cycle Length", "28 days"),
                  _buildStatItem("Avg. Period Length", "5 days"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withAlpha(200),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
  
  Widget _buildSettingsSection() {
    return Container(
      decoration: AppStyles.cardDecoration,
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.person,
            title: "Personal Information",
            subtitle: "Update your personal details",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Personal information feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.lock,
            title: "Change Password",
            subtitle: "Update your password",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Change password feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.notifications,
            title: "Notification Settings",
            subtitle: "Manage your notifications",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Notification settings feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildHealthDataSection() {
    return Container(
      decoration: AppStyles.cardDecoration,
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.water_drop,
            title: "Cycle History",
            subtitle: "View your past cycles",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cycle history feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.healing,
            title: "Symptoms Log",
            subtitle: "View your symptoms history",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Symptoms log feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.file_download,
            title: "Export Health Data",
            subtitle: "Download your health data",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Export health data feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppSettingsSection() {
    return Container(
      decoration: AppStyles.cardDecoration,
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.language,
            title: "Language",
            subtitle: "Change app language",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Language settings feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.color_lens,
            title: "Theme",
            subtitle: "Change app appearance",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Theme settings feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.privacy_tip,
            title: "Privacy Settings",
            subtitle: "Manage your privacy preferences",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Privacy settings feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSupportSection() {
    return Container(
      decoration: AppStyles.cardDecoration,
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.help,
            title: "Help Center",
            subtitle: "Get help with using the app",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Help center feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.feedback,
            title: "Send Feedback",
            subtitle: "Help us improve the app",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Send feedback feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.policy,
            title: "Terms & Privacy Policy",
            subtitle: "Read our terms and policies",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Terms and privacy policy feature coming soon!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
  
  void _signOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        // Navigate to login screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signed out successfully"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error signing out: $e"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
