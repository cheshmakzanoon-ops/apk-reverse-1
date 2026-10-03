local base = UIBaseContainer
local BaseNoteItemComponent = BaseClass("BaseNoteItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function BaseNoteItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BaseNoteItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BaseNoteItemComponent:ComponentDefine()
end

function BaseNoteItemComponent:ComponentDestroy()
end

function BaseNoteItemComponent:DataDefine()
  self.remainNeedHitTimes = 0
end

function BaseNoteItemComponent:DataDestroy()
  self.remainNeedHitTimes = nil
end

function BaseNoteItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function BaseNoteItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BaseNoteItemComponent:SetNoteData(noteData)
  self.noteData = noteData
  self.noteType = noteData.noteType
  self.remainNeedHitTimes = self.noteData:GetTotalHitTimes()
  self.enterClickAreaFlag = true
  self:RefreshNoteView()
end

function BaseNoteItemComponent:RefreshNoteView()
end

function BaseNoteItemComponent:SetShowHide(isShow)
  self.gameObject:SetActive(isShow)
end

function BaseNoteItemComponent:GetNoteTimePos()
  return self.noteData.noteTimePos
end

function BaseNoteItemComponent:IsContinueNote()
  return self:GetNoteType() == CrazyRockNoteType.Continue
end

function BaseNoteItemComponent:GetNoteType()
  return self.noteType
end

function BaseNoteItemComponent:BeHit(hitTimePos)
  local isHit = self.noteData:CheckIsHit(hitTimePos)
  if not isHit then
    return
  end
  local hitRet = {}
  local hitType = self:GetCurHitType()
  self.remainNeedHitTimes = self.remainNeedHitTimes - 1
  self.remainNeedHitTimes = Mathf.Max(self.remainNeedHitTimes, 0)
  if self:IsNoteCompleted() then
    hitRet.isFinish = true
  end
  hitRet.hitType = hitType
  local score, scoreType = self.noteData:GetScoreInfoByHitPos(hitTimePos, hitType)
  hitRet.baseScore = score
  hitRet.scoreType = scoreType
  hitRet.hitTimePos = hitTimePos
  return hitRet
end

function BaseNoteItemComponent:GetCurHitType()
  if self.noteType == CrazyRockNoteType.SingleClick then
    return CrazyRockHitType.SingleNoteHit
  elseif self.noteType == CrazyRockNoteType.Continue then
    if self.remainNeedHitTimes == self.noteData:GetTotalHitTimes() then
      return CrazyRockHitType.ContinueFirstNoteHit
    else
      return CrazyRockHitType.ContinueHit
    end
  end
  return CrazyRockHitType.EmptyHit
end

function BaseNoteItemComponent:OnEnterClickArea()
  self.enterClickAreaFlag = false
end

function BaseNoteItemComponent:IsNoteCompleted()
  return self.remainNeedHitTimes <= 0
end

function BaseNoteItemComponent:Tick(passTime)
end

function BaseNoteItemComponent:IsEndMusicNote()
  return self.noteData and self.noteData.isEndMusicNote
end

return BaseNoteItemComponent
