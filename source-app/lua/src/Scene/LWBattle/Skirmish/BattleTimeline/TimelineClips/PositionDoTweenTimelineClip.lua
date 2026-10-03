local Base = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.BattleTimelineClip")
local PositionDoTweenTimelineClip = BaseClassCache("PositionDoTweenTimelineClip", Base)

function PositionDoTweenTimelineClip:OnStart()
  local unit = self.track:GetOwner()
  if IsNull(unit) then
    return
  end
  local para = self.clipInfo:GetPara()
  local targetPos = para.target
  local duration = self.clipInfo.m_clipDuration
  local isWorld = para.isWorld
  local transform = unit:GetTransform()
  if IsNull(transform) then
    return
  end
  if isWorld then
    transform:DOMove(targetPos, duration)
  else
    transform:DOLocalMove(targetPos, duration)
  end
  Base.OnStart(self)
end

return PositionDoTweenTimelineClip
