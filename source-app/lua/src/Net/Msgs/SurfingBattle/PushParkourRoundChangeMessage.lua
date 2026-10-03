local PushParkourRoundChangeMessage = BaseClass("PushParkourRoundChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushParkourRoundChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushParkourRoundChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:RefreshActivityInfoByRound(t)
  end
end

return PushParkourRoundChangeMessage
