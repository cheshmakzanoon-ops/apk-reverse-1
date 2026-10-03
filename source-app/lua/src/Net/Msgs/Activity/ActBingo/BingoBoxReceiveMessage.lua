local BingoBoxReceiveMessage = BaseClass("BingoBoxReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, type, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.ActBingoDataManager:GetOneBoxReward(t)
    EventManager:GetInstance():Broadcast(EventId.ActBingoBoxGet)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

BingoBoxReceiveMessage.OnCreate = OnCreate
BingoBoxReceiveMessage.HandleMessage = HandleMessage
return BingoBoxReceiveMessage
