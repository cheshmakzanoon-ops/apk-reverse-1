local LandlordGetTargetActInfoMessage = BaseClass("LandlordGetTargetActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function LandlordGetTargetActInfoMessage:OnCreate(targetServerId)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetServerId", targetServerId)
end

function LandlordGetTargetActInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
    t = nil
  end
  EventManager:GetInstance():Broadcast(EventId.LandlordTargetServerActInfoUpdate, t)
end

return LandlordGetTargetActInfoMessage
