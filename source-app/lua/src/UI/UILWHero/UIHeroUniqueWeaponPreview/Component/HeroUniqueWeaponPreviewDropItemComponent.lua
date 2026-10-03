local base = UIBaseContainer
local HeroUniqueWeaponPreviewDropItemComponent = BaseClass("HeroUniqueWeaponPreviewDropItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function HeroUniqueWeaponPreviewDropItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroUniqueWeaponPreviewDropItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroUniqueWeaponPreviewDropItemComponent:ReInit(lv, clickCallback)
  self.lv = lv
  self.clickCallback = clickCallback
  self.textLevel:SetText("Lv." .. tostring(self.lv))
end

function HeroUniqueWeaponPreviewDropItemComponent:UpdateSelect()
  if self.view and self.view.GetSelectLv then
    local curLv = self.view:GetSelectLv()
    self.compSelect:SetActive(curLv == self.lv)
  end
end

function HeroUniqueWeaponPreviewDropItemComponent:ComponentDefine()
  self.textLevel = self:AddComponent(UITextMeshProUGUIEx, "LevelText")
  self.compSelect = self:AddComponent(UIBaseContainer, "Select")
  self.btnLevelLine = self:AddComponent(UIButton, "")
  self.btnLevelLine:SetOnClick(function()
    self:OnBtnLevelLineClick()
  end)
end

function HeroUniqueWeaponPreviewDropItemComponent:ComponentDestroy()
  self.textLevel = nil
  self.compSelect = nil
  self.btnLevelLine = nil
end

function HeroUniqueWeaponPreviewDropItemComponent:DataDefine()
end

function HeroUniqueWeaponPreviewDropItemComponent:DataDestroy()
end

function HeroUniqueWeaponPreviewDropItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function HeroUniqueWeaponPreviewDropItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HeroUniqueWeaponPreviewDropItemComponent:OnBtnLevelLineClick()
  if self.clickCallback and self.lv then
    self.clickCallback(self.lv)
  end
end

return HeroUniqueWeaponPreviewDropItemComponent
