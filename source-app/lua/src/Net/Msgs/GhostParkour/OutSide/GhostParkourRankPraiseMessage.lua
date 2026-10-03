local GhostParkourRankPraiseMessage = BaseClass("GhostParkourRankPraiseMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourRankPraiseMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", param.type)
  self.sfsObj:PutUtfString("targetUid", param.targetUid)
end

function GhostParkourRankPraiseMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:UpdateRankPraiseInfo(t)
  end
end

return GhostParkourRankPraiseMessage
