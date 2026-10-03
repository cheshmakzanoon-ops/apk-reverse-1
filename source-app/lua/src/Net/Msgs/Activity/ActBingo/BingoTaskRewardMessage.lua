local BingoTaskRewardMessage = BaseClass("BingoTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("taskId", taskId)
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
    DataCenter.ActBingoDataManager:GetOneTaskReward(t)
    EventManager:GetInstance():Broadcast(EventId.ActBingoTaskDataUpdate)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.ActBingoTaskReward, t)
  end
end

BingoTaskRewardMessage.OnCreate = OnCreate
BingoTaskRewardMessage.HandleMessage = HandleMessage
return BingoTaskRewardMessage
