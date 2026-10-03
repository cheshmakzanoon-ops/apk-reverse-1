local PushValentineGroupServerRankMessage = BaseClass("PushValentineGroupServerRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushValentineGroupServerRankMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushValentineGroupServerRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ValentineDataManager:UpdateRankData(ValentineRankType.ZoneServer, t)
  end
end

return PushValentineGroupServerRankMessage
