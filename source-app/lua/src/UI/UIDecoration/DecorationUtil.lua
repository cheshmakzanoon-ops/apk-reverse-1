local Localization = CS.GameEntry.Localization
local DecorationUtil = {}

local function OpenDecorationPanel(type, decorationId, activityId)
  GoToUtil.CloseAllWindows()
  if CS.SceneManager.IsInCity() then
    local function onComplete()
      EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
      
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, type, decorationId, activityId)
    end
    
    GoToUtil.GotoCityPos(DecorationUtil.GetCityPos(), CS.SceneManager.World.InitZoom, 0, onComplete)
  else
    local function onComplete()
      EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
      
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, type, decorationId, activityId)
    end
    
    GoToUtil.GotoWorldPos(DecorationUtil.GetCityPos(), CS.SceneManager.World.InitZoom, 0, onComplete)
  end
end

local function GetEffectDesc(decorationId, addColor, subColor)
  if addColor == nil then
    addColor = "#94e138"
  end
  if subColor == nil then
    subColor = "#f26a67"
  end
  local addColorTag = "<color=" .. addColor .. ">"
  local subColorTag = "<color=" .. subColor .. ">"
  local result = {}
  if decorationId == nil then
    return result
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  if template ~= nil then
    if template.type == DecorationType.DecorationType_Emoji and template.customVariable and tonumber(template.customVariable) > 0 then
      local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(template.customVariable))
      if strickerTmp then
        result.name = Localization:GetString(strickerTmp.sticker_name)
      end
    else
      result.name = Localization:GetString(template.name)
    end
    result.color = UIUtil.GetColorByQuality(template.quality)
    local useEffect = ""
    local useNum = table.count(template.wearEffect)
    local count = 0
    result.wearEffects = {}
    for _, v in pairs(template.wearEffect) do
      local effectId = v.key
      local value = v.value
      local nameStr = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
      local name = Localization:GetString(nameStr)
      local addValue = HeroUtils.GetFormattedPropertyValue(effectId, value)
      local effectParam = {}
      effectParam.name = name
      if value < 0 then
        useEffect = useEffect .. name .. "   " .. subColorTag .. addValue .. "</color>"
        effectParam.value = subColorTag .. addValue .. "</color>"
      else
        useEffect = useEffect .. name .. "   " .. addColorTag .. addValue .. "</color>"
        effectParam.value = addColorTag .. addValue .. "</color>"
      end
      count = count + 1
      if useNum > count then
        useEffect = useEffect .. "\n"
      end
      table.insert(result.wearEffects, effectParam)
    end
    result.useEffect = useEffect
    local ownEffect = ""
    count = 0
    local ownNum = table.count(template.ownEffect)
    result.ownEffects = {}
    for _, v in pairs(template.ownEffect) do
      local effectId = v.key
      local value = v.value
      local nameStr = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
      local name = Localization:GetString(nameStr)
      local addValue = HeroUtils.GetFormattedPropertyValue(effectId, value)
      local effectParam = {}
      effectParam.name = name
      if value < 0 then
        ownEffect = ownEffect .. name .. "   " .. subColorTag .. addValue .. "</color>"
        effectParam.value = subColorTag .. addValue .. "</color>"
      else
        ownEffect = ownEffect .. name .. "   " .. addColorTag .. addValue .. "</color>"
        effectParam.value = addColorTag .. addValue .. "</color>"
      end
      count = count + 1
      if ownNum > count then
        ownEffect = ownEffect .. "\n"
      end
      table.insert(result.ownEffects, effectParam)
    end
    result.ownEffect = ownEffect
    local isVipCitySkin = template.if_vip == 1
    result.isVipCitySkin = isVipCitySkin
  end
  return result
end

local function GetBuildingEffectDesc(buildingId)
  if not buildingId then
    return {}
  end
  local ret = {}
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId, 0)
  ret.name = Localization:GetString(buildTemplate.name)
  for k, v in pairs(buildTemplate.building_effect_last) do
    local desc = WorkerUtil.GetEffectText(k, v)
    if ret.buffStr then
      ret.buffStr = ret.buffStr .. "\n" .. desc
    else
      ret.buffStr = desc
    end
  end
  return ret
end

local function GetBuildingEffectDescWithBuffTextColor(buildingId, addColor, subColor)
  if not buildingId then
    return {}
  end
  if addColor == nil then
    addColor = "#94e138"
  end
  if subColor == nil then
    subColor = "#f26a67"
  end
  local addColorTag = "<color=" .. addColor .. ">"
  local subColorTag = "<color=" .. subColor .. ">"
  local ret = {}
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId, 0)
  ret.name = Localization:GetString(buildTemplate.name)
  for k, v in pairs(buildTemplate.building_effect_last) do
    local effectId = k
    local value = v
    local nameStr = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
    local name = Localization:GetString(nameStr)
    local addValue = HeroUtils.GetFormattedPropertyValue(effectId, value)
    local effectParam = {}
    effectParam.name = name
    local useEffect = ""
    if value < 0 then
      useEffect = useEffect .. name .. "   " .. subColorTag .. addValue .. "</color>"
    else
      useEffect = useEffect .. name .. "   " .. addColorTag .. addValue .. "</color>"
    end
    if ret.buffStr then
      ret.buffStr = ret.buffStr .. "\n" .. useEffect
    else
      ret.buffStr = useEffect
    end
  end
  return ret
end

local function GetQualityColor(quality)
  if quality == DecorationQuality.DecorationQuality_Normal then
    return DetectEventGreenColor
  elseif quality == DecorationQuality.DecorationGainType_Rare then
    return DetectEventBlueColor
  elseif quality == DecorationQuality.DecorationGainType_Epic then
    return DetectEventPurpleColor
  elseif quality == DecorationQuality.DecorationGainType_Legend then
    return DetectEventOrangeColor
  end
  return DetectEventGreenColor
end

local function GetCityPos()
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  return SceneUtils.TileIndexToWorld(mainBuild.pointId, ForceChangeScene.City) + Vector3.New(-3.5, 0, -2)
end

local function GetWorldPos(posIndex)
  if posIndex == nil then
    posIndex = 0
  end
  local defaultPosIndex = 2000
  local posYIndex = defaultPosIndex + posIndex * 200
  return Vector3.New(defaultPosIndex, posYIndex, defaultPosIndex)
end

local function GetWorldPosNegativeNumber(posIndex)
  if posIndex == nil then
    posIndex = 0
  end
  local defaultPosIndex = -2000
  local indexVal = -1000
  local posIndex = defaultPosIndex + posIndex * indexVal
  return Vector3.New(defaultPosIndex, 0, posIndex)
end

local function DoWhenClickUnlock(self, decorationId)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  if template ~= nil then
    local lastSex = LuaEntry.Player:GetGender()
    if lastSex ~= SexType.Woman and template.typeGain == DecorationGainType.DecorationGainType_Female then
      UIUtil.ShowTipsId(2000469)
      return
    end
    if template.typeGain == DecorationGainType.DecorationGainType_Item_Exchange then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorateUnlock, decorationId)
    elseif template.typeGain == DecorationGainType.DecorationGainType_OfficialPosition then
      local positionConfig = DataCenter.GovernmentTemplateManager:GetTemplateByTitleName(tonumber(decorationId))
      if positionConfig ~= nil then
        local positionName = Localization:GetString(positionConfig.name)
        if not string.IsNullOrEmpty(positionName) then
          UIUtil.ShowTips(Localization:GetString(2000473, positionName))
        end
      end
    elseif template.typeGain == DecorationGainType.DecorationGainType_Title then
      UIUtil.ShowTips(Localization:GetString("lw_title_ui_16", Localization:GetString(template.name)))
    end
  end
end

function DecorationUtil.GetDecorationBaseInfoById(decorationId)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  if not template then
    return
  end
  local rst = {}
  rst.nameId = template.name
  rst.icon = template.icon
  return rst
end

DecorationUtil.OpenDecorationPanel = OpenDecorationPanel
DecorationUtil.GetEffectDesc = GetEffectDesc
DecorationUtil.GetBuildingEffectDesc = GetBuildingEffectDesc
DecorationUtil.GetBuildingEffectDescWithBuffTextColor = GetBuildingEffectDescWithBuffTextColor
DecorationUtil.GetQualityColor = GetQualityColor
DecorationUtil.GetCityPos = GetCityPos
DecorationUtil.GetWorldPos = GetWorldPos
DecorationUtil.GetWorldPosNegativeNumber = GetWorldPosNegativeNumber
DecorationUtil.DoWhenClickUnlock = DoWhenClickUnlock
return ConstClass("DecorationUtil", DecorationUtil)
