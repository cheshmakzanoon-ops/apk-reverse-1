local UINoticeDatePickerView = BaseClass("UINoticeDatePickerView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UINoticeDatePickerItem = require("UI.UINoticeDatePicker.Component.UINoticeDatePickerItem")
local panel_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local scroll_view_day_path = "Root/TimeContent/TimeSelectContent/DaySelectContent/DaySelectBg/ScrollViewDay"
local day_content1_path = "Root/TimeContent/TimeSelectContent/DaySelectContent/DaySelectBg/ScrollViewDay/mask/Viewport/dayContent1"
local day_item_path = "Root/TimeContent/TimeSelectContent/DaySelectContent/DaySelectBg/dayItem"
local day_content2_path = "Root/TimeContent/TimeSelectContent/DaySelectContent/DaySelectBg/maskContent/dayContent2"
local day_item2_path = "Root/TimeContent/TimeSelectContent/DaySelectContent/DaySelectBg/maskContent/dayItem2"
local scroll_view_time_path = "Root/TimeContent/TimeSelectContent/TimeSelectContent/TimeSelectBg/ScrollViewTime"
local time_content1_path = "Root/TimeContent/TimeSelectContent/TimeSelectContent/TimeSelectBg/ScrollViewTime/mask/Viewport/timeContent1"
local time_item_path = "Root/TimeContent/TimeSelectContent/TimeSelectContent/TimeSelectBg/timeItem"
local time_content2_path = "Root/TimeContent/TimeSelectContent/TimeSelectContent/TimeSelectBg/maskContent/timeContent2"
local time_item2_path = "Root/TimeContent/TimeSelectContent/TimeSelectContent/TimeSelectBg/maskContent/timeItem2"
local change_time_type_btn_path = "Root/TimeContent/timeTypeContent/ChangeTimeTypeBtn"
local time_type_txt_assign_path = "Root/TimeContent/timeTypeContent/timeTypeTxtAssign"
local common_button_path = "Root/CommonButton"
local ViewState = {
  Normal = 1,
  Drag = 2,
  WaitBack = 3,
  Reset = 4
}
local itemH = 90
local itemShowNum = 5
local itemShowRange = 2

function UINoticeDatePickerView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UINoticeDatePickerView:OnDestroy()
  self:ClearAllItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UINoticeDatePickerView:OnEnable()
  base.OnEnable(self)
end

function UINoticeDatePickerView:OnDisable()
  base.OnDisable(self)
end

function UINoticeDatePickerView:OnAddListener()
  base.OnAddListener(self)
end

function UINoticeDatePickerView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UINoticeDatePickerView:DataDefine()
  self.inputData = nil
  self.timeData = nil
  self.showTimeType = nil
  self.showTimeList = nil
  self.showDayIndex = nil
  self.showtimeIndex = nil
  self.showTimeNum = nil
  self.showScrollState = nil
  self.showScrollState2 = nil
  self.showScrollStateVal = nil
  self.showScrollStateVal2 = nil
  self.scrollPreVal = 0
  self.scrollPreVal2 = 0
end

function UINoticeDatePickerView:DataDestroy()
  self.inputData = nil
  self.timeData = nil
  self.showTimeType = nil
  self.showTimeList = nil
  self.showDayIndex = nil
  self.showtimeIndex = nil
  self.showTimeNum = nil
  self.showScrollState = nil
  self.showScrollState2 = nil
  self.showScrollStateVal = nil
  self.showScrollStateVal2 = nil
  self.scrollPreVal = 0
  self.scrollPreVal2 = 0
end

function UINoticeDatePickerView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scroll_view_day = self:AddComponent(UIScrollRect, scroll_view_day_path)
  self.scroll_view_day_trigger = self:AddComponent(UIEventTrigger, scroll_view_day_path)
  self.day_content1 = self:AddComponent(UIBaseContainer, day_content1_path)
  self.day_item = self:AddComponent(UIBaseContainer, day_item_path)
  self.day_content2 = self:AddComponent(UIBaseContainer, day_content2_path)
  self.day_item2 = self:AddComponent(UIBaseContainer, day_item2_path)
  self.scroll_view_time = self:AddComponent(UIScrollRect, scroll_view_time_path)
  self.scroll_view_time_trigger = self:AddComponent(UIEventTrigger, scroll_view_time_path)
  self.time_content1 = self:AddComponent(UIBaseContainer, time_content1_path)
  self.time_item = self:AddComponent(UIBaseContainer, time_item_path)
  self.time_content2 = self:AddComponent(UIBaseContainer, time_content2_path)
  self.time_item2 = self:AddComponent(UIBaseContainer, time_item2_path)
  self.day_item_list = {}
  self.day_item:SetActive(false)
  self.day_item.gameObject:GameObjectCreatePool()
  self.day_item2_list = {}
  self.day_item2:SetActive(false)
  self.day_item2.gameObject:GameObjectCreatePool()
  self.time_item_list = {}
  self.time_item:SetActive(false)
  self.time_item.gameObject:GameObjectCreatePool()
  self.time_item2_list = {}
  self.time_item2:SetActive(false)
  self.time_item2.gameObject:GameObjectCreatePool()
  self.change_time_type_btn = self:AddComponent(UIButton, change_time_type_btn_path)
  self.time_type_txt_assign = self:AddComponent(UITextMeshProUGUIEx, time_type_txt_assign_path)
  self.common_button = self:AddComponent(UIButton, common_button_path)
  self.common_button:SetOnClick(function()
    self:OnCommonButtonClick()
  end)
  self.change_time_type_btn:SetOnClick(function()
    self:OnChangeTimeTypeBtnClick()
  end)
  self.scroll_view_day:AddValueChangeListener(function(val)
    self:OnDayScrollValueChange(val)
  end)
  self.scroll_view_time:AddValueChangeListener(function(val)
    self:OnTimeScrollValueChange(val)
  end)
  self.scroll_view_day_trigger:OnBeginDrag(function(eventData)
    self:OnDayScrollBeginDrag(eventData)
  end)
  self.scroll_view_day_trigger:OnEndDrag(function(eventData)
    self:OnDayScrollEndDrag(eventData)
  end)
  self.scroll_view_time_trigger:OnBeginDrag(function(eventData)
    self:OnTimeScrollBeginDrag(eventData)
  end)
  self.scroll_view_time_trigger:OnEndDrag(function(eventData)
    self:OnTimeScrollEndDrag(eventData)
  end)
end

function UINoticeDatePickerView:ComponentDestroy()
  self.panel = nil
  self.close_btn = nil
  self.scroll_view_day = nil
  self.day_content1 = nil
  self.day_item = nil
  self.day_content2 = nil
  self.day_item2 = nil
  self.scroll_view_time = nil
  self.time_content1 = nil
  self.time_item = nil
  self.time_content2 = nil
  self.time_item2 = nil
  self.change_time_type_btn = nil
  self.time_type_txt_assign = nil
  self.common_button = nil
end

function UINoticeDatePickerView:ClearAllItems()
  self.day_content1:RemoveComponents(UINoticeDatePickerItem)
  self.day_item.gameObject:GameObjectRecycleAll()
  self.day_item_list = {}
  self.day_content2:RemoveComponents(UINoticeDatePickerItem)
  self.day_item2.gameObject:GameObjectRecycleAll()
  self.day_item2_list = {}
  self.time_content1:RemoveComponents(UINoticeDatePickerItem)
  self.time_item.gameObject:GameObjectRecycleAll()
  self.time_item_list = {}
  self.time_content2:RemoveComponents(UINoticeDatePickerItem)
  self.time_item2.gameObject:GameObjectRecycleAll()
  self.time_item2_list = {}
end

function UINoticeDatePickerView:InitData()
  self.inputData = self:GetUserData()
  self.timeData = DataCenter.AllianceNoticeManager:GetVoteSelectTimeDataByCurTime()
  self.showTimeType = self.inputData.type
  local inTime = self.inputData.time
  if self.showTimeType == TimeShowType.Local then
    self.showTimeList = self.timeData.localDataList
  else
    self.showTimeList = self.timeData.serverDataList
  end
  local isFind = false
  for dayIndex, dayData in ipairs(self.showTimeList) do
    for timeIndex, timeData in ipairs(dayData.timeDataList) do
      local time = timeData.time
      self.showDayIndex = dayIndex
      self.showtimeIndex = timeIndex
      self.showTimeNum = time
      if inTime <= time then
        isFind = true
        break
      end
    end
    if isFind then
      break
    end
  end
  self.showScrollState = ViewState.Normal
  self.showScrollState2 = ViewState.Normal
  self.showScrollStateVal = 0
  self.showScrollStateVal2 = 0
end

function UINoticeDatePickerView:RefreshView(isDayPosReset, isTimePosReset)
  self:RefreshTimeContent()
  self:RefreshDayScroll(isDayPosReset)
  self:RefreshTimeScroll(isTimePosReset)
end

function UINoticeDatePickerView:RefreshTimeContent()
  local timeStr = ""
  local timeTipStr = ""
  if self.showTimeType == TimeShowType.Local then
    timeStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.showTimeNum, false, true)
    timeTipStr = Localization:GetString("alliance_announcement_vote_time2", timeStr)
  else
    timeStr = UITimeManager:GetInstance():GetServerTimeByUTC(self.showTimeNum, false, true)
    timeTipStr = Localization:GetString("alliance_announcement_vote_time3", timeStr)
  end
  self.time_type_txt_assign:SetText(timeTipStr)
end

function UINoticeDatePickerView:RefreshDayScroll(isPosReset)
  local dayNum = #self.showTimeList
  local contentH = dayNum * itemH
  self.day_content1:SetSizeDeltaY(contentH)
  self.day_content2:SetSizeDeltaY(contentH)
  local curIndex = self.showDayIndex
  local startIndex = curIndex - itemShowRange
  local endIndex = curIndex + itemShowRange
  for i = startIndex, endIndex do
    local objIndex = i
    if objIndex < 1 then
      local num = math.ceil(math.abs(objIndex - 1) / itemShowNum)
      objIndex = num * itemShowNum + objIndex
    end
    objIndex = (objIndex - 1) % itemShowNum + 1
    local data = self.showTimeList[i]
    if data then
      local str = string.format("%d-%d-%d", data.year, data.month, data.day)
      local itemPos = -1 * (i - 1) * itemH
      if self.day_item_list[objIndex] == nil then
        local item = self.day_item.gameObject:GameObjectSpawn(self.day_content1.transform)
        item.name = i
        local obj = self.day_content1:AddComponent(UINoticeDatePickerItem, item)
        self.day_item_list[objIndex] = obj
      end
      self.day_item_list[objIndex]:SetActive(true)
      self.day_item_list[objIndex]:SetData(str)
      self.day_item_list[objIndex]:SetAnchoredPositionXY(0, itemPos)
      if self.day_item2_list[objIndex] == nil then
        local item = self.day_item2.gameObject:GameObjectSpawn(self.day_content2.transform)
        item.name = i
        local obj = self.day_content2:AddComponent(UINoticeDatePickerItem, item)
        self.day_item2_list[objIndex] = obj
      end
      self.day_item2_list[objIndex]:SetActive(true)
      self.day_item2_list[objIndex]:SetData(str)
      self.day_item2_list[objIndex]:SetAnchoredPositionXY(0, itemPos)
    else
      if self.day_item_list[objIndex] then
        self.day_item_list[objIndex]:SetActive(false)
      end
      if self.day_item2_list[objIndex] then
        self.day_item2_list[objIndex]:SetActive(false)
      end
    end
  end
  if isPosReset then
    self.scroll_view_day:StopMovement()
    self.day_content1:SetAnchoredPositionXY(0, (self.showDayIndex - 1) * itemH)
  end
  self:AsyncDayContentPos()
end

function UINoticeDatePickerView:AsyncDayContentPos()
  self.day_content2:SetAnchoredPositionXY(0, self.day_content1:GetAnchoredPositionY())
end

function UINoticeDatePickerView:RefreshTimeScroll(isPosReset)
  local timeList = self.showTimeList[self.showDayIndex].timeDataList
  local timeNum = #timeList
  local contentH = timeNum * itemH
  self.time_content1:SetSizeDeltaY(contentH)
  self.time_content2:SetSizeDeltaY(contentH)
  local curIndex = self.showtimeIndex
  local startIndex = curIndex - itemShowRange
  local endIndex = curIndex + itemShowRange
  for i = startIndex, endIndex do
    local objIndex = i
    if objIndex < 1 then
      local num = math.ceil(math.abs(objIndex - 1) / itemShowNum)
      objIndex = num * itemShowNum + objIndex
    end
    objIndex = (objIndex - 1) % itemShowNum + 1
    local data = timeList[i]
    if data then
      local str = string.format("%02d:%02d", data.hour, data.min)
      local itemPos = -1 * (i - 1) * itemH
      if self.time_item_list[objIndex] == nil then
        local item = self.time_item.gameObject:GameObjectSpawn(self.time_content1.transform)
        item.name = i
        local obj = self.time_content1:AddComponent(UINoticeDatePickerItem, item)
        self.time_item_list[objIndex] = obj
      end
      self.time_item_list[objIndex]:SetActive(true)
      self.time_item_list[objIndex]:SetData(str)
      self.time_item_list[objIndex]:SetAnchoredPositionXY(0, itemPos)
      if self.time_item2_list[objIndex] == nil then
        local item = self.time_item2.gameObject:GameObjectSpawn(self.time_content2.transform)
        item.name = i
        local obj = self.time_content2:AddComponent(UINoticeDatePickerItem, item)
        self.time_item2_list[objIndex] = obj
      end
      self.time_item2_list[objIndex]:SetActive(true)
      self.time_item2_list[objIndex]:SetData(str)
      self.time_item2_list[objIndex]:SetAnchoredPositionXY(0, itemPos)
    else
      if self.time_item_list[objIndex] then
        self.time_item_list[objIndex]:SetActive(false)
      end
      if self.time_item2_list[objIndex] then
        self.time_item2_list[objIndex]:SetActive(false)
      end
    end
  end
  if isPosReset then
    self.scroll_view_time:StopMovement()
    self.time_content1:SetAnchoredPositionXY(0, (self.showtimeIndex - 1) * itemH)
  end
  self:AsyncTimeContentPos()
end

function UINoticeDatePickerView:AsyncTimeContentPos()
  self.time_content2:SetAnchoredPositionXY(0, self.time_content1:GetAnchoredPositionY())
end

function UINoticeDatePickerView:ReInit()
  self:InitData()
  self:RefreshView()
end

function UINoticeDatePickerView:OnCommonButtonClick()
  local data = {
    time = self.showTimeNum,
    type = self.showTimeType
  }
  EventManager:GetInstance():Broadcast(EventId.NoticeVoteTimeSet, data)
  self.ctrl:CloseSelf()
end

function UINoticeDatePickerView:OnChangeTimeTypeBtnClick()
  if self.showTimeType == TimeShowType.Local then
    self.showTimeType = TimeShowType.Server
  else
    self.showTimeType = TimeShowType.Local
  end
  if self.showTimeType == TimeShowType.Local then
    self.showTimeList = self.timeData.localDataList
  else
    self.showTimeList = self.timeData.serverDataList
  end
  self:RefreshDataByshowTimeNum(true, true)
end

function UINoticeDatePickerView:RefreshDataByshowTimeNum(isDayPosReset, isTimePosReset)
  local isFind = false
  local inTime = self.showTimeNum
  for dayIndex, dayData in ipairs(self.showTimeList) do
    for timeIndex, timeData in ipairs(dayData.timeDataList) do
      local time = timeData.time
      self.showDayIndex = dayIndex
      self.showtimeIndex = timeIndex
      self.showTimeNum = time
      if inTime <= time then
        isFind = true
        break
      end
    end
    if isFind then
      break
    end
  end
  self:RefreshView(isDayPosReset, isTimePosReset)
end

function UINoticeDatePickerView:OnDayScrollValueChange(val)
  if self.showScrollState == ViewState.WaitBack or self.showScrollState == ViewState.Drag then
    self.showScrollStateVal = (self.scrollPreVal - val.y) * 3000
    self.scrollPreVal = val.y
  end
end

function UINoticeDatePickerView:OnTimeScrollValueChange(val)
  if self.showScrollState2 == ViewState.WaitBack or self.showScrollState2 == ViewState.Drag then
    self.showScrollStateVal2 = (self.scrollPreVal2 - val.y) * 3000
    self.scrollPreVal2 = val.y
  end
end

function UINoticeDatePickerView:OnDayScrollBeginDrag(eventData)
  self.showScrollState = ViewState.Drag
  self.scrollPreVal = 0
end

function UINoticeDatePickerView:OnDayScrollEndDrag(eventData)
  self.showScrollState = ViewState.WaitBack
end

function UINoticeDatePickerView:OnTimeScrollBeginDrag(eventData)
  self.showScrollState2 = ViewState.Drag
  self.scrollPreVal2 = 0
end

function UINoticeDatePickerView:OnTimeScrollEndDrag(eventData)
  self.showScrollState2 = ViewState.WaitBack
end

function UINoticeDatePickerView:Update()
  local dayIndex = self.showDayIndex
  local dayConetntPosY = self.day_content1:GetAnchoredPositionY()
  local curDayIndex = math.floor((dayConetntPosY + itemH / 2) / itemH) + 1
  if curDayIndex ~= dayIndex then
    self:OnDayIndexChange(curDayIndex)
  else
    local timeIndex = self.showtimeIndex
    local timeConetntPosY = self.time_content1:GetAnchoredPositionY()
    local curTimeIndex = math.floor((timeConetntPosY + itemH / 2) / itemH) + 1
    if curTimeIndex ~= timeIndex then
      self:OnTimeIndexChange(curTimeIndex)
    end
  end
  if self.showScrollState == ViewState.WaitBack then
    if math.abs(self.showScrollStateVal) > 0.1 then
      self.showScrollStateVal = self.showScrollStateVal / 2
    else
      self.showScrollState = ViewState.Reset
    end
  elseif self.showScrollState == ViewState.Reset then
    local targetPosY = (self.showDayIndex - 1) * itemH
    self.scroll_view_day:StopMovement()
    local curPosY = self.day_content1:GetAnchoredPositionY()
    local diffY = targetPosY - curPosY
    if 1 < math.abs(diffY) then
      self.day_content1:SetAnchoredPositionXY(0, (curPosY + targetPosY) / 2)
    else
      self.day_content1:SetAnchoredPositionXY(0, targetPosY)
      self.showScrollState = ViewState.Normal
    end
  end
  if self.showScrollState2 == ViewState.WaitBack then
    if 0.1 < math.abs(self.showScrollStateVal2) then
      self.showScrollStateVal2 = self.showScrollStateVal2 / 2
    else
      self.showScrollState2 = ViewState.Reset
    end
  elseif self.showScrollState2 == ViewState.Reset then
    local targetPosY = (self.showtimeIndex - 1) * itemH
    self.scroll_view_time:StopMovement()
    local curPosY = self.time_content1:GetAnchoredPositionY()
    local diffY = targetPosY - curPosY
    if 1 < math.abs(diffY) then
      self.time_content1:SetAnchoredPositionXY(0, (curPosY + targetPosY) / 2)
    else
      self.time_content1:SetAnchoredPositionXY(0, targetPosY)
      self.showScrollState2 = ViewState.Normal
    end
  end
  self:AsyncDayContentPos()
  self:AsyncTimeContentPos()
end

function UINoticeDatePickerView:OnDayIndexChange(index)
  if self.showDayIndex == index then
    return
  end
  local diffNum = index - self.showDayIndex
  local curDayIndex = self.showDayIndex
  local targetDayIndex = self.showDayIndex + diffNum
  local curTime = self.showTimeNum
  local targetTime = self.showTimeNum + diffNum * 24 * 60 * 60 * 1000
  if targetDayIndex < 1 then
    targetDayIndex = 1
  elseif targetDayIndex > #self.showTimeList then
    targetDayIndex = #self.showTimeList
  end
  local targetTimeList = self.showTimeList[targetDayIndex].timeDataList
  local targetTimeIndex = -1
  for i, timeData in ipairs(targetTimeList) do
    if targetTime <= timeData.time then
      targetTimeIndex = i
      break
    end
  end
  if targetTimeIndex == -1 then
    targetTimeIndex = #targetTimeList
  end
  self.showTimeNum = targetTimeList[targetTimeIndex].time
  self:RefreshDataByshowTimeNum(false, true)
end

function UINoticeDatePickerView:OnTimeIndexChange(index)
  if self.showtimeIndex == index then
    return
  end
  local diffNum = index - self.showtimeIndex
  self.showTimeNum = self.showTimeNum + diffNum * 30 * 60 * 1000
  self:RefreshDataByshowTimeNum(true, false)
end

return UINoticeDatePickerView
