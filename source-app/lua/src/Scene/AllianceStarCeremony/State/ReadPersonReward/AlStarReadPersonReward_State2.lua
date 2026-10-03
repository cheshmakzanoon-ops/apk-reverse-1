local base = require("Scene.AllianceStarCeremony.State.AlStarBaseInnerState")
local State = {}
State.__index = State
setmetatable(State, base)
local Localization = CS.GameEntry.Localization
local MaskInTime = 300.0
local MaskOutTime = 100.0
local MaskAlpha = 0.9215686274509803

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
  local jumpPanelParam = {}
  jumpPanelParam.panelType = AlStarCeremonyPanelType.Jump
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam, jumpPanelParam})
end

function State:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.scene then
    if self.elapsedTime <= MaskInTime then
      local alpha = self.elapsedTime / MaskInTime * MaskAlpha
      self.scene:SetMaskRendererAlpha(alpha)
    elseif self.template.duration - self.elapsedTime <= MaskOutTime then
      local alpha = (self.template.duration - self.elapsedTime) / MaskOutTime * MaskAlpha
      self.scene:SetMaskRendererAlpha(alpha)
    end
  end
end

function State:OnExit()
  if self.scene then
    self.scene:ClearMPB()
  end
  base.OnExit(self)
end

return State
