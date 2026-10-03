local base = UIBaseContainer
local QuickEquipSlotComponent = BaseClass("QuickEquipSlotComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local CORE_EMPTY_SPRITE = "Assets/Main/Sprites/UI/LWUITCCardMain/FX_zhanshukapai_fangan_big.png"
local CORE_FILLED_SPRITE = "Assets/Main/Sprites/UI/LWUITCCardMain/FX_zhanshukapai_fangan_big2.png"
local NORMAL_EMPTY_SPRITE = "Assets/Main/Sprites/UI/LWUITCCardMain/FX_zhanshukapai_fangan_small.png"
local NORMAL_FILLED_SPRITE = "Assets/Main/Sprites/UI/LWUITCCardMain/FX_zhanshukapai_fangan_small2.png"

function QuickEquipSlotComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function QuickEquipSlotComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function QuickEquipSlotComponent:ComponentDefine()
  self.compEmptySlot = self:TryAddComponent(UIBaseContainer, "Root/EmptySlot")
  self.btnRoot = self:TryAddComponent(UIButton, "Root")
  if self.btnRoot then
    self.btnRoot:SetOnClick(function()
      self:OnCardBtnClick()
    end)
  end
  self.imgLock = self:TryAddComponent(UIImage, "Root/EmptySlot/LockImg")
  self.compEquipCard = self:TryAddComponent(UIBaseContainer, "Root/EquipCard")
  self.compEquipCardCanvas = self:TryAddComponent(UICanvasGroup, "Root/EquipCard")
  self.imgBg = self:TryAddComponent(UIImage, "Root/EquipCard/Bg")
  self.imgTypeIcon = self:TryAddComponent(UIImage, "Root/EquipCard/TypeIcon")
  self.imgMissingMask = self:TryAddComponent(UIImage, "Root/EquipCard/MissingMask")
  self.iconImg = self:TryAddComponent(UIImage, "Root/EquipCard/Icon")
end

function QuickEquipSlotComponent:ComponentDestroy()
  self.compEmptySlot = nil
  self.btnRoot = nil
  self.imgLock = nil
  self.compEquipCard = nil
  self.imgBg = nil
  self.imgTypeIcon = nil
  self.imgMissingMask = nil
end

function QuickEquipSlotComponent:DataDefine()
end

function QuickEquipSlotComponent:DataDestroy()
end

function QuickEquipSlotComponent:OnAddListener()
  base.OnAddListener(self)
end

function QuickEquipSlotComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function QuickEquipSlotComponent:InitSlot(slotId, clickCallback)
  self.slotId = slotId
  self.slotData = TacticalCardUtil.QuickGetSlotDataById(self.slotId)
  self.clickCallback = clickCallback
end

function QuickEquipSlotComponent:SetCardData(cardData)
  self.cardData = cardData
  self.cardId = self.cardData and self.cardData.cardId
  self:RefreshView()
end

function QuickEquipSlotComponent:RefreshView()
  if not self.cardId or self.cardId < 0 then
    self:RefreshEmptySlotView()
    return
  end
  self:RefreshCard()
end

function QuickEquipSlotComponent:RefreshEmptySlotView()
  self.compEmptySlot:SetActive(true)
  self.compEquipCard:SetActive(false)
end

function QuickEquipSlotComponent:RefreshCard()
  self.compEmptySlot:SetActive(false)
  self.compEquipCard:SetActive(true)
  local iconPath, typeIconPath = self:BuildCardDisplayInfo()
  self.imgTypeIcon:LoadSpriteAsync(typeIconPath)
  self.iconImg:LoadSpriteAsync(iconPath)
  local isHasCard = true
  if self.cardData.uuid then
    isHasCard = DataCenter.TacticalCardDataManager:GetCardData(self.cardData.uuid) ~= nil
  elseif self.cardData.cardId then
    isHasCard = DataCenter.TacticalCardDataManager:HasCard(self.cardId)
  end
  self.compEquipCardCanvas:SetAlpha(isHasCard and 1 or 0.6)
end

function QuickEquipSlotComponent:BuildCardDisplayInfo()
  if not self.cardId then
    return nil, nil
  end
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.cardId)
  if not cardTemplate then
    self:RefreshEmptySlotView()
    return
  end
  local slotType = self.slotData and self.slotData:GetSlotType()
  local typeIconPath = TacticalCardUtil.GetSlotTypeIconPath(slotType)
  if cardTemplate and cardTemplate.deck ~= nil then
    local deckTemplate = LocalController:instance():getLine(TableName.BATTLE_CARD_DECK, cardTemplate.deck)
    if deckTemplate and not string.IsNullOrEmpty(deckTemplate.deck_icon_up) then
      typeIconPath = string.format(LoadPath.UILWTC, deckTemplate.deck_icon_up)
    end
  end
  local iconPath = cardTemplate and cardTemplate.icon_new or nil
  if not string.IsNullOrEmpty(iconPath) and not CS.GameEntry.Resource:HasAsset(iconPath) then
    Logger.LogWarning(string.format("cardId:%s not find icon assets:%s", cardTemplate.id, cardTemplate.icon_new))
    iconPath = "Assets/Main/Sprites/UI/UILWTCCardNew/unknown.png"
  end
  return iconPath, typeIconPath
end

function QuickEquipSlotComponent:OnCardBtnClick()
  if self.clickCallback then
    self.clickCallback(self.cardData)
  end
end

return QuickEquipSlotComponent
