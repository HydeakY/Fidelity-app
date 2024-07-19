import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

environement() {
  String env = "";
  if (dotenv.get("ENVIRONMENT") == "DEV") {
    env = "DEV";
  } else if (dotenv.get("ENVIRONMENT") == "PROD") {
    env = "PROD";
  } else {
    env = "PREPROD";
  }
  return env;
}

getApiUrl() {
  String env = "";

  if (dotenv.get("ENVIRONMENT") == "PROD") {

    env = dotenv.get("API_URL_PROD");
  } else if (dotenv.get("ENVIRONMENT") == "PREPROD") {
    env = dotenv.get("API_URL_PREPROD");
  } else {
    env = dotenv.get("API_URL_DEV");
  }
  return env;
}

getMercureUrl() {
  String env = "";
  if (dotenv.get("ENVIRONMENT") == "PROD") {
    env = dotenv.get("MERCURE_URL_PROD");
  } else if (dotenv.get("ENVIRONMENT") == "PREPROD") {
    env = dotenv.get("MERCURE_URL_PREPROD");
  } else {
    env = dotenv.get("MERCURE_URL_DEV");
  }
  return env;
}

getAppSyncEndpoint() {
  String env = "";
  if (dotenv.get("ENVIRONMENT") == "PROD") {
    env = dotenv.get("APP_SYNC_ENDPOINT_PROD");
  } else if (dotenv.get("ENVIRONMENT") == "PREPROD") {
    env = dotenv.get("APP_SYNC_ENDPOINT_PREPROD");
  } else {
    env = dotenv.get("APP_SYNC_ENDPOINT_DEV");
  }
  return env;
}

getAppSyncKey() {
  String env = "";
  if (dotenv.get("ENVIRONMENT") == "PROD") {
    env = dotenv.get("APP_SYNC_API_KEY_PROD");
  } else if (dotenv.get("ENVIRONMENT") == "PREPROD") {
    env = dotenv.get("APP_SYNC_API_KEY_PREPROD");
  } else {
    env = dotenv.get("APP_SYNC_API_KEY_DEV");
  }
  return env;
}

getAppSyncHost() {
  String env = "";
  if (dotenv.get("ENVIRONMENT") == "PROD") {
    env = dotenv.get("APP_SYNC_HOST_PROD");
  } else if (dotenv.get("ENVIRONMENT") == "PREPROD") {
    env = dotenv.get("APP_SYNC_HOST_PREPROD");
  } else {
    env = dotenv.get("APP_SYNC_HOST_DEV");
  }
  return env;
}