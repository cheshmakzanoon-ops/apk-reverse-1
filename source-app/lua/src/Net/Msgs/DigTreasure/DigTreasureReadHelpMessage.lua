local DigTreasureReadHelpMessage = BaseClass("DigTreasureReadHelpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DigTreasureReadHelpMessage:OnCreate(param)
  base.OnCreate(self)
end

function DigTreasureReadHelpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return DigTreasureReadHelpMessage
