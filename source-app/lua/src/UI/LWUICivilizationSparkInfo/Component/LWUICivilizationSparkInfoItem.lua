local base = UIBaseContainer
local LWUICivilizationSparkInfoItem = BaseClass("LWUICivilizationSparkInfoItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICivilizationSparkInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICivilizationSparkInfoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICivilizationSparkInfoItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgIcon = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textBuff = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compLockIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
end

function LWUICivilizationSparkInfoItem:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgIcon = nil
  self.textBuff = nil
  self.compLockIcon = nil
end

function LWUICivilizationSparkInfoItem:DataDefine()
end

function LWUICivilizationSparkInfoItem:DataDestroy()
end

function LWUICivilizationSparkInfoItem:OnAddListener()
  base.OnAddListener(self)
end

function LWUICivilizationSparkInfoItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICivilizationSparkInfoItem:Refresh(template, isLock)
  self.rawImgIcon:LoadSpriteAuto(template.uiItemImg, function()
    self.rawImgIcon:SetNativeSize()
  end)
  local desc = Localization:GetString(template.buffDesc)
  local colorDesc = ""
  if isLock then
    colorDesc = string.format("<color=#FFFFFF>%s</color>", desc)
  else
    colorDesc = string.format("<color=#5FEF87>%s</color>", desc)
  end
  self.textBuff:SetText(colorDesc)
  self.compLockIcon:SetActive(isLock)
  CS.UIGray.SetGray(self.rawImgIcon.transform, isLock, false)
end

return LWUICivilizationSparkInfoItem
