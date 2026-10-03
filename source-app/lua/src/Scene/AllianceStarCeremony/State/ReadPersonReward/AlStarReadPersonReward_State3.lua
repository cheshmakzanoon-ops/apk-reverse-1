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
  panelParam.panelType = AlStarCeremonyPanelType.PersonList
  panelParam.param = {}
  panelParam.param.tipText = Localization:GetString(self.ceremonyInfo:GetTemplateInfo().name)
  panelParam.param.nominatePlayerInfoList = self.ceremonyInfo:GetNominatePlayerInfoList()
  panelParam.param.starPlayerInfo = self.ceremonyInfo:GetStarPlayerInfo()
  panelParam.param.showAnim = self.elapsedTime == 0
  panelParam.param.starDuration = self.template.duration
  local jumpPanelParam = {}
  jumpPanelParam.panelType = AlStarCeremonyPanelType.Jump
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam, jumpPanelParam})
end

return State
