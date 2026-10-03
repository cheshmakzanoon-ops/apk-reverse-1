local InterfaceConfig = {}
InterfaceConfig.Describable = {
  "Description"
}
InterfaceConfig.BattlefieldManager = {
  "OnInit",
  "OnDelete",
  "ResetData",
  "GetActInfo",
  "UpdateAreaMaterial",
  "GetBGM",
  "CheckBattleStart",
  "ReqBattleEffect",
  "GetClosestPos",
  "GetWorldCamp",
  "GetBuildUpEffInfo",
  "CanShowEnter",
  "CanGotoMap",
  "LocalCheckCanEnterBattlefield",
  "SendEnterBattleMessage",
  "ServerCheckCanEnterBattlefield",
  "BeforeEnterBattlefield",
  "AfterEnterBattlefield",
  "GetBuildData",
  "FillBuildBtnList",
  "BuildOpenCheck",
  "HandleBuildingHpChange",
  "CanMultiAssistance",
  "GetBuildBestMarch",
  "GetAttackInfo"
}
InterfaceConfig.BattlefieldTreatment = {
  "SendDragonHospitalViewMsg",
  "SendDragonHospitalFinishMsg",
  "GetTreatmentSpeed",
  "GetAccumulativeTreatmentSoldierNum",
  "GetTreatmentFinishSoldierNum",
  "GetTreatmentSoldierDataList"
}
InterfaceConfig.BattlefieldEnterCheck = {
  "CheckAllianceIsValid",
  "CheckSelfAssigned"
}
InterfaceConfig.UIBFBaseSelectUserCtrl = {
  "GetPlayerList",
  "IsInPrepTime",
  "IsTeamSignUp",
  "IsHadTeam2",
  "IsUserCanJoin",
  "LoadTeamSprite",
  "GetPlayerInfoByUID",
  "GetBattleTimeInfo",
  "GetCurNumByState",
  "SelectPlayer",
  "CancelPlayer",
  "GetTeamBattlePeriod",
  "GetTopBarPrefabPath",
  "GetMemberListPrefabPath",
  "GetMemberItemPrefabPath",
  "GetTitleContentPrefabPath",
  "GetBattlefieldType",
  "GetFilterBattleTimeItemClass",
  "GetSelectUserInfoClass",
  "GetSelectUserItemClass",
  "GetSelectUserTitleClass",
  "GetSelectUserTopBarClass"
}
return InterfaceConfig
