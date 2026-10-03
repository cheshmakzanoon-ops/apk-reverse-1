local UICityAttackS0PageToggleItem = BaseClass("UICityAttackS0PageToggleItem", UIBaseContainer)
local base = UIBaseContainer
local Toggle_path = ""
local TypeText1_path = "Background/TypeText1"
local TypeText2_path = "Background/TypeText2"
local Red_path = "CommonRedPoint"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.Toggle = self:AddComponent(UIToggle, Toggle_path)
  self.TypeText1 = self:AddComponent(UITextMeshProUGUIEx, TypeText1_path)
  self.TypeText2 = self:AddComponent(UITextMeshProUGUIEx, TypeText2_path)
  self.Toggle:SetOnValueChanged(function(tf)
    if tf then
      self.toggleCallback()
    end
  end)
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
  self.Toggle = nil
  self.TypeText1 = nil
  self.TypeText2 = nil
end

local function DataDestroy(self)
  self.index = nil
  self.toggleCallback = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self, index, toggleCallback)
  self.index = index
  self.toggleCallback = toggleCallback
end

local function ReInit(self, strId)
  self.TypeText1:SetLocalText(strId)
  self.TypeText2:SetLocalText(strId)
end

local function OnSelect(self, isSelect)
  self.Toggle:SetIsOn(isSelect)
  self.TypeText1:SetActive(not isSelect)
  self.TypeText2:SetActive(isSelect)
end

UICityAttackS0PageToggleItem.OnCreate = OnCreate
UICityAttackS0PageToggleItem.OnEnable = OnEnable
UICityAttackS0PageToggleItem.OnAddListener = OnAddListener
UICityAttackS0PageToggleItem.OnRemoveListener = OnRemoveListener
UICityAttackS0PageToggleItem.OnDisable = OnDisable
UICityAttackS0PageToggleItem.ComponentDefine = ComponentDefine
UICityAttackS0PageToggleItem.ComponentDestroy = ComponentDestroy
UICityAttackS0PageToggleItem.DataDefine = DataDefine
UICityAttackS0PageToggleItem.DataDestroy = DataDestroy
UICityAttackS0PageToggleItem.OnDestroy = OnDestroy
UICityAttackS0PageToggleItem.SetData = SetData
UICityAttackS0PageToggleItem.ReInit = ReInit
UICityAttackS0PageToggleItem.OnSelect = OnSelect
return UICityAttackS0PageToggleItem
