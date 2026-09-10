import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../auth/data/auth_api.dart';
import '../../auth/providers/auth_provider.dart';

class QrScreen extends ConsumerStatefulWidget {
  const QrScreen({super.key});

  @override
  ConsumerState<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends ConsumerState<QrScreen> {
  static const _errorCooldown = Duration(seconds: 3);
  final _controller = MobileScannerController(formats: const [BarcodeFormat.qrCode], detectionSpeed: DetectionSpeed.normal);
  bool _inProgress = false;
  DateTime? _lastErrorAt;
  bool _permissionToastShown = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || _inProgress) return;
    final last = _lastErrorAt;
    if (last != null && DateTime.now().difference(last) < _errorCooldown) return;
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    try {
      final data = jsonDecode(raw);
      if (data is! Map) return;
      final computerId = data['computer_id']?.toString();
      final computerTime = data['computer_time'];
      if (computerId == null || computerId.isEmpty || computerTime == null) return;
      _inProgress = true;
      final token = ref.read(authProvider).accessToken ?? '';
      await ref.read(authApiProvider).desktopLogin(computerId: computerId, bearer: 'Bearer $token');
      await _controller.stop();
      if (mounted) context.go('/');
      toast.success(l.welcome);
    } catch (_) {
      toast.danger(l.authError);
      _lastErrorAt = DateTime.now();
      _inProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
          errorBuilder: (context, error) {
            if (error.errorCode == MobileScannerErrorCode.permissionDenied && !_permissionToastShown) {
              _permissionToastShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(toastProvider.notifier).danger(l.cameraPermissionDenied));
            }
            return ColoredBox(
              color: AceColors.bg,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    error.errorCode == MobileScannerErrorCode.permissionDenied ? l.cameraPermissionDenied : l.scannerOnlyInApp,
                    textAlign: TextAlign.center,
                    style: AceText.style(size: 14, color: AceColors.muted),
                  ),
                ),
              ),
            );
          },
        ),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -40),
            child: const SizedBox(width: 250, height: 250, child: CustomPaint(painter: _CornersPainter())),
          ),
        ),
      ],
    );
  }
}

class _CornersPainter extends CustomPainter {
  const _CornersPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AceColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.butt;
    const len = 30.0;
    const r = 20.0;
    final w = size.width;
    final h = size.height;
    void corner(Offset origin, int sx, int sy) {
      final path = Path()
        ..moveTo(origin.dx, origin.dy + sy * len)
        ..lineTo(origin.dx, origin.dy + sy * r)
        ..arcToPoint(Offset(origin.dx + sx * r, origin.dy), radius: const Radius.circular(r), clockwise: (sx * sy) > 0)
        ..lineTo(origin.dx + sx * len, origin.dy);
      canvas.drawPath(path, paint);
    }

    corner(const Offset(1.5, 1.5), 1, 1);
    corner(Offset(w - 1.5, 1.5), -1, 1);
    corner(Offset(1.5, h - 1.5), 1, -1);
    corner(Offset(w - 1.5, h - 1.5), -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
