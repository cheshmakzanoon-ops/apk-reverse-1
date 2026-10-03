local GetParkourRankRewardInfoMessage = BaseClass("GetParkourRankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetParkourRankRewardInfoMessage:OnCreate(round, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", round)
  self.sfsObj:PutInt("type", type)
end

function GetParkourRankRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:UpdateSurfingBattleRankRewardInfo(t)
  end
end

return GetParkourRankRewardInfoMessage
