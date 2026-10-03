local UserDayActReward = BaseClass("UserDayActReward", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  else
    local info = DataCenter.ActivityListDataManager:GetSevenDayList()
    if info ~= nil then
      info:SetScoreBoxState(message.index, 1)
      info:CheckRedDot()
    end
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
    EventManager:GetInstance():Broadcast(EventId.SevenDayGetReward)
  end
end

UserDayActReward.OnCreate = OnCreate
UserDayActReward.HandleMessage = HandleMessage
return UserDayActReward
