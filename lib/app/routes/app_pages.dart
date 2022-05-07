import 'package:altea/app/modules/introductions/introduction_screen.dart';
import 'package:altea/app/modules/patient_list/bindings/patient_list_binding.dart';
import 'package:altea/app/modules/patient_list/views/patient_list_view.dart';
import 'package:get/get.dart';

import 'package:altea/app/middleware/auth_middleware.dart';
import 'package:altea/app/middleware/doctor_id_checker_middleware.dart';
import 'package:altea/app/middleware/order_id_checker_middleware.dart';
import 'package:altea/app/modules/add_patient/bindings/add_patient_binding.dart';
import 'package:altea/app/modules/add_patient/views/add_patient_view.dart';
import 'package:altea/app/modules/add_patient_address/bindings/add_patient_address_binding.dart';
import 'package:altea/app/modules/add_patient_address/views/add_patient_address_view.dart';
import 'package:altea/app/modules/add_patient_confirmed/bindings/add_patient_confirmed_binding.dart';
import 'package:altea/app/modules/add_patient_confirmed/views/add_patient_confirmed_view.dart';
import 'package:altea/app/modules/article/bindings/article_binding.dart';
import 'package:altea/app/modules/article/views/article_view.dart';
import 'package:altea/app/modules/article_by_tag/bindings/article_by_tag_binding.dart';
import 'package:altea/app/modules/article_by_tag/views/article_by_tag_view.dart';
import 'package:altea/app/modules/article_detail/bindings/article_detail_binding.dart';
import 'package:altea/app/modules/article_detail/views/article_detail_view.dart';
import 'package:altea/app/modules/call_screen/bindings/call_screen_binding.dart';
import 'package:altea/app/modules/call_screen/views/call_screen_view.dart';
import 'package:altea/app/modules/call_screen/views/desktop_landing_call_screen_view.dart';
import 'package:altea/app/modules/call_screen/views/desktop_web_view/loading_screen_call.dart';
import 'package:altea/app/modules/call_screen/views/mobile_landing_call_screen_view.dart';
import 'package:altea/app/modules/choose_payment/bindings/choose_payment_binding.dart';
import 'package:altea/app/modules/choose_payment/views/choose_payment_view.dart';
import 'package:altea/app/modules/doctor-success-screen/bindings/doctor_success_screen_binding.dart';
import 'package:altea/app/modules/doctor-success-screen/views/doctor_success_screen_view.dart';
import 'package:altea/app/modules/doctor/bindings/doctor_binding.dart';
import 'package:altea/app/modules/doctor/views/doctor_view.dart';
import 'package:altea/app/modules/doctor_spesialis/bindings/doctor_spesialis_binding.dart';
import 'package:altea/app/modules/doctor_spesialis/views/doctor_spesialis_view.dart';
import 'package:altea/app/modules/error_404/views/error_404_view.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/bindings/forgot_new_binding.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/bindings/forgot_password_binding.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/bindings/forgot_verification_binding.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/views/forgot_new_view.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/views/forgot_password_view.dart';
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/views/forgot_verification_view.dart';
import 'package:altea/app/modules/home/bindings/home_binding.dart';
import 'package:altea/app/modules/home/views/home_view.dart';
import 'package:altea/app/modules/my_consultation/bindings/my_consultation_binding.dart';
import 'package:altea/app/modules/my_consultation/views/my_consultation_view.dart';
import 'package:altea/app/modules/my_consultation_detail/bindings/my_consultation_detail_binding.dart';
import 'package:altea/app/modules/my_consultation_detail/views/my_consultation_detail_view.dart';
import 'package:altea/app/modules/my_profile/bindings/my_profile_binding.dart';
import 'package:altea/app/modules/my_profile/views/my_profile_view.dart';
import 'package:altea/app/modules/notifications/bindings/notifications_binding.dart';
import 'package:altea/app/modules/notifications/views/notifications_view.dart';
import 'package:altea/app/modules/on_boarding/bindings/on_boarding_binding.dart';
import 'package:altea/app/modules/on_boarding/views/on_boarding_view.dart';
import 'package:altea/app/modules/onboard_call/bindings/onboard_call_binding.dart';
import 'package:altea/app/modules/onboard_call/views/onboard_call_view.dart';
import 'package:altea/app/modules/onboard_end_call/bindings/onboard_end_call_binding.dart';
import 'package:altea/app/modules/onboard_end_call/views/onboard_end_call_view.dart';
import 'package:altea/app/modules/patient-type/bindings/patient_type_binding.dart';
import 'package:altea/app/modules/patient-type/views/patient_type_view.dart';
import 'package:altea/app/modules/patient_address/bindings/patient_address_binding.dart';
import 'package:altea/app/modules/patient_address/views/patient_address_view.dart';
import 'package:altea/app/modules/patient_confirmation/bindings/patient_confirmation_binding.dart';
import 'package:altea/app/modules/patient_confirmation/patient_confirmation_view.dart';
import 'package:altea/app/modules/patient_data/bindings/patient_data_binding.dart';
import 'package:altea/app/modules/patient_data/views/patient_data_view.dart';
import 'package:altea/app/modules/payment-guide/bindings/payment_guide_binding.dart';
import 'package:altea/app/modules/payment-guide/views/payment_guide_view.dart';
import 'package:altea/app/modules/payment_confirmation/bindings/payment_confirmation_binding.dart';
import 'package:altea/app/modules/payment_confirmation/views/payment_confirmation_view.dart';
import 'package:altea/app/modules/pharmacy_information/bindings/pharmacy_information_binding.dart';
import 'package:altea/app/modules/pharmacy_information/views/pharmacy_information_view.dart';
import 'package:altea/app/modules/profile-edit-detail/bindings/profile_edit_detail_binding.dart';
import 'package:altea/app/modules/profile-edit-detail/views/profile_edit_detail_view.dart';
import 'package:altea/app/modules/profile-privacy/bindings/profile_privacy_binding.dart';
import 'package:altea/app/modules/profile-privacy/views/profile_privacy_view.dart';
import 'package:altea/app/modules/profile-tnc/bindings/profile_tnc_binding.dart';
import 'package:altea/app/modules/profile-tnc/views/profile_tnc_view.dart';
import 'package:altea/app/modules/profile_contact/bindings/profile_contact_binding.dart';
import 'package:altea/app/modules/profile_contact/views/profile_contact_view.dart';
import 'package:altea/app/modules/profile_edit/bindings/profile_edit_binding.dart';
import 'package:altea/app/modules/profile_edit/views/profile_edit_view.dart';
import 'package:altea/app/modules/profile_faq/bindings/profile_faq_binding.dart';
import 'package:altea/app/modules/profile_faq/views/profile_faq_view.dart';
import 'package:altea/app/modules/profile_settings/bindings/profile_settings_binding.dart';
import 'package:altea/app/modules/profile_settings/views/profile_settings_view.dart';
import 'package:altea/app/modules/promo/bindings/promo_binding.dart';
import 'package:altea/app/modules/promo/views/promo_view.dart';
import 'package:altea/app/modules/reconnect-call-view/bindings/reconnect_call_view_binding.dart';
import 'package:altea/app/modules/reconnect-call-view/views/reconnect_call_view_view.dart';
import 'package:altea/app/modules/register/presentation/modules/register/bindings/register_binding.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/register_view.dart';
import 'package:altea/app/modules/search_spesialis/bindings/search_specialist_binding.dart';
import 'package:altea/app/modules/search_spesialis/views/search_specialist_view.dart';
import 'package:altea/app/modules/spesialis_konsultasi/bindings/spesialis_konsultasi_binding.dart';
import 'package:altea/app/modules/spesialis_konsultasi/views/spesialis_konsultasi_view.dart';
import 'package:altea/app/modules/success_payment_page/bindings/success_payment_page_binding.dart';
import 'package:altea/app/modules/success_payment_page/views/success_payment_page_view.dart';
import 'package:altea/app/modules/verif_otp/bindings/verif_otp_binding.dart';
import 'package:altea/app/modules/verif_otp/views/verif_otp_view.dart';
import 'package:altea/app/modules/verify_email/bindings/verify_email_binding.dart';
import 'package:altea/app/modules/verify_email/views/verify_email_view.dart';
import 'package:altea/app/modules/wait_ma_call/bindings/wait_ma_call_binding.dart';
import 'package:altea/app/modules/wait_ma_call/views/wait_ma_call_view.dart';
import 'package:altea/app/modules/wait_ma_info/bindings/wait_ma_info_binding.dart';
import 'package:altea/app/modules/wait_ma_info/views/wait_ma_info_view.dart';

import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final INITIAL = GetPlatform.isWeb ? Routes.HOME : Routes.ON_BOARDING;
  static const NOTFOUND = Routes.ERR_404;
  // static final INITIAL = GetPlatform.isWeb ? Routes.ADD_PATIENT : Routes.ON_BOARDING;

  // Platform.isAndroid || Platform.isIOS ? Routes.LOGIN : Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_VERIF,
      page: () => ForgotVerificationView(),
      binding: ForgotVerificationBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_NEW,
      page: () => ForgotNewView(),
      binding: ForgotNewBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR,
      page: () => DoctorView(),
      binding: DoctorBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR_SPESIALIS,
      page: () => DoctorSpesialisView(),
      binding: DoctorSpesialisBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE,
      page: () => ArticleView(),
      binding: ArticleBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_EMAIL,
      page: () => VerifyEmailView(),
      binding: VerifyEmailBinding(),
    ),
    GetPage(
      name: _Paths.VERIF_OTP,
      page: () => VerifOtpView(),
      binding: VerifOtpBinding(),
    ),
    GetPage(
      name: _Paths.PROMO,
      page: () => PromoView(),
      binding: PromoBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_SPECIALIST,
      page: () => SearchSpecialistView(),
      binding: SearchSpecialistBinding(),
    ),
    GetPage(
      name: _Paths.SPESIALIS_KONSULTASI,
      page: () => SpesialisKonsultasiView(),
      binding: SpesialisKonsultasiBinding(),
      middlewares: [
        DoctorIdCheckerMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.PATIENT_CONFIRMATION,
      page: () => PatientConfirmationPage(),
      binding: PatientConfirmationBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PATIENT_DATA,
      page: () => PatientDataView(),
      binding: PatientDataBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ADD_PATIENT,
      page: () => AddPatientView(),
      binding: AddPatientBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PATIENT_ADDRESS,
      page: () => PatientAddressView(),
      binding: PatientAddressBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ADD_PATIENT_ADDRESS,
      page: () => AddPatientAddressView(),
      binding: AddPatientAddressBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ADD_PATIENT_CONFIRMED,
      page: () => AddPatientConfirmedView(),
      binding: AddPatientConfirmedBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CHOOSE_PAYMENT,
      page: () => ChoosePaymentView(),
      binding: ChoosePaymentBinding(),
      middlewares: [
        AuthMiddleware(),
        OrderIdCheckerMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.PAYMENT_GUIDE,
      page: () => PaymentGuideView(),
      binding: PaymentGuideBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PAYMENT_CONFIRMATION,
      page: () => PaymentConfirmationView(),
      binding: PaymentConfirmationBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ONBOARD_CALL,
      page: () => OnboardCallView(),
      binding: OnboardCallBinding(),
      middlewares: [
        AuthMiddleware(),
        OrderIdCheckerMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.ONBOARD_END_CALL,
      page: () => OnboardEndCallView(),
      binding: OnboardEndCallBinding(),
      middlewares: [
        AuthMiddleware(),
        OrderIdCheckerMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.SUCCESS_PAYMENT_PAGE,
      page: () => SuccessPaymentView(),
      binding: SuccessPaymentPageBinding(),
      middlewares: [
        AuthMiddleware(),
        OrderIdCheckerMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.PAYMENT_GUIDE,
      page: () => PaymentGuideView(),
      binding: PaymentGuideBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.MY_CONSULTATION,
      page: () => MyConsultationView(),
      binding: MyConsultationBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.MY_CONSULTATION_DETAIL,
      page: () => MyConsultationDetailView(),
      binding: MyConsultationDetailBinding(),
      middlewares: [
        AuthMiddleware(),
        OrderIdCheckerMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => MyProfileView(),
      binding: MyProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CALL_SCREEN,
      page: () => CallScreenView(),
      binding: CallScreenBinding(),
      middlewares: [
        AuthMiddleware(),
        OrderIdCheckerMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.WAIT_MA_CALL,
      page: () => WaitMACallView(),
      binding: WaitMaCallBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.WAIT_MA_INFO,
      page: () => WaitMaInfoView(),
      binding: WaitMaInfoBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_SETTINGS,
      page: () => ProfileSettingsView(),
      binding: ProfileSettingsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_CONTACT,
      page: () => ProfileContactView(),
      binding: ProfileContactBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_EDIT,
      page: () => ProfileEditView(),
      binding: ProfileEditBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_FAQ,
      page: () => ProfileFaqView(),
      binding: ProfileFaqBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_EDIT_DETAIL,
      page: () => ProfileEditDetailView(),
      binding: ProfileEditDetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_TNC,
      page: () => ProfileTncView(),
      binding: ProfileTncBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_PRIVACY,
      page: () => ProfilePrivacyView(),
      binding: ProfilePrivacyBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.PATIENT_TYPE,
      page: () => PatientTypeView(),
      binding: PatientTypeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PHARMACY_INFORMATION,
      page: () => PharmacyInformationView(),
      binding: PharmacyInformationBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR_SUCCESS_SCREEN,
      page: () => DoctorSuccessScreenView(),
      binding: DoctorSuccessScreenBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: "${_Paths.ARTICLE_DETAIL}/:slug",
      page: () => ArticleDetailView(),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
      name: "${_Paths.ARTICLE_BY_TAG}/:tag",
      page: () => ArticleByTagView(),
      binding: ArticleByTagBinding(),
    ),
    GetPage(
      name: _Paths.RECONNECT_CALL_VIEW,
      page: () => ReconnectCallViewView(),
      binding: ReconnectCallViewBinding(),
    ),
    GetPage(
      name: "/intro",
      page: () => IntroScreen(),
    ),
    GetPage(
      name: _Paths.CALL_SCREEN_DESKTOP,
      page: () => DesktopLandingCallScreen(),
      // page: () => MobileLandingCallScreen(),

      binding: CallScreenBinding(),
    ),
    GetPage(
      name: _Paths.CALL_SCREEN_MOBILE,
      page: () => MobileLandingCallScreen(),
      binding: CallScreenBinding(),
    ),
    GetPage(
      name: _Paths.ERR_404,
      page: () => Error404View(),
    ),
    GetPage(
      name: "/call-loading",
      page: () => LoadingCallScreen(),
    ),
    GetPage(
      name: _Paths.PATIENT_LIST,
      page: () => PatientListView(),
      binding: PatientListBinding(),
    ),
  ];
}
