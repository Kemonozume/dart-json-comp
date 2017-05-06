# dart-json-comp

Comparing json_god, json_conv and dartson. 

To run the benchmark use

`dart bin/main.dart`

example output: 
```
λ dart bin\main.dart
starting benchmark
benching Encoding:
json_conv  took: 5764
json_god took: 11850
dartson took: 35562
benching Decoding:
JSON.decode took: 725
json_conv decode took: 2112
json_conv decodeObj took: 2390
json_god took: 4245
dartson took: 18179
```

### Disclaimer

Benchmark is in no way scientifc. Mostly used to find hot paths in json_conv. 

To use it to find slow parts use the Dart Observatory like this: 

`dart -c --enable-vm-service --pause-isolates-on-start --pause-isolates-on-exit bin\main.dart`