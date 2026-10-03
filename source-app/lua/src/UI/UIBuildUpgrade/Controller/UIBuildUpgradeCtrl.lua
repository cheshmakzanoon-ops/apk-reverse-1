local UIBuildUpgradeCtrl = BaseClass("UIBuildUpgradeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildUpgrade)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetDesShowData(self, curLevelBuildTemplate, nextLevelBuildTemplate, baseBuildTemplate)
  if curLevelBuildTemplate == nil then
    return nil
  end
  local resShowDataTemp = {}
  if curLevelBuildTemplate.effect_Local_dialog then
    local countDialog = table.count(curLevelBuildTemplate.effect_Local_dialog)
    local countType = table.count(curLevelBuildTemplate.effect_Local_type)
    local curNums = curLevelBuildTemplate.local_num
    local count = math.min(countDialog, countType)
    for i = 1, count do
      local key = Localization:GetString(curLevelBuildTemplate.effect_Local_dialog[i])
      resShowDataTemp[key] = {}
      resShowDataTemp[key].index = i
      local type = curLevelBuildTemplate.effect_Local_type[i]
      resShowDataTemp[key].curValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(curNums[i]) or 0, type)
    end
  end
  if nextLevelBuildTemplate and curLevelBuildTemplate.effect_Local_dialog then
    local countDialog = table.count(nextLevelBuildTemplate.effect_Local_dialog)
    local countType = table.count(nextLevelBuildTemplate.effect_Local_type)
    local curNums = nextLevelBuildTemplate.local_num
    local count = math.min(countDialog, countType)
    for i = 1, count do
      local key = Localization:GetString(nextLevelBuildTemplate.effect_Local_dialog[i])
      local type = nextLevelBuildTemplate.effect_Local_type[i]
      if type == EffectLocalType.Dialog then
        local val = DataCenter.BuildManager:GetEffectNumWithType(nextLevelBuildTemplate.local_num[i] or 0, type)
        if val ~= nil and val ~= "" then
          if resShowDataTemp[key] == nil then
            resShowDataTemp[key] = {}
            resShowDataTemp[key].index = i
          end
          resShowDataTemp[key].addValue = val
          resShowDataTemp[key].curValue = nil
        end
      else
        if resShowDataTemp[key] == nil then
          resShowDataTemp[key] = {}
          resShowDataTemp[key].index = i
        end
        resShowDataTemp[key].addValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(curNums[i]) or 0, type)
      end
    end
  end
  local resShowData = {}
  for i, v in pairs(resShowDataTemp) do
    local param = {}
    param.name = i
    param.curValue = v.curValue
    param.addValue = v.addValue
    param.index = v.index
    if baseBuildTemplate.id == BuildingTypes.LW_BUILD_SQUAD_EQUIP_FACTORY and curLevelBuildTemplate.local_num and curLevelBuildTemplate.local_num[v.index] then
      local curNum = curLevelBuildTemplate.local_num[v.index]
      local type = curLevelBuildTemplate.effect_Local_type[v.index]
      if tonumber(curNum) * 1000 == curLevelBuildTemplate.produce_time then
        local speedAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.DRONE_FACTORY_SPEED_ADD_94101)
        if 0 < speedAdd then
          param.extra = {
            title = Localization:GetString("season_mastery_s2_tips_14"),
            old = Localization:GetString("season_mastery_s2_tips_15"),
            new = Localization:GetString("season_mastery_s2_tips_16"),
            oldValue = param.curValue or param.addValue,
            newValue = DataCenter.BuildManager:GetEffectNumWithType((tonumber(curNum) or 0) / (1 + speedAdd), type)
          }
        end
      end
    end
    table.insert(resShowData, param)
  end
  table.sort(resShowData, function(a, b)
    return a.index < b.index
  end)
  return resShowData
end

UIBuildUpgradeCtrl.CloseSelf = CloseSelf
UIBuildUpgradeCtrl.Close = Close
UIBuildUpgradeCtrl.GetDesShowData = GetDesShowData
return UIBuildUpgradeCtrl
