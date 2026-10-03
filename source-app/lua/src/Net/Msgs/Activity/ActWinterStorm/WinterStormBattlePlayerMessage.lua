local WinterStormBattlePlayerMessage = BaseClass("WinterStormBattlePlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

WinterStormBattlePlayerMessage.OnCreate = OnCreate
WinterStormBattlePlayerMessage.HandleMessage = HandleMessage
return WinterStormBattlePlayerMessage
