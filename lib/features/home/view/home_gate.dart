import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/saved/repository/saved_fitting_store.dart';
import 'package:fit_mate_client/features/saved/view/saved_view.dart';
import 'package:fit_mate_client/features/upload/view/upload_view.dart';

/// Observes route changes so the home can re-check saved fittings when the
/// user pops back to it (e.g. right after generating + auto-saving a fitting).
final RouteObserver<PageRoute<dynamic>> homeRouteObserver =
    RouteObserver<PageRoute<dynamic>>();

/// App entry screen.
/// - No saved fittings yet → the original upload screen (first-run experience).
/// - One or more saved → the saved gallery list with a bottom camera button.
class HomeGate extends StatefulWidget {
  const HomeGate({super.key});

  @override
  State<HomeGate> createState() => _HomeGateState();
}

class _HomeGateState extends State<HomeGate> with RouteAware {
  final _store = SavedFittingStore();
  bool _loading = true;
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      homeRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    homeRouteObserver.unsubscribe(this);
    super.dispose();
  }

  // Returned to the home route — saved fittings may have changed.
  @override
  void didPopNext() {
    _load();
  }

  Future<void> _load() async {
    final list = await _store.list();
    if (!mounted) return;
    setState(() {
      _hasSaved = list.isNotEmpty;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF17162F),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF7A90)),
        ),
      );
    }
    return _hasSaved ? const SavedView() : const UploadView();
  }
}
