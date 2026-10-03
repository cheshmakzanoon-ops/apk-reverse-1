local UIAllianceStarOrderTimePopView = BaseClass("UIAllianceStarOrderTimePopView", UIBaseView)
local DiffItem = require("UI.UIAllianceStarOrderTimePop.Component.UIAllianceStarOrderTimeItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearHourSelectLoopView()
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
  self.btnClose = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "safeArea/Common_img_title/titleText")
  self.textServerTimeTip = self:AddComponent(UIText, "safeArea/WihteImage/ServerTimeTipText")
  self.textTime = self:AddComponent(UIText, "safeArea/WihteImage/TimeText")
  self.loopListViewTimeSelectScrollView = self:AddComponent(UILoopListView2, "safeArea/WihteImage/TimeImage/TimeSelectScrollView")
  self.loopListViewTimeSelectScrollContent = self:AddComponent(UIBaseContainer, "safeArea/WihteImage/TimeImage/TimeSelectScrollView/Viewport/TimeSelectScrollContent")
  self.textLocalTimeTip = self:AddComponent(UIText, "safeArea/WihteImage/LocalTimeBg/LocalTimeTipText")
  self.textLocalTime = self:AddComponent(UIText, "safeArea/WihteImage/LocalTimeBg/LocalTimeText")
  self.textCDTipTxt = self:AddComponent(UIText, "safeArea/CDTipTxt")
  self.btnGo = self:AddComponent(UIButton, "safeArea/BtnGo")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textBtnTxt = self:AddComponent(UIText, "safeArea/BtnGo/btnTxt")
  self.loopListViewTimeSelectScrollView:InitListView(0, function(listView, index)
    return self:OnGetTimeItemByIndex(listView, index)
  end)
  self.loopListViewTimeSelectScrollView:SetOnSnapNearestChanged(function(listView, item)
    self:OnTimeItemSnapNearestChanged(listView, item)
  end)
  self.textTitle:SetLocalText("alliance_weeklyStar_title_setTime")
  self.textServerTimeTip:SetLocalText("alliance_weeklyStar_title_serverTime")
  self.textTime:SetLocalText("alliance_weeklyStar_title_clock")
  self.textLocalTimeTip:SetLocalText("alliance_weeklyStar_title_localTime")
  self.textBtnTxt:SetLocalText("alliance_weeklyStar_confirm")
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.textTitle = nil
  self.textServerTimeTip = nil
  self.textTime = nil
  self.loopListViewTimeSelectScrollView = nil
  self.loopListViewTimeSelectScrollContent = nil
  self.textLocalTimeTip = nil
  self.textLocalTime = nil
  self.textCDTipTxt = nil
  self.btnGo = nil
  self.textBtnTxt = nil
end

local function DataDefine(self)
  self.curSelectHourIndex = 0
  self.dateItemIndex = 0
  self.curSelectHour = nil
  self.lastSelectHour = -1
  self.planTimeStamp = 0
  self:InitHourList()
  self:SetLocalTime()
  self:Update1000MS()
end

local function DataDestroy(self)
  self.curSelectHourIndex = nil
  self.dateItemIndex = nil
  self.curSelectHour = nil
  self.lastSelectHour = nil
  self.planTimeStamp = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarCeremonyInfoPush, self.OnAllianceStarCeremonyInfoPush)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceStarCeremonyInfoPush, self.OnAllianceStarCeremonyInfoPush)
  base.OnRemoveListener(self)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnGoClick(self)
  if self.planCD and self.planCD > 0 then
    UIUtil.ShowTips(Localization:GetString("alliance_weeklyStar_setTime_err4", UITimeManager:GetInstance():MilliSecondToFmtString(self.planCD)))
  else
    if 0 < self.planTimeStamp then
      SFSNetwork.SendMessage(MsgDefines.AllianceStarCeremonySetPlan, self.planTimeStamp * 1000)
    end
    self.ctrl:CloseSelf()
  end
end

local function InitHourList(self)
  local time = DataCenter.AllianceStarManager.planTimeStamp
  self.serverHour = 0
  if 0 < time then
    local timeDate = UITimeManager:GetInstance():TimeSecToServerDate(time / 1000)
    self.serverHour = timeDate.hour
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  curTime = UITimeManager:GetInstance():TimeStampToServerDate(curTime)
  local startHour = curTime.hour + 1
  self.hourList = {}
  for i = startHour, 23 do
    table.insert(self.hourList, i)
  end
  if self.serverHour >= 0 then
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
      if self.lastSelectHour and v == self.lastSelectHour then
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
    self.loopListViewTimeSelectScrollView:SetListItemCount(count, false, false)
    self.loopListViewTimeSelectScrollView:RefreshAllShownItem()
    self.loopListViewTimeSelectScrollView:MovePanelToItemIndex(self.curSelectHourIndex - 1, 0)
  end
end

local function OnGetTimeItemByIndex(self, loopScroll, index)
  local count = table.count(self.hourList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("HourItem")
  local script = self.loopListViewTimeSelectScrollContent:GetComponent(item.gameObject.name, DiffItem)
  if script == nil then
    local objectName = tostring(self.dateItemIndex)
    self.dateItemIndex = self.dateItemIndex + 1
    item.gameObject.name = objectName
    script = self.loopListViewTimeSelectScrollContent:AddComponent(DiffItem, objectName)
  end
  script:SetActive(true)
  local hour = self.hourList[index]
  local isSelect = hour == self.curSelectHour
  script:SetHourData(hour, isSelect)
  return item
end

local function OnTimeItemSnapNearestChanged(self, loopScroll, item)
  self.curSelectHourIndex = item.ItemIndex + 1
  self.curSelectHour = self.hourList[self.curSelectHourIndex]
  self.lastSelectHour = self.curSelectHour
  self:SetLocalTime()
  EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushSelectPopHour, self.curSelectHour)
end

local function SetLocalTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curZeroTimeStamp = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime // 1000)
  self.planTimeStamp = curZeroTimeStamp + self.curSelectHour * 60 * 60
  local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(self.planTimeStamp * 1000)
  self.textLocalTime:SetText(localTime)
end

local function ClearHourSelectLoopView(self)
  self.loopListViewTimeSelectScrollView:RemoveComponents(DiffItem)
  self.loopListViewTimeSelectScrollView:ClearAllItems()
end

local function OnAllianceStarCeremonyInfoPush(self)
  local ceremonyInfo = DataCenter.AllianceStarManager.ceremonyInfo
  if ceremonyInfo and ceremonyInfo.stateId ~= -1 then
    self.ctrl:CloseSelf()
  end
end

local function Update1000MS(self)
  if DataCenter.AllianceStarManager.planChangedTimeStamp then
    local diff = DataCenter.AllianceStarManager:GetChangePlanCD() * 1000 - (UITimeManager:GetInstance():GetServerTime() - DataCenter.AllianceStarManager.planChangedTimeStamp)
    if 0 < diff then
      self.textCDTipTxt:SetActive(true)
      self.textCDTipTxt:SetLocalText("alliance_weeklyStar_setTime_cd", UITimeManager:GetInstance():MilliSecondToFmtString(diff))
    else
      self.textCDTipTxt:SetActive(true)
      self.textCDTipTxt:SetLocalText("alliance_weeklyStar_setTime_cd0", DataCenter.AllianceStarManager:GetChangePlanCD() / 60)
    end
    self.planCD = diff
  end
end

UIAllianceStarOrderTimePopView.OnCreate = OnCreate
UIAllianceStarOrderTimePopView.OnDestroy = OnDestroy
UIAllianceStarOrderTimePopView.OnEnable = OnEnable
UIAllianceStarOrderTimePopView.OnDisable = OnDisable
UIAllianceStarOrderTimePopView.ComponentDefine = ComponentDefine
UIAllianceStarOrderTimePopView.ComponentDestroy = ComponentDestroy
UIAllianceStarOrderTimePopView.DataDefine = DataDefine
UIAllianceStarOrderTimePopView.DataDestroy = DataDestroy
UIAllianceStarOrderTimePopView.OnAddListener = OnAddListener
UIAllianceStarOrderTimePopView.OnRemoveListener = OnRemoveListener
UIAllianceStarOrderTimePopView.OnBtnCloseClick = OnBtnCloseClick
UIAllianceStarOrderTimePopView.OnBtnGoClick = OnBtnGoClick
UIAllianceStarOrderTimePopView.OnGetTimeItemByIndex = OnGetTimeItemByIndex
UIAllianceStarOrderTimePopView.OnTimeItemSnapNearestChanged = OnTimeItemSnapNearestChanged
UIAllianceStarOrderTimePopView.SetLocalTime = SetLocalTime
UIAllianceStarOrderTimePopView.InitHourList = InitHourList
UIAllianceStarOrderTimePopView.ClearHourSelectLoopView = ClearHourSelectLoopView
UIAllianceStarOrderTimePopView.OnAllianceStarCeremonyInfoPush = OnAllianceStarCeremonyInfoPush
UIAllianceStarOrderTimePopView.Update1000MS = Update1000MS
return UIAllianceStarOrderTimePopView
