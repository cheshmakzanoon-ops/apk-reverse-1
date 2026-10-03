local UILWDominatorTrainMainUpgradeCtrl = BaseClass("UILWDominatorTrainMainUpgradeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UILWDominatorTrainMainUpgradeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorTrainUpgradeMain, {anim = false})
end

function UILWDominatorTrainMainUpgradeCtrl:GetNormalLevelContentShowInfo(levelTemplate)
  local data = {
    curValue = 0,
    title = Localization:GetString("dominator_train_rating_desc_2")
  }
  local requires = levelTemplate:GetUpgradeRequireIdList()
  for i, v in pairs(requires) do
    local tmpLevelTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(v)
    if tmpLevelTemplate then
      local group = tmpLevelTemplate:GetGroupTemplate()
      if group and not group:IsMainGroup() then
        data.curValue = tmpLevelTemplate.level_order
        break
      end
    end
  end
  local nextLevelTemplate = levelTemplate:GetNextLevelTemplate()
  if nextLevelTemplate then
    local nextRequires = nextLevelTemplate:GetUpgradeRequireIdList()
    for i, v in pairs(nextRequires) do
      local tmpLevelTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(v)
      if tmpLevelTemplate then
        local group = tmpLevelTemplate:GetGroupTemplate()
        if group and not group:IsMainGroup() then
          data.nextValue = tmpLevelTemplate.level_order
          break
        end
      end
    end
  end
  return data
end

function UILWDominatorTrainMainUpgradeCtrl:GetMainShowEffects(levelTemplate)
  local res = {}
  local attackData = {
    effectId = HeroEffectDefine.DominatorMainTrainGroupAttack,
    title = Localization:GetString("dominator_train_rating_desc_9"),
    curValue = 0,
    nextValue = 0,
    addValue = 0
  }
  local defenceData = {
    effectId = HeroEffectDefine.DominatorMainTrainGroupDefence,
    title = Localization:GetString("dominator_train_rating_desc_11"),
    curValue = 0,
    nextValue = 0,
    addValue = 0
  }
  local hpData = {
    effectId = HeroEffectDefine.DominatorMainTrainGroupHp,
    title = Localization:GetString("dominator_train_rating_desc_10"),
    curValue = 0,
    nextValue = 0,
    addValue = 0
  }
  local curEffects = levelTemplate:GetCombineEffects()
  if not table.IsNullOrEmpty(curEffects) then
    for i, v in ipairs(curEffects) do
      if v.effectId == HeroEffectDefine.DominatorMainTrainGroupAttack then
        attackData.curValue = math.floor(v.effectValue + 0.5)
      elseif v.effectId == HeroEffectDefine.DominatorMainTrainGroupDefence then
        defenceData.curValue = math.floor(v.effectValue + 0.5)
      elseif v.effectId == HeroEffectDefine.DominatorMainTrainGroupHp then
        hpData.curValue = math.floor(v.effectValue + 0.5)
      end
    end
  end
  local nextTemplate = levelTemplate:GetNextLevelTemplate()
  if nextTemplate then
    local nextEffects = nextTemplate:GetCombineEffects()
    if not table.IsNullOrEmpty(nextEffects) then
      for i, v in ipairs(nextEffects) do
        if v.effectId == HeroEffectDefine.DominatorMainTrainGroupAttack then
          attackData.nextValue = math.floor(v.effectValue + 0.5)
          attackData.addValue = math.floor(attackData.nextValue - attackData.curValue + 0.5)
        elseif v.effectId == HeroEffectDefine.DominatorMainTrainGroupDefence then
          defenceData.nextValue = math.floor(v.effectValue + 0.5)
          defenceData.addValue = math.floor(defenceData.nextValue - defenceData.curValue + 0.5)
        elseif v.effectId == HeroEffectDefine.DominatorMainTrainGroupHp then
          hpData.nextValue = math.floor(v.effectValue + 0.5)
          hpData.addValue = math.floor(hpData.nextValue - hpData.curValue + 0.5)
        end
      end
    end
  end
  table.insert(res, attackData)
  table.insert(res, defenceData)
  table.insert(res, hpData)
  return res
end

function UILWDominatorTrainMainUpgradeCtrl:GetNormalShowEffects(levelTemplate)
  local function IsNormalEffectId(effectId)
    if effectId == HeroEffectDefine.DominatorMainTrainGroupHp or effectId == HeroEffectDefine.DominatorMainTrainGroupAttack or effectId == HeroEffectDefine.DominatorMainTrainGroupDefence or effectId == HeroEffectDefine.DominatorAffordHeroHp or effectId == HeroEffectDefine.DominatorAffordHeroAtk or effectId == HeroEffectDefine.DominatorAffordHeroDef then
      return false
    end
    return true
  end
  
  local function GetEffectTitle(effectId)
    if effectId == HeroEffectDefine.DominatorMainTrainGroupSoldierCapacity then
      return Localization:GetString("overlord_march_size_name")
    else
      return Localization:GetString(GetTableData(TableName.LW_Effect_Number, effectId, "name", ""))
    end
  end
  
  local res = {}
  local showEffectDict = {}
  local curEffects = levelTemplate:GetCombineEffects()
  local effectCount = 1
  if not table.IsNullOrEmpty(curEffects) then
    for i, v in ipairs(curEffects) do
      if IsNormalEffectId(v.effectId) then
        showEffectDict[v.effectId] = {
          index = effectCount,
          curValue = v.effectValue,
          effectId = v.effectId,
          title = GetEffectTitle(v.effectId)
        }
        effectCount = effectCount + 1
      end
    end
  end
  local nextTemplate = levelTemplate:GetNextLevelTemplate()
  if nextTemplate then
    local nextEffects = nextTemplate:GetCombineEffects()
    if not table.IsNullOrEmpty(nextEffects) then
      for i, v in ipairs(nextEffects) do
        if IsNormalEffectId(v.effectId) then
          if showEffectDict[v.effectId] then
            showEffectDict[v.effectId].nextValue = v.effectValue
          else
            showEffectDict[v.effectId] = {
              index = effectCount,
              curValue = 0,
              nextValue = v.effectValue,
              effectId = v.effectId,
              title = GetEffectTitle(v.effectId)
            }
            effectCount = effectCount + 1
          end
        end
      end
    end
  end
  for i, v in pairs(showEffectDict) do
    table.insert(res, v)
  end
  table.sort(res, function(a, b)
    return a.index < b.index
  end)
  return res
end

function UILWDominatorTrainMainUpgradeCtrl:GetRequireContentShowLevel(levelTemplate)
  local requires = levelTemplate:GetUpgradeRequireIdList()
  for i, v in pairs(requires) do
    local tmpLevelTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(v)
    if tmpLevelTemplate then
      local group = tmpLevelTemplate:GetGroupTemplate()
      if group and not group:IsMainGroup() then
        return tmpLevelTemplate.level_order
      end
    end
  end
  return nil
end

return UILWDominatorTrainMainUpgradeCtrl
