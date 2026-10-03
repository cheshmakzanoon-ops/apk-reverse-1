local PushGetGoogleIdMessage = BaseClass("PushGetGoogleIdMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGetGoogleIdMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushGetGoogleIdMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local success = t.success
    if success then
      local google_id = t.google_id
      local google_name = t.google_name
      Logger.LogError("[GooglePlayManager]\230\148\182\229\136\176PushGetGoogleIdMessage\229\141\143\232\174\174\228\186\134 google_id:" .. google_id .. " google_name:" .. google_name)
      DataCenter.AccountManager:OnGetGoogleIdSuccess(google_id, google_name)
    else
      local need_auth_code = t.need_auth_code
      Logger.LogError("[GooglePlayManager]PushGetGoogleIdMessage\229\141\143\232\174\174\232\191\148\229\155\158\229\164\177\232\180\165 need_auth_code:" .. tostring(need_auth_code))
    end
  end
end

return PushGetGoogleIdMessage
