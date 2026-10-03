local LWUIWorldTrendView = BaseClass("LWUIWorldTrendView", UIBaseView)
local LWUIDayInfoCell = require("UI.LWUIWorldTrend.Component.LWUIDayInfoCell")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local info_btn_path = "panel/safeArea/TopBar/InfoBtn"

function LWUIWorldTrendView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWUIWorldTrendView:ComponentDefine()
  self.eventTopList = self:AddComponent(UIScrollView, "panel/safeArea/evenToptList")
  self.eventList = self:AddComponent(UIScrollView, "panel/safeArea/eventList")
  self.backBtn = self:AddComponent(UIButton, "BtnBackWhite")
  self.comicBtn = self:AddComponent(UIButton, "panel/safeArea/TopBar/ComicBtn")
  self.comicRedPoint = self:AddComponent(UIBaseContainer, "panel/safeArea/TopBar/ComicBtn/RedPoint")
  self.eventTriggerN = self:AddComponent(UIEventTrigger, "panel/safeArea/eventList/Viewport/Content")
  self.titleText = self:AddComponent(UIText, "panel/safeArea/TopBar/TextTitle")
  self.dayText = self:AddComponent(UIText, "panel/safeArea/ImageTitleBg/Text")
  self.safeAreaContainer = self:AddComponent(UIBaseContainer, "panel/safeArea")
  self.endRoot = self:AddComponent(UIBaseContainer, "panel/EndRoot")
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.arrowBtn = self:AddComponent(UIButton, "panel/BottomBg/ImageArrow")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.comicBtn:SetOnClick(function()
    self:OnComicBtnClick()
  end)
  self.arrowBtn:SetOnClick(function()
    self:OnArrowClick()
  end)
  self.eventList:SetOnItemMoveIn(function(itemObj, index)
    self:OnEventItemCreate(itemObj, index)
  end)
  self.eventList:SetOnValueChanged(function(v2)
    self:OnEventListValueChanged(v2)
  end)
  self.eventList:SetOnItemMoveOut(function(itemObj, index)
    self:DeleteCell(itemObj, self.eventList, LWUIDayInfoCell)
  end)
  self.eventTriggerN:OnEndDrag(function(eventData)
    self.eventListIsDrag = false
    self.eventList:OnEndDrag(eventData)
  end)
  self.eventTriggerN:OnBeginDrag(function(eventData)
    self.eventListIsDrag = true
    self.eventList:OnBeginDrag(eventData)
  end)
  self.eventTriggerN:OnDrag(function(eventData)
    self.isTopClick = false
    self.eventList:OnDrag(eventData)
  end)
  self.info_btn:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString("world_trends_event_rule_title"), nil, Localization:GetString("world_trends_event_rule_desc"))
  end)
end

function LWUIWorldTrendView:OnBackBtnClick()
  self.ctrl.CloseSelf()
end

function LWUIWorldTrendView:OnComicBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWComic, {anim = false}, -1)
end

function LWUIWorldTrendView:OnArrowClick()
  self.eventList:RefillCellsFromEnd()
end

function LWUIWorldTrendView:OnEventListValueChanged(v2)
  if not self.isTopClick then
    local index
    if v2.y < 0.5 then
      index = math.floor(#self.eventListData * v2.y + 1)
    else
      index = math.floor(#self.eventListData * v2.y)
    end
    local data = self.eventListData[index]
    if data then
      local index = self.ctrl.GetDayIndex(data.id)
      if self.topIndex ~= index then
        self:SetDayTop(data.id)
      end
    end
  end
  if self.isTopClick then
    self.isTopClick = false
  end
  if 1 <= self.eventList:GetVerticalNormalizedPosition() and self.arrowBtn:GetActive() then
    self.arrowBtn:SetActive(false)
  elseif 1 > self.eventList:GetVerticalNormalizedPosition() and self.arrowBtn:GetActive() == false then
    self.arrowBtn:SetActive(true)
  end
end

function LWUIWorldTrendView:OnEventItemCreate(itemObj, index)
  itemObj.name = tostring(index .. self.eventListData[index].startDay)
  local item
  item = self.eventList:AddComponent(LWUIDayInfoCell, itemObj)
  item:ReInit(self.eventListData[index], index)
end

function LWUIWorldTrendView:SetDayTop(id)
  local index = self.ctrl.GetDayIndex(id)
  if self.topIndex == index then
    return
  end
  self.topIndex = index
  EventManager:GetInstance():Broadcast(EventId.WorldTrendClickDayTop)
end

function LWUIWorldTrendView:SetEventByDay(day, season)
  local index = self.ctrl.GetIndexByDay(day, season) or 1
  self.isTopClick = true
  if #self.eventListData > 0 then
    local scrollToIndex = index <= 2 and index or index - 1
    self.eventList:RefillCells(scrollToIndex)
  end
  self.topIndex = index
  EventManager:GetInstance():Broadcast(EventId.WorldTrendClickDayTop)
end

function LWUIWorldTrendView:DeleteCell(itemObj, component, class)
  component:RemoveComponent(itemObj.name, class)
end

function LWUIWorldTrendView:ComponentDestroy()
  self:ClearScroll(self.eventList, LWUIDayInfoCell)
  self.eventTopList = nil
  self.eventList = nil
  self.backBtn = nil
  self.eventTriggerN = nil
  self.backBtn = nil
  self.comicBtn = nil
  self.comicRedPoint = nil
  self.dayText = nil
  self.arrowBtn = nil
end

function LWUIWorldTrendView:ClearScroll(component, class)
  component:ClearCells()
  component:RemoveComponents(class)
end

function LWUIWorldTrendView:ReInit()
  self:RefreshComicRedPoint()
  self:RefreshComicBtn()
  local titleName = self.ctrl.GetTitleName()
  self.titleText:SetLocalText(titleName)
  self.eventListData = self.ctrl.GetAllDayInfoList()
  if self.eventListData and #self.eventListData > 0 then
    local count = #self.eventListData
    self.eventList:SetTotalCount(count)
    self:RefreshEventData()
    self:ReshfTime()
  end
end

function LWUIWorldTrendView:ReshfTime()
  self.dayText:SetText(self.ctrl.GetTitleDays())
end

function LWUIWorldTrendView:OnRefresh()
end

function LWUIWorldTrendView:RefreshEventData()
  local curDay = self.ctrl:GetCurDay()
  self:SetDayTop(curDay.id)
  self:SetEventByDay(curDay.startDay, curDay.seasonId)
end

function LWUIWorldTrendView:RefreshComicBtn()
  local haveReadList = DataCenter.ComicManager:GetAllReadOrArchiveSingleComic(true)
  CS.UIGray.SetGray(self.comicBtn.transform, table.IsEmpty(haveReadList), not table.IsEmpty(haveReadList))
end

function LWUIWorldTrendView:RefreshComicRedPoint()
  self.comicRedPoint:SetActive(DataCenter.ComicManager:IsAnyUnArchiveComic())
end

function LWUIWorldTrendView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIWorldTrendView:OnEnable()
  base.OnEnable(self)
end

function LWUIWorldTrendView:OnDisable()
  base.OnDisable(self)
end

function LWUIWorldTrendView:DataDefine()
end

function LWUIWorldTrendView:DataDestroy()
  self.topIndex = nil
  self.eventListData = nil
  self.eventTopDataList = nil
  self.eventListIsDrag = nil
end

function LWUIWorldTrendView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadNewComic, self.RefreshComicRedPoint)
  self:AddUIListener(EventId.WorldTrendActivitySync, self.OnRefresh)
end

function LWUIWorldTrendView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadNewComic, self.RefreshComicRedPoint)
  self:RemoveUIListener(EventId.WorldTrendActivitySync, self.OnRefresh)
end

return LWUIWorldTrendView
