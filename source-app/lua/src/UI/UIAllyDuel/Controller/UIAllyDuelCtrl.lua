local UIAllyDuelCtrl = BaseClass("UIAllyDuelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIAllyDuel)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function CheckIfTabIsVisible(self, tabType)
  local myMatchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
  local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
  local isSubmitting = DataCenter.LeagueMatchManager:CheckIsSubmitting()
  if tabType == LeagueMatchTab.Activity then
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if not actInfo or actInfo.finish or actInfo:GetEventInfo() == nil or isSubmitting then
      return false
    end
    return true
  elseif tabType == LeagueMatchTab.GachaSunday then
    local weekDayIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
    local isScienceOpen = DataCenter.AllyDuelScoreGachaManager:IsScienceOpen()
    local isUnlock = DataCenter.AllyDuelScoreGachaManager:IsUnlock()
    local gachaSwitch = LuaEntry.DataConfig:CheckSwitch("alliance_duel_zhuanpan")
    return weekDayIndex == 7 and isScienceOpen and isUnlock and gachaSwitch
  elseif tabType == LeagueMatchTab.Compete then
    if isSubmitting then
      return false
    end
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if not hasAlliance then
      return true
    end
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    return actInfo
  elseif tabType == LeagueMatchTab.CrossServer then
    if not LuaEntry.Player:IsInAlliance() or isSubmitting then
      return false
    end
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if actInfo then
      local eventInfo = actInfo:GetEventInfo()
      if eventInfo and eventInfo:CheckIfShowCrossServer() then
        return true
      end
    end
    return false
  elseif tabType == LeagueMatchTab.CrossServerDesert then
    if not LuaEntry.Player:IsInAlliance() or isSubmitting then
      return false
    end
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if actInfo then
      local eventInfo = actInfo:GetEventInfo()
      if eventInfo and eventInfo:CheckIfShowCrossDesert() then
        return true
      end
    end
    return false
  elseif tabType == LeagueMatchTab.Notice then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    if tempStage == LeagueMatchStage.Preview or tempStage == LeagueMatchStage.GroupResult then
      return true
    else
      return false
    end
  elseif tabType == LeagueMatchTab.AllianceRank then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    if tempStage == LeagueMatchStage.Preview or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
      if myMatchInfo and myMatchInfo.lastDuelInfo then
        return true
      else
        return false
      end
    elseif tempStage == LeagueMatchStage.GroupResult then
      return false
    elseif myMatchInfo and myMatchInfo.duelInfo then
      return true
    else
      return false
    end
  else
    return false
  end
end

local function CheckIfEnemyAllyExist(self, eventInfo)
  for k, v in pairs(eventInfo.vsAllianceList) do
    if k ~= LuaEntry.Player.allianceId then
      return not string.IsNullOrEmpty(v.alName)
    end
  end
  return true
end

UIAllyDuelCtrl.CloseSelf = CloseSelf
UIAllyDuelCtrl.Close = Close
UIAllyDuelCtrl.CheckIfEnemyAllyExist = CheckIfEnemyAllyExist
UIAllyDuelCtrl.CheckIfTabIsVisible = CheckIfTabIsVisible
UIAllyDuelCtrl.GetAllianceListRanked = GetAllianceListRanked
return UIAllyDuelCtrl
