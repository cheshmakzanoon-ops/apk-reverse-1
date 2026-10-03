local UICommonTipRateDetailInfo = BaseClass("UICommonTipRateDetailInfo", UIBaseContainer)
local base = UIBaseContainer
local UIProbabilityNoticeItem = require("UI.UISurfing.UIAct.ProbabilityNotice.Component.UIProbabilityNoticeItem")
local UIHeroRecruitTipRateDetailInfoItem2 = require("UI.UIHero2.UIHeroRecruitTipNew.Component.UIHeroRecruitTipRateDetailInfoItem2")
local Localization = CS.GameEntry.Localization
local ITEM_TYPE = {TOP = 1, BOTTOM = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self._scrollViewContent = self:AddComponent(UIBaseContainer, "scroll/Viewport/Content")
  self._scrollView = self:AddComponent(UILoopListView2, "scroll")
  self._scrollView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearItems()
  self._scrollView = nil
end

local function DataDefine(self)
  self.showDict = nil
  self.showOrder = nil
  self._itemObjList = {}
  self.cellList = {}
  self.cellReqList = {}
  self.allReqs = {}
end

local function DataDestroy(self)
  self.showDict = nil
  self.showOrder = nil
  self.cellList = nil
  self.cellReqList = nil
  self.allReqs = nil
end

function UICommonTipRateDetailInfo:GetItemPrefabName(index)
  index = index + 1
  if index > table.length(self.showDataList) then
    return ""
  end
  local showData = self.showDataList[index]
  if showData then
    if showData.type == ITEM_TYPE.TOP then
      return "ProbabilityNoticeItemNew"
    elseif showData.type == ITEM_TYPE.BOTTOM then
      return "ProbabilityNoticeItemNewBottom"
    end
  end
end

local function GetRewardTypeByData(data)
  local rewardType
  if data.type == HeroRecruitRateDetailInfoType.Hero then
    rewardType = RewardType.HERO
  elseif data.type == HeroRecruitRateDetailInfoType.Goods then
    rewardType = RewardType.GOODS
  elseif data.type == HeroRecruitRateDetailInfoType.ResItem then
    rewardType = RewardType.RESOURCE_ITEM
  elseif data.type == HeroRecruitRateDetailInfoType.Worker then
    rewardType = RewardType.WORKER
  elseif data.type == HeroRecruitRateDetailInfoType.SquadEquip then
    rewardType = RewardType.CommonEquip
  elseif data.type == HeroRecruitRateDetailInfoType.Equip then
    rewardType = RewardType.EQUIP
  elseif data.type == HeroRecruitRateDetailInfoType.SkillChip then
    rewardType = RewardType.TWSkillChip
  end
  return rewardType
end

local function GetRewardNameByData(data)
  local name = ""
  if data.type == HeroRecruitRateDetailInfoType.Hero then
    name = DataCenter.RewardManager:GetNameByType(RewardType.HERO, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.Goods then
    name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.ResItem then
    name = DataCenter.RewardManager:GetNameByType(RewardType.RESOURCE_ITEM, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.Worker then
    name = DataCenter.RewardManager:GetNameByType(RewardType.WORKER, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.SquadEquip then
    name = DataCenter.RewardManager:GetNameByType(RewardType.CommonEquip, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.Equip then
    name = DataCenter.RewardManager:GetNameByType(RewardType.EQUIP, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.SkillChip then
    name = DataCenter.RewardManager:GetNameByType(RewardType.TWSkillChip, data.id)
  end
  return name
end

function UICommonTipRateDetailInfo:OnGetItemByIndex(listView, index)
  if index < 0 or index >= table.length(self.showDataList) then
    return nil
  end
  self.prefabIndex = self.prefabIndex or 0
  local itemScript = UIProbabilityNoticeItem
  local prefabName = self:GetItemPrefabName(index)
  local item = listView:NewListViewItem(prefabName)
  if item == nil then
    return nil
  end
  if itemScript == nil then
    Logger.LogError(">>>>  prefab - " .. tostring(prefabName))
    return
  end
  local temp
  if self._itemObjList[item.gameObject.name] then
    temp = self._itemObjList[item.gameObject.name]
  else
    local objectName = prefabName .. tostring(self.prefabIndex)
    item.gameObject.name = tostring(objectName)
    self.prefabIndex = self.prefabIndex + 1
    temp = self._scrollViewContent:AddComponent(itemScript, item.gameObject.name)
    self._itemObjList[item.gameObject.name] = temp
  end
  temp:SetActive(true)
  temp:UpdateItem(self.showDataList[index + 1], index + 1)
  if self.showDataList[index + 1] then
    local dataList = self.showDataList[index + 1].data
    local dataCount = #dataList
    local hasChildCount = temp.content.transform.childCount
    for i = 1, 5 do
      if i <= hasChildCount and i > dataCount then
        temp.content.transform:GetChild(i - 1).gameObject:SetActive(false)
      else
        local itemData = dataList[i]
        if itemData then
          do
            local param = UICommonResItem.Param.New()
            param.rewardType = GetRewardTypeByData(itemData)
            param.itemId = itemData.id
            param.count = itemData.num
            param.flag = itemData.flag
            local name = GetRewardNameByData(itemData)
            if i <= hasChildCount then
              local go = temp.content.transform:GetChild(i - 1).gameObject
              go:SetActive(true)
              self.cellList[go.name]:SetData(param, itemData.rate, name)
            else
              self.cellReqList[i] = self:GameObjectInstantiateAsync(UIAssets.PropNoticeItemNew, function(request)
                if request.isError or table.IsNullOrEmpty(temp) or temp.content == nil then
                  return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(temp.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = "iconItem" .. NameCount
                go.name = nameStr
                NameCount = NameCount + 1
                local iconItem = self:AddComponent(UIHeroRecruitTipRateDetailInfoItem2, "scroll/Viewport/Content/" .. temp.gameObject.name .. "/rewardContent/" .. nameStr)
                iconItem:SetData(param, itemData.rate, name)
                self.cellList[nameStr] = iconItem
              end)
              table.insert(self.allReqs, self.cellReqList[i])
            end
          end
        end
      end
    end
  end
  return item
end

local function GetQualityName(type)
  local name = ""
  if type == ItemColor.GOLDEN then
    name = Localization:GetString("drop_info_quality6")
  elseif type == ItemColor.ORANGE then
    name = Localization:GetString("drop_info_quality5")
  elseif type == ItemColor.PURPLE then
    name = Localization:GetString("drop_info_quality4")
  elseif type == ItemColor.BLUE then
    name = Localization:GetString("drop_info_quality3")
  elseif type == ItemColor.GREEN then
    name = Localization:GetString("drop_info_quality2")
  elseif type == ItemColor.WHITE then
    name = Localization:GetString("drop_info_quality1")
  end
  return name
end

local function GetQualityIconBg(type)
  local icon = ""
  if type == ItemColor.GOLDEN then
    icon = "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_hong.png"
  elseif type == ItemColor.ORANGE then
    icon = "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_cheng.png"
  elseif type == ItemColor.PURPLE then
    icon = "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_zi.png"
  elseif type == ItemColor.BLUE then
    icon = "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_lan.png"
  elseif type == ItemColor.GREEN then
    icon = "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_lv.png"
  elseif type == ItemColor.WHITE then
    icon = "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_bai.png"
  end
  return icon
end

local function GetQualityByTypeAndId(type, id)
  if type == HeroRecruitRateDetailInfoType.Hero then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(id)
    return heroTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Goods then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    return itemTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.ResItem then
    local resItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
    return resItemTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Worker then
    local workerTemplate = DataCenter.WorkerTemplateManager:GetShowTemplateById(id)
    return workerTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.SquadEquip then
    local squadEquipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(id)
    return squadEquipTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Equip then
    local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(id)
    return equipTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.SkillChip then
    local chipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(id)
    return chipTemplate.quality
  end
end

local function SetData(self, dropInfoDetail)
  self:ClearItems()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.gameObject then
      self.showDict = {}
      self.showDict[ItemColor.GOLDEN] = {}
      self.showDict[ItemColor.ORANGE] = {}
      self.showDict[ItemColor.PURPLE] = {}
      self.showDict[ItemColor.BLUE] = {}
      self.showDict[ItemColor.GREEN] = {}
      self.showDict[ItemColor.WHITE] = {}
      self.showOrder = {
        ItemColor.GOLDEN,
        ItemColor.ORANGE,
        ItemColor.PURPLE,
        ItemColor.BLUE,
        ItemColor.GREEN,
        ItemColor.WHITE
      }
      local dropList = string.split(dropInfoDetail, "|")
      for _, v in ipairs(dropList) do
        local dropItem = string.split(v, ";")
        if #dropItem == 4 then
          local type = tonumber(dropItem[1])
          local id = tonumber(dropItem[2])
          local num = tonumber(dropItem[3])
          local rate = tonumber(dropItem[4])
          rate = rate * 100
          local quality = GetQualityByTypeAndId(type, id)
          if self.showDict[quality] ~= nil then
            table.insert(self.showDict[quality], {
              type = type,
              id = id,
              num = num,
              rate = rate
            })
          end
        end
      end
      self.showDataList = {}
      for itemListIndex = 1, #self.showOrder do
        local quality = self.showOrder[itemListIndex]
        if #self.showDict[quality] ~= 0 then
          local dataList = self.showDict[quality]
          local totalRate = 0
          for itemIndex = 1, #dataList do
            local itemData = dataList[itemIndex]
            totalRate = totalRate + itemData.rate
          end
          local name = GetQualityName(quality)
          local icon = GetQualityIconBg(quality)
          local isFirst = true
          local dataCount = #dataList
          for i = 1, dataCount, 5 do
            local horDataList = {}
            for j = i, i + 4 do
              if j <= dataCount then
                table.insert(horDataList, dataList[j])
              end
            end
            if isFirst then
              table.insert(self.showDataList, {
                type = ITEM_TYPE.TOP,
                name = name,
                rate = totalRate,
                data = horDataList,
                icon = icon
              })
              isFirst = false
            else
              table.insert(self.showDataList, {
                type = ITEM_TYPE.BOTTOM,
                name = name,
                rate = totalRate,
                data = horDataList,
                icon = icon
              })
            end
          end
        end
      end
      self._scrollView:SetListItemCount(#self.showDataList, false, false)
    end
  end, 3)
end

function UICommonTipRateDetailInfo:SetDataNew(dropInfoDetail)
  self:ClearItems()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.gameObject then
      self.showDict = dropInfoDetail
      self.showOrder = {
        ItemColor.GOLDEN,
        ItemColor.ORANGE,
        ItemColor.PURPLE,
        ItemColor.BLUE,
        ItemColor.GREEN,
        ItemColor.WHITE
      }
      self.showDataList = {}
      for itemListIndex = 1, #self.showOrder do
        local quality = self.showOrder[itemListIndex]
        if #self.showDict[quality] ~= 0 then
          local dataList = self.showDict[quality]
          local totalRate = 0
          for itemIndex = 1, #dataList do
            local itemData = dataList[itemIndex]
            totalRate = totalRate + itemData.rate
          end
          local name = GetQualityName(quality)
          local isFirst = true
          local dataCount = #dataList
          for i = 1, dataCount, 5 do
            local horDataList = {}
            for j = i, i + 4 do
              if j <= dataCount then
                table.insert(horDataList, dataList[j])
              end
            end
            if isFirst then
              table.insert(self.showDataList, {
                type = ITEM_TYPE.TOP,
                name = name,
                rate = totalRate,
                data = horDataList
              })
              isFirst = false
            else
              table.insert(self.showDataList, {
                type = ITEM_TYPE.BOTTOM,
                name = name,
                rate = totalRate,
                data = horDataList
              })
            end
          end
        end
      end
      self._scrollView:SetListItemCount(#self.showDataList, false, false)
    end
  end, 3)
end

local function SetDataForSynthesisRate(self, data)
  self:ClearItems()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.gameObject then
      self.showDict = {}
      self.showDict[ItemColor.GOLDEN] = {}
      self.showDict[ItemColor.ORANGE] = {}
      self.showDict[ItemColor.PURPLE] = {}
      self.showDict[ItemColor.BLUE] = {}
      self.showDict[ItemColor.GREEN] = {}
      self.showDict[ItemColor.WHITE] = {}
      self.showOrder = {
        ItemColor.GOLDEN,
        ItemColor.ORANGE,
        ItemColor.PURPLE,
        ItemColor.BLUE,
        ItemColor.GREEN,
        ItemColor.WHITE
      }
      for k, v in pairs(data.rareArray) do
        local quality = k
        local item = v
        for i = 1, #item do
          local type = item[i].type
          local id = item[i].id
          local num = item[i].num
          local rate = item[i].weight / data.totalWeight * 100
          table.insert(self.showDict[quality], {
            type = type,
            id = id,
            num = num,
            rate = rate
          })
        end
      end
      self.showDataList = {}
      for itemListIndex = 1, #self.showOrder do
        local quality = self.showOrder[itemListIndex]
        if #self.showDict[quality] ~= 0 then
          local dataList = self.showDict[quality]
          local totalRate = 0
          for itemIndex = 1, #dataList do
            local itemData = dataList[itemIndex]
            totalRate = totalRate + itemData.rate
          end
          local name = GetQualityName(quality)
          local isFirst = true
          if data.overrideName ~= nil then
            name = data.overrideName
          end
          local dataCount = #dataList
          for i = 1, dataCount, 5 do
            local horDataList = {}
            for j = i, i + 4 do
              if j <= dataCount then
                table.insert(horDataList, dataList[j])
              end
            end
            if isFirst then
              table.insert(self.showDataList, {
                type = ITEM_TYPE.TOP,
                name = name,
                rate = totalRate,
                data = horDataList
              })
              isFirst = false
            else
              table.insert(self.showDataList, {
                type = ITEM_TYPE.BOTTOM,
                name = name,
                rate = totalRate,
                data = horDataList
              })
            end
          end
        end
      end
      self._scrollView:SetListItemCount(#self.showDataList, false, false)
    end
  end, 3)
end

local function SetDataForRewardProbability(self, data)
  self:ClearItems()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.gameObject then
      self.showDataList = {}
      for i = 1, #data do
        local tItemRateMap = data[i].tItemRateMap
        local tItemList = {}
        for k, v in ipairs(tItemRateMap) do
          local tItemInfo = {}
          tItemInfo.type = HeroRecruitRateDetailInfoType.Goods
          tItemInfo.id = v.nItemId
          tItemInfo.num = v.nNum
          tItemInfo.rate = v.nRate * 100
          table.insert(tItemList, tItemInfo)
        end
        local isFirst = true
        local nBegin = data[i].nBeginOrderId
        local nEnd = data[i].nEndOrderId
        local sDes
        if not nEnd then
          sDes = Localization:GetString("armed_truck_idle_reward_weight_2", nBegin)
        else
          sDes = Localization:GetString("armed_truck_idle_reward_weight_1", nBegin, nEnd)
        end
        local nCurStageId = DataCenter.LWJeepAdventureManager:GetCurStageIdByType(JeepAdventurePageType.Domintor)
        local bIsDuring = false
        if nBegin <= nCurStageId and (nEnd == nil or nEnd >= nCurStageId) then
          bIsDuring = true
        end
        local sCur = Localization:GetString("armed_truck_idle_reward_current")
        if bIsDuring then
          sDes = sDes .. sCur
        end
        if isFirst then
          table.insert(self.showDataList, {
            type = ITEM_TYPE.TOP,
            name = sDes,
            rate = tItemList
          })
          isFirst = false
        else
          table.insert(self.showDataList, {
            type = ITEM_TYPE.BOTTOM,
            name = sDes,
            rate = tItemList
          })
        end
      end
      self._scrollView:SetListItemCount(#self.showDataList, false, false)
    end
  end, 3)
end

local function ClearItems(self)
  self._itemObjList = {}
  self._scrollViewContent:RemoveComponents(UIProbabilityNoticeItem)
  self._scrollView:ClearAllItems()
  if self.allReqs then
    self:RemoveComponents(UIHeroRecruitTipRateDetailInfoItem2)
    for k, v in pairs(self.allReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.allReqs = {}
  end
end

UICommonTipRateDetailInfo.OnCreate = OnCreate
UICommonTipRateDetailInfo.OnDestroy = OnDestroy
UICommonTipRateDetailInfo.ComponentDefine = ComponentDefine
UICommonTipRateDetailInfo.ComponentDestroy = ComponentDestroy
UICommonTipRateDetailInfo.DataDefine = DataDefine
UICommonTipRateDetailInfo.DataDestroy = DataDestroy
UICommonTipRateDetailInfo.SetData = SetData
UICommonTipRateDetailInfo.ClearItems = ClearItems
UICommonTipRateDetailInfo.SetDataForSynthesisRate = SetDataForSynthesisRate
UICommonTipRateDetailInfo.SetDataForRewardProbability = SetDataForRewardProbability
return UICommonTipRateDetailInfo
