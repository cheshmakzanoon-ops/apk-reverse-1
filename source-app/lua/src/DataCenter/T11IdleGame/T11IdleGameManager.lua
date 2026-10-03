local T11IdleGameManager = BaseClass("T11IdleGameManager")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local Localization = CS.GameEntry.Localization

function T11IdleGameManager:__init()
end

function T11IdleGameManager:__delete()
end

function T11IdleGameManager:PrintRealErrorLog(value)
  Logger.LogError(string.format("T11IdleGame Error Log: [%s]", tostring(value)))
end

function T11IdleGameManager:PrintRealInfoLog(value)
  Logger.LogInfo(string.format("T11IdleGame Info Log: [%s]", tostring(value)))
end

function T11IdleGameManager:PrintRealWarningLog(value)
  Logger.LogWarning(string.format("T11IdleGame warning Log: [%s]", tostring(value)))
end

function T11IdleGameManager:PrintEditorErrorLog(value)
  if not CS.SDKManager.IS_UNITY_EDITOR() then
    return
  end
  CS.UnityEngine.Debug.LogError(string.format("T11\230\140\130\230\156\186\231\142\169\230\179\149Error\230\151\165\229\191\151: [%s]", tostring(value)))
end

function T11IdleGameManager:PrintEditorCustomLog(value)
  if not CS.SDKManager.IS_UNITY_EDITOR() then
    return
  end
  Logger.LogCustom(string.format("T11\230\140\130\230\156\186\231\142\169\230\179\149Custom\230\151\165\229\191\151: [%s]", tostring(value)))
end

function T11IdleGameManager:GetT11IdleGameFunctionOnLimitData()
  local configValue = LuaEntry.DataConfig:TryGetStr("idle_game_para", "k1", "")
  if not string.IsNullOrEmpty(configValue) then
    local strSplit = string.split(configValue, ";")
    if #strSplit == 3 then
      return {
        militaryCampLv = tonumber(strSplit[1]) or 0,
        seasonNum = tonumber(strSplit[2]) or 0,
        seasonDay = tonumber(strSplit[3]) or 0
      }
    end
  end
end

function T11IdleGameManager:GetMaxMilitaryCampBuildingLevel()
  local maxLevel = 0
  local buildingList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  if not table.IsNullOrEmpty(buildingList) then
    for _, building in pairs(buildingList) do
      if maxLevel < building.level then
        maxLevel = building.level
      end
    end
  end
  return maxLevel
end

function T11IdleGameManager:IsT11IdleGameFunctionOn()
  if not LuaEntry.DataConfig:CheckSwitch("t11_idle_game_open") then
    return false
  end
  local functionLimitData = self:GetT11IdleGameFunctionOnLimitData()
  if functionLimitData then
    local militaryLv = self:GetMaxMilitaryCampBuildingLevel()
    if militaryLv >= functionLimitData.militaryCampLv then
      local seasonNum = SeasonUtil.GetSeason()
      if seasonNum > functionLimitData.seasonNum then
        return true
      elseif seasonNum < functionLimitData.seasonNum then
        return false
      end
      return functionLimitData.seasonDay <= SeasonUtil.GetSeasonDayByOpenServerZero()
    end
  end
  return false
end

function T11IdleGameManager:IsShowCityAlertTowerEntrance()
  return self:IsT11IdleGameFunctionOn()
end

function T11IdleGameManager:IsShowAlertTowerBubble()
  if not self:IsT11IdleGameFunctionOn() then
    return false
  end
  return true
end

function T11IdleGameManager:HasShownAlertTowerBubbleRedToday()
  local todayZero = UITimeManager:GetInstance():TodayZero()
  local key = "t11_idle_game_alert_tower_red_today_" .. todayZero
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function T11IdleGameManager:SetHasShownAlertTowerBubbleRedToday()
  local todayZero = UITimeManager:GetInstance():TodayZero()
  local key = "t11_idle_game_alert_tower_red_today_" .. todayZero
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function T11IdleGameManager:IsAlertTowerBubbleShowRed()
  local infoData = DataCenter.T11IdleGameDataManager:GetIdleInfoData()
  if infoData == nil then
    return DataCenter.T11IdleGameDataManager:GetIsServerAlertTowerBubbleShowRed()
  end
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData ~= nil and mainData:GetStartGameLeftTime() > 0 then
    if infoData:IsCanEnd() then
      return true
    end
    if not infoData:IsHasStarted() then
      return true
    end
  end
  return false
end

function T11IdleGameManager:OnAlertTowerBubbleClick()
  if DataCenter.LWGuideFlowManager:ReadDone(Const.GuideId.STEP_1) then
    self:OpenMain()
  else
    EventManager:GetInstance():Broadcast(EventId.GF_t11_idle_game_trigger, {
      trigger_id = Const.TriggerId.Bubble
    })
  end
end

function T11IdleGameManager:OnCityEntranceButtonClick()
  if DataCenter.LWGuideFlowManager:ReadDone(Const.GuideId.STEP_1) then
    self:OpenMain()
  else
    EventManager:GetInstance():Broadcast(EventId.GF_t11_idle_game_trigger, {
      trigger_id = Const.TriggerId.TileBtn
    })
  end
end

function T11IdleGameManager:OpenMain()
  if not self:IsT11IdleGameFunctionOn() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameBattleMain, {anim = true})
end

function T11IdleGameManager:OpenIntroduction()
  UIUtil.ShowInfoPop(Localization:GetString("t11_idle_game_title_76"), Localization:GetString("t11_idle_game_desc_77"))
end

function T11IdleGameManager:IsT11GuideId(guideId)
  for i, v in pairs(Const.GuideId) do
    if guideId == v then
      return true
    end
  end
  return false
end

function T11IdleGameManager:OpenRule()
  local param = {}
  param.title = "t11_idle_game_title_58"
  param.activityRulesStr = Localization:GetString("t11_idle_game_desc_59")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function T11IdleGameManager:IsGuideFinished()
  return DataCenter.LWGuideFlowManager:ReadDone(Const.GuideId.STEP_1)
end

function T11IdleGameManager:OpenRankView()
  if DataCenter.T11IdleGameDataManager:GetMainData() == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankDetailList, {anim = true, hideTop = false}, 0, RankingTypeServer.T11_IDLE_GAME)
end

function T11IdleGameManager:SetBossAutoOn(value)
  local key = "t11_idle_game_boss_auto_on"
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, value)
end

function T11IdleGameManager:GetBossAutoIsOn()
  local key = "t11_idle_game_boss_auto_on"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

return T11IdleGameManager
