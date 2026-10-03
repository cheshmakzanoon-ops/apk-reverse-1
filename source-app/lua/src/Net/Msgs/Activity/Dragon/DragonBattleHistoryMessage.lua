local DragonBattleHistoryMessage = BaseClass("DragonBattleHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDragonManager:HandleBattleHistory(t)
  end
end

DragonBattleHistoryMessage.OnCreate = OnCreate
DragonBattleHistoryMessage.HandleMessage = HandleMessage
return DragonBattleHistoryMessage
