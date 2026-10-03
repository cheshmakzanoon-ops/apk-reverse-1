local LottoDrawMessage = BaseClass("LottoDrawMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.totalReward ~= nil then
    DataCenter.RewardManager:AddRewards(t.totalReward)
  end
  if t.recordArr ~= nil then
    for i, v in ipairs(t.recordArr) do
      if v.reward ~= nil then
        DataCenter.RewardManager:AddRewards(v.reward)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActLotteryDrawResultMsg, t)
end

LottoDrawMessage.OnCreate = OnCreate
LottoDrawMessage.HandleMessage = HandleMessage
return LottoDrawMessage
