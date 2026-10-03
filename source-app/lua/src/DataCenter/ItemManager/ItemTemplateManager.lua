local ItemTemplateManager = BaseClass("ItemTemplateManager")
local Localization = CS.GameEntry.Localization
local GlobalData = CS.GameEntry.GlobalData
local GOODS_TYPE = _ENV.GOODS_TYPE
local DataCenter = _ENV.DataCenter
local tonumber = _ENV.tonumber
local pairs = _ENV.pairs
local string_IsNullOrEmpty = string.IsNullOrEmpty
local string_split = string.split

local function __init(self)
  self.itemDic = {}
  self.typeTools = {}
  self.storeTools = {}
  self.commonHeroFrame = {}
  self.heroFrame = {}
  self.allianceItemTemplate = {}
  self.itemSkinDic = nil
end

local function __delete(self)
  self.itemDic = nil
  self.itemSkinDic = nil
  self.typeTools = nil
  self.storeTools = nil
  self.commonHeroFrame = nil
  self.heroFrame = nil
  self.allianceItemTemplate = nil
end

function ItemTemplateManager:GetItemSkin(theItemId, seasonIndex)
  if self.itemSkinDic == nil then
    local itemSkinDic = {}
    LocalController:instance():visitTable(TableName.GoodsTabSkin, function(id, lineData)
      local _seasonIndex = toInt(lineData.season)
      local _itemId = toInt(lineData.goods)
      if itemSkinDic[_seasonIndex] == nil then
        itemSkinDic[_seasonIndex] = {}
      end
      itemSkinDic[_seasonIndex][_itemId] = {
        goods = _itemId,
        season = _seasonIndex,
        name = lineData.name,
        name_value = lineData.name_value,
        description = lineData.description,
        icon = lineData.icon
      }
    end)
    self.itemSkinDic = itemSkinDic
  end
  local dict = self.itemSkinDic[toInt(seasonIndex or SeasonUtil.GetSeason())]
  if dict == nil then
    return nil
  end
  return dict[toInt(theItemId)]
end

local function GetItemTemplate(self, numId)
  local id = tostring(numId)
  if self.itemDic[id] == nil then
    local oneTemplate = LocalController:instance():tryGetLine(TableName.GoodsTab, id)
    if oneTemplate ~= nil then
      local item = ItemTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.itemDic[item.id] = item
      end
    end
  end
  return self.itemDic[id]
end

function ItemTemplateManager:TryGetItemTemplate(numId)
  if string.IsNullOrEmpty(numId) then
    return nil
  end
  local id = tostring(numId)
  if self.itemDic[id] == nil then
    local oneTemplate = LocalController:instance():tryGetLine(TableName.GoodsTab, id)
    if oneTemplate ~= nil then
      local item = ItemTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.itemDic[item.id] = item
      end
    end
  end
  return self.itemDic[id]
end

local function InitAllTemplate(self)
  local seasonIndex = SeasonUtil.GetSeason()
  self.itemDic = {}
  self.typeTools = {}
  self.storeTools = {}
  self.commonHeroFrame = {}
  self.heroFrame = {}
  self.allianceItemTemplate = {}
  LocalController:instance():visitTable(TableName.GoodsTab, function(id, lineData)
    local item = ItemTemplate.New()
    item:InitData(lineData, seasonIndex)
    if self.itemDic[item.id] == nil then
      self.itemDic[item.id] = item
    end
    if self.typeTools[item.type] == nil then
      self.typeTools[item.type] = {}
    end
    table.insert(self.typeTools[item.type], item)
    if item.price > 0 and 0 < item.lv then
      if item.pagehot == ItemHotPage.Yes then
        self:AddStoreItem(UIBagBtnType.Hot, item)
      end
      if 0 < item.pages then
        self:AddStoreItem(item.pages, item)
      end
    end
    if 0 < item.price_all then
      table.insert(self.allianceItemTemplate, item)
    end
    if item.type == GOODS_TYPE.GOODS_TYPE_70 then
      if item.type2 == FrameType.Common then
        if self.commonHeroFrame[item.color] == nil then
          self.commonHeroFrame[item.color] = {}
        end
        table.insert(self.commonHeroFrame[item.color], item)
      elseif item.type2 == FrameType.HeroFrame then
        self.heroFrame[item.para2] = item
      end
    end
  end)
  DataCenter.AllianceShopDataManager:InitAllianceBag()
  EventManager:GetInstance():Broadcast(EventId.FinishInitItemTemplate)
end

local function AddStoreItem(self, page, template)
  if self.storeTools[page] == nil then
    self.storeTools[page] = {}
  end
  table.insert(self.storeTools[page], template)
end

local function GetTypeListByType(self, type)
  return self.typeTools[type]
end

local function GetTypeListByTypes(self, type, type2)
  local typeList = self:GetTypeListByType(type)
  local list = {}
  if not table.IsNullOrEmpty(typeList) then
    for i, v in pairs(typeList) do
      if v.type2 == type2 then
        table.insert(list, v)
      end
    end
  end
  return list
end

local function GetItemByPara(self, para1)
  if self.itemDic ~= nil then
    for i, v in pairs(self.itemDic) do
      if v.para ~= nil and tonumber(v.para1) == tonumber(para1) then
        return self.itemDic[i]
      end
    end
  end
end

local function GetItemByParaAndType(self, para1, type, type2)
  if self.itemDic ~= nil then
    for i, v in pairs(self.itemDic) do
      if v.para ~= nil and tonumber(v.para1) == tonumber(para1) and tonumber(v.type) == tonumber(type) and tonumber(v.type2) == tonumber(type2) then
        return self.itemDic[i]
      end
    end
  end
end

local function GetStoreByBtnType(self, type)
  return self.storeTools[type]
end

local function GetCommonHeroFrameByColor(self, color)
  return self.commonHeroFrame[color]
end

local function GetHeroFrame(self)
  return self.heroFrame
end

local function GetHeroFrameTemplateByHeroId(self, heroId)
  return self.heroFrame[heroId]
end

local function GetName(self, itemId)
  local template = self:GetItemTemplate(itemId)
  if template ~= nil then
    local name = template.name
    local nameLink = template.name_link
    if nameLink ~= nil and 0 < #nameLink then
      local ret = ""
      for k, v in ipairs(nameLink) do
        ret = ret + Localization:GetString(v)
      end
      return ret
    end
    local nameValue = template.name_value
    if nameValue ~= nil and 0 < table.count(nameValue) then
      for k, v in pairs(nameValue) do
        local vec1 = string.split(v, ";")
        if vec1 == nil or #vec1 == 0 then
          return Localization:GetString(tostring(k))
        elseif #vec1 == 1 then
          return Localization:GetString(tostring(k), vec1[1])
        elseif #vec1 == 2 then
          return Localization:GetString(tostring(k), vec1[1], vec1[2])
        elseif #vec1 == 3 then
          return Localization:GetString(tostring(k), vec1[1], vec1[2], vec1[3])
        end
      end
      return Localization:GetString(name)
    end
    if template.type == GOODS_TYPE.GOODS_TYPE_99 or template.type == GOODS_TYPE.GOODS_TYPE_93 then
      return Localization:GetString(name, HeroUtils.GetHeroNameByConfigId(template.para2))
    end
    return Localization:GetString(name)
  end
end

local function GetDes(self, itemId)
  local template = self:GetItemTemplate(itemId)
  if template == nil or template.description == "" then
    return ""
  end
  local desc = template.description
  if template.type == GOODS_TYPE.GOODS_TYPE_99 then
    return Localization:GetString(desc, template.para1, HeroUtils.GetHeroNameByConfigId(template.para2))
  elseif template.type == GOODS_TYPE.GOODS_TYPE_109 then
    local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(template.para1), DataCenter.BuildManager.MainLv, tonumber(template.para2))
    if returnItem ~= nil then
      return Localization:GetString(desc, string.GetFormattedStr2(returnItem.num * tonumber(template.para3)))
    else
      return Localization:GetString(desc, "", 0)
    end
  elseif template.type == GOODS_TYPE.GOODS_TYPE_134 then
    local useCount = 0
    local masteryData = DataCenter.MasteryManager:GetData()
    if masteryData and masteryData.seasonItemCount[itemId] then
      useCount = masteryData.seasonItemCount[itemId]
    end
    return Localization:GetString(desc, template.para1, template.para2, useCount)
  elseif template.type == GOODS_TYPE.GOODS_TYPE_140 then
    local vipWorkerEffectVal1 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_VIP_WORKER_DETECT_REWARD_LIMIT)
    local paraStr = ""
    if 0 < vipWorkerEffectVal1 then
      local vipWorkerGetNumToday = DataCenter.WorkerDataManager:GetVipWorkerRewardTimes()
      local accumulateCount = DataCenter.WorkerDataManager:GetVipWorkerAccumulateCount() or 0
      local maxAccumulateCount = accumulateCount
      local canGetNum = maxAccumulateCount - vipWorkerGetNumToday
      canGetNum = math.max(canGetNum, 0)
      local maxCount = LuaEntry.DataConfig:TryGetNum("worker_box_config", "k1")
      paraStr = Localization:GetString("item_desc2_extra520111", canGetNum, maxAccumulateCount, maxCount)
    end
    return Localization:GetString(desc, paraStr)
  elseif template.type == GOODS_TYPE.GOODS_TYPE_135 then
    return Localization:GetString(desc, template.para1)
  elseif template.type == GOODS_TYPE.GOODS_TYPE_59 or template.type == GOODS_TYPE.GOODS_TYPE_138 then
    local localizedStr = Localization:GetString(desc)
    if string.contains(localizedStr, "{0}") then
      local paramStr = ""
      if not string.IsNullOrEmpty(template.para1) then
        local paraList = string.split(template.para1, "|")
        for i, v in pairs(paraList) do
          local paraPair = string.split(v, ",")
          if #paraPair == 2 or #paraPair == 3 then
            local itemId = 0
            if #paraPair == 2 then
              itemId = paraPair[1]
            else
              itemId = paraPair[2]
            end
            local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
            if itemTemplate ~= nil then
              if string.IsNullOrEmpty(paramStr) then
                paramStr = itemTemplate:GetName()
              else
                paramStr = paramStr .. "," .. itemTemplate:GetName()
              end
            end
          end
        end
      end
      return Localization:GetString(desc, paramStr)
    else
      return localizedStr
    end
  elseif template.type == GOODS_TYPE.GOODS_TYPE_DRAW_BOX then
    local localizedStr = Localization:GetString(desc)
    if string.contains(localizedStr, "{0}") then
      local groupId = checknumber(template.para1)
      local drawBoxData = DataCenter.BoxItemDrawManager:GetUserData(groupId)
      if drawBoxData then
        return Localization:GetString(desc, tostring(drawBoxData:GetCurTotalLeftCount()))
      end
    end
  elseif template.type == GOODS_TYPE.GOODS_TYPE_147 or template.type == GOODS_TYPE.GOODS_TYPE_176 then
    local dailyNum = 0
    local eventId = tonumber(template.para2) or 0
    if 0 < eventId then
      dailyNum = DataCenter.ActDetectTreasureDataManager:GetMaxDigTimes(eventId)
    end
    return Localization:GetString(desc, dailyNum)
  elseif template.type == GOODS_TYPE.GOODS_TYPE_166 then
    local needNum = DataCenter.ExplorerTreasureManager:GetTreasureOpenNeedItemNum()
    return Localization:GetString(desc, needNum)
  elseif template.type == GOODS_TYPE.GOODS_TYPE_173 then
    local activityId = tonumber(template.para5) or 0
    local config = DataCenter.ActConcertDataManager:GetConcertListViewConfig(activityId)
    local bubbleLimit = config.bubbleLimit
    return Localization:GetString(desc, bubbleLimit)
  elseif template.type == GOODS_TYPE.GOODS_TYPE_101 then
    local payExpData = DataCenter.FirstPayManager:GetCurBuildExpData()
    if payExpData and toInt(itemId) == payExpData.goldPigItemId then
      return Localization:GetString(desc, string.GetFormattedStr0(payExpData.expMaxLimit))
    end
  end
  return Localization:GetString(desc)
end

local function GetToolBgByColor(self, color)
  return UIUtil.GetItemQualityBg(color)
end

local function GetShowTime(self, para1, para2)
  if para2 == "m" then
    return tonumber(para1) * 60000
  elseif para2 == "h" then
    return tonumber(para1) * 3600000
  elseif para2 == "d" then
    return tonumber(para1) * 86400000
  end
end

local function IsNewVersionGoods(self, version)
  if version == nil or version == "" then
    return false
  end
  local tempVec1 = string.split(version, ".")
  local tempVec2 = string.split(GlobalData.version, ".")
  if #tempVec1 == #tempVec2 then
    for i = 1, #tempVec1 do
      if tonumber(tempVec1[i]) > tonumber(tempVec2[i]) then
        UIUtil.ShowTipsId(120034)
        return true
      end
    end
  end
  return false
end

local function GetAllianceItemTemplate(self)
  if self.allianceItemTemplate ~= nil then
    table.sort(self.allianceItemTemplate, function(a, b)
      return a.alliance_order > b.alliance_order
    end)
  end
  return self.allianceItemTemplate
end

local function GetIconPath(self, itemId)
  local itemInfo = self:GetItemTemplate(itemId)
  if itemInfo == nil or itemInfo.icon == nil then
    return DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Electricity)
  end
  return string.format(LoadPath.ItemPath, itemInfo.icon)
end

local function GetAllianceItemIconPath(self, aItemType)
  if aItemType == RewardType.ALLIANCE_POINT then
    return string.format(LoadPath.UIAlliance, "UIAlliance_icon_alliance_point")
  elseif aItemType == RewardType.ALLIANCE_DONATE then
    return string.format(LoadPath.ItemPath, "item600001")
  elseif aItemType == RewardType.ALLIANCE_SCIENCE_TECH_POINT then
    return string.format(LoadPath.UILWAlliance, "zyf_lianmengkejijuanxian_exp")
  end
  return DataCenter.ResourceManager:GetResourceIconByType(aItemType)
end

local function GetItemType(self, itemId)
  local template = self:GetItemTemplate(itemId)
  if template ~= nil then
    return template.type
  end
  return GOODS_TYPE_0
end

local function CheckDecorationEternalByGoodsType113ID(self, itemId)
  local isEternal = false
  local eternalType = GoodsType113DecorationEternalType.None
  local temp = self:GetItemTemplate(itemId)
  if temp and temp.type == GOODS_TYPE.GOODS_TYPE_113 then
    local decoId = tonumber(temp.para1) or 0
    local decoData = DataCenter.DecorationDataManager:GetSkinDataById(decoId)
    local decoTemp = DataCenter.DecorationTemplateManager:GetTemplate(decoId)
    if isEternal == false and decoData and 0 >= decoData.expireTime then
      isEternal = true
      eternalType = GoodsType113DecorationEternalType.HaveDeco
    end
    if isEternal == false and decoTemp then
      local gainMethod = decoTemp.gainMethod
      for k, v in ipairs(gainMethod) do
        local goodTemp = self:GetItemTemplate(v.id)
        if goodTemp and goodTemp.type == GOODS_TYPE.GOODS_TYPE_113 then
          local decoTime = tonumber(goodTemp.para2) or 0
          if decoTime <= 0 then
            local curNum = DataCenter.ItemData:GetItemCount(v.id)
            if 0 < curNum then
              isEternal = true
              eternalType = GoodsType113DecorationEternalType.HaveGoods
              break
            end
          end
        end
      end
    end
  end
  return isEternal, eternalType
end

function ItemTemplateManager:CheckDecorationEternalByGoodsType149ID(itemId)
  local temp = self:GetItemTemplate(itemId)
  if temp and temp.type == GOODS_TYPE.GOODS_TYPE_149 then
    local decoId = tonumber(temp.para1) or 0
    if decoId and 0 < decoId then
      local isUnlock = DataCenter.StickerWithDecorationLinkManager:CheckIsPermanentUnlockByStickId(decoId)
      if isUnlock then
        return true
      end
    end
  end
  return false
end

local function GetResGoodsUnitNum(self, itemId, index, multilayer)
  local template = self:GetItemTemplate(itemId)
  if template == nil then
    return
  end
  return ItemTemplateManager.GetResGoodsUnitNumByTemplate(self, template, index, multilayer)
end

local function GetResGoodsUnitNumByTemplate(self, template, index, multilayer)
  if template == nil then
    return
  end
  local type = template.type
  if type == GOODS_TYPE.GOODS_TYPE_3 then
    local type2 = template.type2
    if type2 ~= 999 and not string_IsNullOrEmpty(template.para) then
      return tonumber(template.para)
    end
  elseif type == GOODS_TYPE.GOODS_TYPE_109 then
    local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(template.para1), DataCenter.BuildManager.MainLv, tonumber(template.para2))
    if returnItem ~= nil then
      return returnItem.num * tonumber(template.para3)
    end
  elseif type == GOODS_TYPE.GOODS_TYPE_59 then
    if multilayer then
      return
    end
    if not string_IsNullOrEmpty(template.para1) then
      local paraList = string_split(template.para1, "|")
      if index then
        if index < 0 then
          index = 1
        elseif index >= #paraList then
          index = #paraList
        end
      else
        index = 1
      end
      local paraPair = string_split(paraList[index], ",")
      return self:GetResGoodsUnitNum(paraPair[1], nil, true)
    end
  end
end

function ItemTemplateManager:GetItemPrice(itemId)
  local template = self:GetItemTemplate(itemId)
  if template ~= nil then
    return toInt(template.price)
  end
  return 0
end

ItemTemplateManager.__init = __init
ItemTemplateManager.__delete = __delete
ItemTemplateManager.GetItemTemplate = GetItemTemplate
ItemTemplateManager.InitAllTemplate = InitAllTemplate
ItemTemplateManager.AddStoreItem = AddStoreItem
ItemTemplateManager.GetTypeListByType = GetTypeListByType
ItemTemplateManager.GetStoreByBtnType = GetStoreByBtnType
ItemTemplateManager.GetCommonHeroFrameByColor = GetCommonHeroFrameByColor
ItemTemplateManager.GetHeroFrame = GetHeroFrame
ItemTemplateManager.GetHeroFrameTemplateByHeroId = GetHeroFrameTemplateByHeroId
ItemTemplateManager.GetName = GetName
ItemTemplateManager.GetDes = GetDes
ItemTemplateManager.GetToolBgByColor = GetToolBgByColor
ItemTemplateManager.GetShowTime = GetShowTime
ItemTemplateManager.IsNewVersionGoods = IsNewVersionGoods
ItemTemplateManager.GetAllianceItemTemplate = GetAllianceItemTemplate
ItemTemplateManager.GetIconPath = GetIconPath
ItemTemplateManager.GetTypeListByTypes = GetTypeListByTypes
ItemTemplateManager.GetItemByPara = GetItemByPara
ItemTemplateManager.GetItemByParaAndType = GetItemByParaAndType
ItemTemplateManager.GetAllianceItemIconPath = GetAllianceItemIconPath
ItemTemplateManager.GetItemType = GetItemType
ItemTemplateManager.CheckDecorationEternalByGoodsType113ID = CheckDecorationEternalByGoodsType113ID
ItemTemplateManager.GetResGoodsUnitNum = GetResGoodsUnitNum
ItemTemplateManager.GetResGoodsUnitNumByTemplate = GetResGoodsUnitNumByTemplate
return ItemTemplateManager
