local BattleTimelineTrack = BaseClass("BattleTimelineTrack")
local BattleTimelineEnum = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimelineEnum")
local TrackState = BattleTimelineEnum.BattleTimelineTrackState

function BattleTimelineTrack:__init(timeline, unit, trackType)
  self.runningClips = {}
  self.waitingClips = {}
  self.timeline = timeline
  self.unit = unit
  self.state = TrackState.None
  self.updatableClips = {
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  }
  self.usablePositions = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10
  }
  self.trackType = trackType
end

local objPoolIns = ObjectPool:GetInstance()

function BattleTimelineTrack:RemoveAllClip()
  for _, clip in pairs(self.runningClips) do
    clip:Delete()
    objPoolIns:Save(clip)
  end
  for _, clip in pairs(self.waitingClips) do
    clip:Delete()
    objPoolIns:Save(clip)
  end
  self.runningClips = {}
  self.waitingClips = {}
  self.updatableClips = {
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  }
  self.usablePositions = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10
  }
  self.state = TrackState.None
end

function BattleTimelineTrack:GetArrEmptyIdx()
  if self.usablePositions[1] then
    return table.remove(self.usablePositions, 1)
  end
  for i = 1, #self.updatableClips do
    if not self.updatableClips[i] then
      return i
    end
  end
end

function BattleTimelineTrack:__delete()
  self:RemoveAllClip()
  self.runningClips = nil
  self.waitingClips = nil
  self.updatableClips = nil
  self.unit = nil
  self.timeline = nil
  self.usablePositions = nil
  self.trackType = nil
end

function BattleTimelineTrack:Update(nowTime, deltaTime)
  for i = 1, #self.updatableClips do
    local clip = self.updatableClips[i]
    if clip then
      clip:Update(nowTime, deltaTime)
    end
  end
end

function BattleTimelineTrack:RemoveClip(id)
  local clip = self.runningClips[id]
  clip = clip or self.waitingClips[id]
  local arrIdx
  if clip then
    arrIdx = clip.arrIdx
    clip:OnExit()
    clip:Delete()
  end
  objPoolIns:Save(clip)
  self.runningClips[id] = nil
  self.waitingClips[id] = nil
  if arrIdx then
    self.updatableClips[arrIdx] = false
    table.insert(self.usablePositions, arrIdx)
  end
end

local temp_table = {}
local temp_table2 = {}

function BattleTimelineTrack:AddClipFromNow(clipInfo)
  local nowTime = Time.time
  for i = 1, #temp_table do
    temp_table[i] = nil
  end
  for i = 1, #temp_table2 do
    temp_table2[i] = nil
  end
  local clipStartTime = nowTime + clipInfo.m_startOffset
  local clipPriority = clipInfo.m_priority
  for _, clip in pairs(self.runningClips) do
    if clip:IsValidAtTime(clipStartTime) then
      if clipPriority < clip:GetPriority() then
        table.insert(temp_table, clip)
      else
        table.insert(temp_table2, clip)
      end
    end
  end
  for _, clip in pairs(self.waitingClips) do
    if clip:IsValidAtTime(clipStartTime) then
      if clipPriority < clip:GetPriority() then
        table.insert(temp_table, clip)
      else
        table.insert(temp_table2, clip)
      end
    end
  end
  if 0 < #temp_table then
    return
  end
  for i = 1, #temp_table2 do
    self:RemoveClip(temp_table2[i].id)
  end
  local clsPath = BattleTimelineEnum.BattleTimelineClipCls[clipInfo.m_clipType]
  if not clsPath then
    return
  end
  local cls = require(clsPath)
  local clip = objPoolIns:Load(cls)
  local clipId = self.timeline:CreateId()
  local arrIdx = self:GetArrEmptyIdx()
  self.waitingClips[clipId] = clip
  self.updatableClips[arrIdx] = clip
  clip:Init(self, clipId, nowTime, clipInfo, arrIdx)
  return clipId
end

function BattleTimelineTrack:OnClipStart(clip)
  local id = clip.id
  self.runningClips[id] = clip
  self.waitingClips[id] = nil
end

function BattleTimelineTrack:OnClipFinish(clip)
  local id = clip.id
  self.runningClips[id] = nil
  if clip.arrIdx then
    self.updatableClips[clip.arrIdx] = false
    table.insert(self.usablePositions, clip.arrIdx)
  end
  if self.trackType == BattleTimelineEnum.BattleTimelineTrackType.Animation and clip and clip.clipInfo and clip.clipInfo.m_para.fallbackToIdle == true then
    local nextClip = next(self.runningClips)
    local time = Time.time
    for _, clip in pairs(self.waitingClips) do
      if clip:IsValidAtTimeRange(time, time + 0.1) then
        nextClip = clip
        break
      end
    end
    if not nextClip then
      local idleName = self.unit:GetIdleAnimName()
      self.unit:CrossFadeSimpleAnim(idleName, 1, 0.13)
    end
  end
  objPoolIns:Save(clip)
end

function BattleTimelineTrack:GetOwner()
  return self.unit
end

local lua_next = next

function BattleTimelineTrack:UpdateState()
  if lua_next(self.runningClips) ~= nil then
    self.state = TrackState.Running
  elseif lua_next(self.waitingClips) ~= nil then
    self.state = TrackState.Waiting
  else
    self.state = TrackState.None
  end
end

function BattleTimelineTrack:IsRunning()
  self:UpdateState()
  return self.state == TrackState.Running
end

return BattleTimelineTrack
