local SlotsHistoryLogMessage = BaseClass("SlotsHistoryLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, dayNum, startNum, endNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("dayNum", dayNum)
  self.sfsObj:PutInt("start", startNum)
  self.sfsObj:PutInt("end", endNum)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActSlotMachineDataManager:SetHistoryLogData(t)
    EventManager:GetInstance():Broadcast(EventId.OnGetSlotsHistoryLogData, t.activityId)
  end
end

SlotsHistoryLogMessage.OnCreate = OnCreate
SlotsHistoryLogMessage.HandleMessage = HandleMessage
return SlotsHistoryLogMessage
