import 'package:permission_handler/permission_handler.dart';
class AllPermissions{
  static Future<PermissionStatus> getContactPermission() async{
      final permission = await Permission.contacts.status;

      if(permission != PermissionStatus.granted && 
      permission != PermissionStatus.permanentlyDenied){
        final newPermission = await Permission.contacts.request();
        return newPermission;
      }
      else{
        return permission;
      }
  }

static Future<PermissionStatus> getLocationPermission() async{
      final permission = await Permission.location.status;

      if(permission != PermissionStatus.granted && 
      permission != PermissionStatus.permanentlyDenied){
        final newPermission = await Permission.location.request();
        return newPermission;
      }
      else{
        return permission;
      }
  }

    static Future<PermissionStatus> getSmsPermission() async{
      final permission = await Permission.sms.status;

      if(permission != PermissionStatus.granted && 
      permission != PermissionStatus.permanentlyDenied){
        final newPermission = await Permission.sms.request();
        return newPermission;
      }
      else{
        return permission;
      }
  }
  
}
