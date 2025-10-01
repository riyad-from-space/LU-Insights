enum AppRole {
  student,
  transportationAdmin,
  clubAdmin,
  materialsUploader,
}

String appRoleToString(AppRole role) {
  switch (role) {
    case AppRole.student:
      return 'student';
    case AppRole.transportationAdmin:
      return 'transportation_admin';
    case AppRole.clubAdmin:
      return 'club_admin';
    case AppRole.materialsUploader:
      return 'materials_uploader';
  }
}

AppRole appRoleFromString(String role) {
  switch (role) {
    case 'student':
      return AppRole.student;
    case 'transportation_admin':
      return AppRole.transportationAdmin;
    case 'club_admin':
      return AppRole.clubAdmin;
    case 'materials_uploader':
      return AppRole.materialsUploader;
    default:
      return AppRole.student;
  }
}
