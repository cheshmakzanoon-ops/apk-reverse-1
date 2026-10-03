local FarmerIrrigateMessage = BaseClass("FarmerIrrigateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, queueUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("queueUuid", queueUuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local uuid
    if t.queueObj then
      DataCenter.QueueDataManager:UpdateQueueData(t.queueObj, false)
      uuid = t.queueObj.uuid
    end
    if t.irrigationObj then
      DataCenter.PlayerCareerManager:UpdateOneIrrigationInfo(t.irrigationObj)
    end
    if t.resource then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    if uuid then
      DataCenter.CareerEffectManager:RefreshOne(uuid)
    end
  end
end

FarmerIrrigateMessage.OnCreate = OnCreate
FarmerIrrigateMessage.HandleMessage = HandleMessage
return FarmerIrrigateMessage
