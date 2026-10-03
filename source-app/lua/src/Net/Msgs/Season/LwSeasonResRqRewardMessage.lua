local LwSeasonResRqRewardMessage = BaseClass("LwSeasonResRqRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, resId)
  base.OnCreate(self)
  self.sfsObj:PutLong("resId", toInt(resId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.resId then
    LuaEntry.Player:AddUnpackResourceReward(t.resId)
    EventManager:GetInstance():Broadcast(EventId.LWUnpackResourceRewardUpdate)
  end
end

LwSeasonResRqRewardMessage.OnCreate = OnCreate
LwSeasonResRqRewardMessage.HandleMessage = HandleMessage
return LwSeasonResRqRewardMessage
