class MusicFinderService{
  MusicFinderService._();

  // Future<void> _getAudioFiles()async {
  //   const _methodChannel = MethodChannel(Constants.audioFilesChannel);
  //   final _permissionStatus = await Permission.storage.status;
  //   bool _isGranted = _permissionStatus.isGranted;
  //   if(_permissionStatus.isDenied){
  //     _isGranted = await Permission.storage.request().isGranted;
  //   }
  //   if(!_isGranted){
  //     _showMyDialog();
  //     return;
  //   }
  //   final _result = await _methodChannel.invokeMethod(Constants.methodQueryAudioFiles);
  //   if (_result != null){
  //
  //     print((_result as List).first);
  //   }
  //   return;
  // }


}