import '../View/PrescreeningVisitsPage.dart';
import 'PreScreeningVisits.dart';

class WomenInformation {
  final String VRID;
  final String FullName;
  final String CompleteAddress;
  final String PhoneNumber;
  final int Age;
  final bool PRISMAEnrol;
  final String PRISMAEnrolDateText;
  final bool LabSamplesCollected;
  final bool UltrasoundDone;
  final String UltrasoundDateText;
  final String EDDText;
  final String LMPDateText;
  final int GestationWeek;
  final int GestationDays;
  final String NextUltrasoundDateText;
  final String CTU1VisitDateText;
  final String LabResultsDateText;
  final String PrescreeningVisitDateText;
  final bool IsCounseled;
  final int HasAgreed;
  final String AgreementReason;
  final int HasCounsented;
  final String ConsentReason;
  final String FifthAppointmentDateText;
  final int HasConsentedFifthDay;
  final String ConsentReasonFifthDay;
  final String TenthAppointmnetDateText;
  final int HasConsentedTenthDay;
  final String ConsentReasonTenthDay;

  //final List<PrescreeningVisits>? PrescreeningVisitList;

  WomenInformation(
      {required this.VRID,
      required this.FullName,
      required this.CompleteAddress,
      required this.PhoneNumber,
      required this.Age,
      required this.PRISMAEnrol,
      required this.PRISMAEnrolDateText,
      required this.LabSamplesCollected,
      required this.UltrasoundDone,
      required this.UltrasoundDateText,
      required this.EDDText,
      required this.LMPDateText,
      required this.GestationWeek,
      required this.GestationDays,
      required this.NextUltrasoundDateText,
      required this.CTU1VisitDateText,
      required this.LabResultsDateText,
      required this.PrescreeningVisitDateText,
      required this.IsCounseled,
      required this.HasAgreed,
      required this.AgreementReason,
      required this.HasCounsented,
      required this.ConsentReason,
      required this.FifthAppointmentDateText,
      required this.HasConsentedFifthDay,
      required this.ConsentReasonFifthDay,
      required this.TenthAppointmnetDateText,
      required this.HasConsentedTenthDay,
      required this.ConsentReasonTenthDay //,
      //required this.PrescreeningVisitList
      });
}
