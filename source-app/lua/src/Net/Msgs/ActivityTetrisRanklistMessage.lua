local ActivityTetrisRanklistMessage = BaseClass("ActivityTetrisRanklistMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityTetrisRanklistMessage:OnCreate(param)
  base.OnCreate(self)
end

function ActivityTetrisRanklistMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTetrisManager:UpdateRank(t)
  end
end

return ActivityTetrisRanklistMessage
