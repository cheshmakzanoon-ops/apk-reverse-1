local GatherProductMessage = BaseClass("GatherProductMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bUuid, productPosList)
  base.OnCreate(self)
  if bUuid ~= nil and productPosList ~= nil then
    local array = SFSArray.New()
    table.walk(productPosList, function(k, v)
      array:AddInt(v)
    end)
    self.sfsObj:PutSFSArray("product_zone_pos_list", array)
    self.sfsObj:PutLong("bUuid", bUuid)
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
    DataCenter.FactoryDataManager:RefreshFactoryList(t)
    DataCenter.ResourceItemDataManager:RefreshItemList(t)
    if t.foodFactoryObj ~= nil then
      local data = t.foodFactoryObj
      local bUuid = data.bUuid
      if bUuid ~= nil then
        EventManager:GetInstance():Broadcast(EventId.GetAllProduct, bUuid)
        DataCenter.FactoryDataManager:ResetEventId(bUuid)
      end
    end
    UIUtil.ShowTipsId(170003)
    EventManager:GetInstance():Broadcast(EventId.GatherFactoryItem)
  end
end

GatherProductMessage.OnCreate = OnCreate
GatherProductMessage.HandleMessage = HandleMessage
return GatherProductMessage
