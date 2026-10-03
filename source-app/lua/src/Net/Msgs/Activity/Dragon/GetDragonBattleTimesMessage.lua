local GetDragonBattleTimesMessage = BaseClass("GetDragonBattleTimesMessage", SFSBaseMessage)
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
    DataCenter.ActDragonManager:HandleGetBattleTime(t)
  end
end

GetDragonBattleTimesMessage.OnCreate = OnCreate
GetDragonBattleTimesMessage.HandleMessage = HandleMessage
return GetDragonBattleTimesMessage
