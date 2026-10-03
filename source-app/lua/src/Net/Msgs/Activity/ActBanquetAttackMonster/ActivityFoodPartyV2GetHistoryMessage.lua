local ActivityFoodPartyV2GetHistoryMessage = BaseClass("ActivityFoodPartyV2GetHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, partyNewId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
  self.sfsObj:PutInt("id", partyNewId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBanquetV2Data:PareseHistoryInfo(t)
    EventManager:GetInstance():Broadcast(EventId.BanquetReceiveBatLogData, tostring(t.aid))
    EventManager:GetInstance():Broadcast(EventId.BanquetSuccessGetStashReward, true)
  end
end

ActivityFoodPartyV2GetHistoryMessage.OnCreate = OnCreate
ActivityFoodPartyV2GetHistoryMessage.HandleMessage = HandleMessage
return ActivityFoodPartyV2GetHistoryMessage
