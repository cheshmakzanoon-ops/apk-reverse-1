local BattleTimelineClipInfo = BaseClass("BattleTimelineClipInfo")
local BattleTimelineEnum = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimelineEnum")

function BattleTimelineClipInfo:__init()
  self.m_clipType = 0
  self.m_clipDuration = 0
  self.m_startOffset = 0
  self.m_finite = false
  self.m_priority = 0
  self.m_para = nil
end

function BattleTimelineClipInfo:Clear()
  self.m_clipType = 0
  self.m_clipDuration = 0
  self.m_startOffset = 0
  self.m_finite = false
  self.m_priority = 0
  if self.m_para then
    self.m_para = {}
  end
end

function BattleTimelineClipInfo:Init(clipType, clipDuration, startOffset, infinite, priority)
  self.m_clipType = clipType
  self.m_clipDuration = clipDuration or 0
  self.m_startOffset = startOffset or 0
  if infinite == nil then
    self.m_finite = false
  else
    self.m_finite = infinite
  end
  self.m_priority = priority or 0
  self.m_para = nil
end

function BattleTimelineClipInfo:SetPara(para)
  self.m_para = para
end

function BattleTimelineClipInfo:GetPara()
  if self.m_para == nil then
    self.m_para = {}
  end
  return self.m_para
end

return BattleTimelineClipInfo
