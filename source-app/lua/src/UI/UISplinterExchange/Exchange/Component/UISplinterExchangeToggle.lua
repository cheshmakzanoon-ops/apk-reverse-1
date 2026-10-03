local base = UIToggle
local UISplinterExchangeToggle = BaseClass("UISplinterExchangeToggle", base)
local tab_text_path = "ToggleBg/tab_text"
local Choose_path = "ToggleBg/Choose"
local tab2_text_path = "ToggleBg/Choose/tab_2_text"

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.tab_text = self:AddComponent(UITextMeshProUGUIEx, tab_text_path)
  self.Choose = self:AddComponent(UIBaseContainer, Choose_path)
  self.tab2_text = self:AddComponent(UIBaseContainer, tab2_text_path)
end

local function ComponentDestroy(self)
  self.tab_text = nil
  self.Choose = nil
  self.tab2_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, dialogId)
  if dialogId then
    self.tab_text:SetLocalText(dialogId)
    self.tab2_text:SetLocalText(dialogId)
  end
end

local function SetSelect(self)
  self.Choose:SetActive(true)
end

local function SetUnSelect(self)
  self.Choose:SetActive(false)
end

UISplinterExchangeToggle.OnCreate = OnCreate
UISplinterExchangeToggle.OnDestroy = OnDestroy
UISplinterExchangeToggle.OnEnable = OnEnable
UISplinterExchangeToggle.OnDisable = OnDisable
UISplinterExchangeToggle.ComponentDefine = ComponentDefine
UISplinterExchangeToggle.ComponentDestroy = ComponentDestroy
UISplinterExchangeToggle.DataDefine = DataDefine
UISplinterExchangeToggle.DataDestroy = DataDestroy
UISplinterExchangeToggle.SetData = SetData
UISplinterExchangeToggle.SetSelect = SetSelect
UISplinterExchangeToggle.SetUnSelect = SetUnSelect
return UISplinterExchangeToggle
