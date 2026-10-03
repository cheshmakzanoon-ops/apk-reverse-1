local RewardItem = BaseClass("RewardItem", UIBaseContainer)
local base = UIBaseContainer
local item_quality_path = "IconNode/UIGiftItem/clickBtn/ImgQuality"
local item_icon_path = "IconNode/UIGiftItem/clickBtn/ItemIcon"
local name_text_path = "TxtName"
local flag_path = "IconNode/UIGiftItem/clickBtn/FlagGo"
local flag_text_path = "IconNode/UIGiftItem/clickBtn/FlagGo/FlagText"
local num_txt_path = "TxtNum"

local function OnCreate(self)
  base.OnCreate(self)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.flag_rect = self:AddComponent(UIImage, flag_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.num_txet = self:AddComponent(UIText, num_txt_path)
end

local function OnDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.name_text = nil
  self.flag_text = nil
  self.flag_rect = nil
  self.param = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, giftType)
  self.param = data
  self.name_text:SetText(self.param.itemName)
  self.item_quality:LoadSpriteAuto(self.param.itemColor)
  self.item_icon:LoadSpriteAuto(self.param.iconName)
  self.flag_rect:SetActive(self.param.itemFlag)
  if self.param.itemFlag then
    self.flag_text:SetText(self.param.itemFlag)
  end
  if giftType == 1 then
    if self.param.count ~= nil then
      self.num_txet:SetText("x" .. self.param.count)
    end
  elseif giftType == 2 then
    self.num_txet:SetText("x" .. self.param.count)
  end
end

RewardItem.OnCreate = OnCreate
RewardItem.OnDestroy = OnDestroy
RewardItem.OnEnable = OnEnable
RewardItem.OnDisable = OnDisable
RewardItem.RefreshData = RefreshData
return RewardItem
