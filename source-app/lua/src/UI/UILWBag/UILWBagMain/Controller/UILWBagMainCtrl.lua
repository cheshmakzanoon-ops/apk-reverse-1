local UILWBagMainCtrl = BaseClass("UILWBagMainCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBagMain)
end

function UILWBagMainCtrl:GetResourceIconName(resourceType)
  return DataCenter.ResourceManager:GetResourceIconByType(resourceType)
end

function UILWBagMainCtrl:OnClickResourceBtn(resourceType)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, resourceType)
end

function UILWBagMainCtrl:GetCntByResType(resourceType)
  if DataCenter.ItemTemplateManager:GetItemTemplate(resourceType) ~= nil then
    local item = DataCenter.ItemData:GetItemById(resourceType)
    if item ~= nil then
      return item.count
    end
    return 0
  end
  return LuaEntry.Resource:GetCntByResType(resourceType)
end

local function GetItemListByType(self, tabType, itemType, selectId)
  if tabType ~= UICapacityTableTab.Item and tabType ~= UICapacityTableTab.ResourceItem then
    tabType = UICapacityTableTab.Item
  end
  if tabType == UICapacityTableTab.Item and itemType == UIBagTab.Equip then
    return self:GetEquipItemList()
  end
  local count = DataCenter.ItemData:GetItemRedDotCountByTabType(itemType)
  local result = {}
  local typeMap = {}
  if tabType == UICapacityTableTab.Resource then
    for k, v in ipairs(UICapacityTableResourceType) do
      local param = {}
      param.resourceType = v
      param.tabType = tabType
      param.quality_name = "Common_img_quality_blue"
      param.icon_name = DataCenter.ResourceManager:GetResourceIconByType(v)
      table.insert(result, param)
      table.insert(typeMap, BagItemType.Item)
    end
  elseif tabType == UICapacityTableTab.Farming then
    local itemList = DataCenter.ResourceItemDataManager:GetResourceItemListByTypeFromTemplate(tabType)
    if itemList ~= nil then
      table.sort(itemList, function(a, b)
        if selectId == tostring(a) then
          return true
        end
        if selectId == tostring(b) then
          return false
        end
        local task1 = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(a)
        local task2 = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(b)
        return task1 ~= nil and task2 ~= nil and task2.order > task1.order
      end)
      for k, v in ipairs(itemList) do
        local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v)
        if itemData ~= nil and itemData.number > 0 then
          local param = {}
          param.itemId = v
          param.tabType = tabType
          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v)
          if template ~= nil and template.show == 1 then
            param.icon_name = template.pic
            param.icon_full_path = template.pic_new
            param.name = template.name
            param.quality_name = "Common_img_quality_green"
            param.itemType = template.itemType
            table.insert(result, param)
            table.insert(typeMap, BagItemType.Item)
          end
        end
      end
    end
  elseif tabType == UICapacityTableTab.Item then
    local goodsIsChangeState = false
    local itemInfo = DataCenter.ItemData.ItemInfos
    for k, v in pairs(itemInfo) do
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
      if goods ~= nil and 0 < v.count and 0 <= goods.page then
        local param = {}
        param.itemId = goods.id
        param.tabType = tabType
        param.icon_name = goods.icon
        param.pages = goods.page
        param.order = goods.order
        param.redState = v.redState
        param.template = goods
        param.data = v
        local join_method = -1
        local icon_join
        if goods.join_method ~= nil and 0 < goods.join_method and goods.icon_join ~= nil and goods.icon_join ~= "" then
          join_method = goods.join_method
          icon_join = goods.icon_join
        end
        if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
          local tempJoin = string.split(icon_join, ";")
          if 1 < #tempJoin then
            param.quality_name = tempJoin[2]
          end
          if 2 < #tempJoin then
            param.quality_name = tempJoin[3]
          end
        else
          param.quality_name = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
        end
        local item = DataCenter.ItemData:GetItemById(param.itemId)
        if item ~= nil then
          param.num = string.GetFormattedSeperatorNum(item.count)
          param.newCount = item.newCount
        end
        param.flagtxt = DataCenter.RewardManager:GetFlagText(RewardType.GOODS, param.itemId)
        if param.pages == itemType then
          table.insert(result, param)
          table.insert(typeMap, BagItemType.Item)
        elseif itemType == 0 then
          if not v.redState then
            goodsIsChangeState = false
            if goods.important == 2 then
              if goods.needCount and v.count > goods.needCount then
                param.redState = true
              end
            else
              v.redState = false
            end
          end
          table.insert(result, param)
          table.insert(typeMap, BagItemType.Item)
        end
      else
        Logger.Log("Bag Get ItemTemplate Missing Config itemId " .. tostring(v.itemId))
      end
    end
    table.sort(result, function(a, b)
      local orderA = a.order
      local orderB = b.order
      if orderA ~= orderB then
        return orderA < orderB
      end
      local qualityA = a.template.color
      local qualityB = b.template.color
      if qualityA ~= qualityB then
        return qualityA > qualityB
      end
      return a.itemId < b.itemId
    end)
    if itemType == 0 and not goodsIsChangeState then
      EventManager:GetInstance():Broadcast(EventId.OnGoodsRedState, false)
    end
  elseif tabType == UICapacityTableTab.ResourceItem then
    local itemList = DataCenter.ResourceItemDataManager.itemList
    for k, v in pairs(itemList) do
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
      if template ~= nil and v.number > 0 and 0 <= template.page then
        local param = {}
        param.itemId = template.id
        param.tabType = tabType
        param.icon_name = template.pic
        param.icon_full_path = template.pic_new
        param.pages = template.page
        param.order = template.order
        param.redState = v.redState
        param.quality_name = DataCenter.ItemTemplateManager:GetToolBgByColor(template.quality)
        param.template = template
        param.data = v
        if param.pages == itemType then
          table.insert(result, param)
          table.insert(typeMap, BagItemType.ResourceItem)
        end
        table.sort(result, function(a, b)
          local orderA = a.order
          local orderB = b.order
          if orderA ~= orderB then
            return orderA < orderB
          end
          local qualityA = a.template.quality
          local qualityB = b.template.quality
          if qualityA ~= qualityB then
            return qualityA > qualityB
          end
          return a.itemId < b.itemId
        end)
      end
    end
  end
  return result, typeMap
end

local function GetItemDataByItemId(self, itemId)
  local data = {}
  data.itemId = itemId
  local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
  if template ~= nil then
    data.icon_name = template.pic
    data.icon_full_path = template.pic_new
    data.name = template.name
    data.quality_name = "Common_img_quality_green"
    data.itemType = template.itemType
  end
  return data
end

local function OnItemUse(self, item, count, useBtnPos, bagItemType, itemList, typeMap)
  if BattleFieldUtil.InBattleField() and bagItemType == BagItemType.Item and (item and item.itemId == SpecialItemId.LW_ITEM_ALLY_MOVE_CITY or item.itemId == SpecialItemId.ITEM_MOVE_RANDOM) then
    UIUtil.ShowTipsId(458287)
    return
  end
  if item ~= nil then
    local exchangeItemTemplate = DataCenter.ItemExchangeManager:GetItemExchangeTemplateByItemId(item.itemId)
    local isExpiredInItemInfoData = DataCenter.ItemData:CheckItemIsExpiredInOtherParamData(item.itemId)
    local isItemExpired = UIUtil.CheckItemIsExpired(item.itemId)
    if isItemExpired then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWExpiredItemExchange, {anim = true}, {
        itemId = item.itemId,
        exchangeItemTemplate = exchangeItemTemplate
      })
      return
    end
  end
  if item then
    local template = DataCenter.ItemTemplateManager:TryGetItemTemplate(item.itemId)
    if template then
      local gotoParaData = template:GetGotoParaData()
      if gotoParaData and gotoParaData.type == ItemGotoParaType.Activity and gotoParaData.gotoType and gotoParaData.gotoPara then
        local logData = {
          item_id = item.itemId,
          type = gotoParaData.gotoType,
          activityid = gotoParaData.gotoPara
        }
        PostEventLog.Track(PostEventLog.Defines.ItemBagOnGotoActivityByType, logData)
        GoToUtil.GoToByTypeAndParam(gotoParaData.gotoType, {
          gotoParaData.gotoPara
        })
        return
      end
    end
  end
  if item and bagItemType == BagItemType.HeroEquip or bagItemType == BagItemType.CommonEquip then
    if bagItemType == BagItemType.HeroEquip then
      local unequipped = not item:IsBeingWeared()
      local equipHeroUuid = item.heroUuid
      local equipDatas = itemList
      local equipUuids = {}
      for i, v in pairs(equipDatas) do
        if typeMap[i] and typeMap[i] == BagItemType.HeroEquip then
          table.insert(equipUuids, v.uuid)
        end
      end
      if DataCenter.EquipDataManager:IsPromoteFunctionOpen() and item:CanStartPromote() then
        local canPromoteEquipUuids = {}
        for i, v in ipairs(equipDatas) do
          if typeMap[i] and typeMap[i] == BagItemType.HeroEquip and v:IsMaxLevel() and not v:IsMaxPromoteLevel() and v:SupportPromote() then
            table.insert(canPromoteEquipUuids, v.uuid)
          end
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipPromote, {anim = false}, item.uuid, canPromoteEquipUuids)
        return
      end
      if not item:IsMaxLevel() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquipDetailPanel, {anim = true}, item.uuid, nil, equipUuids, false)
        return
      end
      if unequipped then
        GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        })
      elseif equipHeroUuid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, equipHeroUuid, {equipHeroUuid})
      end
      return
    elseif bagItemType == BagItemType.CommonEquip then
      local hasTacticalWeapon = DataCenter.TacticalWeaponManager:HasTacticalWeapon()
      if not hasTacticalWeapon then
        UIUtil.ShowTipsId(135272)
        return
      end
      local unlock, needLevel = DataCenter.TacticalWeaponManager:IsEquipFunctionUnlock()
      if not unlock then
        UIUtil.ShowTips(Localization:GetString(141152, needLevel))
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, TacticalWeaponPageType.Equip)
    end
    return
  end
  item = DataCenter.ItemData:GetItemById(item.itemId)
  if not item then
    return
  end
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(item.itemId)
  if DataCenter.ItemTemplateManager:IsNewVersionGoods(template.version) then
    return
  end
  local type = template.type
  if type == GOODS_TYPE.GOODS_TYPE_4 and template.type2 == GOODS_TYPE2.ResourceItem then
    if DataCenter.StatusManager:IsUseShieldCD() then
      return
    end
    if DataCenter.StatusManager:WarFeverStatu() then
      UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.WAR_FEVER_NO_SHIELD_TIP), 1, GameDialogDefine.CONFIRM)
      return
    elseif SeasonUtil.IsInSeason(true) then
      local loginServerId = LuaEntry.Player:GetSelfServerId()
      local curIndex = LuaEntry.Player:GetMainWorldPos()
      if DataCenter.BirthPointTemplateManager:IsInAllianceCityField(curIndex, loginServerId) then
        UIUtil.ShowTipsId("season_tips107")
        return
      end
      local overTime, blackMode = DataCenter.AllianceSkillManager:GetBlackAreaOverTime(curIndex)
      if 1000 < overTime then
        if blackMode == AlAlertType.MissileFactory then
          UIUtil.ShowTipsId("season_s2_government_skill_tips19")
        else
          UIUtil.ShowTipsId("season_s2_government_skill_tips19")
        end
        return
      end
    end
    local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
    local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
    if 0 < leftTime then
      local statusMeta = LocalController:instance():getLine(TableName.StatusTab, item.para1)
      if leftTime > statusMeta.time * 1000 then
        UIUtil.ShowTipsId(120400)
        return
      end
      UIUtil.ShowMessage(Localization:GetString("120399", statusMeta.time / 3600), 2, "", "", function()
        DataCenter.StatusManager:SetUseShieldCD()
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = item.uuid,
          num = count,
          useItemFromType = 0,
          useBtnPos = useBtnPos
        })
      end, function()
      end)
      return
    end
    DataCenter.StatusManager:SetUseShieldCD()
  end
  if type == GOODS_TYPE.GOODS_TYPE_5 and template.type2 == GOODS_TYPE2.ResourceItem then
    local oneItemContainResourceItemNum = 1
    if not string.IsNullOrEmpty(template.para1) then
      oneItemContainResourceItemNum = toInt(template.para1)
    end
    if DataCenter.ResourceItemDataManager:CheckIsStorageFull(count * oneItemContainResourceItemNum) then
      GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
      return
    end
  end
  if type == GOODS_TYPE.GOODS_TYPE_98 then
    local jigsawCost = HeroUtils.GetJigsawCost(item.itemId)
    if count >= jigsawCost then
      local exchangeCount = count // jigsawCost
      SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, item.para1, 0, 0, tostring(item.itemId), exchangeCount)
    else
      UIUtil.ShowTipsId(GameDialogDefine.GOODNE)
    end
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_99 then
    local itemId = tostring(item.itemId)
    local hasHero = false
    local heroUuid
    local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
    for uuid, v in pairs(allHeroes) do
      local heroFragId = tostring(v:GetHeroFragId())
      if heroFragId and heroFragId == itemId then
        hasHero = true
        heroUuid = uuid
        break
      end
    end
    if hasHero then
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData and heroData:IsHeroAwakenOpen() then
        local typeBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[heroData.heroType])
        local unlockLevel = LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)
        if typeBuilding and unlockLevel <= typeBuilding.level then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHOF, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, heroData.heroType, heroData.uuid)
        else
          GoToUtil.GotoCityByBuildId(HeroTypeBuilding[heroData.heroType], WorldTileBtnType.City_Upgrade)
        end
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, {
          arrowType = HeroDetailGuideArrowType.Rank
        })
      end
    else
      GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      })
    end
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_137 then
    local workerId = tonumber(item.para2) or 0
    local needNum = tonumber(item.para1) or 0
    local targetWorkerData
    local allWorkerData = DataCenter.WorkerDataManager:GetAllWorkerData()
    for k, v in pairs(allWorkerData) do
      if v.cfgId == workerId then
        targetWorkerData = v
        break
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerOverviewList, {anim = true}, {jumpType = 1, jumpParam = workerId})
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_110 and not LuaEntry.Player:IsInAlliance() then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
    return
  end
  if (type == GOODS_TYPE.GOODS_TYPE_5 or type == GOODS_TYPE.GOODS_TYPE_59 or type == GOODS_TYPE.GOODS_TYPE_102 or type == GOODS_TYPE.GOODS_TYPE_107) and template:IsGuarantBox() then
    local para3 = string.split(template.para3, ";")
    local guarantId = tonumber(para3[1])
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGuarantBox, {anim = true}, guarantId, item.itemId)
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_59 and (template.popupType == GOODS_POPUP_TYPE.Hero or template.popupType == GOODS_POPUP_TYPE.Decoration or template.popupType == GOODS_POPUP_TYPE.Dominator) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelectNew, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, item.uuid, count, template)
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_59 or type == GOODS_TYPE.GOODS_TYPE_102 or type == GOODS_TYPE.GOODS_TYPE_107 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelect, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, item.uuid, count, template)
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_113 then
    local function DoUseDecorationItem()
      local skinId = toInt(template.para1)
      
      local index = DataCenter.DecorationTemplateManager:GetItemInDecoraitonIndex(skinId, item.itemId)
      if index then
        local decoTemp = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
        if decoTemp.type == DecorationType.DecorationType_Emoji then
          local isCanChange = true
          local isUnlock = DataCenter.DecorationDataManager:IsUnlock(skinId)
          if isUnlock then
            local eTime = DataCenter.StickerWithDecorationLinkManager:GetExpireTimeByDecoId(skinId)
            if eTime and eTime <= 0 then
              isCanChange = false
            end
          end
          if isCanChange then
            DataCenter.DecorationDataManager:CovertSkin(skinId, index)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationUseChange, {anim = true}, template.id, item.uuid)
          end
        else
          local decoData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
          if decoData and 0 >= decoData.expireTime then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationUseChange, {anim = true}, template.id, item.uuid)
          else
            DataCenter.DecorationDataManager:CovertSkin(skinId, index)
          end
        end
      end
    end
    
    if UIUtil.TryConfirmUseLimitedDecorationItem(item.itemId, DoUseDecorationItem) then
      return
    end
    DoUseDecorationItem()
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_149 then
    local skinId = toInt(template.para1)
    if skinId then
      local decoTemp = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
      if decoTemp and decoTemp.type == DecorationType.DecorationType_Emoji then
        local isUnlock = DataCenter.DecorationDataManager:IsUnlock(skinId)
        if isUnlock then
          local eTime = DataCenter.StickerWithDecorationLinkManager:GetExpireTimeByDecoId(skinId)
          if eTime and eTime <= 0 then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationUseChange, {anim = true}, template.id, item.uuid)
            return
          end
        end
      end
    end
  end
  if type == GOODS_TYPE.GOODS_TYPE_133 then
    local masteryData = DataCenter.MasteryManager:GetData()
    local maxLevel = DataCenter.MasteryManager:GetMaxLevel()
    local condition = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k5")
    local conditionSeason = 4
    local conditionLv = 100
    if not string.IsNullOrEmpty(condition) then
      local list = string.split(condition, "|")
      if 2 <= #list then
        conditionLv = tonumber(list[1])
        conditionSeason = tonumber(list[2])
      end
    end
    if masteryData and (conditionLv > masteryData.level or conditionSeason > SeasonUtil.GetSeason()) and maxLevel <= masteryData.level then
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.OverUseSeasonExpBook, Localization:GetString("season_mastery_193"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = item.uuid,
          num = count,
          useItemFromType = 0,
          useBtnPos = useBtnPos
        })
      end)
      return
    end
  end
  if type == GOODS_TYPE.GOODS_TYPE_134 then
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = item.uuid,
      num = 1,
      useBtnPos = useBtnPos
    })
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_138 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationChoiceBox, {anim = true}, template.id, false, item.uuid)
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_142 then
    GoToUtil.GotoHeroUniqueWepaon(item.para2)
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_191 then
    GoToUtil.GotoHeroAwaken(item.para2)
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_161 then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
    if not canChat then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftShare, {anim = true}, item.itemId)
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_147 or type == GOODS_TYPE.GOODS_TYPE_176 then
    local isInCrossServer = false
    local player = LuaEntry.Player
    if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() then
      isInCrossServer = true
    end
    local isCheckCanCrossServer = UIUtil.CheckDetectCanCrossServer()
    local isInNineNationTruceMode = UIUtil.IsInNineNationTruceMode()
    if isCheckCanCrossServer or not isInCrossServer then
      local message = Localization:GetString("eventitem_use_alert")
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ActDetectTreasureItemUseTip .. item.itemId, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = item.uuid,
          num = count,
          useItemFromType = 0,
          useBtnPos = useBtnPos
        })
      end, function()
      end, nil, nil, false, nil, nil)
    elseif isInNineNationTruceMode then
      if SeasonUtil.IsInLandlordActAndOnCenterServer() then
        UIUtil.ShowTipsId("zonewar_landlord_tips_1012")
        return
      end
      local message = ""
      if not player:IsLoginSourceServer() then
        message = Localization:GetString("eventitem_crossuse_alert")
      elseif not player:IsInSourceServer() then
        message = Localization:GetString("eventitem_use_alert")
      end
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ActDetectTreasureItemUseTip .. item.itemId, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = item.uuid,
          num = count,
          useItemFromType = 0,
          useBtnPos = useBtnPos
        })
      end, function()
      end, nil, nil, false, nil, nil)
    else
      UIUtil.ShowTipsId("activity_sports_uitips_027")
    end
    return
  end
  if item.itemId == SpecialItemId.ITEM_ALLIANCE_CITY_MOVE then
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390536)
    else
      local myAlId = LuaEntry.Player.allianceId
      local hasAlCity = DataCenter.WorldAllianceCityDataManager:CheckIfHasAlCity(myAlId)
      if DataCenter.AllianceBaseDataManager:IsSelfLeader() and not hasAlCity then
        UIUtil.ShowTipsId(390848)
        return
      end
      local selfMarchCount = UIUtil.GetSelfMarchCountExceptGolloes()
      if selfMarchCount > 0 then
        UIUtil.ShowMessage(CS.GameEntry.Localization:GetString(GameDialogDefine.PLEASE_BACK_MARCH), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        end, function()
        end)
        self:CloseSelf()
      else
        SFSNetwork.SendMessage(MsgDefines.WorldAlMove, 0)
        self:CloseSelf()
      end
      return
    end
    return
  elseif item.itemId == "200070" then
    if CS.ActivityController.Instance:IsBetweenActByType(52) then
      local para = CS.UIWelfareCenter.Param()
      para.currentTab = 27
      CS.UIPreAdd.OpenUIWelfareCenter(para)
    else
      UIUtil.ShowTipsId(360215)
    end
    return
  elseif item.itemId == SpecialItemId.ITEM_MOVE_CITY then
    local selfMarchCount = UIUtil.GetSelfMarchCountExceptGolloes()
    if selfMarchCount > 0 then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString(GameDialogDefine.PLEASE_BACK_MARCH), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      end, function()
      end)
      self:CloseSelf()
    else
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      MoveCityUtil.TryShowMoveCityModel(PlaceBuildType.MoveCity_Cmn, mySourceServerId, CS.SceneManager.World.curIndex)
      self:CloseSelf()
    end
    return
  elseif item.itemId == SpecialItemId.ITEM_MOVE_RANDOM or item.itemId == SpecialItemId.LW_ITEM_ALLY_MOVE_CITY then
    if DataCenter.SeasonHunterManager:IsInBattle() then
      UIUtil.ShowTipsId("season_mastery_s4_tips_11")
      return
    end
    local _itemUse
    if item.itemId == SpecialItemId.LW_ITEM_ALLY_MOVE_CITY then
      function _itemUse()
        MoveCityUtil.TryAllianceMoveCity(4, false)
      end
    else
      function _itemUse()
        self:CloseSelf()
        
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = item.uuid,
          num = count,
          useItemFromType = 0,
          useBtnPos = useBtnPos
        })
      end
    end
    local conditions = ConditionChecker.New(_itemUse)
    if item.itemId == SpecialItemId.ITEM_MOVE_RANDOM then
      conditions:Add({
        need = function()
          return DataCenter.ActMeteoriteBattleManager:NeedNoticeRandomMoveCity()
        end,
        checker = function(handle)
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice, {anim = true}, {
            ok = function()
              handle:Next()
            end,
            cancel = function()
              handle:Destroy()
            end,
            notice = "yuntieBattle_interface_1038",
            ignoreKey = SettingKeys.NO_METEORITE_DROP_PROMPT
          })
        end
      })
    end
    if item.itemId == SpecialItemId.LW_ITEM_ALLY_MOVE_CITY then
      conditions:Add({
        need = function()
          return DataCenter.ActMeteoriteBattleManager:NeedNoticeAllianceMoveCityDropMine()
        end,
        checker = function(handle)
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice, {anim = true}, {
            ok = function()
              handle:Next()
            end,
            cancel = function()
              handle:Destroy()
            end,
            notice = "yuntieBattle_interface_1038",
            ignoreKey = SettingKeys.NO_METEORITE_DROP_PROMPT
          })
        end
      })
      conditions:Add({
        need = function()
          return DataCenter.ActMeteoriteBattleManager:NeedNoticeAllianceMoveCityPosition()
        end,
        checker = function(handle)
          UIUtil.TryShowConfirm(TodayNoSecondConfirmType.MeteoriteAllianceAssembly, CS.GameEntry.Localization:GetString("yuntieBattle_tips_1038"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            handle:Next()
          end, function()
            handle:Destroy()
          end, nil, nil, false, nil, nil)
        end
      })
    end
    if DataCenter.LWZombieRushManager:IsChallenging() then
      conditions:Add({
        need = function()
          return true
        end,
        checker = function(handle)
          UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            handle:Next()
          end, function()
            handle:Destroy()
          end)
        end
      })
    elseif LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_VIRUS_MAX_EXPLODE) ~= 0 then
      conditions:Add({
        need = function()
          return true
        end,
        checker = function(handle)
          UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("season_s1_add_virus_tips03"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            handle:Next()
          end, function()
            handle:Destroy()
          end)
        end
      })
    elseif LuaEntry.Effect:HasStatus(SELF_EXPLOSION_STATUS_ID) then
      conditions:Add({
        need = function()
          return true
        end,
        checker = function(handle)
          UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("season_mastery_tips_30"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            handle:Next()
          end, function()
            handle:Destroy()
          end)
        end
      })
    end
    conditions:Next()
    return
  elseif item.itemId == "200021" then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    self:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChangeName, {anim = true})
    return
  elseif item.itemId == "230007" then
    local configOpenState = LuaEntry.DataConfig:CheckSwitch("hero_postershop")
    if configOpenState then
      self:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroResetShop)
    else
      UIUtil.ShowTipsId(390310)
    end
    return
  elseif item.itemId == "710001" then
    SFSNetwork.SendMessage(MsgDefines.SummonLockhartBoss, 0, true)
    return
  elseif item.itemId == "1520001" then
    if DataCenter.LWMyStationDataManager:IsTruckFunctionLock() then
      UIUtil.ShowTipsId("120018")
      return
    end
    if not SeasonUtil.IsInSeasonNineNationMode() and not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and LuaEntry.Player:AtHomeNow() == false then
      UIUtil.ShowTipsId("500020")
      return
    end
    self:CloseSelf()
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_TRUCK_STATION_1)
    if buildData ~= nil then
      SceneUtils.ChangeToCity(function()
        local worldPos = buildData:GetCenterVec()
        GoToUtil.GotoCityPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
          local param = {}
          worldPos.y = worldPos.y + 5
          param.position = CS.CSUtils.WorldPositionToUISpacePosition(worldPos)
          param.arrowType = ArrowType.Building
          param.positionType = PositionType.Screen
          DataCenter.ArrowManager:ShowArrow(param)
        end)
      end)
    end
    return
  elseif item.itemId == "1520002" then
    if LuaEntry.Player:AtHomeNow() == false then
      UIUtil.ShowTipsId("500021")
      return
    end
    self:CloseSelf()
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DISPATCH_TASK)
    if buildData ~= nil then
      SceneUtils.ChangeToCity(function()
        local worldPos = buildData:GetCenterVec()
        GoToUtil.GotoCityPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
          local param = {}
          worldPos.y = worldPos.y + 8
          param.position = CS.CSUtils.WorldPositionToUISpacePosition(worldPos)
          param.position.x = param.position.x + 5
          param.arrowType = ArrowType.Building
          param.positionType = PositionType.Screen
          DataCenter.ArrowManager:ShowArrow(param)
        end)
      end)
    end
    return
  elseif item.itemId == "999901" then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.GiftVoucher)
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_139 then
    if DataCenter.RedPacketManager:GetIsOpen() then
      CloseSelf()
      GoToUtil.OpenChatView(true)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRedPacketBag)
    else
      UIUtil.ShowTips(Localization:GetString(141152, DataCenter.RedPacketManager:GetOpenLevel()))
    end
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_DRAW_BOX then
    local groupId = checknumber(template.para1)
    local drawBoxData = DataCenter.BoxItemDrawManager:GetUserData(groupId)
    if drawBoxData ~= nil then
      if drawBoxData:GetTemplate(drawBoxData:GetCurRound()) == nil then
        UIUtil.ShowTipsId("activity_torch_relay_desc_53")
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBoxItemDraw, {anim = true}, {
          itemId = item.itemId,
          uuid = item.uuid
        })
      end
    end
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_160 then
    local envelopItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k2")
    if item.itemId == tostring(envelopItemId) then
      PostEventLog.Track(PostEventLog.Defines.Vip18InvitationLetterOpen, {source = "backpack"})
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip18Envelop, {anim = false}, {
        itemId = item.itemId,
        uuid = item.uuid,
        otherParam = item.otherParam
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.ThanksLetter, {anim = true}, {
        itemId = item.itemId,
        uuid = item.uuid,
        otherParam = item.otherParam
      })
    end
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_165 then
    local param = {}
    param.sourceType = 3
    param.itemId = item.itemId
    param.itemUuid = item.uuid
    param.otherParam = item.otherParam
    local windowName = UIWindowNames.ValentineShareRank
    if item.goods and not string.IsNullOrEmpty(item.goods.serverPara1) then
      windowName = item.goods.serverPara1
    end
    UIManager:GetInstance():OpenWindow(windowName, {anim = true}, param)
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_166 then
    self:CloseSelf()
    DataCenter.ExplorerTreasureManager:GotoExplorerModel()
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_170 then
    self:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDigTreasure)
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_172 then
    if not TacticalCardUtil.IsFunctionOpen() then
      UIUtil.ShowTipsId("battle_box_not_open")
      return
    end
    TacticalCardUtil.OpenCardBox(item.para1)
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_173 then
    if LuaEntry.Player.world_main_pos < 0 or CrossServerUtil:NeedIntercept() then
      UIUtil.ShowTipsId("activity_concert_68")
      return
    end
    if SceneUtils.CheckCanGotoWorld() then
      SceneUtils.ChangeToWorld(function()
        DataCenter.SkinAndSkillItemManager:RequestUseSkinItem(item.itemId)
      end)
    end
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_179 or item.goods.type == GOODS_TYPE.GOODS_TYPE_185 then
    if not TacticalCardUtil.IsFunctionOpen() then
      UIUtil.ShowTipsId("battle_box_not_open")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITCChoiceBox, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, item.uuid, count, template)
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_182 then
    local seasonId = tonumber(item.para1)
    local param = {}
    param.sourceType = 3
    param.itemId = item.itemId
    param.itemUuid = item.uuid
    param.otherParam = item.otherParam
    param.seasonId = seasonId
    if SeasonUtil.IsInSeason() and SeasonUtil.GetSeason() == seasonId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.BankReport, {anim = true}, true, param)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankDepositInfo, {anim = true}, param)
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_181 then
    local function openUseFlowerTrainUIFunc()
      local isCrossSeason = FlowerTrainUtils.IsCrossSeasonPlaceNow(toInt(item.itemId))
      
      if isCrossSeason then
        UIUtil.ShowMessage(Localization:GetString("treasure_use_alert7_desc"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          local param = {
            itemId = item.itemId,
            isBagUse = true
          }
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIUseFlowerTrain, {anim = true}, param)
        end)
      else
        local param = {
          itemId = item.itemId,
          isBagUse = true
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIUseFlowerTrain, {anim = true}, param)
      end
    end
    
    openUseFlowerTrainUIFunc()
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_183 then
    local statusMeta = LocalController:instance():getLine(TableName.StatusTab, item.para1)
    if statusMeta then
      local timeInfo = DataCenter.StatusManager:GetBuffTimeInfo(statusMeta.id)
      local currentTime = UITimeManager:GetInstance():GetServerTime()
      if timeInfo and currentTime < timeInfo.endTime then
        UIUtil.ShowTipsId("halloween_fireworks_use_alert2")
        return
      end
    end
    
    local function useFunc()
      self:CloseSelf()
      if SceneUtils.CheckCanGotoWorld() then
        SceneUtils.ChangeToWorld(function()
          SFSNetwork.SendMessage(MsgDefines.UseItemFireworks, item.itemId)
        end)
      end
    end
    
    local displayLv = DisplaySettings.GetCurrentDisplayLevel()
    if displayLv < 0 then
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ShowFireworkBagUse, Localization:GetString("use_firework_errortips"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, useFunc, function()
      end, nil, nil, false, nil, nil)
    else
      useFunc()
    end
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_174 then
    local function useFunc()
      DataCenter.LWFireworkManager:SetDefaultFireworkItemId(item.itemId)
      
      self:CloseSelf()
      if SceneUtils.CheckCanGotoWorld() then
        SceneUtils.ChangeToWorld(function()
          TimerManager:GetInstance():DelayInvoke(function()
            local info = CS.SceneManager.World:GetBaseMainInfoByOwnerUid(LuaEntry.Player:GetUid())
            if info then
              DataCenter.LWFireworkManager:SetNeedShowWorldPointGuide(true)
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.City, 1, info.itemId)
            end
          end, 1)
        end)
      end
    end
    
    local isShowFireworkEffect = DisplaySettings.ShowFireworkEffect()
    if not isShowFireworkEffect then
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ShowFireworkBagUse, Localization:GetString("use_firework_errortips"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, useFunc, function()
      end, nil, nil, false, nil, nil)
    else
      useFunc()
    end
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_186 then
    if not DataCenter.LWBiuBiuDataManager:GetResourceLoaded() then
      DataCenter.LWBiuBiuDataManager:ToLoadRes()
      UIUtil.ShowTipsId("season_s5_activity_1200045_desc34")
      return
    end
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    if not room:HasPvp() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuCreateRoom, {anim = true}, 1, {
        uuid = item.uuid,
        num = 1,
        useBtnPos = useBtnPos,
        betid = item.itemId
      })
    elseif room:GetState() == LittleGameRoomState.FightIng then
      DataCenter.LWBiuBiuManager:ReConnectPvp()
    else
      UIUtil.ShowTipsId("season_s5_activity_1200045_desc67")
    end
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_187 then
    DataCenter.CarpetManager:UseCarpetItem(item.itemId)
    return
  elseif item.goods.type == GOODS_TYPE.GOODS_TYPE_101 then
    local firstPayExpData = DataCenter.FirstPayManager.buildExpData
    if not firstPayExpData then
      return
    end
    local stashExp = 0
    stashExp = firstPayExpData:GetCurRemainStashExp() or 0
    if stashExp > 0 then
      local isFull = firstPayExpData:IsExpPoolMax()
      local str = Localization:GetString(isFull and "fp_desc4" or "fp_desc1", stashExp)
      UIUtil.ShowMessage(str, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.FirstRechargeReward)
      end, nil)
    else
      UIUtil.ShowTipsId("fp_tips_3")
    end
    return
  end
  local useItemFromType = 0
  if type == 3 and (template.type2 == ResourceType.Metal or template.type2 == ResourceType.Water or template.type2 == ResourceType.Electricity or template.type2 == ResourceType.Food) then
    useItemFromType = 1
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = item.uuid,
    num = count,
    useItemFromType = useItemFromType,
    useBtnPos = useBtnPos
  })
end

local function equipSortFunc(lValue, rValue)
  if lValue.config.quality ~= rValue.config.quality then
    return lValue.config.quality > rValue.config.quality
  elseif lValue.config.slot ~= rValue.config.slot then
    return lValue.config.slot < rValue.config.slot
  elseif lValue.config.heroType ~= rValue.config.heroType then
    return lValue.config.heroType > rValue.config.heroType
  elseif lValue.config.id ~= rValue.config.id then
    return lValue.config.id < rValue.config.id
  else
    return lValue.level > rValue.level
  end
end

local function SquadEquipSortFunc(lValue, rValue)
  local leftCofigQuality = lValue:GetConfigQuality()
  local rightCofigQuality = rValue:GetConfigQuality()
  if leftCofigQuality ~= rightCofigQuality then
    return leftCofigQuality > rightCofigQuality
  else
    local leftSlot = lValue:GetConfigSlot()
    local rightSlot = rValue:GetConfigSlot()
    if leftSlot ~= rightSlot then
      return leftSlot < rightSlot
    else
      local leftLevel = lValue:GetConfigLevel()
      local rightLevel = rValue:GetConfigLevel()
      if leftLevel ~= rightLevel then
        return leftLevel > rightLevel
      else
        local leftPower = lValue:GetPower()
        local rightPower = rValue:GetPower()
        if leftPower ~= rightPower then
          return leftPower > rightPower
        else
          local leftId = lValue.cfgId
          local rightId = rValue.cfgId
          if leftId ~= rightId then
            return leftId < rightId
          else
            local ownerUid = lValue.ownerUid
            local ownerUid2 = rValue.ownerUid
            if lValue:GetConfigType() == CommonEquipType.SquadEquip then
              local build1 = DataCenter.BuildManager:GetBuildingDataByUuid(ownerUid)
              local build2 = DataCenter.BuildManager:GetBuildingDataByUuid(ownerUid2)
              if build1 ~= nil and build2 ~= nil and build1 ~= build2 then
                local build1ItemId = build1.itemId
                local build2ItemId = build2.itemId
                if build1ItemId ~= build2ItemId then
                  return build1ItemId < build2ItemId
                else
                  return lValue.uuid < rValue.uuid
                end
              else
                return lValue.uuid < rValue.uuid
              end
            else
              return lValue.uuid < rValue.uuid
            end
          end
        end
      end
    end
  end
end

local function GetEquipItemList(self)
  local allEquips = DataCenter.EquipDataManager:GetAllEquipList()
  local equiped_list = {}
  local unequiped_list = {}
  table.walk(allEquips, function(k, v)
    local equiped = v.heroUuid and v.heroUuid > 0
    if equiped then
      table.insert(equiped_list, v)
    else
      table.insert(unequiped_list, v)
    end
  end)
  table.sort(equiped_list, equipSortFunc)
  table.sort(unequiped_list, equipSortFunc)
  local typeMap = {}
  local result = {}
  table.walk(equiped_list, function(k, v)
    table.insert(result, v)
    table.insert(typeMap, BagItemType.HeroEquip)
  end)
  table.walk(unequiped_list, function(k, v)
    table.insert(result, v)
    table.insert(typeMap, BagItemType.HeroEquip)
  end)
  local allSquadEquips = DataCenter.CommonEquipDataManager:GetAllEquipsByType(CommonEquipType.SquadEquip)
  equiped_list = {}
  unequiped_list = {}
  table.walk(allSquadEquips, function(k, v)
    local equiped = v:IsBeingWeared()
    if equiped then
      table.insert(equiped_list, v)
    else
      table.insert(unequiped_list, v)
    end
  end)
  table.sort(equiped_list, SquadEquipSortFunc)
  table.sort(unequiped_list, SquadEquipSortFunc)
  table.walk(equiped_list, function(k, v)
    table.insert(result, v)
    table.insert(typeMap, BagItemType.CommonEquip)
  end)
  table.walk(unequiped_list, function(k, v)
    table.insert(result, v)
    table.insert(typeMap, BagItemType.CommonEquip)
  end)
  table.walk(result, function(k, v)
    v.isEquip = true
  end)
  return result, typeMap
end

local function TryConvertExpireItems(self)
  local hasExpiredItem = DataCenter.ItemData:HasExpiredItem()
  if hasExpiredItem and not self.sendConvertItems then
    SFSNetwork.SendMessage(MsgDefines.ExpiredItemConvert)
    self.sendConvertItems = true
  end
end

UILWBagMainCtrl.CloseSelf = CloseSelf
UILWBagMainCtrl.GetItemListByType = GetItemListByType
UILWBagMainCtrl.GetItemDataByItemId = GetItemDataByItemId
UILWBagMainCtrl.OnItemUse = OnItemUse
UILWBagMainCtrl.GetEquipItemList = GetEquipItemList
UILWBagMainCtrl.TryConvertExpireItems = TryConvertExpireItems
return UILWBagMainCtrl
