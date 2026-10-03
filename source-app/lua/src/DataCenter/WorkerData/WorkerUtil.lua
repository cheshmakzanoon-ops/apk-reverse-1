local Localization = CS.GameEntry.Localization
local WorkerUtil = {}

local function GetWorkerAdditionProperty(workerData, buildData)
  if workerData == nil or buildData == nil then
    return 0
  end
  local buildLine = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), buildData.itemId)
  local effectName = tonumber(buildLine.bd_effect_result)
  local effectValue = Mathf.RoundTo(workerData:GetWorkerProperty(effectName), 4)
  return effectValue
end

local function GetWorkerAdditionPropertyStr(workerData, buildData)
  if workerData == nil or buildData == nil then
    return "+0%"
  end
  local effectValue = GetWorkerAdditionProperty(workerData, buildData)
  local effectValueStr = string.format("+%s%%", effectValue * 100)
  return effectValueStr
end

local function GetWorkerQualityBg(quality)
  local _quality = quality
  _quality = math.max(6, _quality)
  _quality = math.min(1, _quality)
  return string.format("Assets/Main/Sprites/UI/UIWorker/cfm_tongyong_gongren_touxiangkuang_%d.png", quality)
end

local function GetWorkerQualityColorBottomBg(quality)
  local _quality = quality
  local loadPath = "Assets/Main/Sprites/UI/UIWorker/%s.png"
  local bgName = "Mjc_xcz_iconbg_hui"
  if _quality == WorkerQualityType.Legendary then
    bgName = "Mjc_xcz_iconbg_cheng"
  elseif _quality == WorkerQualityType.Genius then
    bgName = "Mjc_xcz_iconbg_zi"
  elseif _quality == WorkerQualityType.Outstanding then
    bgName = "Mjc_xcz_iconbg_lan"
  elseif _quality == WorkerQualityType.Excellent then
    bgName = "Mjc_xcz_iconbg_lv"
  end
  return string.format(loadPath, bgName)
end

local function GetWorkerIconPath(heroModelId, iconType)
  local path = ""
  local iconName = ""
  if iconType == nil then
    path = LoadPath.LWWorkerHeroIconsBigPath
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroModelId)
    iconName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "queue_icon_path")
  end
  return UIUtil.GetFullPath(path, iconName)
end

local function GetEffectText(effectId, number, isGetValue)
  local effectLine = DataCenter.EffectNumberTemplateManager:GetTemplate(tonumber(effectId))
  if not effectLine then
    Logger.LogError(string.format("not find effectConfig! effectId: %s", effectId))
    return "", ""
  end
  local describe = ""
  if not string.IsNullOrEmpty(effectLine:GetNameKey()) then
    describe = Localization:GetString(effectLine:GetNameKey())
  end
  local text = ""
  if effectLine.type == 0 then
    text = tostring(math.modf(number))
    if 0 <= number then
      text = "+" .. text
    end
  elseif effectLine.type == 1 then
    text = string.format("%s%%", string.format("%.2f", number * 100))
  elseif effectLine.type == 2 then
    text = string.format("%s%%", string.format("%.2f", number * 100))
    if 0 <= number then
      text = "+" .. text
    end
  elseif effectLine.type == 3 then
    text = string.format("%s%%", string.format("%.2f", number * 100))
    if 0 <= number then
      text = "-" .. text
    end
  elseif effectLine.type == 4 then
    local time = ""
    local hour = math.modf(number / 3600)
    local minute = math.modf(number / 60) % 60
    local second = math.floor(number % 60)
    if hour ~= 0 then
      time = time .. " " .. hour .. "" .. Localization:GetString(100166)
    end
    if minute ~= 0 then
      time = time .. " " .. minute .. "" .. Localization:GetString(100165)
    end
    if second ~= 0 then
      time = time .. " " .. second .. "" .. Localization:GetString(372115)
    end
    if time == "" then
      time = " " .. 0 .. "" .. Localization:GetString(372115)
    end
    if time ~= "" then
      text = "" .. time
    end
  elseif effectLine.type == 5 then
    text = "" .. number
  elseif effectLine.type == 8 then
    local realValue = number * 1.0E-4
    text = string.format("%s%%", string.format("%.2f", realValue * 100))
  elseif effectLine.type == 9 then
    local name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, toInt(number))
    text = name
  end
  if isGetValue then
    return describe, text
  end
  return describe .. text
end

local function GetWorkerExistBuild(workerData)
  for i, v in ipairs(workerData.workingBuildList) do
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v)
    if 0 < #buildList then
      for i = 1, #buildList do
        if buildList[i]:GetIsVacancyWorker() then
          return buildList[i]
        end
      end
    end
  end
end

local function GetWorkerNameColor(quality)
  if quality == 6 then
    return 1, 0.675, 0.6, 1
  elseif quality == 5 then
    return 1, 0.808, 0.294, 1
  elseif quality == 4 then
    return 0.988, 0.616, 1, 1
  elseif quality == 3 then
    return 0.439, 0.902, 0.945, 1
  elseif quality == 2 then
    return 0.302, 0.961, 0.69, 1
  elseif quality == 1 then
    return 1, 1, 1, 1
  end
end

function WorkerUtil.GetEffectValue(effects)
  local vals = {}
  local allWorkerData = DataCenter.WorkerDataManager:GetAllWorkerData()
  for i, v in pairs(allWorkerData) do
    if v.state == WorkerState.WORKER then
      for k, _ in pairs(effects) do
        vals[k] = (vals[k] or 0) + v:GetWorkerProperty(k)
      end
    end
  end
  return vals
end

function WorkerUtil.IsExistDispatchableTaylorWorker()
  local taylorWorkerId = 13303
  local taylorState = DataCenter.WorkerDataManager:GetTargetWorkerStateByCfgId(taylorWorkerId)
  if taylorState then
    if taylorState == WorkerState.WORKER then
      return false
    end
    if taylorState == WorkerState.RESIDENTA then
      return true
    end
  end
  local fragData = DataCenter.WorkerDataManager:GetFragDataById(taylorWorkerId)
  if fragData then
    local needNum = fragData.needNum
    local goodsId = fragData.itemCfg.id
    local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
    if needNum <= curNum then
      return true
    end
  end
  return false
end

WorkerUtil.GetWorkerAdditionProperty = GetWorkerAdditionProperty
WorkerUtil.GetWorkerAdditionPropertyStr = GetWorkerAdditionPropertyStr
WorkerUtil.GetWorkerQualityBg = GetWorkerQualityBg
WorkerUtil.GetWorkerIconPath = GetWorkerIconPath
WorkerUtil.GetEffectText = GetEffectText
WorkerUtil.GetWorkerExistBuild = GetWorkerExistBuild
WorkerUtil.GetWorkerNameColor = GetWorkerNameColor
WorkerUtil.GetWorkerQualityColorBottomBg = GetWorkerQualityColorBottomBg
return ConstClass("WorkerUtil", WorkerUtil)
