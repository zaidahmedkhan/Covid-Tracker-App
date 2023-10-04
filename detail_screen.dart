import 'package:covid_tracker/Services/pdf_services.dart';
import 'package:covid_tracker/view/world_stats.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DetailScreen extends StatefulWidget {
  String name;
  String image;
  int totalCases,
      todayCases,
      totalDeath,
      todayDeath,
      totalRecovered,
      active,
      critical,
      todayRecovered,
      test;

  DetailScreen(
      {required this.name,
      required this.image,
      required this.totalCases,
      required this.todayCases,
      required this.totalDeath,
      required this.todayDeath,
      required this.totalRecovered,
      required this.active,
      required this.critical,
      required this.todayRecovered,
      required this.test});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.name,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .070),
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .06,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "COVID-19 Statistics",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ReusableRow(
                          title: 'Cases', value: widget.totalCases.toString()),
                      ReusableRow(
                          title: 'Today Cases',
                          value: widget.todayCases.toString()),
                      ReusableRow(
                          title: 'Recovered',
                          value: widget.totalRecovered.toString()),
                      ReusableRow(
                          title: 'Today Recovered',
                          value: widget.todayRecovered.toString()),
                      ReusableRow(
                          title: 'Deaths', value: widget.totalDeath.toString()),
                      ReusableRow(
                          title: 'Today Deaths',
                          value: widget.todayDeath.toString()),
                      ReusableRow(
                          title: 'Critical', value: widget.critical.toString()),
                    ],
                  ),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.image),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              _createPDF();
            },
            child: Container(
              height: 50,
              width: 280,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(15)),
              child: const Center(
                child: Text(
                  "Generate PDF",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _createPDF() async {
    final PdfDocument document = PdfDocument();
    final page = document.pages.add();
    final PdfGraphics graphics = page.graphics;

    // Add Heading "COVID-19 STATISTICS"
    final PdfFont headingFont = PdfStandardFont(PdfFontFamily.helvetica, 18);
    final String heading = "COVID-19 STATISTICS";
    final Size headingSize = headingFont.measureString(heading);
    final double headingX = (page.size.width - headingSize.width) / 2;
    graphics.drawString(heading, headingFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds:
            Rect.fromLTWH(headingX, 10, headingSize.width, headingSize.height));

    // Country Name
    final PdfFont countryNameFont =
        PdfStandardFont(PdfFontFamily.helvetica, 16);
    final String countryName = widget.name;
    final Size countryNameSize = countryNameFont.measureString(countryName);
    final double countryNameX = (page.size.width - countryNameSize.width) / 2;
    final double countryNameY =
        headingSize.height + 20; // Adjust the Y position
    graphics.drawString(countryName, countryNameFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(countryNameX, countryNameY, countryNameSize.width,
            countryNameSize.height));

    // Current Date and Time
    final PdfFont dateTimeFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final String currentDateTime = DateTime.now().toString();
    final Size dateTimeSize = dateTimeFont.measureString(currentDateTime);
    final double dateTimeX = (page.size.width - dateTimeSize.width) / 2;
    final double dateTimeY =
        countryNameY + countryNameSize.height + 5; // Adjust the Y position
    graphics.drawString(currentDateTime, dateTimeFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(
            dateTimeX, dateTimeY, dateTimeSize.width, dateTimeSize.height));

    // Define the table structure with 2 columns
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);
    final PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = 'Description';
    header.cells[1].value = 'Details';

    // Add data rows to the table
    final List<String> descriptions = [
      'Cases',
      'Today Cases',
      'Recovered',
      'Today Recovered',
      'Deaths',
      'Today Deaths',
      'Critical',
    ];
    final List<String> details = [
      widget.totalCases.toString(),
      widget.todayCases.toString(),
      widget.totalRecovered.toString(),
      widget.todayRecovered.toString(),
      widget.totalDeath.toString(),
      widget.todayDeath.toString(),
      widget.critical.toString(),
    ];
    for (int i = 0; i < descriptions.length; i++) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = descriptions[i];
      row.cells[1].value = details[i];
    }

    // Format the table
    grid.style.cellPadding = PdfPaddings(left: 5);
    grid.style.cellSpacing = 1;
    grid.style.backgroundBrush = PdfSolidBrush(PdfColor(235, 235, 235));

    // Draw the table on the page
    final bounds = Rect.fromPoints(
        Offset(10, dateTimeY + dateTimeSize.height + 20),
        Offset(page.size.width - 10, page.size.height - 50));
    grid.draw(
      page: page,
      bounds: bounds,
      format: PdfLayoutFormat(
        layoutType: PdfLayoutType.paginate,
      ),
    );

    // Save and open the PDF file
    final List<int> bytes = await document.save();
    document.dispose();
    saveAndLaunchFile(bytes, 'Output.pdf');
  }
}
