local ActivityArenaPushBattleListMessage = BaseClass("ActivityArenaPushBattleListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errorCode = t.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaPushBattleList)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaBattleListPush, t)
  end
end

ActivityArenaPushBattleListMessage.OnCreate = OnCreate
ActivityArenaPushBattleListMessage.HandleMessage = HandleMessage
return ActivityArenaPushBattleListMessage
