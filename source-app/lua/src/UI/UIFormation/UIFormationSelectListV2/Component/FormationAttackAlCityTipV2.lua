local SelectAttackTimesPanel = require("UI.UIFormation.UIFormationSelectListV2.Component.SelectAttackTimesPanelV2")
local FormationAttackAlCityTipV2 = BaseClass("FormationAttackAlCityTipV2", UIBaseContainer)
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

FormationAttackAlCityTipV2.OnDestroy = OnDestroy
FormationAttackAlCityTipV2.OnCreate = OnCreate
FormationAttackAlCityTipV2.ComponentDefine = ComponentDefine
FormationAttackAlCityTipV2.ComponentDestroy = ComponentDestroy
FormationAttackAlCityTipV2.DataDefine = DataDefine
FormationAttackAlCityTipV2.DataDestroy = DataDestroy
FormationAttackAlCityTipV2.OnAddListener = OnAddListener
FormationAttackAlCityTipV2.OnRemoveListener = OnRemoveListener
FormationAttackAlCityTipV2.ShowPanel = ShowPanel
FormationAttackAlCityTipV2.OnConfirmCallback = OnConfirmCallback
return FormationAttackAlCityTipV2
