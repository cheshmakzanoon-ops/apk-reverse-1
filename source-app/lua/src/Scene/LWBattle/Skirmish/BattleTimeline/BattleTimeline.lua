local BattleTimeline = BaseClass("BattleTimeline")
local BattleTimelineTrack = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimelineTrack")
local BattleTimelineEnum = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimelineEnum")

function BattleTimeline:__init(unit)
  self.tracks = {}
  self.trackIds = {}
  self.id = 0
  self.unit = unit
end

function BattleTimeline:__delete()
  for i = 1, #self.tracks do
    self.tracks[i]:Delete()
  end
  self.tracks = {}
  self.trackIds = {}
end

local CS_TIME = Time

function BattleTimeline:Update(deltaTime)
  local nowTime = CS_TIME.time
  for i = 1, #self.trackIds do
    local id = self.trackIds[i]
    self.tracks[id]:Update(nowTime, deltaTime)
  end
end

function BattleTimeline:CreateTrack(trackType)
  local track = BattleTimelineTrack.New(self, self.unit, trackType)
  self.tracks[trackType] = track
  self.trackIds[#self.trackIds + 1] = trackType
  return track
end

function BattleTimeline:CreateId()
  self.id = self.id + 1
  return self.id
end

function BattleTimeline:AddClip(clipInfo, forceTrackType)
  local type = clipInfo.m_clipType
  if not BattleTimelineEnum.BattleTimelineClipCls[type] then
    return
  end
  local trackType = forceTrackType or BattleTimelineEnum.ClipToTrackType[type]
  if not trackType then
    return
  end
  local track = self.tracks[trackType]
  track = track or self:CreateTrack(trackType)
  return track:AddClipFromNow(clipInfo)
end

function BattleTimeline:IsTrackRunning(trackType)
  local track = self.tracks[trackType]
  if not track then
    return false
  end
  return track:IsRunning()
end

function BattleTimeline:RemoveClip(id)
  for i = 1, #self.trackIds do
    self.tracks[self.trackIds[i]]:RemoveClip(id)
  end
end

function BattleTimeline:RemoveAllClip()
  for i = 1, #self.trackIds do
    self.tracks[self.trackIds[i]]:RemoveAllClip()
  end
end

return BattleTimeline
