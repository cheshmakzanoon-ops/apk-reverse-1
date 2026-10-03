local FeedAnimalMessage = BaseClass("FeedAnimalMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, queueList)
  base.OnCreate(self)
  if queueList ~= nil then
    local array = SFSArray.New()
    table.walk(queueList, function(k, v)
      array:AddLong(v)
    end)
    self.sfsObj:PutSFSArray("queueList", array)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.FeedAnim, true)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.GetAnim, true)
    local param = {}
    param.stateType = FarmStateType.Feed
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    DataCenter.GuideManager:CheckGuideComplete()
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.FeedAnim, nil)
  else
    if t.queueObjList ~= nil then
      local itemId = 0
      table.walk(t.queueObjList, function(k, v)
        DataCenter.QueueDataManager:UpdateQueueData(v)
        if v.uuid ~= nil then
          local uuid = v.uuid
          DataCenter.QueueDataManager:SetFinishFlag(uuid, nil)
          EventManager:GetInstance():Broadcast(EventId.BuildResourcesSecond, uuid)
        end
        if v.itemObj ~= nil then
          local temp = v.itemObj
          if temp.itemId ~= nil then
            itemId = temp.itemId
          end
        end
      end)
      local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(itemId)
      if functionTemplate ~= nil then
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.FEED, Localization:GetString(functionTemplate.product_name)))
      end
      if t.resource ~= nil then
        LuaEntry.Resource:UpdateResource(t.resource)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.FeedAnim, nil)
  end
end

FeedAnimalMessage.OnCreate = OnCreate
FeedAnimalMessage.HandleMessage = HandleMessage
return FeedAnimalMessage
