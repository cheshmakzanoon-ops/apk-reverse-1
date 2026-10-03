local ActSevenDayV2ListDayItem = BaseClass("ActSevenDayV2ListDayItem", UIBaseContainer)
local base = UIBaseContainer
local Toggle_path = ""
local TypeText1_path = "Background/TypeText1"
local TypeText2_path = "Background/TypeText2"
local Red_path = "Img_RedList1"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.Toggle = self:AddComponent(UIToggle, Toggle_path)
  self.TypeText1 = self:AddComponent(UITextMeshProUGUIEx, TypeText1_path)
  self.TypeText2 = self:AddComponent(UITextMeshProUGUIEx, TypeText2_path)
  self.RedPoint = self:AddComponent(UITextMeshProUGUIEx, Red_path)
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
  self.RedPoint = nil
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

local function ShowRed(self, isShow)
  self.RedPoint:SetActive(isShow)
end

ActSevenDayV2ListDayItem.OnCreate = OnCreate
ActSevenDayV2ListDayItem.OnEnable = OnEnable
ActSevenDayV2ListDayItem.OnAddListener = OnAddListener
ActSevenDayV2ListDayItem.OnRemoveListener = OnRemoveListener
ActSevenDayV2ListDayItem.OnDisable = OnDisable
ActSevenDayV2ListDayItem.ComponentDefine = ComponentDefine
ActSevenDayV2ListDayItem.ComponentDestroy = ComponentDestroy
ActSevenDayV2ListDayItem.ComponentDestroy = ComponentDestroy
ActSevenDayV2ListDayItem.DataDefine = DataDefine
ActSevenDayV2ListDayItem.DataDestroy = DataDestroy
ActSevenDayV2ListDayItem.OnDestroy = OnDestroy
ActSevenDayV2ListDayItem.SetData = SetData
ActSevenDayV2ListDayItem.ReInit = ReInit
ActSevenDayV2ListDayItem.OnSelect = OnSelect
ActSevenDayV2ListDayItem.ShowRed = ShowRed
return ActSevenDayV2ListDayItem
