local TacticalCardCustomPresetData = BaseClass("TacticalCardCustomPresetData")
local TacticalCardGroupData = require("DataCenter.TacticalCardManager.TacticalCardGroupData")
local DEFAULT_NAMES = {
  "Custom Plan 1",
  "Custom Plan 2",
  "Custom Plan 3"
}

local function ParseCustomPlanCards(serverPlan)
  if type(serverPlan) ~= "table" then
    return nil
  end
  local cards = {}
  for _, card in pairs(serverPlan) do
    if type(card) == "table" then
      local slotId = tonumber(card.slotId or card.slot)
      local cardId = tonumber(card.cardId)
      if slotId and cardId then
        local slotData = TacticalCardUtil.QuickGetSlotDataById(slotId)
        cards[slotId] = {
          slotId = slotId,
          slotType = slotData and slotData:GetSlotType() or nil,
          cardType = tonumber(card.cardType),
          cardId = cardId,
          uuid = card.uuid
        }
      end
    end
  end
  if table.count(cards) <= 0 then
    return nil
  end
  return cards
end

local function __init(self)
  self._customPlans = {}
  for i = 1, #self._customPlans do
    self._customPlans[i] = {
      name = DEFAULT_NAMES[i],
      cards = nil
    }
  end
  self._onChanged = nil
  self._onChangedOwner = nil
  self.isInit = false
end

local function __delete(self)
  self._customPlans = nil
  self._onChanged = nil
  self._onChangedOwner = nil
  self.isInit = nil
end

function TacticalCardCustomPresetData:InitData()
  self.isInit = true
  self.allCardGroupList = {}
  self.customCardSlotCount = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k20", 3)
  for i = 1, self.customCardSlotCount do
    local cardGroupData = TacticalCardGroupData.New()
    cardGroupData:Init(i)
    table.insert(self.allCardGroupList, cardGroupData)
  end
end

function TacticalCardCustomPresetData:GetAllCardGroupDataList()
  if not self.isInit then
    self:InitData()
  end
  return self.allCardGroupList or {}
end

function TacticalCardCustomPresetData:GetCustomCardGroupByIndex(index)
  if not self.isInit then
    self:InitData()
  end
  return self.allCardGroupList and self.allCardGroupList[index]
end

function TacticalCardCustomPresetData:GetCustomPlanCount()
  return self.allCardGroupList and #self.allCardGroupList or 0
end

function TacticalCardCustomPresetData:GetCustomPlan(index)
  return self:GetCustomCardGroupByIndex(index)
end

function TacticalCardCustomPresetData:SetChangedCallback(cb, owner)
  if type(cb) == "function" then
    self._onChanged = cb
    self._onChangedOwner = owner
    return
  end
  if owner ~= nil and self._onChangedOwner ~= owner then
    return
  end
  self._onChanged = nil
  self._onChangedOwner = nil
end

function TacticalCardCustomPresetData:UpdateData(msg)
  if not msg or not msg.plans then
    return
  end
  local plans = msg.plans
  local serverPlanDic = {}
  for _, v in pairs(plans) do
    local index = v.index
    serverPlanDic[index] = v
  end
  if self.allCardGroupList then
    for _, v in ipairs(self.allCardGroupList) do
      local index = v.index
      local serverData = serverPlanDic[index]
      if not serverData then
        v:ClearCardData()
      else
        v:UpdateDataFromServerData(serverData)
      end
    end
  end
end

function TacticalCardCustomPresetData:SaveCustomPlan(index, cards)
  if index < 1 or index > #self._customPlans then
    return
  end
  self._customPlans[index].cards = cards
end

function TacticalCardCustomPresetData:DeleteCustomPlan(index)
  if index < 1 or index > #self._customPlans then
    return
  end
  self._customPlans[index].cards = nil
end

TacticalCardCustomPresetData.__init = __init
TacticalCardCustomPresetData.__delete = __delete
return TacticalCardCustomPresetData
