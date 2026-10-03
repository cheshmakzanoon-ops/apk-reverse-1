local PushBloodyQueenS1RestGainCityOccupationRankFirstInfoMessage = BaseClass("PushBloodyQueenS1RestGainCityOccupationRankFirstInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBloodyQueenS1RestGainCityOccupationRankFirstInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBloodyQueenS1RestGainCityOccupationRankFirstInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.OffSeason1RecaptureManager:SetServerRankFirstInfo(t)
  end
end

return PushBloodyQueenS1RestGainCityOccupationRankFirstInfoMessage
