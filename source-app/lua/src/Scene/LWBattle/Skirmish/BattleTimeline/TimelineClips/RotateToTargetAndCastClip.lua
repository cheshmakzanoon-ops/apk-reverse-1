local Base = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.BattleTimelineClip")
local RotateToTargetAndCastClip = BaseClass("RotateToTargetAndCastClip", Base)

function RotateToTargetAndCastClip:InitData()
  self.unit = self.track:GetOwner()
  if IsNull(self.unit) then
    return
  end
  local para = self.clipInfo:GetPara()
  self.skill = para.skill
  self.target = para.target
  Base.OnStart(self)
end

function RotateToTargetAndCastClip:OnUpdate(nowTime, deltaTime)
  if IsNull(self.unit) or IsNull(self.target) then
    self:OnFinish()
    return
  end
  if self.unit == self.target then
    self:OnFinish()
    return
  end
  local targetPos = self.target:GetPosition()
  if IsNull(targetPos) then
    self:OnFinish()
    return
  end
  if PveUtil.CheckCannonLookAt(self.unit, targetPos, deltaTime) then
    self:OnFinish()
    return
  end
end

function RotateToTargetAndCastClip:OnFinish()
  if self.unit and self.unit.CastSkill then
    self.unit:CastSkill(self.skill, self.target)
  end
  if self.track == nil then
    local test = 1
  end
  Base.OnFinish(self)
end

function RotateToTargetAndCastClip:OnExit()
  if self.unit and self.unit.CastSkill then
    self.unit:CastSkill(self.skill, self.target)
  end
  Base.OnExit(self)
end

return RotateToTargetAndCastClip
