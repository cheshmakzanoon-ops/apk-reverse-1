local RewardManager = BaseClass("RewardManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.param = {}
end

local function __delete(self)
  self.param = nil
end

local function AddOneReward(message)
  local eventId
  local type = message.type
  if type ~= nil then
    if type == RewardType.EXP then
      if message.total ~= nil then
        LuaEntry.Player.exp = message.total
      end
    elseif type == RewardType.POWER then
      if message.total ~= nil then
        LuaEntry.Player.questPower = message.total
      end
    elseif type == RewardType.OIL then
      if message.total ~= nil then
        LuaEntry.Resource.oil = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.OBSIDIAN then
      if message.total ~= nil then
        LuaEntry.Resource.obsidian = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.FLINT then
      if message.total ~= nil then
        LuaEntry.Resource.flint = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.METAL then
      if message.total ~= nil then
        LuaEntry.Resource.metal = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.WATER then
      if message.total ~= nil then
        LuaEntry.Resource.water = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.FOOD then
      if message.total ~= nil then
        LuaEntry.Resource.money = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.ELECTRICITY then
      if message.total ~= nil then
        LuaEntry.Resource.electricity = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.PVE_POINT then
      if message.total ~= nil then
        LuaEntry.Resource.pvePoint = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.PEOPLE then
      if message.total ~= nil then
        LuaEntry.Resource.people = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.GOODS then
      if message.value ~= nil then
        local value = message.value
        if tonumber(value.itemId) == 200022 then
          local delay = CS.SceneManager.IsInPVE() and 1 or 0.1
          if DataCenter.BuildManager.MainLv >= LuaEntry.DataConfig:TryGetNum("get_item_tips", "k1") and DataCenter.BuildManager.MainLv < BuildLevelCap then
            local param = {}
            param.total = value.count
            param.add = value.rewardAdd
            param.threshold = DataCenter.BuildManager:GetMainUpgradeNeedItemCount()
            param.name = self:GetNameByType(RewardType.GOODS, value.itemId)
            param.icon = self:GetPicByType(RewardType.GOODS, value.itemId)
            TimerManager:GetInstance():DelayInvoke(function()
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIRecruitLotteryTip, {anim = false, playEffect = false}, param)
            end, delay)
          end
        elseif tonumber(value.itemId) == 1520001 then
          eventId = EventId.ChangeTruckItemNumChange
        end
        DataCenter.ItemData:UpdateOneItem(message.value)
      end
    elseif type == RewardType.ARM then
      local dic = message.value
      if dic ~= nil then
        local armyInfo = DataCenter.ArmyManager:FindArmy(dic.itemId)
        if armyInfo ~= nil then
          armyInfo.free = armyInfo.free + dic.count
        end
      end
    elseif type == RewardType.PTGOLD then
      if message.total ~= nil then
        LuaEntry.Player.ptGold = message.total
      end
    elseif type == RewardType.ITEM_EFFECT then
      local dic = message.value
      if dic ~= nil and dic.status ~= nil and dic.effectState ~= nil then
        for k, v in pairs(dic.status) do
          local id = v.stateId
          local qtype = GetTableData(TableName.StatusTab, id, "type2")
          if qtype ~= nil and qtype ~= "" then
            local eTime, b2 = math.modf(dic.effectState.id / 1000)
            local eId = tonumber(id)
            if eId ~= nil and eId ~= 0 then
              LuaEntry.Effect:AddStatus(eId, eTime)
            end
          end
        end
      end
    elseif type == RewardType.RESOURCE_ITEM then
      if message.value ~= nil then
        DataCenter.ResourceItemDataManager:RefreshOneItem(message.value)
        eventId = EventId.RefreshResourceItem
      end
    elseif type == RewardType.GOLD then
      if message.total ~= nil then
        LuaEntry.Player.gold = message.total
        eventId = EventId.UpdateGold
      end
    elseif type == RewardType.DETECT_EVENT then
      if message.value ~= nil then
        DataCenter.RadarCenterDataManager:UpdateEventNum(message.value)
      end
    elseif type == RewardType.HONOR then
      if message.value ~= nil and message.value.accPoint ~= nil then
        DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.value.accPoint)
      end
    elseif type == RewardType.FORMATION_STAMINA then
    elseif type == RewardType.MuseumArtifact then
    elseif type == RewardType.WOOD then
      if message.total ~= nil then
        LuaEntry.Resource.wood = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.PVE_STAMINA then
      if message.total ~= nil then
        LuaEntry.Player.pveStamina = message.total
        eventId = EventId.PveStaminaUpdate
      end
    elseif type == RewardType.CommonEquip then
      if message.value and message.value.changes then
        DataCenter.CommonEquipDataManager:UpdateEquipInfos(message.value.changes)
      end
    elseif type == RewardType.DragonWorldPoint then
      if message.total ~= nil then
        LuaEntry.Resource.honorScore = message.total
        eventId = EventId.ResourceUpdated
      end
    elseif type == RewardType.DecorateBuild then
      if message.value ~= nil and message.value.buildingUuid ~= nil then
        eventId = EventId.DecorateRedPoint
      end
    elseif type == RewardType.PETROLEUM and message.total ~= nil then
      LuaEntry.Resource.petroleum = message.total
      eventId = EventId.ResourceUpdated
    end
  end
  return eventId
end

local function AddRewards(self, rewardList)
  if rewardList then
    local _eventIds = {}
    local _eventId
    for _, v in pairs(rewardList) do
      _eventId = AddOneReward(v)
      if _eventId ~= nil then
        _eventIds[_eventId] = true
      end
    end
    for k, _ in pairs(_eventIds) do
      EventManager:GetInstance():Broadcast(k)
    end
  end
end

local function AddRewardsAndRes(self, message)
  local _eventIds = {}
  local _eventId
  if message and message.resource ~= nil then
    _eventIds[EventId.ResourceUpdated] = true
    LuaEntry.Resource:UpdateResource(message.resource, false)
  end
  if message and message.reward then
    for _, v in pairs(message.reward) do
      _eventId = AddOneReward(v)
      if _eventId ~= nil then
        _eventIds[_eventId] = true
      end
    end
  end
  for k, _ in pairs(_eventIds) do
    EventManager:GetInstance():Broadcast(k)
  end
end

local function ShowGiftReward(self, message, title, callback, tips)
  local list = {}
  local param = {}
  param.title = title or Localization:GetString("320320")
  param.tips = tips or ""
  if table.count(message.reward) > 0 then
    local origin = message.reward
    local newlist = {}
    for i = table.count(origin), 1, -1 do
      newlist[#newlist + 1] = origin[i]
    end
    list = self:ReturnRewardParamForMessage(newlist)
  end
  if message.gold ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.GOLD
    tempParam.itemId = ""
    tempParam.count = tonumber(message.goldAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.goldBrickAdd ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.GOODS
    tempParam.itemId = GoldBrickConst.ItemId
    tempParam.count = tonumber(message.goldBrickAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.getMoney ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.GOODS
    tempParam.itemId = RecruitItemId
    tempParam.count = tonumber(message.getMoney)
    if tempParam.count > 0 then
      table.insert(list, tempParam)
    end
  end
  if message.creditExp ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.Credit
    tempParam.itemId = RewardType.Credit
    tempParam.count = tonumber(message.creditExp)
    table.insert(list, tempParam)
  end
  if message.getEnergy ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.FORMATION_STAMINA
    tempParam.itemId = ""
    tempParam.count = tonumber(message.getEnergy)
    if tempParam.count > 0 then
      table.insert(list, tempParam)
    end
  end
  if message.goods ~= nil then
    local goods = message.goods
    local listItem = {}
    for i = 1, #goods do
      if listItem[goods[i].itemId] then
        listItem[goods[i].itemId] = listItem[goods[i].itemId] + goods[i].rewardAdd
      else
        listItem[goods[i].itemId] = goods[i].rewardAdd
      end
    end
    for k, v in pairs(listItem) do
      local tempParam = {}
      tempParam.rewardType = RewardType.GOODS
      tempParam.itemId = k
      tempParam.count = v
      table.insert(list, tempParam)
    end
    param.title = Localization:GetString("128027")
  end
  if message.stone ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.METAL
    tempParam.itemId = ""
    tempParam.count = tonumber(message.stoneAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.water ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.WATER
    tempParam.itemId = ""
    tempParam.count = tonumber(message.waterAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.money ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.FOOD
    tempParam.itemId = ""
    tempParam.count = tonumber(message.moneyAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.electricity ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.ELECTRICITY
    tempParam.itemId = ""
    tempParam.count = tonumber(message.electricityAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.pvePoint ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.PVE_POINT
    tempParam.itemId = ""
    tempParam.count = tonumber(message.pvePointAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.detectEvent ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.DETECT_EVENT
    tempParam.itemId = ""
    tempParam.count = tonumber(message.detectEventAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.formationStamina ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.FORMATION_STAMINA
    tempParam.itemId = ""
    tempParam.count = tonumber(message.formationStaminaAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.woodAdd ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.WOOD
    tempParam.itemId = ""
    tempParam.count = tonumber(message.woodAdd)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.pve_stamina ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.PVE_STAMINA
    tempParam.itemId = ""
    tempParam.count = tonumber(message.pve_stamina)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.people ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.PEOPLE
    tempParam.itemId = ""
    tempParam.count = tonumber(message.people)
    if tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.dragonHonorScore ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.DragonWorldPoint
    tempParam.itemId = ""
    tempParam.count = tonumber(message.dragonHonorScoreAdd)
    if tempParam.count ~= nil and tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.flint ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.FLINT
    tempParam.itemId = ""
    tempParam.count = tonumber(message.flintAdd)
    if tempParam.count ~= nil and tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.obsidian ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.OBSIDIAN
    tempParam.itemId = ""
    tempParam.count = tonumber(message.obsidianAdd)
    if tempParam.count ~= nil and tempParam.count ~= 0 then
      table.insert(list, tempParam)
    end
  end
  if message.resourceItem ~= nil then
    local resourceItem = message.resourceItem
    local listItem = {}
    for i = 1, #resourceItem do
      if listItem[resourceItem[i].itemId] then
        listItem[resourceItem[i].itemId] = listItem[resourceItem[i].itemId] + resourceItem[i].add
      else
        listItem[resourceItem[i].itemId] = resourceItem[i].add
      end
    end
    for k, v in pairs(listItem) do
      local tempParam = {}
      tempParam.rewardType = RewardType.RESOURCE_ITEM
      tempParam.itemId = k
      tempParam.count = v
      table.insert(list, tempParam)
    end
  end
  if message.equipment ~= nil then
    local obj = message.equipment[1]
    if obj.changes then
      for i, v in ipairs(obj.changes) do
        if v then
          local tempParam = {}
          tempParam.rewardType = RewardType.CommonEquip
          tempParam.itemId = v.cfgId
          tempParam.count = v.changeNum
          table.insert(list, tempParam)
        end
      end
    end
  end
  if message.battleCard then
    local battleCard = message.battleCard
    local cards = {}
    for i = 1, #battleCard do
      local tempParam = {}
      tempParam.rewardType = RewardType.TACTICAL_CARD
      tempParam.itemId = battleCard[i].itemId
      tempParam.count = battleCard[i].add or 1
      table.insert(cards, tempParam)
    end
    table.sort(cards, function(a, b)
      if a.itemId ~= b.itemId then
        return a.itemId < b.itemId
      end
      return false
    end)
    for i = 1, #cards do
      table.insert(list, cards[i])
    end
    cards = nil
  end
  list = table.reverse(list)
  local heroList = {}
  for i = #list, 1, -1 do
    if list[i].rewardType == RewardType.HERO then
      table.insert(heroList, list[i])
      table.remove(list, i)
    end
  end
  for i = 1, #heroList do
    table.insert(list, 1, heroList[i])
  end
  if table.count(list) == 0 then
    return
  end
  param.rewardList = list
  self:SetParam(param)
  if DataCenter.GuideManager:IsCanShowReward() then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetPayReward, false)
    
    local function openWindow()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, param, callback)
    end
    
    for i, v in pairs(heroList) do
      if v.heroUuid and DataCenter.HeroDataManager:NeedShowNewHeroWindow(v.heroUuid) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, v.heroUuid, {
          v.heroUuid
        }, openWindow, true)
        return
      end
    end
    openWindow()
  else
    DataCenter.GuideManager:SetGuideEndCallBack(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetPayReward, false)
      
      local function openWindow()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, param, callback)
      end
      
      for i, v in pairs(heroList) do
        if v.heroUuid and DataCenter.HeroDataManager:NeedShowNewHeroWindow(v.heroUuid) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, v.heroUuid, {
            v.heroUuid
          }, openWindow, true)
          return
        end
      end
      openWindow()
    end)
  end
end

local function ShowCommonReward(self, message, title, isChange, heroExp, isArmyFly, isActGiftBox, CloseFunc, tips, clickTip, isOnlyReward, onlyText, withoutSort)
  if message.reward ~= nil then
    local list = {}
    list = self:ReturnRewardParamForMessage(message.reward) or {}
    if not withoutSort then
      table.sort(list, function(a, b)
        if a.rewardType ~= b.rewardType then
          return a.rewardType == RewardType.HERO and true or false
        else
          return a.sortOrder < b.sortOrder
        end
      end)
    end
    if isActGiftBox then
      local actGiftBox = self:GetActGiftBox(message)
      for i, v in ipairs(actGiftBox) do
        table.insert(list, v)
      end
    end
    local golloesList = self:GetGolloesRewards(message)
    for i, v in ipairs(golloesList) do
      table.insert(list, v)
    end
    local param = {}
    param.rewardList = list
    param.heroExp = heroExp
    param.title = title or Localization:GetString("128027")
    if tips then
      param.tips = tips
    end
    if clickTip then
      param.clickTip = clickTip
    end
    if isChange and message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic.bId == BuildingTypes.FUN_BUILD_TRADING_CENTER or dic.bId == BuildingTypes.FUN_BUILD_HERO_MONUMENT or dic.bId == BuildingTypes.FUN_BUILD_BARRACKS then
        param.isUpChange = list[1].rewardType
      end
    end
    if message.ownerInfo and (message.fromDispatchStealMessage or message.fromDispatchAssistMessage) then
      param.fromDispatchStealMessage = message.fromDispatchStealMessage
      param.fromDispatchAssistMessage = message.fromDispatchAssistMessage
      param.ownerInfo = message.ownerInfo
    end
    if message.completeByHelper then
      param.completeByHelper = message.completeByHelper
    end
    param.isArmyFly = isArmyFly
    param.CloseFunc = CloseFunc
    param.isOnlyReward = isOnlyReward
    if message.isBigReward then
      param.detectEventIsBigReward = message.isBigReward == 1
      if param.detectEventIsBigReward then
        local multiple = message.bigRewardMultiple
        if multiple then
          param.title = Localization:GetString("activity_s1_qingdian_521003_radar_title_2", multiple)
          param.detectEventBigRewardMultiple = multiple
        else
          param.title = Localization:GetString("radar_title_2")
        end
      end
    end
    if message.treasureChestReward then
      param.treasureChestReward = true
    end
    self:SetParam(param)
    if DataCenter.GuideManager:IsCanShowReward() then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
      
      local function openRewardWindow()
        if isOnlyReward then
          param.onlyText = onlyText
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageOnlyRewardGet, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, param)
        elseif heroExp ~= nil then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetRewardView, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, param)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, param)
        end
      end
      
      if not table.IsNullOrEmpty(list) then
        for i, v in pairs(list) do
          if v and v.rewardType == RewardType.HERO and v.heroUuid and DataCenter.HeroDataManager:NeedShowNewHeroWindow(v.heroUuid) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, v.heroUuid, {
              v.heroUuid
            }, function()
              openRewardWindow()
              DataCenter.LWSoundManager:PlaySound(61010, false)
            end, true)
            return
          end
        end
      end
      openRewardWindow()
    else
      DataCenter.GuideManager:SetGuideEndCallBack(function()
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
        
        local function openRewardWindow()
          if isOnlyReward then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageOnlyRewardGet, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, param)
          elseif heroExp ~= nil then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetRewardView, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, param)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, param)
          end
        end
        
        if not table.IsNullOrEmpty(list) then
          for i, v in pairs(list) do
            if v and v.rewardType == RewardType.HERO and v.heroUuid and DataCenter.HeroDataManager:NeedShowNewHeroWindow(v.heroUuid) then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, v.heroUuid, {
                v.heroUuid
              }, openRewardWindow, true)
              return
            end
          end
        end
        openRewardWindow()
      end)
    end
  end
end

local function ShowGiftBoxOpenReward(self, message, title)
  if message.reward ~= nil then
    local list = {}
    list = self:ReturnRewardParamForMessage(message.reward) or {}
    table.sort(list, function(a, b)
      if a.rewardType ~= b.rewardType then
        return a.rewardType == RewardType.HERO and true or false
      else
        return a.sortOrder < b.sortOrder
      end
    end)
    local param = {}
    param.rewardList = list
    param.title = title or Localization:GetString("128027")
    param.crit = message.crit
    if message.ownerInfo and (message.fromDispatchStealMessage or message.fromDispatchAssistMessage) then
      param.fromDispatchStealMessage = message.fromDispatchStealMessage
      param.fromDispatchAssistMessage = message.fromDispatchAssistMessage
      param.ownerInfo = message.ownerInfo
    end
    if message.completeByHelper then
      param.completeByHelper = message.completeByHelper
    end
    self:SetParam(param)
    if DataCenter.GuideManager:IsCanShowReward() then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
      do
        local function openRewardWindow()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftBoxOpenRewardGet, {
            anim = true,
            
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, param)
        end
        
        openRewardWindow()
      end
    end
  end
end

local function ShowTwoLinesRewards(self, msgReward_0, msgReward_1, title, midNotice)
  local list_0 = self:ReturnRewardParamForMessage(msgReward_0) or {}
  local list_1 = self:ReturnRewardParamForMessage(msgReward_1) or {}
  
  local function sortFunc(a, b)
    if a.rewardType ~= b.rewardType then
      return a.rewardType == RewardType.HERO and true or false
    else
      return a.sortOrder < b.sortOrder
    end
  end
  
  table.sort(list_0, sortFunc)
  table.sort(list_1, sortFunc)
  local param = {}
  param.rewardList_0 = list_0
  param.rewardList_1 = list_1
  param.title = title
  param.middle = midNotice
  if DataCenter.GuideManager:IsCanShowReward() then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    
    local function openRewardWindow()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIExplorationRewardGet, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, param)
    end
    
    openRewardWindow()
  end
end

local function ShowCookingReward(self, message, title)
  if message.base_reward ~= nil then
    local list = {}
    list = self:ReturnRewardParamForMessage(message.base_reward) or {}
    local isHaveExtra = false
    if message.extra1_reward then
      isHaveExtra = true
      local extra1 = self:ReturnRewardParamForMessage(message.extra1_reward) or {}
      table.insertto(list, extra1)
    end
    if message.extra2_reward then
      isHaveExtra = true
      local extra2 = self:ReturnRewardParamForMessage(message.extra2_reward) or {}
      table.insertto(list, extra2)
    end
    local param = {}
    param.rewardList = list
    param.title = title or Localization:GetString("128027")
    self:SetParam(param)
    if DataCenter.GuideManager:IsCanShowReward() then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
      do
        local function openRewardWindow()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UICookingRewardGet, {
            anim = true,
            
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, param)
        end
        
        openRewardWindow()
      end
    end
  end
end

local function ShowCommonHeroReward(self, message)
  local list = {}
  list.rewardType = RewardType.HERO
  list.sortOrder = 0
  list.itemId = message.heroId
  list.count = message.heroCount
  list.heroUuid = message.uuid
  list.isHeroBox = true
  local param = {}
  param.rewardList = {}
  table.insert(param.rewardList, list)
  param.title = Localization:GetString("128027")
  self:SetParam(param)
  if DataCenter.GuideManager:IsCanShowReward() then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    })
  else
    DataCenter.GuideManager:SetGuideEndCallBack(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      })
    end)
  end
end

local function ReturnRewardParamForMessage(self, list)
  local params = {}
  local Player = LuaEntry.Player
  local sortOrder = 0
  if list == nil then
    return nil
  end
  local itemIdDic = {}
  for k, v in pairs(list) do
    local type = v.type
    if type == RewardType.ITEM_EFFECT then
      type = RewardType.GOODS
    end
    local param = {}
    if v.singleShowDesc then
      param.singleShowDesc = v.singleShowDesc
    end
    if v.singleShowDescParam then
      param.singleShowDescParam = v.singleShowDescParam
    end
    param.rewardType = type
    param.sortOrder = sortOrder
    sortOrder = sortOrder + 1
    if v.trainRewardState then
      param.trainRewardState = v.trainRewardState
    end
    if type == RewardType.GOODS or type == RewardType.ITEM_EFFECT then
      local dic = v.value
      if dic ~= nil then
        if dic.id ~= nil then
          param.itemId = dic.id
        elseif dic.itemId ~= nil then
          param.itemId = dic.itemId
        end
        local good = DataCenter.ItemData:GetItemById(param.itemId)
        local num = 0
        if good ~= nil then
          num = good.count
        end
        local sm_addNum = 0
        if dic.rewardAdd then
          sm_addNum = dic.rewardAdd
        elseif dic.count ~= nil then
          sm_addNum = dic.count - num
        elseif dic.num ~= nil then
          sm_addNum = dic.num
        end
        if sm_addNum <= 0 and good ~= nil then
          sm_addNum = good.sm_addCount
        end
        param.count = sm_addNum
      end
    elseif type == RewardType.GOLD then
      if v.value then
        param.count = v.value
      end
      param.itemId = ""
    elseif type == RewardType.EXP then
      local sm_addNum = v.value
      if sm_addNum <= 0 and v.total ~= nil then
        sm_addNum = v.total - Player.exp
      end
      param.count = sm_addNum
    elseif type == RewardType.POWER then
      local sm_addNum = v.value
      if sm_addNum <= 0 and v.total ~= nil then
        sm_addNum = v.total - Player.questPower
      end
      param.count = sm_addNum
    elseif type == RewardType.OIL or type == RewardType.WATER or type == RewardType.FOOD or type == RewardType.METAL or type == RewardType.ELECTRICITY or type == RewardType.PVE_POINT or type == RewardType.DETECT_EVENT or type == RewardType.FORMATION_STAMINA or type == RewardType.FLINT or type == RewardType.OBSIDIAN or type == RewardType.WOOD or type == RewardType.PVE_STAMINA or type == RewardType.PEOPLE then
      param.count = v.value
    elseif type == RewardType.ARM then
      local dic = v.value
      if dic ~= nil then
        param.itemId = dic.itemId or dic.id
        param.count = dic.count or dic.num
      end
    elseif type == RewardType.MuseumArtifact then
      local dic = v.value
      if dic ~= nil then
        param.itemId = dic.itemId or dic.id
        param.itemId = tonumber(param.itemId)
        param.count = dic.count or dic.num
      end
    elseif type == RewardType.EQUIP then
      local dic = v.value
      if dic ~= nil then
        if dic.itemId ~= nil then
          param.itemId = dic.itemId
        elseif dic.id ~= nil then
          param.itemId = dic.id
        end
        param.count = dic.add
      end
    elseif type == RewardType.PTGOLD then
      local sm_addNum = v.value
      if sm_addNum <= 0 and v.total ~= nil then
        sm_addNum = v.total - Player.ptGold
      end
      param.count = sm_addNum
    elseif type == RewardType.HERO then
      local dic = v.value
      if dic ~= nil then
        param.itemId = dic.heroId or dic.id
        param.count = dic.rewardAdd or dic.num
        param.heroUuid = dic.uuid or dic.heroUuid
      end
    elseif type == RewardType.HONOR or type == RewardType.ALLIANCE_POINT then
      param.count = v.value
    elseif type == RewardType.RESOURCE_ITEM then
      local dic = v.value
      if dic ~= nil then
        param.itemId = dic.id or dic.itemId
        param.count = dic.num or dic.add or dic.count
      end
    elseif type == RewardType.RESOURCE then
      local dic = v.value
      if dic ~= nil then
        param.itemId = dic.id or dic.itemId
        param.count = dic.num or dic.add
      end
    elseif type == RewardType.WORKER then
      local dic = v.value
      if dic ~= nil then
        if dic.workerId then
          param.itemId = dic.workerId
        elseif dic.workerUid then
          local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(dic.workerUid)
          if workerData then
            param.itemId = workerData.cfgId
          end
        end
        if dic.workerUid then
          param.workerUid = dic.workerUid
        end
      end
    elseif type == RewardType.VISITOR then
      local dic = v.value
      if dic ~= nil then
        param.itemId = dic.id or dic.itemId
        param.count = dic
      end
    elseif type == RewardType.CommonEquip then
      local dic = v.value
      if dic ~= nil and dic.changes ~= nil then
        local equip = dic.changes[1]
        if equip ~= nil then
          param.itemId = equip.cfgId
          param.count = equip.changeNum
        end
      end
    elseif type == RewardType.DecorateBuild then
      param.itemId = v.value.itemId
      param.count = v.value.add
      param.bUuid = v.value.buildingUuid
      param.itemId = v.value.itemId
      if itemIdDic[param.itemId] then
        itemIdDic[param.itemId].count = itemIdDic[param.itemId].count + param.count
        param.count = 0
      else
        itemIdDic[param.itemId] = {}
        itemIdDic[param.itemId].count = param.count
      end
    elseif type == RewardType.TWSkillChip then
      if v.value and not table.IsNullOrEmpty(v.value.updates) then
        local updateInfo = v.value.updates[1]
        param.itemId = updateInfo.cfgId
        param.count = updateInfo.num
        param.uuid = updateInfo.uuid
      end
    elseif type == RewardType.TACTICAL_CARD then
      local dic = v.value
      if dic ~= nil then
        param.itemId = dic.itemId
        param.count = dic.add or 1
      end
    else
      local dic = v.value
      if dic ~= nil then
        param.count = dic
      end
    end
    if param.count ~= 0 then
      table.insert(params, param)
      if type == RewardType.DecorateBuild and itemIdDic and itemIdDic[param.itemId] then
        itemIdDic[param.itemId].key = #params
      end
    end
  end
  for i, v in pairs(itemIdDic) do
    if 0 < v.count and params[v.key] then
      params[v.key].count = v.count
    end
  end
  if 0 < #params then
    return params
  end
  return nil
end

local function GetGolloesRewards(self, message)
  local retList = {}
  if message.freeSpeedNumAdd and message.freeSpeedNumAdd > 0 then
    local oneData = {}
    oneData.sortOrder = 0
    oneData.rewardType = RewardType.Golloes
    oneData.itemId = GolloesType.Worker
    oneData.count = message.freeSpeedNumAdd
    table.insert(retList, oneData)
  end
  if message.spyNumAdd and 0 < message.spyNumAdd then
    local oneData = {}
    oneData.sortOrder = 0
    oneData.rewardType = RewardType.Golloes
    oneData.itemId = GolloesType.Explorer
    oneData.count = message.spyNumAdd
    table.insert(retList, oneData)
  end
  if message.caravanNumAdd and 0 < message.caravanNumAdd then
    local oneData = {}
    oneData.sortOrder = 0
    oneData.rewardType = RewardType.Golloes
    oneData.itemId = GolloesType.Trader
    oneData.count = message.caravanNumAdd
    table.insert(retList, oneData)
  end
  if message.statusNumAdd and 0 < message.statusNumAdd then
    local oneData = {}
    oneData.sortOrder = 0
    oneData.rewardType = RewardType.Golloes
    oneData.itemId = GolloesType.Warrior
    oneData.count = message.statusNumAdd
    table.insert(retList, oneData)
  end
  return retList
end

local function ReturnRewardParamForView(self, list)
  if not list then
    return nil
  end
  local params = {}
  for k, v in pairs(list) do
    local type = v.type
    if type ~= RewardType.ITEM_EFFECT then
      local param = {}
      param.rewardType = type
      if type == RewardType.GOODS then
        local dic = v.value
        if dic ~= nil then
          if dic.id ~= nil then
            param.itemId = dic.id
          elseif dic.itemId ~= nil then
            param.itemId = dic.itemId
          end
          local sm_addNum = 0
          if dic.num ~= nil then
            sm_addNum = dic.num
          elseif dic.rewardAdd ~= nil then
            sm_addNum = dic.rewardAdd
          end
          param.count = sm_addNum
        end
      elseif type == ResourceType.Gold then
        param.itemId = ""
        param.count = LuaEntry.Player.sm_addGoldCount
      elseif type == RewardType.EXP then
        local sm_addNum = v.value
        param.count = sm_addNum
      elseif type == RewardType.POWER then
        local sm_addNum = v.value
        param.count = sm_addNum
      elseif type == RewardType.OIL or type == RewardType.WATER or type == RewardType.FOOD or type == RewardType.METAL or type == RewardType.ELECTRICITY or type == RewardType.PVE_POINT or type == RewardType.DETECT_EVENT or type == RewardType.FORMATION_STAMINA or type == RewardType.FLINT or type == RewardType.OBSIDIAN or type == RewardType.WOOD or type == RewardType.PVE_STAMINA or type == RewardType.PEOPLE then
        param.count = v.value
      elseif type == RewardType.ARM then
        local dic = v.value
        if dic ~= nil then
          param.itemId = dic.itemId or dic.id
          param.count = dic.count or dic.num
        end
      elseif type == RewardType.MuseumArtifact then
        local dic = v.value
        if dic ~= nil then
          param.itemId = dic.itemId or dic.id
          param.count = dic.count or dic.num
        end
      elseif type == RewardType.EQUIP then
        local dic = v.value
        if dic ~= nil then
          if dic.equipId ~= nil then
            param.itemId = dic.equipId
          elseif dic.id ~= nil then
            param.itemId = dic.id
          end
          param.count = dic.num
        end
      elseif type == RewardType.PTGOLD then
        local sm_addNum = v.value
        param.count = sm_addNum
      elseif type == RewardType.HERO then
        local dic = v.value
        if dic ~= nil then
          param.itemId = dic.id or dic.heroId
          param.count = dic.num or dic.rewardAdd
        end
      elseif type == RewardType.HONOR or type == RewardType.ALLIANCE_POINT then
        param.count = v.value
      elseif type == RewardType.RESOURCE_ITEM then
        local dic = v.value
        if dic ~= nil then
          param.itemId = dic.id or dic.itemId
          param.count = dic.num or dic.add
        end
      elseif type == RewardType.WORKER then
        local dic = v.value
        if dic ~= nil then
          param.itemId = dic.id
        end
      elseif type == RewardType.VISITOR then
        local dic = v.value
        if dic ~= nil then
          param.itemId = dic.id
          param.count = dic
        end
      elseif type == RewardType.CommonEquip then
        local dic = v.value
        if dic ~= nil and dic.changes ~= nil then
          local equip = dic.changes[1]
          if equip ~= nil then
            param.itemId = equip.cfgId
            param.count = equip.changeNum
          end
        end
      elseif type == RewardType.TWSkillChip then
        if v.value and not table.IsNullOrEmpty(v.value.updates) then
          local updateInfo = v.value.updates[1]
          param.itemId = updateInfo.cfgId
          param.count = updateInfo.num
          param.uuid = updateInfo.uuid
        end
      elseif type == RewardType.TACTICAL_CARD then
        local dic = v.value
        if dic ~= nil then
          param.itemId = dic.itemId
          param.count = dic.add or 1
        end
      elseif type == RewardType.DecorateBuild then
        local dic = v.value
        if dic ~= nil then
          if dic.id ~= nil then
            param.itemId = dic.id
          elseif dic.itemId ~= nil then
            param.itemId = dic.itemId
          end
          param.count = dic.add
        end
      else
        local dic = v.value
        if dic ~= nil then
          param.count = dic
        end
      end
      table.insert(params, param)
    end
  end
  if 0 < #params then
    return params
  end
  return nil
end

local function GetPicByType(self, rewardType, id, seasonType, big)
  if RewardToResType[rewardType] ~= nil then
    return DataCenter.ResourceManager:GetResourceIconByType(RewardToResType[rewardType], big, seasonType)
  elseif rewardType == RewardType.POWER then
    return "icon_combat"
  elseif rewardType == RewardType.EXP then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_exp.png"
  elseif rewardType == RewardType.HERO_EXP then
    return "Assets/Main/Sprites/ItemIcons/cfm_zhujiemian_qipao_shu.png"
  elseif rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    if goods ~= nil then
      return string.format(LoadPath.ItemPath, goods.icon)
    end
  elseif rewardType == RewardType.Resistance_Point then
    return ResourceTypeIconName[ResourceType.ResistancePoint]
  elseif rewardType == RewardType.AllianceBattleReward then
    return ResourceTypeIconName[ResourceType.AllianceBattleReward]
  elseif rewardType == RewardType.HONOR then
    return ResourceTypeIconName[ResourceType.AlliancePoint]
  elseif rewardType == RewardType.ALLIANCE_POINT then
    return ResourceTypeIconName[ResourceType.AlliancePoint]
  elseif rewardType == RewardType.BATTLE_HONOR then
    return "Commond7_icon_3"
  elseif rewardType == RewardType.ARM then
    local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
    if army ~= nil then
      return string.format(LoadPath.SoldierIcons, army.icon)
    end
  elseif rewardType == RewardType.PTGOLD then
    return "FB_IC_jinbixiao"
  elseif rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
    if template ~= nil then
      return template:GetIconPath()
    end
  elseif rewardType == RewardType.PVE_ACT_SCORE then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_act_point.png"
  elseif rewardType == RewardType.WORKER then
    if id then
      local appearanceId = GetTableData(TableName.LW_Worker, id, "appearance")
      if appearanceId then
        local appearCfg = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
        if appearCfg then
          local icon = appearCfg.queue_icon_path
          return UIUtil.GetFullPath(LoadPath.HeroIconsSmallPath, icon)
        end
      end
    end
    return "Assets/Main/Sprites/ItemIcons/Common_icon_worker.png"
  elseif rewardType == RewardType.EQUIP then
    local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(tonumber(id))
    if equipTemplate ~= nil then
      return string.format(LoadPath.ItemPath, equipTemplate.icon)
    end
  elseif rewardType == RewardType.HERO then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(id)
    if heroTemplate ~= nil then
      return HeroUtils.GetHeroIconPath(heroTemplate.appearance)
    end
  elseif rewardType == RewardType.BATTLE_PASS then
    return "Assets/Main/Sprites/ItemIcons/zyf_battlepass_icon2"
  elseif rewardType == RewardType.ALLIANCE_GIFT then
    return string.format(LoadPath.UIAllianceGift, GetTableData(TableName.AllianceGiftGroup, id, "icon"))
  elseif rewardType == RewardType.DailyTaskPoint then
    return "Assets/Main/Sprites/ItemIcons/renwujifenhuizhang.png"
  elseif rewardType == RewardType.EquipStrengtheningStone then
    return "Assets/Main/Sprites/ItemIcons/cfm_zhujiemian_qipao_qianghuashi.png"
  elseif rewardType == RewardType.ScrewSpike then
    return "Assets/Main/Sprites/ItemIcons/cfm_zhujiemian_qipao_luosiding.png"
  elseif rewardType == RewardType.FourthFormation then
    return "Assets/Main/Sprites/ItemIcons/icon_cheku.png"
  elseif rewardType == RewardType.MonthCardBuff then
    return "Assets/Main/Sprites/ItemIcons/icon_caijijiasu.png"
  elseif rewardType == RewardType.MarchDefReductionBuff then
    return "Assets/Main/Sprites/ItemIcons/icon_shanghaijianmian.png"
  elseif rewardType == RewardType.VISITOR then
    if id then
      local line = LocalController:instance():getLine(TableName.City_Visitor, tonumber(id))
      if line then
        local appearanceId = line.model_path or ""
        if not string.IsNullOrEmpty(appearanceId) then
          local appearCfg = DataCenter.AppearanceTemplateManager:GetTemplate(tonumber(appearanceId))
          if appearCfg then
            local icon = appearCfg.half_icon_path
            return UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, icon)
          end
        end
      end
    end
    return "Assets/Main/Sprites/ItemIcons/Common_icon_worker.png"
  elseif rewardType == RewardType.CommonEquip then
    local equipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(id)
    if equipTemplate ~= nil then
      return string.format(LoadPath.ItemPath, equipTemplate.icon)
    end
  elseif rewardType == RewardType.Credit then
    return string.format(LoadPath.ItemPath, "sj_tuikuan_xinyonjifen_icon")
  elseif rewardType == RewardType.TWSkillChip then
    local template = DataCenter.TWSkillChipTemplateManager:GetTemplate(id)
    if template ~= nil then
      return string.format(LoadPath.ItemPath, template.icon)
    end
  elseif rewardType == RewardType.TACTICAL_CARD then
    local template = DataCenter.TacticalCardDataManager:GetTemplateData(id)
    if template ~= nil then
      return template.icon
    end
  elseif rewardType == RewardType.EMOTION_SELECT then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
    if template ~= nil and template.gainMethod ~= nil and _G.type(template.gainMethod) == "table" and #template.gainMethod > 0 then
      local method = template.gainMethod[1]
      if method ~= nil and method.id ~= nil then
        local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(method.id)
        if goodsTemplate then
          return string.format(LoadPath.ItemPath, goodsTemplate.icon)
        end
      end
    end
  elseif rewardType == RewardType.CHAT_EMOTION then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    if goods ~= nil then
      return string.format(LoadPath.ItemPath, goods.icon)
    end
  elseif rewardType == RewardType.ArmsMedal then
    return "Assets/Main/Sprites/ItemIcons/icon_junbeijiangzhang.png"
  elseif rewardType == RewardType.TacticalWeaponPart then
    return "Assets/Main/Sprites/ItemIcons/icon_feijilingjian.png"
  end
  return ""
end

local function GetNameByType(self, rewardType, id, type)
  if RewardToResType[rewardType] ~= nil then
    return DataCenter.ResourceManager:GetResourceNameByType(RewardToResType[rewardType])
  elseif rewardType == RewardType.POWER then
    return Localization:GetString("100181")
  elseif rewardType == RewardType.EXP then
    return Localization:GetString("100001")
  elseif rewardType == RewardType.HERO_EXP then
    return Localization:GetString("100180")
  elseif rewardType == RewardType.GOODS then
    return DataCenter.ItemTemplateManager:GetName(id)
  elseif rewardType == RewardType.HONOR then
    return Localization:GetString("390261")
  elseif rewardType == RewardType.ALLIANCE_POINT then
    return Localization:GetString("390266")
  elseif rewardType == RewardType.BATTLE_HONOR then
    return Localization:GetString("360180")
  elseif rewardType == RewardType.PTGOLD then
    return ""
  elseif rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
    if template ~= nil then
      return Localization:GetString(template.name)
    end
  elseif rewardType == RewardType.RESOURCE then
    return DataCenter.ResourceManager:GetResourceNameByType(id)
  elseif rewardType == RewardType.PVE_ACT_SCORE then
    return Localization:GetString("180003")
  elseif rewardType == RewardType.SAPPHIRE then
    return Localization:GetString("390967")
  elseif rewardType == RewardType.EQUIP then
    local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(tonumber(id))
    if equipTemplate ~= nil then
      return Localization:GetString(equipTemplate.name)
    end
  elseif rewardType == RewardType.HERO then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(id)
    if heroTemplate ~= nil then
      return Localization:GetString(heroTemplate.name)
    end
  elseif rewardType == RewardType.BATTLE_PASS then
    return Localization:GetString("2000077")
  elseif rewardType == RewardType.ALLIANCE_GIFT then
    return Localization:GetString(GetTableData(TableName.AllianceGiftGroup, id, "name"))
  elseif rewardType == RewardType.WORKER then
    if id then
      local line = LocalController:instance():getLine(TableName.LW_Worker, tonumber(id))
      if line then
        return Localization:GetString(line.first_name) .. " " .. Localization:GetString(line.last_name)
      end
    end
  elseif rewardType == RewardType.DailyTaskPoint then
    return Localization:GetString(180374)
  elseif rewardType == RewardType.FourthFormation then
    return Localization:GetString(2000159)
  elseif rewardType == RewardType.MonthCardBuff then
    return Localization:GetString(2000164)
  elseif rewardType == RewardType.MarchDefReductionBuff then
    return Localization:GetString(2000663)
  elseif rewardType == RewardType.VISITOR then
    if id then
      local line = LocalController:instance():getLine(TableName.City_Visitor, tonumber(id))
      if line then
        local name = line.name
        if not string.IsNullOrEmpty(name) then
          return Localization:GetString(name)
        end
      end
    end
  elseif rewardType == RewardType.ActGiftBox then
    local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(id)
    return Localization:GetString(template.reward_name)
  elseif rewardType == RewardType.Credit then
    return Localization:GetString("credit_prop_name")
  elseif rewardType == RewardType.TWSkillChip then
    local template = DataCenter.TWSkillChipTemplateManager:GetTemplate(id)
    if template ~= nil then
      return Localization:GetString(template.name)
    end
  elseif rewardType == RewardType.TACTICAL_CARD then
    local template = DataCenter.TacticalCardDataManager:GetTemplateData(id)
    if template ~= nil then
      return Localization:GetString(template.name)
    end
  elseif rewardType == RewardType.DecorateBuild then
    local buildTemp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(id)
    if buildTemp ~= nil then
      return Localization:GetString(buildTemp.name)
    end
  elseif rewardType == RewardType.EMOTION_SELECT then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
    if template ~= nil and template.gainMethod ~= nil and _G.type(template.gainMethod) == "table" and #template.gainMethod > 0 then
      local method = template.gainMethod[1]
      if method ~= nil and method.id ~= nil then
        return DataCenter.ItemTemplateManager:GetName(method.id)
      end
    end
  elseif rewardType == RewardType.CHAT_EMOTION then
    return DataCenter.ItemTemplateManager:GetName(id)
  end
  return ""
end

local function GetDescByType(self, rewardType, id)
  if rewardType == RewardType.GOODS then
    return DataCenter.ItemTemplateManager:GetDes(id)
  elseif rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
    if template ~= nil then
      return Localization:GetString(template.desc)
    end
  elseif RewardToResType[rewardType] ~= nil then
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(RewardToResType[rewardType])
    if template then
      return Localization:GetString(template.description)
    end
  elseif rewardType == RewardType.EXP then
    return Localization:GetString("100523")
  elseif rewardType == RewardType.HERO_EXP then
    return Localization:GetString("100180")
  elseif rewardType == RewardType.EQUIP then
    local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(tonumber(id))
    if equipTemplate ~= nil then
      return Localization:GetString(equipTemplate.desc)
    end
  elseif rewardType == RewardType.BATTLE_PASS then
    return Localization:GetString("2000078")
  elseif rewardType == RewardType.ALLIANCE_GIFT then
    return Localization:GetString(GetTableData(TableName.AllianceGiftGroup, id, "desc"))
  elseif rewardType == RewardType.WORKER then
    local workerDesc = Localization:GetString("HTS100008")
    if id then
      local template = DataCenter.WorkerTemplateManager:GetTemplateById(tonumber(id))
      if template then
        local buildList = template.workingBuildList
        local effects = template.effects
        local peculiarity = effects[1]
        local peculiarityVlue = effects[2]
        local workPlaceStr = ""
        if buildList ~= nil then
          for __, v in pairs(buildList) do
            local buildTempalte = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v)
            if buildTempalte ~= nil then
              workPlaceStr = workPlaceStr .. Localization:GetString(buildTempalte.name) .. " "
            end
          end
        end
        local expertStr = ""
        expertStr = WorkerUtil.GetEffectText(tonumber(peculiarity), tonumber(peculiarityVlue))
        workerDesc = string.format([[
%s%s
%s%s]], Localization:GetString(100038), workPlaceStr, Localization:GetString(135201), expertStr)
      end
    end
    return workerDesc
  elseif rewardType == RewardType.DailyTaskPoint then
    return Localization:GetString(180375)
  elseif rewardType == RewardType.FourthFormation then
    return Localization:GetString(2000158)
  elseif rewardType == RewardType.MonthCardBuff then
    return Localization:GetString(2000165)
  elseif rewardType == RewardType.MarchDefReductionBuff then
    return Localization:GetString(2000664)
  elseif rewardType == RewardType.VISITOR then
    if id then
      local line = LocalController:instance():getLine(TableName.City_Visitor, tonumber(id))
      if line then
        local desc = line.desc or ""
        if not string.IsNullOrEmpty(desc) then
          return Localization:GetString(desc)
        end
      end
    end
    return Localization:GetString("HTS100008")
  elseif rewardType == RewardType.CommonEquip then
    local equipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(id)
    if equipTemplate ~= nil then
      return Localization:GetString(equipTemplate.desc)
    end
  elseif rewardType == RewardType.ActGiftBox then
    local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(id)
    return Localization:GetString(template.reward_desc)
  elseif rewardType == RewardType.EMOTION_SELECT then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
    if template ~= nil and template.gainMethod ~= nil and _G.type(template.gainMethod) == "table" and #template.gainMethod > 0 then
      local method = template.gainMethod[1]
      if method ~= nil and method.id ~= nil then
        return DataCenter.ItemTemplateManager:GetDes(method.id)
      end
    end
  elseif rewardType == RewardType.CHAT_EMOTION then
    return DataCenter.ItemTemplateManager:GetDes(id)
  end
  return ""
end

local function GetMailReward(self, list)
  local params = {}
  for k, v in pairs(list) do
    local param = {}
    if v.t ~= nil then
      param.itemId = v.t
      if v.v ~= nil then
        param.count = v.v
      end
      table.insert(params, param)
    end
  end
  return params
end

local function ShowDailyTaskReward(self, message)
  local list = {}
  if message.rewardList ~= nil then
    list = self:ReturnRewardParamForMessage(message.rewardList)
  end
  local param = {}
  param.rewardList = list
  param.title = Localization:GetString("130067")
  self:SetParam(param)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
    anim = true,
    playEffect = false,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide
  })
end

local function ShowTalentChoose(self, talentId)
  local param = {}
  param.title = Localization:GetString("130067")
  local list = {}
  local tempParam = {}
  tempParam.rewardType = RewardType.TALENT
  tempParam.itemId = talentId
  if tempParam.count ~= 0 then
    table.insert(list, tempParam)
  end
  param.rewardList = list
  self:SetParam(param)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
    anim = true,
    playEffect = false,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide
  })
end

local function GetParam(self)
  return self.param
end

local function SetParam(self, param)
  self.param = param
end

local function ClearParam(self)
  self.param = nil
end

local function GetRewardNames(self, reward)
  local nameList = {}
  for _, v in ipairs(reward) do
    local rewardType = v.type or v.rewardType
    local itemId = v.value.itemId or v.value.id
    local name = self:GetNameByType(rewardType, itemId)
    table.insert(nameList, name)
  end
  return nameList
end

local function StrRewardHandle(self, str, isCount, index)
  if str == "" then
    return nil
  end
  local list = {}
  local rewardList = string.split(str, "|")
  if isCount then
    for i = 1, #rewardList do
      local reward = string.split(rewardList[i], ";")
      local param = {}
      param.itemId = tonumber(reward[1])
      param.count = tonumber(reward[2])
      table.insert(list, param)
    end
  else
    for i = 1, #rewardList do
      local reward = string.split(rewardList[i], ";")
      if index then
        if index == i then
          for k = 1, #reward do
            local param = {}
            param.itemId = tonumber(reward[k])
            param.count = 1
            table.insert(list, param)
          end
          break
        end
      else
        for k = 1, #reward do
          local param = {}
          param.itemId = tonumber(reward[k])
          param.count = 1
          table.insert(list, param)
        end
      end
    end
  end
  return list
end

local function StrRewardToNumHandle(self, str, index)
  if str == "" then
    return nil
  end
  local list = {}
  local rewardList = string.split(str, "|")
  for i = 1, #rewardList do
    local reward = string.split(rewardList[i], ";")
    if index and index == i then
      for k = 1, #reward do
        local str1 = string.split(reward[k], ",")
        local param = {}
        param.itemId = tonumber(str1[1])
        param.count = tonumber(str1[2])
        table.insert(list, param)
      end
      break
    end
  end
  return list
end

local function GetRewardNumsInPveScene(self, num, notShowNum, rewardType)
  local tmp = {}
  
  local function GetOnePicEqualsNum(rewardType, num)
    if rewardType == RewardType.GOODS or rewardType == RewardType.RESOURCE_ITEM or rewardType == RewardType.PVE_ACT_SCORE then
      if num <= 20 then
        return 1
      elseif num <= 40 then
        return 2
      else
        return 5
      end
    end
    if rewardType == RewardType.WATER then
      return 10
    end
    if rewardType == RewardType.METAL or rewardType == RewardType.WOOD or rewardType == RewardType.FOOD or rewardType == RewardType.ELECTRICITY or rewardType == RewardType.PEOPLE then
      if num <= 2000 then
        return 100
      elseif num <= 5000 then
        return 200
      else
        return 500
      end
    end
    if 200 <= num then
      return num / 20
    end
    return 5
  end
  
  if not notShowNum then
    local onePicEqualsNum = GetOnePicEqualsNum(rewardType, num)
    onePicEqualsNum = math.max(onePicEqualsNum, 1)
    local maxNum = math.ceil(num / onePicEqualsNum)
    local count = num
    local index = 1
    local total = math.min(count, maxNum)
    local currentNum = 0
    while index <= total and not (count <= currentNum) do
      if index == total then
        if notShowNum then
          table.insert(tmp, -1)
        else
          table.insert(tmp, count - currentNum)
        end
      else
        if notShowNum then
          table.insert(tmp, -1)
        else
          table.insert(tmp, onePicEqualsNum)
        end
        currentNum = currentNum + onePicEqualsNum
      end
      index = index + 1
    end
  else
    local bigNum = math.floor(num / 5)
    local smallNum = math.floor(num / 5) + num - (math.floor(num / 5) * 4 + math.floor(num / 5))
    local index = 1
    while bigNum >= index do
      table.insert(tmp, -1)
      index = index + 1
    end
    index = 1
    while smallNum >= index do
      local insertIndex = Mathf.Round(math.random() * (bigNum + index - 1))
      insertIndex = math.max(1, math.min(bigNum + index - 1, insertIndex))
      table.insert(tmp, insertIndex, -2)
      index = index + 1
    end
  end
  return tmp
end

local function GetRewardQuality(self, rewardType, id)
  local quality = 1
  if rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
    if template then
      quality = template.quality
      if template.type == ResourceItemRealType.Soldier or template.type == ResourceItemRealType.MummySoldier then
        local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(id)
        if soldierTemplate and soldierTemplate.quality then
          quality = soldierTemplate.quality
        end
      end
    end
  elseif rewardType == RewardType.HERO then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(id)
    if heroTemplate then
      quality = heroTemplate.quality
    end
  elseif rewardType == RewardType.EQUIP then
    local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(tonumber(id))
    if equipTemplate then
      quality = equipTemplate.quality
    end
  elseif rewardType == RewardType.GOODS then
    local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    if goodsTemplate then
      quality = goodsTemplate.color
    end
  elseif rewardType == RewardType.BATTLE_PASS then
    quality = ItemColor.BLUE
  elseif rewardType == RewardType.ALLIANCE_GIFT then
    quality = GetTableData(TableName.AllianceGiftGroup, id, "color")
  elseif rewardType == RewardType.WORKER then
    if id then
      local workerQuality = GetTableData(TableName.LW_Worker, id, "quality")
      if workerQuality then
        quality = workerQuality
      end
    end
  elseif rewardType == RewardType.DailyTaskPoint then
    quality = ItemColor.BLUE
  elseif rewardType == RewardType.FourthFormation then
    quality = ItemColor.ORANGE
  elseif rewardType == RewardType.MonthCardBuff then
    quality = ItemColor.ORANGE
  elseif rewardType == RewardType.MarchDefReductionBuff then
    quality = ItemColor.ORANGE
  elseif rewardType == RewardType.VISITOR then
    if id then
      local line = LocalController:instance():getLine(TableName.City_Visitor, tonumber(id))
      if line then
        quality = line.color or 1
      end
    end
  elseif rewardType == RewardType.CommonEquip then
    if id then
      local equipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(id)
      if equipTemplate then
        quality = equipTemplate.quality
      end
    end
  elseif rewardType == RewardType.DragonWorldPoint then
    quality = ItemColor.ORANGE
  elseif rewardType == RewardType.Credit then
    quality = ItemColor.BLUE
  elseif rewardType == RewardType.TWSkillChip then
    if id then
      local template = DataCenter.TWSkillChipTemplateManager:GetTemplate(id)
      if template then
        quality = template.quality
      end
    end
  elseif rewardType == RewardType.TACTICAL_CARD then
    local template = DataCenter.TacticalCardDataManager:GetTemplateData(id)
    if template then
      quality = template.color
    end
  elseif rewardType == RewardType.RESOURCE then
    if id == 15 then
      quality = ItemColor.PURPLE
    elseif id == 1005 then
      quality = ItemColor.ORANGE
    end
  elseif rewardType == RewardType.EMOTION_SELECT then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
    if template ~= nil and template.gainMethod ~= nil and _G.type(template.gainMethod) == "table" and #template.gainMethod > 0 then
      local method = template.gainMethod[1]
      if method ~= nil and method.id ~= nil then
        local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(method.id)
        if goodsTemplate then
          quality = goodsTemplate.color
        end
      end
    end
  elseif rewardType == RewardType.CHAT_EMOTION then
    local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    if goodsTemplate then
      quality = goodsTemplate.color
    end
  end
  return quality
end

function RewardManager:GetRewardQualityWithOthers(rewardType, id)
  local quality
  if rewardType == RewardType.DecorateBuild then
    quality = BuildingUtils.GetDecorateColor(id, true)
  elseif rewardType == RewardType.GOLD then
    quality = ItemColor.PURPLE
  else
    quality = self:GetRewardQuality(rewardType, id)
  end
  return quality
end

local function GetRewardQualityBg(self, rewardType, id)
  local quality = GetRewardQuality(self, rewardType, id)
  if rewardType == RewardType.HERO then
    return HeroUtils.GetQualityIconPath(quality, false)
  else
    return UIUtil.GetItemQualityBg(quality)
  end
end

local function ParseOneRewardStr(self, str)
  if str == nil or str == "" then
    return nil
  end
  local ui_flag, id, _rewardType, _num = string.match(str, "(%d+)[,;](%d+)[,;](%d+)[,;](%d+)")
  if ui_flag == nil then
    id, _rewardType, _num = string.match(str, "(%d+)[,;](%d+)[,;](%d+)")
    if id == nil then
      return nil
    end
  end
  return self:ParseOneReward(id, tonumber(_rewardType), tonumber(_num))
end

function RewardManager:ParseOneReward(id, rewardType, count)
  local item
  if rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    if goods ~= nil then
      item = {}
      item.iconName = string.format(LoadPath.ItemPath, goods.icon)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
      item.itemName = DataCenter.ItemTemplateManager:GetName(id)
      item.itemDesc = DataCenter.ItemTemplateManager:GetDes(id)
      local itemType = goods.type
      item.goodsType = itemType
      item.para2 = goods.para2
      item.isLocal = true
      if itemType == 2 then
        if goods.para1 ~= nil and goods.para1 ~= "" then
          local para1 = goods.para1
          local temp = string.split(para1, ";")
          if temp ~= nil and 1 < #temp then
            item.itemFlag = temp[1] .. temp[2]
          end
        end
      elseif itemType == GOODS_TYPE.GOODS_TYPE_110 then
        if goods.para2 ~= nil and goods.para2 ~= "" then
          local res_num = tonumber(goods.para2)
          item.itemFlag = string.GetFormattedStr(res_num)
        end
      elseif itemType == 3 then
        local type2 = goods.type2
        if type2 ~= 999 and goods.para ~= nil then
          local res_num = tonumber(goods.para)
          item.itemFlag = string.GetFormattedStr(res_num)
        end
      end
    end
  elseif rewardType == RewardType.HERO then
    local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(id)
    if heroConfig ~= nil then
      item = {}
      item.iconName = HeroUtils.GetHeroIconPath(id)
      item.itemColor = HeroUtils.GetQualityIconPath(heroConfig.quality, false)
      item.itemName = heroConfig.name
      item.itemDesc = heroConfig.name
      item.isLocal = false
    end
  elseif rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
    if template ~= nil then
      item = {}
      item.iconName = string.format(LoadPath.ItemPath, template.pic)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(DataCenter.ResourceItemDataManager:GetResourceItemQuality(id))
      item.itemName = template.name
      item.itemDesc = template.desc
      item.isLocal = false
    end
  elseif rewardType == RewardType.EQUIP then
    local equip = DataCenter.EquipTemplateManager:GetTemplate(id)
    if equip ~= nil then
      item = {}
      item.iconName = string.format(LoadPath.ItemPath, equip.icon)
      item.itemColor = UIUtil.GetItemQualityBg(equip.quality)
      item.itemName = equip.name
      item.itemDesc = equip.desc
      item.isLocal = false
    end
  elseif rewardType == RewardType.WORKER then
    local line = LocalController:instance():getLine(TableName.LW_Worker, tonumber(id))
    if line then
      local modelId = line.appearance
      local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(modelId)
      local apperaCfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
      if apperaCfg then
        local icon = apperaCfg.half_icon_path
        local quality = line.quality
        item = {}
        item.iconName = UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, icon)
        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN)
        item.itemName = self:GetNameByType(rewardType, id)
        item.itemDesc = self:GetDesByType(rewardType, id)
        item.itemQuality = quality
        item.isLocal = true
      end
    end
  elseif rewardType == RewardType.VISITOR then
    local line = LocalController:instance():getLine(TableName.City_Visitor, tonumber(id))
    if line then
      item = {}
      item.itemQuality = self:GetRewardQuality(rewardType, id)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(item.itemQuality)
      item.itemName = self:GetNameByType(rewardType, id)
      item.itemDesc = self:GetDescByType(rewardType, id)
      item.iconName = self:GetPicByType(rewardType, id)
      item.isLocal = true
    end
  else
    local resourceType = RewardToResType[rewardType]
    if resourceType ~= nil then
      item = {}
      item.iconName = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
      if resourceType == ResourceType.Gold then
        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
      else
        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN)
      end
      item.itemName = self:GetNameByType(rewardType, id)
      item.itemDesc = self:GetDescByType(rewardType, id)
      item.isLocal = true
    else
      item = {}
      item.rewardType = rewardType
      item.itemId = tonumber(id)
      item.count = count
    end
  end
  if item ~= nil then
    item.itemId = tonumber(id)
    item.count = count
    item.rewardType = rewardType
  end
  return item
end

local function ParseRewardsStr(self, str, sep)
  local rewards = {}
  if not string.IsNullOrEmpty(str) then
    if sep == "|" or string.IsNullOrEmpty(sep) then
      for one in string.gmatch(str, "([^|]+)|?") do
        if one ~= nil and one ~= "" then
          local item = self:ParseOneRewardStr(one)
          if item ~= nil then
            table.insert(rewards, item)
          end
        end
      end
    else
      local strVec = string.split(str, sep)
      for i = 1, #strVec do
        local item = self:ParseOneRewardStr(strVec[i])
        if item ~= nil then
          table.insert(rewards, item)
        end
      end
    end
  end
  return rewards
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
        oneData.count = v.count
        oneData.rewardType = v.rewardType
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
        elseif itemType == 5 and goods.para3 ~= nil and goods.para3 ~= "" then
          local res_num = tonumber(goods.para3)
          oneData.itemFlag = string.GetFormattedStr(res_num)
        end
        table.insert(showList, oneData)
      elseif v.rewardType == RewardType.RESOURCE_ITEM then
        local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(tonumber(v.itemId))
        if template ~= nil then
          local oneData = {}
          oneData.itemId = id
          oneData.count = v.count
          oneData.rewardType = v.rewardType
          oneData.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
          oneData.itemFlag = nil
          table.insert(showList, oneData)
        end
      end
    elseif v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.GOLD or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OBSIDIAN or v.rewardType == RewardType.ELECTRICITY or v.rewardType == RewardType.FORMATION_STAMINA then
      local oneData = {}
      oneData.count = v.count
      oneData.rewardType = v.rewardType
      oneData.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
      oneData.itemFlag = nil
      table.insert(showList, oneData)
    end
  end)
  return showList
end

local function ShowGeift(self, t)
  DataCenter.RewardManager:AddRewards(t.reward)
  DataCenter.RewardManager:ShowCommonReward(t)
  local rewardIds = LuaEntry.DataConfig:TryGetStr("occupied_report", "k3")
  rewardIds = string.split(rewardIds, ";")
  local packId, pack, temp
  for i, v in pairs(rewardIds) do
    temp = GiftPackManager.get(v)
    if temp then
      packId = v
      pack = temp
    end
  end
  if packId and pack then
    local result, rechargeType, rechargeId = GiftPackManager.CheckIfIsPopupPackage(packId)
    local forbidPop = false
    local login_open_forbid = DataCenter.RechargeManager:getStrValue(rechargeId, "login_open_forbid")
    if not string.IsNullOrEmpty(login_open_forbid) and login_open_forbid == "1" then
      forbidPop = true
    end
    if result and not forbidPop then
      GiftPackManager.TryShowPopupPackage(pack, rechargeType, rechargeId)
    end
  end
end

local function GetActGiftBox(self, message)
  local retList = {}
  if message.lotteryItems then
    for i = 1, table.count(message.lotteryItems) do
      local oneData = {}
      local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(message.lotteryItems[i])
      if template.reward_icon == "" then
        oneData.sortOrder = 1
        oneData.rewardType = RewardType.GOODS
        local str = string.split(template.goods, ";")
        oneData.itemId = str[1]
        oneData.count = str[2]
      else
        oneData.sortOrder = 0
        oneData.rewardType = RewardType.ActGiftBox
        oneData.count = 1
        oneData.itemId = message.lotteryItems[i]
        oneData.itemName = " "
      end
      table.insert(retList, oneData)
    end
    table.sort(retList, function(a, b)
      if a.sortOrder < b.sortOrder then
        return true
      end
      return false
    end)
  end
  return retList
end

function RewardManager:ConcatRewardList(theList, extra_show_info)
  local dict = {}
  for _, strList in ipairs(theList) do
    if type(strList) == "string" then
      strList = string.split(strList, "|")
    end
    for _, str in ipairs(strList) do
      if str ~= nil and str ~= "" then
        local _extra_show_info, id, rewardType, num = string.match(str, "(%d+)[,;](%d+)[,;](%d+)[,;](%d+)")
        if _extra_show_info ~= nil and extra_show_info == _extra_show_info then
          local k = id .. ";" .. rewardType
          dict[k] = (dict[k] or 0) + tonumber(num)
        elseif _extra_show_info == nil then
          id, rewardType, num = string.match(str, "(%d+)[,;](%d+)[,;](%d+)")
          if id ~= nil then
            local k = id .. ";" .. rewardType
            dict[k] = (dict[k] or 0) + tonumber(num)
          end
        end
      end
    end
  end
  local t = {}
  for k, v in pairs(dict) do
    table.insert(t, k .. ";" .. v)
  end
  return t
end

local function GetFlagText(self, rewardType, itemId)
  local flagText = ""
  if rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if goods ~= nil then
      local join_method = -1
      local icon_join
      if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
        join_method = goods.join_method
        icon_join = goods.icon_join
      end
      if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
        flagText = ""
      else
        local itemType = goods.type
        if itemType == GOODS_TYPE.GOODS_TYPE_2 then
          if goods.para1 ~= nil and goods.para1 ~= "" then
            local para1 = goods.para1
            local temp = string.split(para1, ";")
            if temp ~= nil and 1 < #temp then
              flagText = temp[1] .. temp[2]
            end
          end
        elseif itemType == GOODS_TYPE.GOODS_TYPE_110 then
          if goods.para2 ~= nil and goods.para2 ~= "" then
            local res_num = tonumber(goods.para2)
            flagText = string.GetFormattedStr(res_num)
          end
        elseif itemType == GOODS_TYPE.GOODS_TYPE_3 or goods.type == GOODS_TYPE.GOODS_TYPE_91 then
          local type2 = goods.type2
          if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
            local res_num = tonumber(goods.para)
            if table.containsKey(PassYearItemIdList, toInt(itemId)) then
              flagText = res_num
            else
              flagText = string.GetFormattedStr(res_num)
            end
          end
        elseif itemType == GOODS_TYPE.GOODS_TYPE_5 or goods.type == GOODS_TYPE.GOODS_TYPE_59 then
          if not string.IsNullOrEmpty(goods.para4) then
            local nameValue = goods.para4
            local text = ""
            if not string.IsNullOrEmpty(nameValue) then
              local nameValueArr = string.split(nameValue, "|")
              if not table.IsNullOrEmpty(nameValueArr) then
                if #nameValueArr == 1 then
                  text = Localization:GetString(nameValueArr[1])
                elseif #nameValueArr == 2 then
                  text = Localization:GetString(nameValueArr[1], nameValueArr[2])
                elseif #nameValueArr == 3 then
                  text = Localization:GetString(nameValueArr[1], nameValueArr[2], nameValueArr[3])
                end
              end
            end
            if not string.IsNullOrEmpty(text) then
              flagText = text
            end
          end
        elseif itemType == GOODS_TYPE.GOODS_TYPE_111 then
          if goods.para1 ~= nil and goods.para1 ~= "" then
            local para1 = goods.para1
            local temp = string.split(para1, ";")
            if temp ~= nil and 1 < #temp then
              flagText = temp[1] .. temp[2]
            end
          end
        elseif itemType == GOODS_TYPE.GOODS_TYPE_133 and goods.para1 ~= nil and goods.para1 ~= "" then
          local para1 = goods.para1
          local num = tonumber(para1)
          if num then
            flagText = string.GetFormattedStr(num)
          end
        end
      end
    end
  elseif rewardType == RewardType.CommonEquip then
    local equipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(itemId)
    if equipTemplate then
      local level = equipTemplate.level
      if 0 < level then
        flagText = string.format("Lv.%d", level)
      end
    end
  end
  return flagText
end

function RewardManager:ParseRewardInfo(info)
  local item = {}
  if info.type then
    item.rewardType = toInt(info.type)
  elseif info.rewardType then
    item.rewardType = toInt(info.rewardType)
  end
  if info.count and type(info.count) == "number" then
    item.count = toInt(info.count)
  end
  if info.value then
    if type(info.value) == "number" then
      item.count = toInt(info.value)
    else
      item.itemId = toInt(info.value.id)
      item.count = toInt(info.value.num or 1)
    end
  elseif info.itemId then
    item.itemId = toInt(info.itemId)
    item.count = toInt(info.count or 1)
  end
  return item
end

function RewardManager:ParseRewardsInfo(rewards)
  local ret = {}
  for k, v in pairs(rewards) do
    table.insert(ret, self:ParseRewardInfo(v))
  end
  return ret
end

local function CombineRewardList(self, rewardList)
  if rewardList == nil then
    return nil
  end
  local newRewardList = {}
  local rewardCount = table.count(rewardList)
  for i = 1, rewardCount do
    local reward = rewardList[i]
    local have = false
    if type(reward.count) == "number" then
      for j = 1, table.count(newRewardList) do
        local newReward = newRewardList[j]
        if newReward.rewardType == reward.rewardType then
          if (newReward.itemId == nil or newReward.itemId == "") and (reward.itemId == nil or reward.itemId == "") then
            newReward.count = newReward.count + reward.count
            have = true
            break
          elseif newReward.itemId == reward.itemId then
            newReward.count = newReward.count + reward.count
            have = true
            break
          end
        end
      end
    end
    if not have then
      table.insert(newRewardList, reward)
    end
  end
  return newRewardList
end

local function ShowDetectEventCombineReward(self, rewardList)
  local param = {}
  param.rewardList = CombineRewardList(self, rewardList)
  param.title = Localization:GetString("128027")
  param.tips = Localization:GetString("radar_tips_15")
  param.flyReward = false
  self:SetParam(param)
  if DataCenter.GuideManager:IsCanShowReward() then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, param)
  else
    DataCenter.GuideManager:SetGuideEndCallBack(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, param)
    end)
  end
end

function RewardManager:ParseBuyConditionStr(configStr, firstSep, secondSep)
  if string.IsNullOrEmpty(configStr) then
    return nil
  end
  if firstSep == nil then
    firstSep = "|"
  end
  if secondSep == nil then
    secondSep = ";"
  end
  local res = {}
  local strArray1 = string.split_ss_array(configStr, firstSep)
  if 0 < #strArray1 then
    for _, v in pairs(strArray1) do
      local strArray2 = string.split_ss_array(v, secondSep)
      local conditionType = tonumber(strArray2[1])
      for _, j in pairs(BuyConditionType) do
        if j == conditionType then
          if conditionType == BuyConditionType.HeroRankLevel or conditionType == BuyConditionType.HeroAwakenLevel then
            local conditionParamArr = string.split_ss_array(strArray2[2], ",")
            local conditionParam = {
              tonumber(conditionParamArr[1]),
              tonumber(conditionParamArr[2])
            }
            table.insert(res, {conditionType = conditionType, conditionParam = conditionParam})
          elseif conditionType == BuyConditionType.HeroUniqueWeaponLevel then
            local conditionParam = {
              tonumber(strArray2[2]),
              tonumber(strArray2[3])
            }
            table.insert(res, {conditionType = conditionType, conditionParam = conditionParam})
          elseif conditionType == BuyConditionType.DominatorMainTrainGroupLevel or conditionType == BuyConditionType.DominatorRankLevel or conditionType == BuyConditionType.HasDominator or conditionType == BuyConditionType.HasUnlockedDominator then
            local conditionParam = tonumber(strArray2[2])
            table.insert(res, {conditionType = conditionType, conditionParam = conditionParam})
          elseif conditionType == BuyConditionType.MainBuildingLevel then
            local conditionParam = tonumber(strArray2[2])
            table.insert(res, {conditionType = conditionType, conditionParam = conditionParam})
          end
        end
      end
    end
  end
  return res
end

function RewardManager:GetInconsistentBuyConditions(buyConditions)
  if buyConditions == nil then
    return nil
  end
  local res = {}
  for _, v in pairs(buyConditions) do
    if v.conditionType == BuyConditionType.DominatorMainTrainGroupLevel then
      if not DataCenter.DominatorManager:IsDominatorFunctionOn() then
        table.insert(res, v)
      else
        local isConsistent = false
        local requireTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(v.conditionParam)
        if requireTemplate then
          local mainInfo = DataCenter.DominatorManager:GetMainTrainGroupInfo()
          if mainInfo then
            local curTemplate = mainInfo:GetCurLevelTemplate()
            if curTemplate and curTemplate.level_order >= requireTemplate.level_order then
              isConsistent = true
            end
          end
        end
        if not isConsistent then
          table.insert(res, v)
        end
      end
    elseif v.conditionType == BuyConditionType.DominatorRankLevel then
      if not DataCenter.DominatorManager:IsDominatorFunctionOn() then
        table.insert(res, v)
      else
        local isConsistent = false
        local requireTemplate = DataCenter.DominatorTemplateManager:GetRankTemplateById(v.conditionParam)
        if requireTemplate then
          local mainTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateByRankGroup(requireTemplate.group)
          if mainTemplate then
            local info = DataCenter.DominatorManager:GetInfoById(mainTemplate.id)
            if info then
              local curTemplate = info:GetCurRankTemplate()
              if curTemplate and curTemplate.level_num >= requireTemplate.level_num then
                isConsistent = true
              end
            end
          end
        end
        if not isConsistent then
          table.insert(res, v)
        end
      end
    elseif v.conditionType == BuyConditionType.HasUnlockedDominator then
      if not DataCenter.DominatorManager:IsDominatorFunctionOn() then
        table.insert(res, v)
      else
        local isConsistent = false
        local requireTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateById(v.conditionParam)
        if requireTemplate then
          local info = DataCenter.DominatorManager:GetInfoById(requireTemplate.id)
          if info and info:IsUnlocked() then
            isConsistent = true
          end
        end
        if not isConsistent then
          table.insert(res, v)
        end
      end
    elseif v.conditionType == BuyConditionType.HasDominator then
      if not DataCenter.DominatorManager:IsDominatorFunctionOn() then
        table.insert(res, v)
      else
        local isConsistent = false
        local requireTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateById(v.conditionParam)
        if requireTemplate then
          local info = DataCenter.DominatorManager:GetInfoById(requireTemplate.id)
          if info and info:IsDataValid() then
            isConsistent = true
          end
        end
        if not isConsistent then
          table.insert(res, v)
        end
      end
    elseif v.conditionType == BuyConditionType.HeroUniqueWeaponLevel then
      local isConsistent = false
      local heroId = tonumber(v.conditionParam[1])
      local uniqueWeaponLevel = tonumber(v.conditionParam[2])
      local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
      if heroData then
        local curUniqueWeaponLevel = heroData:GetUniqueWeaponLv()
        if uniqueWeaponLevel <= curUniqueWeaponLevel then
          isConsistent = true
        end
      end
      if not isConsistent then
        table.insert(res, v)
      end
    elseif v.conditionType == BuyConditionType.HeroRankLevel then
      local isConsistent = false
      local heroId = tonumber(v.conditionParam[1])
      local rankLv = tonumber(v.conditionParam[2])
      local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
      if heroData then
        local curRankLv = heroData:GetRank()
        if rankLv <= curRankLv then
          isConsistent = true
        end
      end
      if not isConsistent then
        table.insert(res, v)
      end
    elseif v.conditionType == BuyConditionType.HeroAwakenLevel then
      local isConsistent = false
      local heroId = tonumber(v.conditionParam[1])
      local awakenLv = tonumber(v.conditionParam[2])
      local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
      if heroData then
        local curAwakenLv = heroData:GetHeroAwakenRankLevel()
        if awakenLv <= curAwakenLv then
          isConsistent = true
        end
      end
      if not isConsistent then
        table.insert(res, v)
      end
    elseif v.conditionType == BuyConditionType.MainBuildingLevel then
      local isConsistent = false
      local mainBuildingLv = tonumber(v.conditionParam)
      if DataCenter.BuildManager.MainLv and mainBuildingLv <= DataCenter.BuildManager.MainLv then
        isConsistent = true
      end
      if not isConsistent then
        table.insert(res, v)
      end
    end
  end
  return res
end

function RewardManager:ConvertBuyConditionToText(buyCondition)
  if buyCondition == nil then
    return ""
  end
  if buyCondition.conditionType == BuyConditionType.DominatorMainTrainGroupLevel then
    local requireTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(buyCondition.conditionParam)
    if requireTemplate then
      return Localization:GetString("buy_condtion_desc1", requireTemplate:GetName(true))
    end
  elseif buyCondition.conditionType == BuyConditionType.DominatorRankLevel then
    local requireTemplate = DataCenter.DominatorTemplateManager:GetRankTemplateById(buyCondition.conditionParam)
    if requireTemplate then
      local mainTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateByRankGroup(requireTemplate.group)
      if mainTemplate then
        return Localization:GetString("buy_condtion_desc4", mainTemplate:GetName(), requireTemplate:GetShowLevelText())
      end
    end
  elseif buyCondition.conditionType == BuyConditionType.HasUnlockedDominator then
    local requireTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateById(buyCondition.conditionParam)
    if requireTemplate then
      return Localization:GetString("buy_condtion_desc3", requireTemplate:GetName())
    end
  elseif buyCondition.conditionType == BuyConditionType.HasDominator then
    local requireTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateById(buyCondition.conditionParam)
    if requireTemplate then
      return Localization:GetString("buy_condtion_desc3", requireTemplate:GetName())
    end
  elseif buyCondition.conditionType == BuyConditionType.HeroUniqueWeaponLevel then
    return Localization:GetString("buy_condtion_desc5", buyCondition.conditionParam[2])
  end
  return ""
end

local function GetRewardTypeByDropType(self, type)
  local rewardType
  if type == HeroRecruitRateDetailInfoType.Hero then
    rewardType = RewardType.HERO
  elseif type == HeroRecruitRateDetailInfoType.Goods then
    rewardType = RewardType.GOODS
  elseif type == HeroRecruitRateDetailInfoType.ResItem then
    rewardType = RewardType.RESOURCE_ITEM
  elseif type == HeroRecruitRateDetailInfoType.Worker then
    rewardType = RewardType.WORKER
  elseif type == HeroRecruitRateDetailInfoType.SquadEquip then
    rewardType = RewardType.CommonEquip
  elseif type == HeroRecruitRateDetailInfoType.Equip then
    rewardType = RewardType.EQUIP
  elseif type == HeroRecruitRateDetailInfoType.SkillChip then
    rewardType = RewardType.TWSkillChip
  end
  return rewardType
end

local function ShowSingleReward(self, message, callback)
  local singleShowReward = message.singleShowReward or {}
  if not next(singleShowReward) then
    if callback then
      callback()
    end
    return
  end
  local list = {}
  list = self:ReturnRewardParamForMessage(singleShowReward) or {}
  table.sort(list, function(a, b)
    if a.rewardType ~= b.rewardType then
      return a.rewardType == RewardType.HERO and true or false
    else
      return a.sortOrder < b.sortOrder
    end
  end)
  local param = {}
  param.rewardList = list
  param.title = Localization:GetString("128027")
  if message.ownerInfo and (message.fromDispatchStealMessage or message.fromDispatchAssistMessage) then
    param.fromDispatchStealMessage = message.fromDispatchStealMessage
    param.fromDispatchAssistMessage = message.fromDispatchAssistMessage
    param.ownerInfo = message.ownerInfo
  end
  if message.completeByHelper then
    param.completeByHelper = message.completeByHelper
  end
  param.CloseFunc = callback
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageOnlyRewardSingle, {
    anim = true,
    playEffect = false,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide
  }, param)
end

local function SequenceShowReward(self, message)
  local reward = message.reward
  local singleShowReward = message.singleShowReward or {}
  local haveLuckyPacket = message.haveLuckyPacket or false
  if reward == nil and not next(singleShowReward) then
    return
  end
  
  local function luckyPacketCallback()
    DataCenter.LuckyBuffManager:OpenLuckyPacketSharePopup(true)
  end
  
  if reward ~= nil and not next(singleShowReward) then
    self:ShowCommonReward(message, nil, nil, nil, nil, nil, haveLuckyPacket and luckyPacketCallback or nil)
  elseif reward == nil and next(singleShowReward) then
    self:ShowSingleReward(message, haveLuckyPacket and luckyPacketCallback or nil)
  else
    self:ShowSingleReward(message, function()
      self:ShowCommonReward(message, nil, nil, nil, nil, nil, haveLuckyPacket and luckyPacketCallback or nil)
    end)
  end
end

RewardManager.__init = __init
RewardManager.__delete = __delete
RewardManager.AddRewards = AddRewards
RewardManager.AddRewardsAndRes = AddRewardsAndRes
RewardManager.GetPicByType = GetPicByType
RewardManager.GetNameByType = GetNameByType
RewardManager.ShowGiftReward = ShowGiftReward
RewardManager.ShowCommonReward = ShowCommonReward
RewardManager.SequenceShowReward = SequenceShowReward
RewardManager.ShowSingleReward = ShowSingleReward
RewardManager.ShowGiftBoxOpenReward = ShowGiftBoxOpenReward
RewardManager.ShowTwoLinesRewards = ShowTwoLinesRewards
RewardManager.ShowCookingReward = ShowCookingReward
RewardManager.ReturnRewardParamForMessage = ReturnRewardParamForMessage
RewardManager.ReturnRewardParamForView = ReturnRewardParamForView
RewardManager.GetGolloesRewards = GetGolloesRewards
RewardManager.GetMailReward = GetMailReward
RewardManager.ShowDailyTaskReward = ShowDailyTaskReward
RewardManager.GetParam = GetParam
RewardManager.ClearParam = ClearParam
RewardManager.SetParam = SetParam
RewardManager.GetDescByType = GetDescByType
RewardManager.ShowCommonHeroReward = ShowCommonHeroReward
RewardManager.GetRewardNames = GetRewardNames
RewardManager.StrRewardHandle = StrRewardHandle
RewardManager.ShowTalentChoose = ShowTalentChoose
RewardManager.StrRewardToNumHandle = StrRewardToNumHandle
RewardManager.GetRewardNumsInPveScene = GetRewardNumsInPveScene
RewardManager.GetRewardQuality = GetRewardQuality
RewardManager.GetRewardQualityBg = GetRewardQualityBg
RewardManager.ParseOneRewardStr = ParseOneRewardStr
RewardManager.ParseRewardsStr = ParseRewardsStr
RewardManager.RewardItemList = RewardItemList
RewardManager.GetActGiftBox = GetActGiftBox
RewardManager.ShowGeift = ShowGeift
RewardManager.GetFlagText = GetFlagText
RewardManager.CombineRewardList = CombineRewardList
RewardManager.ShowDetectEventCombineReward = ShowDetectEventCombineReward
RewardManager.GetRewardTypeByDropType = GetRewardTypeByDropType
return RewardManager
