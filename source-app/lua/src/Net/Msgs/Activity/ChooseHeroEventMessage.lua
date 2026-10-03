local ChooseHeroEventMessage = BaseClass("ChooseHeroEventMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, eventId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
  self.sfsObj:PutUtfString("eventId", eventId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityListDataManager:RetEventData(t)
    if t.type == EnumActivity.AllianceCompete.EventType then
      EventManager:GetInstance():Broadcast(EventId.RefreshAllianceArmsUI)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    UIUtil.ShowTipsId(150138)
  end
end

ChooseHeroEventMessage.OnCreate = OnCreate
ChooseHeroEventMessage.HandleMessage = HandleMessage
return ChooseHeroEventMessage
