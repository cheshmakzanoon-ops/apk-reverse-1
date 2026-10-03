local GhostParkourRankRewardInfoMessage = BaseClass("GhostParkourRankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourRankRewardInfoMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", param.round)
  self.sfsObj:PutInt("type", param.type)
end

function GhostParkourRankRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SaveTypeRankRewardInfos(t)
  end
end

return GhostParkourRankRewardInfoMessage
