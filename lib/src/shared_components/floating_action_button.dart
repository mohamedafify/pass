import 'dart:math';

import 'package:flutter/material.dart';

class FixedCenterDockedFabLocation extends FloatingActionButtonLocation {
	final context;

	const FixedCenterDockedFabLocation({
		this.context,
	});

	double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
		final double contentBottom = scaffoldGeometry.contentBottom;
		final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
		final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
		final double snackBarHeight = scaffoldGeometry.snackBarSize.height;
		double bottomDistance = MediaQuery.of(context).viewInsets.bottom;

		double fabY = contentBottom + bottomDistance - fabHeight / 2.0;

		if (snackBarHeight > 0.0) {
			fabY = min(fabY, contentBottom - snackBarHeight - fabHeight - kFloatingActionButtonMargin);
		}

		if (bottomSheetHeight > 0.0) {
			fabY = min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);
		}

		final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
		return min(maxFabY, fabY);
	}

	@override
	Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
		final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2.0;
		return Offset(fabX, getDockedY(scaffoldGeometry));
	}
}

class NoScalingAnimation extends FloatingActionButtonAnimator {
	final context;

	const NoScalingAnimation({
		this.context,
	});

	@override
	Offset getOffset({required Offset begin, required Offset end, required double progress}) {
		return end;
	}

	@override
	Animation<double> getRotationAnimation({required Animation<double> parent}) {
		return const AlwaysStoppedAnimation(1.0);
	}

	@override
	Animation<double> getScaleAnimation({required Animation<double> parent}) {
		return const AlwaysStoppedAnimation(1.0);
	}
}
