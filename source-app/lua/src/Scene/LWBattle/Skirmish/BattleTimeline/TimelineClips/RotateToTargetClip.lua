local Base = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.BattleTimelineClip")
local RotateToTargetClip = BaseClassCache("RotateToTargetClip", Base)

function RotateToTargetClip:OnStart()
  self.unit = self.track:GetOwner()
  if IsNull(self.unit) then
    return
  end
  local para = self.clipInfo:GetPara()
  self.target = para.target
  Base.OnStart(self)
end

function RotateToTargetClip:OnUpdate(nowTime, deltaTime)
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

return RotateToTargetClip
