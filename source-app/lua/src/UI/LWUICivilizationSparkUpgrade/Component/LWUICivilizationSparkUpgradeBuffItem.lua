local base = UIBaseContainer
local LWUICivilizationSparkUpgradeBuffItem = BaseClass("LWUICivilizationSparkUpgradeBuffItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICivilizationSparkUpgradeBuffItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICivilizationSparkUpgradeBuffItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICivilizationSparkUpgradeBuffItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBuffBG = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textBuff = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function LWUICivilizationSparkUpgradeBuffItem:ComponentDestroy()
  self.viewSkin = nil
  self.compBuffBG = nil
  self.textBuff = nil
end

function LWUICivilizationSparkUpgradeBuffItem:DataDefine()
end

function LWUICivilizationSparkUpgradeBuffItem:DataDestroy()
end

function LWUICivilizationSparkUpgradeBuffItem:OnAddListener()
  base.OnAddListener(self)
end

function LWUICivilizationSparkUpgradeBuffItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICivilizationSparkUpgradeBuffItem:Refresh(desc, index)
  self.textBuff:SetLocalText(desc)
  self.compBuffBG:SetActive(index % 2 == 1)
end

return LWUICivilizationSparkUpgradeBuffItem
