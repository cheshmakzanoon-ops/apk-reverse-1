local UISettingSetPrompt = BaseClass("UISettingSetPrompt", UIBaseContainer)
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
  self.title_name:SetLocalText(280134)
  self:ShowCells()
end

local function ShowCells(self)
  for k, v in ipairs(SettingSetPromptTypeSort) do
    if v == SettingSetType.GetPersonDuelScoreTip and DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.PersonalArmsNew.Type) then
      self:AddOneCell(v)
    elseif v == SettingSetType.GetAllyDuelScoreTip and DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId) then
      self:AddOneCell(v)
    elseif v == SettingSetType.PowerUpBannerDetail then
      local function_on = LuaEntry.DataConfig:CheckSwitch("player_combat_change")
      if function_on then
        self:AddOneCell(v)
      end
    else
      self:AddOneCell(v)
    end
  end
end

local function AddOneCell(self, setType)
  local temp = self.param.cell:GameObjectSpawn(self.transform)
  temp.name = tostring(setType)
  local cell = self:AddComponent(UISettingSliderCell, temp.name)
  local param = UISettingSliderCell.Param.New()
  param.setType = setType
  temp:SetActive(true)
  cell:ReInit(param)
end

UISettingSetPrompt.OnCreate = OnCreate
UISettingSetPrompt.OnDestroy = OnDestroy
UISettingSetPrompt.OnEnable = OnEnable
UISettingSetPrompt.OnDisable = OnDisable
UISettingSetPrompt.ComponentDefine = ComponentDefine
UISettingSetPrompt.ComponentDestroy = ComponentDestroy
UISettingSetPrompt.DataDefine = DataDefine
UISettingSetPrompt.DataDestroy = DataDestroy
UISettingSetPrompt.ReInit = ReInit
UISettingSetPrompt.ShowCells = ShowCells
UISettingSetPrompt.AddOneCell = AddOneCell
return UISettingSetPrompt
