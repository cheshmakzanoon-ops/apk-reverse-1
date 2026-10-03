local GhostParkourRankInfoMessage = BaseClass("GhostParkourRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourRankInfoMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", param.round)
  self.sfsObj:PutInt("type", param.type)
  self.sfsObj:PutInt("start", param.start)
  self.sfsObj:PutInt("end", param.endNum)
end

function GhostParkourRankInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SaveGhostParkourTypeRankInfo(t)
  end
end

return GhostParkourRankInfoMessage
