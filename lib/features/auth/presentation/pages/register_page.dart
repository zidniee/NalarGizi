import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'package:nalargizi/app/router/app_router.dart';

/// Register screen for NalarGizi.
///
/// Source: claude.md §3A — POST /api/auth/register
/// Source: claude1.md §UI RULES — 4 states required
/// Source: claude2.md §3 — GetIt.I<AuthCubit>()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AuthCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.dashboard,
            (_) => false,
          );
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
            'Buat Akun',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Daftar Akun Baru',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Lengkapi data diri Anda untuk mulai memantau gizi si kecil',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 28),

              // Name
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (p, c) => p.form.isNameValid != c.form.isNameValid,
                builder: (context, state) {
                  return TextField(
                    key: const Key('register_name_field'),
                    controller: _nameController,
                    onChanged: (v) =>
                        context.read<AuthCubit>().nameChanged(v),
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: const Icon(Icons.person_outline),
                      errorText: state.form.isNameValid
                          ? null
                          : 'Nama minimal 2 karakter',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Email
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (p, c) =>
                    p.form.isEmailValid != c.form.isEmailValid,
                builder: (context, state) {
                  return TextField(
                    key: const Key('register_email_field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) =>
                        context.read<AuthCubit>().emailChanged(v),
                    decoration: InputDecoration(
                      labelText: 'Email',
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
              const SizedBox(height: 16),

              // Password
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (p, c) =>
                    p.form.isPasswordValid != c.form.isPasswordValid,
                builder: (context, state) {
                  return TextField(
                    key: const Key('register_password_field'),
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (v) =>
                        context.read<AuthCubit>().passwordChanged(v),
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      hintText: 'Minimal 6 karakter',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      errorText: state.form.isPasswordValid
                          ? null
                          : 'Kata sandi minimal 6 karakter',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Phone
              TextField(
                key: const Key('register_phone_field'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (v) =>
                    context.read<AuthCubit>().phoneNumberChanged(v),
                decoration: InputDecoration(
                  labelText: 'Nomor HP (Opsional)',
                  hintText: '08XXXXXXXXXX',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 28),

              // Register button
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (p, c) => p.status != c.status,
                builder: (context, state) {
                  final isLoading = state.status == AuthStatus.loading;
                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      key: const Key('register_submit_btn'),
                      onPressed: isLoading
                          ? null
                          : () => context.read<AuthCubit>().register(),
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
                              'Daftar Sekarang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun? ',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Color(0xFFF43F5E),
                        fontWeight: FontWeight.bold,
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
  }
}
