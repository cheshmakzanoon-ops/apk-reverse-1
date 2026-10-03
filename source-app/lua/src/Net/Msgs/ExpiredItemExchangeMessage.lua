local ExpiredItemExchangeMessage = BaseClass("ExpiredItemExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, itemId, count)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("goodsId", tostring(itemId))
  self.sfsObj:PutInt("num", count)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    EventManager:GetInstance():Broadcast(EventId.ExpiredItemExchangeSuccess, t)
  end
end

ExpiredItemExchangeMessage.OnCreate = OnCreate
ExpiredItemExchangeMessage.HandleMessage = HandleMessage
return ExpiredItemExchangeMessage
