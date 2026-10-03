local base = require("Scene.AllianceStarCeremony.State.AlStarBaseInnerState")
local State = {}
State.__index = State
setmetatable(State, base)
local showAnimTime = 1300
local Localization = CS.GameEntry.Localization

function State.Create(stateId)
  local copy = {}
  setmetatable(copy, State)
  copy:Init(stateId)
  return copy
end

function State:OnRefresh()
  local panelParam = {}
  panelParam.panelType = AlStarCeremonyPanelType.Tip
  panelParam.param = {}
  panelParam.param.tipText = Localization:GetString(self.ceremonyInfo:GetTemplateInfo().name)
  local jumpPanelParam = {}
  jumpPanelParam.panelType = AlStarCeremonyPanelType.Jump
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam, jumpPanelParam})
  self.needShowUIAnim = self.template.duration - self.elapsedTime > showAnimTime
end

function State:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.needShowUIAnim then
    local time = self.template.duration - self.elapsedTime
    if time <= showAnimTime then
      self.needShowUIAnim = false
      EventManager:GetInstance():Broadcast(EventId.AllianceStarMainPlayAnim, AlStarMainUIAnimName.Reward)
    end
  end
end

return State
