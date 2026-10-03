local UITypeButton = BaseClass("UITypeButton", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  id,
  name,
  callBack,
  needClick
}
local type_text_path = "TypeButtonText"
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.type_text = self:AddComponent(UIText, type_text_path)
  self.type_shadow = self:AddComponent(UIShadow, type_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
end

local function ComponentDestroy(self)
  self.type_text = nil
  self.type_shadow = nil
  self.btn = nil
end

local function DataDefine(self)
  self.param = nil
  self.typeText = nil
  self.typeColor = nil
  self.shadowEnable = nil
end

local function DataDestroy(self)
  self.param = nil
  self.typeText = nil
  self.shadowEnable = nil
  self.typeColor = nil
end

local function ReInit(self, ...)
  self.param = (...)
  if self.param == nil then
    self.gameObject:SetActive(false)
    return
  end
  self:Refresh()
  if self.param.needClick ~= nil and self.param.needClick then
    self:OnClick()
  else
    self:SetSelect(false)
  end
end

local function Refresh(self)
  self:SetTypeText(self.param.name)
end

local function OnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.transform, self.param.id)
  end
end

local function SetTypeText(self, value)
  if self.typeText ~= value then
    self.typeText = value
    self.type_text:SetText(value)
  end
end

local function SetSelect(self, value)
  if value then
    self:SetShadowEnable(true)
    self:SetColor(TabSelectColor)
  else
    self:SetShadowEnable(false)
    self:SetColor(TabUnSelectColor)
  end
end

local function SetColor(self, value)
  if self.typeColor ~= value then
    self.typeColor = value
    self.type_text:SetColor(value)
  end
end

local function SetShadowEnable(self, value)
  if self.shadowEnable ~= value then
    self.shadowEnable = value
    self.type_shadow:Enable(value)
  end
end

UITypeButton.OnDestroy = OnDestroy
UITypeButton.OnCreate = OnCreate
UITypeButton.OnClick = OnClick
UITypeButton.Refresh = Refresh
UITypeButton.ReInit = ReInit
UITypeButton.Param = Param
UITypeButton.ComponentDefine = ComponentDefine
UITypeButton.ComponentDestroy = ComponentDestroy
UITypeButton.DataDefine = DataDefine
UITypeButton.DataDestroy = DataDestroy
UITypeButton.SetTypeText = SetTypeText
UITypeButton.SetSelect = SetSelect
UITypeButton.SetShadowEnable = SetShadowEnable
UITypeButton.SetColor = SetColor
return UITypeButton
