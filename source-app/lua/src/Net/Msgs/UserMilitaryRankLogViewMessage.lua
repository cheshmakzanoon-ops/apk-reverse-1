local UserMilitaryRankLogViewMessage = BaseClass("UserMilitaryRankLogViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserMilitaryRankLogViewMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", param.type)
end

function UserMilitaryRankLogViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonMilitaryEliteManager:OnGetLogCallback(t)
  end
end

return UserMilitaryRankLogViewMessage
