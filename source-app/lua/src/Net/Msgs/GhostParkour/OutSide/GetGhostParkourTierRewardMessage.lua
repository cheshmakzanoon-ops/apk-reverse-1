local GetGhostParkourTierRewardMessage = BaseClass("GetGhostParkourTierRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetGhostParkourTierRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("tier", param.tier)
  self.sfsObj:PutInt("id", param.id)
end

function GetGhostParkourTierRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:UpdateGhostParkourTierRewardInfo(t)
  end
end

return GetGhostParkourTierRewardMessage
