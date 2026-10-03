local ActivityHeroGetInfoMessage = BaseClass("ActivityHeroGetInfoMessage", SFSBaseMessage)
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
    DataCenter.ActivityPersonalArmsDataManager:UpdateData(t)
    EventManager:GetInstance():Broadcast(EventId.ActivityPersonalArmsUpdate, t.aid)
  end
end

ActivityHeroGetInfoMessage.OnCreate = OnCreate
ActivityHeroGetInfoMessage.HandleMessage = HandleMessage
return ActivityHeroGetInfoMessage
