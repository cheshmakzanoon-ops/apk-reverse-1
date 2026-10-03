local SendUserReceiveGiftMessage = BaseClass("SendUserReceiveGiftMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SendUserReceiveGiftMessage:OnCreate(itemId, targetUid, recordType, uuid, group)
  base.OnCreate(self)
  if itemId then
    self.sfsObj:PutInt("itemId", itemId)
  end
  if targetUid then
    self.sfsObj:PutUtfString("targetUid", targetUid)
  end
  if recordType then
    self.sfsObj:PutInt("recordType", recordType)
  end
  if uuid then
    self.sfsObj:PutUtfString("uuid", uuid)
  end
  if group then
    self.sfsObj:PutInt("group", group)
  end
end

function SendUserReceiveGiftMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
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

return SendUserReceiveGiftMessage
