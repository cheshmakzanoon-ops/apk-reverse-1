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
  panelParam.panelType = AlStarCeremonyPanelType.Applaud
  panelParam.param = {}
  panelParam.param.tipText = Localization:GetString(self.ceremonyInfo:GetTemplateInfo().name)
  panelParam.param.playerInfo = self.ceremonyInfo:GetStarPlayerInfo()
  panelParam.param.template = self.ceremonyInfo:GetTemplateInfo()
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam})
end

return State
