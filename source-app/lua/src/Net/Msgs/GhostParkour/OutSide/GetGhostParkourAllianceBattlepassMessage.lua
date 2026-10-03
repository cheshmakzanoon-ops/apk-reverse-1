local GetGhostParkourAllianceBattlepassMessage = BaseClass("GetGhostParkourAllianceBattlepassMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetGhostParkourAllianceBattlepassMessage:OnCreate(round)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", round)
end

function GetGhostParkourAllianceBattlepassMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SaveGhostParkourAllianceBPInfo(t)
  end
end

return GetGhostParkourAllianceBattlepassMessage
