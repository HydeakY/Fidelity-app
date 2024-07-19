import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:logger/logger.dart';

var log = Logger(
  printer: PrettyPrinter(),
);

var session = SessionManager();

class Company {
  final int? id;
  final String? name;
  final String? socialReason;
  final String? address;
  final String? postalCode;
  final String? city;
  final String? mobilePhone;
  final String? phone;
  final String? website;
  final String? apeCode;
  final String? shareCapital;
  final String? siren;
  final String? siret;
  final String? intracommunityVat;
  final String? uuid;
  final String? image;
  final List? salesMethods;
  final List? paymentMethods;
  final String? transactionMerchantId;
  final bool? isOpen;

  Company(
      {this.socialReason,
      this.address,
      this.postalCode,
      this.city,
      this.mobilePhone,
      this.phone,
      this.website,
      this.apeCode,
      this.shareCapital,
      this.siren,
      this.siret,
      this.intracommunityVat,
      this.uuid,
      this.image,
      this.salesMethods,
      this.paymentMethods,
      this.id,
      this.name,
      this.transactionMerchantId,
      this.isOpen});
}

class CompanyRepository {

  Future<dynamic> fetchCompanyDetails() async {
    // String apiUrl = dotenv.get("ENVIRONMENT") == "PROD" ? dotenv.get("API_URL_PROD") : dotenv.get("API_URL_DEV");
    String apiUrl = "https://app-dev.staging.2s-pos.fr/api";
    final url = Uri.parse('$apiUrl/get-company-details');

    final token = await session.get('_csrf');
    final headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'};

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      Company company = Company();

      company = Company(
        id: data['id'],
        name: data['name'],
        socialReason: data['socialReason'],
        address: data['address'],
        city: data['city'],
        postalCode: data['postalCode'],
        mobilePhone: data['mobilePhone'],
        website: data['website'],
        apeCode: data['apeCode'],
        shareCapital: data['shareCapital'],
        siren: data['siren'],
        siret: data['siret'],
        intracommunityVat: data['intracommunityVat'],
        uuid: data['uuid'],
        image: data['image'],
        salesMethods: data['salesMethods'],
        transactionMerchantId: data['companySettings']['transactionMerchantId']
      );
      return company;
    } else {
      throw Exception('Failed to get Company');
    }
  }
}
