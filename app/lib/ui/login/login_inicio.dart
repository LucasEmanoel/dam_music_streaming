import 'dart:io';
import 'package:dam_music_streaming/domain/models/user_data_l.dart';
import 'package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import 'package:provider/provider.dart';
import 'widgets/cover_carousel.dart';

class LoginInicio extends StatefulWidget {
  final Directory docsDir;
  const LoginInicio({super.key, required this.docsDir});

  @override
  State<LoginInicio> createState() => _LoginInicioState();
}

class _LoginInicioState extends State<LoginInicio> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool lembrar = false;
  bool obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext widgetContext) {
    final scheme = Theme.of(widgetContext).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth > 520
                ? 420.0
                : constraints.maxWidth;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const CoverCarousel(covers: _covers),
                      const SizedBox(height: 24),

                      const Text(
                        'Bem-vindo ao Harmony!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Milhões de músicas para ouvir agora.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Faça login para entrar no sistema',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 14),

                      _input(
                        controller: emailCtrl,
                        hint: 'Email',
                        icon: Icons.alternate_email,
                      ),
                      const SizedBox(height: 10),
                      _input(
                        controller: passCtrl,
                        hint: 'Senha',
                        icon: Icons.lock_outline,
                        obscure: obscure,
                        onToggleObscure: () =>
                            setState(() => obscure = !obscure),
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: lembrar,
                            onChanged: (v) =>
                                setState(() => lembrar = v ?? false),
                            visualDensity: VisualDensity.compact,
                          ),
                          const Text(
                            'Lembrar de mim',
                            style: TextStyle(fontSize: 12.5),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _resetSenha,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Esqueceu a senha?',
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: scheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _loading
                              ? null
                              : () async {
                                  await _entrar(widgetContext);
                                },
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_right_alt_rounded,
                                      size: 22,
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _loading ? null : _entrarComGoogle,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Text('Continue with Google'),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: SvgIcon(
                                  assetName: 'assets/icons/google.svg',
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Novo por aqui ?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/signup'),
                            child: Text(
                              'Cadastre-se',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _entrar(BuildContext context) async {
    final UserViewModel userViewModel = context.read<UserViewModel>();

    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      _toast('Preencha e-mail e senha.');
      return;
    }

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final UsuarioData user = UsuarioData(
        id: 123,
        fullName: 'Teste da Silva',
        username: 'teste_zika',
        email: "teste@email.com",
        role: 'user',
      );
      userViewModel.addLoggedUser(user);
      userViewModel.setProfilePicture();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _toast(_mapAuthError(e));
    } catch (e) {
      _toast('Falha ao entrar. Tente novamente.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetSenha() async {
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      _toast('Informe seu e-mail para recuperar a senha.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _toast('Enviamos um link de recuperação para $email');
    } on FirebaseAuthException catch (e) {
      _toast(_mapAuthError(e));
    }
  }

  Future<void> _entrarComGoogle() async {
    setState(() => _loading = true);
    try {
      if (kIsWeb) {
        final cred = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
        if (cred.user == null) throw Exception('Login cancelado.');
      } else {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) throw Exception('Login cancelado.');
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _toast(_mapAuthError(e));
    } catch (e) {
      _toast('Não foi possível entrar com Google.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha inválidos.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Sem conexão. Verifique sua internet.';
      default:
        return 'Erro: ${e.message ?? e.code}';
    }
  }
}

Widget _input({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscure = false,
  VoidCallback? onToggleObscure,
}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: onToggleObscure != null
          ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                size: 18,
              ),
              onPressed: onToggleObscure,
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
  );
}

const _covers = <String>[
  'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400',
  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400',
  'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400',
  'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400',
  'https://images.unsplash.com/photo-1518972559570-7cc1309f3229?w=400',
  'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=400',
  'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
  'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
];
