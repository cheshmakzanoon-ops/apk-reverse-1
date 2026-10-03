local FactoryAddSpeedMessage = BaseClass("FactoryAddSpeedMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("bUuid", param.qUUID)
    self.sfsObj:PutInt("isGold", param.isGold)
    if param.isGold == 0 then
      self.sfsObj:PutUtfString("itemId", tostring(param.itemId))
      self.sfsObj:PutInt("count", param.count)
    end
    if param.index ~= nil then
      self.sfsObj:PutInt("index", param.index)
    end
    if param.isFree ~= nil then
      self.sfsObj:PutBool("isFree", param.isFree)
    end
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
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if DataCenter.ResourceItemDataManager:CheckIsStorageFull(1) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
    end
    if t.resource_items then
      DataCenter.ResourceItemDataManager:RefreshItemList(t)
    end
    EventManager:GetInstance():Broadcast(EventId.FactoryDataAddSpeed)
    UIUtil.ShowTipsId(130317)
    EventManager:GetInstance():Broadcast(EventId.GetFactoryData)
    EventManager:GetInstance():Broadcast(EventId.SkipFactoryAni)
    EventManager:GetInstance():Broadcast(EventId.DelayRefreshResource, 0.1)
    EventManager:GetInstance():Broadcast(EventId.UpdatePlayerExp)
  end
end

FactoryAddSpeedMessage.OnCreate = OnCreate
FactoryAddSpeedMessage.HandleMessage = HandleMessage
return FactoryAddSpeedMessage
