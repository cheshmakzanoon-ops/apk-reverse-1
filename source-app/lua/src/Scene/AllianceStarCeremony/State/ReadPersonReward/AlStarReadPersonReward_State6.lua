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
  panelParam.panelType = AlStarCeremonyPanelType.Thumb
  panelParam.param = {}
  local starTemplate = self.ceremonyInfo:GetTemplateInfo()
  panelParam.param.tipText = Localization:GetString(starTemplate.name)
  panelParam.param.ceremonyInfo = self.ceremonyInfo
  panelParam.param.closeThumb = true
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam})
end

return State
