local DetectEventBatchPutPointInWorldMessage = BaseClass("DetectEventBatchPutPointInWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuidList)
  base.OnCreate(self)
  if table.IsNullOrEmpty(uuidList) then
    return
  end
  local sendData = ""
  for k, v in ipairs(uuidList) do
    if 1 < k then
      sendData = sendData .. "|"
    end
    sendData = sendData .. v
  end
  self.sfsObj:PutUtfString("uuidList", sendData)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    for _, v in pairs(t.array) do
      DataCenter.RadarCenterDataManager:UpdateOneDetectEventInfo(v)
    end
    EventManager:GetInstance():Broadcast(EventId.DetectEventGetBatchRealPoint)
  end
end

DetectEventBatchPutPointInWorldMessage.OnCreate = OnCreate
DetectEventBatchPutPointInWorldMessage.HandleMessage = HandleMessage
return DetectEventBatchPutPointInWorldMessage
