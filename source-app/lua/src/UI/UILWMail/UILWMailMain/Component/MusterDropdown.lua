local MusterDropdown = BaseClass("MusterDropdown", UIBaseContainer)
local base = UIBaseContainer
local MailSoloCell = require("UI.UILWMail.UILWMailMain.Component.MailSoloCell")
local Localization = CS.GameEntry.Localization

function MusterDropdown:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MusterDropdown:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MusterDropdown:ComponentDefine()
  self.toggle = self:AddComponent(UIToggle, "DropdownTxt/Toggle")
  self.toggle:SetOnValueChanged(function(bool)
    self:OnClickToggle(bool)
  end)
end

function MusterDropdown:ComponentDestroy()
  self.parent = nil
end

function MusterDropdown:SetData(parent, bool)
  self.parent = parent
  self.toggle:SetIsOn(bool)
end

function MusterDropdown:OnClickToggle(bool)
  if self.parent then
    self.parent:OnClickToggle(bool)
  end
end

return MusterDropdown
