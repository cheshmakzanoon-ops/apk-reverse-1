local UIPveTriggerItemBuyView = BaseClass("UIPveTriggerItemBuyView", UIBaseView)
local base = UIBaseView
local UIPveTriggerItemBuyCell = require("UI.UIPVE.UIPveTriggerItemBuy.Component.UIPveTriggerItemBuyCell")
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local close_btn_path = "CloseBtn"
local panel_path = "panel"
local trigger_name_path = "Left/NameText"
local trigger_icon_path = "Left/TriggerIcon"
local trigger_desc_path = "Left/DescText"
local trigger_count_path = "Left/CountText"
local cost_btn_path = "Left/CostBtn"
local cost_btn_text_path = "Left/CostBtn/btnTxt2"
local info_path = "Left/Info"
local soldier_level_bg_path = "Left/SoldierLevelBg"
local soldier_level_path = "Left/SoldierLevelBg/SoldierLevel"
local hero_info_path = "Left/HeroInfo"
local hero_cell_path = "Left/HeroInfo/UIHeroCellBig"
local hero_attack_path = "Left/HeroInfo/Attack/AttackVal"
local hero_defence_path = "Left/HeroInfo/Defence/DefenceVal"
local hero_army_path = "Left/HeroInfo/Army/ArmyVal"
local scroll_path = "ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, panel_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.trigger_name = self:AddComponent(UIText, trigger_name_path)
  self.trigger_icon = self:AddComponent(UIImage, trigger_icon_path)
  self.trigger_desc = self:AddComponent(UIText, trigger_desc_path)
  self.trigger_count = self:AddComponent(UIText, trigger_count_path)
  self.cost_btn = self:AddComponent(UIButton, cost_btn_path)
  self.cost_btn_text = self:AddComponent(UIText, cost_btn_text_path)
  self.cost_btn:SetOnClick(function()
    self:OnCostClick()
  end)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.soldier_level_bg_go = self:AddComponent(UIBaseContainer, soldier_level_bg_path)
  self.soldier_level_text = self:AddComponent(UIText, soldier_level_path)
  self.hero_info_go = self:AddComponent(UIBaseContainer, hero_info_path)
  self.hero_cell = self:AddComponent(UIHeroCellBig, hero_cell_path)
  self.hero_attack_text = self:AddComponent(UIText, hero_attack_path)
  self.hero_defence_text = self:AddComponent(UIText, hero_defence_path)
  self.hero_army_text = self:AddComponent(UIText, hero_army_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.data = self:GetUserData()
  self.hasListener = false
end

local function DataDestroy(self)
  self.hasListener = false
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self.hasListener = true
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.PayTriggerResItemBack, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.hasListener == true then
    self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
    self:RemoveUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
    self:RemoveUIListener(EventId.PayTriggerResItemBack, self.OnResOrItemUpdate)
    self:RemoveUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  end
end

local function ReInit(self)
  self:Refresh()
end

local function OnResOrItemUpdate(self)
  self:Refresh()
end

local function OnCostClick(self)
end

local function OnInfoClick(self)
  if self.panelData.onInfoClick then
    self.panelData.onInfoClick()
  end
end

local function Refresh(self)
  self:ClearScroll()
  self.panelData = self.ctrl:GetPanelData(self.data)
  self.showDatalist = self.panelData.list
  if self.panelData.isAllDone then
    DataCenter.BattleLevel:DoTriggerAnimation(self.data, 1)
    self.data:DestroyBubble()
    self.data:CheckDoTrigger()
    self.ctrl:CloseSelf()
    return
  end
  if not string.IsNullOrEmpty(self.panelData.soldierLevel) then
    self.soldier_level_bg_go:SetActive(true)
    self.soldier_level_text:SetText(self.panelData.soldierLevel)
  else
    self.soldier_level_bg_go:SetActive(false)
  end
  self:RefreshTriggerInfo()
  self.ScrollView:SetTotalCount(#self.showDatalist)
  self.ScrollView:RefillCells()
end

local function RefreshTriggerInfo(self)
  self.trigger_name:SetLocalText(self.panelData.name)
  if self.panelData.desc ~= nil then
    self.trigger_desc:SetLocalText(self.panelData.desc)
    self.trigger_desc:SetActive(true)
  else
    self.trigger_desc:SetActive(false)
  end
  if self.panelData.count ~= nil then
    self.trigger_count:SetText("x" .. self.panelData.count)
    self.trigger_count:SetActive(true)
  else
    self.trigger_count:SetActive(false)
  end
  if self.panelData.icon ~= nil then
    self.trigger_icon:LoadSprite(self.panelData.icon)
    self.trigger_icon:SetActive(true)
  else
    self.trigger_icon:SetActive(false)
  end
  if self.panelData.onInfoClick then
    self.info_btn:SetActive(true)
  else
    self.info_btn:SetActive(false)
  end
  local heroData = self.panelData.heroData
  if heroData ~= nil then
    self.hero_cell:InitWithConfigId(heroData.heroId, heroData.quality, heroData.level)
    self.hero_attack_text:SetText(Mathf.Round(heroData.atk))
    self.hero_defence_text:SetText(Mathf.Round(heroData.def))
    self.hero_army_text:SetText(Mathf.Round(heroData.army))
    self.hero_info_go:SetActive(true)
  else
    self.hero_info_go:SetActive(false)
  end
  self.cost_btn:SetActive(false)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIPveTriggerItemBuyCell)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIPveTriggerItemBuyCell, itemObj)
  cellItem:ReInit(self.showDatalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIPveTriggerItemBuyCell)
end

UIPveTriggerItemBuyView.OnCreate = OnCreate
UIPveTriggerItemBuyView.OnDestroy = OnDestroy
UIPveTriggerItemBuyView.ComponentDefine = ComponentDefine
UIPveTriggerItemBuyView.ComponentDestroy = ComponentDestroy
UIPveTriggerItemBuyView.DataDefine = DataDefine
UIPveTriggerItemBuyView.DataDestroy = DataDestroy
UIPveTriggerItemBuyView.OnEnable = OnEnable
UIPveTriggerItemBuyView.OnDisable = OnDisable
UIPveTriggerItemBuyView.OnAddListener = OnAddListener
UIPveTriggerItemBuyView.OnRemoveListener = OnRemoveListener
UIPveTriggerItemBuyView.ReInit = ReInit
UIPveTriggerItemBuyView.OnResOrItemUpdate = OnResOrItemUpdate
UIPveTriggerItemBuyView.Refresh = Refresh
UIPveTriggerItemBuyView.ClearScroll = ClearScroll
UIPveTriggerItemBuyView.OnItemMoveIn = OnItemMoveIn
UIPveTriggerItemBuyView.OnItemMoveOut = OnItemMoveOut
UIPveTriggerItemBuyView.OnCostClick = OnCostClick
UIPveTriggerItemBuyView.OnInfoClick = OnInfoClick
UIPveTriggerItemBuyView.RefreshTriggerInfo = RefreshTriggerInfo
return UIPveTriggerItemBuyView
