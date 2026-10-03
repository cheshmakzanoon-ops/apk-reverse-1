local PushVerifyBindAccountEmailMessage = BaseClass("PushVerifyBindAccountEmailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushVerifyBindAccountEmailMessage:OnCreate()
  base.OnCreate(self)
end

function PushVerifyBindAccountEmailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local verfiyViewType = t.changeType or 0
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICreateAccount) then
      EventManager:GetInstance():Broadcast(EventId.CreateAccountMailFail)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAccountIdBind) then
      EventManager:GetInstance():Broadcast(EventId.CreateAccountMailFail)
    end
    if verfiyViewType == 1 then
      DataCenter.AccountManager:SetOldEmailVerifyCode("")
    end
    return
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
  if verfiyViewType == 1 then
    local openManageView = DataCenter.AccountScoreManager:CheckAccountIDOpen()
    if not openManageView then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateAccount, 2)
    else
      EventManager:GetInstance():Broadcast(EventId.AccountPushChangeMailVerify)
    end
  elseif verfiyViewType == 2 then
    DataCenter.AccountManager:ChangeBindAccountSuccess(t)
  end
  EventManager:GetInstance():Broadcast(EventId.AccountSettingAnonymityChange)
end

return PushVerifyBindAccountEmailMessage
