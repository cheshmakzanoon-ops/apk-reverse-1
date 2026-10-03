local ScoreWebLoginInfoMessage = BaseClass("ScoreWebLoginInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ScoreWebLoginInfoMessage:OnCreate(uuid)
  base.OnCreate(self)
end

function ScoreWebLoginInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AccountScoreManager:UpdateAccountScoreData(t)
  end
end

return ScoreWebLoginInfoMessage
