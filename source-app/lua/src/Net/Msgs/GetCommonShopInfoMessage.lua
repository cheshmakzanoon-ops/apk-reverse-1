local GetCommonShopInfoMessage = BaseClass("GetCommonShopInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, shopType)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", shopType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CommonShopManager:UpdateOneShopInfo(t)
  end
end

GetCommonShopInfoMessage.OnCreate = OnCreate
GetCommonShopInfoMessage.HandleMessage = HandleMessage
return GetCommonShopInfoMessage
