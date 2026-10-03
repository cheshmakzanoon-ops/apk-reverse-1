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
  panelParam.panelType = AlStarCeremonyPanelType.CountDown
  panelParam.param = {}
  panelParam.param.titleText = Localization:GetString("alliance_weeklyStar_ceremony_state_comming")
  panelParam.param.cdTimeStamp = self.manager:GetOpenCDTime() - self.elapsedTime
  panelParam.param.textStyle = 1
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam})
end

return State
