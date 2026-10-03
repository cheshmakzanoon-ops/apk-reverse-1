local UISettingSetPerformance = BaseClass("UISettingSetPerformance", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UISettingSliderCell = require("UI.UISetting.UISettingSet.Component.UISettingSliderCell")
local UISettingPartSliderCell = require("UI.UISetting.UISettingSet.Component.UISettingPartSliderCell")
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
  self.cellShaderLod = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.title_name:SetLocalText(280005)
  self:ShowCells()
end

local function ShowCells(self)
  for k, v in ipairs(SettingSetPerformanceTypeSort) do
    self:AddOneCell(v)
  end
end

local function AddOneCell(self, setType)
  if CS.SceneManager.IsInPVE() and setType ~= SettingSetType.PveResetPos then
    return
  end
  if setType == SettingSetType.Monster or setType == SettingSetType.DebugChooseServer then
    local isOn = CS.CommonUtils.IsDebug()
    if LuaEntry.Player:GetGMFlag() == 0 and not isOn then
      return
    end
  end
  if setType == SettingSetType.SendNotice and LuaEntry.Player:GetGMFlag() == 0 then
    return
  end
  if setType == SettingSetType.ShowAnimal or setType == SettingSetType.ShowFarm then
    local isOn = CS.CommonUtils.IsDebug()
    if not isOn then
      return
    end
  end
  if setType == SettingSetType.ShaderLod then
    local temp = self.param.cell1:GameObjectSpawn(self.transform)
    temp.name = tostring(setType)
    local cell = self:AddComponent(UISettingPartSliderCell, temp.name)
    local param = UISettingPartSliderCell.Param.New()
    param.setType = setType
    temp:SetActive(true)
    cell:ReInit(param)
    self.cellShaderLod = cell
  elseif setType == SettingSetType.PveResetPos then
    local temp = self.param.cell2:GameObjectSpawn(self.transform)
    temp.name = tostring(setType)
    local cell = self:AddComponent(UISettingBtnCell, temp.name)
    local param = UISettingBtnCell.Param.New()
    param.setType = setType
    temp:SetActive(CS.SceneManager.IsInPVE())
    cell:ReInit(param)
  else
    local temp = self.param.cell:GameObjectSpawn(self.transform)
    temp.name = tostring(setType)
    local cell = self:AddComponent(UISettingSliderCell, temp.name)
    local param = UISettingSliderCell.Param.New()
    param.setType = setType
    temp:SetActive(true)
    cell:ReInit(param)
  end
end

function UISettingSetPerformance:OnGraphicLvChanged()
  if self.cellShaderLod then
    self.cellShaderLod:Refresh()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.Settings_Graphic_Lv_Changed, self.OnGraphicLvChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.Settings_Graphic_Lv_Changed, self.OnGraphicLvChanged)
  base.OnRemoveListener(self)
end

UISettingSetPerformance.OnCreate = OnCreate
UISettingSetPerformance.OnDestroy = OnDestroy
UISettingSetPerformance.OnEnable = OnEnable
UISettingSetPerformance.OnDisable = OnDisable
UISettingSetPerformance.ComponentDefine = ComponentDefine
UISettingSetPerformance.ComponentDestroy = ComponentDestroy
UISettingSetPerformance.DataDefine = DataDefine
UISettingSetPerformance.DataDestroy = DataDestroy
UISettingSetPerformance.ReInit = ReInit
UISettingSetPerformance.ShowCells = ShowCells
UISettingSetPerformance.AddOneCell = AddOneCell
UISettingSetPerformance.OnAddListener = OnAddListener
UISettingSetPerformance.OnRemoveListener = OnRemoveListener
return UISettingSetPerformance
