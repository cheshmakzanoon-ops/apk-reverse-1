local PlayerThumbsUpGloryHeartInfoComponent = BaseClass("PlayerThumbsUpGloryHeartInfoComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local heart_path = "heart"
local gift_path = "gift"
local highFive_path = "highFive"
local heart_text_path = "heartText"
local heart_add_path = "heartAdd"
local ICON_PATH = {
  [PlayerInfoHeartInfoType.ThumbsUp] = "Assets/Main/Scripts/Common/UIExtension/SuperScrollView/Demo/Texture/heart_red_heart.png",
  [PlayerInfoHeartInfoType.HighFive] = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/mjc_lianmeng_jizhang_liaotian_bg03.png"
}

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
  self.heart = self:AddComponent(UIImage, heart_path)
  self.highFive = self:AddComponent(UIImage, highFive_path)
  self.gift = self:AddComponent(UIImage, gift_path)
  self.heart_text = self:AddComponent(UITextMeshProUGUIEx, heart_text_path)
  self.heart_add = self:AddComponent(UITextMeshProUGUIEx, heart_add_path)
end

local function ComponentDestroy(self)
  self.heart = nil
  self.gift = nil
  self.heart_text = nil
  self.heart_add = nil
  self.highFive = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function PlayerThumbsUpGloryHeartInfoComponent:RefreshView(num, diff, giftId, showType)
  if showType == PlayerInfoHeartInfoType.Gift then
    self.gift:SetActive(true)
    self.heart:SetActive(false)
    self.highFive:SetActive(false)
    if giftId ~= nil then
      local goods = DataCenter.GiftSystemManager:GetGiftGoods(giftId)
      local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
      self.gift:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
        if self.gift then
          self.gift:SetNativeSize()
        end
      end)
      self.gift:SetLocalScaleXYZ(minScale, minScale, minScale)
      local nowGoodsNum = DataCenter.GiftSystemManager:GetGiftNum(goods.convert_item)
      num = nowGoodsNum - diff
    end
  elseif showType == PlayerInfoHeartInfoType.ThumbsUp then
    self.gift:SetActive(false)
    self.heart:SetActive(true)
    self.highFive:SetActive(false)
  elseif showType == PlayerInfoHeartInfoType.BirthdayThumbsUp then
    self.gift:SetActive(true)
    self.heart:SetActive(false)
    self.highFive:SetActive(false)
    self.gift:LoadSprite("Assets/Main/Sprites/UI/UIMain/UIMainNew/zyf_zhujiemian_shengri_icon.png")
    self.gift:SetLocalScaleXYZ(1, 1, 1)
  else
    self.gift:SetActive(false)
    self.heart:SetActive(false)
    self.highFive:SetActive(true)
    local icon = ICON_PATH[showType]
    if icon then
      self.highFive:LoadSprite(icon)
      self.highFive:SetNativeSize()
    end
  end
  self.heart_text:SetText(string.GetFormattedSeperatorNum(num))
  if 0 < diff then
    self.heart_add:SetText("+" .. string.GetFormattedSeperatorNum(diff))
  else
    self.heart_add:SetText("")
  end
end

PlayerThumbsUpGloryHeartInfoComponent.OnCreate = OnCreate
PlayerThumbsUpGloryHeartInfoComponent.OnDestroy = OnDestroy
PlayerThumbsUpGloryHeartInfoComponent.OnEnable = OnEnable
PlayerThumbsUpGloryHeartInfoComponent.OnDisable = OnDisable
PlayerThumbsUpGloryHeartInfoComponent.ComponentDefine = ComponentDefine
PlayerThumbsUpGloryHeartInfoComponent.ComponentDestroy = ComponentDestroy
PlayerThumbsUpGloryHeartInfoComponent.DataDefine = DataDefine
PlayerThumbsUpGloryHeartInfoComponent.DataDestroy = DataDestroy
PlayerThumbsUpGloryHeartInfoComponent.OnAddListener = OnAddListener
PlayerThumbsUpGloryHeartInfoComponent.OnRemoveListener = OnRemoveListener
return PlayerThumbsUpGloryHeartInfoComponent
