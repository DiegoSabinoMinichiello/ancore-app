import 'package:flutter/material.dart';

import '../viewmodels/home_view_model.dart';
import 'widgets/mic_button.dart';
import 'widgets/expandable_text_input.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel;
  late final TextEditingController _textController;
  late final GlobalKey<ExpandableTextInputState> _textInputKey;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _textController = TextEditingController();
    _textInputKey = GlobalKey<ExpandableTextInputState>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onMicTap() {
    _viewModel.toggleListening(
      onResult: (text) {
        setState(() {
          _textController.text = text;
        });
      },
      onStateChange: (listening) {
        setState(() {});
        if (listening) _scrollToBottom();
      },
    );
  }

  void _onSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Mensagem: $text')));
    _textController.clear();
    FocusScope.of(context).unfocus();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaPadding =
        MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(_viewModel.backgroundImageUrl, fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC0B0F14),
                  Color(0x660B0F14),
                  Color(0x330B0F14),
                  Color(0x990B0F14),
                ],
                stops: [0.0, 0.35, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - safeAreaPadding,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 80,
                        child: Center(
                          child: const Text(
                            'Ancore',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _viewModel.getGreeting(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'O que você está sentindo\nexatamente agora?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 48),
                          MicButton(
                            onTap: _onMicTap,
                            isListening: _viewModel.isListening,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            ExpandableTextInput(
                              key: _textInputKey,
                              controller: _textController,
                              onSubmitted: _onSend,
                              onFocusChanged: (focused) {
                                if (focused) _scrollToBottom();
                              },
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
