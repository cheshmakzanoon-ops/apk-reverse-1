local PushGhostParkourAllianceBpUpdateMessage = BaseClass("PushGhostParkourAllianceBpUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGhostParkourAllianceBpUpdateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushGhostParkourAllianceBpUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
    if round ~= nil then
      DataCenter.LWGhostParkourDataManager:SendGetGhostParkourAllianceBattlePassMessage(round)
    end
  end
end

return PushGhostParkourAllianceBpUpdateMessage
