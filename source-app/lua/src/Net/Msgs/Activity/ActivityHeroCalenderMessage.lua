local ActivityHeroCalenderMessage = BaseClass("ActivityHeroCalenderMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityPersonalArmsDataManager:UpdateCalenderData(t)
    EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsCalenderUpdate, t.aid)
  end
end

ActivityHeroCalenderMessage.OnCreate = OnCreate
ActivityHeroCalenderMessage.HandleMessage = HandleMessage
return ActivityHeroCalenderMessage
