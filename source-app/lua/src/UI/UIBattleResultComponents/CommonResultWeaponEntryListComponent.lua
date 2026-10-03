local base = UIBaseContainer
local CommonResultWeaponEntryListComponent = BaseClass("CommonResultWeaponEntryListComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWTacticalWeaponItem = require("UI.UILWTacticalWeapon.Component.UILWTacticalWeaponItem")

function CommonResultWeaponEntryListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonResultWeaponEntryListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonResultWeaponEntryListComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUILWTacticalWeaponItem = self.viewSkin:AddComponent(self, UILWTacticalWeaponItem, 1)
  self.textTxtWeaponName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTxtDmgNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgProgressBar = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgInner = self.viewSkin:AddComponent(self, UIImage, 5)
  self.canvasGroupImgBg = self.viewSkin:AddComponent(self, UICanvasGroup, 6)
  self.rootSimpleAnimation = self.viewSkin:AddComponent(self, UISimpleAnimation, 7)
end

function CommonResultWeaponEntryListComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUILWTacticalWeaponItem = nil
  self.textTxtWeaponName = nil
  self.textTxtDmgNum = nil
  self.imgProgressBar = nil
  self.imgInner = nil
  self.canvasGroupImgBg = nil
  self.rootSimpleAnimation = nil
end

function CommonResultWeaponEntryListComponent:DataDefine()
end

function CommonResultWeaponEntryListComponent:DataDestroy()
  if not IsNull(self.tween) then
    self.tween:Kill()
    self.tween = nil
  end
end

function CommonResultWeaponEntryListComponent:OnAddListener()
  base.OnAddListener(self)
end

function CommonResultWeaponEntryListComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CommonResultWeaponEntryListComponent:ReInit(data)
  if not data then
    return
  end
  if not IsNull(self.tween) then
    self.tween:Kill()
    self.tween = nil
  end
  self.compUILWTacticalWeaponItem:SetData(data.weaponData, data.appearanceId)
  self.textTxtWeaponName:SetText(data.weaponData:GetName())
  self.textTxtDmgNum:SetText(0)
  local barSize = self.imgProgressBar:GetSizeDelta()
  self.imgInner:SetSizeDelta(Vector2(0, barSize.y))
  self.progress = 0
  local percent = (data.value or 0) / (data.maxValue or 1)
  self.tween = CS.DG.Tweening.DOTween.To(function()
    return self.progress
  end, function(p)
    local value = data.value
    self.progress = value
    local pValue = value * p
    self.textTxtDmgNum:SetText(string.GetFormattedStr(pValue))
    self.imgInner:SetSizeDelta(Vector2(p * percent * barSize.x, barSize.y))
  end, 1, percent * 1):SetEase(CS.DG.Tweening.Ease.OutCubic)
end

function CommonResultWeaponEntryListComponent:SetRootAlpha(alpha)
  if self.canvasGroupImgBg then
    self.canvasGroupImgBg:SetAlpha(alpha)
  end
end

function CommonResultWeaponEntryListComponent:RewindPlayRootAnimation(animationName)
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Rewind(animationName)
    self.rootSimpleAnimation:Play(animationName)
  end
end

function CommonResultWeaponEntryListComponent:StopRootAnimation()
  if self.rootSimpleAnimation then
    self.rootSimpleAnimation:Stop()
  end
end

return CommonResultWeaponEntryListComponent
