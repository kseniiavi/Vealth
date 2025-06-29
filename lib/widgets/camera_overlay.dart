import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CameraOverlay extends StatefulWidget {
  final bool isCapturing;
  final VoidCallback? onCapture;
  final VoidCallback? onSwitchCamera;
  final VoidCallback? onGallery;

  const CameraOverlay({
    super.key,
    this.isCapturing = false,
    this.onCapture,
    this.onSwitchCamera,
    this.onGallery,
  });

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
        
        // Teeth positioning guide
        Center(
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 280,
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.accent,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      // Corner markers
                      _buildCornerMarker(Alignment.topLeft),
                      _buildCornerMarker(Alignment.topRight),
                      _buildCornerMarker(Alignment.bottomLeft),
                      _buildCornerMarker(Alignment.bottomRight),
                      
                      // Center guide
                      Center(
                        child: Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Instructions
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.camera_alt,
                  color: AppColors.accent,
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  'Position Horse\'s Front Teeth',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Align the incisors within the frame for best results',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        
        // Bottom controls
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Gallery button
              if (widget.onGallery != null)
                _buildControlButton(
                  icon: Icons.photo_library,
                  onTap: widget.onGallery!,
                ),
              
              // Capture button
              GestureDetector(
                onTap: widget.isCapturing ? null : widget.onCapture,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: widget.isCapturing 
                          ? AppColors.error 
                          : AppColors.accent,
                      width: 6,
                    ),
                  ),
                  child: widget.isCapturing
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.error,
                              ),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 36,
                          color: AppColors.primary,
                        ),
                ),
              ),
              
              // Switch camera button
              if (widget.onSwitchCamera != null)
                _buildControlButton(
                  icon: Icons.flip_camera_ios,
                  onTap: widget.onSwitchCamera!,
                ),
            ],
          ),
        ),
        
        // Tips
        Positioned(
          bottom: 200,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.warning,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tip: Ensure good lighting and keep the horse calm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCornerMarker(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.accent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.5),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class TeethPositioningGuide extends StatelessWidget {
  const TeethPositioningGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 180),
      painter: TeethGuidePainter(),
    );
  }
}

class TeethGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Main frame
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.9,
        height: size.height * 0.8,
      ),
      const Radius.circular(15),
    );
    canvas.drawRRect(rect, paint);
    
    // Center line
    canvas.drawLine(
      Offset(center.dx, center.dy - 20),
      Offset(center.dx, center.dy + 20),
      paint,
    );
    
    // Tooth position guides
    final toothPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Draw tooth position indicators
    for (int i = 0; i < 6; i++) {
      final x = center.dx - 60 + (i * 24);
      final toothRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, center.dy),
          width: 18,
          height: 40,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(toothRect, toothPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
