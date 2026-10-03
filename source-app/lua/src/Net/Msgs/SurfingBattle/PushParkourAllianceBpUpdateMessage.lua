local PushParkourAllianceBpUpdateMessage = BaseClass("PushParkourAllianceBpUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushParkourAllianceBpUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushParkourAllianceBpUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local round = DataCenter.LWSurfingDataManager:GetRound()
    DataCenter.LWSurfingDataManager:SendGetParkourAllianceBattlePassInfoMessage(round)
  end
end

return PushParkourAllianceBpUpdateMessage
