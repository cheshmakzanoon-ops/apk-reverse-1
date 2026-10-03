local DigTreasureGameInfoMessage = BaseClass("DigTreasureGameInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DigTreasureGameInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function DigTreasureGameInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.DigTreasureManager:OnGetDigTreasureData(t)
  end
end

return DigTreasureGameInfoMessage
