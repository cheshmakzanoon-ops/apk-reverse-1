local PlayerMonthPayInfoMessage = BaseClass("PlayerMonthPayInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    LuaEntry.Player.payMonthlyDollarTotal = t.payMonthlyDollarTotal
  end
end

PlayerMonthPayInfoMessage.OnCreate = OnCreate
PlayerMonthPayInfoMessage.HandleMessage = HandleMessage
return PlayerMonthPayInfoMessage
