local PushLandlordBattleCityNoticeMessage = BaseClass("PushLandlordBattleCityNoticeMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function PushLandlordBattleCityNoticeMessage:OnCreate()
  base.OnCreate(self)
end

function PushLandlordBattleCityNoticeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleBattleCityNotice(t)
  end
end

return PushLandlordBattleCityNoticeMessage
