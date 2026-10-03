local BlueShopBoxRewardMessage = BaseClass("BlueShopBoxRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function BlueShopBoxRewardMessage:OnCreate(activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("index", index)
end

function BlueShopBoxRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWTitaniumBlueStoreManager:UpdateBoxRewardData(message)
  end
end

return BlueShopBoxRewardMessage
