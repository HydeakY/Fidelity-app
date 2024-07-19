import 'package:flutter/material.dart';
import 'package:fidelity/model/company_details.dart';

class CompanyDetailsVM extends ChangeNotifier {

  Company? companyVM;

  CompanyRepository companyDetails = CompanyRepository();

  fetchCompanyDetailsVM() async {
    companyVM = await companyDetails.fetchCompanyDetails();
    log.d(companyVM!.image);
    notifyListeners();
  }
}