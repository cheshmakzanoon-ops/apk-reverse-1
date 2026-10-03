local DebugServerItem = BaseClass("DebugServerItem", UIBaseContainer)
local base = UIBaseContainer
local txt = "Text"

local function OnCreate(self, param)
  base.OnCreate(self)
  self.Text = self:AddComponent(UIText, txt)
  self.Text:SetText(param.Data.name or param.Data.zone)
  self.Toggle = self:AddComponent(UIToggle, "")
  self.Toggle.isOn = param.isOn
  self.param = param
  self.Toggle:SetOnValueChanged(function()
    self.param.ChooseServer(param)
  end)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
  self.Text = nil
  self.Toggle = nil
  self.param = nil
end

DebugServerItem.OnCreate = OnCreate
DebugServerItem.OnDestroy = OnDestroy
DebugServerItem.OnEnable = OnEnable
DebugServerItem.OnDisable = OnDisable
return DebugServerItem
