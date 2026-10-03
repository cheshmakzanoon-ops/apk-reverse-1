local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorOpenPanel = BaseClass("VisitorOpenPanel", CallerUnit)
local Const = require("Scene.CityVisitor.Const")

function VisitorOpenPanel:FinishVisitor(operate)
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

function VisitorOpenPanel:OnTriggerClick()
  if not self.visitorData or not self.visitorData.line then
    return
  end
  local para = self.visitorData.line.custom_para
  if not para then
    return
  end
  local openPanelPara = string.split(para, ",")
  if not openPanelPara or #openPanelPara < 2 then
    return
  end
  local openPanelName = openPanelPara[1]
  local id = openPanelPara[2]
  GoToUtil.GotoOpenView(openPanelName, id)
end

function VisitorOpenPanel:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

return VisitorOpenPanel
