local base = require("Scene.AllianceStarCeremony.State.AlStarBaseInnerState")
local State = {}
State.__index = State
setmetatable(State, base)
local Localization = CS.GameEntry.Localization

function State.Create(stateId)
  local copy = {}
  setmetatable(copy, State)
  copy:Init(stateId)
  return copy
end

function State:OnRefresh()
  local panelParam = {}
  panelParam.panelType = AlStarCeremonyPanelType.AllianceReward
  panelParam.param = {}
  panelParam.param.titleText = Localization:GetString(self.ceremonyInfo:GetTemplateInfo().name)
  panelParam.param.level = tonumber(self.ceremonyInfo.extendInfo or 1)
  panelParam.param.progressParam = {}
  panelParam.param.progressParam.value = self.ceremonyInfo.score or 0
  panelParam.param.progressParam.elapsedTime = self.elapsedTime
  panelParam.param.progressParam.fullTime = self.template.duration
  panelParam.param.progressParam.template = self.ceremonyInfo:GetTemplateInfo()
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam})
end

return State
