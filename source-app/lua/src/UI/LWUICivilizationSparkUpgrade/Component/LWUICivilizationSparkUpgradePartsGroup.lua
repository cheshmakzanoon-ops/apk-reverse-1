local base = UIBaseContainer
local LWUICivilizationSparkUpgradePartsGroup = BaseClass("LWUICivilizationSparkUpgradePartsGroup", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICivilizationSparkUpgradePartsGroup:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICivilizationSparkUpgradePartsGroup:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICivilizationSparkUpgradePartsGroup:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textPartsTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.rawImgPartsRawImage = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.textNextBuff = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function LWUICivilizationSparkUpgradePartsGroup:ComponentDestroy()
  self.viewSkin = nil
  self.textPartsTitle = nil
  self.rawImgPartsRawImage = nil
  self.textNextBuff = nil
end

function LWUICivilizationSparkUpgradePartsGroup:DataDefine()
end

function LWUICivilizationSparkUpgradePartsGroup:DataDestroy()
end

function LWUICivilizationSparkUpgradePartsGroup:OnAddListener()
  base.OnAddListener(self)
end

function LWUICivilizationSparkUpgradePartsGroup:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICivilizationSparkUpgradePartsGroup:Refresh(template)
  self.rawImgPartsRawImage:LoadSpriteAuto(template.uiItemImg, function()
    self.rawImgPartsRawImage:SetNativeSize()
  end)
  self.textNextBuff:SetLocalText(template.buffDesc)
end

return LWUICivilizationSparkUpgradePartsGroup
