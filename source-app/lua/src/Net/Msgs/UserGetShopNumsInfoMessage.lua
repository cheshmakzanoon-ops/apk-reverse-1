local UserGetShopNumsInfoMessage = BaseClass("UserGetShopNumsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, types)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("types", types)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CommonShopManager:SetShopGoodsNum(t)
    EventManager:GetInstance():Broadcast(EventId.GetShopNumsInfoMsg)
  end
end

UserGetShopNumsInfoMessage.OnCreate = OnCreate
UserGetShopNumsInfoMessage.HandleMessage = HandleMessage
return UserGetShopNumsInfoMessage
