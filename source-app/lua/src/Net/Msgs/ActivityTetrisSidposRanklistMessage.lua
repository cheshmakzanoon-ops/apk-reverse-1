local ActivityTetrisSidposRanklistMessage = BaseClass("ActivityTetrisSidposRanklistMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityTetrisSidposRanklistMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("rankType", param.rankType)
  self.sfsObj:PutInt("serverId", param.serverId)
end

function ActivityTetrisSidposRanklistMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonSelectLocationGameManager:OnGetRankCallback(t)
  end
end

return ActivityTetrisSidposRanklistMessage
