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
  local panelParam1 = {}
  panelParam1.panelType = AlStarCeremonyPanelType.Applaud
  panelParam1.param = {}
  panelParam1.param.tipText = Localization:GetString(self.ceremonyInfo:GetTemplateInfo().name)
  panelParam1.param.playerInfo = self.ceremonyInfo:GetStarPlayerInfo()
  panelParam1.param.template = self.ceremonyInfo:GetTemplateInfo()
  panelParam1.param.showInAnim = self.elapsedTime <= 100
  panelParam1.param.endDeltaTime = self.template.duration - self.elapsedTime
  local panelParam2 = {}
  panelParam2.panelType = AlStarCeremonyPanelType.InterAction
  panelParam2.param = {}
  panelParam2.param.tipText = Localization:GetString(self.ceremonyInfo:GetTemplateInfo().name)
  panelParam2.param.playerInfo = self.ceremonyInfo:GetStarPlayerInfo()
  panelParam2.param.endDeltaTime = self.template.duration - self.elapsedTime
  panelParam2.param.template = self.ceremonyInfo:GetTemplateInfo()
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam1, panelParam2})
end

function State:PlayAllyRandomAnim()
  self:PlayAllyRandomAnimByLevel(self:GetInteractionLevel())
end

function State:GetInteractionLevel()
  local starTemplate = self.ceremonyInfo:GetTemplateInfo()
  local info = self.manager:GetCeremonyInteractionInfo(starTemplate:GetInteractionType())
  local level = 1
  if info then
    level = starTemplate:GetLevelByInteractionNum(info.interactionNumber)
  end
  return level
end

function State:PlayAllyRandomAnimByLevel(level)
  if self.scene then
    local allyRandomAnim = self.template.allyRandomAnim[level]
    self.scene:SetRandomAnimAndDelay(allyRandomAnim)
  end
  if self.manager then
    if level == 2 then
      if not string.IsNullOrEmpty(self.template.param2) then
        self.manager:PlayLoopEffect(tonumber(self.template.param2))
      end
    elseif not string.IsNullOrEmpty(self.template.param1) then
      self.manager:PlayLoopEffect(tonumber(self.template.param1))
    end
  end
end

function State:OnExit()
  if self.manager then
    self.manager:StopLoopEffect()
  end
  base.OnExit(self)
end

return State
