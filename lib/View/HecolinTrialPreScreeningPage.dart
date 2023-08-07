import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hecolin_surveillance/Model/WomenInformation.dart';
import 'package:hecolin_surveillance/Utils/GestationCalculations.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import '../Controller/BaselineInformationController.dart';
import '../DBOperations/DBProvider.dart';
import '../Model/PreScreeningVisits.dart';
import '../Service/NotificationService.dart';
import '../Utils/Message.dart';
import '../WebApi/webapiconfig.dart';
import '../Widgets/RoundButton.dart';
import '../config.dart';
import 'LoginScreen.dart';
import 'NavigationPage.dart';

class HecolinTrialPreScreening extends StatefulWidget {
  const HecolinTrialPreScreening({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<HecolinTrialPreScreening> createState() =>
      _HecolinTrialPreScreeningState();
}

class _HecolinTrialPreScreeningState extends State<HecolinTrialPreScreening> {
  final BaselineInformationController baselineInformationController =
      BaselineInformationController();

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _dateOfVisitFormKey = GlobalKey<FormState>();
  final _eligibilityFormKey = GlobalKey<FormState>();
  final _inclusionExclusionFormKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final fullName = TextEditingController();
  FocusNode fullNameFocus = FocusNode();

  final nameOfStaff = TextEditingController();
  FocusNode nameOfStaffFocus = FocusNode();

  final agreeParticipation = TextEditingController();
  FocusNode agreeParticipationFocus = FocusNode();

  final idVR = TextEditingController(text: 'VR-');
  FocusNode idVRFocus = FocusNode();

  final medidataScreeningID = TextEditingController();
  FocusNode medidataScreeningIDFocus = FocusNode();

  final age = TextEditingController();
  FocusNode ageFocus = FocusNode();

  final completeAddress = TextEditingController();
  FocusNode completeAddressFocus = FocusNode();

  //final phoneNumber = TextEditingController();
  // ** Added by Iman ** //
  final TextEditingController phoneNumber = TextEditingController(text: '03');

// ** ** //
  FocusNode phoneNumberFocus = FocusNode();

  final prismaStudyEnrolDate = TextEditingController();
  FocusNode prismaStudyEnrolDateFocus = FocusNode();

  final ctu1VisitDate = TextEditingController();
  FocusNode ctu1VisitDateFocus = FocusNode();

  final ultraSoundDate = TextEditingController();
  FocusNode ultraSoundDateFocus = FocusNode();

  final dateOfLabResults = TextEditingController();
  FocusNode dateOfLabResultsFocus = FocusNode();

  final prescreeningVisitDate = TextEditingController();
  FocusNode prescreeningVisitDateFocus = FocusNode();

  final fifthAppointmentDate = TextEditingController();
  FocusNode fifthAppointmentDateFocus = FocusNode();

  final tenthAppointmentDate = TextEditingController();
  FocusNode tenthAppointmentDateFocus = FocusNode();

  final consentReason =
      TextEditingController(); // Variable to track the selected value
  FocusNode consentReasonFocus = FocusNode();

  final consentFifthDayReason =
      TextEditingController(); // Variable to track the selected value
  FocusNode consentFifthDayReasonFocus = FocusNode();

  final consentTenthDayReason =
      TextEditingController(); // Variable to track the selected value
  FocusNode consentTenthDayReasonFocus = FocusNode();

  final eDD = TextEditingController();
  FocusNode eDDFocus = FocusNode();

  final dateOfEntry = TextEditingController();
  FocusNode dateOfEntryFocus = FocusNode();

  final lMPDate = TextEditingController();
  FocusNode lMPDateFocus = FocusNode();

  final weeks = TextEditingController();
  final days = TextEditingController();

  final nextUltrasoundDate = TextEditingController();
  FocusNode nextUltrasoundDateFocus = FocusNode();

  int ageNumber = 0;
  double heightNumber = 0.0;
  double weightNumber = 0.0;
  double bmiNumber = 0.0;

  bool labSamplesCollected = false;
  bool pregnantWomenEnrolled = false;
  bool counselingAtCenter = false;

  bool ultrasoundDone = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String formattedDate = "";

  String selectedValue = ''; // Set an initial value
  FocusNode siteDropdownFocus = FocusNode();

  String? _errorAgeMessage;
  String? _errorMessage;
  int participationWomenSelectedValue =
      0; // Variable to track the selected value
  String? _errorTextParticipationWomenSelectedValue;
  String? _errorTextWomenConsent;
  String? _errorTextWomenConsentFifthDay;
  String? _errorTextWomenConsentTenthDay;
  String? _errorCurrentReasonForScreenFailureParticipantElig;

  int consentWomenSelectedValue = 0; // Variable to track the selected value
  int consentFifthWomenSelectedValue =
      0; // Variable to track the selected value
  int consentTenthWomenSelectedValue = 0;

  bool showConsentWiseInformation = true;
  bool showConsentWiseRefusalInformation = true;
  bool womenEnrolledInPrismaStudy = false;
  bool hecolinTrialCounselingDoneAtCenter = false;
  bool womenAgreementForParticipation = true;
  bool womenAgreementTimeForParticipation = true;
  bool womenConsentForTrail = true;
  bool womenConsentTimeForTrail = true;
  bool womenConsentForTrailFifthDay = false;
  bool womenConsentForTrailTenthDay = false;
  bool hidePregnancyInformation = true;
  bool formIsSubmitted = false;
  bool selectedParticipantEligibleInClinicalTrial = false;
  int isParticipantEligibleInClinicalTrial = 0;
  int wbIDPrimKey = 0;
  int currentAmnioticFluidIndexNormal = 0;
  int currentFetalBiometryInformation = 0;
  int currentVisibleFetalAnomaly = 0;
  int currentPrenatalInfoOtherVisibleAnomaly = 0;
  String? _errorCurrentAmnioticFluidIndexNormal;
  String? _errorCurrentFetalBiometryInformation;
  String? _errorCurrentVisibleFetalAnomaly;
  String? _errorCurrentPrenatalInfoOtherVisibleAnomaly;
  int isVisitOneTwoSameDay = 0;
  int isInclusionAndExclusionEvaluated = 0;
  String? _errorTextIsInclusionAndExclusionEvaluated;
  bool selectedInclusionAndExclusionEvaluated = false;
  String reasonNotInclusionExclusionDone = '';
  int? counselingAtCenterRB;
  int? labSamplesCollectedRB;
  int? pregnantWomenEnrolledRB;
  int? ultrasoundDoneRB;

  List<PrescreeningVisits>? womenPrecsreeningVisitInformationList;
  final List<String> bodySystems = [
    "Ear / Nose / Throat",
    "Skin",
    "Lymph Nodes",
    "Neck",
    "Pulmonary",
    "Cardiovascular",
    "Abdomen",
    "Extremities",
    "Muscular-Skeletal",
    "Neurological",
    "Abdominal scar",
    "Fundal height",
    "Other",
  ];

  Map<String, int> fullPhysicalExamResults = {};

  final List<String> inclusionCriterias = [
    "Healthy women 16-45 years of age who are between 14 0/7 and 34 6/7 weeks gestation on the day of planned vaccination with an uncomplicated, singleton pregnancy, who are at no known increased risk for complications for herself and her infant.",
    "Individual willing to provide written informed consent for herself and her infant to participate in the study.",
    "Individual who can be followed up during the study period and can comply with the study requirements.",
    "Individual and fetus in good health as determined by the outcome of medical history, physical examination, obstetric history, prenatal care (by ultrasound and other prenatal assessment subject to gestational age), vital signs, laboratory evaluations at screening and the clinical judgment of the investigator.",
    "Individual who is willing and able to comply with scheduled visits, treatment plan, laboratory tests, and other study procedures.",
    "Individual with body mass index (BMI) at or between 18.0 kg/m2 and 40.0 kg/m2 at screening visit (i.e., 18.0 kg/m2 ≤ BMI ≤ 40.0 kg/m2)",
  ];

  Map<String, int> inclusionCriteriaOptionResults = {};

  final List<String> exclusionCriterias = [
    "Has received any hepatitis E vaccine in the past.",
    "Febrile illness (axillary temperature ≥ 38.5°C) or acute illness within 3 days prior to the study vaccination.",
    "Known history or allergy to study vaccine components and/or excipients or other medications, or any other allergies or medical history deemed by the investigator to increase the risk of an adverse event if they were to participate in the trial(e.g., Guillain-Barre Syndrome).",
    "Major congenital abnormalities which in the opinion of investigator may affect the participant’s participation in the study.",
    "Known history of immune function disorders including immunodeficiency diseases (known HIV infection or other immune function disorders) and lupus.",
    "Chronic use of systemic steroids (>2 mg/kg/day or >20 mg/day prednisone equivalent for periods exceeding 10 days), cytotoxic or other immunosuppressive drugs within past 6 weeks.",
    "Any abnormality or chronic disease which in the opinion of the investigator might be detrimental for the safety of the participant and interfere with the assessment of the study objectives."
        "Behavioral or cognitive impairment, or chronic substance abuse, or psychiatric disease or neural disorders, that, in the opinion of the investigator, could interfere with the participant's ability to participate in the trial.",
    "History of splenectomy.",
    "Past history of thrombocytopenia and / or thrombosis, myocarditis or pericarditis or any other significant cardiac condition.",
    "With a known bleeding diathesis, or any condition that may be associated with a prolonged bleeding time resulting in contraindication for IM injections / blood extractions (Those who receive low dose aspirin (less than 100mg/day) are not excluded).",
    "Receipt of blood or blood-derived products in the past 3 months.",
    "Receipt of other vaccines from 42 weeks prior to test vaccination or planned to receive any vaccine within 42 weeks of last dose of study vaccine.",
    "As per Investigator’s medical judgement, an individual could be excluded from the study in spite of meeting all inclusion / exclusion criteria mentioned above.",
    "Concomitantly enrolled or scheduled to be enrolled in another trial.",
    "Research staff involved with the clinical study or family / household members of research staff.",
    "Plans to terminate her pregnancy.",
    "Pregnancy complications (in the current pregnancy) such as preterm labor, gestational diabetes, hypertension, (blood pressure (BP) > 140/90 mmHg in the presence of proteinuria or BP > 150/100 mmHg with or without proteinuria) or currently on an anti-hypertensive therapy, or pre-eclampsia, or evidence of intrauterine growth restriction.",
    "Prior stillbirth or neonatal death, or multiple (≥ 3) spontaneous abortions.",
    "Prior preterm delivery ≤ 34 weeks gestation or having ongoing intervention (medical / surgical) in current pregnancy to prevent preterm birth.",
    "Previous infant with a known genetic disorder or major congenital anomaly.",
    "History of major gynecologic or major abdominal surgery (previous Caesarean section is not an exclusion).",
    "Current pregnancy results from in vitro fertilization (IVF).",
    "Current pregnancy results from rape or incest.",
    "Plans to release the neonate for adoption or the neonate to be a ward of the state.",
    "Greater than 5 prior deliveries.",
  ];

  Map<String, int> exclusionCriteriaOptionResults = {};

  // -- Second Form Start -- //

  int hasMedicalHistory = 0;
  int tobaccoUsage = 0;
  int currenttobaccoUsageSelectedValue = 0;
  String? _errorCurrentTobaccoUsageSelectedValue;
  int alcoholUsage = 0;
  int currentalcoholUsageSelectedValue = 0;
  String? _errorCurrentAlcoholUsageSelectedValue;
  bool hasSelectedMedicalHistory = false;
  int isPrenatalInformationCollected = 0;
  String reasonNotPrenatalInfoCollected = '';
  String? prenatalCareLocation;
  String? otherPrenatalCareLocation;
  int isVitalSignMeasured = 0;
  String reasonNotVitalSignMeasured = '';
  bool isVitalSignSameAsVisitDate = false;
  bool isbodyTempCollectionMethod = true;
  bool hideSecondFormInformation = true;
  bool hasSelectedTobaccoUsage = false;
  bool hasSelectedAlcoholUsage = false;
  bool hasSelectedPrenatalInformation = false;
  bool hasSelectedVitalSign = false;
  bool? isFetalBiometryNormal = null;
  bool? isAmnioticFluidIndexNormal = null;
  bool? isVRIDAlreadyExists = false;
  bool womenInfoFormsVisibility = true;

  String? _errorTextHasSelectedMedicalHistory;
  String? _errorTextHasSelectedTobaccoUse;
  String? _errorTextHasSelectedAlcoholUse;
  String? _errorTextHasSelectedPrenatalInformation;
  String? _errorTextHasSelectedVitalSign;
  String? _errorTextIsVisitOneTwoSameDay;

  String? _errorTextHaveAnyPrevPregObstetricHist;
  int haveAnyPrevPregObstetricHist = 0;
  bool selectedHaveAnyPrevPregObstetricHist = false;
  String? _errorTextObstetricHistAnyAbortion;
  String? _errorTextObstetricHistAnyDelivery;
  int obstetricHistAnyAbortion = 0;
  int obstetricHistAnyDelivery = 0;
  bool selectedObstetricHistAnyAbortion = false;
  bool selectedObstetricHistAnyDelivery = false;
  bool hasSelectedVisitOneTwoSameDay = false;

  int isPhysicalExamPerformed = 0;
  String reasonNotPerformed = '';
  String? fullPhysicalExamBodySystemValue;
  String? otherFullPhysicalExamBodySystemValue;
  int isFullPhysicalExamSameAsVisitDate = 0;
  String? fullPhysicalExamResultValue;

  String? _errorTextHasSelectedFullPhysicalExam;
  String? _errorTextIsParticipantEligibleInClinicalTrial;
  int currentReasonForScreenFailureParticipantElig = 0;

// Controllers

  final participantHeight = TextEditingController();
  FocusNode participantHeightFocus = FocusNode();
  final participantWeight = TextEditingController();
  FocusNode participantWeightFocus = FocusNode();
  final bmiController = TextEditingController();
  TextEditingController medicalHistoryDiseaseNameController =
      TextEditingController();
  TextEditingController inclusionExclusionReasonNotDoneController =
      TextEditingController();

  // Prenatal Information Controller
  TextEditingController prenatalOtherCareController = TextEditingController();
  TextEditingController prenatalFetalBiometryController =
      TextEditingController();
  TextEditingController prenatalAmnioticFluidIndexController =
      TextEditingController();
  TextEditingController prenatalCareDateController = TextEditingController();
  TextEditingController prenatalUltrasonographDateController =
      TextEditingController();
  TextEditingController prenatalReasonNotCollectedController =
      TextEditingController();
  TextEditingController otherFullPhysicalExamBodySystemController =
      TextEditingController();
  TextEditingController
      visibleFetalAnomalyAndOtherVisibleAnomalyReasonController =
      TextEditingController();
  TextEditingController fetalAndAmnioticReasonController =
      TextEditingController();

  // Vital Sign Controller
  TextEditingController vitalSignSystolicController = TextEditingController();
  TextEditingController vitalSignDiastolicController = TextEditingController();
  TextEditingController vitalSignHeartRateController = TextEditingController();
  TextEditingController vitalSignRespiratoryRateController =
      TextEditingController();
  TextEditingController fetalHeartRateController = TextEditingController();
  TextEditingController vitalSignBodyTempController = TextEditingController();
  TextEditingController vitalSignDateOfCollectionController =
      TextEditingController();
  TextEditingController vitalSignTimeOfCollectionController =
      TextEditingController();
  TextEditingController vitalSignReasonNotPerformedController =
      TextEditingController();
  TextEditingController obstetricHistoryNoOfPastPregController =
      TextEditingController();
  TextEditingController obstetricHistoryNoOfAbortionController =
      TextEditingController();
  TextEditingController obstetricHistoryNoOfDeliveryController =
      TextEditingController();

  // Full Physical Controller
  TextEditingController fullPhysicalExamReasonController =
      TextEditingController();
  TextEditingController fullPhysicalDateOfExaminationController =
      TextEditingController();

// Methods & Functions

// Calculate BMI method
  double calculateBMI(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  void calculateBMIAndUpdate() {
    double height = double.tryParse(participantHeight.text) ?? 0.0;
    double weight = double.tryParse(participantWeight.text) ?? 0.0;

    if (height > 0 && weight > 0) {
      double bmi = calculateBMI(weight, height);
      bmiController.text = bmi.toStringAsFixed(2);
    } else {
      bmiController.text = '';
    }
  }

  // Custom validator function for height input
  String? validateParticipantHeight(String? value) {
    if (value == null || value.isEmpty) {
      return "Height is required";
    }

    // Check if the value matches the desired format (ddd.d)
    if (!RegExp(r'^[1-9]\d{2}\.\d$').hasMatch(value)) {
      return "Please enter the height in cm (e.g., 170.0 cm)";
    }

    // Parse the height value to a double
    double? participantHeight = double.tryParse(value);
    if (participantHeight == null) {
      return "Invalid height value";
    }

    // Check if the height is within the desired range
    if (participantHeight < 137 || participantHeight > 180) {
      return "Height range is min 137cm and max 180cm";
    }

    return null; // Validation success
  }

// Custom validator function for weight input
  String? validateParticipantWeight(String? value) {
    if (value == null || value.isEmpty) {
      return "Weight is required";
    }

    // Check if the value matches the desired format (ddd.d)
    if (RegExp(r'^[1-9]\d{2}\.\d$').hasMatch(value)) {
      return "Please enter the weight (e.g., 60.0 kg)";
    }

    // Parse the height value to a double
    double? participantWeight = double.tryParse(value);
    if (participantWeight == null) {
      return "Invalid weight value";
    }

    // Check if the weight is within the desired range
    if (participantWeight < 35 || participantWeight > 110) {
      return "Weight range is min 35 kg and max 110 kg";
    }

    return null; // Validation success
  }

// Define the custom validator function for body temp input
  String? validatevitalSignBodyTemperature(String? value) {
    if (value == null || value.isEmpty) {
      return "Body Temperature is required";
    }

    // Check if the value matches the desired format (ddd.d)
    if (!RegExp(r'^[1-9]\d*(\.\d)?$').hasMatch(value)) {
      return "Enter the temperature in ˚C (e.g., 37.0 ˚C)";
    }

    // Parse the temperature value to a double
    double? bodyTemperature = double.tryParse(value);
    if (bodyTemperature == null) {
      return "Invalid temperature value";
    }

    // Check if the body temperature is within the desired range
    if (bodyTemperature < 35 || bodyTemperature > 40.5) {
      return "Body temperature range is min 35°C and max 40.5°C";
    }

    return null; // Validation success
  }

// -- Second Form End -- //

  @override
  void initState() {
    super.initState();
    for (var bodySystem in bodySystems) {
      fullPhysicalExamResults[bodySystem] =
          0; // Initialize with an empty string
    }
    for (var inclusionCriteria in inclusionCriterias) {
      inclusionCriteriaOptionResults[inclusionCriteria] =
          0; // Initialize with an empty string
    }
    for (var exclusionCriteria in exclusionCriterias) {
      exclusionCriteriaOptionResults[exclusionCriteria] =
          0; // Initialize with an empty string
    }
    // Call your method here
    //postBaselineInformationToWebApi();
    // schedulePrescreeningNotifications();
    counselingAtCenterRB = counselingAtCenter ? 1 : null;
    labSamplesCollectedRB = labSamplesCollected ? 1 : null;
    pregnantWomenEnrolledRB = pregnantWomenEnrolled ? 1 : null;
    ultrasoundDoneRB = ultrasoundDone ? 1 : null;
  }

  @override
  void dispose() {
    nameOfStaff.dispose();
    age.dispose();
    super.dispose();
  }

  clearFields() {
    _formKey.currentState!.reset();
    fullName.text = "";
    idVR.text = "";
    medidataScreeningID.text = "";
    age.text = "";
    completeAddress.text = "";
    phoneNumber.text = "";
  }

  Future<void> _selectFifthDate(
      BuildContext context, TextEditingController aDatetimecontroller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 6)));

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        // formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
      });
    }
  }

  Future<void> _selectTenthDate(
      BuildContext context, TextEditingController aDatetimecontroller) async {
    final String fifthAppointmentDateText = fifthAppointmentDate.text;
    DateTime fifthDate = DateTime.now();

    if (fifthAppointmentDateText.isNotEmpty) {
      try {
        fifthDate = DateFormat('yyyy-MM-dd').parse(fifthAppointmentDateText);
      } catch (e) {
        print('Error parsing date: $e');
        return;
      }
    }

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fifthDate.add(Duration(days: 1)),
        firstDate: fifthDate.add(Duration(days: 1)),
        lastDate: fifthDate.add(Duration(days: 6)));

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
      });
    }
  }

  Future<void> _selectDateOnFieldBasis(
      BuildContext context,
      TextEditingController aDatetimecontrollerFieldSet,
      TextEditingController aDatetimecontroller,
      int backDays,
      int futureDays) async {
    final String dateText = aDatetimecontroller.text;
    DateTime dateCon = DateTime.now();

    if (dateText.isNotEmpty) {
      try {
        dateCon = DateFormat('yyyy-MM-dd').parse(dateText);
      } catch (e) {
        print('Error parsing date: $e');
        return;
      }
    }

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateCon.add(Duration(days: backDays)),
        firstDate: dateCon.add(Duration(days: backDays)),
        lastDate: dateCon.add(Duration(days: futureDays)));

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontrollerFieldSet.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController aDatetimecontroller,
  ) async {
    final TimeOfDay currentTime = TimeOfDay.now();

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
        aDatetimecontroller.text = _selectedTime.format(context);
      });
    }
  }

  Future<void> _selectRequiredDate(
      BuildContext context,
      TextEditingController aDatetimecontroller,
      int backDays,
      int futureDays) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: backDays)),
        lastDate: DateTime.now().add(Duration(days: futureDays)));

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
      });
    } else if (picked == null) {
      setState(() {
        aDatetimecontroller.text = '';
      });
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController aDatetimecontroller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 38 * 7)),
        lastDate: DateTime.now().add(Duration(days: 270)));

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
      });
    }
  }

  Future<void> _selectEDDDate(
      BuildContext context, TextEditingController aDatetimecontroller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 270)));

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
      });
    }
  }

  Future<void> _selectLMPDate(
      BuildContext context, TextEditingController aDatetimecontroller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 38 * 7)),
        lastDate: DateTime.now());

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
        SetGestationalWeeksAndDays();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime todayDate = DateTime.now();
    String formattedDateOfToday = DateFormat('yyyy-MM-dd').format(todayDate);

    dateOfEntry.text = formattedDateOfToday;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PRE-SCREENING LOG SHEET – HECOLIN TRIAL - V1'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NavigationPage(title: AppConfig.applicationName)));
              },
              icon: Icon(Icons.logout_outlined),
            ),
            SizedBox(width: 10)
          ],
          backgroundColor: Colors.deepPurpleAccent,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          //scrollDirection: Axis.horizontal,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 20),
                  // ),

                  Visibility(
                    visible: womenInfoFormsVisibility,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          autovalidateMode: _autovalidateMode,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),

                              TextFormField(
                                focusNode: dateOfEntryFocus,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Date is required";
                                  } else
                                    return null;
                                },
                                controller: dateOfEntry,
                                readOnly: true,
                                //onTap: () => _selectDate(context, dateOfEntry),
                                // onTap: () =>
                                //     _selectRequiredDate(context, dateOfEntry, 0, 0),

                                decoration: InputDecoration(
                                  hintText: "Date (*)",
                                  labelText: "Date (*)",
                                  labelStyle: const TextStyle(fontSize: 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),

                              TextFormField(
                                controller: nameOfStaff,
                                focusNode: nameOfStaffFocus,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-z A-Z]')),
                                  LengthLimitingTextInputFormatter(30)
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name of Staff is required";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Name Of Staff (*)",
                                    labelText: "Name of Staff (*)",
                                    labelStyle: const TextStyle(fontSize: 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),
                              // Row(
                              //   children: [
                              //     SizedBox(width: 10), // give it width
                              //
                              //     DropdownButton<String>(
                              //       value: selectedValue.isNotEmpty ? selectedValue : null, // guard it with null if empty
                              //       style: TextStyle(color: Colors.black,fontSize: 30),
                              //
                              //       onChanged: (value) {
                              //         setState(() {
                              //           selectedValue = value.toString();
                              //         });
                              //       },
                              //       iconSize: 30, // Set the size of the dropdown arrow icon
                              //       underline: Container( // Remove the default underline
                              //         height: 2,
                              //         color: Colors.transparent,
                              //       ),
                              //       items: <String>[
                              //         'IH',
                              //         'AG',
                              //         'BH',
                              //         'RG',
                              //       ].map<DropdownMenuItem<String>>((String item) {
                              //         return DropdownMenuItem<String>(
                              //           value: item,
                              //           child: Text(item
                              //           ),
                              //         );
                              //       }).toList(),
                              //       hint: Text('Select SITE'),
                              //     ),
                              //
                              //   ],
                              // ),
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: 'Select SITE (*)',
                                  hintText: 'Select SITE (*)',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                    // borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                    //borderRadius: BorderRadius.circular(20),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                dropdownColor: Colors.white,
                                value: selectedValue.isNotEmpty
                                    ? selectedValue
                                    : null,
                                // guard it with null if empty
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'SITE is required';
                                  }
                                  return null;
                                },
                                focusNode: siteDropdownFocus,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValue = newValue!;
                                    SetMedidataFieldLetters();
                                  });
                                },

                                items: <String>[
                                  'IH',
                                  'AG',
                                  'BH',
                                  'RG',
                                ].map<DropdownMenuItem<String>>((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                //hint: Text('Select SITE'),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),
                              const Text(
                                'BASELINE INFORMATION ',
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    backgroundColor: Colors.deepPurpleAccent),
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),
                              Row(
                                children: [
                                  // give it width
                                  const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "1.1 Full name of woman (approached)",
                                        style: TextStyle(fontSize: 20),
                                      )
                                      //child: SizedBox(width: 90),
                                      ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              TextFormField(
                                controller: fullName,
                                focusNode: fullNameFocus,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-z A-Z]')),
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Full Name is required";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Full Name (*)",
                                    labelText: "Full Name (*)",
                                    labelStyle: const TextStyle(fontSize: 20),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),
                              Row(
                                children: [
                                  // give it width
                                  const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "1.2 Age (years)",
                                        style: TextStyle(fontSize: 20),
                                      )
                                      //child: SizedBox(width: 90),
                                      ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Focus(
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) {
                                    if (_errorAgeMessage != null) {
                                      setState(() {
                                        _errorAgeMessage = null;
                                        age.clear();
                                      });
                                    }
                                  }
                                },
                                child: TextFormField(
                                  controller: age,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  onChanged: (value) {
                                    final number = int.tryParse(value);

                                    if (number != null &&
                                        (number < 16 || number > 45)) {
                                      setState(() {
                                        _errorAgeMessage =
                                            'Enter age between 16 and 45';
                                      });
                                    } else {
                                      setState(() {
                                        _errorAgeMessage = null;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value != null) {
                                      String? message =
                                          _ageValidator(value.toString());

                                      if (message == null) {
                                        return null;
                                      } else {
                                        return message;
                                      }
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        "Enter age between 16 and 45 years (*)",
                                    labelText:
                                        "Enter age between 16 and 45 years (*)",
                                    errorText: _errorAgeMessage,
                                    labelStyle: const TextStyle(fontSize: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),

                              // TextFormField(
                              //   controller: idVR,
                              //   validator: (value) {
                              //     if (value!.isEmpty)
                              //       return "VRID is required";
                              //     else
                              //       return null;
                              //   },
                              //   decoration: InputDecoration(
                              //     hintText: "VRID (*)",
                              //     labelText: "VRID (*)",
                              //     labelStyle: const TextStyle(fontSize: 20),
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(5),
                              //     ),
                              //   ),
                              // ),
// ** Added by Iman ** //
                              Row(
                                children: [
                                  // give it width
                                  const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "1.3 VR ID",
                                        style: TextStyle(fontSize: 20),
                                      )
                                      //child: SizedBox(width: 90),
                                      ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              TextFormField(
                                controller: idVR,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                validator: (value) {
                                  // bool? isPresent =
                                  //      CheckForExistingVRId(value.toString()) as bool?;
                                  CheckForExistingVRId(value.toString());

                                  if (value!.isEmpty ||
                                      !value.startsWith('VR-')) {
                                    return "VRID is required and should start with VR-";
                                  } else if (value.length != 8) {
                                    return "Complete VRID is required";
                                  } else if (isVRIDAlreadyExists == true) {
                                    return "VRID already exists";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  if (value.isEmpty ||
                                      (value.length == 1 && value != 'V')) {
                                    idVR.value = const TextEditingValue(
                                      text: 'VR-',
                                      selection: TextSelection.collapsed(
                                          offset: 'VR-'.length),
                                    );
                                  } else if (!value.startsWith('VR-')) {
                                    idVR.value = TextEditingValue(
                                      //text: 'VR-' + value.substring(2),
                                      text: 'VR-${value.substring(2)}',
                                      selection: TextSelection.collapsed(
                                          offset:
                                              'VR-'.length + value.length - 2),
                                    );
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "VRID (*)",
                                  labelText: "VRID (*)",
                                  labelStyle: const TextStyle(fontSize: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  //prefixText: 'VR-', // Set the fixed prefix
                                  //prefixStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),

// **  ** //
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),

                              // TextFormField(
                              //   controller: medidataScreeningID,
                              //   inputFormatters: [
                              //     FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-]+$')),
                              //     LengthLimitingTextInputFormatter(7),
                              //
                              //   ],
                              //   // onChanged: (value) {
                              //   //   if (value.length > 3) {
                              //   //     final digitsAfterThree = value.substring(3).replaceAll(RegExp(r'[^0-9]'), '');
                              //   //     medidataScreeningID.value = TextEditingValue(
                              //   //       text: value.substring(0, 3) + digitsAfterThree,
                              //   //       selection: TextSelection.collapsed(offset: value.length),
                              //   //     );
                              //   //   }
                              //   // },
                              //   // inputFormatters: [
                              //   //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')),
                              //   // ],
                              //   validator: (value) {
                              //     if(value!=null) {
                              //       String? message= digitValidator(value.toString());
                              //       if(message=="")
                              //       {
                              //         return null;
                              //       }
                              //       else
                              //       {
                              //         return message;
                              //       }
                              //     }
                              //     // if (value!.isEmpty)
                              //     //   return "Please enter Medidata Screening ID";
                              //     // else
                              //     //   return null;
                              //   },
                              //   decoration: InputDecoration(
                              //     labelText: "Medidata Screening ID (*)",
                              //     hintText: "Medidata Screening ID (*)",
                              //     labelStyle: const TextStyle(fontSize: 20),
                              //     border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(5)),
                              //   ),
                              // ),
                              // Row(
                              //   children: [
                              //     // give it width
                              //     const Expanded(
                              //         flex: 2,
                              //         child: Text(
                              //           "1.3 Medidata",
                              //           style: TextStyle(fontSize: 20),
                              //         )
                              //       //child: SizedBox(width: 90),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 5),
                              // ),
                              Row(
                                children: [
                                  // give it width
                                  const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "1.4 Medidata Screening ID",
                                        style: TextStyle(fontSize: 20),
                                      )
                                      //child: SizedBox(width: 90),
                                      ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              TextFormField(
                                controller: medidataScreeningID,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-Z0-9-]+$')),
                                  //FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                                  //FilteringTextInputFormatter.digitsOnly,
                                  // Restrict to 3 digits
                                  LengthLimitingTextInputFormatter(7),
                                ],
                                validator: (value) {
                                  if (value != null) {
                                    String? message =
                                        digitValidator(value.toString());
                                    if (message == "") {
                                      return null;
                                    } else {
                                      return message;
                                    }
                                  }
                                  return null; // Add a return statement for cases when value is null
                                },

                                onChanged: (value) {
                                  String prefix = '';

                                  if (selectedValue == 'IH') {
                                    prefix = 'S1-';
                                  } else if (selectedValue == 'AG') {
                                    prefix = 'S2-';
                                  } else if (selectedValue == 'BH') {
                                    prefix = 'S3-';
                                  } else if (selectedValue == 'RG') {
                                    prefix = 'S4-';
                                  }

                                  if (!value.startsWith(prefix)) {
                                    if (value.length >= prefix.length) {
                                      String updatedValue = prefix +
                                          value.substring(prefix.length);
                                      medidataScreeningID.value =
                                          medidataScreeningID.value.copyWith(
                                        text: updatedValue,
                                        selection: TextSelection.collapsed(
                                            offset: updatedValue.length),
                                      );
                                    } else {
                                      medidataScreeningID.value =
                                          medidataScreeningID.value.copyWith(
                                        text: prefix,
                                        selection: TextSelection.collapsed(
                                            offset: prefix.length),
                                      );
                                    }
                                  }
                                },

                                // ** ** //
                                decoration: InputDecoration(
                                  labelText: "Medidata Screening ID (*)",
                                  hintText: "Medidata Screening ID (*)",
                                  labelStyle: const TextStyle(fontSize: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),
                              Row(
                                children: [
                                  // give it width
                                  const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "1.5 Complete address",
                                        style: TextStyle(fontSize: 20),
                                      )
                                      //child: SizedBox(width: 90),
                                      ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              TextFormField(
                                controller: completeAddress,
                                focusNode: completeAddressFocus,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Complete Address is required";
                                  } else
                                    return null;
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(120),
                                ],
                                decoration: InputDecoration(
                                  hintText: "Complete Address (*)",
                                  labelText: "Complete Address (*)",
                                  labelStyle: const TextStyle(fontSize: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),

                              // TextFormField(
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return "Phone Number is required";
                              //     }
                              //     // ** Added By Iman ** //
                              //     else if (!value.startsWith('03')) {
                              //       return "Phone Number should start with 03";
                              //     }
                              //     // ** Added By Iman ** //
                              //     // else
                              //       return null;
                              //   },
                              //   //controller: phoneNumber,
                              //   // Added by Iman
                              //   controller: phoneNumber..text = '03',
                              //   focusNode: phoneNumberFocus,
                              //   keyboardType: TextInputType.number,
                              //   inputFormatters: <TextInputFormatter>[
                              //     FilteringTextInputFormatter.digitsOnly,
                              //     LengthLimitingTextInputFormatter(11),
                              //
                              //   ],
                              //   // ** Added By Iman ** //
                              //   onChanged: (value) {
                              //     if (value.isNotEmpty && !value.startsWith('03')) {
                              //       phoneNumber.text = '03' + value.substring(1);
                              //       phoneNumber.selection = TextSelection.fromPosition(
                              //         TextPosition(offset: phoneNumber.text.length),
                              //       );
                              //     }
                              //   },
                              //   // ** ** //
                              //   decoration: InputDecoration(
                              //     hintText: "Phone Number (*)",
                              //     labelText: "Phone Number (*)",
                              //     labelStyle: const TextStyle(fontSize: 20),
                              //     border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(5)),
                              //   ),
                              // ),
// ** Added by Iman ** //
                              Row(
                                children: [
                                  // give it width
                                  const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "1.6 Phone number",
                                        style: TextStyle(fontSize: 20),
                                      )
                                      //child: SizedBox(width: 90),
                                      ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Phone Number is required";
                                  } else if (!value.startsWith('03')) {
                                    return "Phone Number should start with 03";
                                  } else if (value.length != 11) {
                                    return "Complete Phone Number is required";
                                  }
                                  return null;
                                },
                                controller: phoneNumber,
                                focusNode: phoneNumberFocus,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      !value.startsWith('03')) {
                                    //phoneNumberController.text = '03' + value.substring(1);
                                    phoneNumber.text =
                                        '03${value.substring(1)}';
                                    phoneNumber.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: phoneNumber.text.length),
                                    );
                                  } else if (value.length < 2 ||
                                      (value.length == 2 && value != '03')) {
                                    phoneNumber.text = '03';
                                    phoneNumber.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: phoneNumber.text.length),
                                    );
                                  }
                                },
                                onEditingComplete: () {
                                  if (_formKey.currentState!.validate()) {
                                    // All fields are valid, form submission
                                    // Clear the input fields
                                    phoneNumber.clear();
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Phone Number (*)",
                                  labelText: "Phone Number (*)",
                                  labelStyle: const TextStyle(fontSize: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
// ** ** //
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),
                              const Text(
                                'VERBAL CONSENT INFORMATION',
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    backgroundColor: Colors.deepPurpleAccent),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              // SingleChildScrollView(
                              //   scrollDirection: Axis.horizontal,
                              //   child:
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // SizedBox(width: 10),
                                        // give it width
                                        const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "2.1 Counseling for Hecolin Trial is done at the center?",
                                              style: TextStyle(fontSize: 20),
                                            )
                                            //child: SizedBox(width: 90),
                                            ),
                                        // const Text(
                                        //   "Counseling for Hecolin Trial is done at the center?",
                                        //   style: TextStyle(fontSize: 20),
                                        //
                                        // ),
                                        SizedBox(width: 10),
                                        // give it width

                                        // Checkbox(
                                        //   value: counselingAtCenter,
                                        //   onChanged: (value) {
                                        //     setState(() {
                                        //       counselingAtCenter =
                                        //           !counselingAtCenter;
                                        //       // participationWomenSelectedValue = 0;
                                        //       if (!counselingAtCenter) {
                                        //         participationWomenSelectedValue = 0;
                                        //         _errorTextParticipationWomenSelectedValue =
                                        //             null;
                                        //       }
                                        //     });
                                        //   },
                                        // ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                              value: 1,
                                              groupValue: counselingAtCenterRB,
                                              onChanged: (value) {
                                                setState(() {
                                                  counselingAtCenterRB =
                                                      value as int;
                                                  if (counselingAtCenterRB ==
                                                      1) {
                                                    counselingAtCenter = true;
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Yes',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio(
                                              value: 2,
                                              groupValue: counselingAtCenterRB,
                                              onChanged: (value) {
                                                setState(() {
                                                  counselingAtCenterRB =
                                                      value as int;
                                                  if (counselingAtCenterRB ==
                                                      2) {
                                                    counselingAtCenter = false;
                                                  }
                                                });
                                              },
                                            ),
                                            const Text('No',
                                                style: TextStyle(fontSize: 18)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                              // ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              if (counselingAtCenter)
                                Row(
                                  children: [
                                    // SizedBox(width: 10), // give it width
                                    Flexible(
                                      child: const Text(
                                        "2.2 Did the woman agree to participate?",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(width: 90),
                                  ],
                                ),
                              if (counselingAtCenter)
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue:
                                          participationWomenSelectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          participationWomenSelectedValue =
                                              value as int;
                                          _errorTextParticipationWomenSelectedValue =
                                              null;
                                          if (!hidePregnancyInformation)
                                            hidePregnancyInformation = true;

                                          if (!hideSecondFormInformation)
                                            hideSecondFormInformation = true;

                                          if (consentWomenSelectedValue == 1) {
                                            hidePregnancyInformation = false;
                                            hideSecondFormInformation = false;
                                          }

                                          // womenAgreementForParticipation=false;
                                          // womenAgreementTimeForParticipation=true;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(width: 20),
                                    Radio(
                                      value: 2,
                                      groupValue:
                                          participationWomenSelectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          participationWomenSelectedValue =
                                              value as int;
                                          _errorTextParticipationWomenSelectedValue =
                                              null;
                                          if (!hidePregnancyInformation)
                                            hidePregnancyInformation = true;
                                          if (!hideSecondFormInformation)
                                            hideSecondFormInformation = true;
                                          // womenAgreementForParticipation=true;
                                          // womenAgreementTimeForParticipation=false;
                                        });
                                      },
                                    ),
                                    Text('No', style: TextStyle(fontSize: 18)),
                                    SizedBox(width: 20),
                                    Radio(
                                      value: 3,
                                      groupValue:
                                          participationWomenSelectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          participationWomenSelectedValue =
                                              value as int;
                                          _errorTextParticipationWomenSelectedValue =
                                              null;
                                          if (!hidePregnancyInformation)
                                            hidePregnancyInformation = true;

                                          if (!hideSecondFormInformation)
                                            hideSecondFormInformation = true;

                                          if (consentWomenSelectedValue == 1) {
                                            hidePregnancyInformation = false;
                                            hideSecondFormInformation = false;
                                          }
                                          // womenAgreementForParticipation=false;
                                          // womenAgreementTimeForParticipation=true;
                                        });
                                      },
                                    ),
                                    Text('Need time to confirm',
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              if (counselingAtCenter)
                                if (_errorTextParticipationWomenSelectedValue !=
                                    null)
                                  Row(children: [
                                    SizedBox(width: 10),
                                    Text(
                                      _errorTextParticipationWomenSelectedValue!,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ]),

                              if (participationWomenSelectedValue == 2)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                ),
                              if (counselingAtCenter &&
                                  participationWomenSelectedValue == 2)
                                Row(
                                  children: [
                                    // give it width
                                    const Expanded(
                                        flex: 2,
                                        child: Text(
                                          "2.2a Reason",
                                          style: TextStyle(fontSize: 20),
                                        )
                                        //child: SizedBox(width: 90),
                                        ),
                                  ],
                                ),
                              if (counselingAtCenter &&
                                  participationWomenSelectedValue == 2)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                ),
                              if (counselingAtCenter &&
                                  participationWomenSelectedValue == 2)
                                TextFormField(
                                  controller: agreeParticipation,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return "Reason is required";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Reason",
                                      labelText: "Reason",
                                      labelStyle: const TextStyle(fontSize: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              if (counselingAtCenter ||
                                  participationWomenSelectedValue == 2)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                ),

                              Visibility(
                                visible: ((participationWomenSelectedValue == 3
                                        ? true
                                        : false) ||
                                    (participationWomenSelectedValue == 1
                                        ? true
                                        : false) ||
                                    (participationWomenSelectedValue == 2
                                        ? false
                                        : true)),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      // SizedBox(width: 10), // give it width
                                      // const Text(
                                      //   "Did the woman provide consent?",
                                      //   style: TextStyle(fontSize: 20),
                                      //
                                      // ),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "2.3 Did the woman provide consent?",
                                            style: TextStyle(fontSize: 20),
                                          )
                                          //child: SizedBox(width: 90),
                                          ),
                                      SizedBox(width: 90),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: consentWomenSelectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            consentWomenSelectedValue =
                                                value as int;
                                            hidePregnancyInformation = false;
                                            hideSecondFormInformation = false;
                                            _errorTextWomenConsent = null;
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: Text(
                                          'Yes, consented',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Radio(
                                        value: 2,
                                        groupValue: consentWomenSelectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            consentWomenSelectedValue =
                                                value as int;
                                            hidePregnancyInformation = true;
                                            hideSecondFormInformation = true;
                                            _errorTextWomenConsent = null;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text('Consent not provided yet',
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                      Radio(
                                        value: 3,
                                        groupValue: consentWomenSelectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            consentWomenSelectedValue =
                                                value as int;
                                            hidePregnancyInformation = true;
                                            hideSecondFormInformation = true;
                                            _errorTextWomenConsent = null;
                                            fifthAppointmentDate.clear();
                                            consentFifthWomenSelectedValue = 0;
                                            _errorTextWomenConsentFifthDay =
                                                null;
                                            tenthAppointmentDate.clear();
                                            consentTenthWomenSelectedValue = 0;
                                            _errorTextWomenConsentTenthDay =
                                                null;
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: Text('Refused',
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                    ],
                                  ),
                                  if (_errorTextWomenConsent != null)
                                    Row(children: [
                                      SizedBox(width: 10),
                                      Text(
                                        _errorTextWomenConsent!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ]),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  if (consentWomenSelectedValue == 3)
                                    Row(
                                      children: [
                                        // give it width
                                        const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "2.3a Reason:",
                                              style: TextStyle(fontSize: 20),
                                            )
                                            //child: SizedBox(width: 90),
                                            ),
                                      ],
                                    ),
                                  if (consentWomenSelectedValue == 3)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                    ),
                                  if (consentWomenSelectedValue == 3)
                                    TextFormField(
                                      controller: consentReason,
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return "Reason id required";
                                        else
                                          return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Reason",
                                          labelText: "Reason",
                                          labelStyle:
                                              const TextStyle(fontSize: 20),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                    ),
                                  if (consentWomenSelectedValue == 3)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                  Visibility(
                                    visible: ((consentWomenSelectedValue == 2
                                            ? true
                                            : false) &&
                                        (consentWomenSelectedValue == 1
                                            ? false
                                            : true) &&
                                        (consentWomenSelectedValue == 3
                                            ? false
                                            : true)),
                                    child: Column(children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                      ),
                                      Row(
                                        children: [
                                          // give it width
                                          const Expanded(
                                              flex: 2,
                                              child: Text(
                                                "2.4 Provide appointment for visit (5th day) Date of appointment",
                                                style: TextStyle(fontSize: 20),
                                              )
                                              //child: SizedBox(width: 90),
                                              ),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "Date of Appointment (5th Day) is required";
                                          else
                                            return null;
                                        },
                                        controller: fifthAppointmentDate,
                                        readOnly: true,
                                        // onTap: () => _selectFifthDate(context, fifthAppointmentDate),
                                        onTap: () => _selectRequiredDate(
                                            context,
                                            fifthAppointmentDate,
                                            0,
                                            5),

                                        decoration: InputDecoration(
                                          hintText:
                                              "Date of Appointment (5th Day) (*)",
                                          labelText:
                                              "Date of Appointment (5th Day) (*)",
                                          labelStyle:
                                              const TextStyle(fontSize: 20),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 10), // give it width
                                          Expanded(
                                            flex: 2,
                                            child: const Text(
                                              "2.5 Did the woman provide consent on the 5th day?",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(width: 90),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue:
                                                consentFifthWomenSelectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                consentFifthWomenSelectedValue =
                                                    value as int;
                                                hidePregnancyInformation =
                                                    false;
                                                hideSecondFormInformation =
                                                    false;
                                                _errorTextWomenConsentFifthDay =
                                                    null;
                                              });
                                            },
                                          ),
                                          Flexible(
                                            child: Text(
                                              'Yes, consented',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          Radio(
                                            value: 2,
                                            groupValue:
                                                consentFifthWomenSelectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                consentFifthWomenSelectedValue =
                                                    value as int;
                                                hidePregnancyInformation = true;
                                                hideSecondFormInformation =
                                                    true;
                                                _errorTextWomenConsentFifthDay =
                                                    null;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                'Consent not provided yet',
                                                style: TextStyle(fontSize: 18)),
                                          ),
                                          Radio(
                                            value: 3,
                                            groupValue:
                                                consentFifthWomenSelectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                consentFifthWomenSelectedValue =
                                                    value as int;
                                                hidePregnancyInformation = true;
                                                hideSecondFormInformation =
                                                    true;
                                                _errorTextWomenConsentFifthDay =
                                                    null;
                                              });
                                            },
                                          ),
                                          Flexible(
                                            child: Text('Refused',
                                                style: TextStyle(fontSize: 18)),
                                          ),
                                        ],
                                      ),
                                      if (_errorTextWomenConsentFifthDay !=
                                          null)
                                        Row(children: [
                                          SizedBox(width: 10),
                                          Text(
                                            _errorTextWomenConsentFifthDay!,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ]),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                      ),
                                      if (consentFifthWomenSelectedValue == 3)
                                        Row(
                                          children: [
                                            // give it width
                                            const Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "2.5a Reason",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )
                                                //child: SizedBox(width: 90),
                                                ),
                                          ],
                                        ),
                                      if (consentFifthWomenSelectedValue == 3)
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                        ),
                                      if (consentFifthWomenSelectedValue == 3)
                                        TextFormField(
                                          controller: consentFifthDayReason,
                                          validator: (value) {
                                            if (value!.isEmpty)
                                              return "Reason is Required";
                                            else
                                              return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: "Reason",
                                              labelText: "Reason",
                                              labelStyle:
                                                  const TextStyle(fontSize: 20),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                        ),
                                      if (consentFifthWomenSelectedValue == 3)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                        ),
                                      Visibility(
                                        visible: ((consentFifthWomenSelectedValue ==
                                                    2
                                                ? true
                                                : false) &&
                                            (consentFifthWomenSelectedValue == 1
                                                ? false
                                                : true) &&
                                            (consentFifthWomenSelectedValue == 3
                                                ? false
                                                : true)),
                                        child: Column(children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                          ),
                                          Row(
                                            children: [
                                              // give it width
                                              const Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "2.6 Provide appointment for visit (10th day) Date of appointment",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )
                                                  //child: SizedBox(width: 90),
                                                  ),
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty)
                                                return "Date of Appointment (10th Day) required";
                                              else
                                                return null;
                                            },
                                            controller: tenthAppointmentDate,
                                            readOnly: true,
                                            onTap: () => _selectTenthDate(
                                                context, tenthAppointmentDate),
                                            // onTap: () => _selectRequiredDate(
                                            //     context, tenthAppointmentDate, 0, 11),

                                            decoration: InputDecoration(
                                              hintText:
                                                  "Date of Appointment (10th Day) (*)",
                                              labelText:
                                                  "Date of Appointment (10th Day) (*)",
                                              labelStyle:
                                                  const TextStyle(fontSize: 20),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 10),
                                              // give it width
                                              Expanded(
                                                flex: 2,
                                                child: const Text(
                                                  "2.7 Did the woman provide consent on the 10th day?",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                              SizedBox(width: 90),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 1,
                                                groupValue:
                                                    consentTenthWomenSelectedValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    consentTenthWomenSelectedValue =
                                                        value as int;
                                                    hidePregnancyInformation =
                                                        false;
                                                    hideSecondFormInformation =
                                                        false;
                                                    _errorTextWomenConsentTenthDay =
                                                        null;
                                                  });
                                                },
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Yes, consented',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Radio(
                                                value: 2,
                                                groupValue:
                                                    consentTenthWomenSelectedValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    consentTenthWomenSelectedValue =
                                                        value as int;
                                                    hidePregnancyInformation =
                                                        true;
                                                    hideSecondFormInformation =
                                                        true;
                                                    _errorTextWomenConsentTenthDay =
                                                        null;
                                                  });
                                                },
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text('Not on this day',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ),
                                              Radio(
                                                value: 3,
                                                groupValue:
                                                    consentTenthWomenSelectedValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    consentTenthWomenSelectedValue =
                                                        value as int;
                                                    hidePregnancyInformation =
                                                        true;
                                                    hideSecondFormInformation =
                                                        true;
                                                    _errorTextWomenConsentTenthDay =
                                                        null;
                                                  });
                                                },
                                              ),
                                              Flexible(
                                                child: Text('Refused',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ),
                                            ],
                                          ),
                                          if (_errorTextWomenConsentTenthDay !=
                                              null)
                                            Row(children: [
                                              SizedBox(width: 10),
                                              Text(
                                                _errorTextWomenConsentTenthDay!,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ]),
                                          if (consentTenthWomenSelectedValue ==
                                              3)
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                            ),
                                          if (consentTenthWomenSelectedValue ==
                                              3)
                                            Row(
                                              children: [
                                                // give it width
                                                const Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      "2.7a Reason",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )
                                                    //child: SizedBox(width: 90),
                                                    ),
                                              ],
                                            ),
                                          if (consentTenthWomenSelectedValue ==
                                              3)
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                            ),
                                          if (consentTenthWomenSelectedValue ==
                                              3)
                                            TextFormField(
                                              controller: consentTenthDayReason,
                                              validator: (value) {
                                                if (value!.isEmpty)
                                                  return "Reason is required";
                                                else
                                                  return null;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Reason(*)",
                                                  labelText: "Reason(*)",
                                                  labelStyle: const TextStyle(
                                                      fontSize: 20),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))),
                                            ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                          ),
                                        ]),
                                      ),
                                    ]),
                                  ),
                                ]),
                              ),

                              Visibility(
                                visible: !hidePregnancyInformation,
                                child: Column(children: [
                                  const Text(
                                    'PREGNANCY INFORMATION',
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurpleAccent),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  Column(children: [
                                    Row(
                                      children: [
                                        // SizedBox(width: 10), // give it width
                                        const Expanded(
                                          flex: 2,
                                          child: const Text(
                                            "3.1 Is the pregnant women enrolled in PRISMA Study?",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(width: 10), // give it width

                                        // Checkbox(
                                        //   value: pregnantWomenEnrolled,
                                        //   onChanged: (value) {
                                        //     setState(() {
                                        //       pregnantWomenEnrolled =
                                        //           !pregnantWomenEnrolled;
                                        //     });
                                        //   },
                                        // ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                              value: 1,
                                              groupValue:
                                                  pregnantWomenEnrolledRB,
                                              onChanged: (value) {
                                                setState(() {
                                                  pregnantWomenEnrolledRB =
                                                      value as int;
                                                  if (pregnantWomenEnrolledRB ==
                                                      1) {
                                                    pregnantWomenEnrolled =
                                                        true;
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Yes',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio(
                                              value: 2,
                                              groupValue:
                                                  pregnantWomenEnrolledRB,
                                              onChanged: (value) {
                                                setState(() {
                                                  pregnantWomenEnrolledRB =
                                                      value as int;
                                                  if (pregnantWomenEnrolledRB ==
                                                      2) {
                                                    pregnantWomenEnrolled =
                                                        false;
                                                  }
                                                });
                                              },
                                            ),
                                            const Text('No',
                                                style: TextStyle(fontSize: 18)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                                  if (pregnantWomenEnrolled)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  if (pregnantWomenEnrolled)
                                    Row(
                                      children: [
                                        // give it width
                                        const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "3.2 PRISMA Study enroll date",
                                              style: TextStyle(fontSize: 20),
                                            )
                                            //child: SizedBox(width: 90),
                                            ),
                                      ],
                                    ),
                                  if (pregnantWomenEnrolled)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  if (pregnantWomenEnrolled)
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return "PRISMA Study Enroll Date required";
                                        else
                                          return null;
                                      },
                                      controller: prismaStudyEnrolDate,
                                      readOnly: true,
                                      //onTap: () => _selectDate(context, prismaStudyEnrolDate),
                                      onTap: () => _selectRequiredDate(context,
                                          prismaStudyEnrolDate, 38 * 7, 0),

                                      decoration: InputDecoration(
                                        hintText: "PRISMA Study Enroll Date",
                                        labelText: "PRISMA Study Enroll Date",
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  if (pregnantWomenEnrolled)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  if (pregnantWomenEnrolled)
                                    Column(children: [
                                      Row(
                                        children: [
                                          // SizedBox(width: 10), // give it width
                                          Expanded(
                                            flex: 2,
                                            child: const Text(
                                              "3.3 Have the lab samples been collected?",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(width: 120),
                                          // give it width

                                          // Checkbox(
                                          //   value: labSamplesCollected,
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       labSamplesCollected =
                                          //           !labSamplesCollected;
                                          //     });
                                          //   },
                                          // ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                value: 1,
                                                groupValue:
                                                    labSamplesCollectedRB,
                                                onChanged: (value) {
                                                  setState(() {
                                                    labSamplesCollectedRB =
                                                        value as int;
                                                    if (labSamplesCollectedRB ==
                                                        1) {
                                                      labSamplesCollected =
                                                          true;
                                                    }
                                                  });
                                                },
                                              ),
                                              const Text(
                                                'Yes',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 2,
                                                groupValue:
                                                    labSamplesCollectedRB,
                                                onChanged: (value) {
                                                  setState(() {
                                                    labSamplesCollectedRB =
                                                        value as int;
                                                    if (labSamplesCollectedRB ==
                                                        2) {
                                                      labSamplesCollected =
                                                          false;
                                                    }
                                                  });
                                                },
                                              ),
                                              const Text('No',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ]),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  Column(children: [
                                    Row(
                                      children: [
                                        // SizedBox(width: 10), // give it width
                                        Expanded(
                                          flex: 2,
                                          child: const Text(
                                            "3.4 Has the ultrasound been done?",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(width: 180),
                                        // give it width

                                        // Checkbox(
                                        //   value: ultrasoundDone,
                                        //   onChanged: (value) {
                                        //     setState(() {
                                        //       ultrasoundDone = !ultrasoundDone;
                                        //       if (!ultrasoundDone) {
                                        //         ultraSoundDate.clear();
                                        //         lMPDate.clear();
                                        //         eDD.clear();
                                        //         weeks.text = "";
                                        //         days.text = "";
                                        //       } else {
                                        //         nextUltrasoundDate.clear();
                                        //       }
                                        //     });
                                        //   },
                                        // ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                              value: 1,
                                              groupValue: ultrasoundDoneRB,
                                              onChanged: (value) {
                                                setState(() {
                                                  ultrasoundDoneRB =
                                                      value as int;
                                                  if (ultrasoundDoneRB == 1) {
                                                    ultrasoundDone = true;
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Yes',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio(
                                              value: 2,
                                              groupValue: ultrasoundDoneRB,
                                              onChanged: (value) {
                                                setState(() {
                                                  ultrasoundDoneRB =
                                                      value as int;
                                                  if (ultrasoundDoneRB == 2) {
                                                    ultrasoundDone = false;
                                                  }
                                                });
                                              },
                                            ),
                                            const Text('No',
                                                style: TextStyle(fontSize: 18)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                                  if (ultrasoundDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  if (ultrasoundDone)
                                    Row(
                                      children: [
                                        // give it width
                                        const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "3.5 Ultrasound Date",
                                              style: TextStyle(fontSize: 20),
                                            )
                                            //child: SizedBox(width: 90),
                                            ),
                                      ],
                                    ),
                                  if (ultrasoundDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                    ),
                                  if (ultrasoundDone)
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return "Ultrasound Date required";
                                        else
                                          return null;
                                      },
                                      controller: ultraSoundDate,
                                      readOnly: true,
                                      //onTap: () => _selectLMPDate(context, ultraSoundDate),
                                      onTap: () => _selectRequiredDate(
                                          context, ultraSoundDate, 38 * 7, 0),

                                      decoration: InputDecoration(
                                        hintText: "Ultrasound Date",
                                        labelText: "Ultrasound Date",
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  if (ultrasoundDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                  if (ultrasoundDone)
                                    Row(
                                      children: [
                                        // give it width
                                        const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "3.6 LMP Date",
                                              style: TextStyle(fontSize: 20),
                                            )
                                            //child: SizedBox(width: 90),
                                            ),
                                      ],
                                    ),
                                  if (ultrasoundDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                    ),
                                  if (ultrasoundDone)
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return "LMP Date is required";
                                        else
                                          return null;
                                      },
                                      controller: lMPDate,
                                      readOnly: true,
                                      onTap: () =>
                                          _selectLMPDate(context, lMPDate),
                                      //onTap: () => _selectRequiredDate(context, lMPDate,38*7,0),

                                      decoration: InputDecoration(
                                        hintText: "LMP Date",
                                        labelText: "LMP Date",
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  if (ultrasoundDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                  if (ultrasoundDone)
                                    Row(
                                      children: [
                                        // give it width
                                        const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "3.7 EDD Date",
                                              style: TextStyle(fontSize: 20),
                                            )
                                            //child: SizedBox(width: 90),
                                            ),
                                      ],
                                    ),
                                  if (ultrasoundDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                    ),
                                  if (ultrasoundDone)
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return "EDD is required";
                                        else
                                          return null;
                                      },
                                      controller: eDD,
                                      readOnly: true,
                                      //onTap: () => _selectEDDDate(context, eDD),
                                      // onTap: () =>
                                      //     _selectRequiredDate(context, eDD, 0, 270),
                                      onTap: () => _selectDateOnFieldBasis(
                                          context, eDD, lMPDate, 280, 294),

                                      decoration: InputDecoration(
                                        hintText: "EDD",
                                        labelText: "EDD",
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  if (ultrasoundDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                  if (ultrasoundDone)
                                    Row(
                                      children: [
                                        // SizedBox(width: 10), // give it width

                                        const Text(
                                          "3.8 (If yes) Gestational week according to ultrasound",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  if (ultrasoundDone)
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 5),
                                                child: Text(
                                                  "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                controller: weeks,
                                                readOnly: true,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Weeks",
                                                  labelText: "Weeks",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 5),
                                                child: Text(
                                                  "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                controller: days,
                                                readOnly: true,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Days",
                                                  labelText: "Days",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!ultrasoundDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  if (!ultrasoundDone)
                                    Row(
                                      children: const [
                                        // SizedBox(width: 10), // give it width
                                        const Expanded(
                                          flex: 2,
                                          child: Text(
                                            "3.9 If ultrasound is not done due to any reason, next scheduled ultrasound date? ",
                                            style: TextStyle(fontSize: 20),
                                            // softWrap: false,
                                            // maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  // if (!ultrasoundDone)
                                  //   Row(
                                  //     children: const [
                                  //       SizedBox(width: 10), // give it width
                                  //
                                  //       Text(
                                  //         "ultrasound date? ",
                                  //         style: TextStyle(fontSize: 20),
                                  //       ),
                                  //     ],
                                  //   ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  if (!ultrasoundDone)
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return "Next Ultrasound Date is required";
                                        else
                                          return null;
                                      },
                                      controller: nextUltrasoundDate,
                                      readOnly: true,
                                      //onTap: () => _selectDate(context, nextUltrasoundDate),
                                      onTap: () => _selectRequiredDate(
                                          context, nextUltrasoundDate, 0, 270),

                                      decoration: InputDecoration(
                                        hintText: "Next Ultrasound Date (*)",
                                        labelText: "Next Ultrasound Date(*)",
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),
                                  Row(
                                    children: [
                                      // give it width
                                      const Expanded(
                                          flex: 2,
                                          child: Text(
                                            "3.10 Provide CTU 1 Visit Date",
                                            style: TextStyle(fontSize: 20),
                                          )
                                          //child: SizedBox(width: 90),
                                          ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "CTU 1 Visit Date is required";
                                      else
                                        return null;
                                    },
                                    controller: ctu1VisitDate,
                                    readOnly: true,
                                    //onTap: () => _selectDate(context, ctu1VisitDate),
                                    onTap: () => _selectRequiredDate(
                                        context, ctu1VisitDate, 0, 7),

                                    decoration: InputDecoration(
                                      hintText: "CTU 1 Visit Date (*)",
                                      labelText: "CTU 1 Visit Date(*)",
                                      labelStyle: const TextStyle(fontSize: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  Row(
                                    children: const [
                                      SizedBox(width: 10),
                                      // give it width

                                      // Text(
                                      //   "Note: Lab must be done at time of visit or in 7days time.",
                                      //   style: TextStyle(fontSize: 20),
                                      //   softWrap: false,
                                      //   maxLines: 1,
                                      // ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),
                                  Row(
                                    children: [
                                      // give it width
                                      const Expanded(
                                          flex: 2,
                                          child: Text(
                                            "3.11 Date of Lab results",
                                            style: TextStyle(fontSize: 20),
                                          )
                                          //child: SizedBox(width: 90),
                                          ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "Date of Lab results is required";
                                      else
                                        return null;
                                    },
                                    controller: dateOfLabResults,
                                    readOnly: true,
                                    //onTap: () => _selectDate(context, dateOfLabResults),
                                    // onTap: () => _selectRequiredDate(
                                    //     context, dateOfLabResults, 0, 270),
                                    onTap: () => {
                                      if (ctu1VisitDate.text != null ||
                                          ctu1VisitDate.text != "")
                                        {
                                          _selectDateOnFieldBasis(
                                              context,
                                              dateOfLabResults,
                                              ctu1VisitDate,
                                              0,
                                              1)
                                        }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Date of Lab results (*)",
                                      labelText: "Date of Lab results (*)",
                                      labelStyle: const TextStyle(fontSize: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),
                                  Row(
                                    children: [
                                      // give it width
                                      const Expanded(
                                          flex: 2,
                                          child: Text(
                                            "3.12 Provide Prescreening Visit Date",
                                            style: TextStyle(fontSize: 20),
                                          )
                                          //child: SizedBox(width: 90),
                                          ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "Prescreening Visit Date is required";
                                      else
                                        return null;
                                    },
                                    controller: prescreeningVisitDate,
                                    readOnly: true,
                                    //onTap: () => _selectEDDDate(context, prescreeningVisitDate),
                                    // onTap: () => _selectRequiredDate(
                                    //     context, prescreeningVisitDate, 0, 270),
                                    onTap: () => _selectDateOnFieldBasis(
                                        context,
                                        prescreeningVisitDate,
                                        ctu1VisitDate,
                                        1,
                                        3),

                                    decoration: InputDecoration(
                                      hintText: "Prescreening Visit Date (*)",
                                      labelText: "Prescreening Visit Date (*)",
                                      labelStyle: const TextStyle(fontSize: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),
                                ]),
                              ),
                              // RoundButton(
                              //     loading: loading,
                              //     title: "Submit",
                              //     onTap: () async {
                              //       setState(() {
                              //         //_autovalidateMode = AutovalidateMode.always;
                              //         loading = true;
                              //       });
                              //
                              //       if (_formKey.currentState != null &&
                              //           _formKey.currentState!.validate() &&
                              //           _errorTextParticipationWomenSelectedValue ==
                              //               null &&
                              //           _errorTextWomenConsent == null &&
                              //           _errorTextWomenConsentFifthDay == null &&
                              //           _errorTextWomenConsentTenthDay == null) {
                              //         await SaveAllInformation();
                              //       } else {
                              //         SetRadioButtonErrors();
                              //       }
                              //     }
                              //     //},
                              //     ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),

                              // RoundButton(
                              //   title: "Logout",
                              //   onTap: () {
                              //    // logOut();
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        Form(
                          key: _dateOfVisitFormKey,
                          autovalidateMode: _autovalidateMode,
                          child: Column(
                            children: [
                              Visibility(
                                visible: !hideSecondFormInformation,
                                child: Column(children: [
                                  // Baseline Characteristics Heading
                                  const Text(
                                    'BASELINE CHARACTERISTICS',
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurpleAccent),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),

                                  // Baseline Characteristics
                                  // Height
                                  TextFormField(
                                    focusNode: participantHeightFocus,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,

                                    validator: validateParticipantHeight,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'[^0-9\.]')),
                                      // Limit the input to 5 characters
                                    ],
                                    // keyboardType: TextInputType.number,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    controller: participantHeight,

                                    onChanged: (_) => calculateBMIAndUpdate(),
                                    decoration: InputDecoration(
                                      hintText: "Participant Height (cm) (*)",
                                      labelText: "Participant Height (cm) (*)",
                                      labelStyle: const TextStyle(fontSize: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  // Weight
                                  TextFormField(
                                    focusNode: participantWeightFocus,
                                    validator: validateParticipantWeight,
                                    //keyboardType: TextInputType.number,

                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      //FilteringTextInputFormatter.digitsOnly,
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'[^0-9\.]')),
                                    ],
                                    // keyboardType: TextInputType.number,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),

                                    controller: participantWeight,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,

                                    onChanged: (_) => calculateBMIAndUpdate(),
                                    decoration: InputDecoration(
                                      hintText: "Participant Weight (kg) (*)",
                                      labelText: "Participant Weight (kg) (*)",
                                      labelStyle: const TextStyle(fontSize: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  // BMI
                                  TextFormField(
                                    readOnly: true,
                                    controller: bmiController,
                                    decoration: InputDecoration(
                                      hintText: "BMI ",
                                      labelText: "BMI ",
                                      labelStyle: const TextStyle(fontSize: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),

                                  // Medical History Heading
                                  const Text(
                                    'MEDICAL HISTORY',
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurpleAccent),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),

                                  // Medical History
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Are there any significant diseases, clinically significant medical conditions, abnormal (name of diagnosis) and history of surgery that are ever occurred to the participants prior to the signed informed consent?",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue: hasMedicalHistory,
                                            onChanged: (value) {
                                              setState(() {
                                                hasMedicalHistory =
                                                    value as int;
                                                hasSelectedMedicalHistory =
                                                    true;
                                                _errorTextHasSelectedMedicalHistory =
                                                    null;
                                              });
                                            },
                                          ),
                                          const Text("Yes",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue: hasMedicalHistory,
                                            onChanged: (value) {
                                              setState(() {
                                                hasMedicalHistory =
                                                    value as int;
                                                hasSelectedMedicalHistory =
                                                    true;
                                                _errorTextHasSelectedMedicalHistory =
                                                    null;
                                              });
                                            },
                                          ),
                                          const Text("No",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: hasMedicalHistory == 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  medicalHistoryDiseaseNameController,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    200)
                                              ],
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Name of disease / surgery",
                                                labelText:
                                                    "Name of disease / surgery",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (hasSelectedMedicalHistory &&
                                                    hasMedicalHistory == 1 &&
                                                    value!.isEmpty) {
                                                  return "Enter the name of the disease";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                      ),
                                      if (!hideSecondFormInformation)
                                        if (_errorTextHasSelectedMedicalHistory !=
                                            null)
                                          Row(children: [
                                            SizedBox(width: 10),
                                            Text(
                                              _errorTextHasSelectedMedicalHistory!,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ]),
                                    ],
                                  ),

                                  // Substance Use History Heading
                                  const Text(
                                    'SUBSTANCE USE HISTORY ',
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurpleAccent),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),

                                  // Substance Use

                                  // TOBACCO USE
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Tobacco Use",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue: tobaccoUsage,
                                            onChanged: (value) {
                                              setState(() {
                                                tobaccoUsage = value as int;
                                                hasSelectedTobaccoUsage = true;
                                                _errorTextHasSelectedTobaccoUse =
                                                    null;
                                                // if (!isPhysicalExamPerformed) {
                                                //   isSameAsVisitDate = false;
                                                // }
                                              });
                                            },
                                          ),
                                          const Text("Yes",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue: tobaccoUsage,
                                            onChanged: (value) {
                                              setState(() {
                                                tobaccoUsage = value as int;
                                                hasSelectedTobaccoUsage = true;
                                                _errorTextHasSelectedTobaccoUse =
                                                    null;
                                              });
                                            },
                                          ),
                                          const Text("No",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      if (!hideSecondFormInformation)
                                        if (_errorTextHasSelectedTobaccoUse !=
                                            null)
                                          Row(children: [
                                            SizedBox(width: 10),
                                            Text(
                                              _errorTextHasSelectedTobaccoUse!,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ]),
                                      Visibility(
                                        visible: ((hasSelectedTobaccoUsage &&
                                                    tobaccoUsage == 1
                                                ? true
                                                : false) &&
                                            (hasSelectedTobaccoUsage &&
                                                    tobaccoUsage == 2
                                                ? false
                                                : true)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Do you currently use tobacco or tobacco products?",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 1,
                                                            groupValue:
                                                                currenttobaccoUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currenttobaccoUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentTobaccoUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text('Daily',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 2,
                                                            groupValue:
                                                                currenttobaccoUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currenttobaccoUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentTobaccoUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text(
                                                              'Less than daily',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 3,
                                                            groupValue:
                                                                currenttobaccoUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currenttobaccoUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentTobaccoUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text('No',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 4,
                                                            groupValue:
                                                                currenttobaccoUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currenttobaccoUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentTobaccoUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text('Never',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 5,
                                                            groupValue:
                                                                currenttobaccoUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currenttobaccoUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentTobaccoUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              'Decline to Answer',
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (_errorCurrentTobaccoUsageSelectedValue !=
                                                null)
                                              Row(children: [
                                                const SizedBox(width: 10),
                                                Text(
                                                  _errorCurrentTobaccoUsageSelectedValue!,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ]),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    ],
                                  ),
                                  // ALCOHOL USE
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Alcohol Use",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue: alcoholUsage,
                                            onChanged: (value) {
                                              setState(() {
                                                alcoholUsage = value as int;
                                                hasSelectedAlcoholUsage = true;
                                                _errorTextHasSelectedAlcoholUse =
                                                    null;
                                                // if (!isPhysicalExamPerformed) {
                                                //   isSameAsVisitDate = false;
                                                // }
                                              });
                                            },
                                          ),
                                          const Text("Yes",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue: alcoholUsage,
                                            onChanged: (value) {
                                              setState(() {
                                                alcoholUsage = value as int;
                                                hasSelectedAlcoholUsage = true;
                                                _errorTextHasSelectedAlcoholUse =
                                                    null;
                                              });
                                            },
                                          ),
                                          const Text("No",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: ((hasSelectedAlcoholUsage &&
                                                    alcoholUsage == 1
                                                ? true
                                                : false) &&
                                            (hasSelectedAlcoholUsage &&
                                                    alcoholUsage == 2
                                                ? false
                                                : true)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Do you currently consume drinks containing alcohol?",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 1,
                                                            groupValue:
                                                                currentalcoholUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currentalcoholUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentAlcoholUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text('Daily',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 2,
                                                            groupValue:
                                                                currentalcoholUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currentalcoholUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentAlcoholUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text(
                                                              'Several times a week',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 3,
                                                            groupValue:
                                                                currentalcoholUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currentalcoholUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentAlcoholUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text(
                                                              'Several times a month',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 4,
                                                            groupValue:
                                                                currentalcoholUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currentalcoholUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentAlcoholUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text('No',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 5,
                                                            groupValue:
                                                                currentalcoholUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currentalcoholUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentAlcoholUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text('Never',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: 6,
                                                            groupValue:
                                                                currentalcoholUsageSelectedValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currentalcoholUsageSelectedValue =
                                                                    value
                                                                        as int;
                                                                _errorCurrentAlcoholUsageSelectedValue =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                          const Text(
                                                              'Decline to Answer',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (_errorCurrentAlcoholUsageSelectedValue !=
                                                null)
                                              Row(children: [
                                                const SizedBox(width: 10),
                                                Text(
                                                  _errorCurrentAlcoholUsageSelectedValue!,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ]),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!hideSecondFormInformation)
                                        if (_errorTextHasSelectedAlcoholUse !=
                                            null)
                                          Row(children: [
                                            SizedBox(width: 10),
                                            Text(
                                              _errorTextHasSelectedAlcoholUse!,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ]),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),

                                  // Obstetric History  Heading
                                  const Text(
                                    'OBSTETRIC HISTORY',
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurpleAccent),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),
// Obstetric History
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Did you have any previous pregnancy?",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue:
                                                haveAnyPrevPregObstetricHist,
                                            onChanged: (value) {
                                              setState(() {
                                                haveAnyPrevPregObstetricHist =
                                                    value as int;
                                                _errorTextHaveAnyPrevPregObstetricHist =
                                                    null;
                                                selectedHaveAnyPrevPregObstetricHist =
                                                    true;
                                              });
                                            },
                                          ),
                                          const Text("Yes",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue:
                                                haveAnyPrevPregObstetricHist,
                                            onChanged: (value) {
                                              setState(() {
                                                haveAnyPrevPregObstetricHist =
                                                    value as int;
                                                _errorTextHaveAnyPrevPregObstetricHist =
                                                    null;
                                                selectedHaveAnyPrevPregObstetricHist =
                                                    true;
                                              });
                                            },
                                          ),
                                          const Text("No",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 3,
                                            groupValue:
                                                haveAnyPrevPregObstetricHist,
                                            onChanged: (value) {
                                              setState(() {
                                                haveAnyPrevPregObstetricHist =
                                                    value as int;
                                                _errorTextHaveAnyPrevPregObstetricHist =
                                                    null;
                                                selectedHaveAnyPrevPregObstetricHist =
                                                    true;
                                              });
                                            },
                                          ),
                                          const Text("Unknown",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: ((selectedHaveAnyPrevPregObstetricHist &&
                                                    haveAnyPrevPregObstetricHist ==
                                                        1
                                                ? true
                                                : false) &&
                                            (selectedHaveAnyPrevPregObstetricHist &&
                                                    haveAnyPrevPregObstetricHist ==
                                                        2
                                                ? false
                                                : true)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // No of past preg
                                            TextFormField(
                                              controller:
                                                  obstetricHistoryNoOfPastPregController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    2),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Number of past pregnancies",
                                                labelText:
                                                    "Number of past pregnancies",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Number of past pregnancies is required";
                                                }
                                                return null; // Validation success
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7),
                                            ),
                                            // Any abortion
                                            const Text(
                                              "Any Abortion?",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7),
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 1,
                                                  groupValue:
                                                      obstetricHistAnyAbortion,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      obstetricHistAnyAbortion =
                                                          value as int;
                                                      _errorTextObstetricHistAnyAbortion =
                                                          null;
                                                      selectedObstetricHistAnyAbortion =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                const Text("Yes",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 2,
                                                  groupValue:
                                                      obstetricHistAnyAbortion,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      obstetricHistAnyAbortion =
                                                          value as int;
                                                      _errorTextObstetricHistAnyAbortion =
                                                          null;
                                                      selectedObstetricHistAnyAbortion =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                const Text("No",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 3,
                                                  groupValue:
                                                      obstetricHistAnyAbortion,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      obstetricHistAnyAbortion =
                                                          value as int;
                                                      _errorTextObstetricHistAnyAbortion =
                                                          null;
                                                      selectedObstetricHistAnyAbortion =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                const Text("Unknown",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                            Visibility(
                                              visible: ((selectedParticipantEligibleInClinicalTrial &&
                                                          isParticipantEligibleInClinicalTrial ==
                                                              1 &&
                                                          obstetricHistAnyAbortion ==
                                                              1
                                                      ? true
                                                      : false) &&
                                                  (selectedParticipantEligibleInClinicalTrial &&
                                                          isParticipantEligibleInClinicalTrial ==
                                                              2 &&
                                                          obstetricHistAnyAbortion ==
                                                              2
                                                      ? false
                                                      : true)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        obstetricHistoryNoOfAbortionController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          2),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Number of abortions",
                                                      labelText:
                                                          "Number of abortions",
                                                      labelStyle:
                                                          const TextStyle(
                                                              fontSize: 20),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Number of abortions is required";
                                                      }
                                                      return null; // Validation success
                                                    },
                                                  ),

                                                  // if (_errorTextIsVisitOneTwoSameDay !=
                                                  //     null)
                                                  //   Row(children: [
                                                  //     const SizedBox(width: 10),
                                                  //     Text(
                                                  //       _errorTextIsVisitOneTwoSameDay!,
                                                  //       style: TextStyle(color: Colors.red),
                                                  //     ),
                                                  //   ]),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7),
                                            ),
                                            // Any deliveries
                                            const Text(
                                              "Any Deliveries?",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7),
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 1,
                                                  groupValue:
                                                      obstetricHistAnyDelivery,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      obstetricHistAnyDelivery =
                                                          value as int;
                                                      _errorTextObstetricHistAnyDelivery =
                                                          null;
                                                      selectedObstetricHistAnyDelivery =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                const Text("Yes",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 2,
                                                  groupValue:
                                                      obstetricHistAnyDelivery,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      obstetricHistAnyDelivery =
                                                          value as int;
                                                      _errorTextObstetricHistAnyDelivery =
                                                          null;
                                                      selectedObstetricHistAnyDelivery =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                const Text("No",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 3,
                                                  groupValue:
                                                      obstetricHistAnyDelivery,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      obstetricHistAnyDelivery =
                                                          value as int;
                                                      _errorTextObstetricHistAnyDelivery =
                                                          null;
                                                      selectedObstetricHistAnyDelivery =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                const Text("Unknown",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                            Visibility(
                                              visible: ((selectedParticipantEligibleInClinicalTrial &&
                                                          isParticipantEligibleInClinicalTrial ==
                                                              1 &&
                                                          obstetricHistAnyDelivery ==
                                                              1
                                                      ? true
                                                      : false) &&
                                                  (selectedParticipantEligibleInClinicalTrial &&
                                                          isParticipantEligibleInClinicalTrial ==
                                                              2 &&
                                                          obstetricHistAnyDelivery ==
                                                              2
                                                      ? false
                                                      : true)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        obstetricHistoryNoOfDeliveryController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          2),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Number of deliveries",
                                                      labelText:
                                                          "Number of deliveries",
                                                      labelStyle:
                                                          const TextStyle(
                                                              fontSize: 20),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Number of deliveries is required";
                                                      }
                                                      return null; // Validation success
                                                    },
                                                  ),

                                                  // if (_errorTextIsVisitOneTwoSameDay !=
                                                  //     null)
                                                  //   Row(children: [
                                                  //     const SizedBox(width: 10),
                                                  //     Text(
                                                  //       _errorTextIsVisitOneTwoSameDay!,
                                                  //       style: TextStyle(color: Colors.red),
                                                  //     ),
                                                  //   ]),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            if (_errorTextObstetricHistAnyAbortion !=
                                                null)
                                              Row(children: [
                                                const SizedBox(width: 10),
                                                Text(
                                                  _errorTextObstetricHistAnyAbortion!,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ]),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                            ),
                                            if (_errorTextObstetricHistAnyDelivery !=
                                                null)
                                              Row(children: [
                                                const SizedBox(width: 10),
                                                Text(
                                                  _errorTextObstetricHistAnyDelivery!,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ]),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!hideSecondFormInformation)
                                        if (_errorTextHaveAnyPrevPregObstetricHist !=
                                            null)
                                          Row(children: [
                                            SizedBox(width: 10),
                                            Text(
                                              _errorTextHaveAnyPrevPregObstetricHist!,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ]),
                                    ],
                                  ),

                                  // Prenatal information (for current pregnancy) Heading
                                  const Text(
                                    'PRENATAL INFORMATION (for current pregnancy)',
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurpleAccent),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),
                                  // Prenatal information (for current pregnancy)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Was prenatal information collected?",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue:
                                                isPrenatalInformationCollected,
                                            onChanged: (value) {
                                              setState(() {
                                                isPrenatalInformationCollected =
                                                    value as int;
                                                _errorTextHasSelectedPrenatalInformation =
                                                    null;

                                                hasSelectedPrenatalInformation =
                                                    true;
                                                if (hasSelectedPrenatalInformation &&
                                                    isPrenatalInformationCollected ==
                                                        1) {
                                                  reasonNotPrenatalInfoCollected =
                                                      '';
                                                }
                                              });
                                            },
                                          ),
                                          const Text("Yes",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue:
                                                isPrenatalInformationCollected,
                                            onChanged: (value) {
                                              setState(() {
                                                isPrenatalInformationCollected =
                                                    value as int;
                                                _errorTextHasSelectedPrenatalInformation =
                                                    null;
                                                hasSelectedPrenatalInformation =
                                                    true;
                                                if (hasSelectedPrenatalInformation &&
                                                    isPrenatalInformationCollected ==
                                                        2) {
                                                  reasonNotPrenatalInfoCollected =
                                                      '';
                                                  prenatalCareLocation =
                                                      null; // Reset the dropdown selection when "No" is selected
                                                }
                                              });
                                            },
                                          ),
                                          const Text("No",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: ((hasSelectedPrenatalInformation &&
                                                    isPrenatalInformationCollected ==
                                                        2
                                                ? true
                                                : false) &&
                                            (hasSelectedPrenatalInformation &&
                                                    isPrenatalInformationCollected ==
                                                        1
                                                ? false
                                                : true)),
                                        child: TextFormField(
                                          controller:
                                              prenatalReasonNotCollectedController,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                200),
                                          ],
                                          decoration: InputDecoration(
                                            hintText: "Reason not collected",
                                            labelText: "Reason not collected",
                                            labelStyle:
                                                const TextStyle(fontSize: 20),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              reasonNotPrenatalInfoCollected =
                                                  value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Reason is required";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: ((hasSelectedPrenatalInformation &&
                                                    isPrenatalInformationCollected ==
                                                        1
                                                ? true
                                                : false) &&
                                            (hasSelectedPrenatalInformation &&
                                                    isPrenatalInformationCollected ==
                                                        2
                                                ? false
                                                : true)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Where is the prenatal care done?",
                                                  labelText:
                                                      "Where is the prenatal care done?",
                                                  labelStyle: const TextStyle(
                                                      fontSize: 20),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                value: prenatalCareLocation,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    prenatalCareLocation =
                                                        newValue;
                                                  });
                                                },
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: "Ali Akbar Shah",
                                                    child:
                                                        Text("Ali Akbar Shah"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Bhains Colony",
                                                    child:
                                                        Text("Bhains Colony"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Ibrahim Hydari",
                                                    child:
                                                        Text("Ibrahim Hydari"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Rehri Goth",
                                                    child: Text("Rehri Goth"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value:
                                                        "AKUH-Stadium road campus",
                                                    child: Text(
                                                        "AKUH-Stadium road campus"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "AKUHAKH Kharadar",
                                                    child: Text(
                                                        "AKUHAKH Kharadar"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "AKUHAKH Garden",
                                                    child:
                                                        Text("AKUHAKH Garden"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "AKUHAKH Karimabad",
                                                    child: Text(
                                                        "AKUHAKH Karimabad"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Other",
                                                    child: Text("Other"),
                                                  ),
                                                ],
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                              ),
                                              if (prenatalCareLocation ==
                                                  "Other")
                                                TextFormField(
                                                  controller:
                                                      prenatalOtherCareController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "If Other, please specify",
                                                    labelText:
                                                        "If Other, please specify",
                                                    labelStyle: const TextStyle(
                                                        fontSize: 20),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      otherPrenatalCareLocation =
                                                          value;
                                                    });
                                                  },
                                                ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                              ),
                                              TextFormField(
                                                controller:
                                                    prenatalCareDateController,
                                                readOnly: true,
                                                onTap: () => _selectRequiredDate(
                                                    context,
                                                    prenatalCareDateController,
                                                    7,
                                                    0),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Date of prenatal care done",
                                                  labelText:
                                                      "Date of prenatal care done",
                                                  labelStyle: const TextStyle(
                                                      fontSize: 20),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Prenatal date is required";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                              ),
                                              TextFormField(
                                                controller:
                                                    prenatalUltrasonographDateController,
                                                readOnly: true,
                                                onTap: () => _selectRequiredDate(
                                                    context,
                                                    prenatalUltrasonographDateController,
                                                    7,
                                                    0),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Date of ultrasonograph done",
                                                  labelText:
                                                      "Date of ultrasonograph done",
                                                  labelStyle: const TextStyle(
                                                      fontSize: 20),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Ultrasonograph date is required";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Was the fetal biometry normal?",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 1,
                                                        groupValue:
                                                            currentFetalBiometryInformation,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            currentFetalBiometryInformation =
                                                                value as int;
                                                            _errorCurrentFetalBiometryInformation =
                                                                null;
                                                          });
                                                        },
                                                      ),
                                                      const Text("Yes",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 2,
                                                        groupValue:
                                                            currentFetalBiometryInformation,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            currentFetalBiometryInformation =
                                                                value as int;
                                                            _errorCurrentFetalBiometryInformation =
                                                                null;
                                                          });
                                                        },
                                                      ),
                                                      const Text("No",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  if (_errorCurrentFetalBiometryInformation !=
                                                      null)
                                                    Row(children: [
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        _errorCurrentFetalBiometryInformation!,
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ]),
                                                ],
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Was the amniotic fluid index normal?",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 1,
                                                        groupValue:
                                                            currentAmnioticFluidIndexNormal,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            currentAmnioticFluidIndexNormal =
                                                                value as int;
                                                            _errorCurrentAmnioticFluidIndexNormal ==
                                                                null;
                                                          });
                                                        },
                                                      ),
                                                      const Text("Yes",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 2,
                                                        groupValue:
                                                            currentAmnioticFluidIndexNormal,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            currentAmnioticFluidIndexNormal =
                                                                value as int;
                                                            _errorCurrentAmnioticFluidIndexNormal ==
                                                                null;
                                                          });
                                                        },
                                                      ),
                                                      const Text("No",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  if (_errorCurrentAmnioticFluidIndexNormal !=
                                                      null)
                                                    Row(children: [
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        _errorCurrentAmnioticFluidIndexNormal!,
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ]),
                                                  // Add a condition to display "Not selected" if the value is null
                                                  // if (isAmnioticFluidIndexNormal ==
                                                  //     null)
                                                  //   const Text(
                                                  //       "Amniotic fluid index information is required",
                                                  //       style: TextStyle(
                                                  //           color: Colors.red,
                                                  //           fontSize: 16)),
                                                ],
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                              ),
                                              Visibility(
                                                visible: ((hasSelectedPrenatalInformation &&
                                                            isPrenatalInformationCollected ==
                                                                1 &&
                                                            currentFetalBiometryInformation ==
                                                                2 &&
                                                            currentAmnioticFluidIndexNormal ==
                                                                2
                                                        ? true
                                                        : false) &&
                                                    (hasSelectedPrenatalInformation &&
                                                            isPrenatalInformationCollected ==
                                                                2
                                                        ? false
                                                        : true)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            fetalAndAmnioticReasonController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "If no, please specify",
                                                          labelText:
                                                              "If no, please specify",
                                                          labelStyle:
                                                              const TextStyle(
                                                                  fontSize: 20),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Specification is required";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Was there any visible fetal anomaly?",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 1,
                                                        groupValue:
                                                            currentVisibleFetalAnomaly,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            currentVisibleFetalAnomaly =
                                                                value as int;
                                                            _errorCurrentVisibleFetalAnomaly =
                                                                null;
                                                          });
                                                        },
                                                      ),
                                                      const Text("Yes",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 2,
                                                        groupValue:
                                                            currentVisibleFetalAnomaly,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            currentVisibleFetalAnomaly =
                                                                value as int;
                                                            _errorCurrentVisibleFetalAnomaly =
                                                                null;
                                                          });
                                                        },
                                                      ),
                                                      const Text("No",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  if (_errorCurrentVisibleFetalAnomaly !=
                                                      null)
                                                    Row(children: [
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        _errorCurrentVisibleFetalAnomaly!,
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ]),
                                                ],
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Was there any other visible anomaly?",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 1,
                                                        groupValue:
                                                            currentPrenatalInfoOtherVisibleAnomaly,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            currentPrenatalInfoOtherVisibleAnomaly =
                                                                value as int;
                                                            _errorCurrentPrenatalInfoOtherVisibleAnomaly =
                                                                null;
                                                          });
                                                        },
                                                      ),
                                                      const Text("Yes",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 2,
                                                        groupValue:
                                                            currentPrenatalInfoOtherVisibleAnomaly,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            currentPrenatalInfoOtherVisibleAnomaly =
                                                                value as int;
                                                            _errorCurrentPrenatalInfoOtherVisibleAnomaly =
                                                                null;
                                                          });
                                                        },
                                                      ),
                                                      const Text("No",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  if (_errorCurrentPrenatalInfoOtherVisibleAnomaly !=
                                                      null)
                                                    Row(children: [
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        _errorCurrentPrenatalInfoOtherVisibleAnomaly!,
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ]),
                                                ],
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                              ),
                                              Visibility(
                                                visible: ((hasSelectedPrenatalInformation &&
                                                            isPrenatalInformationCollected ==
                                                                1 &&
                                                            currentVisibleFetalAnomaly ==
                                                                1 &&
                                                            currentPrenatalInfoOtherVisibleAnomaly ==
                                                                1
                                                        ? true
                                                        : false) &&
                                                    (hasSelectedPrenatalInformation &&
                                                            isPrenatalInformationCollected ==
                                                                2
                                                        ? false
                                                        : true)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            visibleFetalAnomalyAndOtherVisibleAnomalyReasonController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "If yes, please specify",
                                                          labelText:
                                                              "If yes, please specify",
                                                          labelStyle:
                                                              const TextStyle(
                                                                  fontSize: 20),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Specification is required";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (!hideSecondFormInformation)
                                        if (_errorTextHasSelectedPrenatalInformation !=
                                            null)
                                          Row(children: [
                                            SizedBox(width: 10),
                                            Text(
                                              _errorTextHasSelectedPrenatalInformation!,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ]),
                                    ],
                                  ),

                                  // Full Physical Examination Heading
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  const Text(
                                    'FULL PHYSICAL EXAMINATION',
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurpleAccent),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),
// Full physical examination
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Was the full physical examination performed?",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue: isPhysicalExamPerformed,
                                            onChanged: (value) {
                                              setState(() {
                                                isPhysicalExamPerformed =
                                                    value as int;
                                                _errorTextHasSelectedFullPhysicalExam =
                                                    null;
                                              });
                                            },
                                          ),
                                          const Text("Yes",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue: isPhysicalExamPerformed,
                                            onChanged: (value) {
                                              setState(() {
                                                isPhysicalExamPerformed =
                                                    value as int;
                                                _errorTextHasSelectedFullPhysicalExam =
                                                    null;
                                                if (isPhysicalExamPerformed ==
                                                    2) {
                                                  // Reset the reasonNotPerformed when "No" is selected
                                                  reasonNotPerformed = '';
                                                }
                                              });
                                            },
                                          ),
                                          const Text("No",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: ((isPhysicalExamPerformed == 2
                                                ? true
                                                : false) &&
                                            (isPhysicalExamPerformed == 1
                                                ? false
                                                : true)),
                                        // Show only when "No" is selected
                                        child: TextFormField(
                                          controller:
                                              fullPhysicalExamReasonController,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                200),
                                          ],
                                          decoration: InputDecoration(
                                            hintText: "Reason not performed",
                                            labelText: "Reason not performed",
                                            labelStyle:
                                                const TextStyle(fontSize: 20),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              reasonNotPerformed = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Reason is required";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: ((isPhysicalExamPerformed == 1
                                                ? true
                                                : false) &&
                                            (isPhysicalExamPerformed == 2
                                                ? false
                                                : true)),
                                        // Show only when "No" is selected
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // Show only when "Yes" is selected
                                              children: [
                                                const Text(
                                                  "Same as visit date?",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 7),
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 1,
                                                      groupValue:
                                                          isFullPhysicalExamSameAsVisitDate,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isFullPhysicalExamSameAsVisitDate =
                                                              value as int;
                                                        });
                                                      },
                                                    ),
                                                    const Text("Yes",
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 2,
                                                      groupValue:
                                                          isFullPhysicalExamSameAsVisitDate,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isFullPhysicalExamSameAsVisitDate =
                                                              value as int;
                                                        });
                                                      },
                                                    ),
                                                    const Text("No",
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                ),
                                              ],
                                            ),
                                            TextFormField(
                                              controller:
                                                  fullPhysicalDateOfExaminationController,
                                              readOnly: true,
                                              onTap: () => _selectRequiredDate(
                                                  context,
                                                  fullPhysicalDateOfExaminationController,
                                                  365,
                                                  365),
                                              decoration: InputDecoration(
                                                hintText: "Date of examination",
                                                labelText:
                                                    "Date of examination",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Date of examination is required";
                                                }
                                                return null;
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                            ),
                                            // Loop through each body system to create a question with radio options
                                            for (var bodySystem in bodySystems)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    bodySystem,
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 7),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 1,
                                                        groupValue:
                                                            fullPhysicalExamResults[
                                                                bodySystem],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            fullPhysicalExamResults[
                                                                    bodySystem] =
                                                                value as int;
                                                          });
                                                        },
                                                      ),
                                                      const Text("Not Done",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 2,
                                                        groupValue:
                                                            fullPhysicalExamResults[
                                                                bodySystem],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            fullPhysicalExamResults[
                                                                    bodySystem] =
                                                                value as int;
                                                          });
                                                        },
                                                      ),
                                                      const Text("Normal",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 3,
                                                        groupValue:
                                                            fullPhysicalExamResults[
                                                                bodySystem],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            fullPhysicalExamResults[
                                                                    bodySystem] =
                                                                value as int;
                                                          });
                                                        },
                                                      ),
                                                      const Text(
                                                          "Abnormal, Non-Clinically Significant",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 4,
                                                        groupValue:
                                                            fullPhysicalExamResults[
                                                                bodySystem],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            fullPhysicalExamResults[
                                                                    bodySystem] =
                                                                value as int;
                                                          });
                                                        },
                                                      ),
                                                      const Text(
                                                          "Abnormal, Clinically Significant",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  if (bodySystem == "Other")
                                                    TextFormField(
                                                      controller:
                                                          otherFullPhysicalExamBodySystemController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "If Other, please specify",
                                                        labelText:
                                                            "If Other, please specify",
                                                        labelStyle:
                                                            const TextStyle(
                                                                fontSize: 20),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          otherFullPhysicalExamBodySystemValue =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                  ),
                                                ],
                                              ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!hideSecondFormInformation)
                                        if (_errorTextHasSelectedFullPhysicalExam !=
                                            null)
                                          Row(children: [
                                            SizedBox(width: 10),
                                            Text(
                                              _errorTextHasSelectedFullPhysicalExam!,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ]),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                  ),

                                  // Vital Signs Heading
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  const Text(
                                    'VITAL SIGNS',
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurpleAccent),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                  ),
// Vital Signs
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Were the vital signs measured?",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue: isVitalSignMeasured,
                                            onChanged: (value) {
                                              setState(() {
                                                isVitalSignMeasured =
                                                    value as int;
                                                _errorTextHasSelectedVitalSign =
                                                    null;
                                                hasSelectedVitalSign = true;
                                                // Reset other values when "Yes" is selected
                                                if (isVitalSignMeasured == 1) {
                                                  reasonNotVitalSignMeasured =
                                                      '';
                                                  isVitalSignSameAsVisitDate =
                                                      false;
                                                }
                                              });
                                            },
                                          ),
                                          const Text("Yes",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue: isVitalSignMeasured,
                                            onChanged: (value) {
                                              setState(() {
                                                isVitalSignMeasured =
                                                    value as int;
                                                _errorTextHasSelectedVitalSign =
                                                    null;

                                                hasSelectedVitalSign = true;

                                                if (isVitalSignMeasured == 2) {
                                                  // Reset the reasonNotVitalSignMeasured when "No" is selected
                                                  reasonNotVitalSignMeasured =
                                                      '';
                                                }
                                              });
                                            },
                                          ),
                                          const Text("No",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: ((hasSelectedVitalSign &&
                                                    isVitalSignMeasured == 1
                                                ? true
                                                : false) &&
                                            (hasSelectedVitalSign &&
                                                    isVitalSignMeasured == 2
                                                ? false
                                                : true)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  vitalSignSystolicController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    3),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Systolic blood pressure",
                                                labelText:
                                                    "Systolic blood pressure",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Systolic blood pressure is required";
                                                }
                                                // Parse the input value to an integer
                                                int? systolicBP =
                                                    int.tryParse(value);
                                                // Check if the parsing is successful and the value is within the range
                                                if (systolicBP == null ||
                                                    systolicBP < 90 ||
                                                    systolicBP > 200) {
                                                  return "Systolic blood pressure range is min 90 and max 200";
                                                }
                                                return null; // Validation success
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                            ),
                                            TextFormField(
                                              controller:
                                                  vitalSignDiastolicController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    3),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Diastolic blood pressure",
                                                labelText:
                                                    "Diastolic blood pressure",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Diastolic blood pressure is required";
                                                }

                                                // Parse the input value to an integer
                                                int? diastolicBP =
                                                    int.tryParse(value);

                                                // Check if the parsing is successful and the value is within the range
                                                if (diastolicBP == null ||
                                                    diastolicBP < 60 ||
                                                    diastolicBP > 120) {
                                                  return "Diastolic blood pressure range is min 60 and max 120";
                                                }

                                                return null; // Validation success
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                            ),
                                            TextFormField(
                                              controller:
                                                  vitalSignHeartRateController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    3),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                hintText: "Heart rate",
                                                labelText: "Heart rate",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Heart rate is required";
                                                }

                                                // Parse the input value to an integer
                                                int? heartRate =
                                                    int.tryParse(value);

                                                // Check if the parsing is successful and the value is within the range
                                                if (heartRate == null ||
                                                    heartRate < 50 ||
                                                    heartRate > 130) {
                                                  return "Heart rate range is min 50 and max 130";
                                                }

                                                return null; // Validation success
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                            ),
                                            TextFormField(
                                              controller:
                                                  vitalSignRespiratoryRateController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    2),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                hintText: "Respiratory rate",
                                                labelText: "Respiratory rate",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Respiratory rate is required";
                                                }

                                                // Parse the input value to an integer
                                                int? respiratoryRate =
                                                    int.tryParse(value);

                                                // Check if the parsing is successful and the value is within the range
                                                if (respiratoryRate == null ||
                                                    respiratoryRate < 11 ||
                                                    respiratoryRate > 25) {
                                                  return "Respiratory rate range is min 11 and max 25";
                                                }

                                                return null; // Validation success
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                            ),
                                            TextFormField(
                                                controller:
                                                    fetalHeartRateController,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      3),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                decoration: InputDecoration(
                                                  hintText: "Fetal Heart Rate",
                                                  labelText: "Fetal Heart Rate",
                                                  labelStyle: const TextStyle(
                                                      fontSize: 20),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Fetal heart rate is required";
                                                  }
                                                  // Parse the input value to an integer
                                                  int? fetalHeartRate =
                                                      int.tryParse(value);

// Check if the parsing is successful and the value is within the range
                                                  if (fetalHeartRate == null ||
                                                      fetalHeartRate < 100 ||
                                                      fetalHeartRate > 160) {
                                                    return "Fetal rate range is min 100 and max 160";
                                                  }

                                                  return null;
                                                }),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                            ),
                                            TextFormField(
                                              controller:
                                                  vitalSignBodyTempController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              // keyboardType: TextInputType.number,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              validator:
                                                  validatevitalSignBodyTemperature,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    4),
                                                FilteringTextInputFormatter
                                                    .deny(RegExp(r'[^0-9\.]')),
                                              ],
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Body temperature (˚C)",
                                                labelText:
                                                    "Body temperature (˚C)",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Method of collection for body temperature",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),

                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 7),
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: true,
                                                      groupValue:
                                                          isbodyTempCollectionMethod,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isbodyTempCollectionMethod =
                                                              value as bool;
                                                        });
                                                      },
                                                    ),
                                                    const Text("Axillary",
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: false,
                                                      groupValue:
                                                          isbodyTempCollectionMethod,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isbodyTempCollectionMethod =
                                                              value as bool;
                                                        });
                                                      },
                                                    ),
                                                    const Text("Other",
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                ),
                                                // Add TextFormFields when "Other" is selected
                                                Visibility(
                                                  visible:
                                                      !isbodyTempCollectionMethod,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextFormField(
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "If Other, please specify",
                                                          labelText:
                                                              "If Other, please specify",
                                                          labelStyle:
                                                              const TextStyle(
                                                                  fontSize: 20),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Other is required";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: hasSelectedVitalSign &&
                                            isVitalSignMeasured == 1,
                                        // Show only when "Yes" is selected
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Same as visit date?",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7),
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: true,
                                                  groupValue:
                                                      isVitalSignSameAsVisitDate,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isVitalSignSameAsVisitDate =
                                                          value as bool;
                                                    });
                                                  },
                                                ),
                                                const Text("Yes",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: false,
                                                  groupValue:
                                                      isVitalSignSameAsVisitDate,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isVitalSignSameAsVisitDate =
                                                          value as bool;
                                                    });
                                                  },
                                                ),
                                                const Text("No",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: hasSelectedVitalSign &&
                                            isVitalSignMeasured == 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  vitalSignDateOfCollectionController,
                                              readOnly: true,
                                              onTap: () => _selectRequiredDate(
                                                  context,
                                                  vitalSignDateOfCollectionController,
                                                  365,
                                                  365),
                                              decoration: InputDecoration(
                                                hintText: "Date of collection",
                                                labelText: "Date of collection",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              // onChanged: (value) {
                                              //   setState(() {
                                              //     dateOfCollectionVitalSameVisit =
                                              //         value;
                                              //   });
                                              // },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Date is required";
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                            ),
                                            TextFormField(
                                              controller:
                                                  vitalSignTimeOfCollectionController,
                                              readOnly: true,
                                              onTap: () => _selectTime(context,
                                                  vitalSignTimeOfCollectionController),
                                              decoration: InputDecoration(
                                                hintText: "Time of collection",
                                                labelText: "Time of collection",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              // onChanged: (value) {
                                              //   setState(() {
                                              //     timeOfCollectionVitalSameVisit =
                                              //         value;
                                              //   });
                                              // },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Time is required";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      Visibility(
                                        visible: hasSelectedVitalSign &&
                                            isVitalSignMeasured == 2,
                                        // Show only when "No" is selected
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  vitalSignReasonNotPerformedController,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Reason not performed",
                                                labelText:
                                                    "Reason not performed",
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  reasonNotVitalSignMeasured =
                                                      value;
                                                });
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Reason is required";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!hideSecondFormInformation)
                                        if (_errorTextHasSelectedVitalSign !=
                                            null)
                                          Row(children: [
                                            SizedBox(width: 10),
                                            Text(
                                              _errorTextHasSelectedVitalSign!,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ]),
                                    ],
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ]),
                              ),
                              // Submit Button
                              // RoundButton(
                              //     loading: loading,
                              //     title: "Submit",
                              //     onTap: () async {
                              //       setState(() {
                              //         //_autovalidateMode = AutovalidateMode.always;
                              //         loading = true;
                              //         formIsSubmitted = true;
                              //       });
                              //       SetRadioButtonErrors();
                              //       // print(_errorTextParticipationWomenSelectedValue);
                              //       // print(_errorTextWomenConsent);
                              //       // print(_errorTextWomenConsentFifthDay);
                              //       // print(_errorTextWomenConsentTenthDay);
                              //
                              //       if (_formKey.currentState != null &&
                              //               _formKey.currentState!.validate() &&
                              //               _dateOfVisitFormKey.currentState !=
                              //                   null &&
                              //               _dateOfVisitFormKey.currentState!
                              //                   .validate() &&
                              //               _errorTextParticipationWomenSelectedValue ==
                              //                   null &&
                              //               _errorTextWomenConsent == null &&
                              //               _errorTextWomenConsentFifthDay ==
                              //                   null &&
                              //               _errorTextWomenConsentTenthDay ==
                              //                   null &&
                              //               // -- Second Form Start -- //
                              //               _errorTextHasSelectedMedicalHistory ==
                              //                   null &&
                              //               _errorTextHasSelectedTobaccoUse ==
                              //                   null &&
                              //               _errorTextHasSelectedAlcoholUse ==
                              //                   null &&
                              //               _errorTextHasSelectedPrenatalInformation ==
                              //                   null &&
                              //               _errorTextHasSelectedVitalSign ==
                              //                   null &&
                              //               _errorTextHaveAnyPrevPregObstetricHist ==
                              //                   null &&
                              //               _errorTextObstetricHistAnyAbortion ==
                              //                   null &&
                              //               _errorTextObstetricHistAnyDelivery ==
                              //                   null &&
                              //               _errorTextHasSelectedFullPhysicalExam ==
                              //                   null &&
                              //               _errorCurrentVisibleFetalAnomaly ==
                              //                   null &&
                              //               _errorCurrentFetalBiometryInformation ==
                              //                   null &&
                              //               _errorCurrentAmnioticFluidIndexNormal ==
                              //                   null &&
                              //               _errorCurrentPrenatalInfoOtherVisibleAnomaly ==
                              //                   null
                              //
                              //           // -- Second Form End -- //
                              //           ) {
                              //         await SaveAllInformation();
                              //       } else {
                              //         setState(() {
                              //           //_autovalidateMode = AutovalidateMode.always;
                              //           loading = false;
                              //         });
                              //         // SetRadioButtonErrors();
                              //         Utils().toastMessage(
                              //             "Remove all errors before Submit");
                              //       }
                              //     }
                              //     //},
                              //     ),
                              // const Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 10),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                      key: _inclusionExclusionFormKey,
                      autovalidateMode: _autovalidateMode,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Inclusion and Exclusion Criteria   Heading
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          const Text(
                            'INCLUSION AND EXCLUSION CRITERIA',
                            style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.white,
                                backgroundColor: Colors.deepPurpleAccent),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),

                          // Inclusion and Exclusion
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // INCLUSION AND EXCLUSION
                              const Text(
                                "Inclusion and exclusion evaluated?",
                                style: TextStyle(fontSize: 20),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 7),
                              ),
                              // INCLUSION AND EXCLUSION RADIO YES/NO
                              Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue:
                                        isInclusionAndExclusionEvaluated,
                                    onChanged: (value) {
                                      setState(() {
                                        isInclusionAndExclusionEvaluated =
                                            value as int;
                                        _errorTextIsInclusionAndExclusionEvaluated =
                                            null;
                                        selectedInclusionAndExclusionEvaluated =
                                            true;
                                        // Reset other values when "Yes" is selected
                                        if (isInclusionAndExclusionEvaluated ==
                                            1) {
                                          reasonNotInclusionExclusionDone = '';
                                        }
                                      });
                                    },
                                  ),
                                  const Text("Yes",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 2,
                                    groupValue:
                                        isInclusionAndExclusionEvaluated,
                                    onChanged: (value) {
                                      setState(() {
                                        isInclusionAndExclusionEvaluated =
                                            value as int;
                                        _errorTextIsInclusionAndExclusionEvaluated =
                                            null;
                                        selectedInclusionAndExclusionEvaluated =
                                            true;
                                        if (isInclusionAndExclusionEvaluated ==
                                            2) {
                                          // Reset when "No" is selected
                                          reasonNotInclusionExclusionDone = '';
                                        }
                                      });
                                    },
                                  ),
                                  const Text("No",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              // INCLUSION AND EXCLUSION NO REASON NOT DONE
                              Visibility(
                                visible:
                                    selectedInclusionAndExclusionEvaluated &&
                                        isInclusionAndExclusionEvaluated == 2,
                                // Show only when "No" is selected
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller:
                                          inclusionExclusionReasonNotDoneController,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(200),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: "Reason not done",
                                        labelText: "Reason not done",
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          reasonNotInclusionExclusionDone =
                                              value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Reason is required";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // INCLUSION CRITERIA FIELDS
                              Visibility(
                                visible:
                                    selectedInclusionAndExclusionEvaluated &&
                                        isInclusionAndExclusionEvaluated == 1,
                                // Show only when "Yes" is selected also to confirm for dm.subjcat
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var inclusionCriteria
                                        in inclusionCriterias)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            inclusionCriteria,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7),
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 1,
                                                groupValue:
                                                    inclusionCriteriaOptionResults[
                                                        inclusionCriteria],
                                                onChanged: (value) {
                                                  setState(() {
                                                    inclusionCriteriaOptionResults[
                                                            inclusionCriteria] =
                                                        value as int;
                                                  });
                                                },
                                              ),
                                              const Text("Yes",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 2,
                                                groupValue:
                                                    inclusionCriteriaOptionResults[
                                                        inclusionCriteria],
                                                onChanged: (value) {
                                                  setState(() {
                                                    inclusionCriteriaOptionResults[
                                                            inclusionCriteria] =
                                                        value as int;
                                                  });
                                                },
                                              ),
                                              const Text("No",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),

                              // EXCLUSION CRITERIA FIELDS
                              Visibility(
                                visible:
                                    selectedInclusionAndExclusionEvaluated &&
                                        isInclusionAndExclusionEvaluated == 1,
                                // Show only when "Yes" is selected also to confirm for dm.subjcat
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var exclusionCriteria
                                        in exclusionCriterias)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exclusionCriteria,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7),
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 1,
                                                groupValue:
                                                    exclusionCriteriaOptionResults[
                                                        exclusionCriteria],
                                                onChanged: (value) {
                                                  setState(() {
                                                    exclusionCriteriaOptionResults[
                                                            exclusionCriteria] =
                                                        value as int;
                                                  });
                                                },
                                              ),
                                              const Text("Yes",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: 2,
                                                groupValue:
                                                    exclusionCriteriaOptionResults[
                                                        exclusionCriteria],
                                                onChanged: (value) {
                                                  setState(() {
                                                    exclusionCriteriaOptionResults[
                                                            exclusionCriteria] =
                                                        value as int;
                                                  });
                                                },
                                              ),
                                              const Text("No",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),

                              if (!hideSecondFormInformation)
                                if (_errorTextIsInclusionAndExclusionEvaluated !=
                                    null)
                                  Row(children: [
                                    SizedBox(width: 10),
                                    Text(
                                      _errorTextIsInclusionAndExclusionEvaluated!,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ]),
                            ],
                          ),
                        ],
                      )),
                  Form(
                      key: _eligibilityFormKey,
                      autovalidateMode: _autovalidateMode,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Eligibility Assessment  Heading
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          const Text(
                            'ELIGIBILITY ASSESSMENT',
                            style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.white,
                                backgroundColor: Colors.deepPurpleAccent),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),

                          // Eligibility Assessment
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Is the participant eligible to participate in this clinical trial?",
                                style: TextStyle(fontSize: 20),
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 7),
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue:
                                        isParticipantEligibleInClinicalTrial,
                                    onChanged: (value) {
                                      setState(() {
                                        isParticipantEligibleInClinicalTrial =
                                            value as int;
                                        _errorTextIsParticipantEligibleInClinicalTrial =
                                            null;
                                        selectedParticipantEligibleInClinicalTrial =
                                            true;
                                        // if (selectedParticipantEligibleInClinicalTrial &&
                                        //     isParticipantEligibleInClinicalTrial ==
                                        //         1) {
                                        //   reasonScreenFailureParticipantEligibleClinical = '';
                                        // }
                                      });
                                    },
                                  ),
                                  const Text("Yes",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 2,
                                    groupValue:
                                        isParticipantEligibleInClinicalTrial,
                                    onChanged: (value) {
                                      setState(() {
                                        isParticipantEligibleInClinicalTrial =
                                            value as int;
                                        _errorTextIsParticipantEligibleInClinicalTrial =
                                            null;
                                        selectedParticipantEligibleInClinicalTrial =
                                            true;
                                        // if (selectedParticipantEligibleInClinicalTrial &&
                                        //     isParticipantEligibleInClinicalTrial ==
                                        //         2) {
                                        //   reasonScreenFailureParticipantEligibleClinical = '';
                                        //
                                        // }
                                      });
                                    },
                                  ),
                                  const Text("No",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Visibility(
                                visible: ((selectedParticipantEligibleInClinicalTrial &&
                                            isParticipantEligibleInClinicalTrial ==
                                                2
                                        ? true
                                        : false) &&
                                    (selectedParticipantEligibleInClinicalTrial &&
                                            isParticipantEligibleInClinicalTrial ==
                                                1
                                        ? false
                                        : true)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Reason for screen failure",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: 1,
                                                    groupValue:
                                                        currentReasonForScreenFailureParticipantElig,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        currentReasonForScreenFailureParticipantElig =
                                                            value as int;
                                                        _errorCurrentReasonForScreenFailureParticipantElig =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                  const Text(
                                                      'Inclusion criteria not met',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: 2,
                                                    groupValue:
                                                        currentReasonForScreenFailureParticipantElig,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        currentReasonForScreenFailureParticipantElig =
                                                            value as int;
                                                        _errorCurrentReasonForScreenFailureParticipantElig =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                  const Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                        'Participant meets at least one exclusion criterion',
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: 3,
                                                    groupValue:
                                                        currentReasonForScreenFailureParticipantElig,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        currentReasonForScreenFailureParticipantElig =
                                                            value as int;
                                                        _errorCurrentReasonForScreenFailureParticipantElig =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                  const Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                        'Participant’s consent withdrawal',
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: 4,
                                                    groupValue:
                                                        currentReasonForScreenFailureParticipantElig,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        currentReasonForScreenFailureParticipantElig =
                                                            value as int;
                                                        _errorCurrentReasonForScreenFailureParticipantElig =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                  const Text(
                                                      'Lost to follow-up',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: 5,
                                                    groupValue:
                                                        currentReasonForScreenFailureParticipantElig,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        currentReasonForScreenFailureParticipantElig =
                                                            value as int;
                                                        _errorCurrentReasonForScreenFailureParticipantElig =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                  const Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      '‘Positive’ Pregnancy test (only for non-pregnant participants)',
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: 6,
                                                    groupValue:
                                                        currentReasonForScreenFailureParticipantElig,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        currentReasonForScreenFailureParticipantElig =
                                                            value as int;
                                                        _errorCurrentReasonForScreenFailureParticipantElig =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                  const Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      'Other',
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // if (_errorCurrentReasonForScreenFailureParticipantElig !=
                                    //     null)
                                    //   Row(children: [
                                    //     const SizedBox(width: 10),
                                    //     Text(
                                    //       _errorCurrentReasonForScreenFailureParticipantElig!,
                                    //       style: TextStyle(color: Colors.red),
                                    //     ),
                                    //   ]),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: ((selectedParticipantEligibleInClinicalTrial &&
                                            isParticipantEligibleInClinicalTrial ==
                                                1
                                        ? true
                                        : false) &&
                                    (selectedParticipantEligibleInClinicalTrial &&
                                            isParticipantEligibleInClinicalTrial ==
                                                2
                                        ? false
                                        : true)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Is the participant continuing with the Screening and Enrollment / Vaccination procedures on the same day?",
                                      style: TextStyle(fontSize: 20),
                                    ),

                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7),
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: isVisitOneTwoSameDay,
                                          onChanged: (value) {
                                            setState(() {
                                              isVisitOneTwoSameDay =
                                                  value as int;
                                              _errorTextIsVisitOneTwoSameDay =
                                                  null;
                                              hasSelectedVisitOneTwoSameDay =
                                                  true;
                                            });
                                          },
                                        ),
                                        const Text("Yes",
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 2,
                                          groupValue: isVisitOneTwoSameDay,
                                          onChanged: (value) {
                                            setState(() {
                                              isVisitOneTwoSameDay =
                                                  value as int;
                                              _errorTextIsVisitOneTwoSameDay =
                                                  null;
                                              hasSelectedVisitOneTwoSameDay =
                                                  true;
                                            });
                                          },
                                        ),
                                        const Text("No",
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    ),

                                    // if (_errorTextIsVisitOneTwoSameDay !=
                                    //     null)
                                    //   Row(children: [
                                    //     const SizedBox(width: 10),
                                    //     Text(
                                    //       _errorTextIsVisitOneTwoSameDay!,
                                    //       style: TextStyle(color: Colors.red),
                                    //     ),
                                    //   ]),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                    ),
                                  ],
                                ),
                              ),
                              // if (!hideSecondFormInformation)
                              //   if (_errorTextIsParticipantEligibleInClinicalTrial != null)
                              //     Row(children: [
                              //       SizedBox(width: 10),
                              //       Text(
                              //         _errorTextIsParticipantEligibleInClinicalTrial!,
                              //         style: TextStyle(color: Colors.red),
                              //       ),
                              //     ]),
                            ],
                          ),
                        ],
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  RoundButton(
                      loading: loading,
                      title: "Submit",
                      onTap: () async {
                        setState(() {
                          //_autovalidateMode = AutovalidateMode.always;
                          loading = true;
                          formIsSubmitted = true;
                        });
                        SetRadioButtonErrors();
                        // print(_errorTextParticipationWomenSelectedValue);
                        // print(_errorTextWomenConsent);
                        // print(_errorTextWomenConsentFifthDay);
                        // print(_errorTextWomenConsentTenthDay);

                        if (_formKey.currentState != null &&
                                _formKey.currentState!.validate() &&
                                _dateOfVisitFormKey.currentState != null &&
                                _dateOfVisitFormKey.currentState!.validate() &&
                                _errorTextParticipationWomenSelectedValue ==
                                    null &&
                                _errorTextWomenConsent == null &&
                                _errorTextWomenConsentFifthDay == null &&
                                _errorTextWomenConsentTenthDay == null &&
                                // -- Second Form Start -- //
                                _errorTextHasSelectedMedicalHistory == null &&
                                _errorTextHasSelectedTobaccoUse == null &&
                                _errorTextHasSelectedAlcoholUse == null &&
                                _errorTextHasSelectedPrenatalInformation ==
                                    null &&
                                _errorTextHasSelectedVitalSign == null &&
                                _errorTextHaveAnyPrevPregObstetricHist ==
                                    null &&
                                _errorTextObstetricHistAnyAbortion == null &&
                                _errorTextObstetricHistAnyDelivery == null &&
                                _errorTextHasSelectedFullPhysicalExam == null &&
                                _errorCurrentVisibleFetalAnomaly == null &&
                                _errorCurrentFetalBiometryInformation == null &&
                                _errorCurrentAmnioticFluidIndexNormal == null &&
                                _errorCurrentPrenatalInfoOtherVisibleAnomaly ==
                                    null

                            // -- Second Form End -- //
                            ) {
                          await SaveAllInformation();
                        } else {
                          setState(() {
                            //_autovalidateMode = AutovalidateMode.always;
                            loading = false;
                          });
                          // SetRadioButtonErrors();
                          Utils()
                              .toastMessage("Remove all errors before Submit");
                        }
                      }
                      //},
                      ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  SetRadioButtonErrors() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
      // loading = false;
    });

    // -- Second Form Start -- //
    if (!hideSecondFormInformation &&
        tobaccoUsage == 1 &&
        currenttobaccoUsageSelectedValue == 0) {
      setState(() {
        _errorCurrentTobaccoUsageSelectedValue =
            'Current Tobacco Usage is Required';
      });
    } else {
      setState(() {
        _errorCurrentTobaccoUsageSelectedValue = null;
      });
    }
    if (!hideSecondFormInformation && isPhysicalExamPerformed == 0) {
      setState(() {
        _errorTextHasSelectedFullPhysicalExam =
            'Full physical examination is required';
      });
    } else {
      setState(() {
        _errorTextHasSelectedFullPhysicalExam = null;
      });
    }
    if (!hideSecondFormInformation &&
        isPrenatalInformationCollected == 1 &&
        currentAmnioticFluidIndexNormal == 0) {
      setState(() {
        _errorCurrentAmnioticFluidIndexNormal =
            'Amniotic Fluid Index is required';
      });
    } else {
      setState(() {
        _errorCurrentAmnioticFluidIndexNormal = null;
      });
    }

    if (!hideSecondFormInformation &&
        isPrenatalInformationCollected == 1 &&
        currentFetalBiometryInformation == 0) {
      setState(() {
        _errorCurrentFetalBiometryInformation =
            'Fetal Biometry Information is required';
      });
    } else {
      setState(() {
        _errorCurrentFetalBiometryInformation = null;
      });
    }

    if (!hideSecondFormInformation &&
        isPrenatalInformationCollected == 1 &&
        currentVisibleFetalAnomaly == 0) {
      setState(() {
        _errorCurrentVisibleFetalAnomaly = 'Visible Fetal Anomaly is required';
      });
    } else {
      setState(() {
        _errorCurrentVisibleFetalAnomaly = null;
      });
    }

    if (!hideSecondFormInformation &&
        isPrenatalInformationCollected == 1 &&
        currentPrenatalInfoOtherVisibleAnomaly == 0) {
      setState(() {
        _errorCurrentPrenatalInfoOtherVisibleAnomaly =
            'Other Visible Anomaly is required';
      });
    } else {
      setState(() {
        _errorCurrentPrenatalInfoOtherVisibleAnomaly = null;
      });
    }

    if (!hideSecondFormInformation &&
        alcoholUsage == 1 &&
        currentalcoholUsageSelectedValue == 0) {
      setState(() {
        _errorCurrentAlcoholUsageSelectedValue =
            'Current Alcohol Usage is Required';
      });
    } else {
      setState(() {
        _errorCurrentAlcoholUsageSelectedValue = null;
      });
    }
    if (!hideSecondFormInformation && haveAnyPrevPregObstetricHist == 0) {
      setState(() {
        _errorTextHaveAnyPrevPregObstetricHist =
            'Previous Pregnancy is required';
      });
    } else {
      setState(() {
        _errorTextHaveAnyPrevPregObstetricHist = null;
      });
    }

    if (!hideSecondFormInformation &&
        haveAnyPrevPregObstetricHist == 1 &&
        obstetricHistAnyAbortion == 0) {
      setState(() {
        _errorTextObstetricHistAnyAbortion = 'Any Abortion is required';
      });
    } else {
      setState(() {
        _errorTextObstetricHistAnyAbortion = null;
      });
    }

    if (!hideSecondFormInformation &&
        haveAnyPrevPregObstetricHist == 1 &&
        obstetricHistAnyDelivery == 0) {
      setState(() {
        _errorTextObstetricHistAnyDelivery = 'Any Delivery is required';
      });
    } else {
      setState(() {
        _errorTextObstetricHistAnyDelivery = null;
      });
    }

    if (!hideSecondFormInformation && hasMedicalHistory == 0) {
      setState(() {
        _errorTextHasSelectedMedicalHistory = 'Medical History is required';
      });
    } else {
      setState(() {
        _errorTextHasSelectedMedicalHistory = null;
      });
    }

    if (!hideSecondFormInformation && tobaccoUsage == 0) {
      setState(() {
        _errorTextHasSelectedTobaccoUse = 'Tobacco Use is required';
      });
    } else {
      setState(() {
        _errorTextHasSelectedTobaccoUse = null;
      });
    }

    if (!hideSecondFormInformation && alcoholUsage == 0) {
      setState(() {
        _errorTextHasSelectedAlcoholUse = 'Alcohol Use is required';
      });
    } else {
      setState(() {
        _errorTextHasSelectedAlcoholUse = null;
      });
    }

    if (!hideSecondFormInformation && isPrenatalInformationCollected == 0) {
      setState(() {
        _errorTextHasSelectedPrenatalInformation =
            'Prenatal Information is required';
      });
    } else {
      setState(() {
        _errorTextHasSelectedPrenatalInformation = null;
      });
    }

    if (!hideSecondFormInformation && isVitalSignMeasured == 0) {
      setState(() {
        _errorTextHasSelectedVitalSign = 'Vital Sign is required';
      });
    } else {
      setState(() {
        _errorTextHasSelectedVitalSign = null;
      });
    }

// -- Second Form End -- //

    if (counselingAtCenter && participationWomenSelectedValue == 0) {
      setState(() {
        _errorTextParticipationWomenSelectedValue =
            'Women Participation is Required';
      });
    } else {
      setState(() {
        _errorTextParticipationWomenSelectedValue = null;
      });
    }

    bool isConsentVisible =
        ((participationWomenSelectedValue == 3 ? true : false) ||
            (participationWomenSelectedValue == 1 ? true : false) ||
            (participationWomenSelectedValue == 2 ? false : true));

    if (isConsentVisible && consentWomenSelectedValue == 0) {
      setState(() {
        _errorTextWomenConsent = 'Women Consent is Required';
      });
    } else {
      setState(() {
        _errorTextWomenConsent = null;
      });
    }

    bool isConsentFifthDayVisible =
        ((consentWomenSelectedValue == 2 ? true : false) &&
            (consentWomenSelectedValue == 1 ? false : true) &&
            (consentWomenSelectedValue == 3 ? false : true));

    if (isConsentFifthDayVisible && consentFifthWomenSelectedValue == 0) {
      setState(() {
        _errorTextWomenConsentFifthDay = 'Women Fifth Day Consent is Required';
      });
    } else {
      setState(() {
        _errorTextWomenConsentFifthDay = null;
      });
    }

    bool isConsentTenthDayVisible =
        ((consentFifthWomenSelectedValue == 2 ? true : false) &&
            (consentFifthWomenSelectedValue == 1 ? false : true) &&
            (consentFifthWomenSelectedValue == 3 ? false : true));

    if (isConsentTenthDayVisible && consentTenthWomenSelectedValue == 0) {
      setState(() {
        _errorTextWomenConsentTenthDay = 'Women Tenth Day Consent is Required';
      });
    } else {
      setState(() {
        _errorTextWomenConsentTenthDay = null;
      });
    }
    // Utils().toastMessage("Remove all errors before Submit");
  }

  SaveAllInformation() async {
    await Future.delayed(Duration(seconds: 2));

    bool ifSavedSuccessfully = await SaveWomenInformation();

    // SaveAllInformationInDatabase();

    if (ifSavedSuccessfully) {
      setState(() {
        loading = false;
        Utils().toastMessage(AppConfig.successMessage);
        ResetForm();
        //_formKey.currentState?.reset();
      });
    } else {
      setState(() {
        loading = false;
        Utils().toastMessage(AppConfig.errorMessage);
        //_formKey.currentState?.reset();
      });
    }
  }

  void SaveAllInformationInDatabase() async {
    try {
      await postBaselineInformationToWebApi();
      //postPregnancyInformationToWebApi();
    } catch (exception) {
      Utils().toastMessage(
          "In SaveAllInformationInDatabase " + exception.toString());
    }
  }

  ResetForm() {
    _autovalidateMode = AutovalidateMode.disabled;
    nameOfStaff.clear();
    dateOfEntry.clear();
    selectedValue = "";
    fullName.clear();
    age.text = "";
    idVR.text = "VR-";
    medidataScreeningID.clear();
    completeAddress.clear();
    phoneNumber.clear();
    phoneNumber.text = "03";
    counselingAtCenter = false;
    participationWomenSelectedValue = 0;
    consentWomenSelectedValue = 0;
    consentFifthWomenSelectedValue = 0;
    consentTenthWomenSelectedValue = 0;
    fifthAppointmentDate.clear();
    tenthAppointmentDate.clear();
    pregnantWomenEnrolled = false;
    prismaStudyEnrolDate.clear();
    labSamplesCollected = false;
    ultrasoundDone = false;
    ultraSoundDate.clear();
    lMPDate.clear();
    eDD.clear();
    nextUltrasoundDate.clear();
    weeks.text = "";
    days.text = "";
    dateOfLabResults.clear();
    ctu1VisitDate.clear();
    prescreeningVisitDate.clear();
    consentReason.clear();
    consentFifthDayReason.clear();
    consentTenthDayReason.clear();
    agreeParticipation.clear();
    hidePregnancyInformation = true;
    hideSecondFormInformation = true;
    // -- Second Form Start -- //

    participantHeight.clear();
    participantWeight.clear();
    bmiController.clear();
    hasMedicalHistory = 0;
    medicalHistoryDiseaseNameController.clear();
    tobaccoUsage = 0;
    currenttobaccoUsageSelectedValue = 0;
    alcoholUsage = 0;
    currentalcoholUsageSelectedValue = 0;
    isPrenatalInformationCollected = 0;
    isVitalSignMeasured = 0;
    isbodyTempCollectionMethod = true;
    isFetalBiometryNormal = null;
    isAmnioticFluidIndexNormal = null;
    vitalSignReasonNotPerformedController.text = "";
    prenatalReasonNotCollectedController.text = "";

    haveAnyPrevPregObstetricHist = 0;
    obstetricHistAnyAbortion = 0;
    obstetricHistAnyDelivery = 0;
    currentAmnioticFluidIndexNormal = 0;
    currentFetalBiometryInformation = 0;
    currentVisibleFetalAnomaly = 0;
    currentPrenatalInfoOtherVisibleAnomaly = 0;
    isInclusionAndExclusionEvaluated = 0;

    fetalHeartRateController.clear();
    vitalSignSystolicController.clear();
    vitalSignDiastolicController.clear();
    vitalSignHeartRateController.clear();
    vitalSignRespiratoryRateController.clear();
    vitalSignDateOfCollectionController.clear();
    vitalSignTimeOfCollectionController.clear();
    vitalSignBodyTempController.clear();
    fullPhysicalDateOfExaminationController.clear();
    for (var bodySystem in bodySystems) {
      fullPhysicalExamResults[bodySystem] = 0;
    }

    otherFullPhysicalExamBodySystemController.clear();
    otherFullPhysicalExamBodySystemValue = '';

    counselingAtCenterRB = null;
    labSamplesCollectedRB = null;
    pregnantWomenEnrolledRB = null;
    ultrasoundDoneRB = null;

// -- Second Form End -- //
  }

  Future<bool> SaveBaselineInformation() async {
    try {
      Database db = await DBProvider().initDb();
      ageNumber = int.parse(age.text);
      heightNumber = double.tryParse(participantHeight.text) ?? 0.0;
      weightNumber = double.tryParse(participantWeight.text) ?? 0.0;
      bmiNumber = double.tryParse(bmiController.text) ?? 0.0;

      Map<String, dynamic> row = {
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "FullName": fullName.text,
        "CompleteAddress": completeAddress.text,
        "PhoneNumber": phoneNumber.text,
        "Age": ageNumber,
        "PartHeight": heightNumber,
        "PartWeight": weightNumber,
        "PartBMI": bmiNumber
      };

      wbIDPrimKey = await db.insert("WomenBaselineInformation", row);
      print(wbIDPrimKey);
      await db.close();
      return true;
    } catch (exception) {
      Utils()
          .toastMessage("Women Baseline Information: " + exception.toString());
      return false;
    }
  }

  Future<bool> postBaselineInformationToWebApi() async {
    String apiUrl = WebApiConfig.webApplicationURL +
        WebApiConfig.postWomenBaselineInformation;

    if (weeks.text == '' || weeks.text == null) {
      weeks.text = '0';
    }

    if (days.text == '' || days.text == null) {
      days.text = '0';
    }

    // print("Checking wome list");
    // print(womenPrecsreeningVisitInformationList);

    List<Map<String, dynamic>> prescreeningMapList = [];
    if (womenPrecsreeningVisitInformationList != null) {
      for (var visit in womenPrecsreeningVisitInformationList!) {
        Map<String, dynamic> prescreeningMap = Map<String, dynamic>();
        prescreeningMap = visit.toJson();
        prescreeningMapList.add(prescreeningMap);
      }
    }

    // List<String> pp = <String>[];
    // pp.add('Apple');
    // pp.add('Banana');
    // pp.add('Orange');

    Map<String, dynamic> row = {
      "VRID": idVR.text,
      "MedidataScreeningID": medidataScreeningID.text,
      "FullName": fullName.text,
      "CompleteAddress": completeAddress.text,
      "PhoneNumber": phoneNumber.text,
      "Age": ageNumber,
      "PRISMAEnrol": pregnantWomenEnrolled,
      "PRISMAEnrolDateText": prismaStudyEnrolDate.text,
      "LabSamplesCollected": labSamplesCollected,
      "UltrasoundDone": ultrasoundDone,
      "UltrasoundDateText": ultraSoundDate.text,
      "EDDText": eDD.text,
      "LMPDateText": lMPDate.text,
      "GestationalWeek": int.parse(weeks.text),
      "GestationalDays": int.parse(days.text),
      "NextUltrasoundDateText": nextUltrasoundDate.text,
      "CTU1VisitDateText": ctu1VisitDate.text,
      "LabResultsDateText": dateOfLabResults.text,
      "PrescreeningVisitDateText": prescreeningVisitDate.text,
      "IsCounseled": counselingAtCenter,
      "HasAgreed": participationWomenSelectedValue,
      "AgreementReason": agreeParticipation.text,
      "HasConsented": consentWomenSelectedValue,
      "ConsentReason": consentReason.text,
      "FifthAppointmentDateText": fifthAppointmentDate.text,
      "HasConsentedFifthDay": consentFifthWomenSelectedValue,
      "ConsentReasonFifthDay": consentFifthDayReason.text,
      "TenthAppointmentDateText": tenthAppointmentDate.text,
      "HasConsentedTenthDay": consentTenthWomenSelectedValue,
      "ConsentReasonTenthDay": consentTenthDayReason.text,
      "PrescreeningList": prescreeningMapList,
      "SC_HTORRES": heightNumber,
      "SC_WTORRES2": weightNumber,
      "SC_BMI": bmiNumber
      //,//pp":pp
    };

    // print(row["WomenPrecsreeningVisitInformationList"]);

    // WomenInformation row = new WomenInformation(
    //     VRID: idVR.text,
    //     FullName: fullName.text,
    //     CompleteAddress: completeAddress.text,
    //     PhoneNumber: phoneNumber.text,
    //     Age: ageNumber,
    //     PRISMAEnrol:pregnantWomenEnrolled,
    //     PRISMAEnrolDateText: prismaStudyEnrolDate.text,
    //     LabSamplesCollected: labSamplesCollected,
    //     UltrasoundDone: ultrasoundDone,
    //     UltrasoundDateText: ultraSoundDate.text,
    //     EDDText: eDD.text,
    //     LMPDateText: lMPDate.text,
    //     GestationWeek: int.parse(weeks.text),
    //     GestationDays: int.parse(days.text),
    //     NextUltrasoundDateText: nextUltrasoundDate.text,
    //     CTU1VisitDateText: ctu1VisitDate.text,
    //     LabResultsDateText: dateOfLabResults.text,
    //     PrescreeningVisitDateText: prescreeningVisitDate.text,
    //     IsCounseled: counselingAtCenter,
    //     HasAgreed: participationWomenSelectedValue,
    //     AgreementReason: agreeParticipation.text,
    //     HasCounsented: consentWomenSelectedValue,
    //     ConsentReason: consentReason.text,
    //     FifthAppointmentDateText: fifthAppointmentDate.text,
    //     HasConsentedFifthDay: consentFifthWomenSelectedValue,
    //     ConsentReasonFifthDay: consentFifthDayReason.text,
    //     TenthAppointmnetDateText: tenthAppointmentDate.text,
    //     HasConsentedTenthDay: consentTenthWomenSelectedValue,
    //     ConsentReasonTenthDay: consentTenthDayReason.text//,
    //     //PrescreeningVisitList: womenPrecsreeningVisitInformationList
    // );

    // Map<String, dynamic> row = {
    //   "VRID": "VR-123245",
    //   "MedidataScreeningID": "SRABCD",
    //   "FullName": "Uneeba Rafi",
    //   "CompleteAddress": "A 80",
    //   "PhoneNumber": "03340210489",
    //   "Age": 45,
    //   "PRISMAEnrol": true,
    //   "PRISMAEnrolDateText": '2023-07-20',
    // "LabSamplesCollected": labSamplesCollected,
    // "UltrasoundDone": ultrasoundDone,
    // "UltrasoundDate": ultraSoundDate.text,
    // "EDD": eDD.text,
    // "LMPDate": lMPDate.text,
    // "GestationalWeek": int.parse(weeks.text),
    // "GestationalDays": int.parse(days.text),
    // "NextUltrasoundDate": nextUltrasoundDate.text,
    // "CTU1VisitDate": ctu1VisitDate.text,
    // "LabResultsDate": dateOfLabResults.text,
    // "PrescreeningVisitDate": prescreeningVisitDate.text
    // };
    // print("CheckingJSONENcode");
    // print(jsonEncode(row));
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(row),
      );

      if (response.statusCode == 200) {
        Utils().toastMessage(
            'Data posted successfully. Status code: ${response.statusCode}');

        //print('Data posted successfully');
      } else {
        Utils().toastMessage(
            'Failed to post data. Status code: ${response.statusCode}');
      }
      return true;
    } catch (exception) {
      print(exception.toString());

      Utils().toastMessage(
          "In postBaselineInformationToWebApi" + exception.toString());
      return false;
    }
  }

  Future<bool> SavePregnancyInformation() async {
    try {
      Database db = await DBProvider().initDb();

      if (weeks.text == '' || weeks.text == null) {
        weeks.text = '0';
      }

      if (days.text == '' || days.text == null) {
        days.text = '0';
      }
      // row to insert
      Map<String, dynamic> row = {
        // "VRID": idVR.text,
        "WBID": wbIDPrimKey,
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "PRISMAEnrol": pregnantWomenEnrolled,
        "PRISMAEnrolDate": prismaStudyEnrolDate.text,
        "LabSamplesCollected": labSamplesCollected,
        "UltrasoundDone": ultrasoundDone,
        "UltrasoundDate": ultraSoundDate.text,
        "EDD": eDD.text,
        "LMPDate": lMPDate.text,
        "GestationalWeek": int.parse(weeks.text),
        "GestationalDays": int.parse(days.text),
        "NextUltrasoundDate": nextUltrasoundDate.text,
        "CTU1VisitDate": ctu1VisitDate.text,
        "LabResultsDate": dateOfLabResults.text,
        "PrescreeningVisitDate": prescreeningVisitDate.text,
        "IsPrenatalInfoColl": isPrenatalInformationCollected,
        "PrenatalCareLoc": prenatalCareLocation,
        "IsFetalBioNor": currentFetalBiometryInformation,
        "IsAmnioticFluidNor": currentAmnioticFluidIndexNormal,
        "FetAmniSpecText": fetalAndAmnioticReasonController.text,
        "VisFetAnomaly": currentVisibleFetalAnomaly,
        "OthVisAnomaly": currentPrenatalInfoOtherVisibleAnomaly,
        "VisOthAnomalySpecText":
            visibleFetalAnomalyAndOtherVisibleAnomalyReasonController.text,
        "PrenatalCareDate": prenatalCareDateController.text,
        "UltrasonographDate": prenatalUltrasonographDateController.text
      };

      await db.insert("WomenPregnancyInformation", row);
      db.close();
      //print(await db.query("WomenPregnancyInformation"));
      return true;
    } catch (exception) {
      Utils()
          .toastMessage("In SavePregnancyInformation" + exception.toString());
      return false;
    }
  }

  void postPregnancyInformationToWebApi() async {
    String apiUrl = WebApiConfig.webApplicationURL +
        WebApiConfig.postWomenPregnancyInformation;

    Map<String, dynamic> row = {
      "VRID": idVR.text,
      "PRISMAEnrol": pregnantWomenEnrolled,
      "PRISMAEnrolDate": prismaStudyEnrolDate.text,
      "LabSamplesCollected": labSamplesCollected,
      "UltrasoundDone": ultrasoundDone,
      "UltrasoundDate": ultraSoundDate.text,
      "EDD": eDD.text,
      "LMPDate": lMPDate.text,
      "GestationalWeek": int.parse(weeks.text),
      "GestationalDays": int.parse(days.text),
      "NextUltrasoundDate": nextUltrasoundDate.text,
      "CTU1VisitDate": ctu1VisitDate.text,
      "LabResultsDate": dateOfLabResults.text,
      "PrescreeningVisitDate": prescreeningVisitDate.text,
    };

    // Map<String, dynamic> row = {
    //   "VRID": "VR-12345",
    //   "MedidataScreeningID": "SRABCD",
    //   "FullName": "Uneeba Rafi",
    //   "CompleteAddress": "A 80",
    //   "PhoneNumber": "03340210489",
    //   "Age": 45
    // };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(row),
    );

    if (response.statusCode == 200) {
      //print('Data posted successfully');
    } else {
      //print('Failed to post data. Status code: ${response.statusCode}');
    }
  }

  Future<bool> SaveConsentInformation() async {
    try {
      Database db = await DBProvider().initDb();

      // row to insert
      Map<String, dynamic> row = {
        // "VRID": idVR.text,
        "WBID": wbIDPrimKey,
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "IsCounseled": counselingAtCenter,
        "HasAgreed": participationWomenSelectedValue,
        "AgreementReason": agreeParticipation.text,
        "HasConsented": consentWomenSelectedValue,
        "ConsentReason": consentReason.text,
        "FifthAppointmentDate": fifthAppointmentDate.text,
        "HasConsentedFifthDay": consentFifthWomenSelectedValue,
        "ConsentReasonFifthDay": consentFifthDayReason.text,
        "TenthAppointmentDate": tenthAppointmentDate.text,
        "HasConsentedTenthDay": consentTenthWomenSelectedValue,
        "ConsentReasonTenthDay": consentTenthDayReason.text
      };

      await db.insert("WomenVerbalConsentInformation", row);
      await db.close();
      return true;
      //print(await db.query("WomenVerbalConsentInformation"));
    } catch (exception) {
      Utils().toastMessage("In SaveConsentInformation " + exception.toString());
      return false;
    }
  }

  Future<bool> SaveVitalSignsInformation() async {
    try {
      Database db = await DBProvider().initDb();

      // row to insert
      Map<String, dynamic> row = {
        // "VRID": idVR.text,
        "WBID": wbIDPrimKey,
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "VitSignMeas": isVitalSignMeasured,
        "SysBP": vitalSignSystolicController.text,
        "DiasBP": vitalSignDiastolicController.text,
        "HeartRate": vitalSignHeartRateController.text,
        "ResRate": vitalSignRespiratoryRateController.text,
        "FetalHeartRate": fetalHeartRateController.text,
        "BodyTem": vitalSignBodyTempController.text,
        "BodyTemColMe": isbodyTempCollectionMethod,
        //"BodyTemColOth": consentFifthDayReason.text,
        //"SameVisDate": isVitalSignSameAsVisitDate,
        "DateOfTempCollection": vitalSignDateOfCollectionController.text,
        "TimeOfTempCollection": vitalSignTimeOfCollectionController.text
      };

      await db.insert("VitalSignsInformation", row);
      await db.close();
      return true;
      //print(await db.query("WomenVerbalConsentInformation"));
    } catch (exception) {
      Utils()
          .toastMessage("In SaveVitalSignsInformation " + exception.toString());
      return false;
    }
  }

  Future<bool> SaveFullPhyExamInformation() async {
    try {
      Database db = await DBProvider().initDb();
      if (isPhysicalExamPerformed == 1) {
        for (var bodySys in bodySystems) {
          if (fullPhysicalExamResults[bodySys] != 0) {
            Map<String, dynamic> row = {
              //"VRID": prescreeningModel.VRID,
              "WBID": wbIDPrimKey,
              "VRID": idVR.text,
              "MedidataScreeningID": medidataScreeningID.text,
              "FPEPerformed": isPhysicalExamPerformed,
              "FRNPReason": fullPhysicalExamReasonController.text,
              "SameVisDate": isFullPhysicalExamSameAsVisitDate,
              "DateOfExam": fullPhysicalDateOfExaminationController.text,
              "BodySys": bodySys.toString(),
              if (fullPhysicalExamResults[bodySys] == "Other")
                "OthFEText": otherFullPhysicalExamBodySystemController.text,
              "Result": fullPhysicalExamResults[bodySys]
            };

            await db.insert("FullPhyExamination", row);
          }
        }
      } else {
        Map<String, dynamic> row = {
          //"VRID": prescreeningModel.VRID,
          "WBID": wbIDPrimKey,
          "VRID": idVR.text,
          "MedidataScreeningID": medidataScreeningID.text,
          "FPEPerformed": isPhysicalExamPerformed,
          "FRNPReason": fullPhysicalExamReasonController.text,
        };
        await db.insert("FullPhyExamination", row);
      }
      await db.close();
      return true;
      //print(await db.query("WomenVerbalConsentInformation"));
    } catch (exception) {
      Utils().toastMessage(
          "In SaveFullPhyExamInformation " + exception.toString());
      return false;
    }
  }

  Future<bool> SaveMedHistoryInformation() async {
    try {
      Database db = await DBProvider().initDb();

      // row to insert
      Map<String, dynamic> row = {
        // "VRID": idVR.text,
        "WBID": wbIDPrimKey,
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "MedHist": hasMedicalHistory,
        "MedDisease": medicalHistoryDiseaseNameController.text,
      };

      await db.insert("MedHistoryInformation", row);
      await db.close();
      return true;
      //print(await db.query("WomenVerbalConsentInformation"));
    } catch (exception) {
      Utils()
          .toastMessage("In SaveMedHistoryInformation " + exception.toString());
      return false;
    }
  }

  Future<bool> SaveSubUseInformation() async {
    try {
      Database db = await DBProvider().initDb();

      // row to insert
      Map<String, dynamic> row = {
        // "VRID": idVR.text,
        "WBID": wbIDPrimKey,
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "TobUse": tobaccoUsage,
        "TobProducts": currenttobaccoUsageSelectedValue,
        "AlcUse": alcoholUsage,
        "AlcProducts": currentalcoholUsageSelectedValue,
      };

      await db.insert("SubstanceUse", row);
      await db.close();
      return true;
      //print(await db.query("WomenVerbalConsentInformation"));
    } catch (exception) {
      Utils().toastMessage("In SaveSubUseInformation " + exception.toString());
      return false;
    }
  }

  Future<bool> SaveStaffInformation() async {
    try {
      Database db = await DBProvider().initDb();

      // row to insert
      Map<String, dynamic> row = {
        // "VRID": idVR.text,
        "WBID": wbIDPrimKey,
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "DateOfEntry": dateOfEntry.text,
        "StaffName": nameOfStaff.text,
        "Site": selectedValue,
      };

      await db.insert("StaffInformation", row);
      await db.close();
      return true;
      //print(await db.query("WomenVerbalConsentInformation"));
    } catch (exception) {
      Utils().toastMessage("In SaveStaffInformation " + exception.toString());
      return false;
    }
  }

  Future<bool> SaveObsHisInformation() async {
    try {
      Database db = await DBProvider().initDb();
      if (obstetricHistoryNoOfPastPregController.text == '' ||
          obstetricHistoryNoOfPastPregController.text == null) {
        obstetricHistoryNoOfPastPregController.text = '0';
      }
      int pastPregNumber =
          int.parse(obstetricHistoryNoOfPastPregController.text);

      // row to insert
      Map<String, dynamic> row = {
        // "VRID": idVR.text,
        "WBID": wbIDPrimKey,
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "PrevPreg": haveAnyPrevPregObstetricHist,
        "Abortion": obstetricHistAnyAbortion,
        "NumPastPreg": pastPregNumber,
        "Delivery": obstetricHistAnyDelivery,
      };

      await db.insert("ObstetricHistory", row);
      await db.close();
      return true;
      //print(await db.query("WomenVerbalConsentInformation"));
    } catch (exception) {
      Utils().toastMessage("In SaveObsHisInformation " + exception.toString());
      return false;
    }
  }

  // ** Added by Iman ** //
  void SetMedidataFieldLetters() {
    String prefix = '';

    if (selectedValue == 'IH') {
      prefix = 'S1-';
    } else if (selectedValue == 'AG') {
      prefix = 'S2-';
    } else if (selectedValue == 'BH') {
      prefix = 'S3-';
    } else if (selectedValue == 'RG') {
      prefix = 'S4-';
    }

    String currentValue = medidataScreeningID.text;
    String updatedValue = '';

    if (currentValue.startsWith('S1-')) {
      updatedValue = currentValue.replaceFirst('S1-', prefix);
    } else if (currentValue.startsWith('S2-')) {
      updatedValue = currentValue.replaceFirst('S2-', prefix);
    } else if (currentValue.startsWith('S3-')) {
      updatedValue = currentValue.replaceFirst('S3-', prefix);
    } else if (currentValue.startsWith('S4-')) {
      updatedValue = currentValue.replaceFirst('S4-', prefix);
    } else {
      updatedValue = prefix + currentValue;
    }

    medidataScreeningID.text = updatedValue;
    medidataScreeningID.selection = TextSelection.fromPosition(
      TextPosition(offset: medidataScreeningID.text.length),
    );
  }

// ** ** //
//   SetMedidataFieldLetters()
//   {
//     if(selectedValue=='IH')
//     {
//       medidataScreeningID.text="S1-";
//     }
//     else if(selectedValue=='AG')
//     {
//       medidataScreeningID.text="S2-";
//     }
//     else if(selectedValue=='BH')
//     {
//       medidataScreeningID.text="S3-";
//     }
//     else
//     {
//       medidataScreeningID.text="S4-";
//     }
//   }

  void _validateInput(String value) {
    setState(() {
      if (value.length > 3 && !isNumeric(value.substring(3))) {
        _errorMessage = 'Enter numbers only after the first three characters';
      } else {
        _errorMessage = "";
      }
    });
  }

  Future<void> CheckForExistingVRId(String s_VRID) async {
    isVRIDAlreadyExists =
        await baselineInformationController.CheckForExistingVRID(s_VRID);
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  SetGestationalWeeksAndDays() {
    Duration gestationAgeDuration =
        GestationCalculations.GestationalAgeCalculation(lMPDate.text);
    int totalDays = 0;
    int gestationWeeks = 0;
    int gestationDays = 0;

    if (gestationAgeDuration != null) {
      totalDays = gestationAgeDuration.inDays;
      gestationWeeks = (totalDays ~/ 7) as int;
      gestationDays = totalDays % 7;

      weeks.text = gestationWeeks.toString();
      days.text = gestationDays.toString();
    }
  }

  String digitValidator(String value) {
    if (value.isEmpty) {
      return 'Medidata Screening ID is required';
    }
    if (value.length <= 3) {
      return ""; // Allow any input before the fourth character
    }

    String digits = value.substring(3);
    if (digits.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(digits)) {
      return 'Enter only digits after the third character';
    }

    return ""; // Validation passed
  }

  String? _ageValidator(String value) {
    if (value.isEmpty) {
      return 'Age is required';
    }
    int? age = int.tryParse(value);
    if (age == null) {
      return 'Valid Age is required';
    }
    if (age > 45 || age < 16) {
      return 'Age must between 16 and 45';
    }
    return null;
  }

  Future<bool> SaveWomenInformation() async {
    bool isSaveBaselineInformation = false;
    bool isSaveConsentInformation = false;
    bool isSavePregnancyInformation = false;
    bool isSaveVitalSignsInformation = false;
    bool isSaveHistoryInformation = false;
    bool isSaveSubUseInformation = false;
    bool isSaveObsHistInformation = false;
    bool isSaveFullPhysicalExamination = false;
    bool isSaveStaffInformation = false;
    bool isSavePrescreening = false;
    bool isAllSaved = false;

    try {
      isSaveBaselineInformation = await SaveBaselineInformation();

      if (isSaveBaselineInformation) {
        // if (!hidePregnancyInformation) {
        //   isSavePregnancyInformation = await SavePregnancyInformation();
        //
        //   if (!isSavePregnancyInformation) {
        //     return false;
        //   }
        // }

        if (!hideSecondFormInformation && !hidePregnancyInformation) {
          isSaveConsentInformation = await SaveConsentInformation();
          isSavePregnancyInformation = await SavePregnancyInformation();
          isSaveVitalSignsInformation = await SaveVitalSignsInformation();
          isSaveHistoryInformation = await SaveMedHistoryInformation();
          isSaveSubUseInformation = await SaveSubUseInformation();
          isSaveObsHistInformation = await SaveObsHisInformation();
          isSaveFullPhysicalExamination = await SaveFullPhyExamInformation();
          isSaveStaffInformation = await SaveStaffInformation();

          if (!isSavePregnancyInformation ||
              !isSaveConsentInformation ||
              !isSaveVitalSignsInformation ||
              !isSaveHistoryInformation ||
              !isSaveSubUseInformation ||
              !isSaveObsHistInformation ||
              !isSaveFullPhysicalExamination ||
              !isSaveStaffInformation) {
            return false;
          }
        }

        // if (isSaveConsentInformation)
        // {
        //   if (!hidePregnancyInformation)
        //   {
        //     isSavePregnancyInformation  = await SavePregnancyInformation();
        //
        //     if (!isSavePregnancyInformation)
        //     {
        //       return false;
        //     }
        //   }
        // }
        // else
        // {
        //   return false;
        // }

        if (lMPDate.text != null && lMPDate.text != "") {
          isSavePrescreening = await CalculateWomenPrescreening();
        }
        if (lMPDate.text == null || lMPDate.text == "") {
          isSavePrescreening = true;
        }
      } else {
        return false;
      }

      isAllSaved = isSavePregnancyInformation &&
          isSaveConsentInformation &&
          isSaveVitalSignsInformation &&
          isSaveHistoryInformation &&
          isSaveSubUseInformation &&
          isSaveObsHistInformation &&
          isSaveFullPhysicalExamination &&
          isSaveStaffInformation &&
          isSavePrescreening;

      print(isSavePregnancyInformation);
      print(isSaveConsentInformation);
      print(isSaveVitalSignsInformation);
      print(isSaveHistoryInformation);
      print(isSaveSubUseInformation);
      print(isSaveObsHistInformation);
      print(isSaveFullPhysicalExamination);
      print(isSaveStaffInformation);
      print(isSavePrescreening);

      return isAllSaved;
    } catch (exception) {
      Utils().toastMessage("In SaveWomenInformation " + exception.toString());
      return false;
    }
  }

  Future<bool> CalculateWomenPrescreening() async {
    bool isEligibleForScreening = false;
    bool isEligibleForPostScreening = false;
    List<PrescreeningVisits> prescreeningVisitsList = [];

    try {
      Duration gestationAgeDuration =
          GestationCalculations.GestationalAgeCalculation(lMPDate.text);

      if (gestationAgeDuration != null) {
        isEligibleForScreening =
            GestationCalculations.IsEligibleForPreScreening(
                gestationAgeDuration);
        if (isEligibleForScreening) {
          // List<PrescreeningVisits> prescreeningVisitsList =
          //     GestationCalculations.CalculatePrescreeningVisits(
          //         gestationAgeDuration, idVR.text);
          // List<PrescreeningVisits> prescreeningVisitsList =
          prescreeningVisitsList =
              GestationCalculations.CalculateTenthAndTwelvthPrescreeningVisits(
                  gestationAgeDuration, idVR.text);

          // await SavePrescreeningVisits(prescreeningVisitsList);
        }
        //Calculate for Post Screening Visits

        isEligibleForPostScreening =
            GestationCalculations.IsEligibleForPostScreening(
                gestationAgeDuration);

        if (isEligibleForPostScreening) {
          // List<PrescreeningVisits> prescreeningVisitsPostList =
          prescreeningVisitsList =
              await GestationCalculations.CalculateHEVPostScreeningVisits(
                  gestationAgeDuration, idVR.text);

          // await SavePrescreeningVisits(prescreeningVisitsPostList);
        }
        await SavePrescreeningVisits(prescreeningVisitsList);
      }
      return true;
    } catch (exception) {
      //print((exception));
      Utils().toastMessage(
          "In CalculateWomenPrescreening " + exception.toString());
      return false;
    }
  }

  SavePrescreeningVisits(
      List<PrescreeningVisits> a_lstPrescreeningVisitsList) async {
    try {
      womenPrecsreeningVisitInformationList = a_lstPrescreeningVisitsList;

      Database db = await DBProvider().initDb();
      // row to insert
      for (var prescreeningModel in a_lstPrescreeningVisitsList) {
        Map<String, dynamic> row = {
          //"VRID": prescreeningModel.VRID,
          "WBID": wbIDPrimKey,
          "VRID": idVR.text,
          "MedidataScreeningID": medidataScreeningID.text,
          "TypeOfVisit": prescreeningModel.TypeOfVisit,
          "VisitDate": prescreeningModel.VisitDate.toString(),
          "VisitDone": false
        };

        await db.insert("WomenPrescreeningVisitInformation", row);

        //print(await db.query("WomenPrescreeningVisitInformation"));
        // print(prescreeningModel.VisitDate);
        // print(prescreeningModel.TypeOfVisit);
      }

      db.close();
    } catch (exception) {
      // print(exception);
      Utils().toastMessage("WomenPrescreeningVisits " + exception.toString());
    }
  }

  Future<void> scheduleNotifications() async {
    // Define your list of appointment times
    List<DateTime> appointmentTimes = [
      DateTime.now().add(Duration(seconds: 10)),
      DateTime.now().add(Duration(seconds: 20)),
      DateTime.now().add(Duration(seconds: 30)),
    ];

    // Schedule notifications for each appointment time
    for (int i = 0; i < appointmentTimes.length; i++) {
      DateTime appointmentTime = appointmentTimes[i];
      String formattedTime =
          '${appointmentTime.hour}:${appointmentTime.minute}';

      String title = 'Appointment Reminder';
      String body = 'You have an appointment today at $formattedTime';

      await NotificationService().showNotification(
        id: i,
        title: title,
        body: body,
      );

      await Future.delayed(Duration(seconds: 10));
    }
  }

  Future<void> schedulePrescreeningNotifications() async {
    final List<Map<String, dynamic>>? queryResult =
        await DBProvider().getPrescreeningDataForToday();
    List<PrescreeningVisits> listPrescreening = [];
    String title = 'Appointment Reminder';
    String body = 'There is an appointment today for VRID:';
    int i = 1;

    if (queryResult != null) {
      for (var map in queryResult!) {
        listPrescreening.add(PrescreeningVisits.fromMap(map));
        //print(map);
      }
    }

    for (var visitModel in listPrescreening) {
      await NotificationService().showNotification(
        id: i,
        title: title,
        body: body + visitModel.VRID + " for Visit " + visitModel.TypeOfVisit,
      );
      print(visitModel.VRID);
      await Future.delayed(Duration(seconds: 10));
      i++;
    }
  }
}

class RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int? value = int.tryParse(newValue.text);
    if (value != null && value >= min && value <= max) {
      return newValue;
    }
    return oldValue;
  }
}
