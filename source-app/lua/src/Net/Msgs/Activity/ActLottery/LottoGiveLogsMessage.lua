local LottoGiveLogsMessage = BaseClass("LottoGiveLogsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, startNUm, endNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  if startNUm ~= nil and endNum ~= nil then
    self.sfsObj:PutInt("start", startNUm)
    self.sfsObj:PutInt("end", endNum)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActLotteryDataManager:SetGiveLogs(t)
  EventManager:GetInstance():Broadcast(EventId.ActLotteryGiveLogs)
end

LottoGiveLogsMessage.OnCreate = OnCreate
LottoGiveLogsMessage.HandleMessage = HandleMessage
return LottoGiveLogsMessage
