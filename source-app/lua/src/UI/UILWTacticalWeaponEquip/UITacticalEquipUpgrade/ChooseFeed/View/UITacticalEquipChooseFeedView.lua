local UITacticalEquipChooseFeedView = BaseClass("UITacticalEquipChooseFeedView", UIBaseView)
local TacticalEquipItemWithNum = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipItemWithNum")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
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
  self.textFillProgress = self:AddComponent(UITextMeshProUGUIEx, "Root/fillProgressText")
  self.textUsePropsTip = self:AddComponent(UITextMeshProUGUIEx, "Root/propsNode/usePropsTip")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "Root/propsNode/ItemHolder")
  self.compItemContent = self:AddComponent(UIBaseContainer, "Root/propsNode/ItemHolder/Viewport/ItemContent")
  self.btnGetMore = self:AddComponent(UIButton, "Root/getMoreBtn")
  self.btnGetMore:SetOnClick(function()
    self:OnBtnGetMoreClick()
  end)
  self.btnConfirm = self:AddComponent(UIButton, "Root/confirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.clickCallback = BindCallback(self, self.OnEquipItemClick)
  self.longPressCallback = BindCallback(self, self.OnEquipItemLongPress)
  self.pointerUpCallback = BindCallback(self, self.OnEquipItemPointerUp)
  self.unsetClickCallback = BindCallback(self, self.OnUnsetClick)
  self.unsetLongPressCallback = BindCallback(self, self.OnUnsetLongPressStart)
  self.unsetPointerUpCallback = BindCallback(self, self.OnUnsetPointerUp)
  self.beginDragCallback = BindCallback(self, self.OnBeginDrag)
  self.endDragCallback = BindCallback(self, self.OnEndDrag)
  self.dragCallback = BindCallback(self, self.OnDrag)
end

local function ComponentDestroy(self)
  if self.compItemContent then
    self.compItemContent:RemoveComponents(TacticalEquipItemWithNum)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.textFillProgress = nil
  self.textUsePropsTip = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.btnGetMore = nil
  self.btnConfirm = nil
  self.btnClose = nil
  self.btnPanel = nil
end

local function DataDefine(self)
  self.feedMap = {}
end

local function DataDestroy(self)
  self.feedMap = nil
  self.clickCallback = nil
  self.longPressCallback = nil
  self.pointerUpCallback = nil
  self.unsetClickCallback = nil
  self.unsetLongPressCallback = nil
  self.unsetPointerUpCallback = nil
  self.beginDragCallback = nil
  self.endDragCallback = nil
  self.dragCallback = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CommonEquipDataChanged, self.OnDataUpChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.CommonEquipDataChanged, self.OnDataUpChanged)
  base.OnRemoveListener(self)
end

function UITacticalEquipChooseFeedView:ReInit()
  self.curEquipData, self.slot = self:GetUserData()
  self:RefreshOwnList()
  self:UpdateExpValue()
end

function UITacticalEquipChooseFeedView:OnDataUpChanged()
  if self.curEquipData == nil or self.slot == nil then
    return
  end
  self:RefreshOwnList()
  self:UpdateExpValue()
end

function UITacticalEquipChooseFeedView:RefreshOwnList()
  self.feedList, self.cacheExp = DataCenter.CommonEquipDataManager:GetEquipFeedList(self.slot)
  local hasFeed = self.feedList and #self.feedList > 0
  if hasFeed then
    self.loopGridViewItemHolder:SetListItemCount(#self.feedList)
    self.loopGridViewItemHolder:RefreshAllShownItem()
    for i, v in ipairs(self.feedList) do
      self.feedMap[v.equip.cfgId] = v
    end
  end
  self.loopGridViewItemHolder:SetActive(hasFeed)
end

function UITacticalEquipChooseFeedView:OnLongPressTimer()
  if self.startLongPress and self.longPressItem and self.longPressItemInfo then
    if self.addSpeed > 0 then
      self:OnAddFeed(self.longPressItem, self.longPressItemInfo)
    elseif self.addSpeed < 0 then
      self:OnSubFeed(self.longPressItem, self.longPressItemInfo)
    end
  end
end

function UITacticalEquipChooseFeedView:OnGetItemByRowColumn(loopScroll, index)
  if self.feedList ~= nil then
    local count = #self.feedList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalEquipItemWithNum")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TacticalEquipItemWithNum)
    if script == nil then
      local name = "props_" .. index
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TacticalEquipItemWithNum, name)
      script:SetOnClick(self.clickCallback)
      script:SetOnLongPress(self.longPressCallback)
      script:SetOnPointerUp(self.pointerUpCallback)
      script:SetOnUnsetClick(self.unsetClickCallback)
      script:SetOnUnsetLongPress(self.unsetLongPressCallback)
      script:SetOnUnsetPointerUp(self.unsetPointerUpCallback)
      script:SetOnBeginDrag(self.beginDragCallback)
      script:SetOnEndDrag(self.endDragCallback)
      script:SetOnDrag(self.dragCallback)
    end
    script:SetActive(true)
    local data = self.feedList[index]
    script:SetData(data)
    return item
  end
end

function UITacticalEquipChooseFeedView:OnAddFeed(item, feedData)
  local num = math.min(feedData.useNum + 1, feedData.equip.num)
  local delta = num - feedData.useNum
  self.feedMap[feedData.equip.cfgId].useNum = num
  self.cacheExp = self.cacheExp + feedData.equip.config.growth_value * delta
  self:UpdateExpValue()
  item:SetSelectNumber(num)
  if feedData.useNum >= feedData.equip.num and self.startLongPress then
    self:RemoveLongPressTimer()
  end
end

function UITacticalEquipChooseFeedView:OnSubFeed(item, feedData)
  local num = math.max(feedData.useNum - 1, 0)
  local delta = num - feedData.useNum
  self.feedMap[feedData.equip.cfgId].useNum = num
  self.cacheExp = self.cacheExp + feedData.equip.config.growth_value * delta
  self:UpdateExpValue()
  item:SetSelectNumber(num)
  if feedData.useNum <= 0 and self.startLongPress then
    self:RemoveLongPressTimer()
  end
end

local GREEN_NUM_FORMAT = " <color=#68F37F>+%s</color> "

function UITacticalEquipChooseFeedView:UpdateExpValue()
  if self.cacheExp > 0 then
    local addExpStr = string.format(GREEN_NUM_FORMAT, self.cacheExp)
    self.textFillProgress:SetLocalText("squad_equip_research_desc_4", self:GetCurExp(), addExpStr, self:GetUpgradeNeedExp())
  else
    self.textFillProgress:SetLocalText("squad_equip_research_desc_4", self:GetCurExp(), "", self:GetUpgradeNeedExp())
  end
end

function UITacticalEquipChooseFeedView:GetCurExp()
  return self.curEquipData.exp
end

function UITacticalEquipChooseFeedView:GetUpgradeNeedExp()
  return self.curEquipData.config.upgrade_value
end

function UITacticalEquipChooseFeedView:OnEquipItemClick(item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
    return
  end
  self:OnAddFeed(item, itemInfo)
end

function UITacticalEquipChooseFeedView:OnEquipItemLongPress(item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
  end
  self.startLongPress = true
  self.longPressItemInfo = itemInfo
  self.longPressItem = item
  self:AddLongPressTimer()
  self.addSpeed = 1
end

function UITacticalEquipChooseFeedView:OnEquipItemPointerUp(item, itemInfo)
  if not itemInfo then
    return
  end
  self:RemoveLongPressTimer(self)
end

function UITacticalEquipChooseFeedView:OnUnsetClick(item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
    return
  end
  self:OnSubFeed(item, itemInfo)
end

function UITacticalEquipChooseFeedView:OnUnsetLongPressStart(item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
  end
  self.startLongPress = true
  self.longPressItemInfo = itemInfo
  self.longPressItem = item
  self:AddLongPressTimer()
  self.addSpeed = -1
end

function UITacticalEquipChooseFeedView:OnUnsetPointerUp(item, itemInfo)
  if not itemInfo then
    return
  end
  self:RemoveLongPressTimer(self)
end

function UITacticalEquipChooseFeedView:OnBeginDrag(eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnBeginDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnBeginDrag(eventData)
  end
end

function UITacticalEquipChooseFeedView:OnEndDrag(eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnEndDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnEndDrag(eventData)
  end
end

function UITacticalEquipChooseFeedView:OnDrag(eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnDrag(eventData)
  end
end

function UITacticalEquipChooseFeedView:AddLongPressTimer()
  if self.longPressTimer == nil then
    self.longPressTimer = TimerManager:GetInstance():GetTimer(0.1, function()
      self:OnLongPressTimer()
    end, nil, false, false, false)
  end
  self.longPressTimer:Start()
end

function UITacticalEquipChooseFeedView:RemoveLongPressTimer()
  if self.longPressTimer ~= nil then
    self.longPressTimer:Stop()
    self.longPressTimer = nil
  end
  self.startLongPress = false
  self.longPressItem = nil
  self.longPressItemInfo = nil
  self.addSpeed = 1
end

function UITacticalEquipChooseFeedView:SaveCache()
  local list = {}
  for i, v in pairs(self.feedMap) do
    if v.useNum > 0 then
      table.insert(list, v)
    end
  end
  DataCenter.CommonEquipDataManager:SetEquipResearchCacheFeed(list)
  EventManager:GetInstance():Broadcast(EventId.TacticalEquipSaveFeed)
end

local function OnBtnGetMoreClick(self)
  LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.CommonEquip, 1)
end

local function OnBtnConfirmClick(self)
  self:OnClose()
end

local function OnBtnCloseClick(self)
  self:OnClose()
end

local function OnBtnPanelClick(self)
  self:OnClose()
end

function UITacticalEquipChooseFeedView:OnClose()
  self:SaveCache()
  self.ctrl:CloseSelf()
end

UITacticalEquipChooseFeedView.OnCreate = OnCreate
UITacticalEquipChooseFeedView.OnDestroy = OnDestroy
UITacticalEquipChooseFeedView.OnEnable = OnEnable
UITacticalEquipChooseFeedView.OnDisable = OnDisable
UITacticalEquipChooseFeedView.ComponentDefine = ComponentDefine
UITacticalEquipChooseFeedView.ComponentDestroy = ComponentDestroy
UITacticalEquipChooseFeedView.DataDefine = DataDefine
UITacticalEquipChooseFeedView.DataDestroy = DataDestroy
UITacticalEquipChooseFeedView.OnAddListener = OnAddListener
UITacticalEquipChooseFeedView.OnRemoveListener = OnRemoveListener
UITacticalEquipChooseFeedView.OnBtnGetMoreClick = OnBtnGetMoreClick
UITacticalEquipChooseFeedView.OnBtnConfirmClick = OnBtnConfirmClick
UITacticalEquipChooseFeedView.OnBtnCloseClick = OnBtnCloseClick
UITacticalEquipChooseFeedView.OnBtnPanelClick = OnBtnPanelClick
return UITacticalEquipChooseFeedView
