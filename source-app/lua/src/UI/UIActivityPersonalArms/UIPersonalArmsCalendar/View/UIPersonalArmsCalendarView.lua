local UIPersonalArmsCalendarView = BaseClass("UIPersonalArmsCalendarView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPersonalArmsCalendarItem = require("UI.UIActivityPersonalArms.UIPersonalArmsCalendar.Component.UIPersonalArmsCalendarItem")
local Screen = CS.UnityEngine.Screen
local bgPanelPath = "Panel"
local closeBtnPath = "UICommonPopUpTitle/CloseBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityPersonalArmsCalenderUpdate, self.OnDataUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActivityPersonalArmsCalenderUpdate, self.OnDataUpdate)
end

local function OnDataUpdate(self)
  self:RefreshView()
end

local function ComponentDefine(self)
  self.bgPanel = self:AddComponent(UIButton, bgPanelPath)
  self.bgPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtnPath)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.weekText = self:AddComponent(UIText, "Root/titleItem/weekText")
  self.timeText = self:AddComponent(UIText, "Root/titleItem/timePanel/timeText")
  self.nameText = self:AddComponent(UIText, "Root/titleItem/nameText")
  self.weekText:SetLocalText(2000378)
  self:RefreshTimeText(DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc)
  self.nameText:SetLocalText(2000377)
  self.content = self:AddComponent(UIBaseContainer, "Root/MethodScroll/Viewport/Content")
  self.item = self:AddComponent(UIBaseContainer, "Root/MethodScroll/item")
  self.item.gameObject:GameObjectCreatePool()
  self.changeTimeBtn = self:AddComponent(UIButton, "Root/titleItem/timePanel/changeTimeBtn")
  self.changeTimeBtn:SetOnClick(function()
    local isShowSvrTimeDesc = DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc
    DataCenter.ActivityPersonalArmsDataManager:SetIsShowSvrTimeDesc(not isShowSvrTimeDesc)
    self:RefreshShowSvrTimeDesc()
  end)
end

local function ComponentDestroy(self)
  self.bgPanel = nil
  self.closeBtn = nil
  self.content:RemoveComponents(UIPersonalArmsCalendarItem)
  self.content = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
  self.cellList = nil
end

local function RefreshView(self)
  local activityId = self.param
  local calendarData = DataCenter.ActivityPersonalArmsDataManager:GetCalenderData(activityId)
  if calendarData == nil then
    SFSNetwork.SendMessage(MsgDefines.ActivityHeroCalender, toInt(activityId))
    return
  end
  local curDay = calendarData.curDay
  local curStage = calendarData.curStage
  local activityData = DataCenter.ActivityPersonalArmsDataManager:GetCurData(activityId)
  if activityData then
    curDay = activityData.curDay
    curStage = activityData.curStage
  end
  local curIndex = 0
  self.showDataList = {}
  local dayArr = calendarData.dayArr
  for i = 1, #dayArr do
    local dayData = dayArr[i]
    local dayNum = dayData.day
    local eventArr = dayData.eventArr
    for j = 1, #eventArr do
      local stageNum = j - 1
      local eventData = eventArr[j]
      local isShowWeek = stageNum == 0
      local isCur = dayNum == curDay and stageNum == curStage
      if isCur then
        curIndex = #self.showDataList
      end
      local showDataItem = {
        dayNum = dayNum,
        stageNum = stageNum,
        isShowWeek = isShowWeek,
        isCur = isCur,
        eventId = eventData.eventId,
        name = eventData.name,
        startTime = eventData.startTime * 1000,
        endTime = eventData.endTime * 1000
      }
      table.insert(self.showDataList, showDataItem)
    end
  end
  self.content:RemoveComponents(UIPersonalArmsCalendarItem)
  self.item.gameObject:GameObjectRecycleAll()
  self.cellList = nil
  local list = self.showDataList
  if list ~= nil then
    self.cellList = {}
    local isShowSvrTimeDesc = DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc
    self:RefreshTimeText(isShowSvrTimeDesc)
    for i = 1, table.length(list) do
      local item = self.item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = tostring(i)
      local cell = self.content:AddComponent(UIPersonalArmsCalendarItem, item.name, list[i])
      cell:SetData(list[i], isShowSvrTimeDesc)
      self.cellList[i] = cell
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.content:SetAnchoredPositionXY(0, curIndex * 74)
end

local function RefreshShowSvrTimeDesc(self)
  local isShowSvrTimeDesc = DataCenter.ActivityPersonalArmsDataManager.isShowSvrTimeDesc
  self:RefreshTimeText(isShowSvrTimeDesc)
  if self.cellList then
    for i, v in ipairs(self.cellList) do
      v:RefreshTimeType(isShowSvrTimeDesc)
    end
  end
end

local function RefreshTimeText(self, isShowSvrTimeDesc)
  if isShowSvrTimeDesc then
    self.timeText:SetLocalText("activity_clock_serverTime")
  else
    self.timeText:SetLocalText("activity_clock_localTime")
  end
end

UIPersonalArmsCalendarView.OnCreate = OnCreate
UIPersonalArmsCalendarView.OnDestroy = OnDestroy
UIPersonalArmsCalendarView.ComponentDefine = ComponentDefine
UIPersonalArmsCalendarView.ComponentDestroy = ComponentDestroy
UIPersonalArmsCalendarView.RefreshView = RefreshView
UIPersonalArmsCalendarView.OnAddListener = OnAddListener
UIPersonalArmsCalendarView.OnRemoveListener = OnRemoveListener
UIPersonalArmsCalendarView.OnDataUpdate = OnDataUpdate
UIPersonalArmsCalendarView.RefreshShowSvrTimeDesc = RefreshShowSvrTimeDesc
UIPersonalArmsCalendarView.RefreshTimeText = RefreshTimeText
return UIPersonalArmsCalendarView
