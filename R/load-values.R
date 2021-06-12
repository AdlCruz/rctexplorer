
# variables to manipulate in set_app_input()

age_cols <- c("MinimumAge","MaximumAge")

fct_cols <- c(
  "AgreementRestrictionType",
  "ArmGroupType",
  "AvailIPDType",
  "BaselineDenomUnits",
  "BaselineMeasureDispersionType",
  "BaselineMeasureParamType",

  "CompletionDateType",
  "ConditionMeshId",
  "ConditionMeshTerm",
  "DelayedPosting",
  "DesignAllocation",
  "DesignInterventionModel",

  "DesignMasking",

  "DesignPrimaryPurpose",
  "DesignTimePerspective",
  "DesignWhoMasked",

  "DispFirstPostDate",
  "DispFirstPostDateType",
  "DispFirstSubmitDate",
  "DispFirstSubmitQCDate",

  "EnrollmentType",

  "FDAAA801Violation",

  "Gender",
  "GenderBased",
  "HasExpandedAccess",
  "HealthyVolunteers",
  "IPDSharing",

  "InterventionMeshId",
  "InterventionMeshTerm",

  "InterventionType",
  "IsFDARegulatedDevice",
  "IsFDARegulatedDrug",
  "IsPPSD",
  "IsUSExport",
  "IsUnapprovedDevice",

  "LastUpdatePostDateType",

  "LeadSponsorClass",

  "LocationCity",

  "LocationCountry",

  "LocationState",
  "LocationStatus",

  "MaximumAge",
  "MinimumAge",

  "OutcomeAnalysisDispersionType",

  "OutcomeAnalysisNonInferiorityType",

  "OutcomeAnalysisParamType",

  "OutcomeMeasureDispersionType",
  "OutcomeMeasureParamType",

  "OutcomeMeasureReportingStatus",

  "OutcomeMeasureType",
  "OutcomeMeasureTypeUnitsAnalyzed",
  "OutcomeMeasureUnitOfMeasure",

  "OverallOfficialAffiliation",

  "OverallStatus",
  "OversightHasDMC",
  "PatientRegistry",
  "Phase",

  "PrimaryCompletionDateType",


  "ReferenceType",

  "ResponsiblePartyType",

  "ResultsFirstPostDateType",

  "StartDateType",

  "StudyFirstPostDateType",

  "StudyPopulation",
  "StudyType",
  "TargetDuration",

  "UnpostedEventType",

  "VersionHolder",
  "WhyStopped",
  "Condition",
  "MinimumAge",
  "MaximumAge",
  "AgeRange",
  "HealthyVolunteers",
  "OversightHasDMC",
  "HasResults")


date_cols <- c("StartDate","CompletionDate")


#usethis::use_data(age_cols,fct_cols,date_cols, internal = T, overwrite = T)

