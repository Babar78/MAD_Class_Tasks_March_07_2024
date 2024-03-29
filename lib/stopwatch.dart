import 'dart:async';
import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key, required this.runnerName, required this.email});

  final String runnerName;
  final String email;

  @override
  State createState() => StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  int milliseconds = 0;
  Timer? timer;
  bool isTicking = true;
  final laps = <int>[];

  void _onTick(Timer time) {
    setState(() {
      milliseconds += 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay()),
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Lap ${laps.length + 1}',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: Colors.white),
          ),
          Text(
            _secondsText(milliseconds),
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildControls(),
          const SizedBox(height: 20),
          Text(
            'Runner: ${widget.runnerName}',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(width: 20),
          Text(
            'Email: ${widget.email}',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text('Start'),
          onPressed: isTicking ? null : _startTimer,
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
          ),
          onPressed: isTicking ? _lap : null,
          child: const Text('Lap'),
        ),
        const SizedBox(width: 20),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text('Stop'),
          onPressed: isTicking ? _stopTimer : null,
        )
      ],
    );
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), _onTick);
    setState(() {
      milliseconds = 0;
      isTicking = true;
      laps.clear();
    });
  }

  void _lap() {
    setState(() {
      laps.add(milliseconds);
      milliseconds = 0;
    });

    // Stop the stopwatch
    _stopTimer();

    // Show a dialog with the total run time
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Total Run Time'),
          content: Text('Your Total Run Time is ${_secondsText(laps.last)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _stopTimer() {
    timer?.cancel();
    setState(() {
      isTicking = false;
    });
  }

  Widget _buildLapDisplay() {
    return ListView(
      children: [
        for (int milliseconds in laps)
          ListTile(
            title: Text(_secondsText(milliseconds)),
          )
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _secondsText(int milliseconds) {
    final seconds = milliseconds / 1000;
    return '$seconds seconds';
  }
}
