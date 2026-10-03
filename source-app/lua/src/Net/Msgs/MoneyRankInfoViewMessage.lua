local MoneyRankInfoViewMessage = BaseClass("MoneyRankInfoViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MoneyRankInfoViewMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("rankType", param.rankType)
  self.sfsObj:PutInt("periodType", param.periodType)
end

function MoneyRankInfoViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonMoneyRankManager:OnGetRankCallback(DataCenter.SeasonMoneyRankManager.RankMode.Full, t)
  end
end

return MoneyRankInfoViewMessage
