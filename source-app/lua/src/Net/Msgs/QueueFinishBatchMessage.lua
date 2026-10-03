local QueueFinishBatchMessage = BaseClass("QueueFinishBatchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, queueList, paraState)
  base.OnCreate(self)
  if queueList ~= nil then
    local array = SFSArray.New()
    table.walk(queueList, function(k, v)
      array:AddLong(v)
    end)
    self.sfsObj:PutSFSArray("queueList", array)
    if paraState == QueueProductState.DEFAULT then
      DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.PlantFarm, true)
    elseif paraState == QueueProductState.PASTURE_MATURE then
      DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.GetAnim, true)
    end
    local param = {}
    param.stateType = FarmStateType.HarvestSecond
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    DataCenter.GuideManager:CheckGuideComplete()
  end
  if paraState ~= nil then
    self.sfsObj:PutInt("paraState", paraState)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    if t.errorCode == "120227" then
      DataCenter.ResourceItemDataManager:DoWhenStorageMaxError()
    end
    return
  end
  DataCenter.QueueDataManager:QueueFinishBatchHandle(t)
end

QueueFinishBatchMessage.OnCreate = OnCreate
QueueFinishBatchMessage.HandleMessage = HandleMessage
return QueueFinishBatchMessage
