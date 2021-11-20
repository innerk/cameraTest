import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CamaraPrueba extends StatefulWidget {
  CamaraPrueba({Key? key}) : super(key: key);

  @override
  _CamaraPruebaState createState() => _CamaraPruebaState();
}

class _CamaraPruebaState extends State<CamaraPrueba> {
  CameraController? controladorCam;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    if (controladorCam != null) {
      if (!controladorCam!.value.isInitialized) {
        return Container(
          child: Text(
            "no contorller",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!controladorCam!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black38,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(),
          Positioned(
            top: 40.0,
            left: 12.0,
            child: IconButton(
              iconSize: 28.0,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 40.0,
            right: 12.0,
            child: IconButton(
              iconSize: 28.0,
              icon: Icon(
                Icons.switch_camera,
                color: Colors.white,
              ),
              onPressed: () {
                /* _onCameraSwitch(); */
              },
            ),
          ),
          /*  _mostrando
              ? Positioned(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  top: 100.0,
                  /*  left: 20.0,
            right: 20.0, */
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        /* border:Border.all(color: Colors.red,width: 1), */ borderRadius:
                            BorderRadius.all(Radius.circular(4.0))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                            child: Text(
                          "¿Es esta tu planta?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        )),
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(10.0),
                          /* height: 250.0, */
                          child: Stack(
                            children: stackChildren,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () {},
                                child: Text("asdas"),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () {},
                                child: Text("asdas"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ) 
              : Text("")*/
        ],
      ),
      bottomNavigationBar: _botonesBottom(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iniciarCamara();
  }

  Widget _buildCameraPreview() {
    print(controladorCam);
    /* final size = MediaQuery.of(context).size; */
    return ClipRect(
      child: CameraPreview(controladorCam!),
    );
  }

  Widget _botonesBottom() {
    return Container(
      color: Colors.transparent,
      height: 100.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28.0,
            child: IconButton(
                icon: Icon(
                  Icons.photo,
                  size: 28.0,
                  color: Colors.black,
                ),
                onPressed: _elegirImagen),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28.0,
            child: IconButton(
              icon: Icon(
                Icons.camera,
                size: 28.0,
                color: Colors.black,
              ),
              onPressed: () {
                print("asdsas caputara");
                /*   _capturarImage(); */
                controladorCam!.takePicture();
              },
            ),
          ),
        ],
      ),
    );
  }

  iniciarCamara() async {
    var _camaras = await availableCameras();
    print(_camaras);
    controladorCam = CameraController(_camaras[0], ResolutionPreset.high);
    var activar = controladorCam!.initialize();

    activar.then((value) {
      setState(() {});
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (controladorCam == null || !controladorCam!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controladorCam?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controladorCam != null) {
        print(state);
        print(state);
        onNewCameraSelected(controladorCam!.description);
      }
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controladorCam != null) {
      await controladorCam!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  _elegirImagen() async {
    /* Navigator.of(context).pop(); */

    var imagen = await _picker.getImage(source: ImageSource.gallery);
    print('imagen picker : $imagen');
    if (imagen != null) {
      /* recortarImagen(imagen); */
    } else {
      return;
    }
  }
}
