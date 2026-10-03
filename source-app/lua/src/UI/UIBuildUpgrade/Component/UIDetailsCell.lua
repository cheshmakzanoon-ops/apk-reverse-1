local UIDetailsCell = BaseClass("UIDetailsCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  names
}
local MaxTextCount = 5
local this_path = ""
local text_path = "Text%s"
local SpacingList = {
  0,
  0,
  150,
  60,
  0
}

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
  self.layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, this_path)
  self.text = {}
  for i = 1, MaxTextCount do
    self.text[i] = self:AddComponent(UIText, string.format(text_path, i))
    self.text[i]:SetActive(false)
  end
end

local function ComponentDestroy(self)
  self.layout = nil
  for k, v in pairs(self.text) do
    v:SetActive(false)
  end
  self.text = nil
end

local function DataDefine(self)
  self.param = {}
  self.max = nil
end

local function DataDestroy(self)
  self.param = nil
  self.max = nil
end

local function ReInit(self, param)
  self.param = param
  self.max = #param.names
  if self.max > MaxTextCount then
    self.max = MaxTextCount
  end
  for i = 1, self.max do
    self.text[i]:SetActive(true)
    self.text[i]:SetText(param.names[i])
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
return UIDetailsCell
