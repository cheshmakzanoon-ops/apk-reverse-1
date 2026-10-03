local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorS0AllianceBossVisitor = BaseClass("VisitorS0AllianceBossVisitor", CallerUnit)
local Const = require("Scene.CityVisitor.Const")

function VisitorS0AllianceBossVisitor:FinishVisitor(operate)
  self:SetFinishTargetPos()
  self.isFinish = true
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

function VisitorS0AllianceBossVisitor:InitClickParam()
  base.InitClickParam(self)
  local overdue, type = DataCenter.S0AllianceBossDataManager:CheckVisitorStatus()
  if type == nil or type == 0 then
    return
  end
  local contextId
  if type == 1 then
    contextId = "s0_alliance_boss_visitor_reminder_2"
  elseif type == 2 then
    contextId = "s0_alliance_boss_visitor_reminder_1"
  elseif type == 3 then
    contextId = "s0_alliance_boss_visitor_bubble"
  end
  if contextId then
    self.param.desList = {
      CS.GameEntry.Localization:GetString(contextId)
    }
    self.param.type = OptionType.Two
    self.status = type
  end
end

function VisitorS0AllianceBossVisitor:OnTriggerClick()
  if not self.param or self.status == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICityVisitorNotify, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.param)
  DataCenter.S0AllianceBossDataManager:UpdateS0AllianceBossVisitorNoShow()
end

function VisitorS0AllianceBossVisitor:OnConfirmClick()
  self:OnDelayClick(function()
    if not self.visitorData or self.status == nil then
      return
    end
    if self.status and (self.status == 1 or self.status == 2) then
      DataCenter.S0AllianceBossDataManager:GotoActivityPanel()
    end
    local info = {
      uid = self.visitorData.uid,
      visitorType = self.visitorData.type,
      operate = 1
    }
    DataCenter.CityVisitorManager:FinishVisitor(info)
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitorNotify, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
  end)
end

function VisitorS0AllianceBossVisitor:CancelClick()
  self:OnDelayClick(function()
    if not self.visitorData then
      return
    end
    local info = {
      uid = self.visitorData.uid,
      visitorType = self.visitorData.type,
      operate = 2
    }
    DataCenter.CityVisitorManager:FinishVisitor(info)
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitorNotify, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
  end)
end

function VisitorS0AllianceBossVisitor:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

function VisitorS0AllianceBossVisitor:ClearData()
  base.ClearData(self)
end

return VisitorS0AllianceBossVisitor
