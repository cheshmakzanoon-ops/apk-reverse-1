local UIDetailsCell = BaseClass("UIDetailsCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  name1,
  name2,
  name3,
  name4,
  name5,
  name6
}
local text1_path = "Text1"
local text2_path = "Text2"
local text3_path = "Text3"
local text4_path = "Text4"
local text5_path = "Text5"
local text6_path = "Text6"

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
  self.text1 = self:AddComponent(UIText, text1_path)
  self.text2 = self:AddComponent(UIText, text2_path)
  self.text3 = self:AddComponent(UIText, text3_path)
  self.text4 = self:AddComponent(UIText, text4_path)
  self.text5 = self:AddComponent(UIText, text5_path)
  self.text6 = self:AddComponent(UIText, text6_path)
end

local function ComponentDestroy(self)
  self.text1 = nil
  self.text2 = nil
  self.text3 = nil
  self.text4 = nil
  self.text5 = nil
  self.text6 = nil
end

local function DataDefine(self)
  self.param = {}
  self.name1Text = nil
  self.name2Text = nil
  self.name3Text = nil
  self.name4Text = nil
  self.name5Text = nil
  self.name6Text = nil
  self.name1Active = nil
  self.name2Active = nil
  self.name3Active = nil
  self.name4Active = nil
  self.name5Active = nil
  self.name6Active = nil
end

local function DataDestroy(self)
  self.param = nil
  self.name1Text = nil
  self.name2Text = nil
  self.name3Text = nil
  self.name4Text = nil
  self.name5Text = nil
  self.name6Text = nil
  self.name1Active = nil
  self.name2Active = nil
  self.name3Active = nil
  self.name4Active = nil
  self.name5Active = nil
  self.name6Active = nil
end

local function ReInit(self, param)
  self.param = param
  if param.name1 == nil then
    self:SetName1Active(false)
  else
    self:SetName1Text(param.name1)
    self:SetName1Active(true)
  end
  if param.name2 == nil then
    self:SetName2Active(false)
  else
    self:SetName2Text(param.name2)
    self:SetName2Active(true)
  end
  if param.name3 == nil then
    self:SetName3Active(false)
  else
    self:SetName3Text(param.name3)
    self:SetName3Active(true)
  end
  if param.name4 == nil then
    self:SetName4Active(false)
  else
    self:SetName4Text(param.name4)
    self:SetName4Active(true)
  end
  if param.name5 == nil then
    self:SetName5Active(false)
  else
    self:SetName5Text(param.name5)
    self:SetName5Active(true)
  end
  if param.name6 == nil then
    self:SetName6Active(false)
  else
    self:SetName6Text(param.name6)
    self:SetName6Active(true)
  end
end

local function SetName1Text(self, value)
  if self.name1Text ~= value then
    self.name1Text = value
    self.text1:SetText(value)
  end
end

local function SetName2Text(self, value)
  if self.name2Text ~= value then
    self.name2Text = value
    self.text2:SetText(value)
  end
end

local function SetName3Text(self, value)
  if self.name3Text ~= value then
    self.name3Text = value
    self.text3:SetText(value)
  end
end

local function SetName4Text(self, value)
  if self.name4Text ~= value then
    self.name4Text = value
    self.text4:SetText(value)
  end
end

local function SetName5Text(self, value)
  if self.name5Text ~= value then
    self.name5Text = value
    self.text5:SetText(value)
  end
end

local function SetName6Text(self, value)
  if self.name6Text ~= value then
    self.name6Text = value
    self.text6:SetText(value)
  end
end

local function SetName1Active(self, value)
  if self.name1Active ~= value then
    self.name1Active = value
    self.text1:SetActive(value)
  end
end

local function SetName2Active(self, value)
  if self.name2Active ~= value then
    self.name2Active = value
    self.text2:SetActive(value)
  end
end

local function SetName3Active(self, value)
  if self.name3Active ~= value then
    self.name3Active = value
    self.text3:SetActive(value)
  end
end

local function SetName4Active(self, value)
  if self.name4Active ~= value then
    self.name4Active = value
    self.text4:SetActive(value)
  end
end

local function SetName5Active(self, value)
  if self.name5Active ~= value then
    self.name5Active = value
    self.text5:SetActive(value)
  end
end

local function SetName6Active(self, value)
  if self.name6Active ~= value then
    self.name6Active = value
    self.text6:SetActive(value)
  end
end

UIDetailsCell.OnCreate = OnCreate
UIDetailsCell.OnDestroy = OnDestroy
UIDetailsCell.Param = Param
UIDetailsCell.OnEnable = OnEnable
UIDetailsCell.OnDisable = OnDisable
UIDetailsCell.ComponentDefine = ComponentDefine
UIDetailsCell.ComponentDestroy = ComponentDestroy
UIDetailsCell.DataDefine = DataDefine
UIDetailsCell.DataDestroy = DataDestroy
UIDetailsCell.ReInit = ReInit
UIDetailsCell.SetName1Text = SetName1Text
UIDetailsCell.SetName2Text = SetName2Text
UIDetailsCell.SetName3Text = SetName3Text
UIDetailsCell.SetName4Text = SetName4Text
UIDetailsCell.SetName5Text = SetName5Text
UIDetailsCell.SetName6Text = SetName6Text
UIDetailsCell.SetName1Active = SetName1Active
UIDetailsCell.SetName2Active = SetName2Active
UIDetailsCell.SetName3Active = SetName3Active
UIDetailsCell.SetName4Active = SetName4Active
UIDetailsCell.SetName5Active = SetName5Active
UIDetailsCell.SetName6Active = SetName6Active
return UIDetailsCell
