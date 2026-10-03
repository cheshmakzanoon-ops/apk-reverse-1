local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorNotify = BaseClass("VisitorNotify", CallerUnit)
local Const = require("Scene.CityVisitor.Const")
local LATEST_NOTIFY_TIME_KEY = "LATEST_NOTIFY_TIME_KEY"

function VisitorNotify:FinishVisitor(operate)
  self:SetFinishTargetPos()
  self.isFinish = true
  self:PlayAni(Const.animation.Walk)
  self.questionIcon.gameObject:SetActive(false)
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

function VisitorNotify:OnTriggerClick()
  if not self.param then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICityVisitorNotify, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.param)
end

function VisitorNotify:InitClickParam()
  base.InitClickParam(self)
  self.param.type = OptionType.Two
end

function VisitorNotify:OnConfirmClick()
  self:OnDelayClick(function()
    if not self.visitorData then
      return
    end
    local info = {
      uid = self.visitorData.uid,
      visitorType = self.visitorData.type,
      operate = 1
    }
    CS.GameEntry.Sdk:AskForNotifyPermission()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetLong(LATEST_NOTIFY_TIME_KEY, curTime)
    DataCenter.CityVisitorManager:FinishVisitor(info)
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitorNotify, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
  end)
end

function VisitorNotify:CancelClick()
  self:OnDelayClick(function()
    if not self.visitorData then
      return
    end
    local info = {
      uid = self.visitorData.uid,
      visitorType = self.visitorData.type,
      operate = 2
    }
    local curTime = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetLong(LATEST_NOTIFY_TIME_KEY, curTime)
    DataCenter.CityVisitorManager:FinishVisitor(info)
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitorNotify, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
  end)
end

function VisitorNotify:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

function VisitorNotify:ClearData()
  base.ClearData(self)
end

return VisitorNotify
