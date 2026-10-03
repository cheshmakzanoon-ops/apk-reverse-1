local UISettingSetSound = BaseClass("UISettingSetSound", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UISettingSliderCell = require("UI.UISetting.UISettingSet.Component.UISettingSliderCell")
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
  self.title_name:SetLocalText(280015)
  self:ShowCells()
end

local function ShowCells(self)
  for k, v in ipairs(SettingSetSoundTypeSort) do
    self:AddOneCell(v)
  end
end

local function AddOneCell(self, setType)
  if CS.SceneManager.IsInPVE() and setType ~= SettingSetType.Sound and setType ~= SettingSetType.Vibrate then
    return
  end
  local isInSeason = SeasonUtil.IsInSeasonOrHalt(LuaEntry.Player:GetSelfServerId())
  if not isInSeason and setType == SettingSetType.UseSeasonBGM then
    return
  end
  if not DataCenter.LWSoundManager:IsEnvSwitchOn() and setType == SettingSetType.envSound then
    return
  end
  local temp = self.param.cell:GameObjectSpawn(self.transform)
  temp.name = tostring(setType)
  local cell = self:AddComponent(UISettingSliderCell, temp.name)
  local param = UISettingSliderCell.Param.New()
  param.setType = setType
  temp:SetActive(true)
  cell:ReInit(param)
end

UISettingSetSound.OnCreate = OnCreate
UISettingSetSound.OnDestroy = OnDestroy
UISettingSetSound.OnEnable = OnEnable
UISettingSetSound.OnDisable = OnDisable
UISettingSetSound.ComponentDefine = ComponentDefine
UISettingSetSound.ComponentDestroy = ComponentDestroy
UISettingSetSound.DataDefine = DataDefine
UISettingSetSound.DataDestroy = DataDestroy
UISettingSetSound.ReInit = ReInit
UISettingSetSound.ShowCells = ShowCells
UISettingSetSound.AddOneCell = AddOneCell
return UISettingSetSound
