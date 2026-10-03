local TCBagItemComponent = BaseClass("TCBagItemComponent", UIBaseContainer)
local StarListItem = require("UI.LWUITCCardMain.Component.TCStarListItemComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local t_c_card_item_path = "Root/CardHangUp/TCCardItem"
local lv_text_path = "Root/LvText"
local t_c_star_list_item_path = "Root/TCStarListItem"
local root_path = "Root"
local equip_obj_path = "Root/EquipObj"

local function OnCreate(self)
  base.OnCreate(self)
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
  self.lvText = self:AddComponent(UIText, lv_text_path)
  self.starListItem = self:AddComponent(StarListItem, t_c_star_list_item_path)
  self.clickBtn = self:AddComponent(UIButton, root_path)
  self.clickBtn:SetOnClick(function()
    self:OnBeClick()
  end)
  self.equipLabelObj = self:AddComponent(UIBaseContainer, equip_obj_path)
  self.redDot = self:TryAddComponent(UIBaseContainer, "Root/redDot")
  if self.redDot then
    self.redDot:SetActive(false)
  end
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalCardStarUpgrade, self.OnTacticalCardStarUpgrade)
  self:AddUIListener(EventId.TacticalCardOpenBox, self.OnTacticalCardBoxOpen)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TacticalCardStarUpgrade, self.OnTacticalCardStarUpgrade)
  self:RemoveUIListener(EventId.TacticalCardOpenBox, self.OnTacticalCardBoxOpen)
  base.OnRemoveListener(self)
end

function TCBagItemComponent:SetData(cardData)
  if not cardData then
    return
  end
  self.cardData = cardData
  self:RefreshCardItem()
  self:RefreshLv()
  self:RefreshStar()
  self:RefreshEquipLabel()
  self:RefreshStarUpgradeRedDot()
end

function TCBagItemComponent:RefreshCardItem()
  if not self.cardData then
    return
  end
  if not self.cardItem then
    local cardType = self.cardData:GetCardType()
    local _, cls = TacticalCardUtil.GetCardConfigByCardType(cardType)
    self.cardItem = self:AddComponent(require(cls), t_c_card_item_path)
  end
  local displayConfig = {}
  displayConfig.isShowLv = false
  displayConfig.isShowStar = false
  self.cardItem:SetData(self.cardData, displayConfig)
end

function TCBagItemComponent:RefreshLv()
  if not self.cardData then
    return
  end
  self.lvText:SetText(TacticalCardUtil.GetLevelStr(self.cardData))
end

function TCBagItemComponent:RefreshStar()
  if not self.cardData then
    return
  end
  self.starListItem:ReInit(self.cardData.star)
end

function TCBagItemComponent:SetClickFunc(clickFunc)
  self.clickFunc = clickFunc
end

function TCBagItemComponent:OnBeClick()
  if self.clickFunc then
    self.clickFunc(self.cardData)
  end
end

function TCBagItemComponent:RefreshEquipLabel()
  if not self.cardData then
    self.equipLabelObj:SetActive(false)
    return
  end
  self.equipLabelObj:SetActive(self.cardData:IsEquip())
end

function TCBagItemComponent:OnTacticalCardStarUpgrade()
  self:RefreshStarUpgradeRedDot()
end

function TCBagItemComponent:OnTacticalCardBoxOpen()
  self:RefreshStarUpgradeRedDot()
end

function TCBagItemComponent:RefreshStarUpgradeRedDot()
  if not self.cardData then
    return
  end
  local hasRedDot = DataCenter.TacticalCardDataManager:CheckCoreStarUpgrade(self.cardData.cardId)
  if self.redDot then
    self.redDot:SetActive(hasRedDot)
  end
end

TCBagItemComponent.OnCreate = OnCreate
TCBagItemComponent.OnDestroy = OnDestroy
TCBagItemComponent.OnEnable = OnEnable
TCBagItemComponent.OnDisable = OnDisable
TCBagItemComponent.ComponentDefine = ComponentDefine
TCBagItemComponent.ComponentDestroy = ComponentDestroy
TCBagItemComponent.DataDefine = DataDefine
TCBagItemComponent.DataDestroy = DataDestroy
TCBagItemComponent.OnAddListener = OnAddListener
TCBagItemComponent.OnRemoveListener = OnRemoveListener
return TCBagItemComponent
