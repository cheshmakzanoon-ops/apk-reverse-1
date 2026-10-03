local SelectAttackTimesPanel = require("UI.UIFormation.UIFormationSelectListNew.Component.SelectAttackTimesPanel")
local FormationAttackAlCityTip = BaseClass("FormationAttackAlCityTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local selectTimesPanel_path = "SelectAttackTimesPanel"

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

local function ComponentDefine(self)
  self.selectPanel = self:AddComponent(SelectAttackTimesPanel, selectTimesPanel_path)
end

local function ComponentDestroy(self)
  self.selectPanel = nil
end

local function DataDefine(self)
  self.formationData = nil
end

local function DataDestroy(self)
  self.formationData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, posX, posY, formationData, isMarch)
  self.formationData = formationData
  self.canCreate = formationData.useForm
  self.isMarch = formationData.isMarch == 1
  local v3 = self.transform.position
  v3.x = posX
  v3.y = posY
  self.transform.position = v3
  self.selectPanel:ShowPanel(nil, isMarch, function(times)
    self:OnConfirmCallback(times)
  end)
end

local function OnConfirmCallback(self, timesIndex)
  if self.isMarch then
    local uuid = self.formationData.uuid
    self.view:OnAttackAlCityBtnClick(uuid, timesIndex)
  elseif self.canCreate then
    self.view:OnCreateClick(self.formationData.uuid, timesIndex)
  else
    self.view:HideAllShowTip()
    self.view:OnEditClick(self.formationData.uuid, true, timesIndex)
  end
end

FormationAttackAlCityTip.OnDestroy = OnDestroy
FormationAttackAlCityTip.OnCreate = OnCreate
FormationAttackAlCityTip.ComponentDefine = ComponentDefine
FormationAttackAlCityTip.ComponentDestroy = ComponentDestroy
FormationAttackAlCityTip.DataDefine = DataDefine
FormationAttackAlCityTip.DataDestroy = DataDestroy
FormationAttackAlCityTip.OnAddListener = OnAddListener
FormationAttackAlCityTip.OnRemoveListener = OnRemoveListener
FormationAttackAlCityTip.ShowPanel = ShowPanel
FormationAttackAlCityTip.OnConfirmCallback = OnConfirmCallback
return FormationAttackAlCityTip
