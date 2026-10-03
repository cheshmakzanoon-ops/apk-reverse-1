local LWBeginnerCityEventPageRewardMessage = BaseClass("LWBeginnerCityEventPageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, eventId, page)
  base.OnCreate(self)
  self.sfsObj:PutInt("eventId", eventId)
  self.sfsObj:PutInt("page", page)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.LWBeginnerDirectorManager:UpdateRewardedPage(t)
  end
end

LWBeginnerCityEventPageRewardMessage.OnCreate = OnCreate
LWBeginnerCityEventPageRewardMessage.HandleMessage = HandleMessage
return LWBeginnerCityEventPageRewardMessage
