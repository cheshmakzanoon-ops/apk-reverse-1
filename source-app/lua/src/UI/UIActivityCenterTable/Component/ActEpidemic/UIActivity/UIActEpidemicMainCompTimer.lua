local base = UIAsyncContainer
local UIActEpidemicMainCompTimer = BaseClass("UIActEpidemicMainCompTimer", base)
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local Localization = CS.GameEntry.Localization

local function OnCreate(self, mainView)
  base.OnCreate(self)
  self.mainView = mainView
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpTitle0 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpTitle1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnChangeTimeType = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnChangeTimeType:SetOnClick(function()
    self:OnBtnChangeTimeTypeClick()
  end)
  self.textTmpTimeTypeTop = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpTimeBottomLeft = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpTimeBottomRight = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compCalendarAddBtnContent = self.viewSkin:AddComponent(self, CalendarAddBtnContent, 7)
  self.showLocalTime = BattleFieldUtil.GetShowLocalTime()
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.textTmpTitle0 = nil
  self.textTmpTitle1 = nil
  self.btnChangeTimeType = nil
  self.textTmpTimeTypeTop = nil
  self.textTmpTimeBottomLeft = nil
  self.textTmpTimeBottomRight = nil
  self.compCalendarAddBtnContent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnChangeShowLocalTime)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnChangeShowLocalTime)
  base.OnRemoveListener(self)
end

local function OnBtnChangeTimeTypeClick(self)
  self.showLocalTime = not self.showLocalTime
  BattleFieldUtil.SetShowLocalTime(self.showLocalTime)
end

function UIActEpidemicMainCompTimer:OnChangeShowLocalTime()
  self.showLocalTime = BattleFieldUtil.GetShowLocalTime()
  self:RefreshBattleStartTime()
end

function UIActEpidemicMainCompTimer:RefreshBattleStartTime()
  local keyTimeType = self.showLocalTime and "Desert_strom_tips1001" or "Desert_strom_tips1002"
  self.textTmpTimeTypeTop:SetLocalText(keyTimeType)
  local battleStartSec = (self.groupInfo ~= nil and self.groupInfo.startTime or 0) * 1000
  local battleEndSec = (self.groupInfo ~= nil and self.groupInfo.endTime or 0) * 1000
  if toInt(battleStartSec) == 0 then
    Logger.LogWarning(string.format("UIActEpidemicMainCompTimer battleTimes error : group=%s", self.groupIdx))
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  local strDate = "-"
  local strHMStart = "00"
  local strHMEnd = "00"
  if self.showLocalTime then
    strDate = UITimeManager:GetInstance():GetTimeToLocalYMD(battleStartSec)
    strHMStart = UITimeManager:GetInstance():GetTimeToLocalHHMM(battleStartSec)
    strHMEnd = UITimeManager:GetInstance():GetTimeToLocalHHMM(battleEndSec)
  else
    strDate = UITimeManager:GetInstance():GetTimeToServerYMD(battleStartSec)
    strHMStart = UITimeManager:GetInstance():GetTimeToServerHHMM(battleStartSec)
    strHMEnd = UITimeManager:GetInstance():GetTimeToServerHHMM(battleEndSec)
  end
  self.textTmpTimeBottomLeft:SetTextFormat("%s : %s", Localization:GetString("Desert_strom_tips1017"), strDate)
  self.textTmpTimeBottomRight:SetTextFormat("%s~%s", strHMStart, strHMEnd)
end

function UIActEpidemicMainCompTimer:RefreshCountdown()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local endTime = self.endTime or 0
  local remainMs = endTime - curTime
  if remainMs <= 0 then
    self.timeUpdate = false
    self.textTmpTitle1:SetText("-")
  else
    local txt = UITimeManager:GetInstance():SecondToFmtString(remainMs)
    self.timeUpdate = true
    self.textTmpTitle1:SetText(txt)
  end
end

function UIActEpidemicMainCompTimer:CloseTimer()
end

function UIActEpidemicMainCompTimer:Update1000MS()
  if self.timeUpdate then
    self:RefreshCountdown()
  end
end

function UIActEpidemicMainCompTimer:SetGroup(groupIdx)
  self.groupIdx = groupIdx
  self.groupInfo = ActEpidemicUtils.GetGroup(groupIdx)
end

function UIActEpidemicMainCompTimer:Show()
  self:SetActive(true)
  if not self:AsyncLoadDone() then
    return
  end
  local actInfo = ActEpidemicUtils.GetActInfo()
  if not actInfo then
    return
  end
  local keyTitle = "458016"
  self.endTime = actInfo.stageEndTime
  local currentState = self.mainView:GetCurrentActStage()
  if currentState == EpidemicZoneStage.SignIn then
    keyTitle = "458016"
  elseif currentState == EpidemicZoneStage.Matching then
    keyTitle = "YiBianJinQu_event_tips_4"
  elseif currentState == EpidemicZoneStage.MatchEnd then
    keyTitle = "YiBianJinQu_event_tips_5"
    self.endTime = self.groupInfo ~= nil and self.groupInfo.readyTime or 0
  elseif currentState == EpidemicZoneStage.Prepare then
    keyTitle = "YiBianJinQu_event_tips_5"
    self.endTime = self.groupInfo ~= nil and self.groupInfo.startTime or 0
  elseif currentState == EpidemicZoneStage.Battle then
    keyTitle = "YiBianJinQu_event_tips_6"
    self.endTime = self.groupInfo ~= nil and self.groupInfo.endTime or 0
  elseif currentState == EpidemicZoneStage.Show then
    keyTitle = ""
  end
  self.textTmpTitle0:SetLocalText(keyTitle)
  self:RefreshCountdown()
  self:RefreshBattleStartTime()
  self:ShowCalendatBtnContent()
end

function UIActEpidemicMainCompTimer:ShowCalendatBtnContent()
  local currentState = self.mainView:GetCurrentActStage()
  if currentState == EpidemicZoneStage.MatchEnd and self.endTime > 0 then
    self.compCalendarAddBtnContent:SetActive(true)
    local startTime = toInt(self.endTime)
    local endTime = toInt(self.endTime)
    self.compCalendarAddBtnContent:SetDataWithDefautValue(7, startTime, endTime, CalendarSourcePath.Activity)
  else
    self.compCalendarAddBtnContent:SetActive(false)
  end
end

function UIActEpidemicMainCompTimer:Hide()
  self:SetActive(false)
  if self:AsyncLoadDone() then
    return
  end
end

UIActEpidemicMainCompTimer.OnCreate = OnCreate
UIActEpidemicMainCompTimer.OnDestroy = OnDestroy
UIActEpidemicMainCompTimer.OnEnable = OnEnable
UIActEpidemicMainCompTimer.OnDisable = OnDisable
UIActEpidemicMainCompTimer.ComponentDefine = ComponentDefine
UIActEpidemicMainCompTimer.ComponentDestroy = ComponentDestroy
UIActEpidemicMainCompTimer.DataDefine = DataDefine
UIActEpidemicMainCompTimer.DataDestroy = DataDestroy
UIActEpidemicMainCompTimer.OnAddListener = OnAddListener
UIActEpidemicMainCompTimer.OnRemoveListener = OnRemoveListener
UIActEpidemicMainCompTimer.OnBtnChangeTimeTypeClick = OnBtnChangeTimeTypeClick
return UIActEpidemicMainCompTimer
