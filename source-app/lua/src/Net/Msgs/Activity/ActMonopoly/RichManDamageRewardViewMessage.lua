local RichManDamageRewardViewMessage = BaseClass("RichManDamageRewardViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMonopolyDataManager:SetDamageRewardData(t)
  EventManager:GetInstance():Broadcast(EventId.ActMonopolyBoxRewardDataGet)
end

RichManDamageRewardViewMessage.OnCreate = OnCreate
RichManDamageRewardViewMessage.HandleMessage = HandleMessage
return RichManDamageRewardViewMessage
