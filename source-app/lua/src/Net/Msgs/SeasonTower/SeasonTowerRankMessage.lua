local SeasonTowerRankMessage = BaseClass("SeasonTowerRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonTowerRankMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageId", param.stageId)
end

function SeasonTowerRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSeasonTowerManager:ParseRankingData(t)
  end
end

return SeasonTowerRankMessage
