local BloodyQueenS1RestGainCityOccupationRankFirstInfoMessage = BaseClass("BloodyQueenS1RestGainCityOccupationRankFirstInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodyQueenS1RestGainCityOccupationRankFirstInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function BloodyQueenS1RestGainCityOccupationRankFirstInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.OffSeason1RecaptureManager:SetServerRankFirstInfo(t)
  end
end

return BloodyQueenS1RestGainCityOccupationRankFirstInfoMessage
