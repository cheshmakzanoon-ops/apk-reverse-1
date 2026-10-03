local ValentineOpenBoxMessage = BaseClass("ValentineOpenBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineOpenBoxMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutInt("boxItemId", param.boxItemId)
  self.sfsObj:PutInt("num", param.num)
end

function ValentineOpenBoxMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local function closeFunc()
      DataCenter.ValentineDataManager:OnOpenBoxSuccess(t)
    end
    
    if t.reward then
      DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, closeFunc)
    end
    if t.starRewardNum then
      DataCenter.ValentineDataManager:UpdateTargetActivityStarRewardNum(toInt(t.activityId), toInt(t.starRewardNum))
    end
    DataCenter.ValentineDataManager:UpdateReceiveTotalReward(t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return ValentineOpenBoxMessage
