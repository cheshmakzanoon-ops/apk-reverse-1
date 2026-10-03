local FetchAllianceMemberDevotesRankMessage = BaseClass("FetchAllianceMemberDevotesRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceMemberDevotesRankMessage:OnCreate()
  base.OnCreate(self)
end

function FetchAllianceMemberDevotesRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonRewardDataManager:UpdateAllianceMemberDevotesRank(t)
end

return FetchAllianceMemberDevotesRankMessage
