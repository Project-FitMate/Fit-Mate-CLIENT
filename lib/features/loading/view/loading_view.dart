import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/loading/viewmodel/loading_viewmodel.dart';
import 'package:fit_mate_client/features/loading/widget/loading_scan_frame.dart';
import 'package:fit_mate_client/features/loading/widget/loading_progress_bar.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/result/model/result_item.dart';
import 'package:fit_mate_client/features/result/view/result_view.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({
    super.key,
    required this.userImageName,
    required this.outfitImageUrl,
    required this.selectedProduct,
  });

  final String userImageName;
  final String outfitImageUrl;
  final RecommendedProduct selectedProduct;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with TickerProviderStateMixin {
  late final LoadingViewModel _viewModel;

  // Scan line + character pulse share one looping controller (both 4s ease-in-out)
  late final AnimationController _loopController;
  late final Animation<double> _scanPositionAnim;
  late final Animation<double> _scanOpacityAnim;
  late final Animation<double> _pulseOpacityAnim;

  // Progress bar (0 → 0.95 over 12s)
  late final AnimationController _progressController;
  late final Animation<double> _progressAnim;

  // Character fill (0 → 1.0 over 8s, one-shot)
  late final AnimationController _fillController;
  late final Animation<double> _fillAnim;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _viewModel = LoadingViewModel(
      userImageName: widget.userImageName,
      outfitImageUrl: widget.outfitImageUrl,
    );

    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scanPositionAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );
    _scanOpacityAnim = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );
    _pulseOpacityAnim = Tween<double>(begin: 0.3, end: 0.5).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();
    _progressAnim = Tween<double>(begin: 0.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: const Cubic(0.1, 0.5, 0.5, 1.0),
      ),
    );

    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();
    _fillAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fillController, curve: Curves.easeInOut),
    );

    _viewModel.addListener(_onViewModelChange);
    _viewModel.start();
  }

  void _onViewModelChange() {
    if (_navigated) return;
    if (_viewModel.status == FittingStatus.success && _viewModel.result != null) {
      _navigated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultView(
            generatedImageBase64: _viewModel.result!.imageBase64,
            items: [ResultItem.fromProduct(widget.selectedProduct)],
          ),
        ),
      );
    } else if (_viewModel.status == FittingStatus.error) {
      _navigated = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.errorMessage ?? '오류가 발생했습니다.')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _viewModel.dispose();
    _loopController.dispose();
    _progressController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingScanFrame(
                    scanPositionAnim: _scanPositionAnim,
                    scanOpacityAnim: _scanOpacityAnim,
                    pulseOpacityAnim: _pulseOpacityAnim,
                    fillAnim: _fillAnim,
                  ),
                  const SizedBox(height: 64),
                  _DynamicText(viewModel: _viewModel),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LoadingProgressBar(progressAnim: _progressAnim),
          ),
        ],
      ),
    );
  }
}

class _DynamicText extends StatelessWidget {
  const _DynamicText({required this.viewModel});

  final LoadingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return SizedBox(
          height: 100,
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                    child: child,
                  ),
                ),
                child: Text(
                  viewModel.mainText,
                  key: ValueKey(viewModel.mainText),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFE7D5E),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  viewModel.subText,
                  key: ValueKey(viewModel.subText),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
