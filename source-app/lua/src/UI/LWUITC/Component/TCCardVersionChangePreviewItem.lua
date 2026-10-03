local base = UIBaseContainer
local TCCardVersionChangePreviewItem = BaseClass("TCCardVersionChangePreviewItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local CARD_DISPLAY_CONFIG = {
  isShowLv = false,
  isShowStar = false,
  isDeluxeShow = false,
  showBg = false
}
local CardBaseItem = require("UI.LWUITCCardMain.Component.CardEntity.TCCardBaseItem")

function TCCardVersionChangePreviewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TCCardVersionChangePreviewItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TCCardVersionChangePreviewItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compOldCard = self.viewSkin:AddComponent(self, CardBaseItem, 1)
  self.compNewCard = self.viewSkin:AddComponent(self, CardBaseItem, 2)
  self.jiantou = self:AddComponent(UIBaseContainer, "jiantou")
end

function TCCardVersionChangePreviewItem:ComponentDestroy()
  self.viewSkin = nil
  self.compOldCard = nil
  self.compNewCard = nil
  self.jiantou = nil
end

function TCCardVersionChangePreviewItem:DataDefine()
end

function TCCardVersionChangePreviewItem:DataDestroy()
end

function TCCardVersionChangePreviewItem:OnAddListener()
  base.OnAddListener(self)
end

function TCCardVersionChangePreviewItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TCCardVersionChangePreviewItem:SetData(param)
  self.oldId = param.oldCardId
  self.newId = param.newCardId
  self.compOldCard:SetConfigData(self.oldId, 1, 0, CARD_DISPLAY_CONFIG)
  self.compNewCard:SetConfigData(self.newId, 1, 0, CARD_DISPLAY_CONFIG)
  self.compOldCard:SetClickFunc(function(cardId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardViewPanel, {anim = true}, cardId, true)
  end)
  self.compNewCard:SetClickFunc(function(cardId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardViewPanel, {anim = true}, cardId, true)
  end)
  if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == -1 then
    self.jiantou:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.jiantou:SetLocalScaleXYZ(1, 1, 1)
  end
end

function TCCardVersionChangePreviewItem:SetCardItem()
end

return TCCardVersionChangePreviewItem
