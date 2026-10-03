local LandlordActInfoMessage = BaseClass("LandlordActInfoMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function LandlordActInfoMessage:OnCreate()
  base.OnCreate(self)
end

function LandlordActInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleActInfo(t)
  end
end

return LandlordActInfoMessage
