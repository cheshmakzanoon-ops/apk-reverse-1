local LWAllianceGiftRewardItem = BaseClass("LWAllianceGiftRewardItem", UIBaseContainer)
local base = UIBaseContainer
local item_quality_path = "ImgQuality"
local item_icon_path = "ItemIcon"
local num_text_path = "NumText"
local name_text_path = "NameText"
local flag_text_path = "FlagText"
local btn_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function OnDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.num_text = nil
  self.name_text = nil
  self.flag_text = nil
  self.btn = nil
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
  self.name_text:SetText(self.param.itemName)
  self.num_text:SetText(self.param.count)
  self.item_quality:LoadSprite(self.param.itemColor)
  self.item_icon:LoadSprite(self.param.iconName)
  self.flag_text:SetText(self.param.itemFlag)
end

local function OnBtnClick(self)
end

LWAllianceGiftRewardItem.OnCreate = OnCreate
LWAllianceGiftRewardItem.OnDestroy = OnDestroy
LWAllianceGiftRewardItem.OnBtnClick = OnBtnClick
LWAllianceGiftRewardItem.OnEnable = OnEnable
LWAllianceGiftRewardItem.OnDisable = OnDisable
LWAllianceGiftRewardItem.RefreshData = RefreshData
return LWAllianceGiftRewardItem
