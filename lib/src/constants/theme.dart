part of constants;

final ThemeData githubTheme = ThemeData.from(
	colorScheme: const ColorScheme.dark(
		primary: white
	),
).copyWith(
 	textButtonTheme: const TextButtonThemeData(
 		style: ButtonStyle(
 			shape: MaterialStatePropertyAll(RoundedRectangleBorder(
 				borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))
 			))
 		),
 	),
	inputDecorationTheme: InputDecorationTheme(
		contentPadding: const EdgeInsets.all(kSmallSpacing),
		isCollapsed: true,
		border: OutlineInputBorder(
			borderRadius: BorderRadius.circular(kBorderRadius)
		),
	)
);
