local LwSeasonResRqInfoMessage = BaseClass("LwSeasonResRqInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local idsStr = ""
  if t.ids then
    for i, v in ipairs(t.ids) do
      idsStr = idsStr .. "," .. v
      LuaEntry.Player:AddUnpackResourceReward(v)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.LWUnpackResourceRewardUpdate)
end

LwSeasonResRqInfoMessage.OnCreate = OnCreate
LwSeasonResRqInfoMessage.HandleMessage = HandleMessage
return LwSeasonResRqInfoMessage
