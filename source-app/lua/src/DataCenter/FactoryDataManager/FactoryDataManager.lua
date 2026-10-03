local FactoryDataManager = BaseClass("FactoryDataManager")

local function __init(self)
  self.factoryList = {}
  self.initPlanZoneNum = 0
  self.productZoneNum = 0
  self.addPlanZoneCost = 0
  self.factoryTemplateList = {}
  self.factoryTemplateDic = {}
  self.hasSendEvent = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckCanGetProduct()
  end
  
  self:AddTimer()
  self.isSendList = {}
  self.useTableName = nil
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function __delete(self)
  self.factoryList = nil
  self.initPlanZoneNum = nil
  self.productZoneNum = nil
  self.addPlanZoneCost = nil
  self.factoryTemplateList = nil
  self.factoryTemplateDic = nil
  self.timer_action = nil
  self:DeleteTimer()
  self.isSendList = nil
  self.useTableName = nil
end

local function CheckCanGetProduct(self)
  for k, v in pairs(self.factoryList) do
    if self.factoryList[k] ~= nil and self.factoryList[k]:CheckCanGetProduct() > -1 and self.hasSendEvent[k] == nil then
      EventManager:GetInstance():Broadcast(EventId.CanGetProduct, k)
      self.hasSendEvent[k] = true
    end
  end
  self:RefreshFactoryProductTime()
end

local function GetFactoryTemplateByBuildId(self, buildId)
  if self.factoryTemplateList[buildId] == nil then
    self.factoryTemplateList[buildId] = {}
    LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
      local item = FactoryTemplate.New()
      item:InitData(lineData)
      if item.build_type == buildId then
        table.insert(self.factoryTemplateList[buildId], item)
        if self.factoryTemplateDic[item.id] == nil then
          self.factoryTemplateDic[item.id] = item
        end
      end
    end)
  end
  return self.factoryTemplateList[buildId]
end

local function ResetPveFactoryFormula(self, buildId)
  self.factoryTemplateList[buildId] = nil
  self:GetFactoryTemplateByBuildIdInGroup(buildId, -1, true)
end

local function GetFactoryTemplateByBuildIdInGroup(self, buildId, productLv, isPve)
  productLv = productLv or -1
  local isOpen = LuaEntry.DataConfig:CheckSwitch("farm_more")
  if not isOpen then
    productLv = -1
  end
  if self.factoryTemplateList[buildId] == nil then
    self.factoryTemplateList[buildId] = {}
    if isPve then
      local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(buildId)
      if data then
        local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(data.id)
        if triggerData ~= nil then
          local formula = triggerData:GetPVEFactoryFormulaByLv(data.level)
          table.walk(formula, function(_, v)
            if self.factoryTemplateDic[v] == nil then
              local lineData = LocalController:instance():getLine(self:GetTableName(), v)
              local item = FactoryTemplate.New()
              item:InitData(lineData)
              self.factoryTemplateDic[item.id] = item
            end
            if self.factoryTemplateDic[v] ~= nil then
              table.insert(self.factoryTemplateList[buildId], self.factoryTemplateDic[v])
            end
          end)
        end
      end
    else
      LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
        local item = FactoryTemplate.New()
        item:InitData(lineData)
        if item.build_type == buildId then
          table.insert(self.factoryTemplateList[buildId], item)
          if self.factoryTemplateDic[item.id] == nil then
            self.factoryTemplateDic[item.id] = item
          end
        end
      end)
    end
  end
  local result = {}
  local tmp = {}
  table.walk(self.factoryTemplateList[buildId], function(_, v)
    if tmp[v.group] == nil then
      tmp[v.group] = {}
    end
    table.insert(tmp[v.group], v)
  end)
  table.walk(tmp, function(_, v)
    table.sort(v, function(a, b)
      return a.order < b.order
    end)
  end)
  table.walk(tmp, function(_, v)
    local find
    for index, k in ipairs(v) do
      if find == nil then
        find = k
      end
      if not self:IsUnlockProductByProductId(k.id) or 0 < productLv and index > productLv then
        break
      end
      find = k
    end
    if find ~= nil then
      table.insert(result, find)
    end
  end)
  return result
end

local function GetAllFactoryTemplate(self)
  local factoryList = {}
  LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
    local item = FactoryTemplate.New()
    item:InitData(lineData)
    if factoryList[item.id] == nil then
      factoryList[item.id] = item
    end
  end)
  return factoryList
end

local function GetFactoryTemplate(self, id)
  if self.factoryTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(self:GetTableName(), id)
    if oneTemplate ~= nil then
      local item = FactoryTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.factoryTemplateDic[item.id] = item
      end
    end
  end
  return self.factoryTemplateDic[tonumber(id)]
end

local function InitData(self, message)
  self.initPlanZoneNum = LuaEntry.DataConfig:TryGetStr("food_factory", "k1")
  self.productZoneNum = LuaEntry.DataConfig:TryGetStr("food_factory", "k3")
  self.addPlanZoneCost = LuaEntry.DataConfig:TryGetStr("food_factory", "k4")
  if message.foodFactoryObjList == nil then
    self:GetFactoryData()
    return
  end
  self.factoryList = {}
  self.isSendList = {}
  local data = message.foodFactoryObjList
  table.walk(data, function(k, v)
    self:RefreshFactoryList(v)
  end)
end

local function RefreshFactoryList(self, message)
  if message.foodFactoryObj ~= nil then
    local data = message.foodFactoryObj
    local bUuid = data.bUuid
    if bUuid ~= nil then
      if self.factoryList[bUuid] == nil then
        local item = FactoryData.New()
        self.factoryList[bUuid] = item
      end
      self.factoryList[bUuid]:RefreshData(data)
      self.isSendList[bUuid] = false
    end
  end
end

local function RefreshFactoryProductTime(self)
  for _, v in pairs(self.factoryList) do
    if v ~= nil and self.isSendList[v.bUuid] == false and v:NeedRefreshFactoryData() then
      self.isSendList[v.bUuid] = true
      SFSNetwork.SendMessage(MsgDefines.SynFoodFactory, v.bUuid)
    end
  end
end

local function GetFactoryDataByBUuid(self, bUuid)
  return self.factoryList[bUuid]
end

local function GetFactoryNoWorkData(self)
  local result = {}
  if next(self.factoryList) then
    table.walk(self.factoryList, function(k, v)
      if not next(v.planZoneList) then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(k)
        if buildData ~= nil then
          table.insert(result, buildData.itemId)
        end
      end
    end)
  end
  return result
end

local function GetInitPlanZoneNum(self)
  return 0
end

local function GetMaxPlanZoneNum(self, buildId, isPve)
  if isPve and DataCenter.BattleLevel ~= nil then
    local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(buildId)
    local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(buildId)
    if data ~= nil and triggerData ~= nil then
      local num = triggerData:GetPVEFactoryMaxQueueNumByLv(data.level)
      return num or 0
    end
  else
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildTemplate ~= nil then
      local vec = string.split(buildTemplate.para1, "|")
      if vec ~= nil then
        return table.count(vec)
      end
    end
  end
  return 0
end

local function GetAddPlanZoneCost(self)
  return tonumber(self.addPlanZoneCost)
end

local function GetProductZoneNum(self)
  return tonumber(self.productZoneNum)
end

local function GetFactoryData(self)
  table.walk(FactoryBuild, function(_, v)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v)
    if buildData ~= nil then
      SFSNetwork.SendMessage(MsgDefines.SynFoodFactory, buildData.uuid)
    end
  end)
end

local function ResetEventId(self, bUuid)
  if self.hasSendEvent[bUuid] ~= nil then
    self.hasSendEvent[bUuid] = nil
  end
  self:CheckCanGetProduct()
end

local function GetTypePriceByBuildid(self, buildId)
  local items = {}
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    local vec = string.split(buildTemplate.para1, "|")
    if 0 < #vec then
      table.walk(vec, function(k, v)
        local vec1 = string.split(v, ";")
        if 0 < #vec1 then
          local need = {}
          need.id = tonumber(vec1[1])
          if vec1[2] ~= null then
            need.type = tonumber(vec1[2])
          else
            need.type = 0
          end
          if vec1[3] ~= null then
            need.count = tonumber(vec1[3])
          else
            need.count = 0
          end
          table.insert(items, need)
        end
      end)
    end
  end
  return items
end

local function GetFactoryStateByBuildUuid(self, uuid)
  local state = FactoryWorkState.Free
  local factoryData = self:GetFactoryDataByBUuid(uuid)
  if factoryData ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
      local open = self:HasUnlockItemByBuildId(buildData.itemId)
      if not open then
        state = FactoryWorkState.NotOpen
        return state
      end
    end
    if #factoryData.planZoneList <= 0 then
      state = FactoryWorkState.Free
    elseif #factoryData.productZoneList >= self:GetProductZoneNum() then
      state = FactoryWorkState.Full
    else
      local workingList = factoryData.workingList
      if workingList ~= nil then
        for _, v in pairs(workingList) do
          if 0 < v.startTime and 0 < v.endTime then
            state = FactoryWorkState.Work
            break
          end
        end
      end
    end
  else
    state = FactoryWorkState.NotOpen
  end
  return state
end

local function GetFactoryAllStateByBuildUuid(self, uuid)
  local result = {}
  local isAllFree = false
  local isFull = false
  local factoryData = self:GetFactoryDataByBUuid(uuid)
  if factoryData ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
      local open = self:HasUnlockItemByBuildId(buildData.itemId)
      if not open then
        table.insert(result, FactoryWorkState.NotOpen)
        return result
      end
    end
    isAllFree = table.count(factoryData.planZoneList) == 0
    isFull = table.count(factoryData.productZoneList) >= self:GetProductZoneNum()
    local workingList = factoryData.workingList
    if workingList ~= nil then
      for _, v in pairs(workingList) do
        if isAllFree then
          table.insert(result, FactoryWorkState.Free)
        elseif isFull then
          table.insert(result, FactoryWorkState.Full)
        elseif v.product == 0 then
          table.insert(result, FactoryWorkState.Free)
        else
          table.insert(result, FactoryWorkState.Work)
        end
      end
    end
  end
  return result
end

local function GetFactoryWorkData(self, uuid)
  local factoryData = self:GetFactoryDataByBUuid(uuid)
  if factoryData == nil then
    return nil
  end
  local productId = factoryData:GetLatestWorkData()
  if productId == nil then
    return nil
  end
  local info = self:GetFactoryTemplate(productId)
  if info == nil then
    return nil
  end
  return info.icon
end

local function IsCanProductByProductId(self, productId, buildUuid)
  local result = true
  local template = self:GetFactoryTemplate(productId)
  if template ~= nil then
    if template.unlock_type ~= nil then
      local needConditionId, needConditionLv
      table.walk(template.unlock_condition, function(a, b)
        needConditionId = a
        needConditionLv = b
      end)
      if template.unlock_type == TemplateUnlockType.Build then
        result = CommonUtil.CheckIsBuildEnough(needConditionId, needConditionLv)
      elseif template.unlock_type == TemplateUnlockType.Science then
        result = CommonUtil.CheckIsScienceEnough(needConditionId, needConditionLv)
      end
    end
    if result then
      for k, v in pairs(template.need_resource) do
        if CommonUtil.CheckIsResourceEnough(k, v) == false then
          return false
        end
      end
      for k, v in pairs(template.need_resource_goods) do
        if CommonUtil.CheckIsResourceGoodsEnough(k, v) == false then
          return false
        end
      end
    end
  end
  if not self:CheckHasFreeQueue(buildUuid) then
    return false
  end
  return result
end

local function IsUnlockProductByProductId(self, productId)
  local result = true
  local template = self:GetFactoryTemplate(productId)
  if template ~= nil then
    if template.unlock_type ~= nil then
      local needConditionId, needConditionLv
      table.walk(template.unlock_condition, function(a, b)
        needConditionId = a
        needConditionLv = b
      end)
      if template.unlock_type == TemplateUnlockType.Build then
        result = CommonUtil.CheckIsBuildEnough(needConditionId, needConditionLv)
      elseif template.unlock_type == TemplateUnlockType.Science then
        result = CommonUtil.CheckIsScienceEnough(needConditionId, needConditionLv)
      elseif template.unlock_type == TemplateUnlockType.Career then
        local selfCareer = DataCenter.PlayerCareerManager:GetCareerType()
        local selfCareerLv = DataCenter.PlayerCareerManager:GetCareerLv()
        result = needConditionId == selfCareer and needConditionLv <= selfCareerLv
      elseif template.unlock_type == TemplateUnlockType.Talent then
        result = DataCenter.TalentDataManager:IsTalentOpen(needConditionId)
      end
    end
    if not DataCenter.PlayerLevelManager:ReachLevel(template.unlock_player_level) then
      result = false
    end
  end
  return result
end

local function CheckHasFreeQueue(self, buildUuid)
  local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(buildUuid)
  if factoryData ~= nil then
    local initBoxNum = 0
    local addNum = factoryData.unlocked
    local totalNum = addNum + initBoxNum
    if totalNum > #factoryData.planZoneList then
      return true
    end
  end
  return false
end

local function GetTableName(self)
  if self.useTableName == nil then
    self.useTableName = LuaEntry.Player:GetABTestTableName(TableName.Factory)
  end
  return self.useTableName
end

local function IsQueueOpenByIndex(self, bUuid, index)
  if index == 1 then
    return true
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil then
    local effectId = FactoryIdToProductEffectId[buildData.itemId]
    if effectId ~= nil then
      local effect = LuaEntry.Effect:GetGameEffect(effectId)
      return index <= effect + 1
    end
  end
  return false
end

local function GetFactoryTemplateByResourceItem(self, resourceType)
  for _, template in pairs(self:GetAllFactoryTemplate()) do
    for k, v in ipairs(template.productList) do
      if v.itemId == resourceType then
        return template
      end
    end
  end
  return nil
end

local function HasUnlockItemByBuildId(self, buildId)
  local dataList = self:GetFactoryTemplateByBuildId(buildId)
  if dataList == nil or table.count(dataList) == 0 then
    return false
  end
  local result = false
  for _, v in ipairs(dataList) do
    if v ~= nil and self:IsUnlockProductByProductId(v.id) then
      result = true
      break
    end
  end
  return result
end

local function GetShowFactoryItemOpenFlag(self, itemId)
  local key = LuaEntry.Player.uid .. "_ShowFactoryItemOpenFlag"
  local value = Setting:GetString(key, "")
  if string.IsNullOrEmpty(value) then
    return false
  end
  local vec = string.split(value, "_")
  for _, v in ipairs(vec) do
    if v == tostring(itemId) then
      return true
    end
  end
  return false
end

local function SaveShowFactoryItemOpenFlag(self, itemId)
  local key = LuaEntry.Player.uid .. "_ShowFactoryItemOpenFlag"
  local value = Setting:GetString(key, "")
  if string.IsNullOrEmpty(value) then
    value = tostring(itemId)
  else
    value = value .. "_" .. itemId
  end
  Setting:SetString(key, value)
end

local function RemoveShowFactoryItemOpenFlag(self, itemId)
  local key = LuaEntry.Player.uid .. "_ShowFactoryItemOpenFlag"
  local value = Setting:GetString(key, "")
  if string.IsNullOrEmpty(value) then
    return
  end
  local vec = string.split(value, "_")
  for k, v in ipairs(vec) do
    if v == tostring(itemId) then
      table.remove(vec, k)
      break
    end
  end
  value = string.join(vec, "_")
  Setting:SetString(key, value)
end

local function SendCancelFactoryPanel(self, bUuid, index)
  SFSNetwork.SendMessage(MsgDefines.UserCancelFactoryPanel, bUuid, index)
end

local function DoWhenCancelFactoryPanel(self, message)
  if message.resourceItem ~= nil and message.resourceItem.resource_items ~= nil then
    DataCenter.ResourceItemDataManager:RefreshItemList(message.resourceItem)
  end
  self:RefreshFactoryList(message)
  EventManager:GetInstance():Broadcast(EventId.FactoryDataCancel)
end

local function GetProductLevels(self, buildId)
  local isOpen = LuaEntry.DataConfig:CheckSwitch("farm_more")
  if not isOpen then
    return {1}
  end
  self:GetFactoryTemplateByBuildId(buildId)
  local tmp = {}
  table.walk(self.factoryTemplateList[buildId], function(_, v)
    if tmp[v.group] == nil then
      tmp[v.group] = {}
    end
    table.insert(tmp[v.group], v)
  end)
  table.walk(tmp, function(_, v)
    table.sort(v, function(a, b)
      return a.order < b.order
    end)
  end)
  local max = 0
  for k, v in pairs(tmp) do
    local find = false
    for k1, v1 in ipairs(v) do
      if not self:IsUnlockProductByProductId(v1.id) then
        if k1 > max and not find then
          max = k1
        end
        break
      else
        find = true
        if k1 > max then
          max = k1
        end
      end
    end
  end
  local result = {}
  local index = 1
  while max >= index do
    table.insert(result, index)
    index = index + 1
  end
  return result
end

local function FactoryProductTypeToRewardType(self, productType, itemId)
  if productType == FactoryProductType.FactoryProductType_Resource_Item then
    return RewardType.RESOURCE_ITEM
  elseif productType == FactoryProductType.FactoryProductType_Item then
    return RewardType.GOODS
  elseif productType == FactoryProductType.FactoryProductType_Resource then
    return ResTypeToReward[itemId] or RewardType.RESOURCE_ITEM
  elseif productType == FactoryProductType.FactoryProductType_Score then
    return RewardType.BATTLE_PASS
  end
  return RewardType.RESOURCE_ITEM
end

local function GetProductShowIcon(self, product)
  if product.type == FactoryProductType.FactoryProductType_Resource_Item then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(tonumber(product.itemId))
    if template ~= nil then
      return template:GetIconPath()
    end
  elseif product.type == FactoryProductType.FactoryProductType_Item then
    return DataCenter.ItemTemplateManager:GetIconPath(tonumber(product.itemId))
  elseif product.type == FactoryProductType.FactoryProductType_Resource then
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(tonumber(product.itemId))
    if template then
      return string.format(LoadPath.LWCommonPath, template.icon)
    end
  elseif product.type == FactoryProductType.FactoryProductType_Score then
    return string.format(LoadPath.ItemPath, "Common_icon_act_point")
  end
  return ""
end

FactoryDataManager.GetProductShowIcon = GetProductShowIcon
FactoryDataManager.__init = __init
FactoryDataManager.__delete = __delete
FactoryDataManager.RefreshFactoryList = RefreshFactoryList
FactoryDataManager.InitData = InitData
FactoryDataManager.GetFactoryDataByBUuid = GetFactoryDataByBUuid
FactoryDataManager.GetFactoryTemplateByBuildId = GetFactoryTemplateByBuildId
FactoryDataManager.GetFactoryTemplateByBuildIdInGroup = GetFactoryTemplateByBuildIdInGroup
FactoryDataManager.HasUnlockItemByBuildId = HasUnlockItemByBuildId
FactoryDataManager.FactoryProductTypeToRewardType = FactoryProductTypeToRewardType
FactoryDataManager.GetFactoryTemplate = GetFactoryTemplate
FactoryDataManager.GetInitPlanZoneNum = GetInitPlanZoneNum
FactoryDataManager.GetMaxPlanZoneNum = GetMaxPlanZoneNum
FactoryDataManager.GetAddPlanZoneCost = GetAddPlanZoneCost
FactoryDataManager.GetProductZoneNum = GetProductZoneNum
FactoryDataManager.GetFactoryData = GetFactoryData
FactoryDataManager.CheckCanGetProduct = CheckCanGetProduct
FactoryDataManager.DeleteTimer = DeleteTimer
FactoryDataManager.AddTimer = AddTimer
FactoryDataManager.ResetEventId = ResetEventId
FactoryDataManager.GetTypePriceByBuildid = GetTypePriceByBuildid
FactoryDataManager.GetFactoryStateByBuildUuid = GetFactoryStateByBuildUuid
FactoryDataManager.RefreshFactoryProductTime = RefreshFactoryProductTime
FactoryDataManager.GetFactoryNoWorkData = GetFactoryNoWorkData
FactoryDataManager.GetAllFactoryTemplate = GetAllFactoryTemplate
FactoryDataManager.GetFactoryWorkData = GetFactoryWorkData
FactoryDataManager.IsCanProductByProductId = IsCanProductByProductId
FactoryDataManager.IsUnlockProductByProductId = IsUnlockProductByProductId
FactoryDataManager.CheckHasFreeQueue = CheckHasFreeQueue
FactoryDataManager.GetTableName = GetTableName
FactoryDataManager.GetFactoryAllStateByBuildUuid = GetFactoryAllStateByBuildUuid
FactoryDataManager.IsQueueOpenByIndex = IsQueueOpenByIndex
FactoryDataManager.GetFactoryTemplateByResourceItem = GetFactoryTemplateByResourceItem
FactoryDataManager.GetShowFactoryItemOpenFlag = GetShowFactoryItemOpenFlag
FactoryDataManager.SaveShowFactoryItemOpenFlag = SaveShowFactoryItemOpenFlag
FactoryDataManager.RemoveShowFactoryItemOpenFlag = RemoveShowFactoryItemOpenFlag
FactoryDataManager.DoWhenCancelFactoryPanel = DoWhenCancelFactoryPanel
FactoryDataManager.SendCancelFactoryPanel = SendCancelFactoryPanel
FactoryDataManager.GetProductLevels = GetProductLevels
FactoryDataManager.ResetPveFactoryFormula = ResetPveFactoryFormula
return FactoryDataManager
