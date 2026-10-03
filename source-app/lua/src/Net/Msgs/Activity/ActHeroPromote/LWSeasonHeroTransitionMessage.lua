local LWSeasonHeroTransitionMessage = BaseClass("LWSeasonHeroTransitionMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, heroUuid, activityId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", heroUuid)
  self.sfsObj:PutInt("act_id", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local heroId = t.hero_id
  EventManager:GetInstance():Broadcast(EventId.LWSeasonHeroPromote, heroId)
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonMainEntranceRedPoint)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonHeroPromoteTabRedPoint)
  end
end

LWSeasonHeroTransitionMessage.OnCreate = OnCreate
LWSeasonHeroTransitionMessage.HandleMessage = HandleMessage
return LWSeasonHeroTransitionMessage
