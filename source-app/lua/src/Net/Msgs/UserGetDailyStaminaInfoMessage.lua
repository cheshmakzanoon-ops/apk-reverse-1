local UserGetDailyStaminaInfoMessage = BaseClass("UserGetDailyStaminaInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserGetDailyStaminaInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function UserGetDailyStaminaInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.todayFreeStamina == nil then
      t.todayFreeStamina = 0
    end
    LuaEntry.Player:UpdateClaimFreeStamina(t)
  end
end

return UserGetDailyStaminaInfoMessage
