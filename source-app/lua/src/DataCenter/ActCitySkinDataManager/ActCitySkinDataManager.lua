local ActCitySkinDataManager = BaseClass("ActCitySkinDataManager")
local Localization = CS.GameEntry.Localization

function ActCitySkinDataManager:__init()
  self.citySkinGetActInfos = {}
  self.citySkinExchangeInfos = {}
  self.exchangeTemplates = {}
  self.hasAddListener = false
  self.prevExchangeRedPointCount = nil
  self.onItemUpdateAction = BindCallback(self, self.OnItemUpdate)
end

function ActCitySkinDataManager:__delete()
  if self.hasAddListener then
    self:RemoveListener()
  end
  self.citySkinGetActInfos = nil
  self.citySkinExchangeInfos = nil
  self.exchangeTemplates = nil
  self.prevExchangeRedPointCount = nil
  self.onItemUpdateAction = nil
end

function ActCitySkinDataManager:OnItemUpdate()
  if not table.IsNullOrEmpty(self.citySkinExchangeInfos) then
    local count = 0
    for i, v in pairs(self.citySkinExchangeInfos) do
      count = count + self:GetExchangeRedPoint(v.id)
    end
    local boradCast = false
    if self.prevExchangeRedPointCount == nil and 0 < count then
      boradCast = true
    elseif self.prevExchangeRedPointCount ~= nil and self.prevExchangeRedPointCount ~= count then
      boradCast = true
    end
    if boradCast then
      self.prevExchangeRedPointCount = count
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

function ActCitySkinDataManager:AddListener()
  if not self.hasAddListener then
    self.hasAddListener = true
    EventManager:GetInstance():AddListener(EventId.RefreshItems, self.onItemUpdateAction)
    EventManager:GetInstance():AddListener(EventId.CitySkinExchange, self.onItemUpdateAction)
  end
end

function ActCitySkinDataManager:RemoveListener()
  if self.hasAddListener then
    self.hasAddListener = false
    EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.onItemUpdateAction)
    EventManager:GetInstance():RemoveListener(EventId.CitySkinExchange, self.onItemUpdateAction)
  end
end

function ActCitySkinDataManager:ParseActCitySkinGetMessage(msg)
  if not msg then
    return
  end
  local actInfo = {}
  actInfo.id = msg.id
  actInfo.surelyReward = msg.fixReward
  actInfo.randomReward = DataCenter.RewardManager:ReturnRewardParamForView(msg.randomReward)
  self.citySkinGetActInfos[tostring(actInfo.id)] = actInfo
end

function ActCitySkinDataManager:ParseActCitySkinExchangeMessage(msg)
  if not msg then
    return
  end
  local actInfo = {}
  actInfo.id = msg.id
  actInfo.items = msg.converts
  if not table.IsNullOrEmpty(actInfo.items) then
    for i, v in pairs(actInfo.items) do
      local template = self:GetExchangeTempalte(v.id)
      v.reward = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      v.needItems = {}
      v.tips_type = 0
      if template then
        v.needItems = template.needItems or {}
        v.tips_type = template.tips_type or 0
        v.buy_condition = template.buy_condition or {}
        v.common_buy_condition = template.common_buy_condition or ""
        v.order = template.order or 0
      end
    end
    table.sort(actInfo.items, function(a, b)
      if a.index and b.index then
        return a.index < b.index
      else
        return false
      end
    end)
  end
  self.citySkinExchangeInfos[tostring(actInfo.id)] = actInfo
  self:AddListener()
end

function ActCitySkinDataManager:GetActCitySkinGetInfo(aid)
  return self.citySkinGetActInfos[tostring(aid)]
end

function ActCitySkinDataManager:GetActCitySkinExchangeInfo(aid)
  return self.citySkinExchangeInfos[tostring(aid)]
end

function ActCitySkinDataManager:GetExchangeTempalte(id)
  if self.exchangeTemplates[id] then
    return self.exchangeTemplates[id]
  end
  local line = LocalController:instance():getLine(TableName.LW_CitySkin_Exchange, id)
  local template
  if line then
    template = {}
    template.id = line.id
    template.needItems = line.need_goods or {}
    template.maxCount = line.maxCount or 0
    template.tips_type = line.tips_type or 0
    template.buy_condition = line.buy_condition or {}
    template.order = tonumber(line.order) or 0
    template.common_buy_condition = line.common_buy_condition or ""
  end
  self.exchangeTemplates[id] = template
  return template
end

function ActCitySkinDataManager:SetExchangeTimes(aid, id, times)
  if not (aid and id) or not times then
    return
  end
  local actInfo = self:GetActCitySkinExchangeInfo(aid)
  if not actInfo then
    return
  end
  for i, v in pairs(actInfo.items) do
    if v.id == id then
      v.curCount = times
      break
    end
  end
end

function ActCitySkinDataManager:GetExchangeRedPoint(aid)
  local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(aid))
  if not actBaseInfo then
    return 0
  end
  if not actBaseInfo:IsValid() then
    return 0
  end
  local actInfo = self:GetActCitySkinExchangeInfo(aid)
  local count = 0
  if not actInfo then
    return count
  end
  local showExchangeRedPoint = self:GetExchangeRedPointConditon(actBaseInfo.id)
  if not showExchangeRedPoint then
    return count
  end
  for i, v in pairs(actInfo.items) do
    local isRewardDecoAndEternal = false
    if v.reward and 0 < #v.reward then
      local targetRewardData = v.reward[1]
      if targetRewardData.rewardType == RewardType.GOODS then
        local itemId = targetRewardData.itemId
        local itemtemp = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        if itemtemp and itemtemp.type == GOODS_TYPE.GOODS_TYPE_113 then
          isRewardDecoAndEternal = DataCenter.ItemTemplateManager:CheckDecorationEternalByGoodsType113ID(itemId)
        end
      end
    end
    if isRewardDecoAndEternal == false and v.curCount < v.maxCount then
      local needItems = v.needItems
      local canExchange = true
      if not table.IsNullOrEmpty(v.buy_condition) then
        local selfLevel = DataCenter.BuildManager:GetMainLevel()
        for type, value in pairs(v.buy_condition) do
          if type == 1 then
            local needLevel = tonumber(value) or 0
            if selfLevel < needLevel then
              canExchange = false
              break
            end
          end
        end
      end
      if not string.IsNullOrEmpty(v.common_buy_condition) then
        local commonBuyConditions = DataCenter.RewardManager:ParseBuyConditionStr(v.common_buy_condition)
        local inconsistentConditions = DataCenter.RewardManager:GetInconsistentBuyConditions(commonBuyConditions)
        if not table.IsNullOrEmpty(inconsistentConditions) then
          canExchange = false
          break
        end
      end
      if not table.IsNullOrEmpty(needItems) then
        for id, count in pairs(needItems) do
          local haveCount = DataCenter.ItemData:GetItemCount(id)
          if count > haveCount then
            canExchange = false
            break
          end
        end
      end
      if canExchange then
        count = count + 1
      end
    end
  end
  return count
end

function ActCitySkinDataManager:GetExchangeRedPointConditon(actId)
  local actStr = string.format("%s_%s", SettingKeys.ACT_CITYSKIN_EXCHANGE_REDPOINT, actId)
  return CS.GameEntry.Setting:GetPrivateBool(actStr, true)
end

function ActCitySkinDataManager:SetExchangeRedPointConditon(actId, showRedPoint)
  local prevValue = self:GetExchangeRedPointConditon(actId)
  local actStr = string.format("%s_%s", SettingKeys.ACT_CITYSKIN_EXCHANGE_REDPOINT, actId)
  CS.GameEntry.Setting:SetPrivateBool(actStr, showRedPoint)
  if prevValue ~= showRedPoint then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return ActCitySkinDataManager
