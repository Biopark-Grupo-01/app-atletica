import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 2,
    this.style,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _showToggle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfExceeds();
    });
  }

  void _checkIfExceeds() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final maxWidth = renderBox?.constraints.maxWidth ?? MediaQuery.of(context).size.width;

    final span = TextSpan(text: widget.text, style: widget.style);
    final tp = TextPainter(
      text: span,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    setState(() {
      _showToggle = tp.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            maxLines: widget.trimLines,
            overflow: TextOverflow.ellipsis,
            style: widget.style,
          ),
          secondChild: Text(
            widget.text,
            style: widget.style,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 25),
        ),
        if (_showToggle)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _isExpanded ? 'Ver menos' : 'Ver mais',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
