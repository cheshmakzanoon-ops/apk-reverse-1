local GetHeroMonthCardRewardMessage = BaseClass("GetHeroMonthCardRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, day)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  if day ~= nil then
    self.sfsObj:PutLong("day", day)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.HeroMonthCardManager:DoWhenGetRewardBack(message)
end

GetHeroMonthCardRewardMessage.OnCreate = OnCreate
GetHeroMonthCardRewardMessage.HandleMessage = HandleMessage
return GetHeroMonthCardRewardMessage
