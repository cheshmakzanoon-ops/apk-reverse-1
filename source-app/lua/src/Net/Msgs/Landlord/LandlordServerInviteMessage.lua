local LandlordServerInviteMessage = BaseClass("LandlordServerInviteMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function LandlordServerInviteMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", param.serverId)
  if param.giftId then
    self.sfsObj:PutInt("giftId", param.giftId)
  end
  if param.giftNum then
    self.sfsObj:PutInt("giftNum", param.giftNum)
  end
  if param.giftContext then
    self.sfsObj:PutUtfString("giftContext", param.giftContext)
  end
  if param.msg then
    self.sfsObj:PutUtfString("msg", param.msg)
  end
end

function LandlordServerInviteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleServerInvite(t)
  end
end

return LandlordServerInviteMessage
