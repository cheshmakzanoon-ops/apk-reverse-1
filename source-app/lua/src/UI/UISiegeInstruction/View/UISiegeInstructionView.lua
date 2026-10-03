local base = UIBaseView
local UISiegeInstructionView = BaseClass("UISiegeInstructionView", base)
local close_path = "bg/close"
local desc_path = "bg/desc"

function UISiegeInstructionView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UISiegeInstructionView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISiegeInstructionView:ComponentDefine()
  self.close = self:AddComponent(UIButton, close_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.close:SetOnClick(function()
    self:CloseSelf()
  end)
end

function UISiegeInstructionView:ComponentDestroy()
end

function UISiegeInstructionView:DataDefine()
end

function UISiegeInstructionView:DataDestroy()
end

function UISiegeInstructionView:OnAddListener()
  base.OnAddListener(self)
end

function UISiegeInstructionView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISiegeInstructionView:Refresh()
end

return UISiegeInstructionView
