local ActivityArenaBattleListMessage = BaseClass("ActivityArenaBattleListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errorCode = t.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaBattleList)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaBattleListBack, t)
    DataCenter.LWNewbieArenaV2Manager:SetBattleListDataCache(t)
  end
end

ActivityArenaBattleListMessage.OnCreate = OnCreate
ActivityArenaBattleListMessage.HandleMessage = HandleMessage
return ActivityArenaBattleListMessage
