class AttendanceData {
  static final AttendanceData _instance = AttendanceData._internal();

  factory AttendanceData() {
    return _instance;
  }

  AttendanceData._internal();

  List<Map<String, dynamic>> attendanceRecords = [];

  void addRecord(String date, String checkIn, String checkOut) {
    attendanceRecords.add({
      'date': date,
      'checkIn': checkIn,
      'checkOut': checkOut,
    });
  }
}
