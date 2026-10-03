local BloodyQueenS1RestChooseCityDefendGainMessage = BaseClass("BloodyQueenS1RestChooseCityDefendGainMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodyQueenS1RestChooseCityDefendGainMessage:OnCreate(cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
end

function BloodyQueenS1RestChooseCityDefendGainMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.OffSeason1QueenOfBloodManager:QueenOfBloodRefreshAllianceListMessage(t)
  end
end

return BloodyQueenS1RestChooseCityDefendGainMessage
