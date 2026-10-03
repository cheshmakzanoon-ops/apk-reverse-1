local AlRankRewardMessage = BaseClass("AlRankRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceDonateRankDataManager:UpdateData(t)
  end
  EventManager:GetInstance():Broadcast(EventId.GetAlDonateRankRewardGet)
end

AlRankRewardMessage.OnCreate = OnCreate
AlRankRewardMessage.HandleMessage = HandleMessage
return AlRankRewardMessage
