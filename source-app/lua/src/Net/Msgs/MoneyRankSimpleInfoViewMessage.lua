local MoneyRankSimpleInfoViewMessage = BaseClass("MoneyRankSimpleInfoViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MoneyRankSimpleInfoViewMessage:OnCreate(param)
  base.OnCreate(self)
  local arr = SFSArray.New()
  for k, v in pairs(param.rankType) do
    arr:AddInt(v)
  end
  self.sfsObj:PutSFSArray("rankTypeArr", arr)
  self.sfsObj:PutInt("periodType", param.periodType)
end

function MoneyRankSimpleInfoViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonMoneyRankManager:OnGetRankCallback(DataCenter.SeasonMoneyRankManager.RankMode.Simple, t)
  end
end

return MoneyRankSimpleInfoViewMessage
