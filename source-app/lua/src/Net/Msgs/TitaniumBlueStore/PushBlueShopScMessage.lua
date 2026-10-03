local PushBlueShopSc = BaseClass("PushBlueShopSc", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushBlueShopSc:OnCreate()
  base.OnCreate(self)
end

function PushBlueShopSc:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWTitaniumBlueStoreManager:UpdateTotalScoreData(message)
  end
end

return PushBlueShopSc
