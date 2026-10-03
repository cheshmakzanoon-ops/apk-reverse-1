local UIAllianceStarMainInteractionTip = BaseClass("UIAllianceStarMainInteractionTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
end

local function ComponentDestroy(self)
  self.canvasGroup = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, showTime, unit, pos, alpha)
  self.showTime = showTime
  if pos then
    self:SetAnchoredPosition(pos)
  end
  if alpha then
    self.canvasGroup:SetAlpha(alpha)
  end
  self.unit = unit
end

local function Clear(self)
  self.unit = nil
end

local function Update(self)
  if not (self.unit == nil or self.unit.showInteractionIcon) or self.showTime <= 0 then
    self.holder:RemoveTipIcon(self, self.unit)
    return
  end
  self.showTime = self.showTime - Time.deltaTime
end

UIAllianceStarMainInteractionTip.OnCreate = OnCreate
UIAllianceStarMainInteractionTip.OnDestroy = OnDestroy
UIAllianceStarMainInteractionTip.OnEnable = OnEnable
UIAllianceStarMainInteractionTip.OnDisable = OnDisable
UIAllianceStarMainInteractionTip.ComponentDefine = ComponentDefine
UIAllianceStarMainInteractionTip.ComponentDestroy = ComponentDestroy
UIAllianceStarMainInteractionTip.DataDefine = DataDefine
UIAllianceStarMainInteractionTip.DataDestroy = DataDestroy
UIAllianceStarMainInteractionTip.OnAddListener = OnAddListener
UIAllianceStarMainInteractionTip.OnRemoveListener = OnRemoveListener
UIAllianceStarMainInteractionTip.Refresh = Refresh
UIAllianceStarMainInteractionTip.Update = Update
UIAllianceStarMainInteractionTip.Clear = Clear
return UIAllianceStarMainInteractionTip
