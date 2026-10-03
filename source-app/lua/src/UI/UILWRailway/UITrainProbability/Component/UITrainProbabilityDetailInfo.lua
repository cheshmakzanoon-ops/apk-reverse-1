local base = UIBaseContainer
local UITrainProbabilityDetailInfo = BaseClass("UITrainProbabilityDetailInfo", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UITrainProbabilityDetailItemTop = require("UI.UILWRailway.UITrainProbability.Component.UITrainProbabilityDetailItemTop")
local UITrainProbabilityDetailItemMiddle = require("UI.UILWRailway.UITrainProbability.Component.UITrainProbabilityDetailItemMiddle")
local UITrainProbabilityDetailItemBottom = require("UI.UILWRailway.UITrainProbability.Component.UITrainProbabilityDetailItemBottom")
local UIHeroRecruitTipRateDetailInfoItem2 = require("UI.UIHero2.UIHeroRecruitTipNew.Component.UIHeroRecruitTipRateDetailInfoItem2")
local ITEM_TYPE = {
  TOP = 1,
  MIDDLE = 2,
  BOTTOM = 3
}

function UITrainProbabilityDetailInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITrainProbabilityDetailInfo:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITrainProbabilityDetailInfo:ComponentDefine()
  self.scrollViewContent = self:AddComponent(UIBaseContainer, "scroll/Viewport/Content")
  self.scrollView = self:AddComponent(UILoopListView2, "scroll")
  self.scrollView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
end

function UITrainProbabilityDetailInfo:ComponentDestroy()
  self:ClearItems()
  self.scrollViewContent = nil
  self.scrollView = nil
end

function UITrainProbabilityDetailInfo:DataDefine()
  self._itemObjList = {}
  self.cellList = {}
  self.cellReqList = {}
end

function UITrainProbabilityDetailInfo:DataDestroy()
  self.cellList = nil
  self.cellReqList = nil
end

function UITrainProbabilityDetailInfo:GetItemScriptName(index)
  index = index + 1
  if index > table.length(self.showDataList) then
    return ""
  end
  local showData = self.showDataList[index]
  if showData then
    if showData.type == ITEM_TYPE.TOP then
      return UITrainProbabilityDetailItemTop
    elseif showData.type == ITEM_TYPE.MIDDLE then
      return UITrainProbabilityDetailItemMiddle
    elseif showData.type == ITEM_TYPE.BOTTOM then
      return UITrainProbabilityDetailItemBottom
    end
  end
end

function UITrainProbabilityDetailInfo:GetItemPrefabName(index)
  index = index + 1
  if index > table.length(self.showDataList) then
    return ""
  end
  local showData = self.showDataList[index]
  if showData then
    if showData.type == ITEM_TYPE.TOP then
      return "UITrainProbabilityItemTop"
    elseif showData.type == ITEM_TYPE.MIDDLE then
      return "UITrainProbabilityItemMiddle"
    elseif showData.type == ITEM_TYPE.BOTTOM then
      return "UITrainProbabilityItemBottom"
    end
  end
end

function UITrainProbabilityDetailInfo:GetRewardTypeByData(data)
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

function UITrainProbabilityDetailInfo:GetRewardNameByData(data)
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

function UITrainProbabilityDetailInfo:OnGetItemByIndex(listView, index)
  if index < 0 or index >= table.length(self.showDataList) then
    return nil
  end
  self.prefabIndex = self.prefabIndex or 0
  local itemScript = self:GetItemScriptName(index)
  local prefabName = self:GetItemPrefabName(index)
  local item = listView:NewListViewItem(prefabName)
  if item == nil then
    return nil
  end
  if itemScript == nil then
    Logger.LogError(">>>>  UITrainProbabilityDetailInfo:OnGetItemByIndex invalid script - " .. tostring(prefabName))
    return
  end
  local temp
  if self._itemObjList[item.gameObject.name] then
    temp = self._itemObjList[item.gameObject.name]
  else
    local objectName = prefabName .. tostring(self.prefabIndex)
    item.gameObject.name = tostring(objectName)
    self.prefabIndex = self.prefabIndex + 1
    temp = self.scrollViewContent:AddComponent(itemScript, item.gameObject.name)
    self._itemObjList[item.gameObject.name] = temp
  end
  temp:SetActive(true)
  temp:UpdateItem(self.showDataList[index + 1], index + 1)
  if self.showDataList[index + 1].type == ITEM_TYPE.MIDDLE then
    local dataList = self.showDataList[index + 1].data
    local dataCount = #dataList
    local hasChildCount = temp.content.transform.childCount
    local maxCount = Mathf.Max(dataCount, hasChildCount)
    for i = 1, maxCount do
      if i <= hasChildCount and i > dataCount then
        temp.content.transform:GetChild(i - 1).gameObject:SetActive(false)
      else
        local itemData = dataList[i]
        if itemData then
          do
            local param = UICommonResItem.Param.New()
            param.rewardType = self:GetRewardTypeByData(itemData)
            param.itemId = itemData.id
            param.count = itemData.num
            param.flag = itemData.flag
            local name = self:GetRewardNameByData(itemData)
            if i <= hasChildCount then
              local go = temp.content.transform:GetChild(i - 1).gameObject
              go:SetActive(true)
              self.cellList[go.name]:SetData(param, itemData.rate, name)
            else
              self.cellReqList[i] = self:GameObjectInstantiateAsync(UIAssets.PropNoticeItem, function(request)
                if request.isError then
                  return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(temp.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = "iconItem" .. NameCount
                go.name = nameStr
                NameCount = NameCount + 1
                local iconItem = self:AddComponent(UIHeroRecruitTipRateDetailInfoItem2, "scroll/Viewport/Content/" .. temp.gameObject.name .. "/Content/" .. nameStr)
                iconItem:SetData(param, itemData.rate, name)
                self.cellList[nameStr] = iconItem
              end)
            end
          end
        end
      end
    end
  end
  return item
end

function UITrainProbabilityDetailInfo:OnAddListener()
  base.OnAddListener(self)
end

function UITrainProbabilityDetailInfo:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITrainProbabilityDetailInfo:SetData(dataList)
  self:ClearItems()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.gameObject then
      self.showDataList = dataList
      self.scrollView:SetListItemCount(#self.showDataList, false, false)
    end
  end, 3)
end

function UITrainProbabilityDetailInfo:ClearItems()
  self._itemObjList = {}
  self.scrollViewContent:RemoveComponents(UITrainProbabilityDetailItemTop)
  self.scrollViewContent:RemoveComponents(UITrainProbabilityDetailItemMiddle)
  self.scrollViewContent:RemoveComponents(UITrainProbabilityDetailItemBottom)
  if self.cellReqList then
    self:RemoveComponents(UIHeroRecruitTipRateDetailInfoItem2)
    for k, v in pairs(self.cellReqList) do
      if v ~= nil then
        v:Destroy()
      end
    end
  end
  self.scrollView:ClearAllItems()
end

return UITrainProbabilityDetailInfo
