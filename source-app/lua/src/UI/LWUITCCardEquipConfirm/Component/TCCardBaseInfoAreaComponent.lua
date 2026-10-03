local TCCardBaseInfoAreaComponent = BaseClass("TCCardBaseInfoAreaComponent", UIBaseContainer)
local StarListItem = require("UI.LWUITCCardMain.Component.TCStarListItemComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local quality_bar_img_path = "QualityBarImg"
local card_item_hang_up_point_path = "CardItemHangUpPoint"
local card_name_text_path = "CardNameText"
local power_layout_path = "PowerLayout"
local card_power_text_path = "PowerLayout/CardPowerText"
local t_c_star_list_item_path = "TCStarListItem"
local card_lv_text_path = "CardLvText"
local type_quality_icon_img_path = "CardType/TypeQualityIconImg"
local type_icon_img_path = "CardType/TypeIconImg"
local change_arr_img_path = "PowerLayout/ChangeArrImg"
local card_type_path = "CardType"

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
  self.cardHangUp = self:AddComponent(UIBaseContainer, card_item_hang_up_point_path)
  self.qualityImg = self:AddComponent(UIImage, quality_bar_img_path)
  self.nameText = self:AddComponent(UIText, card_name_text_path)
  self.powerRoot = self:AddComponent(UIBaseContainer, power_layout_path)
  self.powerText = self:AddComponent(UIText, card_power_text_path)
  self.starListItem = self:AddComponent(StarListItem, t_c_star_list_item_path)
  self.lvText = self:AddComponent(UIText, card_lv_text_path)
  self.cardTypeQualityIconImg = self:AddComponent(UIImage, type_quality_icon_img_path)
  self.cardTypeIconImg = self:AddComponent(UIImage, type_icon_img_path)
  self.powerChangeArrImg = self:AddComponent(UIImage, change_arr_img_path)
  self.cardTypeObj = self:AddComponent(UIBaseContainer, card_type_path)
end

local function ComponentDestroy(self)
  self:ClearCardItem()
  self.loadCardReq = nil
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

function TCCardBaseInfoAreaComponent:SetData(cardData, powerChangeSign)
  if not cardData then
    return
  end
  self.cardData = cardData
  local cardQuality = TacticalCardQualityType.White
  if self.cardData.template then
    cardQuality = self.cardData.template.color
  end
  self:RefreshBaseInfo()
  self:GenCardItem()
  self:RefreshStarList()
  self:RefreshAboutQuality(cardQuality)
  self:RefreshPowerChangeInfo(powerChangeSign)
end

function TCCardBaseInfoAreaComponent:RefreshBaseInfo()
  self.nameText:SetText(TacticalCardUtil.GetCardFullNameStr(self.cardData))
  self.lvText:SetText(TacticalCardUtil.GetLevelStr(self.cardData))
  local cardPower = self.cardData:GetPower() or 0
  self.powerText:SetText(string.GetFormattedSeperatorNum(cardPower))
  local cardType = self.cardData:GetCardType()
  local isShowCardTypeIcon = cardType ~= TacticalCardType.Core
  self.cardTypeObj:SetActive(isShowCardTypeIcon)
  if isShowCardTypeIcon then
    local cardTypeIconPath = TacticalCardUtil.GetSlotTypeIconPath(cardType)
    self.cardTypeIconImg:LoadSprite(cardTypeIconPath)
  end
end

function TCCardBaseInfoAreaComponent:RefreshAboutQuality(quality)
  local barImgPath = TacticalCardUtil.GetCardQualityColorBarImgPath(quality)
  self.qualityImg:LoadSprite(barImgPath)
  local qualityColorHex = TacticalCardUtil.GetQualityColorHex(quality)
  local color = Color.FromHex(qualityColorHex)
  self.cardTypeQualityIconImg:SetColor(color)
end

function TCCardBaseInfoAreaComponent:GenCardItem()
  self:ClearCardItem()
  self.loadCardReq = TacticalCardUtil.CreateOneCardItem(self, self.cardData.cardType, self.cardHangUp, function(cardItem)
    self.cardItem = cardItem
    local displayConfig = {}
    displayConfig.isShowLv = false
    displayConfig.isShowStar = false
    self.cardItem:SetData(self.cardData, displayConfig)
    self.cardItem.transform:Set_localScale(1, 1, 1)
    local xOffset = 0
    if self.cardData.cardType ~= TacticalCardType.Core then
      xOffset = -26
    end
    self.cardItem.transform:Set_localPosition(xOffset, 0, 0)
    self:OnCardLoadFinish()
  end)
end

function TCCardBaseInfoAreaComponent:ClearCardItem()
  if self.loadCardReq then
    self.loadCardReq:Destroy()
    self.loadCardReq = nil
  end
end

function TCCardBaseInfoAreaComponent:OnCardLoadFinish()
end

function TCCardBaseInfoAreaComponent:RefreshStarList()
  local isShowStar = self.cardData.cardType == TacticalCardType.Core
  self.starListItem:SetActive(isShowStar)
  if not isShowStar then
    return
  end
  local maxStar = self.cardData.template.max_star or 0
  self.starListItem:ReInit(self.cardData.star, maxStar)
end

function TCCardBaseInfoAreaComponent:RefreshPowerChangeInfo(powerChangeSign)
  powerChangeSign = powerChangeSign or 0
  self.powerChangeArrImg:SetActive(powerChangeSign ~= 0)
  if powerChangeSign == 0 then
    return
  end
  local arrIconPath = 0 < powerChangeSign and "Assets/Main/Sprites/UI/UILWTC/FX_xiangqing_common_jiantou1_icon.png" or "Assets/Main/Sprites/UI/UILWTC/FX_xiangqing_common_jiantou2_icon.png"
  self.powerChangeArrImg:LoadSprite(arrIconPath)
end

TCCardBaseInfoAreaComponent.OnCreate = OnCreate
TCCardBaseInfoAreaComponent.OnDestroy = OnDestroy
TCCardBaseInfoAreaComponent.OnEnable = OnEnable
TCCardBaseInfoAreaComponent.OnDisable = OnDisable
TCCardBaseInfoAreaComponent.ComponentDefine = ComponentDefine
TCCardBaseInfoAreaComponent.ComponentDestroy = ComponentDestroy
TCCardBaseInfoAreaComponent.DataDefine = DataDefine
TCCardBaseInfoAreaComponent.DataDestroy = DataDestroy
TCCardBaseInfoAreaComponent.OnAddListener = OnAddListener
TCCardBaseInfoAreaComponent.OnRemoveListener = OnRemoveListener
return TCCardBaseInfoAreaComponent
