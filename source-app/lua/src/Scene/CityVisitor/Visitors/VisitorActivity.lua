local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorActivity = BaseClass("VisitorActivity", CallerUnit)
local Const = require("Scene.CityVisitor.Const")

function VisitorActivity:FinishVisitor(operate)
  self.isFinish = true
  self:SetFinishTargetPos()
  self:PlayAni(Const.animation.Walk)
  if self.questionIcon then
    self.questionIcon.gameObject:SetActive(false)
  end
  if operate == 1 then
    self.smilingFaceIcon.gameObject:SetActive(true)
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

function VisitorActivity:OnTriggerClick()
  if not self.param then
    return
  end
  if self.param.isNewLogic then
    base.OnTriggerClick(self)
  else
    self:OnConfirmClick()
  end
end

function VisitorActivity:OnConfirmClick()
  self:OnDelayClick(function()
    if not self.visitorData then
      return
    end
    local actVisitorData = DataCenter.ActivityVisitorManager:GetActivityVisitorDataByUid(self.visitorData.uid)
    if not actVisitorData or not actVisitorData.actVisitorData then
      return
    end
    local activityId = actVisitorData.actVisitorData.activityId
    SFSNetwork.SendMessage(MsgDefines.VisitorReceiveRewardMessage, activityId)
  end)
end

function VisitorActivity:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

return VisitorActivity
