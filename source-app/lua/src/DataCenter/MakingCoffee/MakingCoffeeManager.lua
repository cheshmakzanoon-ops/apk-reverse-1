local MakingCoffeeManager = BaseClass("MakingCoffeeManager")

function MakingCoffeeManager:__init()
  self.unlockDic = {}
  self.allStatus = {}
  self.allGoodsDic = nil
  self.productNum = 0
  self.productSpeedTime = 0
  self.productLastTime = 0
  self.productSettleTime = 0
  self.buildingId = 0
  self.maxCoffeeCount = nil
  self.makingCoffeeTask = nil
  self.remainTime = 0
  self:AddListeners()
end

function MakingCoffeeManager:__delete()
  self.unlockDic = nil
  self.productNum = nil
  self.productSpeedTime = nil
  self.productLastTime = nil
  self.productSettleTime = nil
  self.buildingId = nil
  self.maxCoffeeCount = nil
  self.allStatus = nil
  self.remainTime = nil
  if self.makingCoffeeTask then
    self.makingCoffeeTask:Stop()
    self.makingCoffeeTask = nil
  end
  self:RemoveListeners()
end

function MakingCoffeeManager:CheckUnlockCondition(config)
  if not config or config.unlock_goods == "0" then
    return false
  end
  local curNum = DataCenter.ItemData:GetItemCount(config.unlock_goods)
  return 0 < curNum
end

function MakingCoffeeManager:AddListeners()
  EventManager:GetInstance():AddListenerWithSelf(EventId.GF_item_refreshed, self.OnUpdateItems, self)
end

function MakingCoffeeManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener2(EventId.GF_item_refreshed, self.OnUpdateItems, self)
end

function MakingCoffeeManager:OnUpdateItems(goods)
  if not self.allGoodsDic then
    self:InitAllGoods()
  end
  if goods and self.allGoodsDic and self.allGoodsDic[goods.itemId] then
    EventManager:GetInstance():Broadcast(EventId.GetCoffeeGoods, goods.itemId)
  end
end

function MakingCoffeeManager:GetElapsedMilliseconds()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return curTime - self.productLastTime
end

function MakingCoffeeManager:GetNextTime()
  if self.productSpeedTime == 0 then
    return 0
  end
  local elapsed = self:GetElapsedMilliseconds()
  local remainTime = self.productSpeedTime - elapsed % self.productSpeedTime
  return remainTime
end

function MakingCoffeeManager:GetCurCoffeePercent()
  if self.productSpeedTime == 0 then
    return 0
  end
  return 1 - self:GetNextTime() / self.productSpeedTime
end

function MakingCoffeeManager:GetCurCount()
  if self.productSpeedTime == 0 then
    return 0
  end
  local elapsed = self:GetElapsedMilliseconds()
  local count = math.floor(elapsed / self.productSpeedTime)
  return math.min(self.productNum + count, self:GetMaxCoffeeCount())
end

function MakingCoffeeManager:GetCoffeeState()
  local curCount = self:GetCurCount()
  if curCount >= self:GetMaxCoffeeCount() then
    return CoffeeState.FULL
  elseif curCount == 0 then
    return CoffeeState.EMPTY
  else
    return CoffeeState.AVAILABLE
  end
end

function MakingCoffeeManager:UpdateTimerTask()
  if self.makingCoffeeTask then
    self.makingCoffeeTask:Stop()
    self.makingCoffeeTask = nil
  end
  local curCount = self:GetCurCount()
  if curCount < self:GetMaxCoffeeCount() then
    self.remainTime = self:GetNextTime() / 1000
    if self.remainTime > 0 then
      self.makingCoffeeTask = TimerManager:GetInstance():DelayInvoke(function()
        self:UpdateProductNum()
      end, self.remainTime)
    end
  end
end

function MakingCoffeeManager:UpdateProductNum()
  if self.productNum < self:GetMaxCoffeeCount() then
    self.productNum = self.productNum + 1
    self.productLastTime = UITimeManager:GetInstance():GetServerTime()
    EventManager:GetInstance():Broadcast(EventId.MakingCoffeeUpdate)
    if self:GetCurCount() < self:GetMaxCoffeeCount() then
      self:UpdateTimerTask()
    end
  end
end

function MakingCoffeeManager:SendUnlockMessage(coffeeId)
  SFSNetwork.SendMessage(MsgDefines.CoffeeStatusUnlock, coffeeId)
end

function MakingCoffeeManager:SendCoffeeStatusUse(coffeeId)
  SFSNetwork.SendMessage(MsgDefines.CoffeeStatusUse, coffeeId)
end

function MakingCoffeeManager:OnInitMessage(message)
  self:UpdateCoffeeInfo(message)
  local count = self:GetCurCount()
end

function MakingCoffeeManager:OnCoffeeStatusUseMessage(message)
  self:UpdateCoffeeInfo(message)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWMakingCoffeeView)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITitleDrinkCoffeeView, {anim = true}, message.coffeeId)
end

function MakingCoffeeManager:UpdateCoffeeInfo(message)
  local coffeeInfo = message.coffeeInfo
  if not coffeeInfo then
    return
  end
  self:GetAllFreeConfigID()
  self:InitAllGoods()
  self.productNum = coffeeInfo.productNum or 0
  self.productLastTime = coffeeInfo.productLastTime or 0
  self.productSettleTime = coffeeInfo.productSettleTime or 0
  self.productSpeedTime = coffeeInfo.productSpeedTime or 0
  self.buildingId = coffeeInfo.buildingId or 0
  self:UpdateTimerTask()
  if coffeeInfo.unlockArr then
    for _, id in ipairs(coffeeInfo.unlockArr) do
      self:UnlockCoffee(id)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MakingCoffeeUpdate, self.productNum)
end

function MakingCoffeeManager:UnlockCoffee(coffeeId)
  if not self.unlockDic then
    self.unlockDic = {}
  end
  if not self.unlockDic[coffeeId] then
    self.unlockDic[coffeeId] = true
    EventManager:GetInstance():Broadcast(EventId.MakingCoffeeUnlock, coffeeId)
  end
end

function MakingCoffeeManager:GetIsUnlock(coffeeId)
  return self.unlockDic and self.unlockDic[coffeeId] or false
end

function MakingCoffeeManager:GetAllFreeConfigID()
  local freeIdList = DataCenter.MakingCoffeeTemplateManager:GetAllFreeConfigID()
  for _, id in ipairs(freeIdList) do
    self.unlockDic[id] = true
  end
end

function MakingCoffeeManager:GetAllNotUnLockCoffee()
  local coffeeList = DataCenter.MakingCoffeeTemplateManager:GetAllCoffeeList()
  local lockCoffeeList = {}
  for _, config in ipairs(coffeeList) do
    if not self.unlockDic[config.id] then
      table.insert(lockCoffeeList, config)
    end
  end
  return lockCoffeeList
end

function MakingCoffeeManager:HasUnlockableCoffee()
  for _, config in ipairs(self:GetAllNotUnLockCoffee()) do
    if self:CheckUnlockCondition(config) then
      return true
    end
  end
  return false
end

function MakingCoffeeManager:IsCanUnlocked(coffeeId)
  local config = DataCenter.MakingCoffeeTemplateManager:GetTemplate(coffeeId)
  return self:CheckUnlockCondition(config)
end

function MakingCoffeeManager:HasCoffeeStatus()
  if #self.allStatus == 0 then
    self.allStatus = DataCenter.MakingCoffeeTemplateManager:GetAllStatus()
  end
  for _, status in ipairs(self.allStatus) do
    if status and LuaEntry.Effect:HasStatus(status) then
      return true
    end
  end
  return false
end

function MakingCoffeeManager:GetMaxCoffeeCount()
  if not self.maxCoffeeCount then
    self.maxCoffeeCount = LuaEntry.DataConfig:TryGetNum("coffee_function", "k2")
  end
  return self.maxCoffeeCount
end

function MakingCoffeeManager:ShouldShowCoffeeTipOnAttack(serverId, uuid, targetType)
  if SeasonUtil.InSeasonBigMapMode(serverId) then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILDING_SEASON5_RESEARCH)
    if not buildData or buildData.level < 1 then
      return false
    end
    local count = self:GetCurCount()
    if count <= 0 then
      return false
    end
    local monster
    if targetType == MarchTargetType.JOIN_RALLY then
      local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
      if data and data.targetUid then
        monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.targetUid)
      end
    elseif targetType == MarchTargetType.ATTACK_MONSTER or targetType == MarchTargetType.RALLY_FOR_BOSS then
      local marchInfo = CS.SceneManager.World:GetMarch(uuid)
      if marchInfo and marchInfo.monsterId then
        monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
      end
    end
    if monster ~= nil then
      local data = {}
      if 0 < monster.monster_resistance and not DataCenter.MakingCoffeeManager:HasCoffeeStatus() then
        data.resistance = monster.monster_resistance + SeasonUtil.GetBloodyNightResistanceValueAdd()
        data.selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
        if data.selfValue < data.resistance then
          return true
        end
      end
    end
  end
  return false
end

function MakingCoffeeManager:InitAllGoods()
  if not self.allGoodsDic then
    self.allGoodsDic = {}
    local allList = DataCenter.MakingCoffeeTemplateManager:GetAllCoffeeList()
    for _, cfg in ipairs(allList) do
      if cfg.unlock_goods ~= "0" then
        self.allGoodsDic[cfg.unlock_goods] = true
      end
    end
  end
end

function MakingCoffeeManager:GetAllActiveStatus()
  local allList = DataCenter.MakingCoffeeTemplateManager:GetAllStatus()
  local list = {}
  for _, status in ipairs(allList) do
    if status and LuaEntry.Effect:HasStatus(status) then
      table.insert(list, status)
    end
  end
  return list
end

local Localization = CS.GameEntry.Localization

function MakingCoffeeManager:OpenDrinkCoffeeTip(callBack)
  local localDay = CommonUtil.PlayerPrefsGetInt("COFFEE_ATTACK", -1)
  local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
  if localDay == -1 or today ~= localDay then
    local param = {}
    param.Action = callBack
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWMakingCoffeeTipsView, {anim = true}, param)
  elseif callBack then
    callBack()
  end
end

return MakingCoffeeManager
