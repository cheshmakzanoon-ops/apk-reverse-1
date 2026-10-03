local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIDispatchContentBase = BaseClass("UIDispatchContentBase", base)

function UIDispatchContentBase:OnCreate()
  base.OnCreate(self)
  self:BaseComponentDefine()
end

function UIDispatchContentBase:BaseComponentDefine()
  self.canvasGroupComponent = self:AddComponent(UICanvasGroup, "")
  self:ContentShow()
end

function UIDispatchContentBase:BaseComponentDestroy()
  self.canvasGroupComponent = nil
end

function UIDispatchContentBase:OnDestroy()
  self:BaseComponentDestroy()
  base.OnDestroy(self)
end

function UIDispatchContentBase:ContentShow()
  self.canvasGroupComponent:SetAlpha(1)
  self.canvasGroupComponent:SetInteractable(true)
  self.canvasGroupComponent:SetBlocksRaycasts(true)
end

function UIDispatchContentBase:ContentHide()
  self.canvasGroupComponent:SetAlpha(0)
  self.canvasGroupComponent:SetInteractable(false)
  self.canvasGroupComponent:SetBlocksRaycasts(false)
end

return UIDispatchContentBase
