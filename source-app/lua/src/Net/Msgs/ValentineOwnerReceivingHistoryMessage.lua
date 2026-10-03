local ValentineOwnerReceivingHistoryMessage = BaseClass("ValentineOwnerReceivingHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, startNum, endNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("start", startNum)
  self.sfsObj:PutInt("end", endNum)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ValentineDataManager:SetActReceiveGiftRecordData(t)
  EventManager:GetInstance():Broadcast(EventId.ValentineReceiveGiftRecordData)
end

ValentineOwnerReceivingHistoryMessage.OnCreate = OnCreate
ValentineOwnerReceivingHistoryMessage.HandleMessage = HandleMessage
return ValentineOwnerReceivingHistoryMessage
