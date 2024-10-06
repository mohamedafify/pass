import 'dart:ui';

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
 	Loading({this.alpha = 200});
	
	int alpha;

	@override
	Widget build(BuildContext context) {
		return BackdropFilter(
			filter: ImageFilter.blur(
				sigmaX: 4.0,
				sigmaY: 4.0,
			),
			child: Container(
				color: Colors.transparent.withAlpha(alpha),
				child: const Center(
					child: CircularProgressIndicator(),
				)
			)
		);
	}
}
