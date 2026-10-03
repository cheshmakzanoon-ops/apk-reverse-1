local GoToResLack = {}
local HeroExpResFlag = 100002
local PercentResFlag = 200000
local DesertResFlag = 200001

local function GotoOpenView(ui_name, ...)
  UIManager:GetInstance():OpenWindow(ui_name, ...)
end

local function GoToItemResLackList(list, isUpgrade, startPos, isUseCur, isPVESTAMINA, isReturn)
  if list then
    local dis = {}
    local resList = {}
    local lackItems = {}
    local lackResource = {}
    for i = 1, #list do
      if list[i].type == ResLackType.Res then
        local own = LuaEntry.Resource:GetCntByResType(list[i].resType)
        if list[i].resType == ResourceType.PVE_STAMINA then
          own = math.ceil(LuaEntry.Player:GetCurPveStamina())
        end
        if isUseCur then
          own = list[i].curNum
        end
        local param = {}
        param.disNum = list[i].targetNum - own
        param.resType = list[i].resType
        param.needCount = list[i].targetNum
        if param.disNum > 0 or isPVESTAMINA then
          table.insert(dis, param)
          lackResource[list[i].resType] = list[i].targetNum
        end
      elseif list[i].type == ResLackType.Item then
        local own = DataCenter.ItemData:GetItemCount(list[i].itemId)
        local param = {}
        param.disNum = list[i].targetNum - own
        param.resType = list[i].itemId
        param.needCount = list[i].targetNum
        param.isItem = true
        table.insert(dis, param)
        table.insert(lackItems, {
          itemId = list[i].itemId,
          count = list[i].targetNum
        })
      elseif list[i].type == ResLackType.ResItem then
        local own = DataCenter.ResourceItemDataManager:GetCountByItemId(list[i].itemId)
        local param = {}
        param.disNum = list[i].targetNum - own
        param.resType = list[i].itemId
        param.needCount = list[i].targetNum
        param.isResItem = true
        if param.disNum > 0 then
          table.insert(dis, param)
          table.insert(lackItems, {
            itemId = list[i].itemId,
            count = list[i].targetNum
          })
        end
      elseif list[i].type == ResLackType.HeroExp then
        local hero = DataCenter.HeroDataManager:GetHeroByUuid(list[i].heroUuid)
        list[i].targetNum = HeroUtils.GetLevelUpNeedExp(hero.level)
        local param = {}
        param.disNum = list[i].targetNum - hero.exp
        param.resType = list[i].itemId
        param.needCount = list[i].targetNum
        param.isHero = true
        param.heroUuid = list[i].heroUuid
        table.insert(dis, param)
        table.insert(lackItems, {
          itemId = list[i].itemId,
          count = list[i].targetNum
        })
      elseif list[i].type == ResLackType.Percent then
        local param = {}
        param.resType = PercentResFlag
        table.insert(dis, param)
      elseif list[i].type == ResLackType.DesertNum then
        local param = {}
        param.resType = DesertResFlag
        local dic = DataCenter.DesertDataManager:GetSelfSeverDesert()
        if LuaEntry.Player:IsInSelfServer() then
          param.isCross = false
        else
          dic = DataCenter.DesertDataManager:GetOtherSeverDesert()
          param.isCross = true
        end
        local maxNum = DataCenter.DesertDataManager:GetDesertMaxNum()
        param.disNum = math.floor(maxNum) - dic
        param.needCount = math.floor(maxNum)
        table.insert(dis, param)
      elseif list[i].type == ResLackType.SkyBattleRes and DataCenter.LWSkyBattleGrowthChapterManager.userInfo then
        local own = DataCenter.LWSkyBattleGrowthChapterManager.userInfo.coin or 0
        local param = {}
        param.disNum = list[i].targetNum - own
        param.resType = list[i].resType
        param.needCount = list[i].targetNum
        if param.disNum > 0 then
          table.insert(dis, param)
          lackResource[list[i].resType] = list[i].targetNum
        end
      end
    end
    for i = 1, #dis do
      resList[i] = DataCenter.ResLackManager:CheckResAddWay(dis[i].resType, dis[i].needCount, dis[i].isResItem)
    end
    if isUpgrade then
      GoToResLack.GotoOpenView(UIWindowNames.UIResourceLack, {anim = true}, lackResource, true, nil, lackItems, {
        isUpgrade = isUpgrade,
        resList = resList,
        dis = dis
      })
    else
      if isReturn then
        return resList, dis
      end
      if startPos ~= nil then
        GoToResLack.GotoOpenView(UIWindowNames.UICommonAccessBigPanel, {anim = false}, resList, dis, startPos, true, isPVESTAMINA)
      else
        GoToResLack.GotoOpenView(UIWindowNames.UICommonAccessBigPanel, {anim = true}, resList, dis, startPos, true, isPVESTAMINA)
      end
    end
  end
end

local function CheckMainLV()
  local k1 = LuaEntry.DataConfig:TryGetStr("res_lack", "k1")
  if k1 == "" then
    return false
  end
  if DataCenter.BuildManager.MainLv > tonumber(k1) then
    return false
  end
  return false
end

GoToResLack.GotoOpenView = GotoOpenView
GoToResLack.CheckMainLV = CheckMainLV
GoToResLack.GoToItemResLackList = GoToItemResLackList
return ConstClass("GoToResLack", GoToResLack)
