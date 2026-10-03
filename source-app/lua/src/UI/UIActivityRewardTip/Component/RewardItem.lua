local RewardItem = BaseClass("RewardItem", UIBaseContainer)
local base = UIBaseContainer
local gift_item_path = "IconNode/UIGiftItem"
local item_quality_path = "IconNode/UIGiftItem/clickBtn/ImgQuality"
local item_icon_path = "IconNode/UIGiftItem/clickBtn/ItemIcon"
local imgExtra_path = "IconNode/UIGiftItem/clickBtn/ImgExtra"
local name_text_path = "TxtName"
local flag_text_path = "IconNode/UIGiftItem/clickBtn/FlagGo/FlagText"
local btn_path = "IconNode/UIGiftItem/clickBtn"
local num_txt_path = "IconNode/UIGiftItem/clickBtn/NumText"

local function OnCreate(self)
  base.OnCreate(self)
  self.gift_item = self:AddComponent(UIBaseComponent, gift_item_path)
  self.gift_item:SetActive(true)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.imgExtra = self:AddComponent(UIImage, imgExtra_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.num_txet = self:AddComponent(UIText, num_txt_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function OnDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.imgExtra = nil
  self.name_text = nil
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
  self.name_text:SetText(self.param.name)
  self.item_quality:LoadSprite(self.param.itemColor)
  local getNum = tonumber(self.param.count)
  self.num_txet:SetText(string.GetFormattedStr(getNum))
  self.item_icon:LoadSprite(self.param.iconName)
end

local function OnBtnClick(self)
  if self.param.itemId ~= nil then
    local param = {}
    param.itemId = self.param.itemId
    param.rewardType = self.param.rewardType
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.heroEventPoint then
    local param = {}
    param.itemName = 321081
    param.itemDesc = 321082
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

RewardItem.OnCreate = OnCreate
RewardItem.OnDestroy = OnDestroy
RewardItem.OnEnable = OnEnable
RewardItem.OnDisable = OnDisable
RewardItem.RefreshData = RefreshData
RewardItem.OnBtnClick = OnBtnClick
return RewardItem
