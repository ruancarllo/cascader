import 'dart:io';

class Cascader {
  static String minifyDirectives(String styleSheet) {
    List<String> oldCharacters = styleSheet.split('');
    List<String> newCharacters = [];

    bool areSingleQuotesOpen = false;
    bool areDoubleQuotesOpen = false;

    for (int characterIndex = 0; characterIndex < oldCharacters.length; characterIndex++) {
      String analyzingCharacter = oldCharacters[characterIndex];

      if (analyzingCharacter == '"') areSingleQuotesOpen = !areSingleQuotesOpen;
      if (analyzingCharacter == "'") areDoubleQuotesOpen = !areDoubleQuotesOpen;

      if (areSingleQuotesOpen || areDoubleQuotesOpen) {
        newCharacters.add(analyzingCharacter);
        continue;
      }

      if (
        characterIndex + 1 >= 0 && characterIndex + 1 < oldCharacters.length &&
        characterIndex - 1 >= 0 && characterIndex - 1 < oldCharacters.length &&

        analyzingCharacter == ':' && oldCharacters[characterIndex + 1] != ':' && oldCharacters[characterIndex - 1] != ':'
      ) {
        while (analyzingCharacter != ';' && analyzingCharacter != '}' && analyzingCharacter != ')') {
          newCharacters.add(analyzingCharacter);
          characterIndex++;
          analyzingCharacter = oldCharacters[characterIndex];
        }
      }

      if (analyzingCharacter == '@') {
        while (analyzingCharacter != ' ') {
          newCharacters.add(analyzingCharacter);
          characterIndex++;
          analyzingCharacter = oldCharacters[characterIndex];
        }
        
        newCharacters.add(' ');
        continue;
      }

      if (
        characterIndex + 1 >= 0 && characterIndex + 1 < oldCharacters.length &&
        characterIndex - 1 >= 0 && characterIndex - 1 < oldCharacters.length &&

        analyzingCharacter == ':' && oldCharacters[characterIndex + 1] != ':' && oldCharacters[characterIndex - 1] != ':'
      ) {
        newCharacters.add(analyzingCharacter);
        newCharacters.add(' ');
        continue;
      }

      if (analyzingCharacter == '{') {
        newCharacters.add(' ');
        newCharacters.add(analyzingCharacter);
        continue;
      }

      if (analyzingCharacter == '}') {
        int previousIndex = characterIndex - 1;
        String previousCharacter = oldCharacters[previousIndex];

        while (previousCharacter == ' ' || previousCharacter == '\n') {
          previousIndex--;
          previousCharacter = oldCharacters[previousIndex];
        }

        if (previousCharacter != ';' && previousCharacter != '}') {
          newCharacters.add(';');
          newCharacters.add(analyzingCharacter);
          continue;
        }
      }
      
      if (analyzingCharacter != ' ' && analyzingCharacter != '\n') {
        newCharacters.add(analyzingCharacter);
      }
    }

    styleSheet = newCharacters.join();

    return styleSheet;
  }

  static String breakLines(String styleSheet) {
    List<String> styleSheetCharacters = styleSheet.split('');

    for (int characterIndex = 0; characterIndex < styleSheetCharacters.length; characterIndex++) {
      String analyzingCharacter = styleSheetCharacters[characterIndex];

      if (analyzingCharacter == '{' || analyzingCharacter == '}' || analyzingCharacter == ';') {
        styleSheetCharacters[characterIndex] = '${analyzingCharacter}\n';
      }
    }

    styleSheet = styleSheetCharacters.join();

    return styleSheet;
  }

  static String indentLines(String styleSheet) {
    List<String> styleSheetLines = styleSheet.split('\n');

    int indentationCount = 0;

    for (int lineIndex = 0; lineIndex < styleSheetLines.length; lineIndex++) {
      String analyzingLine = styleSheetLines[lineIndex];
      String trimmedLine = analyzingLine.trim();

      if (analyzingLine.startsWith('}')) {
        indentationCount--;
      }

      int indentationCorrection = trimmedLine.startsWith('"') || trimmedLine.startsWith("'") ? 1 : 0;

      styleSheetLines[lineIndex] = '${indentationSpacing * (indentationCount + indentationCorrection)}${trimmedLine}';

      if (analyzingLine.endsWith('{')) {
        indentationCount++;
      }
    }

    styleSheet = styleSheetLines.join('\n');

    return styleSheet;
  }

  static String spaceLines(String styleSheet) {
    List<String> styleSheetLines = styleSheet.split('\n');

    for (int lineIndex = 0; lineIndex < styleSheetLines.length; lineIndex++) {
      String analyzingLine = styleSheetLines[lineIndex];

      if (
        lineIndex - 1 >= 0 && lineIndex - 1 < styleSheetLines.length &&
        analyzingLine.endsWith('{') && !styleSheetLines[lineIndex - 1].endsWith('{')
      ) {
        styleSheetLines[lineIndex] = '\n${analyzingLine}';
      }
    }

    styleSheet = styleSheetLines.join('\n');

    return styleSheet;
  }

  static String adaptToMobile(String styleSheet) {
    List<String> oldLines = styleSheet.split('\n');
    List<String> newLines = [];

    for (int lineIndex = 0; lineIndex < oldLines.length; lineIndex++) {
      String analyzingLine = oldLines[lineIndex];

      newLines.add(analyzingLine);

      if (!analyzingLine.contains('"') && !analyzingLine.contains("'") && RegExp(r'-?\d+\.?\d*vw').hasMatch(analyzingLine)) {
        newLines.add(analyzingLine.replaceAll('vw', 'dvw'));
      }

      if (!analyzingLine.contains('"') && !analyzingLine.contains("'") && RegExp(r'-?\d+\.?\d*vh').hasMatch(analyzingLine)) {
        newLines.add(analyzingLine.replaceAll('vh', 'dvh'));
      }
    }

    styleSheet = newLines.join('\n');

    return styleSheet;
  }

  static String revertFromMobile(String styleSheet) {
    List<String> oldLines = styleSheet.split('\n');
    List<String> newLines = [];

    for (int lineIndex = 0; lineIndex < oldLines.length; lineIndex++) {
      String analyzingLine = oldLines[lineIndex];

      if (!analyzingLine.contains('"') && !analyzingLine.contains("'") && analyzingLine.contains('dvw')) {
        continue;
      }

      if (!analyzingLine.contains('"') && !analyzingLine.contains("'") && analyzingLine.contains('dvh')) {
        continue;
      }

      newLines.add(analyzingLine);
    }

    styleSheet = newLines.join('\n');

    return styleSheet;
  }

  static String indentationSpacing = '  ';
}

class Scanner {
  static List<String> listFilePathsRecursively(Directory rootDirectory) {
    List<String> filePaths = [];

    void navigateIntoDirectory(Directory subDirectory) {
      List<FileSystemEntity> systemEntities = subDirectory.listSync();

      for (FileSystemEntity systemEntity in systemEntities) {
        if (systemEntity is File) {
          filePaths.add(systemEntity.path);
        }

        if (systemEntity is Directory) {
          navigateIntoDirectory(systemEntity);
        }
      }
    }

    navigateIntoDirectory(rootDirectory);

    return filePaths;
  }
}


void main(List<String> args) {
  List<String> currentDirectoryFilePaths = Scanner.listFilePathsRecursively(Directory.current);

  for (String filePath in currentDirectoryFilePaths) {
    if (filePath.endsWith('.css') || filePath.endsWith('.scss')) {
      File styleSheetFile = File(filePath);
      String styleSheet = styleSheetFile.readAsStringSync();

      styleSheet = Cascader.minifyDirectives(styleSheet);
      styleSheet = Cascader.breakLines(styleSheet);
      styleSheet = Cascader.indentLines(styleSheet);
      styleSheet = Cascader.spaceLines(styleSheet);

      if (args.length > 0 && args[0] == 'convert') {
        styleSheet = Cascader.adaptToMobile(styleSheet);
      }

      if (args.length > 0 && args[0] == 'revert') {
        styleSheet = Cascader.revertFromMobile(styleSheet);
      }


      styleSheetFile.writeAsStringSync(styleSheet);
    }
  }

}

// fix template-areas