local UIVIPEffectTipShakePanel = BaseClass("UIVIPEffectTipShakePanel", UIBaseContainer)
local base = UIBaseContainer
local shakeText_path = "ShakeText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.shakeText = self:AddComponent(UIText, shakeText_path)
  self.shakeText:SetLocalText("effectNumber_desc_90028")
end

local function DataDefine(self)
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
  self.shakeText = nil
end

local function DataDestroy(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self)
end

UIVIPEffectTipShakePanel.OnCreate = OnCreate
UIVIPEffectTipShakePanel.OnEnable = OnEnable
UIVIPEffectTipShakePanel.OnAddListener = OnAddListener
UIVIPEffectTipShakePanel.OnRemoveListener = OnRemoveListener
UIVIPEffectTipShakePanel.OnDisable = OnDisable
UIVIPEffectTipShakePanel.ComponentDefine = ComponentDefine
UIVIPEffectTipShakePanel.ComponentDestroy = ComponentDestroy
UIVIPEffectTipShakePanel.ComponentDestroy = ComponentDestroy
UIVIPEffectTipShakePanel.DataDefine = DataDefine
UIVIPEffectTipShakePanel.DataDestroy = DataDestroy
UIVIPEffectTipShakePanel.OnDestroy = OnDestroy
UIVIPEffectTipShakePanel.SetData = SetData
return UIVIPEffectTipShakePanel
