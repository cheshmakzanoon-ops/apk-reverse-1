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
  panelParam.panelType = AlStarCeremonyPanelType.PersonAward
  panelParam.param = {}
  local starTemplate = self.ceremonyInfo:GetTemplateInfo()
  panelParam.param.tipText = Localization:GetString(starTemplate.name)
  panelParam.param.playerInfo = self.ceremonyInfo:GetStarPlayerInfo()
  panelParam.param.showAnim = self.elapsedTime == 0
  panelParam.param.dialogText = Localization:GetString(starTemplate.content, string.GetFormattedSeparatorNum(self.ceremonyInfo:GetStarPlayerScore()))
  local jumpPanelParam = {}
  jumpPanelParam.panelType = AlStarCeremonyPanelType.Jump
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam, jumpPanelParam})
  if self.elapsedTime == 0 then
    self.scene:PlayReadPersonRewardAnim()
  end
end

return State
