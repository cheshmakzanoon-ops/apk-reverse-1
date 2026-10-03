local UISettingSetGame = BaseClass("UISettingSetGame", UIBaseContainer)
local base = UIBaseContainer
local UISettingSliderCell = require("UI.UISetting.UISettingSet.Component.UISettingSliderCell")
local title_name_path = "TitleBg/TitleName"
local cellsType = {
  SettingSetType.BuildFinishRemind,
  SettingSetType.ShakeCollectRes,
  SettingSetType.OneKeyCollectRes,
  SettingSetType.ShakeCollectTruckRes,
  SettingSetType.BackGesture,
  SettingSetType.ShowOfficialEffect
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
  self.title_name = self:AddComponent(UIText, title_name_path)
end

local function ComponentDestroy(self)
  self.title_name = nil
end

local function DataDefine(self)
  self.param = {}
  self.cells = {}
end

local function DataDestroy(self)
  self.param = nil
  self.cells = nil
end

local function ReInit(self, param)
  self.param = param
  self.title_name:SetLocalText("game_settings_title")
  self:ShowCells()
end

local function ShowCells(self)
  for k, v in ipairs(cellsType) do
    if self:CheckCellTypeShow(v) then
      self:AddOneCell(v)
    end
  end
  self:RefreshCells()
end

local function AddOneCell(self, setType)
  local temp = self.param.cell:GameObjectSpawn(self.transform)
  local name = tostring(setType)
  temp.name = name
  local cell = self:AddComponent(UISettingSliderCell, name)
  local param = UISettingSliderCell.Param.New()
  param.setType = setType
  temp:SetActive(true)
  cell:ReInit(param)
  self.cells[setType] = cell
end

local function CheckCellTypeShow(self, type)
  local show = false
  if type == SettingSetType.BuildFinishRemind then
    local showLevel = LuaEntry.DataConfig:TryGetStr("building_finish_check", "k1")
    show = not string.IsNullOrEmpty(showLevel) and DataCenter.BuildManager.MainLv >= tonumber(showLevel) or false
  elseif type == SettingSetType.ShakeCollectRes or type == SettingSetType.ShakeCollectTruckRes then
    show = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SHAKE_COLLECT_RES) > 0
  elseif type == SettingSetType.OneKeyCollectRes then
    show = not Config.IsPC() and LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SHAKE_COLLECT_RES) > 0
  elseif type == SettingSetType.BackGesture then
    show = DataCenter.BackGestureManager:GetNeedShowSetting()
  elseif type == SettingSetType.ShowOfficialEffect then
    show = LuaEntry.DataConfig:CheckSwitch("world_officer_icon")
  end
  return show
end

local function RefreshShow(self)
  local show = false
  for key, value in pairs(cellsType) do
    if self:CheckCellTypeShow(value) then
      show = true
      break
    end
  end
  self:SetActive(show)
end

function UISettingSetGame:RefreshCells()
  if self.cells then
    for k, v in pairs(self.cells) do
      if k == SettingSetType.OneKeyCollectRes then
        v:SetActive(not Config.IsPC() and LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SHAKE_COLLECT_RES) > 0 and Setting:GetBool(SettingKeys.SHAKE_COLLECT_RES, true))
      end
    end
  end
end

UISettingSetGame.OnCreate = OnCreate
UISettingSetGame.OnDestroy = OnDestroy
UISettingSetGame.OnEnable = OnEnable
UISettingSetGame.OnDisable = OnDisable
UISettingSetGame.ComponentDefine = ComponentDefine
UISettingSetGame.ComponentDestroy = ComponentDestroy
UISettingSetGame.DataDefine = DataDefine
UISettingSetGame.DataDestroy = DataDestroy
UISettingSetGame.ReInit = ReInit
UISettingSetGame.ShowCells = ShowCells
UISettingSetGame.AddOneCell = AddOneCell
UISettingSetGame.CheckCellTypeShow = CheckCellTypeShow
UISettingSetGame.RefreshShow = RefreshShow
return UISettingSetGame
