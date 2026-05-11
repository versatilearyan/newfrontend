import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _emailCtrl = TextEditingController();
  bool _emailValid = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onEmailChanged(String v) {
    setState(() {
      _emailValid = v.contains('@') && v.toLowerCase().contains('.edu');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: context.bgPage,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: AppTheme.primary, size: 18),
                          const SizedBox(width: 6),
                          Text('CampusBlind',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: context.txtMain)),
                        ],
                      ),
                      Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: context.border),
                          color: context.isDark ? AppTheme.darkCard : Colors.white,
                        ),
                        child: Center(
                          child: Text('?',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: context.txtSub,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),



                // Form card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: context.bgCard,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Welcome Back',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: context.txtMain)),
                      const SizedBox(height: 6),
                      Text(
                        'Enter your university email to join\nthe conversation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.5, color: context.txtSub, height: 1.5),
                      ),
                      const SizedBox(height: 22),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('UNIVERSITY EMAIL (.EDU)',
                            style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                color: context.txtSub)),
                      ),
                      const SizedBox(height: 8),
                      _EmailField(
                        controller: _emailCtrl,
                        isValid: _emailValid,
                        onChanged: _onEmailChanged,
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'We will send a secure magic link to this address. No passwords required.',
                          style: TextStyle(
                              fontSize: 11.5,
                              color: AppTheme.textLight,
                              height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _VerifyButton(
                        isActive: _emailValid,
                        email: _emailCtrl.text,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/otp',
                          arguments: _emailCtrl.text,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _TrustedSection(),
                      const SizedBox(height: 20),
                      const _TermsText(),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Footer badges
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: context.bgCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _FooterBadge(icon: Icons.lock_outline, label: 'End-to-End\nEncryption'),
                      _FooterBadge(icon: Icons.visibility_off_outlined, label: 'No Tracking\nPixels'),
                      _FooterBadge(icon: Icons.verified_user_outlined, label: 'Anti-Bot\nProtection'),
                      _FooterBadge(icon: Icons.shield_outlined, label: 'FERPA\nCompliant'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatefulWidget {
  final TextEditingController controller;
  final bool isValid;
  final ValueChanged<String> onChanged;
  const _EmailField({required this.controller, required this.isValid, required this.onChanged});

  @override
  State<_EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<_EmailField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: context.isDark ? AppTheme.darkCard : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focused ? AppTheme.primary.withOpacity(0.6) : context.border,
            width: _focused ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                style: TextStyle(fontSize: 14, color: context.txtMain),
                decoration: InputDecoration(
                  hintText: 'student@university.edu',
                  hintStyle: TextStyle(color: context.txtLight, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                ),
              ),
            ),
            if (widget.isValid)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('✓',
                        style: TextStyle(fontSize: 11, color: AppTheme.primary)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VerifyButton extends StatefulWidget {
  final bool isActive;
  final String email;
  final VoidCallback onTap;
  const _VerifyButton({
    required this.isActive,
    required this.email,
    required this.onTap,
  });

  @override
  State<_VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<_VerifyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Verify your .edu email  →',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustedSection extends StatelessWidget {
  const _TrustedSection();
  static const _schools = [
    ('Stanford', Color(0xFFEF4444)),
    ('MIT', Color(0xFF3B5BDB)),
    ('Columbia', Color(0xFF7C3AED)),
    ('Princeton', Color(0xFFF97316)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('TRUSTED BY STUDENTS FROM',
            style: TextStyle(
                fontSize: 10, letterSpacing: 0.8, color: AppTheme.textLight,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _schools.map((s) => _SchoolChip(name: s.$1, color: s.$2)).toList(),
        ),
      ],
    );
  }
}

class _SchoolChip extends StatelessWidget {
  final String name;
  final Color color;
  const _SchoolChip({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: context.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(name,
              style: TextStyle(fontSize: 13, color: context.txtMain,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(fontSize: 11.5, color: AppTheme.textLight, height: 1.6),
        children: [
          TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(text: 'Community\nGuidelines',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w500)),
          TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Commitment',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w500)),
          TextSpan(text: '.'),
        ],
      ),
    );
  }
}

class _FooterBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FooterBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: context.txtLight),
        const SizedBox(height: 5),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10.5, color: context.txtLight, height: 1.4)),
      ],
    );
  }
}