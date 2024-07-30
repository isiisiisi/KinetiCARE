import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kineticare/components/patient_components/patient_appbar.dart';

class OnboardingScreens extends StatefulWidget {
  final Function(String?) onFileUploaded;

  const OnboardingScreens({super.key, required this.onFileUploaded});

  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  String? _uploadedFileUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: UploadScreen(
              onFileUploaded: (String? url) {
                setState(() {
                  _uploadedFileUrl = url;
                });
              },
              onNextPressed: () {
                if (_uploadedFileUrl != null) {
                  //Navigator.pushReplacementNamed(context, '/TherapistInformation');
                    widget.onFileUploaded(_uploadedFileUrl);
                } else {
                  // Safely show SnackBar after the current frame
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please upload a file before proceeding.'),
                      ),
                    );
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class UploadScreen extends StatefulWidget {
  final Function(String?) onFileUploaded;
  final VoidCallback onNextPressed;

  const UploadScreen({
    super.key,
    required this.onFileUploaded,
    required this.onNextPressed,
  });

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _fileName;
  String? _filePreviewUrl;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instanceFor(
    bucket: 'gs://kineticare-7cf80.appspot.com',
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const  Center(
            child: Text(
              'Upload PT Referral Letter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Before starting, you need to upload your PT Referral Letter. This is necessary in order for you to communicate with your therapist. If you choose to skip this, you can still upload the letter in your profile.',
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _showPicker,
            child: DashedBorder(
              child: SizedBox(
                height: 150,
                child: _filePreviewUrl != null
                    ? Image.network(
                        _filePreviewUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, size: 48, color: Colors.red),
                              SizedBox(height: 8),
                              Text('Failed to load image',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          );
                        },
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Choose file',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
          ),
          if (_fileName != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.description, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(child: Text(_fileName!)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearFile,
                ),
              ],
            ),
          ],
          const Spacer(),
          ElevatedButton(
            onPressed: _isUploading ? null : widget.onNextPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: const Color(0xFF5A8DEE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isUploading
                ? const CircularProgressIndicator()
                : const Text('Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                )),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _isUploading ? null : _showPicker,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Color(0xFF5A8DEE), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Change Letter',
            style: TextStyle(
              color: Color(0xFF5A8DEE),
              fontSize: 16,
              fontWeight: FontWeight.w500
            )),
          ),
        ],
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
          _fileName = pickedFile.name;
        });

        try {
          final ref = storage.ref('uploads/$_fileName');

          if (kIsWeb) {
            // For web
            await ref.putData(await pickedFile.readAsBytes());
          } else {
            // For mobile
            await ref.putFile(File(pickedFile.path));
          }

          final downloadUrl = await ref.getDownloadURL();

          setState(() {
            _filePreviewUrl = downloadUrl;
            _isUploading = false;
          });

          widget.onFileUploaded(downloadUrl);
        } catch (e) {
          // Handle any errors during upload
          setState(() {
            _isUploading = false;
          });
          print('Error uploading file: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking file: $e');
      }
    }
  }

  void _clearFile() {
    setState(() {
      _fileName = null;
      _filePreviewUrl = null;
    });
  }
}

class DashedBorder extends StatelessWidget {
  final Widget child;
  const DashedBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      canvas.drawLine(Offset(startX, size.height),
          Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      canvas.drawLine(Offset(size.width, startY),
          Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
