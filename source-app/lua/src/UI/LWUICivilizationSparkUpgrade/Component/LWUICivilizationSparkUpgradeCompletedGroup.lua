local base = UIBaseContainer
local LWUICivilizationSparkUpgradeCompletedGroup = BaseClass("LWUICivilizationSparkUpgradeCompletedGroup", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICivilizationSparkUpgradeCompletedGroup:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICivilizationSparkUpgradeCompletedGroup:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICivilizationSparkUpgradeCompletedGroup:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textCompleted = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
end

function LWUICivilizationSparkUpgradeCompletedGroup:ComponentDestroy()
  self.viewSkin = nil
  self.textCompleted = nil
end

function LWUICivilizationSparkUpgradeCompletedGroup:DataDefine()
end

function LWUICivilizationSparkUpgradeCompletedGroup:DataDestroy()
end

function LWUICivilizationSparkUpgradeCompletedGroup:OnAddListener()
  base.OnAddListener(self)
end

function LWUICivilizationSparkUpgradeCompletedGroup:OnRemoveListener()
  base.OnRemoveListener(self)
end

return LWUICivilizationSparkUpgradeCompletedGroup
