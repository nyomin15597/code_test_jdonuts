import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/core/constants/app_colors.dart';
import '../../application/auth_controller.dart';
import '../../application/auth_validators.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _phoneController = TextEditingController();
  bool _isValid = false;

  bool _validatePhoneNumber(String input) =>
      AuthValidators.validatePhone(input) == null;

  String _getCleanedPhoneNumber(String input) {
    var cleaned = input.replaceAll(RegExp(r'\s+|-'), '');
    if (cleaned.startsWith('0')) cleaned = cleaned.substring(1);
    return '+95$cleaned';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 5, offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => context.go('/onboarding'),
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      value: 0.25,
                      backgroundColor: AppColors.primary,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF4B8B)),
                      strokeWidth: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Enter your phone\nnumber',
                style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold,
                  color: Colors.black87, height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8, offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text('+95',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      )),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          hintText: '09XXXXXXXXX',
                          hintStyle: TextStyle(color: Colors.black26),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onChanged: (value) => setState(
                          () => _isValid = _validatePhoneNumber(value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: _isValid ? () {
                    final phone = _getCleanedPhoneNumber(_phoneController.text);
                    ref.read(authControllerProvider.notifier).setPhone(phone);
                    context.go('/otp');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF56D9E4),
                    disabledBackgroundColor: const Color(0xFFBCEFF3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text('CONTINUE',
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: Colors.white, letterSpacing: 0.5,
                    )),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'By continuing, you acknowledge that you have read and\nagree to our ',
                    style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600, height: 1.3,
                    ),
                    children: const [
                      TextSpan(text: 'Terms of Use',
                        style: TextStyle(
                          color: Colors.pinkAccent, fontWeight: FontWeight.w500,
                        )),
                      TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy',
                        style: TextStyle(
                          color: Colors.pinkAccent, fontWeight: FontWeight.w500,
                        )),
                      TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
