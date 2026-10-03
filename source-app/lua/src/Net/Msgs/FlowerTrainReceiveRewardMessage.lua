local FlowerTrainReceiveRewardMessage = BaseClass("FlowerTrainReceiveRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local _sendType = 0

function FlowerTrainReceiveRewardMessage:OnCreate(trainUuid, sendType)
  base.OnCreate(self)
  _sendType = sendType
  self.sfsObj:PutLong("trainUuid", trainUuid)
end

function FlowerTrainReceiveRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:AddRewards(t.reward)
    end
    local trainData
    if t.train then
      local flowerTrainUuid = t.train.uuid
      trainData = DataCenter.FlowerTrainDataManager:GetPlayerSelfFlowerTrainData(flowerTrainUuid)
      trainData:UpdateData(t.train)
      DataCenter.FlowerTrainDataManager:RemoveSelfFlowerTrainData(flowerTrainUuid)
    end
    local params = {}
    params.reward = DataCenter.RewardManager:ReturnRewardParamForMessage(t.reward)
    params.trainData = trainData
    params.topPlayerArr = t.topPlayerArr
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainArrived, {anim = true}, params)
    EventManager:GetInstance():Broadcast(EventId.FlowerTrainGetFinishReward)
    PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Show_Arrive_Panel, {share_type = _sendType})
  end
end

return FlowerTrainReceiveRewardMessage
