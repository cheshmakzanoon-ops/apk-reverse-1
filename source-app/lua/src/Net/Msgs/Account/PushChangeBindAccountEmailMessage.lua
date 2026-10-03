local PushChangeBindAccountEmailMessage = BaseClass("PushChangeBindAccountEmailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushChangeBindAccountEmailMessage:OnCreate()
  base.OnCreate(self)
end

function PushChangeBindAccountEmailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local emailExpireTime = t.emailExpireTime
  if not string.IsNullOrEmpty(emailExpireTime) then
    CS.GameEntry.Setting:SetPrivateString("LW_EmailResendExpireTime", tostring(emailExpireTime))
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICreateAccount)
  local verfiyViewType = t.changeType
  local openManageView = DataCenter.AccountScoreManager:CheckAccountIDOpen()
  if not openManageView then
    if verfiyViewType == 1 then
      local account = DataCenter.AccountManager.MailAccount.gameAccount
      if account == "" then
        Logger.LogError("Email\230\141\162\231\187\145\230\151\182\239\188\140\230\156\172\229\156\176\232\174\176\229\189\149\231\154\132\233\130\174\231\174\177\229\177\133\231\132\182\228\184\186\231\169\186\239\188\129")
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify, account, 4)
    elseif verfiyViewType == 2 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify, t.newEmail or "", 5)
    end
  else
    local const = require("DataCenter.AccountScore.AccountScoreConst")
    if verfiyViewType == 1 then
      EventManager:GetInstance():Broadcast(EventId.AccountPushChangeBindAccountEmail, const.ViewState.ShowOldMail)
    elseif verfiyViewType == 2 then
      EventManager:GetInstance():Broadcast(EventId.AccountPushChangeBindAccountEmail, const.ViewState.InputChangeMail)
    end
  end
end

return PushChangeBindAccountEmailMessage
