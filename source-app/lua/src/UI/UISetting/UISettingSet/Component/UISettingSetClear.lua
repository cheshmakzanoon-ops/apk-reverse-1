local UISettingSetClear = BaseClass("UISettingSetClear", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UISettingBtnCell = require("UI.UISetting.UISettingSet.Component.UISettingBtnCell")
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
  self.title_name:SetLocalText(100244)
  self:ShowCells()
end

local function ShowCells(self)
  for k, v in ipairs(SettingSetClearTypeSort) do
    self:AddOneCell(v)
  end
end

local function AddOneCell(self, setType)
  local temp = self.param.cell:GameObjectSpawn(self.transform)
  temp.name = tostring(setType)
  local cell = self:AddComponent(UISettingBtnCell, temp.name)
  local param = UISettingBtnCell.Param.New()
  param.setType = setType
  temp:SetActive(true)
  cell:ReInit(param)
end

UISettingSetClear.OnCreate = OnCreate
UISettingSetClear.OnDestroy = OnDestroy
UISettingSetClear.OnEnable = OnEnable
UISettingSetClear.OnDisable = OnDisable
UISettingSetClear.ComponentDefine = ComponentDefine
UISettingSetClear.ComponentDestroy = ComponentDestroy
UISettingSetClear.DataDefine = DataDefine
UISettingSetClear.DataDestroy = DataDestroy
UISettingSetClear.ReInit = ReInit
UISettingSetClear.ShowCells = ShowCells
UISettingSetClear.AddOneCell = AddOneCell
return UISettingSetClear
