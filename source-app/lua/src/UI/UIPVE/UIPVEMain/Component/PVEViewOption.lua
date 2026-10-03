local PVEViewOption = BaseClass("PVEViewOption", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local check_path = "Check"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn_path = self:AddComponent(UIButton, this_path)
  self.btn_path:SetOnClick(function()
    self:OnClick()
  end)
  self.check_go = self:AddComponent(UIBaseContainer, check_path)
  self.check_go:SetActive(false)
end

local function ComponentDestroy(self)
  self.btn_path = nil
  self.check_go = nil
end

local function DataDefine(self)
  self.isOn = false
  self.onClick = false
end

local function DataDestroy(self)
  self.isOn = nil
  self.onClick = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function GetIsOn(self)
  return self.isOn
end

local function SetIsOn(self, isOn)
  if self.isOn ~= isOn then
    self.isOn = isOn
    self.check_go:SetActive(self.isOn)
  end
end

local function OnClick(self)
  local isOn = not self:GetIsOn()
  self:SetIsOn(isOn)
  if self.onClick then
    self.onClick(isOn)
  end
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

PVEViewOption.OnCreate = OnCreate
PVEViewOption.OnDestroy = OnDestroy
PVEViewOption.ComponentDefine = ComponentDefine
PVEViewOption.ComponentDestroy = ComponentDestroy
PVEViewOption.DataDefine = DataDefine
PVEViewOption.DataDestroy = DataDestroy
PVEViewOption.OnEnable = OnEnable
PVEViewOption.OnDisable = OnDisable
PVEViewOption.OnAddListener = OnAddListener
PVEViewOption.OnRemoveListener = OnRemoveListener
PVEViewOption.ReInit = ReInit
PVEViewOption.GetIsOn = GetIsOn
PVEViewOption.SetIsOn = SetIsOn
PVEViewOption.OnClick = OnClick
PVEViewOption.SetOnClick = SetOnClick
return PVEViewOption
