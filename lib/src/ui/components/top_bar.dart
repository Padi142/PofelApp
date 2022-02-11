import 'package:flutter/material.dart';

import '../../../constants.dart';

class TopAppBar extends StatefulWidget {
  const TopAppBar(this.labelText, {Key? key}) : super(key: key);

  @required
  final String labelText;

  @override
  State<StatefulWidget> createState() => _TopAppBar();
}

class _TopAppBar extends State<TopAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppBar().preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 4),
                  child: Text(
                    widget.labelText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
