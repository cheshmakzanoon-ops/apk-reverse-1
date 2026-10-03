local BlueShopDayRewardMessage = BaseClass("BlueShopDayRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function BlueShopDayRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BlueShopDayRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWTitaniumBlueStoreManager:UpdateDailyRewardData(message)
  end
end

return BlueShopDayRewardMessage
