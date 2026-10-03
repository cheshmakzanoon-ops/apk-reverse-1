local GetParkourRankInfoMessage = BaseClass("GetParkourRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetParkourRankInfoMessage:OnCreate(round, type, start, endNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", round)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("start", start)
  self.sfsObj:PutInt("end", endNum)
end

function GetParkourRankInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:UpdateSurfingBattleRankInfo(t)
  end
end

return GetParkourRankInfoMessage
