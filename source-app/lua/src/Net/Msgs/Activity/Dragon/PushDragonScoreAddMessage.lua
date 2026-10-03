local PushDragonScoreAddMessage = BaseClass("PushDragonScoreAddMessage", SFSBaseMessage)
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
    DataCenter.ActDragonManager:OnHandleBattleScoreAdd(t)
  end
end

PushDragonScoreAddMessage.OnCreate = OnCreate
PushDragonScoreAddMessage.HandleMessage = HandleMessage
return PushDragonScoreAddMessage
