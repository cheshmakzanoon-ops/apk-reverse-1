local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Localization = CS.GameEntry.Localization

function State.Create(stateId)
  local copy = {}
  setmetatable(copy, State)
  copy:Init(stateId)
  return copy
end

function State:Init(stateId)
  self.stateId = stateId
end

function State:Dispose()
  self.stateId = nil
  self:OnExit()
end

function State:OnEnter(ceremonyInfo, elapsedTime)
  self.scene = self.owner.scene
  self.manager = self.scene.manager
  self.template = self.manager:GetTemplateByInnerId(self.owner.templateGroup, self.stateId)
  self:Refresh(ceremonyInfo, elapsedTime)
end

function State:OnExit()
  self.scene = nil
  self.manager = nil
  self.ceremonyInfo = nil
  self.elapsedTime = nil
end

function State:Refresh(ceremonyInfo, elapsedTime)
  self.ceremonyInfo = ceremonyInfo
  self.elapsedTime = elapsedTime
  self.scene:RefreshCompereBubble(self.template, self.elapsedTime, self.owner.stateId, self.stateId)
  self:RefreshSound()
  self:PlayAllyRandomAnim()
  self:OnRefresh()
end

function State:RefreshSound()
  if self.manager then
    if self.template then
      if self.template.bgmId and self.template.bgmId ~= 0 then
        self.manager:PlayBgm(self.template.bgmId)
      else
        self.manager:StopBgm()
      end
    end
    if self.template and self.template.sfxId and self.elapsedTime <= 100 then
      self.manager:PlaySfx(self.template.sfxId)
    end
  end
end

function State:OnRefresh()
end

function State:OnUpdate(deltaTime)
  self.elapsedTime = self.elapsedTime + deltaTime * 1000
end

function State:IsFinished()
  local isFinished = false
  if self.template and self.template.duration then
    isFinished = self.elapsedTime >= self.template.duration
  end
  return isFinished
end

function State:PlayAllyRandomAnim()
  if self.scene then
    if self.template and self.template.allyRandomAnim and #self.template.allyRandomAnim > 0 then
      local allyRandomAnim = self.template.allyRandomAnim[1]
      self.scene:SetRandomAnimAndDelay(allyRandomAnim)
    else
      self.scene:ClearRandomAnim()
    end
  end
end

return State
