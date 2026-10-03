local PostCardReceiveMessage = BaseClass("PostCardReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PostCardReceiveMessage:OnCreate(itemId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", itemId)
end

function PostCardReceiveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local isEnvelopItem = false
    local envelopItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k2")
    if t.itemId ~= nil and t.itemId == tostring(envelopItemId) then
      isEnvelopItem = true
    end
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      if not isEnvelopItem then
        DataCenter.RewardManager:ShowCommonReward(t)
      end
    end
    if t.itemObj ~= nil and t.itemId ~= nil then
      DataCenter.ItemData:UpdateOneItem(t.itemObj)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshBagItems)
    if isEnvelopItem then
      local rewardItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k3")
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(rewardItemId)
      if template == nil then
        return
      end
      local skinId = toInt(template.para1)
      local index = DataCenter.DecorationTemplateManager:GetItemInDecoraitonIndex(skinId, rewardItemId)
      if index then
        DataCenter.DecorationDataManager:CovertSkin(skinId, index)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.OnLetterRewardGet, t)
  end
end

return PostCardReceiveMessage
