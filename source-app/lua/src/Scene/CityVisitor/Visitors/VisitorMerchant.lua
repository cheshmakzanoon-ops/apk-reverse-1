local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorMerchant = BaseClass("VisitorMerchant", CallerUnit)
local Const = require("Scene.CityVisitor.Const")
local Localization = CS.GameEntry.Localization

function VisitorMerchant:FinishVisitor(operate)
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
  EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState)
end

function VisitorMerchant:OnInitClickParam(param)
  for i = 1, #param.desList do
    if i == #param.desList then
      local line = LocalController:instance():getLine(TableName.City_Visitor, self.visitorData.eventId)
      local paramList = string.split(line.para, ";")
      local res = LocalController:instance():getLine(TableName.Resource, paramList[3])
      local goodName = DataCenter.ItemTemplateManager:GetName(paramList[1])
      param.desList[i] = Localization:GetString(param.desList[i], goodName, paramList[2], Localization:GetString(res.name), paramList[4])
    else
      param.desList[i] = Localization:GetString(param.desList[i])
    end
  end
  return param
end

function VisitorMerchant:OnConfirmClick()
  self:OnDelayClick(function()
    SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 1)
    self:ShowNextInfo()
  end)
end

function VisitorMerchant:CancelClick()
  self:OnDelayClick(function()
    SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 0)
  end)
end

function VisitorMerchant:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

return VisitorMerchant
