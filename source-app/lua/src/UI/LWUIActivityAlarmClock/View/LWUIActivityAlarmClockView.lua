local base = UIBaseView
local LWUIActivityAlarmClockView = BaseClass("LWUIActivityAlarmClockView", base)
local LWUIActivityAlarmClockDesItemRender = require("UI.LWUIActivityAlarmClock.Component.LWUIActivityAlarmClockDesItemRender")
local LWUIActivityAlarmClockInfoItemRender = require("UI.LWUIActivityAlarmClock.Component.LWUIActivityAlarmClockInfoItemRender")
local LWUIActivityAlarmClockSystemItemRender = require("UI.LWUIActivityAlarmClock.Component.LWUIActivityAlarmClockSystemItemRender")
local ActivityAlarmClockViewData = {
  activityAlarmClockGroupType = 1,
  activityAlarmClockInfo = nil,
  activityAlarmClockSystemType = nil
}
local OneData = DataClass("OneData", ActivityAlarmClockViewData)
local panelShowAniName = "LWUIActivityAlarmClock_Open"
local panelHideAniName = "LWUIActivityAlarmClock_Close"
local panelBtn_path = "panel"
local closeBtn_path = "PopUpContent/CloseBtn"
local titleText_path = "PopUpContent/TitleText"
local timeTipsText_path = "PopUpContent/TimeTipsText"
local timeChangeBtn_path = "PopUpContent/TimeChangeBtn"
local emptyTipsText_path = "PopUpContent/EmptyTipsText"
local activityLoopListView_path = "PopUpContent/ActivityScrollView"
local activityScrollContent_path = "PopUpContent/ActivityScrollView/Viewport/ActivityScrollContent"
local curTimeText_path = "PopUpContent/CurTimeText"
local panelAni_path = ""
local allianceTipsText_path = "PopUpContent/AllianceTipsText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearActivityLoopView()
  self:ClearAniTimer()
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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.timeTipsText = self:AddComponent(UIText, timeTipsText_path)
  self.timeChangeBtn = self:AddComponent(UIButton, timeChangeBtn_path)
  self.emptyTipsText = self:AddComponent(UIText, emptyTipsText_path)
  self.activityLoopListView = self:AddComponent(UILoopListView2, activityLoopListView_path)
  self.activityScrollContent = self:AddComponent(UIBaseContainer, activityScrollContent_path)
  self.curTimeText = self:AddComponent(UIText, curTimeText_path)
  self.panelAni = self:AddComponent(UIAnimator, panelAni_path)
  self.allianceTipsText = self:AddComponent(UITextMeshProUGUIEx, allianceTipsText_path)
  self.panelBtn:SetOnClick(function()
    self:CloseBtnClick()
  end)
  self.closeBtn:SetOnClick(function()
    self:CloseBtnClick()
  end)
  self.timeChangeBtn:SetOnClick(function()
    self:TimeChangeBtnClick()
  end)
  self.titleText:SetLocalText("activity_clock_title")
  self.emptyTipsText:SetLocalText("activity_clock_empty")
  self.activityLoopListView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.closeBtn = nil
  self.titleText = nil
  self.timeTipsText = nil
  self.timeChangeBtn = nil
  self.emptyTipsText = nil
  self.activityLoopListView = nil
  self.activityScrollContent = nil
  self.curTimeText = nil
  self.panelAni = nil
end

local function DataDefine(self)
  self.isShowServerTime = DataCenter.LWActivityAlarmClockManager:GetShowServerTimeMode()
  self.activityViewList = {}
  self.isClosing = false
end

local function DataDestroy(self)
  self.isShowServerTime = nil
  self.activityViewList = nil
  self.isClosing = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActivityAlarmClockData, self.RefreshActivityAlarmClockListView)
  self:AddUIListener(EventId.UpdateActivityAlarmClockData, self.RefreshActivityAlarmClockListView)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnAllianceQuitSuccess)
  self:AddUIListener(EventId.UserSettingChanged, self.OnRefreshTimeShowModeView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetActivityAlarmClockData, self.RefreshActivityAlarmClockListView)
  self:RemoveUIListener(EventId.UpdateActivityAlarmClockData, self.RefreshActivityAlarmClockListView)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnAllianceQuitSuccess)
  self:RemoveUIListener(EventId.UserSettingChanged, self.OnRefreshTimeShowModeView)
  base.OnRemoveListener(self)
end

local function OnAllianceQuitSuccess(self)
  self.ctrl:CloseSelf()
end

local function OnRefreshTimeShowModeView(self, type)
  if type == UserSettingKey.ActivityAlarmClock then
    self.isShowServerTime = DataCenter.LWActivityAlarmClockManager:GetShowServerTimeMode()
    self:RefreshTimeShow()
    self:RefreshActivityAlarmClockListView()
  end
end

local function Update1000MS(self)
  self:RefreshCurTimeShow()
end

local function ReInit(self)
  DataCenter.LWActivityAlarmClockManager:TrySendGetActivityAlarmClockDataMsg()
  self.panelAni:SampleAnimationAtTime(panelShowAniName, 0)
  self.panelAni:Play(panelShowAniName)
  self:RefreshActivityAlarmClockListView()
  self:RefreshTimeShow()
  local todayShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ActivityAlarmClockBubble)
  if todayShow then
    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.ActivityAlarmClockBubble, false)
    local activityAlarmClockBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ACTIVITY_ALARM_CLOCK)
    if activityAlarmClockBuildData then
      DataCenter.BuildBubbleManager:CheckShowBubble(activityAlarmClockBuildData.uuid)
    end
  end
end

local function RefreshActivityAlarmClockListView(self)
  self:GetActivityViewList()
  local showCount = table.count(self.activityViewList)
  self.emptyTipsText:SetActive(showCount == 0)
  self.activityLoopListView:SetActive(0 < showCount)
  local bHaveAllianceMark = false
  if 0 < showCount then
    self.activityLoopListView:SetListItemCount(showCount, false, false)
    self.activityLoopListView:RefreshAllShownItem()
    bHaveAllianceMark = self:IsActivityListHaveAllianceMark()
  end
  if bHaveAllianceMark then
    self.allianceTipsText:SetActive(false)
    self.activityLoopListView.rectTransform.sizeDelta = Vector2.New(570, 654)
  else
    self.allianceTipsText:SetLocalText("activity_clock_tips_allianceMark")
    self.allianceTipsText:SetActive(true)
    self.activityLoopListView.rectTransform.sizeDelta = Vector2.New(570, 610)
  end
end

local function RefreshCurTimeShow(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local showTimeStr = ""
  if self.isShowServerTime then
    local serverTimeData = UITimeManager:GetInstance():TimeStampToServerDate(curTime)
    showTimeStr = self:ConversionShowTime(serverTimeData.hour) .. string.format("<sprite=%s>", 10) .. self:ConversionShowTime(serverTimeData.min) .. string.format("<sprite=%s>", 10) .. self:ConversionShowTime(serverTimeData.sec)
  else
    local localTimeData = UITimeManager:GetInstance():TimeStampToLocalDate(curTime)
    showTimeStr = self:ConversionShowTime(localTimeData.hour) .. string.format("<sprite=%s>", 10) .. self:ConversionShowTime(localTimeData.min) .. string.format("<sprite=%s>", 10) .. self:ConversionShowTime(localTimeData.sec)
  end
  self.curTimeText:SetText(showTimeStr)
end

function LWUIActivityAlarmClockView:ConversionShowTime(value)
  local num1, num2 = 0, 0
  if 0 < value then
    num1 = math.floor(value / 10)
    num2 = math.floor(value % 10)
  end
  return string.format("<sprite=%s>", num1) .. string.format("<sprite=%s>", num2)
end

local function GetActivityViewList(self)
  self.activityViewList = {}
  local doingActivityList = {}
  local todayActivityList = {}
  local tomorrowActivityList = {}
  local afterTomorrowActivityList = {}
  local allianceActivityList = {}
  local activityDataList = DataCenter.LWActivityAlarmClockManager:GetActivityAlarmClockData()
  for i = 1, table.count(activityDataList) do
    local activityInfo = activityDataList[i]
    local state = activityInfo:GetActivityAlarmClockState()
    if activityInfo.template and activityInfo.template.event_group and activityInfo.template.event_group > 0 then
      if activityInfo.template.event_group == ActivityAlarmClockGroupType.Alliance then
        self:AddActivityView(allianceActivityList, ActivityAlarmClockGroupType.Alliance, activityInfo)
      else
        Logger.LogError("\230\151\182\233\146\159\229\136\134\231\187\132\232\166\129\229\138\160\230\150\176\231\177\187\229\158\139\229\175\185\229\186\148\233\128\187\232\190\145\239\188\129\239\188\129\239\188\129")
      end
    elseif state == ActivityAlarmClockState.Doing then
      self:AddActivityView(doingActivityList, ActivityAlarmClockGroupType.Doing, activityInfo)
    elseif state == ActivityAlarmClockState.NoOpen then
      local diffInDays = DataCenter.LWActivityAlarmClockManager:GetActivityAlarmClockSurplusDayToStartTime(activityInfo, self.isShowServerTime)
      if diffInDays ~= -1 then
        if diffInDays == 0 then
          self:AddActivityView(todayActivityList, ActivityAlarmClockGroupType.Today, activityInfo)
        elseif diffInDays == 1 then
          self:AddActivityView(tomorrowActivityList, ActivityAlarmClockGroupType.Tomorrow, activityInfo)
        elseif diffInDays == 2 then
          self:AddActivityView(afterTomorrowActivityList, ActivityAlarmClockGroupType.DayAfterTomorrow, activityInfo)
        end
      end
    end
  end
  if #doingActivityList == 0 and #todayActivityList == 0 then
    self:AddActivityView(todayActivityList, ActivityAlarmClockGroupType.Today, nil, ActivityAlarmClockSystemType.DayFree)
  end
  table.extendArray(self.activityViewList, doingActivityList)
  table.extendArray(self.activityViewList, allianceActivityList)
  table.extendArray(self.activityViewList, todayActivityList)
  table.extendArray(self.activityViewList, tomorrowActivityList)
  table.extendArray(self.activityViewList, afterTomorrowActivityList)
end

local function AddActivityView(self, list, activityAlarmClockGroupType, activityInfo, activityAlarmClockSystemType)
  if table.count(list) == 0 then
    local oneData = OneData.New()
    oneData.activityAlarmClockGroupType = activityAlarmClockGroupType
    table.insert(list, oneData)
  end
  local activityOneData = OneData.New()
  activityOneData.activityAlarmClockInfo = activityInfo
  activityOneData.activityAlarmClockSystemType = activityAlarmClockSystemType
  table.insert(list, activityOneData)
end

local function OnGetItemByIndex(self, listView, index)
  local count = table.count(self.activityViewList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local prefabName = self:GetPrefabName(index)
  if prefabName == "" then
    return nil
  end
  local item = listView:NewListViewItem(prefabName)
  local scriptName = self:GetItemScriptName(index)
  local script = self.activityScrollContent:GetComponent(item.gameObject.name, scriptName)
  if script == nil then
    NameCount = NameCount + 1
    local objName = "item_" .. tostring(NameCount)
    item.gameObject.name = objName
    script = self.activityScrollContent:AddComponent(scriptName, item.gameObject.name)
  end
  script:SetActive(true)
  local viewData = self.activityViewList[index]
  local waitShowTime = index * 0.03
  if viewData.activityAlarmClockInfo ~= nil then
    script:InitData(viewData.activityAlarmClockInfo, self.isShowServerTime, waitShowTime)
  elseif viewData.activityAlarmClockSystemType ~= nil then
    script:InitData(viewData.activityAlarmClockSystemType)
  else
    script:InitData(viewData.activityAlarmClockGroupType, self.isShowServerTime, waitShowTime)
  end
  return item
end

local function GetPrefabName(self, index)
  local viewData = self.activityViewList[index]
  if viewData ~= nil then
    if viewData.activityAlarmClockInfo ~= nil then
      return "LWUIActivityAlarmClockInfoItemRender"
    elseif viewData.activityAlarmClockSystemType ~= nil then
      return "LWUIActivityAlarmClockSystemItemRender"
    else
      return "LWUIActivityAlarmClockDesItemRender"
    end
  end
  return ""
end

local function GetItemScriptName(self, index)
  local viewData = self.activityViewList[index]
  if viewData ~= nil then
    if viewData.activityAlarmClockInfo ~= nil then
      return LWUIActivityAlarmClockInfoItemRender
    elseif viewData.activityAlarmClockSystemType ~= nil then
      return LWUIActivityAlarmClockSystemItemRender
    else
      return LWUIActivityAlarmClockDesItemRender
    end
  end
  return ""
end

local function ClearActivityLoopView(self)
  self.activityScrollContent:RemoveComponents(LWUIActivityAlarmClockDesItemRender)
  self.activityScrollContent:RemoveComponents(LWUIActivityAlarmClockSystemItemRender)
  self.activityScrollContent:RemoveComponents(LWUIActivityAlarmClockInfoItemRender)
  self.activityLoopListView:ClearAllItems()
end

local function RefreshTimeShow(self)
  if self.isShowServerTime then
    self.timeTipsText:SetLocalText("activity_clock_serverTime")
  else
    self.timeTipsText:SetLocalText("activity_clock_localTime")
  end
  self:RefreshCurTimeShow()
end

local function TimeChangeBtnClick(self)
  local newValue = not self.isShowServerTime
  DataCenter.LWActivityAlarmClockManager:SetShowServerTimeMode(newValue)
end

local function CloseBtnClick(self)
  if self.isClosing then
    return
  end
  self.isClosing = true
  local ret, time = self.panelAni:PlayAnimationReturnTime(panelHideAniName)
  if ret then
    self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ClearAniTimer()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, time)
  elseif self.ctrl then
    self.ctrl:CloseSelf()
  end
end

local function ClearAniTimer(self)
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

local function IsActivityListHaveAllianceMark(self)
  if not self.activityViewList then
    return false
  end
  for i, v in ipairs(self.activityViewList) do
    local tInfo = v.activityAlarmClockInfo
    if tInfo then
      local bHave = tInfo.template and tInfo.template.type == ActivityAlarmClockType.AllianceMark
      if bHave then
        return true
      end
    end
  end
  return false
end

LWUIActivityAlarmClockView.OnCreate = OnCreate
LWUIActivityAlarmClockView.OnDestroy = OnDestroy
LWUIActivityAlarmClockView.OnEnable = OnEnable
LWUIActivityAlarmClockView.OnDisable = OnDisable
LWUIActivityAlarmClockView.ComponentDefine = ComponentDefine
LWUIActivityAlarmClockView.ComponentDestroy = ComponentDestroy
LWUIActivityAlarmClockView.DataDefine = DataDefine
LWUIActivityAlarmClockView.DataDestroy = DataDestroy
LWUIActivityAlarmClockView.OnAddListener = OnAddListener
LWUIActivityAlarmClockView.OnRemoveListener = OnRemoveListener
LWUIActivityAlarmClockView.OnAllianceQuitSuccess = OnAllianceQuitSuccess
LWUIActivityAlarmClockView.OnRefreshTimeShowModeView = OnRefreshTimeShowModeView
LWUIActivityAlarmClockView.Update1000MS = Update1000MS
LWUIActivityAlarmClockView.ReInit = ReInit
LWUIActivityAlarmClockView.RefreshActivityAlarmClockListView = RefreshActivityAlarmClockListView
LWUIActivityAlarmClockView.GetActivityViewList = GetActivityViewList
LWUIActivityAlarmClockView.AddActivityView = AddActivityView
LWUIActivityAlarmClockView.RefreshCurTimeShow = RefreshCurTimeShow
LWUIActivityAlarmClockView.OnGetItemByIndex = OnGetItemByIndex
LWUIActivityAlarmClockView.GetPrefabName = GetPrefabName
LWUIActivityAlarmClockView.GetItemScriptName = GetItemScriptName
LWUIActivityAlarmClockView.ClearActivityLoopView = ClearActivityLoopView
LWUIActivityAlarmClockView.RefreshTimeShow = RefreshTimeShow
LWUIActivityAlarmClockView.TimeChangeBtnClick = TimeChangeBtnClick
LWUIActivityAlarmClockView.CloseBtnClick = CloseBtnClick
LWUIActivityAlarmClockView.ClearAniTimer = ClearAniTimer
LWUIActivityAlarmClockView.IsActivityListHaveAllianceMark = IsActivityListHaveAllianceMark
return LWUIActivityAlarmClockView
