local GetAllAllianceTradeMessage = BaseClass("GetAllAllianceTradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllAllianceTradeMessage:OnCreate(allianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

function GetAllAllianceTradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldAllianceCityDataManager:GetAllAllianceTradeStation(t)
  end
end

return GetAllAllianceTradeMessage
