local AllianceCurShopItem = BaseClass("AllianceCurShopItem", UIBaseContainer)
local base = UIBaseContainer
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local flag_text_path = "clickBtn/FlagGo/FlagText"

local function OnCreate(self)
  base.OnCreate(self)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
end

local function OnDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.flag_text = nil
  self.param = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data)
  self.param = data
  self.item_quality:LoadSprite(self.param.itemColor)
  self.item_icon:LoadSprite(self.param.iconName)
  self.flag_text:SetText(self.param.itemFlag)
end

AllianceCurShopItem.OnCreate = OnCreate
AllianceCurShopItem.OnDestroy = OnDestroy
AllianceCurShopItem.OnEnable = OnEnable
AllianceCurShopItem.OnDisable = OnDisable
AllianceCurShopItem.RefreshData = RefreshData
return AllianceCurShopItem
