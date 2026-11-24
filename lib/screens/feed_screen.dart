import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/video_item.dart';

class FeedScreen extends StatefulWidget {
  final AuthService authService;

  const FeedScreen({super.key, required this.authService});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isLoggingOut = false;

  // Lista de videos de ejemplo con URLs públicas 100% compatibles
  final List<VideoData> _videos = const [
    VideoData(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      username: 'flutter_latam',
      description:
          '🦋 Hermosa mariposa en cámara lenta. ¡Desarrollando apps fluidas con Flutter y Firebase! #flutter #parcial #tiktok',
      songTitle: 'Sonido original - Flutter Latam Oficial',
      likes: 24500,
      comments: 1320,
      shares: 489,
      userAvatar:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    ),
    VideoData(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'nature_shorts',
      description:
          '🐝 La magia de la polinización y la naturaleza en alta definición. ¡Dale me gusta si amas la vida! 🌻 #nature #bee #viral',
      songTitle: 'Spring Vibes - LoFi Nature Beats',
      likes: 89400,
      comments: 4230,
      shares: 3120,
      userAvatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    ),
    VideoData(
      videoUrl: 'https://media.w3.org/2010/05/bunny/trailer.mp4',
      username: 'animacion_3d',
      description:
          '🐰 El clásico Big Buck Bunny en acción. Animación de código abierto para pruebas en video_player. #animation #3d #blender',
      songTitle: 'Big Buck Theme - Orchestral Suite',
      likes: 12500,
      comments: 654,
      shares: 210,
      userAvatar:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    ),
    VideoData(
      videoUrl: 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      username: 'cinema_trailer',
      description:
          '🐉 Trailer cinematográfico de Sintel. Fantasía y aventura épica en app_parcial. #cinema #epic #trailers #movies',
      songTitle: 'Dragon Flight - Epic Cinematic Soundtrack',
      likes: 54100,
      comments: 2980,
      shares: 1540,
      userAvatar:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    ),
    VideoData(
      videoUrl: 'https://media.w3.org/2010/05/video/movie_300.mp4',
      username: 'tech_creators',
      description:
          '🚀 Reproducción continua y gestión de ciclo de vida en Flutter. ¡Suscríbete para más tips! #coding #developer #dart',
      songTitle: 'Futuristic Waves - Electronic Bass',
      likes: 43200,
      comments: 1845,
      shares: 980,
      userAvatar:
          'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showProfileAndLogoutDialog() {
    final user = widget.authService.currentUser;
    final displayName = user?.displayName ?? 'Usuario';
    final email = user?.email ?? 'Sin correo electrónico';
    final photoUrl = user?.photoURL;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicador de arrastre superior
                Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Avatar del usuario
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFFE2C55),
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 14),

                // Nombre completo
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),

                // Correo electrónico
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 16),

                // Badge de estado autenticado
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, size: 16, color: Colors.green),
                      SizedBox(width: 6),
                      Text(
                        'Sesión Activa en Firebase',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botón de Cerrar Sesión
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoggingOut
                        ? null
                        : () async {
                            Navigator.of(ctx).pop();
                            await _handleLogout();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFE2C55),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await widget.authService.signOut();
      // GoRouter redirige automáticamente a /login al detectar el cambio de sesión
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authService.currentUser;
    final userLabel = user?.displayName?.split(' ').first ??
        user?.email?.split('@').first ??
        'Perfil';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Feed de videos vertical con PageView.builder
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return VideoItem(
                key: ValueKey(_videos[index].videoUrl),
                data: _videos[index],
                isCurrent: index == _currentIndex,
              );
            },
          ),

          // Barra Superior: Tabs "Siguiendo" / "Para ti" y Botón de Perfil/Logout
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Título o Logo sutil
                    const Text(
                      'app_parcial',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),

                    // Tabs Centrales estilo TikTok
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white60,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text(
                            'Siguiendo',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Para ti',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 28,
                              height: 2.5,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFE2C55),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Botón de Perfil / Logout en la esquina superior derecha
                    GestureDetector(
                      onTap: _showProfileAndLogoutDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 80),
                              child: Text(
                                userLabel,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.logout_rounded,
                              color: Color(0xFFFE2C55),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
