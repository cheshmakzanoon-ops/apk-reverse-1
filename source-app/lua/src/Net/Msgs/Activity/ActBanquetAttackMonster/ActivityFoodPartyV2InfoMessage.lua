local ActivityFoodPartyV2InfoMessage = BaseClass("ActivityFoodPartyV2InfoMessage", SFSBaseMessage)
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
    DataCenter.ActBanquetV2Data:ParseInfo(t.info[1])
    DataCenter.ActBanquetV2Data:ParseTaskDataInfo(t)
    EventManager:GetInstance():Broadcast(EventId.GetActBanquetDetailInfo)
  end
end

ActivityFoodPartyV2InfoMessage.OnCreate = OnCreate
ActivityFoodPartyV2InfoMessage.HandleMessage = HandleMessage
return ActivityFoodPartyV2InfoMessage
