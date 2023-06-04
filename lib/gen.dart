import 'dart:io';

void main(List<String> args) async {
  var sink = File('${Directory.current.path}/space.dart').openWrite();
  if (args.isEmpty || int.tryParse(args.first) == null) {
    print('''You must have to pass a number to as a first argument
         to defign the space you want, the number is multiplied with 5
        try figure out it, you number of spaces * 5, 1000 * 5 = 5000''');
    exit(0);
  }
  sink.write('var space = "${'Space' * int.parse(args.first)}";');
}
