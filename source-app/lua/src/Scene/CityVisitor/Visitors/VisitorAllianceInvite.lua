local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorAllianceInvite = BaseClass("VisitorAllianceInvite", CallerUnit)
local Const = require("Scene.CityVisitor.Const")

function VisitorAllianceInvite:FinishVisitor(operate)
  self:SetFinishTargetPos()
  self.isFinish = true
  self:PlayAni(Const.animation.Walk)
  self.questionIcon.gameObject:SetActive(false)
  if operate == 1 then
    self.smilingFaceIcon.gameObject:SetActive(true)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.tipRoot then
        self.tipRoot.gameObject:SetActive(false)
      end
    end, Const.showEmojiTime)
  else
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

function VisitorAllianceInvite:OnTriggerClick()
  if not self.param then
    return
  end
  DataCenter.ClientCityVisitorManager:OpenAllianceInvitePanel()
  local info = {
    uid = self.visitorData.uid,
    visitorType = self.visitorData.type,
    operate = 1
  }
  DataCenter.CityVisitorManager:FinishVisitor(info)
end

function VisitorAllianceInvite:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

function VisitorAllianceInvite:ClearData()
  base.ClearData(self)
end

return VisitorAllianceInvite
