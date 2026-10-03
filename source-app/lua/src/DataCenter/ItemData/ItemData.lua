local ItemData = BaseClass("ItemData")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.ItemInfos = {}
  self.ItemIdAndUuid = {}
  self.StatusItems = {}
  self.AllUseStatusItem = {}
  self.eventContext = nil
end

local function __delete(self)
  self.ItemInfos = nil
  self.ItemIdAndUuid = nil
  self.StatusItems = nil
  self.AllUseStatusItem = nil
  self.eventContext = nil
end

local function GetItemById(self, numId)
  if self.ItemIdAndUuid == nil then
    return nil
  end
  local id = tostring(numId)
  if self.ItemIdAndUuid[id] ~= nil then
    return self.ItemInfos[self.ItemIdAndUuid[id]]
  end
  return nil
end

local function GetItemByItemId(self, itemId)
  for _, info in pairs(self.ItemInfos) do
    if tonumber(info.itemId) == itemId then
      return info
    end
  end
  return nil
end

local function SetItemRedDotCountisNot(self, tabType)
  local goods
  local count = 0
  if not self.ItemInfos then
    return
  end
  for i, info in pairs(self.ItemInfos) do
    goods = nil
    goods = DataCenter.ItemTemplateManager:GetItemTemplate(info.itemId)
    if goods and goods.page ~= nil and goods.page ~= "" and goods.page == tabType and goods.important == 1 then
      info:SetNewCount()
    end
  end
end

function ItemData:SetAllItemRedDotCountisNot()
  local goods
  local count = 0
  if not self.ItemInfos then
    return
  end
  for i, info in pairs(self.ItemInfos) do
    goods = nil
    goods = DataCenter.ItemTemplateManager:GetItemTemplate(info.itemId)
    if goods and goods.important == 1 then
      info:SetNewCount()
    end
  end
end

local function GetItemsRedDotCount(self)
  local goods
  local count = 0
  for i, info in pairs(self.ItemInfos) do
    goods = nil
    goods = DataCenter.ItemTemplateManager:GetItemTemplate(info.itemId)
    if goods and goods.page ~= nil and goods.page ~= "" and goods.page < 5 then
      if goods.important == 1 then
        count = count + info.newCount
      elseif goods.important == 2 and goods.needCount and info.count > goods.needCount then
        count = count + info.count
      end
    end
  end
  return count
end

local function GetItemRedDotCountByTabType(self, tabType)
  local goods
  local count = 0
  for i, info in pairs(self.ItemInfos) do
    goods = nil
    goods = DataCenter.ItemTemplateManager:GetItemTemplate(info.itemId)
    if goods and goods.page ~= nil and goods.page ~= "" and goods.page == tabType then
      if goods.important == 1 then
        count = count + info.newCount
      elseif goods.important == 2 and goods.needCount and info.count > goods.needCount then
        count = count + info.count
      end
    end
  end
  return count
end

local function GetItemsByType(self, type)
  local list = DataCenter.ItemTemplateManager:GetTypeListByType(type)
  if list ~= nil then
    local result = {}
    for k, v in pairs(list) do
      local item = self:GetItemById(v.id)
      if item ~= nil then
        table.insert(result, item)
      end
    end
    return result
  end
  return nil
end

local function GetItemsTemplateByType(self, type)
  local list = DataCenter.ItemTemplateManager:GetTypeListByType(type)
  if list ~= nil then
    local result = {}
    for k, v in pairs(list) do
      local item = self:GetItemById(v.id)
      if item ~= nil then
        table.insert(result, v)
      end
    end
    return result
  end
  return nil
end

local function GetMateToolsList(self)
  return self:GetItemsByType(GOODS_TYPE.GOODS_TYPE_7)
end

local function GetType62List(self)
  return self:GetItemsByType(GOODS_TYPE.GOODS_TYPE_62)
end

local function ParseItemData(self, items)
  self.ItemInfos = {}
  self.eventContext = {
    heroFragmentItemUpdate = false,
    tacticalCardBoxItemChange = false,
    onGoodsRedState = false,
    gFItemRefreshed = false,
    refreshItems = false,
    bagRefresh = false
  }
  if items ~= nil then
    for k, v in pairs(items) do
      self:UpdateOneItem(v, nil, nil, true)
    end
  end
  if self.eventContext == nil then
    return
  end
  if self.eventContext.onGoodsRedState then
    EventManager:GetInstance():Broadcast(EventId.OnGoodsRedState, true)
  end
  if self.eventContext.gFItemRefreshed then
    EventManager:GetInstance():Broadcast(EventId.GF_item_refreshed)
  end
  if self.eventContext.heroFragmentItemUpdate then
    EventManager:GetInstance():Broadcast(EventId.HeroFragmentItemUpdate)
  end
  if self.eventContext.tacticalCardBoxItemChange then
    EventManager:GetInstance():Broadcast(EventId.TacticalCardBoxItemChange)
  end
  if self.eventContext.refreshItems then
    if self.eventContext.bagRefresh then
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshBagItems)
    else
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    end
  end
  self.eventContext = nil
end

local function UpdateItems(self, items)
  if items ~= nil then
    for k, v in pairs(items) do
      self:UpdateOneItem(v)
    end
  end
end

local function AfterUpdateItem(self, itemId)
  local goodsType = DataCenter.ItemTemplateManager:GetItemType(itemId)
  if goodsType then
    if self.eventContext then
      if goodsType == GOODS_TYPE.GOODS_TYPE_99 or goodsType == GOODS_TYPE.GOODS_TYPE_98 then
        self.eventContext.heroFragmentItemUpdate = true
      elseif goodsType == GOODS_TYPE.GOODS_TYPE_172 then
        self.eventContext.tacticalCardBoxItemChange = true
      end
      return
    end
    if goodsType == GOODS_TYPE.GOODS_TYPE_99 or goodsType == GOODS_TYPE.GOODS_TYPE_98 then
      EventManager:GetInstance():DelayBroadcast(0.1, EventId.HeroFragmentItemUpdate, itemId)
    elseif goodsType == GOODS_TYPE.GOODS_TYPE_172 then
      EventManager:GetInstance():DelayBroadcast(0.1, EventId.TacticalCardBoxItemChange, itemId)
    end
  end
end

local function UpdateOneItem(self, message, isInit, bagRefresh, isIntNew)
  local uuid = message.uuid
  if uuid ~= nil then
    local isNewGood = false
    if self.ItemInfos[uuid] == nil then
      isNewGood = true
      self.ItemInfos[uuid] = ItemInfo.New()
    end
    self.ItemInfos[uuid]:UpdateInfo(message, isIntNew)
    local itemId = self.ItemInfos[uuid].itemId
    self.ItemIdAndUuid[itemId] = uuid
    if self.ItemInfos[uuid].count <= 0 then
      self.ItemInfos[uuid] = nil
      self.ItemIdAndUuid[itemId] = nil
    end
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if self.ItemInfos[uuid] and goods ~= nil and goods.important ~= nil then
      if goods.important == 2 then
        if goods.needCount and goods.needCount <= self.ItemInfos[uuid].count then
          self.ItemInfos[uuid].redState = false
          if self.eventContext then
            self.eventContext.onGoodsRedState = true
          else
            EventManager:GetInstance():Broadcast(EventId.OnGoodsRedState, true)
          end
        else
          self.ItemInfos[uuid].redState = true
        end
      else
        self.ItemInfos[uuid].redState = goods.important == 0 and true or not (self.ItemInfos[uuid].count >= goods.important)
      end
      if isNewGood and goods.important == 1 then
        if self.eventContext then
          self.eventContext.onGoodsRedState = true
        else
          EventManager:GetInstance():Broadcast(EventId.OnGoodsRedState, true)
        end
      end
    end
    if self.eventContext then
      self.eventContext.gFItemRefreshed = true
    else
      EventManager:GetInstance():Broadcast(EventId.GF_item_refreshed, self.ItemInfos[uuid])
    end
    if not isIntNew and self.ItemInfos[uuid] and self.ItemInfos[uuid].itemId == RecruitItemId and self.ItemInfos[uuid].preCount < self.ItemInfos[uuid].count then
      EventManager:GetInstance():Broadcast(EventId.GF_recruit_card_refreshed, self.ItemInfos[uuid])
    end
    if not isIntNew and itemId and itemId == DataCenter.GiftVoucherShopBuildBubbleDataManager:GetCostItemId() then
      EventManager:GetInstance():Broadcast(EventId.GiftVoucherNumChange)
    end
    if goods then
      AfterUpdateItem(self, itemId)
    end
  else
    Logger.Log("item can not get uuid from server !!!!!")
    local id
    if message.itemId ~= nil then
      id = message.itemId
    elseif message.goodsId ~= nil then
      id = message.goodsId
    end
    if id ~= nil and id ~= "" then
      if self.ItemIdAndUuid[id] ~= nil then
        self.ItemInfos[self.ItemIdAndUuid[id]]:UpdateInfo(message)
        if self.ItemInfos[self.ItemIdAndUuid[id]].count <= 0 then
          self.ItemInfos[self.ItemIdAndUuid[id]] = nil
          self.ItemIdAndUuid[id] = nil
        end
      end
      AfterUpdateItem(self, id)
    end
  end
  if self.eventContext then
    self.eventContext.refreshItems = true
    if bagRefresh then
      self.eventContext.bagRefresh = true
    end
  elseif bagRefresh then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshBagItems)
  else
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
  end
end

local function GetItemStatusArrayByType(self, type, bAlive, onlyType)
  local list = DataCenter.ItemTemplateManager:GetTypeListByType(type)
  if list ~= nil and bAlive then
    return list
  end
  local mainLv = DataCenter.BuildManager.MainLv
  local result = {}
  if type == 120 then
    list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_3)
    if list ~= nil then
      for k, v in pairs(list) do
        if v.type2 == type then
          table.insert(result, v)
        end
      end
    end
  elseif type == 100 then
    list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_4)
    if list ~= nil then
      for k, v in pairs(list) do
        if v.type2 == type and mainLv >= v.lv and (bAlive or v.price ~= 0) then
          table.insert(result, v)
        end
      end
    end
  else
    list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_4)
    if list ~= nil then
      for k, v in pairs(list) do
        if v.type2 == type and mainLv >= v.lv then
          if type == 18 then
            if self:GetItemById(v.id) ~= nil then
              table.insert(result, v)
            end
          else
            table.insert(result, v)
          end
        end
      end
    end
    list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_16)
    if list ~= nil then
      local haveLeftTime = self.StatusItems[18] ~= nil
      for k, v in pairs(list) do
        if v.type2 == type and mainLv >= v.lv and (haveLeftTime or self:GetItemById(v.id) ~= nil) then
          table.insert(result, v)
        end
      end
    end
    list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_50)
    if list ~= nil then
      local haveLeftTime = self.StatusItems[38] ~= nil
      for k, v in pairs(list) do
        if v.type2 == type and mainLv >= v.lv and (haveLeftTime or self:GetItemById(v.id) ~= nil) then
          table.insert(result, v)
        end
      end
    end
    list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_57)
    if list ~= nil then
      local haveLeftTime = self.StatusItems[38] ~= nil
      for k, v in pairs(list) do
        if v.type2 == type and mainLv >= v.lv and (haveLeftTime or self:GetItemById(v.id) ~= nil) then
          table.insert(result, v)
        end
      end
    end
  end
  if 0 < #result then
    table.sort(result, function(a, b)
      return a.order > b.order
    end)
  end
  return result
end

local function UpdateEffectList(status)
  for i, v in ipairs(status) do
    LuaEntry.Effect:UpdateEffectStatus(tonumber(v.effVal), tonumber(v.effNum), tonumber(v.stateId), tonumber(v.endTime))
  end
end

local function OnUseRet(self, message)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(message.itemId)
  if template ~= nil then
    local itemEffectObj = message.itemEffectObj
    if itemEffectObj ~= nil then
      if itemEffectObj.status ~= nil then
        UpdateEffectList(itemEffectObj.status)
      end
      if itemEffectObj.oldStatus ~= nil then
        local reStatusId = itemEffectObj.oldStatus
        LuaEntry.Effect:RemoveStatus(reStatusId)
      end
      local stateObj = itemEffectObj.effectState
      if stateObj ~= nil then
        local type = template.type
        local type2 = template.type2
        for k, v in pairs(stateObj) do
          local intKey = tonumber(k)
          local numValue = tonumber(v)
          if k == "layer" then
          elseif k ~= "startTime" then
            if intKey >= EffectStateDefine.PLAYER_PROTECTED_TIME1 and intKey <= EffectStateDefine.PLAYER_PROTECTED_TIME5 then
              LuaEntry.Player.ProtectTimeStamp = numValue
            end
            local temp = {}
            local param = {}
            param.intKey = intKey
            param.numValue = numValue
            temp[intKey] = numValue
            self:SetAllStatusItem(temp)
            LuaEntry.Effect:AddStatus(intKey, numValue)
          end
          if k ~= "layer" and (type == GOODS_TYPE.GOODS_TYPE_4 or type == GOODS_TYPE.GOODS_TYPE_22 or type == GOODS_TYPE.GOODS_TYPE_50 or type == GOODS_TYPE.GOODS_TYPE_55 or type == GOODS_TYPE.GOODS_TYPE_57) then
            local dic = self.StatusItems[type2]
            if dic == nil then
              dic = StatusItem.New()
              if k ~= "startTime" then
                dic.stateId = intKey
                dic.endTime = numValue
              else
                dic.StartTime = numValue
              end
              self.StatusItems[type2] = dic
            elseif k ~= "startTime" then
              dic.stateId = intKey
              dic.endTime = numValue
              dic.StartTime = UITimeManager:GetInstance():GetServerTime()
            else
              dic.StartTime = numValue
            end
          end
        end
        EventManager:GetInstance():Broadcast(EventId.UpdateWorldMapInfo)
        if type == GOODS_TYPE.GOODS_TYPE_4 or type == GOODS_TYPE.GOODS_TYPE_22 or type == GOODS_TYPE.GOODS_TYPE_50 or type == GOODS_TYPE.GOODS_TYPE_55 or type == GOODS_TYPE.GOODS_TYPE_57 then
          EventManager:GetInstance():Broadcast(EventId.MSG_ITME_STATUS_TIME_CHANGE, type2)
          if type2 == 1 then
            local dic = self.StatusItems[type2]
            local tempTime = 0
            if dic ~= nil then
              tempTime = dic.endTime - UITimeManager:GetInstance():GetServerTime()
            end
            if 0 < tempTime then
            end
          end
        end
      end
    end
  end
end

local function CheckUseStateTool(self, template, yesCallback)
  local temp = self.StatusItems[template.type2]
  if temp ~= nil and temp.endTime > UITimeManager:GetInstance():GetServerTime() then
    UIUtil.ShowMessage(Localization:GetString("120015"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, yesCallback)
    return false
  end
  return true
end

local function UseTool(self, itemId, num)
  local item = self:GetItemById(itemId)
  if item ~= nil then
    if num >= item.count then
      self.ItemInfos[item.uuid] = nil
      self.ItemIdAndUuid[itemId] = nil
    else
      item.count = item.count - num
    end
  end
end

local function GetSpeedItem(self, type2)
  local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_2)
  if list ~= nil then
    local result = {}
    for k, v in pairs(list) do
      if v.type2 == ItemSpdMenu.ItemSpdMenu_ALL or v.type2 == type2 then
        local item = self:GetItemById(v.id)
        if item ~= nil then
          item.speedUpType = v.type2
          table.insert(result, item)
        end
      end
    end
    return result
  end
  return nil
end

local function GetItemList(self, type, type2)
  local list = DataCenter.ItemTemplateManager:GetTypeListByType(type)
  if list ~= nil then
    local result = {}
    for k, v in pairs(list) do
      if v.type2 == type2 then
        local item = self:GetItemById(v.id)
        if item ~= nil then
          table.insert(result, item)
        end
      end
    end
    return result
  end
  return nil
end

local function GetResourceItem(self, resource)
  local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_3)
  if list ~= nil then
    local result = {}
    local buyResult = {}
    for k, v in pairs(list) do
      if v.type2 == resource then
        if v.price > 0 then
          table.insert(buyResult, v)
        end
        local item = self:GetItemById(v.id)
        if item ~= nil and 0 < item.count then
          table.insert(result, item)
        end
      end
    end
    return buyResult, result
  end
  return nil
end

local function GetResourceItemCount(self, resource)
  local count = 0
  local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_3)
  if list ~= nil then
    for k, v in pairs(list) do
      if v.type2 == resource then
        local item = self:GetItemById(v.id)
        if item ~= nil then
          count = count + item.count * tonumber(v.para)
        end
      end
    end
  end
  return count
end

local function GetItemByUuid(self, uuid)
  return self.ItemInfos[uuid]
end

local function SetItemCountByUuid(self, uuid, count)
  local item = self:GetItemByUuid(uuid)
  if count <= 0 then
    if item ~= nil then
      item.count = 0
      self.ItemIdAndUuid[item.itemId] = nil
      self.ItemInfos[uuid] = nil
    end
  else
    if item == nil then
      self.ItemInfos[uuid] = ItemInfo.New()
    end
    item.count = count
  end
end

local function SetItemRed(self, uuid)
  local item = self:GetItemByUuid(uuid)
  if item and item.goods and item.count < item.goods.needCount then
    self.ItemInfos[uuid].redState = true
  end
end

local function GetStatusItem(self, type)
  return self.StatusItems[type]
end

local function GetItemCount(self, itemConfigId)
  local itemData = self:GetItemById(tostring(itemConfigId))
  return itemData and itemData.count or 0
end

local function SetAllStatusItem(self, param)
  for k, v in pairs(param) do
    if self.AllUseStatusItem[k] == nil then
      self.AllUseStatusItem[k] = v
    end
  end
end

local function HasExpiredItem(self)
  if not self.ItemInfos then
    return false
  end
  for _, info in pairs(self.ItemInfos) do
    if info and info.goods and info.count > 0 then
      local itemTemplate = info.goods
      local allActExpired = true
      if not table.IsNullOrEmpty(itemTemplate.recovery) then
        for _, actId in pairs(itemTemplate.recovery) do
          local actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
          if actData and actData:IsValid() then
            allActExpired = false
            break
          end
        end
        if allActExpired then
          return true
        end
      end
    end
  end
  return false
end

local function GetItemRealCount(self, itemConfigId)
  local isExpired = UIUtil.CheckItemIsExpired(itemConfigId)
  local itemData = self:GetItemById(tostring(itemConfigId))
  return not isExpired and itemData and itemData.count or 0
end

local function CheckItemIsExpiredInOtherParamData(self, id)
  local isExpired = false
  local itemData = self:GetItemById(tostring(id))
  if itemData then
    isExpired = itemData:CheckIsExpireInOtherParamData()
  end
  return isExpired
end

function ItemData:IsShowWillExpired(id, ignoreDelay)
  if id == nil then
    return false
  end
  id = tonumber(id)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  if template == nil then
    return false
  end
  if template.show_will_expire ~= 1 then
    return false
  end
  if self.showExpireMinTime == nil then
    local day = LuaEntry.DataConfig:TryGetNum("gift_show_expire", "k1", 7)
    local ONE_DAY = 86400
    self.showExpireMinTime = day * ONE_DAY
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local expireTime = 0
  local itemData = self:GetItemById(tostring(id))
  if itemData then
    local otherParamTab = itemData:GetOtherParamTab()
    if otherParamTab and otherParamTab.expireTime then
      expireTime = otherParamTab.expireTime
    end
  end
  if expireTime <= 0 then
    return false
  end
  if ignoreDelay then
    return 0 < expireTime and curTime < expireTime
  else
    return 0 < expireTime and curTime > expireTime - self.showExpireMinTime and curTime < expireTime
  end
end

function ItemData:GetWillExpireTime(id)
  if id == nil then
    return 0
  end
  id = tonumber(id)
  local time = 0
  local itemData = self:GetItemById(tostring(id))
  if itemData then
    local otherParamTab = itemData:GetOtherParamTab()
    if otherParamTab and otherParamTab.expireTime then
      time = otherParamTab.expireTime
    end
  end
  return time
end

function ItemData:HandleItemGetCounts(msg)
  local msgItems = msg.items or {}
  for _, msgItem in pairs(msgItems) do
    local itemId = msgItem.itemId
    local itemInfo = self:GetItemById(itemId)
    if itemInfo then
      local uuid = itemInfo.uuid
      if msgItem.count <= 0 then
        self.ItemInfos[uuid] = nil
        self.ItemIdAndUuid[itemId] = nil
      else
        itemInfo:UpdateInfo(msgItem)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ItemCountRefresh)
end

ItemData.ParseItemData = ParseItemData
ItemData.__init = __init
ItemData.__delete = __delete
ItemData.GetItemById = GetItemById
ItemData.GetItemsByType = GetItemsByType
ItemData.GetItemTemplatesByType = GetItemsTemplateByType
ItemData.GetMateToolsList = GetMateToolsList
ItemData.GetType62List = GetType62List
ItemData.UpdateOneItem = UpdateOneItem
ItemData.GetItemStatusArrayByType = GetItemStatusArrayByType
ItemData.OnUseRet = OnUseRet
ItemData.CheckUseStateTool = CheckUseStateTool
ItemData.UseTool = UseTool
ItemData.GetItemByUuid = GetItemByUuid
ItemData.GetSpeedItem = GetSpeedItem
ItemData.GetResourceItem = GetResourceItem
ItemData.GetResourceItemCount = GetResourceItemCount
ItemData.UpdateItems = UpdateItems
ItemData.SetItemCountByUuid = SetItemCountByUuid
ItemData.GetStatusItem = GetStatusItem
ItemData.GetItemCount = GetItemCount
ItemData.GetItemRealCount = GetItemRealCount
ItemData.SetAllStatusItem = SetAllStatusItem
ItemData.GetItemList = GetItemList
ItemData.SetItemRed = SetItemRed
ItemData.GetItemByItemId = GetItemByItemId
ItemData.GetItemRedDotCountByTabType = GetItemRedDotCountByTabType
ItemData.GetItemsRedDotCount = GetItemsRedDotCount
ItemData.SetItemRedDotCountisNot = SetItemRedDotCountisNot
ItemData.HasExpiredItem = HasExpiredItem
ItemData.CheckItemIsExpiredInOtherParamData = CheckItemIsExpiredInOtherParamData
return ItemData
