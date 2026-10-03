local ActMonopolyDataManager = BaseClass("ActMonopolyDataManager")
local Localization = CS.GameEntry.Localization
local ActMonopolyData = require("DataCenter.ActMonopolyManager.ActMonopolyData")
local ActMonopolyTemplate = require("DataCenter.ActMonopolyManager.ActMonopolyTemplate")
local ActMonopolyBossTemplate = require("DataCenter.ActMonopolyManager.ActMonopolyBossTemplate")
local ActMonopolyParaTemplate = require("DataCenter.ActMonopolyManager.ActMonopolyParaTemplate")
local ActMonopolyDropShowTemplate = require("DataCenter.ActMonopolyManager.ActMonopolyDropShowTemplate")

local function __init(self)
  self.dataDict = {}
  self.templatepDict = nil
  self.bossTemplateDict = nil
  self.paraTemplateDict = nil
  self.dropShowDict = nil
  self.dropShowGroupList = nil
end

local function __delete(self)
  self.dataDict = nil
  self.templatepDict = nil
  self.bossTemplateDict = nil
  self.paraTemplateDict = nil
  self.dropShowDict = nil
end

local function RefreshActDetailData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    self.dataDict[activityId] = ActMonopolyData.New()
  end
  self.dataDict[activityId]:ParseData(message)
end

local function TryInitTemplate(self)
  if self.templatepDict == nil then
    self.templatepDict = {}
    LocalController:instance():visitTable(TableName.RichMan, function(id, line)
      local template = ActMonopolyTemplate.New()
      template:InitData(line)
      local group = template.group
      if self.templatepDict[group] == nil then
        self.templatepDict[group] = {}
      end
      table.insert(self.templatepDict[group], template)
    end)
    for k, v in pairs(self.templatepDict) do
      table.sort(v, function(a, b)
        return a.order < b.order
      end)
      for index, temp in ipairs(v) do
        temp.index = index
      end
    end
  end
  if self.bossTemplateDict == nil then
    self.bossTemplateDict = {}
    LocalController:instance():visitTable(TableName.RichManBoss, function(id, line)
      local template = ActMonopolyBossTemplate.New()
      template:InitData(line)
      self.bossTemplateDict[id] = template
    end)
  end
  if self.paraTemplateDict == nil then
    self.paraTemplateDict = {}
    LocalController:instance():visitTable(TableName.RichManPara, function(id, line)
      local template = ActMonopolyParaTemplate.New()
      template:InitData(line)
      self.paraTemplateDict[id] = template
    end)
  end
  if self.dropShowDict == nil then
    self.dropShowDict = {}
    self.dropShowGroupList = {}
    LocalController:instance():visitTable(TableName.RichmanDropshow, function(id, line)
      local template = ActMonopolyDropShowTemplate.New()
      template:InitData(line)
      self.dropShowDict[id] = template
      if self.dropShowGroupList[template.group_id] == nil then
        self.dropShowGroupList[template.group_id] = {}
      end
      if self.dropShowGroupList[template.group_id][template.type] == nil then
        self.dropShowGroupList[template.group_id][template.type] = {}
      end
      table.insert(self.dropShowGroupList[template.group_id][template.type], template)
    end)
  end
end

local function GetActData(self, activityId)
  local data
  data = self.dataDict[activityId]
  return data
end

local function GetMonopolyTempListByGroup(self, group)
  self:TryInitTemplate()
  local data = {}
  if self.templatepDict[group] then
    data = self.templatepDict[group]
  end
  return data
end

local function GetMonopolyTempByGroupAndIndex(self, group, index)
  self:TryInitTemplate()
  local data
  if self.templatepDict[group] then
    local maxIndex = #self.templatepDict[group]
    if index <= maxIndex then
      data = self.templatepDict[group][index]
    end
  end
  return data
end

local function GetMonopolyBossTempById(self, id)
  self:TryInitTemplate()
  local data
  data = self.bossTemplateDict[id]
  return data
end

local function GetMonopolyParaTempById(self, id)
  self:TryInitTemplate()
  local data
  data = self.paraTemplateDict[tonumber(id)]
  return data
end

local function GetDropShowTempByGroupAndType(self, group, type)
  self:TryInitTemplate()
  local data = {}
  if self.dropShowGroupList[group] and self.dropShowGroupList[group][type] then
    data = self.dropShowGroupList[group][type]
  end
  return data
end

local function OnGetShopListDataMsg(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:OnGetShopListDataMsg(message)
end

local function AddShopData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:AddShopData(message.storeDetail)
end

local function UpdateShopItem(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:UpdateShopItem(message)
end

local function UpdateDailyRewardData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:UpdateDailyRewardData(message)
end

local function CanGetFreePack(self, actId)
  if self.dataDict[actId] then
    return self.dataDict[actId]:CanGetFreePack()
  end
  return false
end

local function CanGotoPackShop(self, actId)
  if self.dataDict[actId] then
    return self.dataDict[actId]:CanGotoPackShop()
  end
  return false
end

local function GetKeyGiftPackId(self, actId)
  if self.dataDict[actId] then
    return self.dataDict[actId]:GetGiftPackId()
  end
end

local function GetRedNum(self, actId)
  local num = 0
  if self.dataDict[actId] then
    num = self.dataDict[actId]:GetRedNum()
  end
  return num
end

local function GetBossStageRewardMsg(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:GetBossStageRewardMsg(message)
end

local function GetBossWeakRewardMsg(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:GetBossWeakRewardMsg(message)
end

local function OnGetDamageDataMsg(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:OnGetDamageDataMsg(message)
end

local function OnGetDamageRewardMsg(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:OnGetDamageRewardMsg(message)
end

local function OnAddDamageReward(self, activityId, reward)
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:OnAddDamageReward(reward)
end

local function OnAddAutoEvent(self, activityId, eventId)
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:OnAddAutoEvent(eventId)
end

local function OnReceiveAutoEvent(self, activityId, eventId)
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:OnReceiveAutoEvent(eventId)
end

local function SetDamageRewardData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:SetDamageRewardData(message.reward)
end

local function EventTypeIsToAutoEventSave(self, eventType)
  local result = false
  if eventType == ActMonopolyEventType.BackEvent or eventType == ActMonopolyEventType.FreeH or eventType == ActMonopolyEventType.ExpEvent or eventType == ActMonopolyEventType.Sport then
    result = true
  end
  return result
end

ActMonopolyDataManager.__init = __init
ActMonopolyDataManager.__delete = __delete
ActMonopolyDataManager.RefreshActDetailData = RefreshActDetailData
ActMonopolyDataManager.TryInitTemplate = TryInitTemplate
ActMonopolyDataManager.GetActData = GetActData
ActMonopolyDataManager.GetMonopolyTempListByGroup = GetMonopolyTempListByGroup
ActMonopolyDataManager.GetMonopolyTempByGroupAndIndex = GetMonopolyTempByGroupAndIndex
ActMonopolyDataManager.GetMonopolyBossTempById = GetMonopolyBossTempById
ActMonopolyDataManager.GetMonopolyParaTempById = GetMonopolyParaTempById
ActMonopolyDataManager.OnGetShopListDataMsg = OnGetShopListDataMsg
ActMonopolyDataManager.AddShopData = AddShopData
ActMonopolyDataManager.UpdateShopItem = UpdateShopItem
ActMonopolyDataManager.UpdateDailyRewardData = UpdateDailyRewardData
ActMonopolyDataManager.CanGotoPackShop = CanGotoPackShop
ActMonopolyDataManager.CanGetFreePack = CanGetFreePack
ActMonopolyDataManager.GetKeyGiftPackId = GetKeyGiftPackId
ActMonopolyDataManager.GetRedNum = GetRedNum
ActMonopolyDataManager.GetBossStageRewardMsg = GetBossStageRewardMsg
ActMonopolyDataManager.GetBossWeakRewardMsg = GetBossWeakRewardMsg
ActMonopolyDataManager.OnGetDamageDataMsg = OnGetDamageDataMsg
ActMonopolyDataManager.OnGetDamageRewardMsg = OnGetDamageRewardMsg
ActMonopolyDataManager.OnAddDamageReward = OnAddDamageReward
ActMonopolyDataManager.OnAddAutoEvent = OnAddAutoEvent
ActMonopolyDataManager.OnReceiveAutoEvent = OnReceiveAutoEvent
ActMonopolyDataManager.SetDamageRewardData = SetDamageRewardData
ActMonopolyDataManager.GetDropShowTempByGroupAndType = GetDropShowTempByGroupAndType
ActMonopolyDataManager.EventTypeIsToAutoEventSave = EventTypeIsToAutoEventSave
return ActMonopolyDataManager
