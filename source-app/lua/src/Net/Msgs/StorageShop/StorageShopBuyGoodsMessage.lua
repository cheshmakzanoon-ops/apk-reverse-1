local StorageShopBuyGoodsMessage = BaseClass("StorageShopBuyGoodsMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
    self.sfsObj:PutUtfString("uid", param.uid)
    if param.serverId then
      self.sfsObj:PutInt("server", param.serverId)
    end
    if param.itemId then
      self.sfsObj:PutInt("itemId", tonumber(param.itemId))
    end
    if param.price then
      self.sfsObj:PutInt("price", tonumber(param.price))
    end
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if tostring(errCode) == "320302" then
      UIUtil.ShowMessage(Localization:GetString("143612"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, nil, nil, nil, "143613")
      DataCenter.StorageShopManager:OnRecvBuyFail()
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    if t.extraReward then
      DataCenter.RewardManager:AddRewards(t.extraReward)
      for i, v in ipairs(t.extraReward) do
        if v.type == RewardType.GOODS then
          local strName = DataCenter.ItemTemplateManager:GetName(v.value.itemId)
          local count = v.value.rewardAdd
          UIUtil.ShowTips(Localization:GetString("120149", strName, count))
          break
        end
      end
    else
      UIUtil.ShowTipsId(120144)
    end
    DataCenter.PlayerCareerManager:UpdateTraderExtraReward(t)
    DataCenter.StorageShopManager:OnRecvBuySucc(t)
  end
end

StorageShopBuyGoodsMessage.OnCreate = OnCreate
StorageShopBuyGoodsMessage.HandleMessage = HandleMessage
return StorageShopBuyGoodsMessage
