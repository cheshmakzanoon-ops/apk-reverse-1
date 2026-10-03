local UILWMailDetail = BaseClass("UILWMailDetail", UIBaseContainer)
local base = UIBaseContainer
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")
local MailDetailType = {
  Common = 1,
  War = 2,
  Scout = 3,
  Muster = 4,
  AllianceCityRank = 5,
  InActivityMember = 6,
  AllianceCityOccupyReward = 7,
  Truck = 8,
  DesertBattleSignUp = 9,
  DesertBattleParticipants = 10,
  DesertBattleResult = 11,
  DesertBattleMatchResult = 12,
  AllyDrill = 13,
  Train = 14,
  TrainReward = 15,
  PersonalArmsDailyRank = 16,
  AllOut = 17,
  ResourceConsersion = 18,
  ZombieRush_Alliance = 19,
  Landmine = 20,
  BreakIce = 21,
  SeasonAllianceReward = 22,
  Disguise = 23,
  LW_MIGRATION_MARKET = 24,
  LW_METEORITE_RANK = 25,
  LW_METEORITE_KNOCKOUT_BIG = 26,
  LW_METEORITE_KNOCKOUT_SMALL = 27,
  AttackRuinBuilding = 28,
  RevivalActivity = 29,
  AllianceStarCommend = 30,
  AllianceMark = 31,
  REFUND_COMPLETE = 32,
  EpidemicBattleResult = 33,
  AllianceLeaderChange = 34,
  CityBattleS1RestStart = 35,
  SurfingBattleReward = 36,
  DsbDuelResult = 37,
  DsbDuelAllianceCondition = 38,
  BankReport = 39,
  HSR = 40,
  LandlordWeekResult = 41,
  S0AllianceBossAlliance = 42
}
local PrefabPath = {
  [MailDetailType.Common] = "Assets/Main/Prefabs/UI/LWMail/MailDetailCommon.prefab",
  [MailDetailType.War] = "Assets/Main/Prefabs/UI/LWMail/MailDetailWar.prefab",
  [MailDetailType.Scout] = "Assets/Main/Prefabs/UI/LWMail/MailDetailScout.prefab",
  [MailDetailType.Muster] = "Assets/Main/Prefabs/UI/LWMail/MailDetailMuster.prefab",
  [MailDetailType.AllianceCityRank] = "Assets/Main/Prefabs/UI/LWMail/MailDetailAllianceCityRank.prefab",
  [MailDetailType.InActivityMember] = "Assets/Main/Prefabs/UI/LWMail/MailDetailInActivityMember.prefab",
  [MailDetailType.AllianceCityOccupyReward] = "Assets/Main/Prefabs/UI/LWMail/MailDetailAllianceCityOccupyReward.prefab",
  [MailDetailType.Truck] = "Assets/Main/Prefabs/UI/LWMail/MailDetailTruck.prefab",
  [MailDetailType.HSR] = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Mail/MailDetailHSR.prefab",
  [MailDetailType.Train] = "Assets/Main/Prefabs/UI/LWMail/MailDetailTrain.prefab",
  [MailDetailType.TrainReward] = "Assets/Main/Prefabs/UI/LWMail/MailDetailTrainReward.prefab",
  [MailDetailType.DesertBattleParticipants] = "Assets/Main/Prefabs/UI/LWMail/MailDetailDesertBattleParticipants.prefab",
  [MailDetailType.DesertBattleSignUp] = "Assets/Main/Prefabs/UI/LWMail/MailDetailDesertBattleSignUp.prefab",
  [MailDetailType.DesertBattleResult] = "Assets/Main/Prefabs/UI/LWMail/MailDetailDesertBattleResult.prefab",
  [MailDetailType.DesertBattleMatchResult] = "Assets/Main/Prefabs/UI/LWMail/MailDetailDesertBattleMatchResult.prefab",
  [MailDetailType.AllyDrill] = "Assets/Main/Prefabs/UI/LWMail/MailDetailAllyDrill.prefab",
  [MailDetailType.PersonalArmsDailyRank] = "Assets/Main/Prefabs/UI/LWMail/MailDetailPersonalArmsDailyRank.prefab",
  [MailDetailType.AllOut] = "Assets/Main/Prefabs/UI/LWMail/MailDetailAllOut.prefab",
  [MailDetailType.ResourceConsersion] = "Assets/Main/Prefabs/UI/LWMail/MailDetailResourceConversion/MailDetailResConversion.prefab",
  [MailDetailType.ZombieRush_Alliance] = "Assets/Main/Prefabs/UI/LWMail/MailDetailZombieRush.prefab",
  [MailDetailType.Landmine] = "Assets/Main/Prefabs/UI/LWMail/MailDetailLandmine.prefab",
  [MailDetailType.BreakIce] = "Assets/Main/Prefabs/UI/LWMail/MailDetailBreakIce.prefab",
  [MailDetailType.Disguise] = "Assets/Main/Prefabs/UI/LWMail/MailDetailDisguise.prefab",
  [MailDetailType.LW_MIGRATION_MARKET] = "Assets/Main/Prefabs/UI/LWMail/MailDetailMigrationMarket.prefab",
  [MailDetailType.AttackRuinBuilding] = "Assets/Main/Prefabs/UI/LWMail/MailDetailAttackRuinBuilding.prefab",
  [MailDetailType.LW_METEORITE_RANK] = "Assets/Main/Prefabs/UI/LWMail/MailDetailMeteoriteRank.prefab",
  [MailDetailType.LW_METEORITE_KNOCKOUT_BIG] = "Assets/Main/Prefabs/UI/LWMail/MailDetailMeteoriteMoveNoticeBig.prefab",
  [MailDetailType.LW_METEORITE_KNOCKOUT_SMALL] = "Assets/Main/Prefabs/UI/LWMail/MailDetailMeteoriteMoveNoticeSmall.prefab",
  [MailDetailType.RevivalActivity] = "Assets/Main/Prefabs/UI/LWMail/MailDetailRevivalActivity.prefab",
  [MailDetailType.AllianceStarCommend] = "Assets/Main/Prefabs/UI/LWMail/MailDetailAllianceStarCommend.prefab",
  [MailDetailType.REFUND_COMPLETE] = "Assets/Main/Prefabs/UI/LWMail/MailDetailRefundComplete.prefab",
  [MailDetailType.AllianceMark] = "Assets/Main/Prefabs/UI/LWMail/MailDetailAllianceMark.prefab",
  [MailDetailType.EpidemicBattleResult] = "Assets/Main/Prefabs/UI/BF_Epidemic/Common/MailDetailEpidemicBattleResult.prefab",
  [MailDetailType.CityBattleS1RestStart] = "Assets/Main/Prefabs/UI/LWOffSeason1/LWMail/MailDetailCityBattleS1RestStart.prefab",
  [MailDetailType.SurfingBattleReward] = "Assets/Main/Prefabs/UI/LWMail/MailDetailSurfingBattle.prefab",
  [MailDetailType.DsbDuelResult] = "Assets/Main/Prefabs/UI/LWMail/DsbDuel/MailDetailDsbDuelResult.prefab",
  [MailDetailType.DsbDuelAllianceCondition] = "Assets/Main/Prefabs/UI/LWMail/DsbDuel/MailDetailDsbDuelAllianceCondition.prefab",
  [MailDetailType.AllianceLeaderChange] = "Assets/Main/Prefabs/UI/LWMail/UILWMailAllianceLeaderChange.prefab",
  [MailDetailType.BankReport] = "Assets/Main/Prefabs/UI/LWMail/MailDetailBankReport.prefab",
  [MailDetailType.LandlordWeekResult] = "Assets/Main/Prefabs/UI/LWMail/Landlord/MailDetailLandlordResult.prefab",
  [MailDetailType.S0AllianceBossAlliance] = "Assets/Main/Prefabs/UI/LWMail/MailDetailS0AllianceBoss.prefab"
}
local ScriptPath = {
  [MailDetailType.Common] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailCommon",
  [MailDetailType.War] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailWar",
  [MailDetailType.Scout] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailScout",
  [MailDetailType.Muster] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailMuster",
  [MailDetailType.AllianceCityRank] = "UI.UILWMail.UILWMailMain.Component.MailDetailAllianceCityRank",
  [MailDetailType.InActivityMember] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailInActivityMember",
  [MailDetailType.AllianceCityOccupyReward] = "UI.UILWMail.UILWMailMain.Component.MailDetailAllianceCityOccupyReward",
  [MailDetailType.Truck] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailTruck",
  [MailDetailType.HSR] = "UI.UILWMail.UILWMailMain.Component.MailDetailHSRComponent",
  [MailDetailType.Train] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailTrain",
  [MailDetailType.TrainReward] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailTrainReward",
  [MailDetailType.DesertBattleResult] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailDesertBattleResult",
  [MailDetailType.DesertBattleSignUp] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailDesertBattleSignUp",
  [MailDetailType.DesertBattleParticipants] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailDesertBattleParticipants",
  [MailDetailType.DesertBattleMatchResult] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailDesertBattleMatchResult",
  [MailDetailType.AllyDrill] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailAllyDrill",
  [MailDetailType.PersonalArmsDailyRank] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailPersonalArmsDailyRank",
  [MailDetailType.AllOut] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailAllOut",
  [MailDetailType.ResourceConsersion] = "UI.UILWMail.UILWMailMain.Component.UILWMailResConversion",
  [MailDetailType.ZombieRush_Alliance] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailZombieRush",
  [MailDetailType.Landmine] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailLandmine",
  [MailDetailType.BreakIce] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailBreakIce",
  [MailDetailType.Disguise] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailDisguise",
  [MailDetailType.LW_MIGRATION_MARKET] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailMigrationMarket",
  [MailDetailType.AttackRuinBuilding] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailAttackRuinBuilding",
  [MailDetailType.LW_METEORITE_RANK] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailMeteoriteRank",
  [MailDetailType.LW_METEORITE_KNOCKOUT_BIG] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailMeteoriteMoveNoticeBig",
  [MailDetailType.LW_METEORITE_KNOCKOUT_SMALL] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailMeteoriteMoveNoticeSmall",
  [MailDetailType.RevivalActivity] = "UI.UILWMail.UILWMailMain.Component.UIMailDetailRevivalActivity",
  [MailDetailType.AllianceStarCommend] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailAllianceStarCommend",
  [MailDetailType.REFUND_COMPLETE] = "UI.UILWMail.UILWMailMain.Component.UILWMailRefundComplete",
  [MailDetailType.AllianceMark] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailAllianceMark",
  [MailDetailType.EpidemicBattleResult] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailEpidemicBattleResult",
  [MailDetailType.SurfingBattleReward] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailSurfingBattle",
  [MailDetailType.CityBattleS1RestStart] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailCityBattleS1RestStart",
  [MailDetailType.DsbDuelResult] = "UI.UILWMail.UILWMailMain.Component.MailDsbDuel.UILWMailDetailDsbDuelBattleResult",
  [MailDetailType.DsbDuelAllianceCondition] = "UI.UILWMail.UILWMailMain.Component.MailDsbDuel.UILWMailDetailDsbDuelAllianceCondition",
  [MailDetailType.AllianceLeaderChange] = "UI.UILWMail.UILWMailMain.Component.UILWMailAllianceLeaderChange",
  [MailDetailType.BankReport] = "UI.UILWMail.UILWMailMain.Component.UILWMailDetailBankReport",
  [MailDetailType.LandlordWeekResult] = "UI.UILWMail.UILWMailMain.Component.MailLandlord.UILWMailDetailLandlordWeekResult",
  [MailDetailType.S0AllianceBossAlliance] = "UI.UILWMail.UILWMailMain.Component.UIMailDetailS0AllianceBossAlliance"
}
local MailDetailScript = {}

function UILWMailDetail:GetScript(mailDetailType)
  if not MailDetailScript[mailDetailType] then
    MailDetailScript[mailDetailType] = require(ScriptPath[mailDetailType])
  end
  return MailDetailScript[mailDetailType]
end

function UILWMailDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMailDetail:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetail:ComponentDefine()
  self.mailDetailList = {}
  self.req = {}
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
end

function UILWMailDetail:CreateDetail(type, refresh)
  self.req[type] = self:GameObjectInstantiateAsync(PrefabPath[type], function(req)
    if IsNull(req) then
      return
    end
    local gameObject = req.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.transform)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local name = gameObject.name
    self.mailDetailList[type] = self:AddComponent(self:GetScript(type), name)
    self.mailDetailList[type]:SetOffsetMaxXY(0, 0)
    self.mailDetailList[type]:SetOffsetMinXY(0, 0)
    refresh(self.mailDetailList[type])
  end)
end

function UILWMailDetail:ComponentDestroy()
  self.mailDetailList = {}
  for _, v in pairs(self.req) do
    v:Destroy()
  end
  self.req = {}
  self.uid = nil
  self.canvasGroup = nil
end

function UILWMailDetail:RefreshContent()
  if not self.view.ctrl:GetCurrentMailData() then
    return
  end
  local mailData = self.view.ctrl:GetCurrentMailData()
  if mailData then
    mailData:OnMailIntegrityExecute(function(mailInfo)
      if not self.view then
        return
      end
      local nowMail = self.view.ctrl:GetCurrentMailData()
      if not nowMail then
        return
      end
      if nowMail.uid ~= mailInfo.uid then
        return
      end
      local type = self:GetDetailType()
      local uid = self.view.ctrl:GetCurrentMailData().uid
      Logger.LogCustom("mailUid: " .. uid)
      self:RefreshDetail(type, function(mailDetail)
        mailDetail:SetActive(true)
        if uid ~= self.uid and self.view.ctrl:GetCurrentView() >= 3 then
          self.uid = uid
          mailDetail:RefreshContent()
        end
      end)
      for k, v in pairs(self.mailDetailList) do
        if k ~= type then
          v:SetActive(false)
        end
      end
    end)
  end
end

function UILWMailDetail:ShowMusterSolo()
  self:RefreshDetail(MailDetailType.War, function(mailDetail)
    mailDetail:SetActive(true)
    if self.view.ctrl:GetCurrentView() == 4 then
      mailDetail:RefreshContent()
    end
  end)
  for k, v in pairs(self.mailDetailList) do
    if k ~= MailDetailType.War then
      v:SetActive(false)
    end
  end
end

function UILWMailDetail:RefreshDetail(type, callback)
  local mailData = self.view.ctrl:GetCurrentMailData()
  if mailData then
    mailData:OnMailIntegrityExecute(function()
      if self.view then
        if self.mailDetailList[type] then
          callback(self.mailDetailList[type])
        else
          self:CreateDetail(type, callback)
        end
      end
    end)
    if mailData.type == MailType.LW_ALLIANCE_GROUP_MAIL then
      AlPostEventLog.PostEventLog_Mail_Action(AlPostEventLog.MailAction.Open)
    end
  end
end

function UILWMailDetail:GetDetailType()
  local mailData = self.view.ctrl:GetCurrentMailData()
  local curMailType = mailData.type
  local extData = mailData:GetMailExt()
  local mailId = mailData:GetContentMailId()
  if IsMailScoutType(curMailType) or IsMailBeScoutType(curMailType) or curMailType == MailType.LW_SEASON_SCOUT_MAIL then
    return MailDetailType.Scout
  elseif BattleReportMailType[curMailType] then
    if extData.isMuster then
      return MailDetailType.Muster
    else
      return MailDetailType.War
    end
  elseif curMailType == MailType.LW_INACTIVITY_MEMBER_MAIL then
    return MailDetailType.InActivityMember
  elseif curMailType == MailType.ALLIANCE_CITY_RANK then
    return MailDetailType.AllianceCityRank
  elseif curMailType == MailType.ALLIANCE_CITY_OCCUPIED_REWARD then
    return MailDetailType.AllianceCityOccupyReward
  elseif curMailType == MailType.TRUCK then
    return MailDetailType.Truck
  elseif curMailType == MailType.ZONE_TRAIN_TRADE_SETTLE then
    return MailDetailType.HSR
  elseif curMailType == MailType.TRAIN_DEPARTURE or curMailType == MailType.TRAIN_ARRIVE then
    return MailDetailType.Train
  elseif curMailType == MailType.TRAIN_REWARD then
    return MailDetailType.TrainReward
  elseif curMailType == MailType.DESERT_BATTLE_RESULT then
    return MailDetailType.DesertBattleResult
  elseif curMailType == MailType.DESERT_BATTLE_PARTICIPANTS then
    return MailDetailType.DesertBattleParticipants
  elseif curMailType == MailType.DESERT_BATTLE_BEGIN then
    return MailDetailType.DesertBattleSignUp
  elseif curMailType == MailType.DESERT_BATTLE_MATCH_RESULT then
    return MailDetailType.DesertBattleMatchResult
  elseif curMailType == MailType.LW_ALLIANCE_BOSS_ALLIANCE_MAIL then
    return MailDetailType.AllyDrill
  elseif curMailType == MailType.PERSON_ARMS_DAILY_RANK then
    return MailDetailType.PersonalArmsDailyRank
  elseif curMailType == MailType.ALL_OUT then
    return MailDetailType.AllOut
  elseif curMailType == MailType.LW_SEASON_END_COMPENSATE then
    return MailDetailType.ResourceConsersion
  elseif curMailType == MailType.LW_ZOMBIE_RUSH_ALLIANCE_MAIL then
    return MailDetailType.ZombieRush_Alliance
  elseif curMailType == MailType.LANDMINE then
    return MailDetailType.Landmine
  elseif curMailType == MailType.DISGUISE_ATTACK then
    return MailDetailType.Disguise
  elseif curMailType == MailType.LW_SEASON_BREAK_ICE_MAIL then
    return MailDetailType.BreakIce
  elseif curMailType == MailType.LW_SEASON_ALLIANCE_REWARD_MAIL then
    return MailDetailType.SeasonAllianceReward
  elseif curMailType == MailType.LW_MIGRATION_MARKET then
    return MailDetailType.LW_MIGRATION_MARKET
  elseif curMailType == MailType.ATTACK_RUIN_BUILDING then
    return MailDetailType.AttackRuinBuilding
  elseif curMailType == MailType.LW_METEORITE_RANK then
    return MailDetailType.LW_METEORITE_RANK
  elseif curMailType == MailType.LW_METEORITE_KNOCKOUT_BIG then
    return MailDetailType.LW_METEORITE_KNOCKOUT_BIG
  elseif curMailType == MailType.LW_METEORITE_KNOCKOUT_SMALL then
    return MailDetailType.LW_METEORITE_KNOCKOUT_SMALL
  elseif curMailType == MailType.ALLIANCE_WEEKLY_STAR_MAIL then
    return MailDetailType.AllianceStarCommend
  elseif curMailType == MailType.REVIVAL_ACTIVITY then
    return MailDetailType.RevivalActivity
  elseif curMailType == MailType.ALLIANCE_BOSS_SAND_ATTACK_CITY then
    return MailDetailType.RevivalActivity
  elseif curMailType == MailType.REFUND_COMPLETE then
    return MailDetailType.REFUND_COMPLETE
  elseif curMailType == MailType.MAIL_ALLIANCE_MARK_ADD then
    return MailDetailType.AllianceMark
  elseif curMailType == MailType.EPIDEMIC_BATTLE_RESULT then
    return MailDetailType.EpidemicBattleResult
  elseif curMailType == MailType.CITY_BATTLE_S1_REST_START then
    return MailDetailType.CityBattleS1RestStart
  elseif curMailType == MailType.MAIL_AL_LEADER_CHANGE then
    return MailDetailType.AllianceLeaderChange
  elseif curMailType == MailType.MAIL_AL_AL_COMMON and MailIdToDetailType[mailId] == MailType.MAIL_AL_AL_COMMON then
    return MailDetailType.AllianceLeaderChange
  elseif curMailType == MailType.SURFING_BATTLE_REWARD then
    return MailDetailType.SurfingBattleReward
  elseif curMailType == MailType.SEASON_BANK then
    return MailDetailType.BankReport
  elseif curMailType == MailType.DSB_DUEL_BATTLE_RESULT then
    return MailDetailType.DsbDuelResult
  elseif curMailType == MailType.DSB_DUEL_ALLIANCE_CONDITION or curMailType == MailType.DSB_DUEL_ALLIANCE_CONDITION_FAIL or curMailType == MailType.DSB_DUEL_ALLIANCE_CONDITION_SUCCESS then
    return MailDetailType.DsbDuelAllianceCondition
  elseif curMailType == MailType.LANDLORD_WEEK_RESULT then
    return MailDetailType.LandlordWeekResult
  elseif curMailType == MailType.S0_ALLIANCE_BOSS_ALLIANCE then
    return MailDetailType.S0AllianceBossAlliance
  else
    return MailDetailType.Common
  end
end

function UILWMailDetail:SetShow(bool)
  local tab = 0
  if self.view and self.view.ctrl then
    tab = self.view.ctrl:GetCurrentTab()
  end
  if tab == MailInternalGroup.MAIL_IN_report then
    if bool then
      self:SetActive(true)
    end
    self.canvasGroup:SetShow(bool)
  else
    if bool then
      self.canvasGroup:SetShow(true)
    end
    self:SetActive(bool)
  end
end

return UILWMailDetail
