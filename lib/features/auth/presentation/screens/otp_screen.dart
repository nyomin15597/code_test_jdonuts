import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _startSeconds = 300;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _startSeconds = 300;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_startSeconds == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _startSeconds--);
      }
    });
  }

  String get _formattedTime {
    final minutes = _startSeconds ~/ 60;
    final seconds = _startSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _checkAndNavigate() async {
    if (_isVerifying) return;
    final otp = _controllers.map((controller) => controller.text).join();
    if (otp.length != 6) return;

    setState(() => _isVerifying = true);
    final success =
        await ref.read(authControllerProvider.notifier).verifyOtp(otp);
    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (!success) {
      final message = ref.read(authControllerProvider).errorMessage ??
          'Invalid OTP code. Try 123456';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    final loggedIn = ref.read(authControllerProvider).isLoggedIn;
    context.go(loggedIn ? '/home' : '/name');
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                      onPressed: () => context.go('/phone'),
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      value: 0.50,
                      backgroundColor: AppColors.primary,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF4B8B)),
                      strokeWidth: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Verify your number',
                style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F), height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "We've sent 6 digit OTP to ${auth.phone}",
                style: const TextStyle(
                  fontSize: 14, color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, _buildOtpBox),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Text("Didn't receive the code?  ",
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                  GestureDetector(
                    onTap: _canResend ? () {
                      _startTimer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Demo OTP resend timer restarted.'),
                        ),
                      );
                    } : null,
                    child: _canResend
                        ? const Text('Resend Code',
                            style: TextStyle(
                              fontSize: 13, color: Color(0xFFFF4B8B),
                              fontWeight: FontWeight.bold,
                            ))
                        : RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 13, color: Colors.grey,
                              ),
                              children: [
                                const TextSpan(text: 'Resend in '),
                                TextSpan(
                                  text: _formattedTime,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' min'),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(auth.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent)),
              ],
              const Spacer(),
              if (_isVerifying)
                const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 12),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 11, color: Colors.grey, height: 1.4,
                    ),
                    children: [
                      TextSpan(text: 'By continuing, you acknowledge that you have read and\nagree to our '),
                      TextSpan(text: 'Terms of Use',
                        style: TextStyle(
                          color: Color(0xFFFF4B8B),
                          fontWeight: FontWeight.w500,
                        )),
                      TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFFFF4B8B),
                          fontWeight: FontWeight.w500,
                        )),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 48, height: 56,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8, offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold,
            color: Color(0xFF1F1F1F),
          ),
          decoration: const InputDecoration(
            counterText: '', border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
            if (index == 5 && value.isNotEmpty) _checkAndNavigate();
          },
        ),
      ),
    );
  }
}
