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
  panelParam.panelType = AlStarCeremonyPanelType.Leave
  panelParam.param = {}
  local ceremonyInfo = DataCenter.AllianceStarManager:GetCeremonyFullData().ceremonyInfo
  panelParam.tipText = Localization:GetString("alliance_weeklyStar_reward_ex", #ceremonyInfo)
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam})
end

return State
