import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  
  int _secondsRemaining = 60;
  bool _canResend = false;
  bool _isVerifying = false;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.35)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    
    _startResendTimer();
    
    // Setup OTP field listeners
    for (int i = 0; i < 6; i++) {
      _otpControllers[i].addListener(() {
        _updateOtp();
      });
    }
  }

  void _startResendTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining == 0) {
            _canResend = true;
          } else {
            _startResendTimer();
          }
        });
      }
    });
  }

  void _updateOtp() {
    _otp = _otpControllers.map((c) => c.text).join();
    if (_otp.length == 6) {
      // Auto-verify when all 6 digits are entered
      _verifyOtp();
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        _otpControllers[index].text = value.substring(value.length - 1);
        return;
      }
      if (index < 5) {
        FocusScope.of(context).nextFocus();
      }
    }
  }

  void _onOtpBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) return;
    
    setState(() => _isVerifying = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isVerifying = false);
      // Navigate to home after successful verification
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    }
  }

  void _resendOtp() {
    if (!_canResend) return;
    
    // Clear OTP fields
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _updateOtp();
    _startResendTimer();
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent to your email'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: context.bgPage,
        appBar: AppBar(
          backgroundColor: context.bgSurface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.txtMain),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Verify Email',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.txtMain)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  // Icon
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Opacity(
                      opacity: _pulseAnim.value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mail_outline,
                          size: 40,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title
                  Text(
                    'Verify Your Email',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: context.txtMain,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Description with email
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: context.txtSub,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'We sent a code to\n'),
                        TextSpan(
                          text: widget.email,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // OTP Input Fields — responsive width
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Total gaps: 5 gaps × 8px = 40px
                      // Available per box: (screenWidth - 40 padding - 40 gaps) / 6
                      final boxSize = ((constraints.maxWidth - 40) / 6)
                          .clamp(40.0, 52.0);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => _OtpField(
                            controller: _otpControllers[index],
                            boxSize: boxSize,
                            onChanged: (value) => _onOtpChanged(value, index),
                            onBackspace: () => _onOtpBackspace(index),
                            isDark: context.isDark,
                            onFieldSubmitted: (value) {
                              if (index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isVerifying || _otp.length != 6
                          ? null
                          : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        disabledBackgroundColor:
                            AppTheme.primary.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isVerifying
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.8),
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Resend Section
                  Column(
                    children: [
                      Text(
                        "Didn't get the code?",
                        style: TextStyle(
                          fontSize: 13,
                          color: context.txtSub,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!_canResend)
                        Text(
                          'Resend in ${_secondsRemaining}s',
                          style: TextStyle(
                            fontSize: 13,
                            color: context.txtLight,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            'Resend OTP',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Check your spam folder if you don\'t see the email.',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.txtSub,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── OTP Input Field ───────────────────────────────────────────────────────────
class _OtpField extends StatefulWidget {
  final TextEditingController controller;
  final double boxSize;          // ✅ responsive size
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  final bool isDark;
  final ValueChanged<String> onFieldSubmitted;

  const _OtpField({
    required this.controller,
    required this.boxSize,
    required this.onChanged,
    required this.onBackspace,
    required this.isDark,
    required this.onFieldSubmitted,
  });

  @override
  State<_OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<_OtpField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boxSize,
      height: widget.boxSize + 10,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _focusNode.hasFocus
                  ? AppTheme.primary
                  : context.border,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: widget.isDark
              ? AppTheme.darkCard
              : const Color(0xFFF9FAFB),
        ),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: context.txtMain,
        ),
        onSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}