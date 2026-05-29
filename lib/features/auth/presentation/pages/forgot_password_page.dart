import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

/// Forgot Password screen for NalarGizi.
///
/// Source: claude.md §3A — POST /api/auth/forgot-password
/// Source: claude1.md §UI RULES — 4 states required
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AuthCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Color(0xFF1E293B)),
          title: const Text(
            'Lupa Kata Sandi',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDA4AF)),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.lock_reset,
                          size: 48,
                          color: Color(0xFFF43F5E),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Masukkan email yang terdaftar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Kami akan mengirimkan link untuk membuat kata sandi baru ke email Anda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email field
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (p, c) =>
                        p.form.isEmailValid != c.form.isEmailValid,
                    builder: (context, state) {
                      return TextField(
                        key: const Key('forgot_password_email_field'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) =>
                            context.read<AuthCubit>().emailChanged(v),
                        decoration: InputDecoration(
                          labelText: 'Email Terdaftar',
                          hintText: 'nama@email.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: state.form.isEmailValid
                              ? null
                              : 'Format email tidak valid',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Send button
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (p, c) => p.status != c.status,
                    builder: (context, state) {
                      final isLoading = state.status == AuthStatus.loading;
                      return SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          key: const Key('forgot_password_submit_btn'),
                          onPressed: isLoading
                              ? null
                              : () =>
                                  context.read<AuthCubit>().forgotPassword(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF43F5E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Kirim Link Reset',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
