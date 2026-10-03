local LWUIZombieRushOrderTimePopView = BaseClass("LWUIZombieRushOrderTimePopView", UIBaseView)
local DiffItem = require("UI.LWUIZombieRushOrderPop.Component.OrderTimeItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWZombieRushTemplateManager = DataCenter.LWZombieRushTemplateManager
local MinuteSplit = 4

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitServerData()
  self:InitData()
  self:InitAttendTimeList()
  if self.serverData <= 0 or #self.hourList == 0 then
    self:InitHoutList()
  end
  self:SetLoaclTime()
end

local function OnDestroy(self)
  self:ClearDifficultySelectLoopView()
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
  self.titleText = self:AddComponent(UIText, "safeArea/Common_img_title/titleText")
  self.closeBtn = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.difficultySelectScrollView = self:AddComponent(UILoopListView2, "safeArea/WihteImage/DifficultySelectScrollView")
  self.difficultySelectScrollContent = self:AddComponent(UIBaseContainer, "safeArea/WihteImage/DifficultySelectScrollView/Viewport/DifficultySelectScrollContent")
  self.DateSelectScrollView = self:AddComponent(UILoopListView2, "safeArea/WihteImage/DateSelectScrollView")
  self.DateSelectScrollContent = self:AddComponent(UIBaseContainer, "safeArea/WihteImage/DateSelectScrollView/Viewport/DateSelectScrollContent")
  self.TimeSelectScrollView = self:AddComponent(UILoopListView2, "safeArea/WihteImage/TimeSelectScrollView")
  self.TimeSelectScrollContent = self:AddComponent(UIBaseContainer, "safeArea/WihteImage/TimeSelectScrollView/Viewport/TimeSelectScrollContent")
  self.localTimeText = self:AddComponent(UIText, "safeArea/WihteImage/LocalTimeText")
  self.confirmBtn = self:AddComponent(UIButton, "safeArea/BtnGo")
  self.panelBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.panelBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirmBtn:SetOnClick(function()
    self:ConfirmBtn()
  end)
  self.difficultySelectScrollView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.difficultySelectScrollView:SetOnSnapItemFinished(function(listView, item)
    self:OnItemSnapFinish(listView, item)
  end)
  self.difficultySelectScrollView:SetOnSnapNearestChanged(function(listView, item)
    self:OnItemSnapNearestChanged(listView, item)
  end)
  self.DateSelectScrollView:InitListView(0, function(listView, index)
    return self:OnGetDateItemByIndex(listView, index)
  end)
  self.DateSelectScrollView:SetOnSnapNearestChanged(function(listView, item)
    self:OnDateItemSnapNearestChanged(listView, item)
  end)
  self.TimeSelectScrollView:InitListView(0, function(listView, index)
    return self:OnGetTimeItemByIndex(listView, index)
  end)
  self.TimeSelectScrollView:SetOnSnapNearestChanged(function(listView, item)
    self:OnTimeItemSnapNearestChanged(listView, item)
  end)
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.closeBtn = nil
  self.difficultySelectScrollView = nil
  self.difficultySelectScrollContent = nil
  self.DateSelectScrollView = nil
  self.DateSelectScrollContent = nil
  self.TimeSelectScrollView = nil
  self.TimeSelectScrollContent = nil
  self.localTimeText = nil
  self.confirmBtn = nil
  self.panelBtn = nil
end

local function DataDefine(self)
  self.allTemplateIds = LWZombieRushTemplateManager:GetAllTemplateIdsByType(ZombieRushType.ZombieRush)
  table.sort(self.allTemplateIds, function(a, b)
    local templateA = LWZombieRushTemplateManager:GetTemplate(a)
    local templateB = LWZombieRushTemplateManager:GetTemplate(b)
    return templateA.difficulty < templateB.difficulty
  end)
  self.timeList = {}
  self.hourList = {}
  self.curSelectIndex = 0
  self.curSelectDateIndex = 0
  self.curSelectHourIndex = 0
  self.itemIndex = 0
  self.dateItemIndex = 0
  self.hourItemIndex = 0
  self.timeStamp = 0
  self.curSelectTemplateId = nil
  self.curSelectDate = nil
  self.curSelectHour = nil
  self.serverData = -1
  self.serverHour = -1
  self.serverDate = -1
  self.lastSelectHour = -1
  self.lastHourCount = 0
end

local function DataDestroy(self)
  self.allTemplateIds = nil
  self.timeList = nil
  self.hourList = nil
  self.curSelectIndex = nil
  self.curSelectDateIndex = nil
  self.itemIndex = nil
  self.hourItemIndex = nil
  self.dateItemIndex = nil
  self.curSelectTemplateId = nil
  self.curSelectDate = nil
  self.curSelectHour = nil
  self.curSelectHourIndex = nil
  self.timeStamp = nil
  self.serverData = nil
  self.serverHour = nil
  self.serverDate = nil
  self.lastSelectHour = nil
  self.lastHourCount = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitServerData(self)
  self.serverData = DataCenter.LWZombieRushPlanInfoManager:GetPlanId()
  local time = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
  if 0 < time then
    local timeDate = UITimeManager:GetInstance():TimeSecToServerDate(time / 1000)
    self.serverHour = self.ctrl:GetHourParamByHourAndMinute(timeDate.hour, timeDate.min, MinuteSplit)
    self.serverDate = timeDate.day
  end
end

local function InitData(self)
  if self.serverData > 0 then
    self.curSelectTemplateId = self.serverData
  else
    self.curSelectTemplateId = DataCenter.LWZombieRushManager.maxDifficultyId
  end
  local count = table.count(self.allTemplateIds)
  if table.indexof(self.allTemplateIds, self.curSelectTemplateId) then
    self.curSelectIndex = table.indexof(self.allTemplateIds, self.curSelectTemplateId)
  elseif self.allTemplateIds[count] < self.curSelectTemplateId then
    self.curSelectIndex = count
    self.curSelectTemplateId = self.allTemplateIds[count]
  end
  if 0 < count then
    self.difficultySelectScrollView:SetListItemCount(count, false, false)
    self.difficultySelectScrollView:RefreshAllShownItem()
    self.difficultySelectScrollView:MovePanelToItemIndex(self.curSelectIndex - 1, 0)
  end
end

local function OnGetItemByIndex(self, loopScroll, index)
  local count = table.count(self.allTemplateIds)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  if self.allTemplateIds[index] <= DataCenter.LWZombieRushManager.maxDifficultyId then
    local item = loopScroll:NewListViewItem("DiffItem")
    local script = self.difficultySelectScrollContent:GetComponent(item.gameObject.name, DiffItem)
    if script == nil then
      local objectName = tostring(self.itemIndex)
      self.itemIndex = self.itemIndex + 1
      item.gameObject.name = objectName
      script = self.difficultySelectScrollContent:AddComponent(DiffItem, objectName)
    end
    script:SetActive(true)
    local templateId = self.allTemplateIds[index]
    local template = LWZombieRushTemplateManager:GetTemplate(templateId)
    local isSelect = templateId == self.curSelectTemplateId
    script:SetDiffData(template, isSelect)
    return item
  else
    return nil
  end
end

local function OnGetDateItemByIndex(self, loopScroll, index)
  local count = table.count(self.timeList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("DateItem")
  local script = self.DateSelectScrollContent:GetComponent(item.gameObject.name, DiffItem)
  if script == nil then
    local objectName = tostring(self.hourItemIndex)
    self.hourItemIndex = self.hourItemIndex + 1
    item.gameObject.name = objectName
    script = self.DateSelectScrollContent:AddComponent(DiffItem, objectName)
  end
  script:SetActive(true)
  local date = self.timeList[index]
  local isSelect = date.day == self.curSelectDate.day
  script:SetDateData(date, isSelect)
  return item
end

local function OnGetTimeItemByIndex(self, loopScroll, index)
  local count = table.count(self.hourList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("HourItem")
  local script = self.TimeSelectScrollContent:GetComponent(item.gameObject.name, DiffItem)
  if script == nil then
    local objectName = tostring(self.dateItemIndex)
    self.dateItemIndex = self.dateItemIndex + 1
    item.gameObject.name = objectName
    script = self.TimeSelectScrollContent:AddComponent(DiffItem, objectName)
  end
  script:SetActive(true)
  local hour = self.hourList[index]
  local isSelect = hour == self.curSelectHour
  script:SetHourData(hour, isSelect)
  return item
end

local function OnItemSnapNearestChanged(self, loopScroll, item)
  self.curSelectIndex = item.ItemIndex + 1
  self.curSelectTemplateId = self.allTemplateIds[self.curSelectIndex]
  EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushSelectPopDifficulty, self.curSelectTemplateId)
end

local function OnDateItemSnapNearestChanged(self, loopScroll, item)
  self.curSelectDateIndex = item.ItemIndex + 1
  self.curSelectDate = self.timeList[self.curSelectDateIndex]
  self:InitHoutList()
  EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushSelectPopDate, self.curSelectDate)
  local find = false
  for k, v in pairs(self.hourList) do
    if v == self.lastSelectHour then
      self.curSelectHourIndex = k
      self.curSelectHour = self.hourList[self.curSelectHourIndex]
      find = true
      break
    end
  end
  if not find then
    self.curSelectHourIndex = 1
    self.curSelectHour = self.hourList[self.curSelectHourIndex]
  end
  self:SetLoaclTime()
  EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushSelectPopHour, tostring(self.curSelectHour))
end

local function OnTimeItemSnapNearestChanged(self, loopScroll, item)
  self.curSelectHourIndex = item.ItemIndex + 1
  self.curSelectHour = self.hourList[self.curSelectHourIndex]
  self.lastSelectHour = self.curSelectHour
  self:SetLoaclTime()
  EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushSelectPopHour, tostring(self.curSelectHour))
end

local function SetLoaclTime(self)
  if self.curSelectDate then
    local hour, min = self.ctrl:GetHourAndMinuteByHour(self.curSelectHour)
    self.curSelectDate.min = min
    self.curSelectDate.sec = 0
    self.curSelectDate.hour = hour
    local offsetHour = (self.curSelectDateIndex - 1) * 24 + self.curSelectHour
    self.timeStamp = self.startZeroTime + offsetHour * 3600 * 1000
    if self.curSelectHour == 0 then
      self.timeStamp = self.timeStamp + LuaEntry.DataConfig:TryGetNum("zombieRush_config", "k13", 5) * 1000
    end
    local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(self.timeStamp)
    self.localTimeText:SetLocalText("zombierush_plan_title5", localTime)
  end
end

local function CalculateDaysDifference(self, date1, date2)
  local time1 = SafeLocalOsTime(date1)
  local time2 = SafeLocalOsTime(date2)
  local difference = os.difftime(time1, time2)
  local days = math.floor(difference / 86400)
  return math.abs(days)
end

local function ClearDifficultySelectLoopView(self)
  self.difficultySelectScrollContent:RemoveComponents(DiffItem)
  self.difficultySelectScrollView:ClearAllItems()
  self.DateSelectScrollContent:RemoveComponents(DiffItem)
  self.DateSelectScrollView:ClearAllItems()
  self:ClearHourSelectLoopView()
end

local function ClearHourSelectLoopView(self)
  self.TimeSelectScrollView:RemoveComponents(DiffItem)
  self.TimeSelectScrollView:ClearAllItems()
end

local function OnItemSnapFinish(self, loopScroll, item)
end

local function InitAttendTimeList(self)
  local isCd = DataCenter.LWZombieRushManager:IsCd()
  local startTime
  if isCd then
    startTime = DataCenter.LWZombieRushManager:GetCdTime()
  else
    startTime = UITimeManager:GetInstance():GetServerTime()
  end
  self.curSelectDate = UITimeManager:GetInstance():TimeStampToServerDate(startTime)
  self.curSelectDateIndex = 1
  local startTimeOffset = 0
  for i = 1, 3 do
    local timeData = startTime + (i - 1) * 86400000
    local serverTimeData = UITimeManager:GetInstance():TimeStampToServerDate(timeData)
    local hour, min = self.ctrl:GetStartHourAndMinuteByData(serverTimeData, MinuteSplit)
    if hour < 23 then
      if self.serverDate == serverTimeData.day then
        self.curSelectDate = UITimeManager:GetInstance():TimeStampToServerDate(timeData)
        self.curSelectDateIndex = i
      end
    else
      if i == 1 then
        startTimeOffset = 3600000
      end
      timeData = startTime + (i - 1) * 86400000 + 3600000
      serverTimeData = UITimeManager:GetInstance():TimeStampToServerDate(timeData)
      self.curSelectDate = UITimeManager:GetInstance():TimeStampToServerDate(timeData)
      self.curSelectDateIndex = i
    end
    table.insert(self.timeList, serverTimeData)
  end
  self.startZeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime((startTime + startTimeOffset) // 1000) * 1000
  local count = #self.timeList
  if 0 < count then
    self.DateSelectScrollView:SetListItemCount(count, false, false)
    self.DateSelectScrollView:RefreshAllShownItem()
    self.DateSelectScrollView:MovePanelToItemIndex(self.curSelectDateIndex - 1, 0)
  end
end

local function InitHoutList(self)
  local isCd = DataCenter.LWZombieRushManager:IsCd()
  local startHour = 0
  local startMin = 0
  if isCd then
    local cdTime = DataCenter.LWZombieRushManager:GetCdTime()
    cdTime = UITimeManager:GetInstance():TimeStampToServerDate(cdTime)
    if self.curSelectDate.day == cdTime.day then
      startHour, startMin = self.ctrl:GetStartHourAndMinuteByData(cdTime, MinuteSplit)
    end
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    curTime = UITimeManager:GetInstance():TimeStampToServerDate(curTime)
    if self.curSelectDate.day == curTime.day then
      startHour, startMin = self.ctrl:GetStartHourAndMinuteByData(curTime, MinuteSplit)
    end
  end
  self.lastHourCount = #self.hourList
  self.hourList = {}
  for i = startHour, 23 do
    local minStep = 1 / MinuteSplit
    for j = 0, MinuteSplit - 1 do
      local min = minStep * j
      if i == startHour then
        if startMin <= min * 60 then
          table.insert(self.hourList, i + min)
        end
      else
        table.insert(self.hourList, i + min)
      end
    end
  end
  if 0 <= self.serverHour and self.serverDate == self.curSelectDate.day then
    local index = 1
    for i = 1, #self.hourList do
      if self.serverHour == self.hourList[i] then
        index = i
        break
      end
    end
    self.curSelectHourIndex = index
    self.curSelectHour = self.serverHour
    self.serverHour = -1
  else
    local find = false
    for k, v in pairs(self.hourList) do
      if v == self.lastSelectHour then
        self.curSelectHourIndex = k
        self.curSelectHour = self.hourList[self.curSelectHourIndex]
        find = true
        break
      end
    end
    if not find then
      self.curSelectHourIndex = 1
      self.curSelectHour = self.hourList[self.curSelectHourIndex]
    end
  end
  self.lastSelectHour = self.curSelectHour
  local count = #self.hourList
  if 0 < count then
    self.TimeSelectScrollView:SetListItemCount(count, false, false)
    self.TimeSelectScrollView:RefreshAllShownItem()
    self.TimeSelectScrollView:MovePanelToItemIndex(self.curSelectHourIndex - 1, 0)
  end
end

local function ConfirmBtn(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.timeStamp and curTime > self.timeStamp then
    UIUtil.ShowTipsId("zombierush_plan_tips_04")
    return
  end
  DataCenter.LWZombieRushPlanInfoManager:SetPlanTime(self.timeStamp)
  local level = DataCenter.LWZombieRushPlanInfoManager:GetNowPlanLevel()
  DataCenter.LWZombieRushPlanInfoManager:SendMsgZombieRushActSetPlanInfo(self.curSelectTemplateId, self.timeStamp, level)
  self.ctrl:CloseSelf()
end

LWUIZombieRushOrderTimePopView.OnCreate = OnCreate
LWUIZombieRushOrderTimePopView.OnDestroy = OnDestroy
LWUIZombieRushOrderTimePopView.OnEnable = OnEnable
LWUIZombieRushOrderTimePopView.OnDisable = OnDisable
LWUIZombieRushOrderTimePopView.ComponentDefine = ComponentDefine
LWUIZombieRushOrderTimePopView.ComponentDestroy = ComponentDestroy
LWUIZombieRushOrderTimePopView.DataDefine = DataDefine
LWUIZombieRushOrderTimePopView.DataDestroy = DataDestroy
LWUIZombieRushOrderTimePopView.OnAddListener = OnAddListener
LWUIZombieRushOrderTimePopView.OnRemoveListener = OnRemoveListener
LWUIZombieRushOrderTimePopView.OnGetItemByIndex = OnGetItemByIndex
LWUIZombieRushOrderTimePopView.OnItemSnapFinish = OnItemSnapFinish
LWUIZombieRushOrderTimePopView.OnItemSnapNearestChanged = OnItemSnapNearestChanged
LWUIZombieRushOrderTimePopView.InitData = InitData
LWUIZombieRushOrderTimePopView.ClearDifficultySelectLoopView = ClearDifficultySelectLoopView
LWUIZombieRushOrderTimePopView.InitAttendTimeList = InitAttendTimeList
LWUIZombieRushOrderTimePopView.OnGetDateItemByIndex = OnGetDateItemByIndex
LWUIZombieRushOrderTimePopView.OnDateItemSnapNearestChanged = OnDateItemSnapNearestChanged
LWUIZombieRushOrderTimePopView.InitHoutList = InitHoutList
LWUIZombieRushOrderTimePopView.OnGetTimeItemByIndex = OnGetTimeItemByIndex
LWUIZombieRushOrderTimePopView.OnTimeItemSnapNearestChanged = OnTimeItemSnapNearestChanged
LWUIZombieRushOrderTimePopView.ClearHourSelectLoopView = ClearHourSelectLoopView
LWUIZombieRushOrderTimePopView.SetLoaclTime = SetLoaclTime
LWUIZombieRushOrderTimePopView.ConfirmBtn = ConfirmBtn
LWUIZombieRushOrderTimePopView.InitServerData = InitServerData
LWUIZombieRushOrderTimePopView.CalculateDaysDifference = CalculateDaysDifference
return LWUIZombieRushOrderTimePopView
