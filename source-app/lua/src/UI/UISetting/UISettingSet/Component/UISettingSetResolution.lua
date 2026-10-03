local UISettingSetResolution = BaseClass("UISettingSetResolution", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UISettingInputCell = require("UI.UISetting.UISettingSet.Component.UISettingInputCell")
local title_name_path = "TitleBg/TitleName"

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
  self.title_name = self:AddComponent(UIText, title_name_path)
end

local function ComponentDestroy(self)
  self.title_name = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.title_name:SetText("\230\128\167\232\131\189\232\174\190\231\189\174")
  self:ShowCells()
end

local function ShowCells(self)
  for k, v in ipairs(SettingSetResolutionTypeSort) do
    self:AddOneCell(v)
  end
end

local function AddOneCell(self, setType)
  local temp = self.param.cell:GameObjectSpawn(self.transform)
  temp.name = tostring(setType)
  local cell = self:AddComponent(UISettingInputCell, temp.name)
  local param = UISettingInputCell.Param.New()
  param.setType = setType
  temp:SetActive(true)
  cell:ReInit(param)
end

UISettingSetResolution.OnCreate = OnCreate
UISettingSetResolution.OnDestroy = OnDestroy
UISettingSetResolution.OnEnable = OnEnable
UISettingSetResolution.OnDisable = OnDisable
UISettingSetResolution.ComponentDefine = ComponentDefine
UISettingSetResolution.ComponentDestroy = ComponentDestroy
UISettingSetResolution.DataDefine = DataDefine
UISettingSetResolution.DataDestroy = DataDestroy
UISettingSetResolution.ReInit = ReInit
UISettingSetResolution.ShowCells = ShowCells
UISettingSetResolution.AddOneCell = AddOneCell
return UISettingSetResolution
