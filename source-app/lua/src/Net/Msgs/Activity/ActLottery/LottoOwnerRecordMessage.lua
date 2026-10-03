local LottoOwnerRecordMessage = BaseClass("LottoOwnerRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActLotteryDataManager:SetOwnerRecord(t)
  EventManager:GetInstance():Broadcast(EventId.ActLotteryOwnerRecordMsg)
end

LottoOwnerRecordMessage.OnCreate = OnCreate
LottoOwnerRecordMessage.HandleMessage = HandleMessage
return LottoOwnerRecordMessage
