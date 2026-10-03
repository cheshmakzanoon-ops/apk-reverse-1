local UIVIPEffectTipView = BaseClass("UIVIPEffectTipView", UIBaseView)
local base = UIBaseView
local UIVIPEffectTipShakePanel = require("UI.UIVip.UIVIPEffectTip.Component.UIVIPEffectTipShakePanel")
local closePanel_path = "Panel"
local root_path = "Root"
local arrow_path = "Root/Arrow"
local shakePanel_path = "Root/ShakePanel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

local function ComponentDefine(self)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.shakePanel = self:AddComponent(UIVIPEffectTipShakePanel, shakePanel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function DataDefine(self)
  self.effectId, self.targetPos = self:GetUserData()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
  self.closePanel = nil
  self.arrow = nil
  self.shakePanel = nil
end

local function DataDestroy(self)
  self.effectId = nil
  self.targetPos = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function Refresh(self)
  if CommonUtil.IsArabic() then
    self.root:SetPivotXY(1, 0.5)
    self.root:SetPositionXYZ(self.targetPos.x - 40, self.targetPos.y, self.root:GetPosition().z)
    self.arrow:SetAnchorMinXY(1, 0.5)
    self.arrow:SetAnchorMaxXY(1, 0.5)
    self.arrow:SetLocalPositionXYZ(8.6, 0, 0)
    self.arrow:SetLocalScaleXYZ(1, 1, 1)
    if CommonUtil.GetAutoArabicMirrorSwitch() then
      self.arrow:SetLocalPositionXYZ(-8.6, 0, 0)
      self.arrow:SetLocalScaleXYZ(-1, 1, 1)
    end
  else
    self.root:SetPivotXY(0, 0.5)
    self.root:SetPositionXYZ(self.targetPos.x + 40, self.targetPos.y, self.root:GetPosition().z)
    self.arrow:SetAnchorMinXY(0, 0.5)
    self.arrow:SetAnchorMaxXY(0, 0.5)
    self.arrow:SetLocalPositionXYZ(-8.6, 0, 0)
    self.arrow:SetLocalScaleXYZ(-1, 1, 1)
  end
  self.shakePanel:SetActive(false)
  if self.effectId == EffectDefine.LW_SHAKE_COLLECT_RES then
    self.shakePanel:SetData()
    self.shakePanel:SetActive(true)
  end
end

UIVIPEffectTipView.OnCreate = OnCreate
UIVIPEffectTipView.OnEnable = OnEnable
UIVIPEffectTipView.OnAddListener = OnAddListener
UIVIPEffectTipView.OnRemoveListener = OnRemoveListener
UIVIPEffectTipView.OnDisable = OnDisable
UIVIPEffectTipView.ComponentDefine = ComponentDefine
UIVIPEffectTipView.ComponentDestroy = ComponentDestroy
UIVIPEffectTipView.ComponentDestroy = ComponentDestroy
UIVIPEffectTipView.DataDefine = DataDefine
UIVIPEffectTipView.DataDestroy = DataDestroy
UIVIPEffectTipView.OnDestroy = OnDestroy
UIVIPEffectTipView.Refresh = Refresh
return UIVIPEffectTipView
