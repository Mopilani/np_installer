// import 'dart:ffi';

// import 'package:ffi/ffi.dart';
// import 'package:win32/win32.dart';

// void main() {
//   Volumes();
// }

// final volumeHandles = <int, String>{};

// class Volume {
//   final String deviceName;
//   final String volumeName;
//   final List<String> paths;

//   const Volume(this.deviceName, this.volumeName, this.paths);
// }

// Volumes() {
//   var error = 0;
//   final volumeNamePtr = wsalloc(MAX_PATH);

//   final hFindVolume = FindFirstVolume(volumeNamePtr, MAX_PATH);
//   if (hFindVolume == INVALID_HANDLE_VALUE) {
//     error = GetLastError();
//     throw Exception('FindFirstVolume failed with error code $error');
//   }

//   while (true) {
//     final volumeName = volumeNamePtr.toDartString();

//     //  Skip the \\?\ prefix and remove the trailing backslash.
//     final shortVolumeName = volumeName.substring(4, volumeName.length - 1);
//     final shortVolumeNamePtr = shortVolumeName.toNativeUtf16();

//     final deviceName = wsalloc(MAX_PATH);
//     final charCount = QueryDosDevice(shortVolumeNamePtr, deviceName, MAX_PATH);

//     if (charCount == 0) {
//       error = GetLastError();
//       throw Exception('QueryDosDevice failed with error code $error');
//     }

//     _volumes.add(Volume(
//         deviceName.toDartString(), volumeName, getVolumePaths(volumeName)));

//     final success = FindNextVolume(hFindVolume, volumeNamePtr, MAX_PATH);
//     if (success == FALSE) {
//       error = GetLastError();
//       if (error != ERROR_NO_MORE_FILES && error != ERROR_SUCCESS) {
//         print('FindNextVolume failed with error code $error');
//         break;
//       } else {
//         break;
//       }
//     }
//     free(shortVolumeNamePtr);
//   }
//   free(volumeNamePtr);
//   FindVolumeClose(hFindVolume);
// }


// class Volumes {
//   final _volumes = <Volume>[];

//   List<Volume> getVolumes() => _volumes;

//   List<String> getVolumePaths(String volumeName) {
//     final paths = <String>[];

//     // Could be arbitrarily long, but 4*MAX_PATH is a reasonable default.
//     // More sophisticated solutions can be found online
//     final pathNamePtr = wsalloc(MAX_PATH * 4);
//     final charCount = calloc<DWORD>();
//     final volumeNamePtr = volumeName.toNativeUtf16();

//     try {
//       charCount.value = MAX_PATH;
//       final success = GetVolumePathNamesForVolumeName(
//           volumeNamePtr, pathNamePtr, charCount.value, charCount);

//       if (success != FALSE) {
//         if (charCount.value > 1) {
//           for (final path in pathNamePtr.unpackStringArray(charCount.value)) {
//             paths.add(path);
//           }
//         }
//       } else {
//         final error = GetLastError();
//         throw Exception(
//             'GetVolumePathNamesForVolumeName failed with error code $error');
//       }
//       return paths;
//     } finally {
//       free(pathNamePtr);
//       free(charCount);
//     }
//   }

//   Volumes() {
//     var error = 0;
//     final volumeNamePtr = wsalloc(MAX_PATH);

//     final hFindVolume = FindFirstVolume(volumeNamePtr, MAX_PATH);
//     if (hFindVolume == INVALID_HANDLE_VALUE) {
//       error = GetLastError();
//       throw Exception('FindFirstVolume failed with error code $error');
//     }

//     while (true) {
//       final volumeName = volumeNamePtr.toDartString();

//       //  Skip the \\?\ prefix and remove the trailing backslash.
//       final shortVolumeName = volumeName.substring(4, volumeName.length - 1);
//       final shortVolumeNamePtr = shortVolumeName.toNativeUtf16();

//       final deviceName = wsalloc(MAX_PATH);
//       final charCount =
//           QueryDosDevice(shortVolumeNamePtr, deviceName, MAX_PATH);

//       if (charCount == 0) {
//         error = GetLastError();
//         throw Exception('QueryDosDevice failed with error code $error');
//       }

//       _volumes.add(Volume(
//           deviceName.toDartString(), volumeName, getVolumePaths(volumeName)));

//       final success = FindNextVolume(hFindVolume, volumeNamePtr, MAX_PATH);
//       if (success == FALSE) {
//         error = GetLastError();
//         if (error != ERROR_NO_MORE_FILES && error != ERROR_SUCCESS) {
//           print('FindNextVolume failed with error code $error');
//           break;
//         } else {
//           break;
//         }
//       }
//       free(shortVolumeNamePtr);
//     }
//     free(volumeNamePtr);
//     FindVolumeClose(hFindVolume);
//   }
// }


// bool GetDriveGeometry(Pointer<Utf16> wszPath, Pointer<DISK_GEOMETRY> pdg) {
//   final bytesReturned = calloc<Uint32>();

//   try {
//     final hDevice = CreateFile(
//         wszPath, // drive to open
//         0, // no access to the drive
//         FILE_SHARE_READ | FILE_SHARE_WRITE,
//         nullptr, // default security attributes
//         OPEN_EXISTING,
//         0, // file attributes
//         NULL); // do not copy file attributes

//     if (hDevice == INVALID_HANDLE_VALUE) // cannot open the drive
//     {
//       return false;
//     }

//     final bResult = DeviceIoControl(
//         hDevice, // device to be queried
//         IOCTL_DISK_GET_DRIVE_GEOMETRY, // operation to perform
//         nullptr,
//         0, // no input buffer
//         pdg,
//         sizeOf<DISK_GEOMETRY>(), // output buffer
//         bytesReturned, // # bytes returned
//         nullptr); // synchronous I/O

//     CloseHandle(hDevice);

//     return bResult == TRUE;
//   } finally {
//     free(bytesReturned);
//   }
// }

// void getDisksInfos() {
//   final wszDrive = r"\\.\PhysicalDrive0".toNativeUtf16();
//   final pdg = calloc<DISK_GEOMETRY>();

//   try {
//     final bResult = GetDriveGeometry(wszDrive, pdg);

//     if (bResult) {
//       print('Drive path      = ${wszDrive.toDartString()}');
//       print('Cylinders       = ${pdg.ref.Cylinders}');
//       print('Tracks/cylinder = ${pdg.ref.TracksPerCylinder}');
//       print('Sectors/track   = ${pdg.ref.SectorsPerTrack}');
//       print('Bytes/sector    = ${pdg.ref.BytesPerSector}');

//       final DiskSize = pdg.ref.Cylinders *
//           pdg.ref.TracksPerCylinder *
//           pdg.ref.SectorsPerTrack *
//           pdg.ref.BytesPerSector;
//       print('Disk size       = $DiskSize (Bytes)\n'
//           '                = ${DiskSize / (1024 * 1024 * 1024).toInt()} (Gb)');
//     } else {
//       print('GetDriveGeometry failed.');
//     }
//   } finally {
//     free(wszDrive);
//     free(pdg);
//   }
// }
