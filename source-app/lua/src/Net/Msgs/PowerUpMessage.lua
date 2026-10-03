local PowerUpMessage = BaseClass("PowerUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PowerUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif LuaEntry.Player then
    LuaEntry.Player:UpdatePowerDataNew(t)
  end
end

return PowerUpMessage
