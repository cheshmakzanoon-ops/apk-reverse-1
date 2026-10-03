local TCBookItemComponent = BaseClass("TCBookItemComponent", UIBaseContainer)
local base = UIBaseContainer
local GameObject = CS.UnityEngine.GameObject
local Type_CS_Image = typeof(CS.UnityEngine.UI.Image)
local Type_CS_RectTransform = typeof(CS.UnityEngine.RectTransform)
local MASK_PATHS = {
  [TacticalCardType.Core] = "Assets/Main/Sprites/UI/UILWTCCardBook/FX_zhanshukapai_zhezhao_hexing.png",
  [TacticalCardType.Battle] = "Assets/Main/Sprites/UI/UILWTCCardBook/FX_zhanshukapai_zhezhao_putong.png",
  [TacticalCardType.Economy] = "Assets/Main/Sprites/UI/UILWTCCardBook/FX_zhanshukapai_zhezhao_putong.png"
}
local MASK_SIZES = {
  [TacticalCardType.Core] = {208.4739, 220.6181},
  [TacticalCardType.Battle] = {141, 189},
  [TacticalCardType.Economy] = {141, 189}
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
end

local function ComponentDestroy(self)
  self:RemoveAddOns()
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local CARD_DISPLAY_CONFIG = {
  isShowLv = false,
  isShowStar = false,
  isDeluxeShow = false,
  showBg = true
}

function TCBookItemComponent:SetConfigData(cardId, level, star, displayConfig)
  if not cardId then
    return
  end
  if not self.cardItem then
    local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
    self.cardType = cardTemplate.type
    local _, cls = TacticalCardUtil.GetCardConfigByCardType(self.cardType)
    self.cardItem = self:AddComponent(require(cls), "cardItem")
    self.cardItem:SetClickFunc(function(cardId, cardUuid, cardLevel, cardStar, cardData)
      if self.onClick then
        self.onClick(cardId, cardUuid, cardLevel, cardStar, cardData)
      end
    end)
  end
  self.cardItem:SetConfigData(cardId, level, star, CARD_DISPLAY_CONFIG)
end

function TCBookItemComponent:SetClickFunc(callback)
  self.onClick = callback
end

local MASK_SCALE_MAP = {
  [TacticalCardType.Core] = 1,
  [TacticalCardType.Battle] = 1,
  [TacticalCardType.Economy] = 1
}
local MASK_OFFSET_MAP_X = {
  [TacticalCardType.Core] = 0,
  [TacticalCardType.Battle] = -3.2,
  [TacticalCardType.Economy] = -3.2
}
local MASK_OFFSET_MAP = {
  [TacticalCardType.Core] = 0,
  [TacticalCardType.Battle] = 0,
  [TacticalCardType.Economy] = 0
}

function TCBookItemComponent:SetMaskState(showMask)
  if showMask and not self.mask then
    local maskObj = GameObject("Mask")
    maskObj:AddComponent(Type_CS_Image)
    maskObj.transform:SetParent(self.cardItem.clickBtn.transform)
    self.mask = self:AddComponent(UIImage, maskObj)
    self.mask:SetLocalScaleXYZ(MASK_SCALE_MAP[self.cardType], MASK_SCALE_MAP[self.cardType], MASK_SCALE_MAP[self.cardType])
    self.mask:SetAnchoredPositionXY(MASK_OFFSET_MAP_X[self.cardType], MASK_OFFSET_MAP[self.cardType])
    self.mask:SetRaycastTarget(false)
  end
  if self.mask then
    self.mask:SetActive(showMask)
    if showMask and (not self.maskType or self.maskType ~= self.cardType) then
      self.maskType = self.cardType
      self.mask:LoadSprite(MASK_PATHS[self.cardType])
      self.mask:SetColorRGBA(0.102, 0.149, 0.282, 0.6)
      self.mask:SetSizeDeltaXY(MASK_SIZES[self.cardType][1], MASK_SIZES[self.cardType][2])
    end
  end
end

function TCBookItemComponent:RemoveAddOns()
  if self.mask then
    local obj = self.mask.gameObject
    self.mask = nil
    if not IsNull(obj) then
      obj.transform:SetParent(nil)
      GameObject.Destroy(obj)
    end
  end
end

TCBookItemComponent.OnCreate = OnCreate
TCBookItemComponent.OnDestroy = OnDestroy
TCBookItemComponent.OnEnable = OnEnable
TCBookItemComponent.OnDisable = OnDisable
TCBookItemComponent.ComponentDefine = ComponentDefine
TCBookItemComponent.ComponentDestroy = ComponentDestroy
TCBookItemComponent.DataDefine = DataDefine
TCBookItemComponent.DataDestroy = DataDestroy
TCBookItemComponent.OnAddListener = OnAddListener
TCBookItemComponent.OnRemoveListener = OnRemoveListener
return TCBookItemComponent
