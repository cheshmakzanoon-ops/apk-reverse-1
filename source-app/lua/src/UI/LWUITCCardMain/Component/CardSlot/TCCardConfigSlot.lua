local base = require("UI.LWUITCCardMain.Component.CardSlot.TCCardBaseSlot")
local TCCardConfigSlot = BaseClass("TCCardConfigSlot", base)
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource

function TCCardConfigSlot:SetData(slotType, cardData, slotId)
  self.slotType = slotType
  self.slotCardData = cardData
  self.slotId = slotId
  self:RefreshView()
end

function TCCardConfigSlot:RefreshView()
  self:ShowEmptyState()
  self:RefreshSlotIcon()
  if self.slotCardData then
    self:GenCardItem(self.slotCardData)
  end
end

function TCCardConfigSlot:GenCardItem(cardData)
  self:ClearCardItem()
  self.loadCardReq = TacticalCardUtil.CreateOneCardItem(self, self.slotType, self.equipCardRoot, function(cardItem)
    self.cardItem = cardItem
    local displayConfig = {}
    displayConfig.isDeluxeShow = true
    displayConfig.isShowLv = true
    displayConfig.isEquipEffShow = false
    self.cardItem:SetConfigData(cardData.cardId, cardData.level or 1, cardData.star or 0, displayConfig)
    self:OnCardLoadFinish()
  end)
end

function TCCardConfigSlot:RefreshSlotIcon()
  if not self.slotData then
    return
  end
  self.lockImgObj:SetActive(false)
  local isShowCardTypeIcon = self.slotType ~= TacticalCardSlotType.Core
  self.slotTypeIcon:SetActive(isShowCardTypeIcon)
  if isShowCardTypeIcon then
    local iconPath = TacticalCardUtil.GetSlotTypeIconPath(self.slotType)
    if not string.IsNullOrEmpty(iconPath) then
      self.slotTypeIcon:LoadSprite(iconPath)
      self.slotTypeIcon:SetNativeSize()
    end
  end
end

function TCCardConfigSlot:SetClickFunc(clickFunc)
  self.clickFunc = clickFunc
end

function TCCardConfigSlot:ClickCardSlot()
  if self.clickFunc then
    self.clickFunc(self.slotId)
  end
end

return TCCardConfigSlot
