local UIHeroBountyTaskCtrl = BaseClass("UIHeroBountyTaskCtrl", UIBaseCtrl)

function UIHeroBountyTaskCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroBountyTask)
end

function UIHeroBountyTaskCtrl:InitData()
  self.curHeroes = {}
end

function UIHeroBountyTaskCtrl:GetRewards(rewardList)
  local reward = {}
  if rewardList == nil then
    return reward
  end
  table.walk(rewardList, function(_, v)
    local item = {}
    item.count = v.count
    item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
    item.rewardType = v.rewardType
    local desc = DataCenter.RewardManager:GetDescByType(v.rewardType, v.itemId)
    local name = DataCenter.RewardManager:GetNameByType(v.rewardType, v.itemId)
    item.itemName = name
    item.itemDesc = desc
    item.isLocal = true
    if v.rewardType == RewardType.GOODS then
      if v.itemId ~= nil then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
        if goods ~= nil then
          local join_method = -1
          local icon_join
          if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
            join_method = goods.join_method
            icon_join = goods.icon_join
          end
          if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
            local tempJoin = string.split(icon_join, ";")
            if 1 < #tempJoin then
              item.itemColor = tempJoin[2]
            end
            if 2 < #tempJoin then
              item.iconName = tempJoin[3]
            end
          else
            item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
            local itemType = goods.type
            item.goodsType = goods.type
            item.para2 = goods.para2
            if itemType == 2 then
              if goods.para1 ~= nil and goods.para1 ~= "" then
                local para1 = goods.para1
                local temp = string.split(para1, ";")
                if temp ~= nil and 1 < #temp then
                  item.itemFlag = temp[1] .. temp[2]
                end
              end
            elseif itemType == 3 then
              local type2 = goods.type2
              if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                local res_num = tonumber(goods.para)
                item.itemFlag = string.GetFormattedStr(res_num)
              end
            end
            item.iconName = string.format(LoadPath.ItemPath, goods.icon)
          end
        end
      end
    elseif v.rewardType == RewardType.GOLD then
      item.iconName = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
    elseif v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.FORMATION_STAMINA or v.rewardType == RewardType.WATER or v.rewardType == RewardType.PVE_POINT or v.rewardType == RewardType.DETECT_EVENT or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.ELECTRICITY then
      item.iconName = DataCenter.RewardManager:GetPicByType(v.rewardType)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
    elseif v.rewardType == RewardType.RESOURCE_ITEM then
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
      if template ~= nil then
        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
        item.iconName = string.format(LoadPath.ItemPath, template.pic)
      end
    elseif v.rewardType == RewardType.EXP then
      item.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
      item.iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_exp.png"
    end
    table.insert(reward, item)
  end)
  return reward
end

function UIHeroBountyTaskCtrl:GetHeroTotalStarNum()
  local num = 0
  for k, v in pairs(self.curHeroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
    if heroData ~= nil then
      local quality = heroData.quality
      local starNum, const = HeroUtils.GetHeroStarAndProgress(quality)
      num = num + starNum
    end
  end
  num = math.floor(num)
  return num
end

function UIHeroBountyTaskCtrl:GetHeroMaxRarity()
  local maxRarity = 4
  for k, v in pairs(self.curHeroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
    if heroData ~= nil then
      local heroConfig = heroData:GetConfig()
      local rarity = tonumber(heroConfig.rarity)
      if maxRarity > rarity then
        maxRarity = rarity
      end
    end
  end
  return maxRarity
end

function UIHeroBountyTaskCtrl:GetHeroNumByRarity(needRarity)
  local num = 0
  for k, v in pairs(self.curHeroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
    if heroData ~= nil then
      local heroConfig = heroData:GetConfig()
      local rarity = tonumber(heroConfig.rarity)
      if needRarity >= rarity then
        num = num + 1
      end
    end
  end
  return num
end

function UIHeroBountyTaskCtrl:CheckHasHeroByCampIndex(campIndex, num)
  local count = 0
  for k, v in pairs(self.curHeroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
    if heroData ~= nil then
      local heroConfig = heroData:GetConfig()
      local camp = tonumber(heroConfig.camp)
      if campIndex == camp then
        count = count + 1
      end
    end
  end
  return num <= count
end

function UIHeroBountyTaskCtrl:GetCurrentHeroDataList(camp)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
  local heroes = table.values(allHeroes)
  table.sort(heroes, function(heroA, heroB)
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    return heroA.heroId < heroB.heroId
  end)
  local result = {}
  for _, heroData in pairs(heroes) do
    if camp ~= nil and 0 < camp then
      local targetCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
      if targetCamp == camp then
        table.insert(result, heroData.uuid)
      end
    else
      table.insert(result, heroData.uuid)
    end
  end
  return result
end

function UIHeroBountyTaskCtrl:GetHeroDataByUuid(heroUuid)
  local data = {}
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local heroConfig = heroData:GetConfig()
  data.camp = heroConfig.camp
  local rarity = heroConfig.rarity
  data.hero_rarity = HeroUtils.GetRarityIconName(rarity, true)
  data.rankId = heroData:GetRank()
  data.heroUuid = heroUuid
  data.heroId = heroData.heroId
  data.qualityIndex = heroData.quality
  data.isWaken = heroData:IsWakeUp()
  data.quality = HeroUtils.GetQualityBgInTroopsByPath(rarity, data.isWaken)
  data.icon = HeroUtils.GetHeroBodyByHeroId(heroData.heroId)
  data.heroLevel = heroData.level
  data.index = 0
  data.rarity = rarity
  data.isSelect = false
  data.isLock = DataCenter.HeroBountyDataManager:GetHeroIsInTaskByUuid(heroUuid)
  if data.isLock == false then
    table.walk(self.curHeroes, function(k, v)
      if v == heroUuid then
        data.index = k
        data.isSelect = true
      else
        local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
        if tempHeroData ~= nil and tempHeroData.heroId == heroData.heroId then
          data.isLock = true
        end
      end
    end)
  end
  return data
end

function UIHeroBountyTaskCtrl:SelectHeroByUuid(heroUuid, maxHeroNum)
  local tempIndex = 0
  for i = 1, maxHeroNum do
    if tempIndex <= 0 and self.curHeroes[i] == nil then
      tempIndex = i
    end
  end
  if 0 < tempIndex then
    self.curHeroes[tempIndex] = heroUuid
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnSelectHeroSelectForBounty, heroData.heroId)
    end
  end
end

function UIHeroBountyTaskCtrl:OnDeleteHeroByIndex(index)
  if self.curHeroes[index] ~= nil then
    local uuid = 0
    uuid = self.curHeroes[index]
    self.curHeroes[index] = nil
    local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    if tempHeroData ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnCancelHeroSelectForBounty, tempHeroData.heroId)
    end
  end
end

function UIHeroBountyTaskCtrl:GetCurHeroData()
  return self.curHeroes
end

function UIHeroBountyTaskCtrl:GetTaskDataByIndex(index)
  local taskData = DataCenter.HeroBountyDataManager:GetTaskDataByIndex(index)
  local oneData = {}
  if taskData ~= nil then
    oneData.id = taskData.id
    oneData.index = taskData.index
    oneData.name = taskData.name
    local exp = tonumber(taskData.exp_hero)
    local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
    oneData.exp_hero = Mathf.Round(exp * (1 + effectValue / 100))
    oneData.rarity = taskData.rarity
    oneData.description = taskData.description
    oneData.needHeroNum = tonumber(taskData.needHeroNum)
    oneData.star_requirements = tonumber(taskData.star_requirements)
    local arr = taskData.rarity_requirements_list
    if 2 <= #arr then
      oneData.rarity_requirement = tonumber(arr[1])
      oneData.rarity_num_requirement = tonumber(arr[2])
    end
    oneData.camp_requirements_list = {}
    local campArr = taskData.camp_requirements_list
    if 0 < #campArr then
      for i = 1, #campArr do
        table.insert(oneData.camp_requirements_list, tonumber(campArr[i]))
      end
    end
    oneData.rewardStr = self:GetRewards(taskData.rewardList)
    return oneData
  end
end

function UIHeroBountyTaskCtrl:OnStartClick(index)
  SFSNetwork.SendMessage(MsgDefines.StartHeroBountyTask, index, self.curHeroes)
end

return UIHeroBountyTaskCtrl
