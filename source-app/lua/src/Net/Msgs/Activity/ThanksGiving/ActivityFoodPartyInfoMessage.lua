local ActivityFoodPartyInfoMessage = BaseClass("ActivityFoodPartyInfoMessage", SFSBaseMessage)
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
    DataCenter.ActBanquetData:ParseInfo(t.info[1])
    EventManager:GetInstance():Broadcast(EventId.GetActBanquetDetailInfo)
  end
end

ActivityFoodPartyInfoMessage.OnCreate = OnCreate
ActivityFoodPartyInfoMessage.HandleMessage = HandleMessage
return ActivityFoodPartyInfoMessage
