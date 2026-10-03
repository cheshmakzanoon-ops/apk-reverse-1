local UserMoneyRankLogViewMessage = BaseClass("UserMoneyRankLogViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserMoneyRankLogViewMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", param.type)
end

function UserMoneyRankLogViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonMoneyRankManager:OnGetLogCallback(t)
  end
end

return UserMoneyRankLogViewMessage
