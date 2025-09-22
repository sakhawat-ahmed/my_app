import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoaderDownloadPage(),
    );
  }
}

class LoaderDownloadPage extends StatefulWidget {
  const LoaderDownloadPage({super.key});

  @override
  State<LoaderDownloadPage> createState() => _LoaderDownloadPageState();
}

class _LoaderDownloadPageState extends State<LoaderDownloadPage> {
  StateMachineController? _smController;
  SMITrigger? _triggerStart;
  SMINumber? _progressInput;

  bool isDownloading = false;
  double progress = 0;

  void _onRiveInit(Artboard artboard) {
    const stateMachineName = 'loader_icon';

    final controller = StateMachineController.fromArtboard(
      artboard,
      stateMachineName,
    );

    if (controller != null) {
      artboard.addController(controller);
      _smController = controller;

      // ✅ Replace with your actual input names (if they exist)
      _triggerStart =
          controller.findInput<bool>('StartDownload') as SMITrigger?;
      _progressInput =
          controller.findInput<double>('ProgressValue') as SMINumber?;

      // If your machine starts automatically, you don’t need a trigger.
    } else {
      debugPrint('⚠️ State machine not found. Check the name.');
    }
  }

  void startDownload() {
    setState(() {
      isDownloading = true;
      progress = 0;
    });

    // Fire trigger if the machine expects a start action
    _triggerStart?.fire();

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        progress += 0.05;
        // Update the Rive number input if it exists
        _progressInput?.value = progress;
      });
      return progress < 1;
    }).then((_) {
      setState(() => isDownloading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rive Loader',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 220,
              height: 220,
              child: RiveAnimation.asset(
                'assets/loader_icon.riv',
                fit: BoxFit.contain,
                
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isDownloading ? null : startDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(180, 50),
              ),
              child: Text(
                isDownloading
                    ? 'Downloading ${(progress * 100).round()}%'
                    : 'Download',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
