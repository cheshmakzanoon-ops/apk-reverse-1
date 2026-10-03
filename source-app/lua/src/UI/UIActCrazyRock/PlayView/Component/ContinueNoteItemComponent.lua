local BaseNoteItemComponent = require("UI.UIActCrazyRock.PlayView.Component.BaseNoteItemComponent")
local base = BaseNoteItemComponent
local ContinueNoteItemComponent = BaseClass("ContinueNoteItemComponent", BaseNoteItemComponent)
local Localization = CS.GameEntry.Localization
local continue_times_text_path = "ContinueTimesText"
local continue_eff_path = "continueEff"
local count_down_progress_path = "CountDownProgress"

function ContinueNoteItemComponent:OnCreate()
  base.OnCreate(self)
end

function ContinueNoteItemComponent:OnDestroy()
  base.OnDestroy(self)
end

function ContinueNoteItemComponent:ComponentDefine()
  base.ComponentDefine(self)
  self.continueTimesText = self:AddComponent(UIText, continue_times_text_path)
  self.continueEff = self:AddComponent(UIBaseContainer, continue_eff_path)
  self.countDownProgressImg = self:AddComponent(UIImage, count_down_progress_path)
end

function ContinueNoteItemComponent:ComponentDestroy()
  base.ComponentDestroy(self)
end

function ContinueNoteItemComponent:DataDefine()
  base.DataDefine(self)
end

function ContinueNoteItemComponent:DataDestroy()
  base.DataDestroy(self)
end

function ContinueNoteItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ContinueNoteItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ContinueNoteItemComponent:SetNoteData(noteData)
  base.SetNoteData(self, noteData)
  self.countDownProgressImg:SetFillAmount(1)
end

function ContinueNoteItemComponent:RefreshNoteView()
  base.RefreshNoteView(self)
  self.continueTimesText:SetText(self.remainNeedHitTimes)
end

function ContinueNoteItemComponent:BeHit(hitTimePos)
  local ret = base.BeHit(self, hitTimePos)
  self:RefreshNoteView()
  return ret
end

function ContinueNoteItemComponent:OnEnterClickArea()
  base.OnEnterClickArea(self)
end

function ContinueNoteItemComponent:Tick(passTime)
  base.Tick(self, passTime)
  if not self.noteData then
    return
  end
  local passHitTime = passTime - self.noteData.noteTimePos
  if passHitTime <= 0 then
    return
  end
  local disappearTime = self.noteData:DisappearTimeWhenPassHitTime()
  local progress = Mathf.Clamp(1 - passHitTime / disappearTime, 0, 1)
  self.countDownProgressImg:SetFillAmount(progress)
end

return ContinueNoteItemComponent
