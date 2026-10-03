local base = UIBaseView
local ActCalendarMain = BaseClass("ActCalendarMain", UIBaseView)
local Localization = CS.GameEntry.Localization
local ActCalendarWeekTab = require("UI.ActCalendar.Component.ActCalendarWeekTab")
local ActCalendarEventGroup = require("UI.ActCalendar.Component.ActCalendarEventGroup")
local CUR_DAY_INDEX = DataCenter.ActCalendarManager.CUR_DAY_INDEX
local WEEK_DAYS = DataCenter.ActCalendarManager.WEEK_DAYS
local FILTER_ICON = "lrb_huodongrili_btn_jianglishaixuan"
local FILTER_ICON_CANCEL = "lrb_huodongrili_btn_jianglishaixuan_qvxiao"

function ActCalendarMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ActCalendarMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActCalendarMain:OnEnable()
  base.OnEnable(self)
  self:DataDefine()
end

function ActCalendarMain:OnDisable()
  self:DataDestroy()
  base.OnDisable(self)
end

function ActCalendarMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgBanner = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textCurDate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compWeekTabLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compEventGroupContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textBottomTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compRewardFilter = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.imgRewardFilterIcon = self.viewSkin:AddComponent(self, UIImage, 7)
  self.btnRewardFilter = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnRewardFilter:SetOnClick(function()
    self:OnBtnRewardFilterClick()
  end)
  self.compEventGroupScrollView = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.weekTabItemList = {}
  local weekTabCount = self.compWeekTabLayout.transform.childCount
  for i = 0, weekTabCount - 1 do
    local childTrans = self.compWeekTabLayout.transform:GetChild(i)
    if childTrans then
      local childName = childTrans.gameObject.name
      local tab = self.compWeekTabLayout:AddComponent(ActCalendarWeekTab, childName)
      tab:SetActive(true)
      table.insert(self.weekTabItemList, tab)
    end
  end
  self.viewSize = self.compEventGroupScrollView.rectTransform.rect.height
end

function ActCalendarMain:ComponentDestroy()
  self.compWeekTabLayout:RemoveComponents(ActCalendarWeekTab)
  self.weekTabItemList = nil
  self.viewSkin = nil
  self.rawImgBanner = nil
  self.textCurDate = nil
  self.compWeekTabLayout = nil
  self.compEventGroupContent = nil
  self.textBottomTips = nil
  self.compRewardFilter = nil
  self.imgRewardFilterIcon = nil
  self.btnRewardFilter = nil
  self.compEventGroupScrollView = nil
end

function ActCalendarMain:DataDefine()
  self.groupContentHeight = 0
end

function ActCalendarMain:DataDestroy()
  self:_clearList()
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self._filterStatus = nil
  self.groupList = nil
  self.activityId = nil
end

function ActCalendarMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActCalendarPropsFilter, self._onFilterStatus)
  self:AddUIListener(EventId.ActCalendarDataUpdate, self._onUpdateData)
end

function ActCalendarMain:OnRemoveListener()
  self:RemoveUIListener(EventId.ActCalendarPropsFilter, self._onFilterStatus)
  self:RemoveUIListener(EventId.ActCalendarDataUpdate, self._onUpdateData)
  base.OnRemoveListener(self)
end

function ActCalendarMain:SetData(activityId)
  self.activityId = activityId
  self:_requestData()
end

function ActCalendarMain:_requestData()
  SFSNetwork.SendMessage(MsgDefines.ActivityCalendarView)
end

function ActCalendarMain:_onFilterStatus(props)
  self._filterStatus = true
  self.groupList = self:_getGroupList(props)
  self:_refreshGroupList(props)
  self:_refreshFilterBtn()
end

function ActCalendarMain:_onUpdateData()
  self._filterStatus = false
  self.groupList = self:_getGroupList()
  self:_refreshGroupList()
  self:_refreshWeekTab()
  self:_refreshBanner()
  self:_refreshFilterBtn()
  self:_setPassDayTimer()
end

function ActCalendarMain:_onPassDay()
  self:_requestData()
end

function ActCalendarMain:Update1000MS()
  self:_updateCurTimeShow()
end

function ActCalendarMain:_updateCurTimeShow()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local x, y, z, hour, min, sec = UITimeManager:GetInstance():GetServerDate(curTime)
  local timeFormat = string.format("%d-%d-%d %02d:%02d:%02d", x, y, z, hour, min, sec)
  self.textCurDate:SetText(timeFormat)
end

function ActCalendarMain:_refreshWeekTab()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local nowIndex = UITimeManager:GetInstance():GetWeekdayIndex(serverTime)
  local startDay = nowIndex - (CUR_DAY_INDEX - 1)
  if startDay <= 0 then
    startDay = startDay + 7
  end
  local endDay = nowIndex + WEEK_DAYS - CUR_DAY_INDEX
  if 7 < endDay then
    endDay = endDay - 7
  end
  local index = 1
  for i = 1, WEEK_DAYS do
    local day = startDay + (i - 1)
    if 7 < day then
      day = day - 7
    end
    local date = serverTime + (index - CUR_DAY_INDEX) * 24 * 60 * 60 * 1000
    self.weekTabItemList[index]:ReInit(WeekDayNameByIndex[day], date)
    index = index + 1
  end
end

function ActCalendarMain:_refreshBanner()
  local bannerFullName = DataCenter.ActCalendarManager:GetBanner()
  self.rawImgBanner:LoadSpriteAsync(bannerFullName)
end

function ActCalendarMain:_refreshFilterBtn()
  local iconFullName
  if self._filterStatus then
    iconFullName = string.format(LoadPath.ActCalendar, FILTER_ICON_CANCEL)
  else
    iconFullName = string.format(LoadPath.ActCalendar, FILTER_ICON)
  end
  self.imgRewardFilterIcon:LoadSpriteAsync(iconFullName)
end

function ActCalendarMain:_refreshGroupList(props)
  self:_clearList()
  self.groupItemReqs = {}
  if self.groupList then
    for i, v in ipairs(self.groupList) do
      table.insert(self.groupItemReqs, self:_createEventGroup(v, i, props))
    end
  end
end

function ActCalendarMain:_setEventContentHeight(deltaHeight)
  if not self.groupContentHeight then
    self.groupContentHeight = 0
  end
  self.groupContentHeight = self.groupContentHeight + deltaHeight
  self.compEventGroupContent:SetSizeDeltaY(self.groupContentHeight)
end

function ActCalendarMain:_createEventGroup(data, index, props)
  return self:GameObjectInstantiateAsync(UIAssets.ActCalendarEventGroup, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local name = "calendarGroup_" .. index
    go.name = name
    go.transform:SetParent(self.compEventGroupContent.transform)
    local cell = self.compEventGroupContent:AddComponent(ActCalendarEventGroup, name)
    cell:SetLocalScaleXYZ(1, 1, 1)
    cell:SetData(data, props, function(deltaHeight)
      self:_setEventContentHeight(deltaHeight)
      self:_moveViewToGroupTop(cell)
    end)
    self:_setEventContentHeight(cell:GetHeight())
  end)
end

function ActCalendarMain:_moveViewToGroupTop(cell)
  if not cell then
    return
  end
  local posY = math.abs(cell:GetAnchoredPositionY())
  local height = self.compEventGroupContent.rectTransform.rect.height
  local x = self.compEventGroupContent:GetAnchoredPositionX()
  local delta = height - posY
  local targetPosY
  if delta >= self.viewSize then
    targetPosY = posY
  elseif height < self.viewSize then
    targetPosY = 0
  else
    targetPosY = height - self.viewSize
  end
  self.compEventGroupContent:SetAnchoredPositionXY(x, targetPosY)
end

function ActCalendarMain:_getGroupList(propsFilter)
  if propsFilter then
    return DataCenter.ActCalendarManager:GetGroupDataSortListByProps(propsFilter)
  else
    return DataCenter.ActCalendarManager:GetGroupDataSortList()
  end
end

function ActCalendarMain:_clearList()
  self.compEventGroupContent:RemoveComponents(ActCalendarEventGroup)
  if self.groupItemReqs then
    for i, v in ipairs(self.groupItemReqs) do
      if v then
        v:Destroy()
      end
    end
  end
  self.groupItemReqs = nil
  self.groupContentHeight = 0
end

function ActCalendarMain:OnBtnRewardFilterClick()
  if self._filterStatus then
    self:_onUpdateData()
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCalendarRewardFilter, {anim = true})
  end
end

function ActCalendarMain:_setPassDayTimer()
  if self.passDayTimer then
    self.passDayTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  self.passDayTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    self:_onPassDay()
  end, remainTimeS)
end

function ActCalendarMain:_refreshContentSize()
end

return ActCalendarMain
