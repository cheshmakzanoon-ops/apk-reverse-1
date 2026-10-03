local UIBuildBuffDetailCell = BaseClass("UIBuildBuffDetailCell", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local name_text_path = "nameText"
local value_text_path = "valueText"
local icon_path = "icon"

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
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.value_text = self:AddComponent(UIText, value_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, data)
  self.data = data
  self:RefreshView()
end

local function RefreshView(self)
  self.name_text:SetText(self.data.name)
  self.value_text:SetText(self.data.num)
  self.icon:LoadSprite(self.data.icon)
end

UIBuildBuffDetailCell.OnCreate = OnCreate
UIBuildBuffDetailCell.OnDestroy = OnDestroy
UIBuildBuffDetailCell.OnEnable = OnEnable
UIBuildBuffDetailCell.OnDisable = OnDisable
UIBuildBuffDetailCell.ComponentDefine = ComponentDefine
UIBuildBuffDetailCell.ComponentDestroy = ComponentDestroy
UIBuildBuffDetailCell.DataDefine = DataDefine
UIBuildBuffDetailCell.DataDestroy = DataDestroy
UIBuildBuffDetailCell.SetData = SetData
UIBuildBuffDetailCell.RefreshView = RefreshView
return UIBuildBuffDetailCell
