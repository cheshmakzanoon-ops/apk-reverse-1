local SeasonFactionWarTimeline = BaseClass("SeasonFactionWarTimeline", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_active1_path = "bg/icon1/iconActive1"
local icon_active2_path = "bg/icon2/iconActive2"
local icon_active3_path = "bg/icon3/iconActive3"
local icon_active4_path = "bg/icon4/iconActive4"
local time_day1_path = "bg/line/TimeTips1/TimeDay1"
local time_day2_path = "bg/line/TimeTips2/TimeDay2"
local time_day3_path = "bg/line/TimeTips3/TimeDay3"
local time_day4_path = "bg/line/TimeTips4/TimeDay4"
local world_time_text_path = "bg/WorldTimeBg/WorldTimeText"
local btn_refresh_path = "bg/WorldTimeBg/BtnRefresh"
local bg_path = "bg"

function SeasonFactionWarTimeline:OnCreate()
  base.OnCreate(self)
  self.modeServerTime = true
  self.bg = self:AddComponent(UISimpleAnimation, bg_path)
  self.world_time_text = self:AddComponent(UITextMeshProUGUIEx, world_time_text_path)
  self.btn_refresh = self:AddComponent(UIButton, btn_refresh_path)
  self.btn_refresh:SetOnClick(function()
    self:SwitchTimeShow()
  end)
  self.icon_active1 = self:AddComponent(UIImage, icon_active1_path)
  self.icon_active2 = self:AddComponent(UIImage, icon_active2_path)
  self.icon_active3 = self:AddComponent(UIImage, icon_active3_path)
  self.icon_active4 = self:AddComponent(UIImage, icon_active4_path)
  self.time_day1 = self:AddComponent(UITextMeshProUGUIEx, time_day1_path)
  self.time_day2 = self:AddComponent(UITextMeshProUGUIEx, time_day2_path)
  self.time_day3 = self:AddComponent(UITextMeshProUGUIEx, time_day3_path)
  self.time_day4 = self:AddComponent(UITextMeshProUGUIEx, time_day4_path)
end

function SeasonFactionWarTimeline:OnDestroy()
  self.world_time_text = nil
  self.btn_refresh = nil
  self.icon_active1 = nil
  self.icon_active2 = nil
  self.icon_active3 = nil
  self.icon_active4 = nil
  self.time_day1 = nil
  self.time_day2 = nil
  self.time_day3 = nil
  self.time_day4 = nil
  self.bg = nil
  base.OnDestroy(self)
end

function SeasonFactionWarTimeline:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionDeclareInfoUpdate, self.UpdateData)
  self:AddUIListener(EventId.LWSeasonFactionBattleInfoUpdate, self.UpdateData)
end

function SeasonFactionWarTimeline:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionDeclareInfoUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.LWSeasonFactionBattleInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function SeasonFactionWarTimeline:Update1000MS()
  if self.world_time_text then
    local mgr = UITimeManager:GetInstance()
    local now = mgr:GetServerTime()
    if self.modeServerTime then
      if string.IsNullOrEmpty(self.modeServerText) then
        self.modeServerText = Localization:GetString("800811") .. " : "
      end
      self.world_time_text:SetText(self.modeServerText .. mgr:TimeStampToTimeForServer(now))
    else
      if string.IsNullOrEmpty(self.modeLocalText) then
        self.modeLocalText = Localization:GetString("302335") .. " : "
      end
      self.world_time_text:SetText(self.modeLocalText .. mgr:TimeStampToTimeForLocal(now))
    end
  end
end

function SeasonFactionWarTimeline:SwitchTimeShow()
  self.modeServerTime = not self.modeServerTime
  self:UpdateData()
end

function SeasonFactionWarTimeline:UpdateData()
  local factionMgr = DataCenter.SeasonFactionWarDataManager
  local actInfo = factionMgr:GetDeclareWarActInfo()
  local timeInfos = factionMgr.timeInfos
  if timeInfos == nil or actInfo == nil then
    self.icon_active1:SetActive(false)
    self.icon_active2:SetActive(false)
    self.icon_active3:SetActive(false)
    self.icon_active4:SetActive(false)
    self.time_day1:SetText("")
    self.time_day2:SetText("")
    self.time_day3:SetText("")
    self.time_day4:SetText("")
    self:Update1000MS()
    self:PlayAnim("Default")
    return
  end
  local currStep = actInfo.currStep
  local round = actInfo.round
  local stepDeclareStartTime = 0
  local stepInviteStartTime = 0
  local stepPreparationStartTime = 0
  local stepBattleStartTime = 0
  local stepBattleEndTime = 0
  for k, v in ipairs(timeInfos) do
    if v and v.round == round then
      stepBattleStartTime = v.declareTime
      break
    end
  end
  if currStep == SeasonFactionDeclareWarStep.declare then
    self:PlayAnim("DeclareStart")
  elseif currStep == SeasonFactionDeclareWarStep.invite then
    self:PlayAnim("InviteStart")
  elseif currStep == SeasonFactionDeclareWarStep.battle_before then
    self:PlayAnim("PreparationStart")
  elseif currStep == SeasonFactionDeclareWarStep.battle then
    self:PlayAnim("BattleStart")
  elseif currStep == SeasonFactionDeclareWarStep.battle_after then
    for k, v in ipairs(timeInfos) do
      if v and v.round == round + 1 then
        stepBattleStartTime = v.declareTime
        break
      end
    end
    self:PlayAnim("Default")
  else
    self:PlayAnim("Default")
  end
  if self.cfgStepDuration == nil then
    local theSeasonType = SeasonUtil.GetSeasonType()
    local factionWarActivityType = SeasonUtil.GetFactionWarActivityType(theSeasonType)
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
    if dataList ~= nil and 0 < #dataList then
      local data = dataList[1]
      if data then
        local stepDeclare, stepInvite, stepPreparation, stepBattle1v1, stepBattle1v2, stepBattle1v3
        local tmp = string.split(data.para_1, "|")
        if tmp and #tmp == 3 then
          stepDeclare, stepInvite, stepPreparation = toInt(tmp[1]) * 1000, toInt(tmp[2]) * 1000, toInt(tmp[3]) * 1000
        end
        tmp = string.split(data.para_2, "|")
        if tmp and #tmp == 3 then
          stepBattle1v1, stepBattle1v2, stepBattle1v3 = toInt(tmp[1]) * 1000, toInt(tmp[2]) * 1000, toInt(tmp[3]) * 1000
        end
        self.cfgStepDuration = {
          stepDeclare,
          stepInvite,
          stepPreparation,
          stepBattle1v1,
          stepBattle1v2,
          stepBattle1v3
        }
      end
    end
  end
  if self.cfgStepDuration ~= nil then
    stepPreparationStartTime = stepBattleStartTime - self.cfgStepDuration[3]
    stepInviteStartTime = stepPreparationStartTime - self.cfgStepDuration[2]
    stepDeclareStartTime = stepInviteStartTime - self.cfgStepDuration[1]
    stepBattleEndTime = 0
    if currStep == SeasonFactionDeclareWarStep.battle_before or currStep == SeasonFactionDeclareWarStep.battle_after then
      local theAttackerCount = table.count(factionMgr.theAttackerList)
      local theDefenderCount = table.count(factionMgr.theDefenderList)
      local diff = theAttackerCount - theDefenderCount
      if diff == 0 then
        stepBattleEndTime = stepBattleStartTime + self.cfgStepDuration[4]
      elseif diff == 1 then
        stepBattleEndTime = stepBattleStartTime + self.cfgStepDuration[5]
      elseif diff == 2 then
        stepBattleEndTime = stepBattleStartTime + self.cfgStepDuration[6]
      end
    elseif currStep == SeasonFactionDeclareWarStep.battle then
      stepBattleEndTime = actInfo.stepEndTime
    end
    self:ShowTime(self.time_day1, stepDeclareStartTime, stepInviteStartTime)
    self:ShowTime(self.time_day2, stepInviteStartTime, stepPreparationStartTime)
    self:ShowTime(self.time_day3, stepPreparationStartTime, stepBattleStartTime)
    self:ShowTime(self.time_day4, stepBattleStartTime, stepBattleEndTime)
  end
  self:Update1000MS()
end

function SeasonFactionWarTimeline:PlayAnim(anim_name)
  if self.bg:IsPlaying(anim_name) then
  else
    self.bg:Play(anim_name)
  end
end

function SeasonFactionWarTimeline:ShowTime(txtNode, timeStart, timeEnd)
  local mgr = UITimeManager:GetInstance()
  if timeEnd == nil or timeEnd == 0 then
    if self.modeServerTime then
      local formatStart = os.date("!*t", math.modf((timeStart + mgr.changeDeltaTime) / 1000))
      txtNode:SetText(string.format([[
<b><size=36>%02d/%02d</size></b>
%02d:%02d - ?]], formatStart.month, formatStart.day, formatStart.hour, formatStart.min))
    else
      local formatStart = os.date("*t", math.modf(timeStart / 1000))
      txtNode:SetText(string.format([[
<b><size=36>%02d/%02d</size></b>
%02d:%02d - ?]], formatStart.month, formatStart.day, formatStart.hour, formatStart.min))
    end
  elseif self.modeServerTime then
    local formatStart = os.date("!*t", math.modf((timeStart + mgr.changeDeltaTime) / 1000))
    local formatEnd = os.date("!*t", math.modf((timeEnd + mgr.changeDeltaTime) / 1000))
    if formatStart.hour == 0 and formatStart.min == 0 and formatEnd.hour == 0 and formatEnd.min == 0 and timeStart + OneDayTime * 1000 == timeEnd then
      txtNode:SetText(string.format([[
<b><size=36>%02d/%02d</size></b>
00:00 - 24:00]], formatStart.month, formatStart.day))
    elseif formatStart.day == formatEnd.day then
      txtNode:SetText(string.format([[
<b><size=36>%02d/%02d</size></b>
%02d:%02d - %02d:%02d]], formatStart.month, formatStart.day, formatStart.hour, formatStart.min, formatEnd.hour, formatEnd.min))
    else
      txtNode:SetText(string.format([[
<b><size=36>%02d/%02d</size></b> %02d:%02d
-
<b><size=36>%02d/%02d</size></b> %02d:%02d]], formatStart.month, formatStart.day, formatStart.hour, formatStart.min, formatEnd.month, formatEnd.day, formatEnd.hour, formatEnd.min))
    end
  else
    local formatStart = os.date("*t", math.modf(timeStart / 1000))
    local formatEnd = os.date("*t", math.modf(timeEnd / 1000))
    if formatStart.hour == 0 and formatStart.min == 0 and formatEnd.hour == 0 and formatEnd.min == 0 and timeStart + OneDayTime * 1000 == timeEnd then
      txtNode:SetText(string.format([[
<b><size=36>%02d/%02d</size></b>
00:00 - 24:00]], formatStart.month, formatStart.day))
    elseif formatStart.day == formatEnd.day then
      txtNode:SetText(string.format([[
<b><size=36>%02d/%02d</size></b>
%02d:%02d - %02d:%02d]], formatStart.month, formatStart.day, formatStart.hour, formatStart.min, formatEnd.hour, formatEnd.min))
    else
      txtNode:SetText(string.format([[
<b><size=36>%02d/%02d</size></b> %02d:%02d
-
<b><size=36>%02d/%02d</size></b> %02d:%02d]], formatStart.month, formatStart.day, formatStart.hour, formatStart.min, formatEnd.month, formatEnd.day, formatEnd.hour, formatEnd.min))
    end
  end
end

return SeasonFactionWarTimeline
