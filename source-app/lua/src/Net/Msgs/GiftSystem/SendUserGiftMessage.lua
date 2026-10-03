local SendUserGiftMessage = BaseClass("SendUserGiftMessage", SFSBaseMessage)
local base = SFSBaseMessage
local itemId, isAnonymous

function SendUserGiftMessage:OnCreate(param)
  base.OnCreate(self)
  itemId = param.itemId
  isAnonymous = param.isAnonymous
  self.sfsObj:PutUtfString("targetUid", param.targetUid)
  self.sfsObj:PutInt("itemId", param.itemId)
  self.sfsObj:PutLong("num", param.num)
  self.sfsObj:PutUtfString("context", param.context)
  self.sfsObj:PutInt("isAnonymous", param.isAnonymous and 1 or 0)
  self.sfsObj:PutLong("returnGiftUuid", param.returnGiftUuid or 0)
  self.sfsObj:PutInt("activityId", param.activityId or 0)
  self.sfsObj:PutInt("fromType", param.fromType or 0)
end

function SendUserGiftMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
  else
    if t.itemId == nil then
      t.itemId = itemId
    end
    if t.isAnonymous == nil then
      t.isAnonymous = isAnonymous
    end
    DataCenter.GiftSystemManager:HandleSendGift(t)
    if t.reward then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.ValentineDataManager:SetActSendGiftRecordDataDirty(t)
    DataCenter.ValentineDataManager:CacheOtherPlayerGiftHotAdd(t)
    DataCenter.GiftDetailShowDataManager:OnGetSendGiftMsg(t)
    EventManager:GetInstance():Broadcast(EventId.OnSendUserGiftMsgBack)
  end
end

return SendUserGiftMessage
