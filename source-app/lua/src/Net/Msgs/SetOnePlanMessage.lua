local SetOnePlanMessage = BaseClass("SetOnePlanMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bUuid, product_id)
  base.OnCreate(self)
  if bUuid ~= nil and product_id ~= nil then
    self.sfsObj:PutLong("bUuid", bUuid)
    self.sfsObj:PutInt("product_id", product_id)
    local param = {}
    param.product_id = product_id
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
  else
    if t.resource ~= nil then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
    end
    DataCenter.FactoryDataManager:RefreshFactoryList(t)
    DataCenter.ResourceItemDataManager:RefreshItemList(t)
    EventManager:GetInstance():Broadcast(EventId.AddFactoryProduct)
    if t.foodFactoryObj ~= nil then
      local planZone = t.foodFactoryObj.planZone
      if planZone ~= nil and planZone ~= "" then
        local str = string.split_ss_array(planZone, "|")
        local count = table.count(str)
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.FactoryProductStart, str[count])
      end
    end
  end
end

SetOnePlanMessage.OnCreate = OnCreate
SetOnePlanMessage.HandleMessage = HandleMessage
return SetOnePlanMessage
