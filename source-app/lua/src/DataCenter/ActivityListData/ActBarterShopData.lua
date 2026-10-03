local ActBarterShopData = BaseClass("ActBarterShopData", ActivityInfoData)
local base = ActivityInfoData

local function __init(self)
  base.__init(self)
  self.exchangeRecordDic = {}
  self.actEndTime = 0
  self.allianceId = nil
end

local function __delete(self)
  self.exchangeRecordDic = nil
  self.actEndTime = nil
  self.allianceId = nil
  base.__delete(self)
end

local function ParseData(self, serverData)
  if not serverData then
    return
  end
  base.ParseActivityData(self, serverData)
  if serverData.exchangeRecord then
    for i, v in ipairs(serverData.exchangeRecord) do
      self.exchangeRecordDic[tonumber(v.id)] = v.num
    end
  end
  if serverData.extraTime then
    self.actEndTime = self.endTime
    self.endTime = serverData.extraTime
  end
  if serverData.allianceId then
    self.allianceId = serverData.allianceId
  end
end

local function GetExchangeRecords(self)
  return self.exchangeRecordDic
end

local function GetExchangedNum(self, id)
  return self.exchangeRecordDic[id] or 0
end

local function UpdateOneData(self, id, num)
  self.exchangeRecordDic[tonumber(id)] = num
end

local function CheckIfIsNew(self)
  local key = "BarterShopFirstOpen_" .. LuaEntry.Player.uid
  local isFirstOpen = CS.GameEntry.Setting:GetBool(key, true)
  return isFirstOpen
end

local function SetIsNew(self, isNew)
  local key = "BarterShopFirstOpen_" .. LuaEntry.Player.uid
  CS.GameEntry.Setting:SetBool(key, false)
end

local function GetRedCount(self)
  local redNum = 0
  local key = "BarterShowRedSwitch_" .. LuaEntry.Player.uid
  local showRed = CS.GameEntry.Setting:GetBool(key, true)
  if showRed then
    LocalController:instance():visitTable("activity_barter", function(id, lineData)
      if lineData.activity_id == tonumber(self.id) and (self.exchangeRecordDic[id] == nil or self.exchangeRecordDic[id] < lineData.times) then
        local needList = self:GetBarterItemsList(lineData.item1, true)
        local allEnough = true
        for i, v in ipairs(needList) do
          if v.cost > v.count then
            allEnough = false
            break
          end
        end
        if allEnough then
          redNum = redNum + 1
        end
      end
    end)
  end
  return redNum
end

local function GetBarterItemsList(self, strConf, isNeed)
  local retList = {}
  local strList = string.split(strConf, "|")
  for i, v in ipairs(strList) do
    local paramList = string.split(v, ";")
    local oneItem = {}
    if #paramList == 2 then
      oneItem.rewardType = tonumber(paramList[1])
      if isNeed then
        local resType = RewardToResType[tonumber(paramList[1])]
        local tempCount = 0
        if resType == ResourceType.Gold then
          tempCount = LuaEntry.Player.gold
        else
          tempCount = LuaEntry.Resource:GetCntByResType(resType)
        end
        oneItem.count = tempCount
        oneItem.cost = tonumber(paramList[2])
      else
        oneItem.count = tonumber(paramList[2])
      end
      table.insert(retList, oneItem)
    elseif #paramList == 3 then
      oneItem.rewardType = tonumber(paramList[1])
      oneItem.itemId = paramList[2]
      if isNeed then
        local costItem = DataCenter.ItemData:GetItemById(paramList[2])
        local ownNum = costItem and costItem.count or 0
        oneItem.count = ownNum
        oneItem.cost = tonumber(paramList[3])
      else
        oneItem.count = tonumber(paramList[3])
      end
      table.insert(retList, oneItem)
    end
  end
  return self:RewardItemList(retList)
end

local function RewardItemList(self, list)
  local showList = {}
  table.walk(list, function(k, v)
    local id = v.itemId
    if id ~= nil then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
      if goods ~= nil then
        local oneData = {}
        oneData.itemId = id
        oneData.iconName = string.format(LoadPath.ItemPath, goods.icon)
        oneData.count = v.count
        oneData.cost = v.cost
        oneData.rewardType = v.rewardType
        oneData.itemName = goods.name
        oneData.itemDesc = goods.description
        oneData.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
        local itemType = goods.type
        if itemType == 2 then
          if goods.para1 ~= nil and goods.para1 ~= "" then
            local para1 = goods.para1
            local temp = string.split(para1, ";")
            if temp ~= nil and 1 < #temp then
              oneData.itemFlag = temp[1] .. temp[2]
            end
          end
        elseif itemType == 3 then
          local type2 = goods.type2
          if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
            local res_num = tonumber(goods.para)
            oneData.itemFlag = string.GetFormattedStr(res_num)
          end
        end
        table.insert(showList, oneData)
      elseif v.rewardType == RewardType.RESOURCE_ITEM then
        local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(tonumber(v.itemId))
        if template ~= nil then
          local oneData = {}
          oneData.iconName = template:GetIconPath()
          oneData.itemName = template.name
          oneData.itemDesc = template.desc
          oneData.count = v.count
          oneData.cost = v.cost
          oneData.rewardType = v.rewardType
          oneData.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
          oneData.itemFlag = nil
          table.insert(showList, oneData)
        end
      end
    elseif v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.GOLD or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.ELECTRICITY or v.rewardType == RewardType.WOOD or v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OBSIDIAN then
      local oneData = {}
      local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(RewardToResType[v.rewardType])
      oneData.iconName = DataCenter.RewardManager:GetPicByType(v.rewardType)
      oneData.itemName = ResourceTypeTxt[v.rewardType]
      oneData.itemDesc = template.description
      oneData.count = v.count
      oneData.cost = v.cost
      oneData.rewardType = v.rewardType
      oneData.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
      oneData.itemFlag = nil
      table.insert(showList, oneData)
    end
  end)
  return showList
end

ActBarterShopData.__init = __init
ActBarterShopData.__delete = __delete
ActBarterShopData.ParseData = ParseData
ActBarterShopData.GetExchangeRecords = GetExchangeRecords
ActBarterShopData.GetExchangedNum = GetExchangedNum
ActBarterShopData.UpdateOneData = UpdateOneData
ActBarterShopData.CheckIfIsNew = CheckIfIsNew
ActBarterShopData.SetIsNew = SetIsNew
ActBarterShopData.GetRedCount = GetRedCount
ActBarterShopData.GetBarterItemsList = GetBarterItemsList
ActBarterShopData.RewardItemList = RewardItemList
return ActBarterShopData
