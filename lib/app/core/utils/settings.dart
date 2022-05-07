// Package imports:

// ? ini DEV
// const alteaURL = "https://dev-services.alteacare.com";
// const alteaSocketURL = "https://dev-socket.alteacare.com";
// const String thisWebUrl = "https://altea-dev.web.app/#";

// ? ini STAGING
// const alteaURL = "https://staging-services.alteacare.com";
// const alteaSocketURL = "https://staging-socket.alteacare.com";
// const String thisWebUrl = "https://altea-staging.web.app/#";

// ? ini PROD
const alteaURL = "https://services.alteacare.com";
const alteaSocketURL = "https://socket.alteacare.com";
const String thisWebUrl = "https://altea-prod.web.app/#";

const alteaURLAPIAPP = "https://apiapp.alteacare.com"; //untuk article /article

// STATUS PAYMENT
//baru  --> waiting for payment screen / payment screen
const newOrder = "NEW";
const processGP = "PROCESS_GP";
const waitingForPayment = "WAITING_FOR_PAYMENT";
//payment ok --> ketemu dokter
const paid = "PAID";
const meetSpecialist = "MEET_SPECIALIST";
const onGoing = "ON_GOING";
const waitingForMedicalResume = "WAITING_FOR_MEDICAL_RESUME";
const completed = "COMPLETED";
//nda jadi / batal --> canceled screen
const canceled = "CANCELED";
const canceledBySystem = "CANCELED_BY_SYSTEM";
const canceledByGP = "CANCELED_BY_GP";
const canceledByUser = "CANCELED_BY_USER";
const paymentExpired = "PAYMENT_EXPIRED";
const paymentFailed = "PAYMENT_FAILED";
const refunded = "REFUNDED";

String addCDNforLoadImage(String urlImage) {
  return "${urlImage.substring(0, 8)}cdn.statically.io/img/${urlImage.substring(8, urlImage.length)}";
}

const List<String> berandaRoutes = ["/home", "/promo"];

const List<String> dokterSpesialisRoutes = [
  "/doctor",
  "/doctor/doctor-spesialis",
  "/home/search-specialist",
  "/home/search-specialist/spesialis-konsultasi",
];

const List<String> konsultasiSayaRoutes = [
  "/my-consultation",
  "/consultation-detail",
  "/my-consultation-detail",
];

const String QUERY_CALL_MA = "CALL_MA";
const String QUERY_CALL_CONSULTATION = "CONSULTATION_CALL";
const String SOCKET_EVENT_CALL_MA_ANSWERED = "CALL_MA_ANSWERED";
const String SOCKET_EVENT_CALL_CONSULTATION_ANSWERED = "CONSULTATION_STARTED";
const String SOCKET_EVENT_ME = "ME";
const String SOCKET_EVENT_ERROR = "socket_error";
const String EXTRA_CALL_METHOD_SPECIALIST = "TransitionExtra.CallSpecialist";
const String EXTRA_CALL_METHOD_MA = "TransitionExtra.CallMA";
