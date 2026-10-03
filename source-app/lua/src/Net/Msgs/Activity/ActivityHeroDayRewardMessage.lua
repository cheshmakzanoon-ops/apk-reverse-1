local ActivityHeroDayRewardMessage = BaseClass("ActivityHeroDayRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityPersonalArmsDataManager:DailyRewardGet(t)
    EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsUpdate, t.aid)
  end
end

ActivityHeroDayRewardMessage.OnCreate = OnCreate
ActivityHeroDayRewardMessage.HandleMessage = HandleMessage
return ActivityHeroDayRewardMessage
