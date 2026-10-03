local MilitaryRankInfoViewMessage = BaseClass("MilitaryRankInfoViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MilitaryRankInfoViewMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("militaryRankId", param.rankType)
  self.sfsObj:PutInt("periodType", param.periodType)
  if param.isLocal then
    self.sfsObj:PutBool("isLocal", param.isLocal)
  end
end

function MilitaryRankInfoViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonMilitaryEliteManager:OnGetRankCallback(DataCenter.SeasonMilitaryEliteManager.RankMode.Full, t)
  end
end

return MilitaryRankInfoViewMessage
