import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  final String participantName;
  final String participantAvatar;
  
  const VideoCallScreen({
    super.key, 
    required this.participantName,
    required this.participantAvatar,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isSpeaker = false;
  Duration _callDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _callDuration += const Duration(seconds: 1));
      }
      return true;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          // Kamera görüntüsü (simülasyon)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D2D44), Color(0xFF1A1A2E)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)],
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Center(
                      child: Text(
                        widget.participantAvatar,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.participantName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '● ',
                        style: TextStyle(color: Color(0xFF22C55E), fontSize: 12),
                      ),
                      Text(
                        _formatDuration(_callDuration),
                        style: const TextStyle(color: Color(0xFF22C55E)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Küçük önizleme
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D44),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
              ),
              child: const Center(
                child: Text('📷', style: TextStyle(fontSize: 30)),
              ),
            ),
          ),

          // Kontroller
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControl(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _buildControl(
                    icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
                    isActive: _isCameraOff,
                    onTap: () => setState(() => _isCameraOff = !_isCameraOff),
                  ),
                  _buildControl(
                    icon: Icons.call_end,
                    isRed: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildControl(
                    icon: _isSpeaker ? Icons.volume_up : Icons.volume_down,
                    isActive: _isSpeaker,
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),
                  _buildControl(
                    icon: Icons.flip_camera_ios,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControl({
    required IconData icon,
    bool isActive = false,
    bool isRed = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isRed 
              ? Colors.red 
              : (isActive ? const Color(0xFF8B5CF6) : const Color(0xFF2D2D44)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
