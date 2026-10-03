local UILWAlMainCtrl = BaseClass("UILWAlMainCtrl", UIBaseCtrl)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

function UILWAlMainCtrl:__init()
end

function UILWAlMainCtrl:__delete()
end

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMain)
end

local function GetAlInfos(self)
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if alData == nil then
    return
  end
  local icon = alData.icon
  local announce = alData.announce
  local name = "[" .. alData.abbr .. "] " .. alData.allianceName
  local gift = DataCenter.AllianceGiftDataManager:GetCurLevel()
  local power = string.GetFormattedSeperatorNum(alData.fightPower)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(alData.leaderUid, alData.leaderName)
  local leader = alData.leaderUid == "" and Localization:GetString("100206") or showName
  local member = alData.curMember .. "/" .. alData.maxMember
  local uid = alData.uid
  local scoreInfo = {
    allianceScore = alData.allianceScore,
    powerScore = alData.powerScore,
    rewardScore = alData.rewardScore,
    dailyTaskScore = alData.dailyTaskScore,
    r4LimitScore = alData.r4LimitScore,
    comprehensiveScore = alData.comprehensiveScore,
    blackIndustryScore = alData.blackIndustryScore
  }
  local infos = {
    icon = icon,
    announce = announce,
    name = name,
    gift = gift,
    power = power,
    leader = leader,
    member = member,
    language = alData.language,
    translateMsg = alData:GetTranslationMsg(),
    translating = alData:GetIsTranslating(),
    uid = uid,
    scoreInfo = scoreInfo
  }
  return infos
end

local function OnMidBtnClick(self, type)
  if type == LWAlMainMidBtnType.Al_Member then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMember, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_Help then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlHelp, {anim = true})
  elseif type == LWAlMainMidBtnType.Al_Gift then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceGift, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_War then
    DataCenter.AllianceWarDataManager:OpenALWarMain(true)
  elseif type == LWAlMainMidBtnType.Al_Science then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWPlayerDetail) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_Shop then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true, hideTop = true}, CommonShopType.AllianceShop)
  elseif type == LWAlMainMidBtnType.Al_Achieve then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask, {anim = true, hideTop = true}, nil, false)
  elseif type == LWAlMainMidBtnType.Al_Gather then
    if not DataCenter.AllianceRallyPointDataManager:CanAllianceMoveCity() then
      UIUtil.ShowTipsId("alliance_AssemblyPoint_tips_06")
    elseif LuaEntry.Player:IsLoginSourceServer() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlAssemblyInfo, {anim = true, hideTop = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlAssemblyInfo, {anim = true, hideTop = true})
    end
  elseif type == LWAlMainMidBtnType.Al_Rank then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceRank, {anim = true})
  elseif type == LWAlMainMidBtnType.Al_City_Effect then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityEffectTips)
  elseif type == LWAlMainMidBtnType.Al_City then
    if SeasonUtil.IsInSeason() then
      local seasonType = SeasonUtil.GetSeasonType()
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
      if SeasonUtil.SeasonHasCityStronghold(seasonType) then
        SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
      end
      if SeasonUtil.SeasonHasTradingStation(seasonType) then
        SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStationList)
      end
      SeasonUtil.ShowSeasonUI(UIWindowNames.UILWSeasonCityOccupyList, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    else
      SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityAttackCityDetail)
    end
  elseif type == LWAlMainMidBtnType.Al_SeasonCity then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCity, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_SeasonDevote then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonAllianceRank, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_SeasonMilestone then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask, {anim = true, hideTop = true}, nil, true)
  elseif type == LWAlMainMidBtnType.Al_SeasonStoveCenter then
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonStoveCenter, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_SeasonMilitaryCenter then
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMilitaryCenter, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_Season4Center then
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason4Center, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_GovernmentSkill then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGovernmentSkill, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_CityAttachment then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityAttachment, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_Activity then
    if DataCenter.ActivityListDataManager:IsContainActivityGroup(CommonActivityGroupEnum.Alliance) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, CommonActivityGroupEnum.Alliance)
    elseif not LuaEntry.Player:IsLoginSourceServer() then
      UIUtil.ShowTipsId("alliance_activity_err_crossServer")
    else
      UIUtil.ShowTipsId(393003)
    end
  elseif type == LWAlMainMidBtnType.Al_MakeFriends then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsMainUI, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif type == LWAlMainMidBtnType.Al_MilitaryPay then
    local state = DataCenter.AllianceMilitaryPayDataManager:GetActivityState()
    if state == SalaryActivityState.NotOpen then
      UIUtil.ShowTipsId(120018)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWAllianceMilitaryPayMainView, {anim = true, hideTop = true})
  elseif type == LWAlMainMidBtnType.Al_Camp_Science then
    if not DataCenter.CampScienceDataManager:IsOpenCampScience() then
      return
    end
    GoToUtil.GoToCampScience()
  elseif type == LWAlMainMidBtnType.Al_Alliance_Skill then
    GoToUtil.GoToNewAllianceSkill()
  else
    UIUtil.ShowTipsId(393003)
  end
end

local function OnDownBtnClick(self, type)
  if type == LWAlMainDownBtnType.Al_Setting then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlSetting)
    if GMUtils.GetBool(GMConst.DebugClickLogWarning, false) and LuaEntry.Player.allianceId then
      UIUtil.ShowTips(string.format("\232\129\148\231\155\159id\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191"))
      CommonUtil.CopyTextToClipboard(LuaEntry.Player.allianceId)
      Logger.Log(LuaEntry.Player.allianceId)
    end
  elseif type == LWAlMainDownBtnType.Al_Apply then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceApplication)
    else
      UIUtil.ShowTipsId(393018)
    end
  elseif type == LWAlMainDownBtnType.Al_Record then
    if string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
      UIUtil.ShowTipsId("monster_invasion_no_alliance")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceLog)
  elseif type == LWAlMainDownBtnType.Al_StarLog then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceStarBook, {anim = true})
  else
    UIUtil.ShowTipsId(393003)
  end
end

local function TranslateAnnounce()
  local translateManager = DataCenter.MailDataManager.Translate
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  data:SetIsTranslating(true)
  translateManager:Translate(data, translateManager.TranslateEnum.AlianceAnnouncement)
end

local function GetRedPotCountByType(self, type)
  local count = 0
  if type == LWAlMainMidBtnType.Al_Help then
    count = DataCenter.AllianceHelpDataManager:GetHelpNum()
  elseif type == LWAlMainMidBtnType.Al_Gift then
    count = DataCenter.AllianceGiftDataManager:GetGiftNum()
  elseif type == LWAlMainMidBtnType.Al_War then
    count = DataCenter.AllianceWarDataManager:GetAllianceWarRed()
    count = count + DataCenter.AllianceWarDataManager:GetAlertNum()
    count = count + DataCenter.AllianceAlertDataManager:GetAlertNum()
  elseif type == LWAlMainMidBtnType.Al_Science then
    count = DataCenter.AllianceScienceDataManager:GetAllianceScienceRedpointCount()
  elseif type == LWAlMainMidBtnType.Al_Shop then
    count = DataCenter.CommonShopManager:GetRedCount(CommonShopType.AllianceShop)
  elseif type == LWAlMainMidBtnType.Al_Achieve then
    if DataCenter.AllianceTaskManager:CheckIfAllianceTaskOpen() then
      count = DataCenter.AllianceTaskManager:GetTaskRedCount()
    end
  elseif type == LWAlMainMidBtnType.Al_SeasonMilestone then
    count = DataCenter.AllianceSeasonTaskManager:GetTaskRedCount()
  elseif type == LWAlMainMidBtnType.Al_City then
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType ~= SeasonMapType.Nothing then
      if seasonType ~= SeasonMapType.CityStronghold and 0 < table.count(DataCenter.SeasonDataManager.CrossOccupyStrongholdList) then
        local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
        if RewardInfo and 0 < #RewardInfo then
          for _, v in ipairs(RewardInfo) do
            count = count + toInt(v.leftNum)
          end
        end
      end
      if seasonType == SeasonMapType.Darkness and DataCenter.BloodyNightDataManager:IsBloodyNight() then
        count = count + DataCenter.AllianceWarDataManager:GetGhostTipNum()
      end
    else
      count = DataCenter.WorldAllianceCityDataManager:OccupyRewardCount()
    end
  elseif type == LWAlMainMidBtnType.Al_City_Effect then
    count = 0
  elseif type == LWAlMainMidBtnType.Al_SeasonStoveCenter then
    count = 0
  elseif type == LWAlMainMidBtnType.Al_SeasonMilitaryCenter and DataCenter.AllianceMineManager:IsAllianceCenterHasProduce() then
    count = 1
  elseif type == LWAlMainMidBtnType.Al_Season4Center and DataCenter.AllianceMineManager:IsAllianceCenterHasProduce() then
    count = 1
  elseif type == LWAlMainMidBtnType.Al_GovernmentSkill then
    count = 0
  elseif type == LWAlMainMidBtnType.Al_Gather then
    local redPointCount, selfFarAwayRedPoint, farAwayMemberRedPoint = DataCenter.AllianceRallyPointDataManager:GetAllianceGatherRedPoint()
    count = redPointCount
  elseif type == LWAlMainMidBtnType.Al_CityAttachment then
    count = DataCenter.SeasonFarmerManager:CountOfBuildReward()
  elseif type == LWAlMainMidBtnType.Al_Activity then
    count = DataCenter.ActivityListDataManager:GetActivityRedCountByGroupId(CommonActivityGroupEnum.Alliance)
  elseif type == LWAlMainMidBtnType.Al_MilitaryPay then
    count = DataCenter.AllianceMilitaryPayDataManager:GetRedPointNum()
  elseif type == LWAlMainMidBtnType.Al_MakeFriends then
    local allyCombinedList = DataCenter.SeasonAllyFriendManager:GetAllyCombinedList()
    if allyCombinedList ~= nil then
      count = table.count(allyCombinedList.recList)
    end
    if count == 0 and DataCenter.SeasonAllyFriendManager.friendMarkDirty then
      count = 1
    end
    if count == 0 then
      count = DataCenter.SeasonAllyFriendManager:GetNewLogCount()
    end
  elseif type == LWAlMainMidBtnType.Al_Camp_Science then
    count = DataCenter.CampScienceDataManager:GetRedPointNum()
  elseif type == LWAlMainMidBtnType.Al_Alliance_Skill then
    count = DataCenter.AllianceGovernmentCommonSkillManager:GetRedPointNum()
  end
  return count
end

local function GetMidShowBtnsList(self)
  local ret = {}
  local existDevoteData = DataCenter.SeasonDataManager.ExistDevoteData
  local season = SeasonUtil.GetSeason()
  local isInSeason = SeasonUtil.IsInSeason(false)
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  local seasonIsOpen = SeasonUtil.IsOpen()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  if theStoveCenter ~= nil and seasonIsOpen then
    DataCenter.AllianceMineManager:FetchMilitaryCenterBuildInfo()
  end
  for i, v in ipairs(LWAlMainMidShowBtns) do
    if v == LWAlMainMidBtnType.Al_City_Effect then
      if not isInSeason and (seasonType == SeasonMapType.NineNation or seasonType == SeasonMapType.NineNationRainforest) then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_SeasonCity then
      if 0 < season and seasonIsOpen and seasonType == SeasonMapType.Desert then
        local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SEASON_ALLIANCE_CENTER_OPEN)
        if effectValue and 0 < effectValue then
          table.insert(ret, v)
        end
      end
    elseif v == LWAlMainMidBtnType.Al_SeasonStoveCenter then
      if theStoveCenter ~= nil and seasonIsOpen and seasonType == SeasonMapType.Snow then
        table.insert(ret, v)
      elseif 0 < season and seasonIsOpen and seasonType == SeasonMapType.Snow then
        local effectValue = DataCenter.LWSeasonTrendsManager:GetEffectValue(EffectDefine.LW_SEASON_STOVE_CENTER_OPEN)
        if effectValue and 0 < effectValue then
          table.insert(ret, v)
        end
      end
    elseif v == LWAlMainMidBtnType.Al_Season4Center then
      if theStoveCenter ~= nil and seasonIsOpen and seasonType == SeasonMapType.Darkness then
        table.insert(ret, v)
      elseif 0 < season and seasonIsOpen and seasonType == SeasonMapType.Darkness then
        local effectValue = DataCenter.LWSeasonTrendsManager:GetEffectValue(EffectDefine.LW_SEASON_ALLIANCE_CENTER_OPEN_DARKNESS)
        if effectValue and 0 < effectValue then
          table.insert(ret, v)
        end
      end
    elseif v == LWAlMainMidBtnType.Al_SeasonMilitaryCenter then
      if theStoveCenter ~= nil and seasonIsOpen and seasonType == SeasonMapType.Mummy then
        table.insert(ret, v)
      elseif 0 < season and seasonIsOpen and seasonType == SeasonMapType.Mummy then
        local effectValue = DataCenter.LWSeasonTrendsManager:GetEffectValue(EffectDefine.LW_SEASON_ALLIANCE_CENTER_OPEN_MUMMY)
        if effectValue and 0 < effectValue then
          table.insert(ret, v)
        end
      end
    elseif v == LWAlMainMidBtnType.Al_CityAttachment then
      if 0 < season and 0 < SeasonUtil.GetFarmerConfigId() and DataCenter.ActivityListDataManager:IsActivityOpen(EnumActivity.SeasonFarmer.Type) then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_SeasonDevote then
      if 0 < season and existDevoteData then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_SeasonMilestone then
      if 0 < season and isInSeason then
        local tempList, targetIndex = DataCenter.AllianceSeasonTaskManager:GetTaskList()
        if tempList and targetIndex and 0 < #tempList then
          table.insert(ret, v)
        end
      end
    elseif v == LWAlMainMidBtnType.Al_Achieve and not DataCenter.AllianceTaskManager:CheckIfAllianceTaskOpen() then
    elseif v == LWAlMainMidBtnType.Al_City then
      if not (season ~= 0 and isInSeason) or seasonType ~= SeasonMapType.Desert then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_GovernmentSkill then
      if isInSeason and DataCenter.AllianceGovernmentSkillManager:ExistUsefulSkill() then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_Activity then
      if DataCenter.ActivityListDataManager:IsContainActivityGroup(CommonActivityGroupEnum.Alliance) or LuaEntry.DataConfig:CheckSwitch("alliance_activity_entrance") and not LuaEntry.Player:IsLoginSourceServer() then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_MilitaryPay then
      if DataCenter.AllianceMilitaryPayDataManager:IsFunctionOpen() then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_MakeFriends then
      if isInSeason and SeasonUtil.CanAllianceMakeFriends(mySourceServerId) or DataCenter.SeasonAllyFriendManager:HasFriend() then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_Camp_Science then
      if DataCenter.CampScienceDataManager:IsOpenCampScience() then
        table.insert(ret, v)
      end
    elseif v == LWAlMainMidBtnType.Al_Alliance_Skill then
      if DataCenter.AllianceGovernmentCommonSkillManager:IsOpen() and DataCenter.AllianceGovernmentCommonSkillManager:HasSkill() then
        table.insert(ret, v)
      end
    else
      table.insert(ret, v)
    end
  end
  return ret
end

UILWAlMainCtrl.SetView = SetView
UILWAlMainCtrl.ClearView = ClearView
UILWAlMainCtrl.CloseSelf = CloseSelf
UILWAlMainCtrl.GetAlInfos = GetAlInfos
UILWAlMainCtrl.OnMidBtnClick = OnMidBtnClick
UILWAlMainCtrl.OnDownBtnClick = OnDownBtnClick
UILWAlMainCtrl.GetRedPotCountByType = GetRedPotCountByType
UILWAlMainCtrl.GetMidShowBtnsList = GetMidShowBtnsList
UILWAlMainCtrl.TranslateAnnounce = TranslateAnnounce
return UILWAlMainCtrl
