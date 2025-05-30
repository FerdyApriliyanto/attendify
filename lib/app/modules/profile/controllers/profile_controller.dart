import 'package:attendify/app/utils/color_list.dart';
import 'package:attendify/app/utils/modern_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProfileController extends GetxController {
  // RECAP DATA FUNCTIONS

  Future<void> pickDateAndGeneratePDF(BuildContext context) async {
    showMonthPicker(
      context,
      onSelected: (month, year) async {
        final data = await fetchMonthlyAttendance(month, year);
        if (data.isNotEmpty) {
          generatePDF(data, month, year);
        } else {
          ModernSnackbar.showModernSnackbar(
            title: 'No recap data found',
            message: 'No attendance data found in that time',
            backgroundColor: ColorList.dangerColor,
            icon: Icons.error,
          );
        }
      },
      initialSelectedMonth: DateTime.now().month,
      initialSelectedYear: DateTime.now().year,
      firstYear: 2015,
      lastYear: 2025,
      lastEnabledMonth: DateTime.now().month,
      selectButtonText: 'OK',
      cancelButtonText: 'Cancel',
      highlightColor: ColorList.primaryColor,
      textColor: Colors.black,
      contentBackgroundColor: Colors.white,
      dialogBackgroundColor: Colors.grey[200],
    );
  }

  Future<List<Map<String, dynamic>>> fetchMonthlyAttendance(
    int month,
    int year,
  ) async {
    List<Map<String, dynamic>> allData = [];

    final checkinSnapshot =
        await FirebaseFirestore.instance.collectionGroup('checkin').get();
    final checkoutSnapshot =
        await FirebaseFirestore.instance.collectionGroup('checkout').get();

    Map<String, Map<String, dynamic>> tempData = {};

    for (var doc in checkinSnapshot.docs) {
      final data = doc.data();
      if (data['time'] == null || data['name'] == null) continue;

      final dateTime = DateTime.parse(data['time']);
      if (dateTime.month != month || dateTime.year != year) continue;

      final key =
          '${data['name']}_${DateFormat('yyyy-MM-dd').format(dateTime)}';
      tempData[key] = {
        'name': data['name'],
        'date': DateFormat('yyyy-MM-dd').format(dateTime),
        'checkIn': DateFormat('HH:mm').format(dateTime),
        'status': data['status'] ?? '-',
        'checkOut': '-',
      };
    }

    for (var doc in checkoutSnapshot.docs) {
      final data = doc.data();
      if (data['time'] == null || data['name'] == null) continue;

      final dateTime = DateTime.parse(data['time']);
      if (dateTime.month != month || dateTime.year != year) continue;

      final key =
          '${data['name']}_${DateFormat('yyyy-MM-dd').format(dateTime)}';
      if (tempData.containsKey(key)) {
        tempData[key]!['checkOut'] = DateFormat('HH:mm').format(dateTime);
      } else {
        tempData[key] = {
          'name': data['name'],
          'date': DateFormat('yyyy-MM-dd').format(dateTime),
          'checkIn': '-',
          'checkOut': '-',
          'status': '-',
        };
      }
    }

    allData = tempData.values.toList();

    return allData;
  }

  Future<void> generatePDF(
    List<Map<String, dynamic>> data,
    int month,
    int year,
  ) async {
    final pdf = pw.Document();
    final monthName = DateFormat('MMMM').format(DateTime(year, month));

    final Map<int, List<Map<String, dynamic>>> groupedByWeek = {};

    for (var entry in data) {
      final date = DateTime.parse(entry['date']);
      if (date.month == month && date.year == year) {
        final weekNumber = ((date.day - 1) ~/ 7) + 1;
        groupedByWeek.putIfAbsent(weekNumber, () => []).add(entry);
      }
    }

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Attendance Recap - $monthName $year",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                ...groupedByWeek.entries.map((weekEntry) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Week - ${weekEntry.key}",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.TableHelper.fromTextArray(
                        context: context,
                        headers: [
                          'Name',
                          'Date',
                          'Check In',
                          'Check Out',
                          'Status',
                        ],
                        data:
                            weekEntry.value.map((e) {
                              return [
                                e['name'] ?? '-',
                                e['date'] ?? '-',
                                e['checkIn'] ?? '-',
                                e['checkOut'] ?? '-',
                                e['status'] ?? '-',
                              ];
                            }).toList(),
                        columnWidths: {
                          0: pw.FlexColumnWidth(2),
                          1: pw.FlexColumnWidth(1.3),
                          2: pw.FlexColumnWidth(1),
                          3: pw.FlexColumnWidth(1.2),
                          4: pw.FlexColumnWidth(1.2),
                        },
                      ),
                      pw.SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // END OF RECAP DATA FUNCTIONS
  }
}
