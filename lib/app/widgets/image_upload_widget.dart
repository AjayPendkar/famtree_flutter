import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../services/s3_service.dart';
import '../core/values/api_constants.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(String) onImageUploaded;
  final String? initialImageUrl;
  final double height;
  final double width;
  final bool isCircular;
  final IconData placeholderIcon;
  final double iconSize;
  
  const ImageUploadWidget({
    Key? key, 
    required this.onImageUploaded,
    this.initialImageUrl,
    this.height = 200,
    this.width = double.infinity,
    this.isCircular = false,
    this.placeholderIcon = Icons.add_photo_alternate,
    this.iconSize = 50,
  }) : super(key: key);

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _imageFile;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  final ImageUploadService _imageUploadService = Get.find<ImageUploadService>();

  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        
        print('Image selected: ${_imageFile!.path}');
        await _uploadImage();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error picking image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    
    setState(() {
      _isUploading = true;
    });
    
    try {
      print('Starting image upload for file: ${_imageFile!.path}');
      final response = await _imageUploadService.uploadImage(
        _imageFile!,
        category: 'PROFILE_PICTURE'
      );
      setState(() {
        _imageUrl = response.url;
      });
      widget.onImageUploaded(response.url);
      
      print('Image uploaded successfully: ${response.url}');
      
      Get.snackbar(
        'Success',
        'Image uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      print('❌ IMAGE UPLOAD WIDGET ERROR ❌');
      print('Error uploading image: $e');
      print('Stack trace: $stackTrace');
      
      String errorMessage = e.toString();
      if (errorMessage.contains('Authentication token not found')) {
        errorMessage = 'Authentication error. Please log in again.';
      } else if (errorMessage.contains('Failed to upload image')) {
        errorMessage = 'Failed to upload image. Please try again.';
      } else if (errorMessage.length > 100) {
        errorMessage = '${errorMessage.substring(0, 100)}...';
      }
      
      Get.snackbar(
        'Error',
        'Error uploading image: $errorMessage',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        isDismissible: true,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Widget _buildImageDisplay() {
    if (_imageFile != null) {
      // Show local image file
      return widget.isCircular
          ? CircleAvatar(
              radius: widget.width / 2,
              backgroundImage: FileImage(_imageFile!),
              onBackgroundImageError: (e, stackTrace) {
                print('Error loading local image: $e');
                return;
              },
            )
          : Image.file(
              _imageFile!,
              height: widget.height,
              width: widget.width,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading local image: $error');
                return _buildPlaceholder();
              },
            );
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      // Show network image
      return widget.isCircular
          ? CircleAvatar(
              radius: widget.width / 2,
              backgroundImage: NetworkImage(_imageUrl!),
              onBackgroundImageError: (e, stackTrace) {
                print('Error loading network image: $e');
                return;
              },
              child: _handleCircularImageError(),
            )
          : Image.network(
              _imageUrl!,
              height: widget.height,
              width: widget.width,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
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
                print('Error loading network image: $error');
                return _buildPlaceholder();
              },
            );
    } else {
      // Show placeholder
      return _buildPlaceholder();
    }
  }

  Widget _handleCircularImageError() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.placeholderIcon,
        size: widget.iconSize,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return widget.isCircular
        ? CircleAvatar(
            radius: widget.width / 2,
            backgroundColor: Colors.grey[200],
            child: Icon(
              widget.placeholderIcon,
              size: widget.iconSize,
              color: Colors.grey[600],
            ),
          )
        : Container(
            height: widget.height,
            width: widget.width,
            color: Colors.grey[200],
            child: Icon(
              widget.placeholderIcon,
              size: widget.iconSize,
              color: Colors.grey[600],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showImageSourceDialog(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildImageDisplay(),
              if (_isUploading)
                Container(
                  height: widget.height,
                  width: widget.width,
                  color: Colors.black54,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImageSourceDialog() {
    if (_isUploading) return;
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_imageUrl != null || _imageFile != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Image', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  setState(() {
                    _imageFile = null;
                    _imageUrl = null;
                  });
                  widget.onImageUploaded('');
                },
              ),
          ],
        ),
      ),
    );
  }
} 