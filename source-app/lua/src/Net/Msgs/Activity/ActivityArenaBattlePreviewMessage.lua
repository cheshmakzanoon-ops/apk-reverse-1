local ActivityArenaBattlePreviewMessage = BaseClass("ActivityArenaBattlePreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, rank)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  if rank then
    self.sfsObj:PutInt("rank", tonumber(rank))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaBattlePreview)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaBattlePreviewBack, t)
  end
end

ActivityArenaBattlePreviewMessage.OnCreate = OnCreate
ActivityArenaBattlePreviewMessage.HandleMessage = HandleMessage
return ActivityArenaBattlePreviewMessage
