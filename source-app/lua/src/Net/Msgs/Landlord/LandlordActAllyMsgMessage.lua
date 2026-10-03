local LandlordActAllyMsgMessage = BaseClass("LandlordActAllyMsgMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function LandlordActAllyMsgMessage:OnCreate(msg)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("msg", msg)
end

function LandlordActAllyMsgMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleActAllyMsg(t)
  end
end

return LandlordActAllyMsgMessage
