local FarmFarmingMessage = BaseClass("FarmFarmingMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, queueList, product_ID)
  base.OnCreate(self)
  if queueList ~= nil then
    local array = SFSArray.New()
    table.walk(queueList, function(k, v)
      array:AddLong(v)
    end)
    self.sfsObj:PutSFSArray("queueList", array)
    self.sfsObj:PutInt("product_ID", product_ID)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.PlantAnim, true)
    local param = {}
    param.stateType = FarmStateType.Plant
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    DataCenter.GuideManager:CheckGuideComplete()
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.PlantAnim, nil)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
  else
    if t.queueObjList ~= nil then
      local functionId = ""
      table.walk(t.queueObjList, function(k, v)
        DataCenter.QueueDataManager:UpdateQueueData(v)
        if v.uuid ~= nil then
          local qUuid = v.uuid
        end
        if v.funcUuid ~= nil then
          local buildUuid = v.funcUuid
          EventManager:GetInstance():Broadcast(EventId.BuildResourcesStart, buildUuid)
          if v.itemObj ~= nil then
            local temp = v.itemObj
            if temp.itemId ~= nil then
              functionId = temp.itemId
            end
          end
        end
      end)
      local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
      if functionTemplate == nil or functionTemplate.build_id == BuildingTypes.APS_BUILD_FARM_FIELD then
      elseif functionTemplate.build_id == BuildingTypes.APS_BUILD_PASTURE_FIELD then
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.FEED, Localization:GetString(functionTemplate.product_name)), "", MessageBarType.Cost)
      end
      if t.resource ~= nil then
        LuaEntry.Resource:UpdateResource(t.resource)
      end
      if t.gold ~= nil then
        LuaEntry.Player.gold = t.gold
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
      end
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.FarmPlantStart, tostring(functionId))
    end
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
  end
end

FarmFarmingMessage.OnCreate = OnCreate
FarmFarmingMessage.HandleMessage = HandleMessage
return FarmFarmingMessage
