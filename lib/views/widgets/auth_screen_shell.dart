import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class AuthScreenShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const AuthScreenShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return Stack(
          children: [
            Positioned(
              top: -90,
              right: -40,
              child: _blob(
                size: 220,
                color: AppColors.primary.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              top: 120,
              left: -60,
              child: _blob(
                size: 170,
                color: AppColors.deepBlue.withValues(alpha: 0.08),
              ),
            ),
            Positioned(
              bottom: -70,
              right: 20,
              child: _blob(
                size: 180,
                color: AppColors.orange.withValues(alpha: 0.08),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 36 : 16,
                    vertical: 22,
                  ),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(
                                  top: 30,
                                  right: 22,
                                ),
                                child: _AuthIntro(),
                              ),
                            ),
                            Expanded(flex: 2, child: _formCard(context)),
                          ],
                        )
                      : _formCard(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _formCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFECECF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _brandHeader(context),
          const SizedBox(height: 18),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF161627),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF7C7C90),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _brandHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF6D54FF), Color(0xFF4B9CFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Image.asset('assets/images/updated_logo_app.png'),
        ),
        const SizedBox(width: 10),
        Text(
          'E-Commerce',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1C1C2B),
          ),
        ),
      ],
    );
  }

  Widget _blob({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _AuthIntro extends StatelessWidget {
  const _AuthIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Smooth Shopping\nStarts Here',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1D1D2B),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Clean experience, quick access, and a calm interface that matches the app style.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF6F6F84),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.white.withValues(alpha: 0.86),
            border: Border.all(color: const Color(0xFFE7E7F1)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.primary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your credentials are protected with secure authentication.',
                  style: TextStyle(color: Color(0xFF5D5D74), height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
