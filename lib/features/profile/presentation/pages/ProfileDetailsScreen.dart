import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/core/widgets/custom_text_field.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isEditing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    nameController = TextEditingController(text: user?.displayName ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    passwordController = TextEditingController(text: '********');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfileData() async {
    setState(() => isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 1. تحديث الاسم
        if (nameController.text.trim() != user.displayName) {
          await user.updateDisplayName(nameController.text.trim());
        }

        // 2. تحديث الإيميل (قد يتطلب إعادة تسجيل الدخول حديثاً لأسباب أمنية في Firebase)
        if (emailController.text.trim() != user.email) {
          await user.verifyBeforeUpdateEmail(emailController.text.trim());
        }

        // 3. تحديث الباسورد (فقط إذا تم تغييره عن القيمة الافتراضية)
        if (passwordController.text != '********' &&
            passwordController.text.length >= 6) {
          await user.updatePassword(passwordController.text);
        }

        if (mounted) {
          setState(() => isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.profileUpdated),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message ?? 'Update failed. You may need to log in again.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userImage = user?.photoURL;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isEditing) {
                        _updateProfileData();
                      } else {
                        setState(() => isEditing = true);
                      }
                    },
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : isEditing
                        ? Text(
                            'Save',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Icon(
                            Icons.edit_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Profile Avatar
              Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      backgroundImage: userImage != null
                          ? NetworkImage(userImage)
                          : null,
                      child: userImage == null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            )
                          : null,
                    ),
                    if (isEditing)
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Fields
              CustomTextField(
                label: 'Full Name',
                hint: 'Enter your name',
                controller: nameController,
                readOnly: !isEditing,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Email Address',
                hint: 'Enter your email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: !isEditing,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: passwordController,
                isPassword: true,
                readOnly: !isEditing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
