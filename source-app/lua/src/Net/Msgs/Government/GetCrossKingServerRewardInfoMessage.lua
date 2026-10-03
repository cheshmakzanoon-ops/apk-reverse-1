local GetCrossKingServerRewardInfoMessage = BaseClass("GetCrossKingServerRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossKingServerRewardInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetCrossKingServerRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ZoneWarManager:SetCrossKingServerRewardInfo(t)
end

return GetCrossKingServerRewardInfoMessage
