local ExchangeSpecialManager = BaseClass("ExchangeSpecialManager")
local ExchangeSpecialTemplate = require("DataCenter.ExchangeSpecialManager.ExchangeSpecialTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.templateList = nil
  self.cacheSpeedInfoList = {}
  self.lastRequestTime = {}
end

local function __delete(self)
  self.templateList = nil
  self.cacheSpeedInfoList = {}
  self.lastRequestTime = {}
end

function ExchangeSpecialManager.getters:GetTemplateList()
  if self.templateList ~= nil then
    return self.templateList
  end
  self.templateList = {}
  LocalController:instance():visitTable(TableName.Exchange_Special, function(id, lineData)
    local template = ExchangeSpecialTemplate.New()
    template:InitData(lineData)
    table.insert(self.templateList, template)
  end)
  return self.templateList
end

local function InitData(self)
end

function ExchangeSpecialManager:InitStaticData()
  if self.templateList ~= nil then
    return
  end
  self.templateList = {}
  LocalController:instance():visitTable(TableName.Exchange_Special, function(id, lineData)
    local template = ExchangeSpecialTemplate.New()
    template:InitData(lineData)
    table.insert(self.templateList, template)
  end)
end

function ExchangeSpecialManager:IsExistSpeedUpBuilding(speedType)
  local result = false
  local templateList = self.GetTemplateList
  for _, v in ipairs(templateList) do
    if v.item_spd_menu == tostring(speedType) then
      local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(tonumber(v.decoration_id), true)
      local isFoldUp = buildData == nil or buildData.state == BuildingStateType.FoldUp
      local isShowEffectThisServer = v:IsShowEffectThisServer()
      if not isFoldUp and isShowEffectThisServer then
        result = true
        break
      end
    end
  end
  return result
end

function ExchangeSpecialManager:GetEffectTemplateList(speedType)
  local list = {}
  local templateList = self.GetTemplateList
  for _, v in ipairs(templateList) do
    if v.item_spd_menu == tostring(speedType) then
      local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(tonumber(v.decoration_id), true)
      local isFoldUp = buildData == nil or buildData.state == BuildingStateType.FoldUp
      local isShowEffectThisServer = v:IsShowEffectThisServer()
      if not isFoldUp and isShowEffectThisServer then
        table.insert(list, v)
      end
    end
  end
  return list
end

function ExchangeSpecialManager:RequestExchangeSpecialDecorationReduce(templateId, forceRequest)
  local lastReqTime = self.lastRequestTime[templateId]
  local now = UITimeManager:GetInstance():GetServerTime()
  if lastReqTime and now - lastReqTime < 5000 and not forceRequest then
    if self.cacheSpeedInfoList[tostring(templateId)] then
      EventManager:GetInstance():Broadcast(EventId.PyramidReduceTips, self.cacheSpeedInfoList[tostring(templateId)])
    end
    return
  end
  self.lastRequestTime[templateId] = now
  if self:CheckPyramidData(templateId) then
    SFSNetwork.SendMessage(MsgDefines.PyramidDecorationReduce)
  else
    SFSNetwork.SendMessage(MsgDefines.ExchangeSpecialDecorationReduce, templateId)
  end
end

function ExchangeSpecialManager:CheckPyramidData(templateId)
  local template
  local templateList = self.GetTemplateList
  for _, v in ipairs(templateList) do
    if tostring(v.id) == tostring(templateId) then
      template = v
      break
    end
  end
  if template == nil then
    return false
  end
  return tostring(template.id) == "1" and tostring(template.decoration_id) == tostring(BuildingTypes.LW_BUILD_DECORATION_PYRAMID)
end

function ExchangeSpecialManager:OnResponsePyramidDecorationReduce(t)
  t.id = "1"
  self.cacheSpeedInfoList["1"] = t
end

function ExchangeSpecialManager:OnResponseExchangeSpecialDecorationReduce(t)
  self.cacheSpeedInfoList[tostring(t.id)] = t
end

function ExchangeSpecialManager:GetExchangeSpecialDecorationData(id)
  return self.cacheSpeedInfoList[tostring(id)]
end

function ExchangeSpecialManager:GetTemplateContainPackageId(packageId)
  if packageId == nil then
    return
  end
  local templateList = self.GetTemplateList
  for _, v in ipairs(templateList) do
    local package = v:IsActivePackage(packageId)
    if package then
      return v
    end
  end
end

function ExchangeSpecialManager:GetCanBuyPackageTemplate(speedType)
  local templateList = self.GetTemplateList
  for _, v in ipairs(templateList) do
    if v.item_spd_menu == tostring(speedType) then
      local package = v:GetCanBuyPackage()
      if package then
        return v
      end
    end
  end
end

function ExchangeSpecialManager:GetSpeedInfoTipText(id)
  local template
  local templateList = self.GetTemplateList
  for _, v in ipairs(templateList) do
    if tostring(v.id) == tostring(id) then
      template = v
      break
    end
  end
  if template == nil then
    return ""
  end
  local msg = self.cacheSpeedInfoList[tostring(id)]
  if msg == nil then
    return ""
  end
  local itemName = DataCenter.RewardManager:GetNameByType(7, msg.itemId)
  local saveTimePercentInCfg = template:GetRefundRatio()
  local saveTimePercentInCfgStr = tonumber(saveTimePercentInCfg) * 100 .. "%"
  local buildTotalTime = UITimeManager:GetInstance():MilliSecondToFmtString(msg.needTotalTime * 1000 or 0)
  local reduceTime = UITimeManager:GetInstance():MilliSecondToFmtString(msg.reduceTime * 1000 or 0)
  return Localization:GetString(template.decoration_des2, reduceTime, itemName, msg.itemNum, saveTimePercentInCfgStr)
end

function ExchangeSpecialManager:GetReduceTime(template, uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if buildCurLevelTemplate == nil then
    return 0
  end
  local T0 = buildCurLevelTemplate.time * 1000 or 0
  local pyramidData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(tonumber(template.decoration_id), true)
  if pyramidData == nil then
    return 0
  end
  local pyramidCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(tonumber(template.decoration_id), pyramidData.level)
  local A2 = 1
  if pyramidCurLevelTemplate then
    A2 = pyramidCurLevelTemplate.building_effect_last[tonumber(template.effectId)] or 1
  end
  if tonumber(template.effectId) == EffectDefine.BUILD_SPEED_UP_Pyramid then
    local T2 = buildData.updateTime - buildData.startTime
    local A1 = T0 / T2 - 1 - A2
    local T1 = T0 / (1 + A1)
    return T1 - T2
  elseif tonumber(template.effectId) == EffectDefine.BUILD_SPEED_UP_SuperBuilding then
    return A2 * 1000
  end
end

function ExchangeSpecialManager:GetBuildingReduceTimeByUuid(uuid)
  local list = self:GetEffectTemplateList(ItemSpdMenu.ItemSpdMenu_City)
  table.sort(list, function(a, b)
    return tonumber(a.effect_word) < tonumber(b.effect_word)
  end)
  local time = 0
  for _, v in ipairs(list) do
    local reduce = self:GetReduceTime(v, uuid)
    time = time + reduce
  end
  return time
end

ExchangeSpecialManager.__init = __init
ExchangeSpecialManager.__delete = __delete
ExchangeSpecialManager.InitData = InitData
return ExchangeSpecialManager
