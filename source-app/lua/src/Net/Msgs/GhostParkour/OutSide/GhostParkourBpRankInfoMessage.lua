local GhostParkourBpRankInfoMessage = BaseClass("GhostParkourBpRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourBpRankInfoMessage:OnCreate(round)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", round)
end

function GhostParkourBpRankInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SaveGhostParkourBpRankInfo(t)
  end
end

return GhostParkourBpRankInfoMessage
