local LWUIGoodsLackView = require("UI.LWResourceLack.Goods.View.LWUIGoodsLackView")
local LWResourceLackUtil = {}
local OutTime = 600000

function LWResourceLackUtil:GotoGoodsItemLack(id, need, autoExitWhenComplete, closeCallback)
  local data = {}
  data.type = ResLackContextType.Good
  data.id = id
  data.need = need
  data.autoExitWhenComplete = true
  data.closeCallback = closeCallback
  if autoExitWhenComplete ~= nil then
    data.autoExitWhenComplete = autoExitWhenComplete
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGoodsLack, {anim = true}, data)
end

function LWResourceLackUtil:GotoResourceItemLack(id, need)
  local data = {}
  data.type = ResLackContextType.ResItem
  data.id = id
  data.need = need
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGoodsLack, {anim = true}, data)
end

function LWResourceLackUtil:GotoResourceItemLackWithAutoExit(id, need, autoExitWhenComplete)
  local data = {}
  data.type = ResLackContextType.ResItem
  data.id = id
  data.need = need
  data.autoExitWhenComplete = autoExitWhenComplete
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGoodsLack, {anim = true}, data)
end

function LWResourceLackUtil:GotoResLack(data)
  if not data then
    return
  end
  if data then
    for i, v in pairs(data) do
      v.type = ResLackContextType.Resource
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceLack, {anim = true}, data)
end

function LWResourceLackUtil:GotoSpecialResLack(type, need, fromClickMainUI, closeCallBack)
  local data = {}
  data.type = type
  if type == ResLackContextType.Energy then
    local cur = LuaEntry.Player:GetCurStamina()
    local full = 100
    local config = DataCenter.ArmyFormationDataManager:GetConfigData()
    if config ~= nil then
      full = config.FormationStaminaMax
    end
    data.resType = ResourceType.FORMATION_STAMINA
    data.need = math.max(1, full - cur)
    data.fromClickMainUI = fromClickMainUI
    data.closeCallBack = closeCallBack
  else
    data.need = need or math.maxinteger
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSpecialResLack, {anim = true}, data)
end

function LWResourceLackUtil:GotoSpecialResLackTacticalChip(type, need, chipId)
  local data = {}
  data.type = type
  data.need = need or math.maxinteger
  data.chipId = chipId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSpecialResLack, {anim = true}, data)
end

function LWResourceLackUtil:GotoTacticalCardLack(cardId, need)
  local data = {}
  data.type = ResLackContextType.TacticalCard
  data.need = need or math.maxinteger
  data.cardId = cardId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSpecialResLack, {anim = true}, data)
end

function LWResourceLackUtil:FilterResourceTemplates(templates, need, param, goodsId)
  local dataList = {}
  local fullback_template
  local mainLv = DataCenter.BuildManager.MainLv
  for k, v in pairs(templates) do
    local t = v
    if t.minLevel < t.maxLevel and (mainLv > t.maxLevel or mainLv < t.minLevel) then
      if mainLv < t.minLevel and (fullback_template == nil or fullback_template.cacheLevel > t.minLevel - mainLv) then
        fullback_template = t
        fullback_template.cacheLevel = t.minLevel - mainLv
      end
    else
      if not string.IsNullOrEmpty(t.needHero) then
        local hero_uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(t.needHero)
      end
      if not string.IsNullOrEmpty(hero_uuid) and TimeConditionUtils.CheckTimeConditionsByStr(t.show_condition) then
        if t.tips == LWResourceLackGetWay.UseItem then
          local items = DataCenter.ItemData:GetItemById(t.para1)
          local itemCount = items and items.count or 0
          if itemCount == 0 then
            goto lbl_1547
          end
          if param and param.type == ResLackContextType.TWSkillChip and items and items.goods and items.goods.type == GOODS_TYPE.GOODS_TYPE_59 then
            local chipId = param.chipId
            local isFindChip = false
            if chipId then
              local chipPairList = string.split(items.para1, "|")
              for i, itemIdDara in ipairs(chipPairList) do
                local strList = string.split(itemIdDara, ",")
                local itemId = tonumber(strList[1])
                local itemConfig = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
                if itemConfig and chipId == itemConfig.linked_item_id then
                  isFindChip = true
                  break
                end
              end
              if not isFindChip then
                goto lbl_1547
              end
            end
          end
        end
        if t.tips == LWResourceLackGetWay.ClaimFreeStamina then
          local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.ClaimFreeStamina)
        end
        if unlock and (t.tips ~= LWResourceLackGetWay.Gather and t.tips ~= LWResourceLackGetWay.WorldMonster and t.tips ~= LWResourceLackGetWay.WorldCollection or not LuaEntry.Player:IsFirstJoinAlliance()) then
          if t.tips == LWResourceLackGetWay.QuestReward then
            local state = 0
            local infos
            if DataCenter.ChapterTaskManager:IsCompleteAllChapter() then
              infos = DataCenter.TaskManager:GetOneMainTaskForMainUI()
            else
              infos = DataCenter.ChapterTaskManager:GetFirstChapterTask()
            end
            if infos then
              local isChapter = infos.isChapter
              if isChapter then
                local taskState = infos.state
                local allNum = DataCenter.ChapterTaskManager:GetAllNum()
                local completeNum = DataCenter.ChapterTaskManager:GetCompleteNum()
                if allNum <= completeNum and taskState == "0" then
                  state = 3
                end
              else
                local taskinfos = DataCenter.ChapterTaskManager:GetTaskInfos(infos)
                state = taskinfos.is_finish and 2 or 1
              end
            end
            if state == 0 or state == 1 then
              goto lbl_1547
            end
          end
          if t.tips == LWResourceLackGetWay.DiamondStore then
            local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.Goods, tonumber(t.para1))
            if not goodsConf then
              goto lbl_1547
            end
          end
          if t.tips == LWResourceLackGetWay.Recruit and t.para1 then
            local recruitIDList = string.split(tostring(t.para1), ";")
            local curIDList = DataCenter.LotteryDataManager.curRecruitIdList
            local isInList = false
            for k, v in pairs(curIDList) do
              if table.hasvalue(recruitIDList, tostring(v)) then
                isInList = true
                break
              end
            end
            if not isInList then
              goto lbl_1547
            end
          end
          if t.tips == LWResourceLackGetWay.Promote then
            local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
            if table.IsNullOrEmpty(buildList) then
              goto lbl_1547
            end
          end
          if t.tips == LWResourceLackGetWay.OpenBuyDiamondViewWeekCard then
            local functionUnlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Daily_Quest)
            if not functionUnlock then
              goto lbl_1547
            end
            local weekcardId = tonumber(t.para1)
            local weekCardData = DataCenter.WeekCardManager:GetWeekCardDataById(weekcardId)
            if not weekCardData or weekCardData:IsRenewWeekCountLimited() then
              goto lbl_1547
            end
          end
          if t.tips == LWResourceLackGetWay.AllianceShop then
            if param and not table.IsNullOrEmpty(param.skipFilterTypeList) and self:IsTypeSkipFilter(t.tips, param.skipFilterTypeList) then
              if not self:ExistAnyShopGoods(t, CommonShopType.AllianceShop) then
                goto lbl_1547
              end
            else
              local hasAnyShopCanBuy = self:HasAnyShopCanBuy(t, CommonShopType.AllianceShop)
              if not hasAnyShopCanBuy then
                goto lbl_1547
              end
            end
          end
          if t.tips == LWResourceLackGetWay.VIPShop then
            if param and not table.IsNullOrEmpty(param.skipFilterTypeList) and self:IsTypeSkipFilter(t.tips, param.skipFilterTypeList) then
              if not self:ExistAnyShopGoods(t, CommonShopType.Vip) then
                goto lbl_1547
              end
            else
              local hasAnyShopCanBuy = self:HasAnyShopCanBuy(t, CommonShopType.Vip)
              if not hasAnyShopCanBuy then
                goto lbl_1547
              end
            end
          end
          if t.tips == LWResourceLackGetWay.TrailTowerShop then
            do
              local shopId = tonumber(t.para1)
              local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.TrailTowerShop, shopId)
              if goodsConf then
                do
                  local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.TrailTowerShop, shopId)
                  local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
                  if 0 < goodsConf.maxTimes and boughtTimes >= goodsConf.maxTimes then
                    goto lbl_429
                  end
                end
                goto lbl_430
              end
              ::lbl_429::
            end
          else
            ::lbl_430::
            if t.tips == LWResourceLackGetWay.GoCommonShop then
              if param and not table.IsNullOrEmpty(param.skipFilterTypeList) and self:IsTypeSkipFilter(t.tips, param.skipFilterTypeList) then
                if not self:ExistAnyShopGoods_GoCommonShop(t) then
                  goto lbl_1547
                end
              else
                local hasAnyShopCanBuy = self:HasAnyShopCanBuy_GoCommonShop(t)
                if not hasAnyShopCanBuy then
                  goto lbl_1547
                end
              end
            end
            if t.tips == LWResourceLackGetWay.Activity and t.para1 and t.para1 ~= "cross_king" then
              local idList = string.split(tostring(t.para1), "|")
              local isOneActivityOpen = false
              for _, v in ipairs(idList) do
                local actId = tonumber(v)
                local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
                if actInfo then
                  if actInfo.type == EnumActivity.InfiniteGift.Type then
                    local active = DataCenter.ActInfiniteGiftDataManager:IsActAcitve(actId)
                    if active then
                      isOneActivityOpen = true
                    end
                  else
                    isOneActivityOpen = true
                  end
                end
              end
              if not isOneActivityOpen then
                goto lbl_1547
              end
            end
            if t.tips == LWResourceLackGetWay.GiftPackage then
              local groups = string.split(t.para1, "|")
              local hasGiftPack = false
              for i = 1, #groups do
                local packs = GiftPackManager.GetPacksByGroupId(groups[i], false)
                packs = GiftPackManager.FilterVipPacksExclude(packs, VipPayGoodState.HasGet, true)
                hasGiftPack = packs and 0 < #packs
                if hasGiftPack then
                  break
                end
              end
              if not hasGiftPack then
                goto lbl_1547
              end
            end
            if t.tips == LWResourceLackGetWay.Stage then
            end
            if t.tips == LWResourceLackGetWay.DailyBuy or t.tips == LWResourceLackGetWay.WeeklyBuy then
              local giftPackageInfo = GiftPackageData.GetPacksByGroupId(tonumber(t.para1), false)
              if giftPackageInfo == nil or #giftPackageInfo == 0 then
                goto lbl_1547
              end
            end
            if t.tips == LWResourceLackGetWay.HeroMonthCard then
              local needMonthCardId = tonumber(t.para1)
              local cardData = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(needMonthCardId)
              local template
              if cardData ~= nil then
                template = DataCenter.HeroMonthCardManager:GetTemplate(cardData.activityId)
              end
              if template == nil then
                goto lbl_1547
              end
            end
            if t.tips == LWResourceLackGetWay.Radar then
              local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_DetectBtn)
              if not unlock then
                goto lbl_1547
              end
            end
            if t.tips == LWResourceLackGetWay.ActivityShop then
              local para1 = t.para1
              if string.IsNullOrEmpty(para1) then
                goto lbl_1547
              end
              local spl = string.split(para1, "|")
              if not spl or #spl < 2 then
                goto lbl_1547
              end
              local actId = tonumber(spl[1])
              local actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
              if not actData then
                goto lbl_1547
              end
              local hasFreeReward = DataCenter.ActivityListDataManager:GetActHasFreeDailyReward(actId)
              if not hasFreeReward then
                local packGroupId = tonumber(spl[2])
                local packs = GiftPackManager.GetPacksByGroupId(packGroupId, false)
                if table.IsNullOrEmpty(packs) then
                  goto lbl_1547
                end
              end
            end
            if t.tips == LWResourceLackGetWay.GiftPackageList then
              if string.IsNullOrEmpty(t.para1) then
                goto lbl_1547
              end
              local spl = string.split(t.para1, "|") or {}
              if #spl == 0 then
                goto lbl_1547
              end
              local hasPack = false
              for i = 1, #spl do
                local giftPack = GiftPackManager.get(spl[i])
                if giftPack and 0 < giftPack:getCountdown() and giftPack:canGet() then
                  hasPack = true
                  break
                end
              end
            end
            if hasPack and (t.tips ~= LWResourceLackGetWay.SaveGirl or DataCenter.LWSaveGirlManager:IsShowBubble()) and (not (t.tips == LWResourceLackGetWay.GoSeasonMain and t.para1) or SeasonUtil.IsInSeason()) then
              if t.tips == LWResourceLackGetWay.ChooseUseItem then
                if string.IsNullOrEmpty(t.para1) then
                  goto lbl_1547
                end
                local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(tonumber(t.para1))
                if not (goodsTemplate and goodsTemplate:IsSelectBox()) then
                  goto lbl_1547
                end
              end
              if t.tips == LWResourceLackGetWay.VIPGiftPackage then
                local giftPackId = DataCenter.VIPManager:GetVipPackContainsItem(t.res, t.goods, t.res_item)
              end
              if giftPackId and (t.tips ~= LWResourceLackGetWay.ActivityAndCheckOpen and t.tips ~= LWResourceLackGetWay.GoToActivityAndDontCloseSelf or param and not table.IsNullOrEmpty(param.skipFilterTypeList) and self:IsTypeSkipFilter(t.tips, param.skipFilterTypeList) and t.para3 == "1" or LWResourceLackUtil:IsShowActivityLack(t)) then
                if (t.tips == LWResourceLackGetWay.Activity or t.tips == LWResourceLackGetWay.ActivityAndCheckOpen) and not string.IsNullOrEmpty(t.para1) and not string.IsNullOrEmpty(t.para2) then
                  local idList = string.split(tostring(t.para1), "|")
                  local isExistDecoCachaAct = false
                  local isFindTargetDeco = false
                  for _, v in ipairs(idList) do
                    local actId = tonumber(v)
                    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
                    if actInfo.type == EnumActivity.DecorationGacha.Type then
                      isExistDecoCachaAct = true
                      if param and param.decoBuildingUuid then
                        local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(param.decoBuildingUuid)
                        if not buildingData then
                          goto lbl_1547
                        end
                        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingData.itemId, 1)
                        local productDecoStrList = string.split(t.para2, ";")
                        for _, v in ipairs(productDecoStrList) do
                          local decoId = toInt(v)
                          if decoId == buildTemplate.id then
                            isFindTargetDeco = true
                            break
                          end
                        end
                      end
                    end
                  end
                  if not (not isExistDecoCachaAct or isFindTargetDeco) then
                    goto lbl_1547
                  end
                end
                if t.tips == LWResourceLackGetWay.ZombieBattle then
                  if not DataCenter.StageManager.stageId then
                    goto lbl_1547
                  end
                  local stageMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), DataCenter.StageManager.stageId)
                end
                if stageMeta and (t.tips ~= LWResourceLackGetWay.GoToDesertCollect or BattleFieldUtil.InBattleField(BattleFieldType.Desert)) then
                  if t.tips == LWResourceLackGetWay.CityCollection then
                    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(t.para1))
                    if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
                      goto lbl_1547
                    end
                  end
                  if t.tips == LWResourceLackGetWay.DecoChipExchange and param and param.decoBuildingUuid then
                    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(param.decoBuildingUuid)
                    if not buildingData then
                      goto lbl_1547
                    end
                    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingData.itemId, 1)
                    if not buildTemplate or 0 >= buildTemplate.convert_decorator_num then
                      goto lbl_1547
                    end
                  end
                  if t.tips == LWResourceLackGetWay.DecoSelfSelectItem and param and param.decoBuildingUuid then
                    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(param.decoBuildingUuid)
                    if not buildingData then
                      goto lbl_1547
                    end
                    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingData.itemId, 1)
                    if not buildTemplate or string.IsNullOrEmpty(buildTemplate.para4) then
                      goto lbl_1547
                    end
                    local targetId = toInt(buildTemplate.para4)
                    local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(tonumber(t.para1))
                    if not goodsTemplate then
                      goto lbl_1547
                    end
                    local haveCount = DataCenter.ItemData:GetItemCount(tonumber(t.para1))
                    if haveCount <= 0 then
                      goto lbl_1547
                    end
                    local isFind = false
                    if goodsTemplate.type == GOODS_TYPE.GOODS_TYPE_59 then
                      local List = string.split(goodsTemplate.para1, "|")
                      for _, v in ipairs(List) do
                        local str = string.split(v, ",")
                        local buildingId = toInt(str[1])
                        if buildingId == targetId then
                          isFind = true
                          break
                        end
                      end
                    end
                    if not isFind then
                      goto lbl_1547
                    end
                  end
                  if t.tips == LWResourceLackGetWay.HonorShopNew then
                    if param and not table.IsNullOrEmpty(param.skipFilterTypeList) and self:IsTypeSkipFilter(t.tips, param.skipFilterTypeList) then
                      if not self:ExistAnyShopGoods(t, CommonShopType.HonorShop) then
                        goto lbl_1547
                      end
                    else
                      local hasAnyShopCanBuy = self:HasAnyShopCanBuy(t, CommonShopType.HonorShop)
                      if not hasAnyShopCanBuy then
                        goto lbl_1547
                      end
                    end
                  end
                  if t.tips == LWResourceLackGetWay.GotoEmptyActivity then
                    local showAnyActivity = false
                    local idList = string.split(tostring(t.para1), "|")
                    for _, lackId in ipairs(idList) do
                      local lackTemplate = DataCenter.LWResourceLackManager:GetTemplateById(tonumber(lackId))
                      if lackTemplate and LWResourceLackUtil:IsShowActivityLack(lackTemplate) then
                        showAnyActivity = true
                        break
                      end
                    end
                    if showAnyActivity then
                      goto lbl_1547
                    end
                  end
                  if t.tips == LWResourceLackGetWay.GiftShopSell then
                    local sellDict = DataCenter.GiftSystemManager:GetGiftShopSellDict()
                    local isSell = false
                    if goodsId then
                      isSell = sellDict[tostring(goodsId)]
                    end
                    if not isSell then
                      goto lbl_1547
                    end
                  end
                  if t.tips == LWResourceLackGetWay.GiftShopNotSell then
                    local sellDict = DataCenter.GiftSystemManager:GetGiftShopSellDict()
                    local isSell = false
                    if goodsId then
                      isSell = sellDict[tostring(goodsId)]
                    end
                    if isSell then
                      goto lbl_1547
                    end
                  end
                  if t.tips == LWResourceLackGetWay.GoSeasonActivityEmpty then
                    local act_type = t.para1
                    local actId
                    if SeasonUtil.IsInSeason() then
                      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(act_type)
                      if actList and 0 < #actList then
                        for index, value in ipairs(actList) do
                          if value.forSeason then
                            actId = value.id
                            break
                          end
                        end
                      end
                    end
                  end
                  if not actId and (t.tips ~= LWResourceLackGetWay.ResourceList or param and param.isShowInResourceList == true) then
                    goto lbl_1231
                    goto lbl_1547
                    ::lbl_1231::
                    if t.tips == LWResourceLackGetWay.GoToAdList then
                      local data = DataCenter.MaxAdManager:GetAdCollectionById(t.para1)
                      local isShow = false
                      if data.template.times and data.serverData.rewardTimes then
                        isShow = data.template.times > data.serverData.rewardTimes
                      end
                      if not isShow then
                        goto lbl_1547
                      end
                    end
                    if t.tips == LWResourceLackGetWay.GoToSeasonTower then
                      if not DataCenter.LWSeasonTowerManager:IsShowEntrance() then
                        goto lbl_1547
                      end
                      local groupId = DataCenter.LWSeasonTowerManager:GetCurrentGroupId()
                      if groupId <= 0 then
                        goto lbl_1547
                      end
                      groupId = tostring(groupId)
                      local isFound = false
                      local groupIdArr = string.split(t.para1, "|")
                      for _, groupIdTmp in ipairs(groupIdArr) do
                        if groupIdTmp == groupId then
                          isFound = true
                          break
                        end
                      end
                      if not isFound then
                        goto lbl_1547
                      end
                    end
                    if t.tips == LWResourceLackGetWay.BountyHunterOpenHistoryView then
                      local isShow = false
                      local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActBountyHunter.Type)
                      if activityData then
                        local actData = DataCenter.BountyHunterActDataManager:GetActData(tonumber(activityData.activityId))
                        if actData then
                          local canClaimRewardDataList = actData:GetCurStashRewardData()
                          if 0 < #canClaimRewardDataList then
                            isShow = true
                          end
                        end
                      end
                      if not isShow then
                        goto lbl_1547
                      end
                    end
                    if t.tips == LWResourceLackGetWay.GoBirthdaySetView then
                      local isBirthdayFuncOpne = DataCenter.BirthdayDataManager:GetIsSelfBirthdayFuncOpen()
                    end
                    if isBirthdayFuncOpne and (t.tips ~= LWResourceLackGetWay.GoGiftPrivilegeView or IsGiftSystemOpen) then
                      if t.tips == LWResourceLackGetWay.OpenAllyDuelTodayGacha or t.tips == LWResourceLackGetWay.OpenAllyDuelRewardView then
                        local isUnlock = DataCenter.AllianceCompeteDataManager:CheckIfAllianceCompeteOpen()
                        local gachaSwitch = LuaEntry.DataConfig:CheckSwitch("alliance_duel_zhuanpan")
                        if not (isUnlock and gachaSwitch) then
                          goto lbl_1547
                        end
                      end
                      if t.tips == LWResourceLackGetWay.TacticalChipFactory then
                        local chipId = param.chipId
                        local chipTemplate = DataCenter.TacticalChipFactoryManager:GetChipTemplate(chipId)
                        if not chipTemplate then
                          goto lbl_1547
                        end
                        local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
                        if buildList and buildList[1] ~= nil then
                          local curBuildingLv = buildList[1].level
                          if curBuildingLv >= chipTemplate.craft_factory_level then
                            local costItemId = chipTemplate.craft_material[1]
                            local costItemNum = chipTemplate.craft_material[2]
                            local itemInfo = DataCenter.ItemData:GetItemById(costItemId)
                            local ownItemNum = 0
                            if itemInfo then
                              ownItemNum = itemInfo.count or 0
                            end
                            if costItemNum > ownItemNum then
                              goto lbl_1547
                            end
                          end
                        end
                      end
                      if t.tips == LWResourceLackGetWay.GotoWorldBossTask then
                        if not LWResourceLackUtil:IsShowActivityLack(t) then
                          goto lbl_1547
                        end
                        if not string.IsNullOrEmpty(t.para2) then
                          local isClaimedAllTask = true
                          local splitPara2 = string.split(t.para2, "|")
                          for _, idStr in ipairs(splitPara2) do
                            local taskId = tonumber(idStr)
                            if taskId then
                              local taskInfo = DataCenter.ActBossDataManager:GetAchievementTaskData(taskId)
                              if taskInfo and taskInfo.state ~= 2 then
                                isClaimedAllTask = false
                                break
                              end
                            end
                          end
                          if isClaimedAllTask then
                            goto lbl_1547
                          end
                        end
                      end
                      if t.tips == LWResourceLackGetWay.MultiUseItem then
                        local isHaveItem = false
                        if not string.IsNullOrEmpty(t.para1) then
                          local itemIdList = string.split(t.para1, "|")
                          for _, itemIdStr in ipairs(itemIdList) do
                            local itemInfo = DataCenter.ItemData:GetItemById(itemIdStr)
                            if itemInfo then
                              local itemCount = itemInfo and itemInfo.count or 0
                              if 0 < itemCount then
                                isHaveItem = true
                                break
                              end
                            end
                          end
                        end
                        if not isHaveItem then
                          goto lbl_1547
                        end
                      end
                      if t.tips == LWResourceLackGetWay.OpenHeroTryOutTask then
                        local tagId = checknumber(t.para1)
                        local tagTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTagTemplateById(tagId)
                        if not (not tagTemplate or DataCenter.HeroTryOutManager:IsShowHeroTryOutEntrance(tagTemplate.hero_id)) then
                          goto lbl_1547
                        end
                      end
                      if t.needCalcOrder then
                        local order = self:CalcOrder(t, need)
                        if order == 0 then
                          goto lbl_1547
                        end
                        t.order = order
                      end
                      table.insert(dataList, t)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    ::lbl_1547::
  end
  local showDataDict = {}
  for i, v in ipairs(dataList) do
    showDataDict[v.id] = true
  end
  for i = #dataList, 1, -1 do
    local data = dataList[i]
    if data.tips == LWResourceLackGetWay.LackTypeMutal and 0 < data.mutal_lack_tips and showDataDict[data.mutal_lack_tips] then
      table.remove(dataList, i)
    end
  end
  if #dataList == 0 and fullback_template then
    table.insert(dataList, fullback_template)
  end
  return dataList
end

function LWResourceLackUtil:ExistAnyShopGoods(t, shopType)
  local shopIdList = {}
  local paraSplitList = string.split(t.para1, "|")
  for _, str in ipairs(paraSplitList) do
    table.insert(shopIdList, tonumber(str))
  end
  for _, shopId in ipairs(shopIdList) do
    local hasGoods = self:HasShopGoods(shopType, shopId)
    if hasGoods then
      return true
    end
  end
  return false
end

function LWResourceLackUtil:ExistAnyShopGoods_GoCommonShop(t)
  local paramList = string.split(t.para1, ";")
  for _, paramStr in ipairs(paramList) do
    local paramStrList = string.split(paramStr, "|")
    if #paramStrList == 2 then
      local shopType = tonumber(paramStrList[1])
      local shopId = tonumber(paramStrList[2])
      local hasGoods = self:HasShopGoods(shopType, shopId)
      if hasGoods then
        return true
      end
    end
  end
  return false
end

function LWResourceLackUtil:HasShopGoods(shopType, shopId)
  local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(shopType, shopId)
  return goodsConf ~= nil, goodsConf
end

function LWResourceLackUtil:HasAnyShopCanBuy(t, shopType)
  local shopIdList = {}
  local paraSplitList = string.split(t.para1, "|")
  for _, str in ipairs(paraSplitList) do
    table.insert(shopIdList, tonumber(str))
  end
  local hasAnyShopCanBuy = false
  for _, shopId in ipairs(shopIdList) do
    local hasGoods, goodsConf = self:HasShopGoods(shopType, shopId)
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(shopType, shopId)
    if hasGoods then
      local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
      if 0 >= goodsConf.maxTimes or boughtTimes < goodsConf.maxTimes then
        local isConditionOk = true
        if goodsConf.GetInconsistentConditions then
          local inconsistentConditions = goodsConf:GetInconsistentConditions()
          if table.IsNullOrEmpty(inconsistentConditions) then
            isConditionOk = true
          end
        end
        if isConditionOk then
          hasAnyShopCanBuy = true
          break
        end
      end
    end
  end
  return hasAnyShopCanBuy
end

function LWResourceLackUtil:HasAnyShopCanBuy_GoCommonShop(t)
  local hasAnyShopCanBuy = false
  local paramList = string.split(t.para1, ";")
  for _, paramStr in ipairs(paramList) do
    local paramStrList = string.split(paramStr, "|")
    if #paramStrList == 2 then
      local shopType = tonumber(paramStrList[1])
      local shopId = tonumber(paramStrList[2])
      local hasGoods, goodsConf = self:HasShopGoods(shopType, shopId)
      local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(shopType, shopId)
      if hasGoods then
        local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
        if 0 >= goodsConf.maxTimes or boughtTimes < goodsConf.maxTimes then
          local isConditionOk = true
          if goodsConf.GetInconsistentConditions then
            local inconsistentConditions = goodsConf:GetInconsistentConditions()
            if table.IsNullOrEmpty(inconsistentConditions) then
              isConditionOk = true
            end
          end
          if isConditionOk then
            hasAnyShopCanBuy = true
            break
          end
        end
      end
    end
  end
  return hasAnyShopCanBuy
end

function LWResourceLackUtil:SortShowDataList(dataList)
  if table.IsNullOrEmpty(dataList) then
    return dataList
  end
  
  local function IsCountdownState(lackData)
    if lackData.tips == LWResourceLackGetWay.Promote then
      return DataCenter.RadarCenterDataManager:GetUnFinishedDetectEventNum() == 0
    end
    if lackData.tips == LWResourceLackGetWay.PersonalArms then
      return DataCenter.ActivityPersonalArmsDataManager:IsAllBoxRewardReceivedByType(EnumActivity.PersonalArmsNew.Type)
    end
    return false
  end
  
  local function IsCompletedState(lackData)
    if lackData.tips == LWResourceLackGetWay.SecretTask then
      return DataCenter.ActDispatchTaskDataManager:IsAllSingleTaskDispatched()
    end
    if lackData.tips == LWResourceLackGetWay.TruckStation then
      return DataCenter.LWMyStationDataManager:IsAllTruckDispatchedAndRobUsedUp()
    end
    if lackData.tips == LWResourceLackGetWay.DailyTask then
      return DataCenter.DailyTaskManager:IsAllBoxRewardReceived()
    end
    if lackData.tips == LWResourceLackGetWay.AllyDuel then
      return DataCenter.AllianceCompeteDataManager:IsAll9BoxRewardReceived()
    end
    return false
  end
  
  local function IsSoldOutState(lackData)
    if lackData.goods == 200002 then
      return false
    end
    if lackData.tips == LWResourceLackGetWay.AllianceShop then
      return not LWResourceLackUtil:HasAnyShopCanBuy(lackData, CommonShopType.AllianceShop)
    end
    if lackData.tips == LWResourceLackGetWay.VIPShop then
      return not LWResourceLackUtil:HasAnyShopCanBuy(lackData, CommonShopType.Vip)
    end
    if lackData.tips == LWResourceLackGetWay.GoCommonShop then
      return not LWResourceLackUtil:HasAnyShopCanBuy_GoCommonShop(lackData)
    end
    if lackData.tips == LWResourceLackGetWay.HonorShopNew then
      return not LWResourceLackUtil:HasAnyShopCanBuy(lackData, CommonShopType.HonorShop)
    end
    return false
  end
  
  local function GetSortGroup(lackData)
    if LWResourceLackShow_NotOpenTypes[lackData.tips] and not UIUtil.CheckWayTypeOfActivityAndCheckOpenIsOpen(lackData) then
      return 5
    end
    if LWResourceLackShow_SoldOutTypes[lackData.tips] and IsSoldOutState(lackData) then
      return 4
    end
    if LWResourceLackShow_CompletedTypes[lackData.tips] and IsCompletedState(lackData) then
      return 3
    end
    if LWResourceLackShow_CountdownTypes[lackData.tips] and IsCountdownState(lackData) then
      return 2
    end
    return 1
  end
  
  local tailDataList = {}
  for index = #dataList, 1, -1 do
    local lackData = dataList[index]
    if LWResourceLackShow_CountdownTypes[lackData.tips] and IsCountdownState(lackData) or LWResourceLackShow_CompletedTypes[lackData.tips] and IsCompletedState(lackData) or LWResourceLackShow_SoldOutTypes[lackData.tips] and IsSoldOutState(lackData) or LWResourceLackShow_NotOpenTypes[lackData.tips] and not UIUtil.CheckWayTypeOfActivityAndCheckOpenIsOpen(lackData) then
      table.insert(tailDataList, 1, lackData)
      table.remove(dataList, index)
    end
  end
  table.sort(tailDataList, function(a, b)
    local groupA = GetSortGroup(a)
    local groupB = GetSortGroup(b)
    if groupA ~= groupB then
      return groupA < groupB
    end
    local orderA = tonumber(a.order) or 0
    local orderB = tonumber(b.order) or 0
    if orderA ~= orderB then
      return orderA < orderB
    end
    return (tonumber(a.id) or 0) < (tonumber(b.id) or 0)
  end)
  for _, lackData in ipairs(tailDataList) do
    table.insert(dataList, lackData)
  end
  return dataList
end

function LWResourceLackUtil:IsTypeSkipFilter(type, skipFilterTypeList)
  if type == nil or table.IsNullOrEmpty(skipFilterTypeList) then
    return false
  end
  return skipFilterTypeList[type] == true
end

function LWResourceLackUtil:CalcOrder(template, need)
  if template.tips == LWResourceLackGetWay.CityCollection then
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(template.para1))
    if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
      return 0
    end
    local storage = 0
    for k, v in pairs(buildList) do
      storage = storage + DataCenter.ProductLineManager:GetBuildingCurrStorage(v.uuid)
    end
    if storage == 0 then
      return 0
    end
    local splOrder = string.split(template.raw_order, "|")
    local splLine = string.split(template.baseline, "|")
    local rate = storage / need
    local index = 0
    for k, v in pairs(splLine) do
      if rate < tonumber(v) then
        return tonumber(splOrder[index])
      end
      index = index + 1
    end
    return tonumber(splOrder[#splOrder])
  else
    return 99
  end
end

function LWResourceLackUtil:GetResState(time, needList, type)
  if not needList or not time then
    Logger.LogError("error !! not needList or not time")
    return
  end
  local speedType = ItemSpdMenu.ItemSpdMenu_Soldier
  if type then
    speedType = type
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = curTime + time * 1000
  local speedUpitems, outTime = self:GetSpeedUpGoods(endTime, speedType)
  local info = {}
  info.speedUpitems = speedUpitems
  info.time = outTime
  if outTime <= 0 then
    if 0 < #needList then
      info.miaCompleteState = MiaCompleteState.ItemAmpleResDeficiency
    else
      info.miaCompleteState = MiaCompleteState.ItemAmpleResAmple
    end
  elseif 0 < #needList then
    info.miaCompleteState = MiaCompleteState.ItemDeficiencyResDeficiency
  else
    info.miaCompleteState = MiaCompleteState.ItemDeficiencyResAmple
  end
  return info
end

function LWResourceLackUtil:GetSpeedUpGoods(endTime, speedType, itemList)
  local list
  if itemList then
    list = itemList
  else
    list = DataCenter.ItemData:GetSpeedItem(speedType) or {}
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = (endTime - curTime) / 1000
  local tempItemList = DeepCopy(list) or {}
  local time1, time2
  table.sort(tempItemList, function(a, b)
    time1 = tonumber(a.para3)
    time2 = tonumber(b.para3)
    if a.speedUpType > b.speedUpType then
      return true
    elseif a.speedUpType == b.speedUpType and time1 > time2 then
      return true
    end
  end)
  local tempTime
  local count = 0
  local maxCount = 0
  local speedItemList = {}
  local tempInfo
  local surplusTime2 = time + 59
  for i = 1, #tempItemList do
    if 0 < time then
      tempTime = tonumber(tempItemList[i].para3)
      if surplusTime2 > tempTime then
        count = math.floor(surplusTime2 / tempTime)
        maxCount = math.min(count, tempItemList[i].count)
        time = time - tempTime * maxCount
        surplusTime2 = surplusTime2 - tempTime * maxCount
        tempInfo = DeepCopy(tempItemList[i])
        tempInfo.id = tempItemList[i].itemId
        tempInfo.rewardType = 7
        tempInfo.count = maxCount
        tempInfo.speedUpType = tempItemList[i].speedUpType
        tempItemList[i].count = tempItemList[i].count - maxCount
        table.insert(speedItemList, {maxCount = maxCount, item = tempInfo})
      end
    end
  end
  local isContinueStage3 = false
  local deviationTime = 0
  local minValue = LuaEntry.DataConfig:TryGetNum("speedup_config", "k1")
  local maxValue = LuaEntry.DataConfig:TryGetNum("speedup_config", "k2")
  if 0 < time then
    table.sort(tempItemList, function(a, b)
      time1 = tonumber(a.para3)
      time2 = tonumber(b.para3)
      if time1 < time2 then
        return true
      elseif time1 == time2 and a.speedUpType > b.speedUpType then
        return true
      end
    end)
    for i = 1, table.count(tempItemList) do
      if 0 < tempItemList[i].count then
        deviationTime = math.abs(time - tonumber(tempItemList[i].para3))
        isContinueStage3 = minValue <= deviationTime and maxValue >= deviationTime
        if minValue > deviationTime or minValue <= deviationTime and maxValue >= deviationTime then
          local isNew = true
          for j = 1, table.count(speedItemList) do
            local useTemp = speedItemList[j]
            if useTemp.item.id == tempItemList[i].itemId then
              isNew = false
              useTemp.item.count = useTemp.item.count + 1
              useTemp.maxCount = useTemp.maxCount + 1
              time = time - tonumber(tempItemList[i].para3)
              break
            end
          end
          if isNew then
            local newTemp = {}
            newTemp.maxCount = 1
            newTemp.item = DeepCopy(tempItemList[i])
            newTemp.item.id = tempItemList[i].itemId
            newTemp.item.rewardType = 7
            newTemp.item.count = 1
            newTemp.item.speedUpType = tempItemList[i].speedUpType
            time = time - tonumber(tempItemList[i].para3)
            table.insert(speedItemList, newTemp)
          end
        end
        break
      end
    end
  end
  if isContinueStage3 then
    table.sort(speedItemList, function(a, b)
      time1 = tonumber(a.item.para3)
      time2 = tonumber(b.item.para3)
      if a.item.speedUpType < b.item.speedUpType then
        return true
      elseif a.item.speedUpType == b.item.speedUpType and time1 < time2 then
        return true
      end
    end)
    for i = 1, table.count(speedItemList) do
      if minValue > deviationTime then
        break
      end
      local useTemp = speedItemList[i]
      local oneTime = tonumber(useTemp.item.para3)
      local needReturnCount = math.floor(deviationTime / oneTime)
      if 0 < needReturnCount then
        local realReturnCount = math.min(needReturnCount, useTemp.item.count)
        deviationTime = deviationTime - oneTime * realReturnCount
        time = time + oneTime * realReturnCount
        local surplusCount = useTemp.item.count - realReturnCount
        useTemp.item.count = surplusCount
        useTemp.maxCount = surplusCount
      end
    end
  end
  local endSpeedItemList = {}
  for i = 1, table.count(speedItemList) do
    local temp = speedItemList[i]
    if 0 < temp.item.count then
      table.insert(endSpeedItemList, temp)
    end
  end
  table.sort(endSpeedItemList, function(a, b)
    time1 = tonumber(a.item.para3)
    time2 = tonumber(b.item.para3)
    if a.item.speedUpType > b.item.speedUpType then
      return true
    elseif a.item.speedUpType == b.item.speedUpType and time1 > time2 then
      return true
    end
  end)
  return endSpeedItemList, time
end

function LWResourceLackUtil:IsResourcePurchasableWithDiamonds(resType)
  local isExist = false
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
  if not templates then
    return isExist
  end
  for _, k in ipairs(templates) do
    if k.tips == LWResourceLackGetWay.BuyGiftBag then
      return true
    end
  end
  return isExist
end

function LWResourceLackUtil:GetResourceByUseItemWay(resType)
  local goItemList = {}
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
  if not templates or #templates == 0 then
    return nil
  end
  for k, v in pairs(templates) do
    if v.tips == LWResourceLackGetWay.UseItem then
      local items = DataCenter.ItemData:GetItemById(v.para1)
      local itemCount = items and items.count or 0
      if 0 < itemCount then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
        local type = tonumber(goods.type)
        if type == GOODS_TYPE.GOODS_TYPE_3 then
          local give = tonumber(items.para2) or 0
          table.insert(goItemList, {
            itemId = tonumber(items.itemId),
            give = give,
            haveNum = itemCount,
            quality = goods.color
          })
        elseif type == GOODS_TYPE.GOODS_TYPE_109 then
          local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(goods.para1), DataCenter.BuildManager.MainLv, tonumber(goods.para2))
          local give = returnItem.count * tonumber(goods.para3)
          table.insert(goItemList, {
            itemId = tonumber(items.itemId),
            give = give,
            haveNum = itemCount,
            quality = goods.color
          })
        elseif goods:IsSelectBox() and not goods:IsGuarantBox() then
          local List = string.split(items.para1, "|")
          local options = {}
          local optionsIndices = {}
          for i = 1, #List do
            local item = string.split(List[i], ",")
            options[tonumber(item[1])] = tonumber(item[2])
            optionsIndices[tonumber(item[1])] = i
          end
          local templates = {}
          templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
          if templates then
            for i = 1, #templates do
              local lackTemplate = templates[i]
              local para1Num = tonumber(lackTemplate.para1)
              if para1Num and lackTemplate.tips == LWResourceLackGetWay.UseItem and options[para1Num] then
                local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(para1Num)
                local perGainItemCount = GoodsUtil.GetGoodsReturnItemCount(goodsTemplate.id, resType)
                table.insert(goItemList, {
                  itemId = tonumber(items.itemId),
                  give = perGainItemCount,
                  haveNum = itemCount,
                  quality = goods.color,
                  chooseItemIndex = optionsIndices[para1Num]
                })
                break
              end
            end
          end
        end
      end
    end
  end
  return goItemList
end

function LWResourceLackUtil:GetResItemsToSupplementDatas(resType, differenceCount)
  local usedItems = {}
  local goItemList = LWResourceLackUtil:GetResourceByUseItemWay(resType)
  if goItemList ~= nil then
    table.sort(goItemList, function(a, b)
      return a.quality < b.quality
    end)
    for k, v in ipairs(goItemList) do
      if differenceCount <= 0 then
        break
      end
      local give = v.give
      local haveNum = v.haveNum
      if 0 < haveNum and 0 < give then
        local useNum = Mathf.Min(Mathf.Ceil(differenceCount / give), haveNum)
        local totalGive = useNum * give
        differenceCount = differenceCount - totalGive
        Logger.Log("\230\183\187\229\138\160\231\154\132\233\129\147\229\133\183ID\239\188\155 " .. v.itemId .. "\230\149\176\233\135\143\239\188\154 " .. useNum .. " \229\141\149\228\189\141\230\149\176\233\135\143\231\187\153\228\186\136\239\188\154 " .. give .. " \228\187\141\231\132\182\231\188\186\229\164\154\229\176\145\239\188\154 " .. differenceCount)
        local tempParam = {}
        tempParam.rewardType = RewardType.GOODS
        tempParam.itemId = v.itemId
        tempParam.count = useNum
        tempParam.quality = v.quality
        if v.chooseItemIndex then
          tempParam.chooseItemIndex = v.chooseItemIndex
        end
        table.insert(usedItems, tempParam)
      end
    end
  end
  table.sort(usedItems, function(a, b)
    return a.quality > b.quality
  end)
  return usedItems, differenceCount
end

function LWResourceLackUtil:IsExistLackResourceIteminBag(resType)
  local isExist = false
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
  if not templates then
    return isExist
  end
  for _, k in ipairs(templates) do
    if k.tips == LWResourceLackGetWay.UseItem then
      local items = DataCenter.ItemData:GetItemById(k.para1)
      local itemCount = items and items.count or 0
      if 0 < itemCount then
        return true
      end
    end
  end
  return isExist
end

function LWResourceLackUtil:TryGetBuildingCanCollectResNum(resType, need)
  local resLackTemplateList = LWResourceLackUtil:GetResLackList(resType, need)
  local collection = 0
  if resLackTemplateList and 0 < #resLackTemplateList then
    for j, resLackTemplate in ipairs(resLackTemplateList) do
      local collectCityNum = BuildingUtils.GetCityBuildAllResByItemId(tonumber(resLackTemplate.para1)) or 0
      collection = collectCityNum + collection
    end
  end
  return collection
end

function LWResourceLackUtil:TryCollectBuildingCollection(resType, need, silence)
  local resLackTemplateList = LWResourceLackUtil:GetResLackList(resType, need)
  local collection = 0
  local itemID = 0
  if resLackTemplateList and 0 < #resLackTemplateList then
    for j, resLackTemplate in ipairs(resLackTemplateList) do
      local collectCityNum = BuildingUtils.CityCollectionByItemId(tonumber(resLackTemplate.para1), nil, nil, 300) or 0
      if collectCityNum ~= 0 then
        itemID = tonumber(resLackTemplate.para1)
      end
      collection = collectCityNum + collection
    end
  end
  if not silence and 0 < collection and 0 < itemID then
    DataCenter.LWSoundManager:PlayBubbleEffect(itemID)
    UIUtil.ShowTipsId("fill_up_collect_resources")
  end
  return collection
end

function LWResourceLackUtil:TryGetHangUpRewardCanCollectResNum(resType, receiveHangUpReward)
  local collectNum = 0
  local hangUpValue = 0
  local reward = DataCenter.StageManager.idleReward
  if reward then
    for i, rewardRow in ipairs(reward) do
      if resType == rewardRow.type then
        hangUpValue = rewardRow.value
        break
      end
    end
  end
  if 0 < hangUpValue then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local timeDelta = curTime - DataCenter.StageManager.lastIdleRewardTimeStamp
    local time = timeDelta / 1000 / 60
    if 5 < time then
      collectNum = hangUpValue
      if receiveHangUpReward then
        DataCenter.LWResourceLackManager:SetReceiveHangUpRewardSilentlySign()
        SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 1, true)
      end
    end
  end
  return collectNum
end

function LWResourceLackUtil:GetResLackList(resType, need)
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
  local tempDataList
  if not table.IsNullOrEmpty(templates) then
    tempDataList = LWResourceLackUtil:FilterResourceTemplates(templates, need)
  end
  if not tempDataList or #tempDataList == 0 then
    return
  end
  table.sort(tempDataList, function(a, b)
    return a.order < b.order
  end)
  local resLackList
  if 0 < table.count(tempDataList) then
    local giftPackageData = tempDataList[1]
    if giftPackageData.tips == LWResourceLackGetWay.GiftPackage or giftPackageData.tips == LWResourceLackGetWay.GiftPackageList then
      resLackList = {}
      if table.count(tempDataList) > 1 then
        for k = 2, table.count(tempDataList) do
          table.insert(resLackList, tempDataList[k])
        end
      end
    else
      resLackList = tempDataList
    end
  end
  resLackList = resLackList or {}
  return resLackList
end

function LWResourceLackUtil:GotoBuildDecorationResLack(buildingUuid, next, fromClickMainUI)
  local data = {}
  data.type = ResLackContextType.BuildingDecoration
  data.need = next or math.maxinteger
  data.decoBuildingUuid = buildingUuid
  data.fromClickMainUI = fromClickMainUI
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSpecialResLack, {anim = true}, data)
end

function LWResourceLackUtil:GetResourceSpeedCountPerHour(resourceType)
  local res = 0
  local uuids = DataCenter.ProductLineManager:GetBuildUuidsByProductRes(resourceType)
  for k, bUuid in pairs(uuids) do
    local num = DataCenter.ProductLineManager:GetProductRes(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductRes(bUuid))[1]]
    if num == nil then
      num = DataCenter.ProductLineManager:GetProductResItem(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductResItem(bUuid))[1]]
    end
    if num == nil then
      num = DataCenter.ProductLineManager:GetProductGoods(bUuid)[table.keys(DataCenter.ProductLineManager:GetProductGoods(bUuid))[1]]
    end
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData then
      local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
      if BuildingUtils.IsSeasonWeekCardCityBuilding(buildData.itemId) then
        local flag = true
        if buildData.level == 0 then
        else
          local actWeek = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonPeriodicCard.Type)
          if actWeek ~= nil and actWeek.endTime ~= nil then
            local now = UITimeManager:GetInstance():GetServerTime()
            if now < actWeek.endTime then
              local cardId = toInt(actWeek.para)
              local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
              if cardData and cardData:IsBought() then
                flag = false
              end
            else
              flag = false
            end
          end
        end
        if flag then
          buildLevelTemplate = nil
        end
      end
      if buildLevelTemplate then
        local cnt = 3600000 / buildLevelTemplate.produce_time
        local effectValue = 1 + DataCenter.ProductLineManager:GetBuildingWorkerEffect(bUuid) + DataCenter.ProductLineManager:GetAdditionTechnological(buildData)
        res = res + cnt * num * effectValue
      end
    end
  end
  return res
end

function LWResourceLackUtil:IsShowActivityLack(lackTemplate)
  if lackTemplate.tips == LWResourceLackGetWay.ActivityAndCheckOpen or lackTemplate.tips == LWResourceLackGetWay.GoToActivityAndDontCloseSelf or lackTemplate.tips == LWResourceLackGetWay.GotoWorldBossTask then
    local isShow = UIUtil.CheckWayTypeOfActivityAndCheckOpenIsOpen(lackTemplate)
    if not isShow then
      return false
    end
  end
  return true
end

function LWResourceLackUtil:GetShowItemIdFromMultiUseItemGetWay(lackTemplate)
  if lackTemplate == nil then
    return nil
  end
  if lackTemplate.tips ~= LWResourceLackGetWay.MultiUseItem then
    return nil
  end
  if not string.IsNullOrEmpty(lackTemplate.para1) then
    local itemIdList = string.split(lackTemplate.para1, "|")
    for _, itemIdStr in ipairs(itemIdList) do
      local itemInfo = DataCenter.ItemData:GetItemById(itemIdStr)
      if itemInfo then
        local itemCount = itemInfo and itemInfo.count or 0
        if 0 < itemCount then
          return itemIdStr
        end
      end
    end
  end
end

return ConstClass("LWResourceLackUtil", LWResourceLackUtil)
