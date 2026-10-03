local BattleTimelineClip = BaseClass("BattleTimelineClip")
local BattleTimelineEnum = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimelineEnum")
local ClipState = BattleTimelineEnum.ClipState

function BattleTimelineClip:__init()
  self.track = nil
  self.startTime = 0
  self.endTime = 0
  self.state = ClipState.None
  self.id = 0
  self.isInfinite = false
  self.arrIdx = 0
end

local objPoolIns = ObjectPool:GetInstance()

function BattleTimelineClip:__delete()
  if self.clipInfo then
    self.clipInfo:Clear()
    objPoolIns:Save(self.clipInfo)
  end
  self.track = nil
  self.clipInfo = nil
  self.arrIdx = 0
end

function BattleTimelineClip:Init(track, id, nowTime, info, arrIdx)
  self.id = id
  self.arrIdx = arrIdx
  self.clipInfo = info
  self.duration = self.clipInfo.m_clipDuration
  self.startTime = nowTime + self.clipInfo.m_startOffset
  self.endTime = self.startTime + self:GetDuration()
  self.state = ClipState.NotStart
  self.track = track
  self.isInfinite = self.clipInfo.m_finite
  self:InitData()
  if not self.isInfinite and self.duration <= 0 then
    self:OnStart()
    self:OnUpdate(nowTime, 0)
    self:OnFinish()
  end
end

function BattleTimelineClip:InitData()
end

function BattleTimelineClip:Update(nowTime, deltaTime)
  if self.state == ClipState.NotStart then
    if nowTime >= self.startTime then
      self:OnStart()
    end
  elseif self.state == ClipState.Running then
    self:OnUpdate(deltaTime)
    if not self.isInfinite and nowTime >= self.endTime then
      self:OnFinish()
    end
  end
end

function BattleTimelineClip:OnStart()
  self.track:OnClipStart(self)
  self.state = ClipState.Running
end

function BattleTimelineClip:OnUpdate(nowTime, deltaTime)
end

function BattleTimelineClip:OnFinish()
  self.state = ClipState.Finished
  self.track:OnClipFinish(self)
end

function BattleTimelineClip:GetDuration()
  return self.duration
end

function BattleTimelineClip:OnExit()
end

function BattleTimelineClip:IsValidAtTime(time)
  if self.state == ClipState.Finished then
    return false
  end
  if time < self.startTime then
    return false
  end
  if not self.isInfinite and time >= self.endTime then
    return false
  end
  return true
end

function BattleTimelineClip:IsValidAtTimeRange(startTime, endTime)
  if self.state == ClipState.Finished then
    return false
  end
  if endTime < self.startTime then
    return false
  end
  if not self.isInfinite and startTime >= self.endTime then
    return false
  end
  return true
end

function BattleTimelineClip:GetPriority()
  if not self.clipInfo then
    return 0
  end
  return self.clipInfo.m_priority or 0
end

return BattleTimelineClip
