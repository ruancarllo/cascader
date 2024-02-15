# [Cascader](https://github.com/ruancarllo/cascader) &middot; ![License](https://img.shields.io/badge/License-BSD--Zero--Clause-dodgerblue?style=flat-square) ![Language](https://img.shields.io/badge/Language-Dart-darkturquoise?style=flat-square)

This command-line software is responsible for normalizing and indenting your style sheets available in a specific folder, as well as adapting them for mobile devices. It is compatible with both [CSS](https://wikipedia.org/wiki/Cascading_Style_Sheets) and [SCSS](https://en.wikipedia.org/wiki/Sass_(style_sheet_language)) formats.

## Installation

To set up the program on your computer, you need to install the latest version of the [Dart SDK](https://dart.dev). After that, open your terminal in the [source](./source) folder and execute the following command:

```shell
dart compile exe "cascader.dart" -o "cascader"
```

It is recommended to add the generated program to a global executable folder on your operating system that is cataloged by the `$PATH` environment variable.

Don't forget to allow the execution of the executable with:

```shell
chmod +x cascader
```

## Usage

After installing Cascader correctly, you can perform three actions.

1. Simply normalize and indent the style sheets:

```shell
cascader
```

2. Add mobile adaptations to the style sheets:

```shell
cascader convert
```

3. Remove mobile adaptations from the style sheets:

```shell
cascader revert
```

## License

This project is licensed under the terms of the [BSD Zero Clause License](./LICENSE.md), so feel free to use it to help you with any projects.