flutter build bundle


C:\flutter\bin\cache\dart-sdk\bin\dart.exe ^
  C:\flutter\bin\cache\dart-sdk\bin\snapshots\frontend_server.dart.snapshot ^
  --sdk-root C:\flutter\bin\cache\artifacts\engine\common\flutter_patched_sdk_product ^
  --target=flutter ^
  --aot ^
  --tfa ^
  -Ddart.vm.product=true ^
  --packages .packages ^
  --output-dill build\kernel_snapshot.dill ^
  --verbose ^
  --depfile build\kernel_snapshot.d ^
  package:streamberry_client/main.dart


wsl


../engine-binaries/arm/gen_snapshot_linux_x64_release \
  --deterministic \
  --snapshot_kind=app-aot-elf \
  --elf=build/flutter_assets/app.so \
  --strip \
  build/kernel_snapshot.dill


rsync -a --info=progress2 ./build/flutter_assets/ pi@raspberrypi:/home/pi/streamberry/


exit
