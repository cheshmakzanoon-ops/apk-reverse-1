local base = UIBaseContainer
local T11EffAttrItemComponent = BaseClass("T11EffAttrItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local EFF_PREFAB_PATH = "Assets/Main/Prefabs/UI/T11/Effect/Eff_ui_T11_saoguang_new.prefab"
local v_f_x_saoguang_path = "Bg/VFX_saoguang"

function T11EffAttrItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11EffAttrItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11EffAttrItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textCurValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textNextValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compNextIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compVFXSaoguang = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.effCpt = self:AddComponent(UIVfx, v_f_x_saoguang_path, EFF_PREFAB_PATH)
end

function T11EffAttrItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textCurValue = nil
  self.textNextValue = nil
  self.compNextIcon = nil
  self.compVFXSaoguang = nil
end

function T11EffAttrItemComponent:DataDefine()
end

function T11EffAttrItemComponent:DataDestroy()
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
end

function T11EffAttrItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11EffAttrItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11EffAttrItemComponent:SetData(title, fromValStr, toValStr, isUpgrade, isForceShowLightEff)
  local oldCurVal = self.textCurValue:GetText()
  self.textTitle:SetText(title)
  self.textCurValue:SetText(fromValStr)
  self.textNextValue:SetText(toValStr)
  self.effCpt:Stop()
  local isSameVal = fromValStr == toValStr
  self.compNextIcon:SetActive(not isSameVal)
  self.textNextValue:SetActive(not isSameVal)
  if isUpgrade and oldCurVal ~= tostring(fromValStr) then
    self:ShowLightEff()
    if self.playUpgradeEffCallback then
      self.playUpgradeEffCallback(self.transform.position)
    end
  elseif isForceShowLightEff then
    self:ShowLightEff()
  end
end

function T11EffAttrItemComponent:ShowLightEff()
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
  self.effCpt:Replay()
  self.effTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.effTimer = nil
  end, 2)
end

function T11EffAttrItemComponent:SetTitleText(stringKey)
  self.textTitle:SetLocalText(stringKey)
end

function T11EffAttrItemComponent:SetPlayUpgradeEffCallback(callback)
  self.playUpgradeEffCallback = callback
end

return T11EffAttrItemComponent
