local VisitorUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = VisitorUnit
local VisitorProtectCoverNotify = BaseClass("VisitorProtectCoverNotify", base)
local Const = require("Scene.CityVisitor.Const")

function VisitorProtectCoverNotify:OnCreateModel(req, uid, startPos, endPos)
  base.OnCreateModel(self, req, uid, startPos, endPos)
  if self.questionIcon then
    self.questionIcon.transform:Set_localScale(2, 2, 2)
  end
end

function VisitorProtectCoverNotify:FinishVisitor(operate)
  self.isFinish = true
  self:SetFinishTargetPos()
  self:PlayAni(Const.animation.Walk)
  if self.questionIcon then
    self.questionIcon.gameObject:SetActive(false)
  end
  if operate == 1 then
    if self.smilingFaceIcon then
      self.smilingFaceIcon.gameObject:SetActive(true)
    end
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.tipRoot then
        self.tipRoot.gameObject:SetActive(false)
      end
    end, Const.showEmojiTime)
  elseif self.tipRoot then
    self.tipRoot.gameObject:SetActive(false)
  end
  if self.modelTrigger then
    self.modelTrigger.onPointerClick = nil
  end
  if self.trigger then
    self.trigger.onPointerClick = nil
  end
  DataCenter.CityVisitorManager:DeleteVisitor(self.visitorData.uid, self.visitorData.type)
end

function VisitorProtectCoverNotify:OnTriggerClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllianceCompeteProtectTip, {anim = false})
  local info = {
    uid = self.visitorData.uid,
    visitorType = self.visitorData.type,
    operate = 2
  }
  DataCenter.CityVisitorManager:FinishVisitor(info)
end

function VisitorProtectCoverNotify:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

return VisitorProtectCoverNotify
