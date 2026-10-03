local base = UIBaseContainer
local T11PowerInfoComponent = BaseClass("T11PowerInfoComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UPGRADE_PREFAB_PATH = "Assets/Main/Prefabs/UI/T11/Effect/Eff_ui_common_zhanli_saoguang.prefab"
local upgrade_eff_path = "UpgradeEff"

function T11PowerInfoComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11PowerInfoComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11PowerInfoComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textPowerNumber = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.upgradeEff = self:AddComponent(UIVfx, upgrade_eff_path, UPGRADE_PREFAB_PATH)
end

function T11PowerInfoComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textPowerNumber = nil
end

function T11PowerInfoComponent:DataDefine()
end

function T11PowerInfoComponent:DataDestroy()
end

function T11PowerInfoComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11PowerInfoComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11PowerInfoComponent:SetPowerValue(powerValue)
  self.textPowerNumber:SetText(powerValue)
  self.upgradeEff:Stop()
end

function T11PowerInfoComponent:PlayUpgradeEff()
  self.upgradeEff:Replay()
end

return T11PowerInfoComponent
