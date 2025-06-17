import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import '../models/test_model.dart';
import '../models/variant_model.dart';

class CreateVariantPage extends StatelessWidget {
  const CreateVariantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Variant yaratish"));
  }
}
