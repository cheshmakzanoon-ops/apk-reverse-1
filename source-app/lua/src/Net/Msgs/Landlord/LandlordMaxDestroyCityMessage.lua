local LandlordMaxDestroyCityMessage = BaseClass("LandlordMaxDestroyCityMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function LandlordMaxDestroyCityMessage:OnCreate()
  base.OnCreate(self)
end

function LandlordMaxDestroyCityMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:OnHandleMaxDestroyCity(t)
  end
end

return LandlordMaxDestroyCityMessage
