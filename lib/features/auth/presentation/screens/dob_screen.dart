import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/auth_controller.dart';
import '../../application/auth_validators.dart';

class DobScreen extends ConsumerStatefulWidget {
  const DobScreen({super.key});

  @override
  ConsumerState<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends ConsumerState<DobScreen> {
  final _monthController = TextEditingController();
  final _dayController = TextEditingController();
  final _yearController = TextEditingController();
  String? _errorMessage;
  bool _isSaving = false;

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _getMonthNumber(String value) {
    const months = {
      'january': 1, 'february': 2, 'march': 3, 'april': 4,
      'may': 5, 'june': 6, 'july': 7, 'august': 8,
      'september': 9, 'october': 10, 'november': 11, 'december': 12,
    };
    return months[value.trim().toLowerCase()] ?? 0;
  }

  DateTime? _parseDate() {
    final month = _getMonthNumber(_monthController.text);
    final day = int.tryParse(_dayController.text.trim());
    final year = int.tryParse(_yearController.text.trim());

    if (month == 0 || day == null || year == null) return null;
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  bool _validateDateOfBirth() {
    if (_monthController.text.trim().isEmpty ||
        _dayController.text.trim().isEmpty ||
        _yearController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please fill in all date fields');
      return false;
    }

    final dob = _parseDate();
    if (dob == null) {
      setState(() => _errorMessage = 'Please enter a valid calendar date');
      return false;
    }

    final error = AuthValidators.validateDob(dob);
    if (error != null) {
      setState(() => _errorMessage = error);
      return false;
    }

    setState(() => _errorMessage = null);
    return true;
  }

  Future<void> _saveAndContinue() async {
    if (_isSaving || !_validateDateOfBirth()) return;
    setState(() => _isSaving = true);

    final auth = ref.read(authControllerProvider);
    final saved = await ref.read(authControllerProvider.notifier).register(
      firstName: auth.firstName,
      lastName: auth.lastName,
      dob: _parseDate()!,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (saved) {
      context.go('/welcome');
    } else {
      setState(() {
        _errorMessage = ref.read(authControllerProvider).errorMessage ??
            'Unable to save your profile';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      onPressed: () => context.go('/name'),
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      value: 1,
                      backgroundColor: AppColors.primary,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF4B8B)),
                      strokeWidth: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "What's your\ndate of birth?",
                style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F), height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent, fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              _buildInputField(_monthController, 'Month (e.g. May)'),
              const SizedBox(height: 16),
              _buildInputField(_dayController, 'Day (e.g. 1)',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildInputField(_yearController, 'Year (e.g. 1980)',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 220),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: const Color(0xFF4EE2EC),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isSaving ? null : _saveAndContinue,
                child: _isSaving
                    ? const SizedBox(
                  height: 22, width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white,
                  ),
                )
                    : const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _terms(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller,
      String hint, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600,
          color: Color(0xFF1F1F1F),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400,
            color: Colors.black26,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _terms() => Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
        children: [
          TextSpan(text: 'By continuing, you acknowledge that you have read and\nagree to our '),
          TextSpan(text: 'Terms of Use',
              style: TextStyle(
                color: Color(0xFFFF4B8B), fontWeight: FontWeight.w500,
              )),
          TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Policy',
              style: TextStyle(
                color: Color(0xFFFF4B8B), fontWeight: FontWeight.w500,
              )),
          TextSpan(text: '.'),
        ],
      ),
    ),
  );
}