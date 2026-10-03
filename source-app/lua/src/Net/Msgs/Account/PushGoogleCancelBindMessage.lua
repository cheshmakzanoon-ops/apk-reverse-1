local PushGoogleCancelBindMessage = BaseClass("PushGoogleCancelBindMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGoogleCancelBindMessage:OnCreate()
  base.OnCreate(self)
end

function PushGoogleCancelBindMessage:HandleMessage(t)
  Logger.LogError("\230\148\182\229\136\176\229\141\143\232\174\174\228\186\134")
  base.HandleMessage(self, t)
  if t.errorCode then
    Logger.LogError("\232\167\163\231\187\145\229\164\177\232\180\165\228\186\134")
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  Logger.LogError("\232\167\163\231\187\145\230\136\144\229\138\159\228\186\134")
  DataCenter.AccountManager:SetAccountChangeBindExp(tonumber(t.accountChangeBindCd))
  DataCenter.AccountManager:GoogleCancelBindRefresh()
  EventManager:GetInstance():Broadcast(EventId.AccountSettingAnonymityChange)
end

return PushGoogleCancelBindMessage
