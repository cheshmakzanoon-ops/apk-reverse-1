local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorAdReminder = BaseClass("VisitorAdReminder", CallerUnit)
local Const = require("Scene.CityVisitor.Const")

function VisitorAdReminder:OnCreateModel(req, uid, startPos, endPos)
  base.OnCreateModel(self, req, uid, startPos, endPos)
  if self.cancel_icon then
    self.cancel_icon:LoadSpriteAsync("Assets/Main/Sprites/UI/LWUIMaxAd/lrb_daditu_ADqipao.png")
  end
end

function VisitorAdReminder:FinishVisitor(operate)
  self:SetFinishTargetPos()
  self.isFinish = true
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
  EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState)
end

function VisitorAdReminder:OnTriggerClick()
  if not self.param then
    return
  end
  DataCenter.MaxAdManager:ShowAdsCollectionPanel()
end

function VisitorAdReminder:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

function VisitorAdReminder:ClearData()
  base.ClearData(self)
end

return VisitorAdReminder
