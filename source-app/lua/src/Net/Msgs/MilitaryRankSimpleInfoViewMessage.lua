local MilitaryRankSimpleInfoViewMessage = BaseClass("MilitaryRankSimpleInfoViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MilitaryRankSimpleInfoViewMessage:OnCreate(param)
  base.OnCreate(self)
  local arr = SFSArray.New()
  for k, v in pairs(param.rankType) do
    arr:AddInt(v)
  end
  self.sfsObj:PutSFSArray("militaryRankIds", arr)
  self.sfsObj:PutInt("periodType", param.periodType)
end

function MilitaryRankSimpleInfoViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonMilitaryEliteManager:OnGetRankCallback(DataCenter.SeasonMilitaryEliteManager.RankMode.Simple, t)
  end
end

return MilitaryRankSimpleInfoViewMessage
