local GetParkourAllianceBattlePassMessage = BaseClass("GetParkourAllianceBattlePassMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetParkourAllianceBattlePassMessage:OnCreate(round)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", round)
end

function GetParkourAllianceBattlePassMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:UpdateAllianceBattleInfo(t)
  end
end

return GetParkourAllianceBattlePassMessage
