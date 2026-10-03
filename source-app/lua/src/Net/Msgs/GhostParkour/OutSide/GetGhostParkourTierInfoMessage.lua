local GetGhostParkourTierInfoMessage = BaseClass("GetGhostParkourTierInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetGhostParkourTierInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetGhostParkourTierInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SaveGhostParkourTierInfos(t)
  end
end

return GetGhostParkourTierInfoMessage
