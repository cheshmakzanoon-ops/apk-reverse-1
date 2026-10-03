local GetFireworksGiftMessage = BaseClass("GetFireworksGiftMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetFireworksGiftMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutUtfString("ownerUid", param.ownerUid)
  self.sfsObj:PutInt("type", param.type)
end

function GetFireworksGiftMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    if errCode == "firework_tips_1016" then
      DataCenter.LWFireworkGiftManager:SetGiftUuidGot(t.uuid)
    end
  else
    DataCenter.LWFireworkGiftManager:OnSelfGetFireworksGift(t)
  end
end

return GetFireworksGiftMessage
