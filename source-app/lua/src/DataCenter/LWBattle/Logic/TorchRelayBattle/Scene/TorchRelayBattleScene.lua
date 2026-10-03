local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local PropsClassTitle = "DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelaySceneProps%s"
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayBattleScene = BaseClass("TorchRelayBattleScene")

function TorchRelayBattleScene:__init(sceneData, logic)
  self.isActive = true
  self.sceneData = sceneData
  self.logic = logic
  self.bornDataList = {}
  self.scenePropsList = {}
  self.propsNumCheck = {}
  self.scenePropsListDic = {}
  self.scenePropsListDic[TorchRelayScenePropsMainType.Buff] = {}
  self.scenePropsListDic[TorchRelayScenePropsMainType.Obstacles] = {}
  self.startTime = 0
  self.buffRandomWeight = 0
end

function TorchRelayBattleScene:__delete()
  self.bornDataList = nil
  self.scenePropsList = nil
  self.propsNumCheck = nil
  self.scenePropsListDic = nil
  self.bornMaxDistanceItem = nil
  self.canBornMinZ = nil
  self.canBornMaxZ = nil
  self.startTime = nil
  self.buffRandomWeight = nil
end

function TorchRelayBattleScene:OnLoad(callback)
  self.loadCallback = callback
  self:LoadAsset()
end

function TorchRelayBattleScene:OnDestroy()
  self.active = false
  self:StopDropTimer()
  self:RecycleProps()
  if self.assetReq then
    self.assetReq:Destroy()
    self.assetReq = nil
  end
  self.scenePropsList = nil
  self.scenePropsListDic = nil
  self.bornDataList = nil
  self.propsNumCheck = nil
  self.bornMaxDistanceItem = nil
  self.buffRandomWeight = nil
end

function TorchRelayBattleScene:RecycleProps()
  if self.logic and self.logic.scenePropsPool and self.scenePropsList then
    for i, v in ipairs(self.scenePropsList) do
      self.logic.scenePropsPool:Recycle(v)
    end
    self.scenePropsList = nil
  end
end

function TorchRelayBattleScene:GetStartZ()
  if self.sceneData ~= nil then
    return self.sceneData.startZ
  end
  return 0
end

function TorchRelayBattleScene:GetEndZ()
  if self.sceneData ~= nil then
    return self.sceneData.endZ
  end
  return 0
end

function TorchRelayBattleScene:OnUpdate(dt)
  if self.scenePropsList ~= nil then
    for i, sceneProps in ipairs(self.scenePropsList) do
      if sceneProps.isLoaded and sceneProps.active then
        sceneProps:OnUpdate(dt)
      end
    end
  end
end

function TorchRelayBattleScene:LoadAsset()
  local req = Resource:InstantiateAsync(string.format(PVEScenePath, self.sceneData.config.asset))
  req:completed("+", function()
    if req.isError then
      req:Destroy()
      return
    end
    self.sceneRoot = req.gameObject.transform
    self.sceneRoot:Set_position(0, 0, self.sceneData.config.offset)
    if self.loadCallback then
      self.loadCallback()
      self.loadCallback = nil
    end
    self:LoadSceneProps()
  end)
  self.assetReq = req
  if self.logic and self.logic.staticMgr then
    self.logic.staticMgr:Append(string.format(PVEDecorationPath, self.sceneData.config.asset), self.sceneData.config.offset)
  end
end

function TorchRelayBattleScene:IsContainsZ(z)
  return z >= self:GetStartZ() and z < self:GetEndZ()
end

function TorchRelayBattleScene:GetPreviousScene()
  if self.logic ~= nil and self.logic.scenes ~= nil and self.sceneData ~= nil then
    for i, v in pairs(self.logic.scenes) do
      if v.sceneData and v.sceneData.index == self.sceneData.index - 1 then
        return v
      end
    end
  end
end

function TorchRelayBattleScene:GetNextScene()
  if self.logic ~= nil and self.logic.scenes ~= nil and self.sceneData ~= nil then
    for i, v in pairs(self.logic.scenes) do
      if v.sceneData and v.sceneData.index == self.sceneData.index + 1 then
        return v
      end
    end
  end
end

function TorchRelayBattleScene:LoadSceneProps()
  local randomConfigId = self.logic.data.stage:GetRandomConfigId(self.sceneData.index, self.logic)
  self.randomConfig = DataCenter.TorchRelayTemplateManager:GetStageRandomTemplate(randomConfigId)
  if self.randomConfig == nil then
    Logger.LogError(" [TorchRelay]  [LoadSceneProps]  not find config.  index\239\188\154" .. self.sceneData.index .. "  Id:" .. tostring(randomConfigId))
    return
  end
  local needInit, propsListDic = self:InitCanBornProps()
  if not needInit then
    return
  end
  self:InitAttributeAdd()
  self:InitBornDataList(propsListDic)
  self:BornDataRecord()
  self:CreateAllProps()
end

function TorchRelayBattleScene:InitAttributeAdd()
  self.buffRandomWeight = self.randomConfig.buff_num_weight * (1 + self.logic.data:GetLucky() * 1.0E-4)
end

function TorchRelayBattleScene:InitCanBornProps()
  if not self.randomConfig.propsList or #self.randomConfig.propsList <= 0 then
    return false
  end
  local propsMainTypeDic = {}
  for i, v in ipairs(self.randomConfig.propsList) do
    local propsConfig = DataCenter.TorchRelayTemplateManager:GetStageItemTemplate(v.id)
    if propsMainTypeDic[propsConfig.type] == nil then
      local typeData = {}
      typeData.totalWeight = 0
      typeData.propsList = {}
      propsMainTypeDic[propsConfig.type] = typeData
    end
    if 0 < propsConfig.num_limit then
      self.propsNumCheck[propsConfig.id] = propsConfig.num_limit
    end
    local data = propsMainTypeDic[propsConfig.type]
    data.totalWeight = data.totalWeight + v.weight
    local propsWeightData = {}
    propsWeightData.id = v.id
    propsWeightData.config = propsConfig
    propsWeightData.weight = v.weight
    table.insert(data.propsList, propsWeightData)
    propsMainTypeDic[propsConfig.type] = data
  end
  return true, propsMainTypeDic
end

function TorchRelayBattleScene:InitBornDataList(propsListDic)
  local sceneSizeZ = self:GetEndZ() - self:GetStartZ()
  Logger.Log("Cur Scene size Z: " .. sceneSizeZ)
  local canBornMinZ = self.randomConfig.minBornDistance
  local canBornMaxZ = self.randomConfig.maxBornDistance
  local deltaZ = math.random(canBornMinZ, canBornMaxZ)
  local curServerTime = UITimeManager:GetInstance():GetServerTime()
  math.randomseed(curServerTime)
  repeat
    local mainType = self:RandomPropsMainType()
    local typeData = propsListDic[mainType]
    if typeData == nil then
      self.logic:PrintRealErrorLog("\231\177\187\229\158\139\233\129\147\229\133\183\228\184\141\229\173\152\229\156\168 \232\175\165\229\156\186\230\153\175\228\184\141\229\134\141\231\148\159\230\136\144\233\129\147\229\133\183 \230\163\128\230\159\165Random\232\161\168\233\133\141\231\189\174  config id:" .. self.randomConfig.id .. "Main Type:" .. tostring(mainType))
      break
    end
    local list = typeData.propsList
    local targetProps = self:RandomProps(list)
    if targetProps == nil then
      break
    end
    local newBornData = {}
    newBornData.props = targetProps
    newBornData.configId = targetProps.config.id
    newBornData.mainType = mainType
    newBornData.propsType = targetProps.config.buff_type
    newBornData.line = targetProps.config:GetRandomLine()
    newBornData.x = self:GetOffsetX(newBornData.line)
    if self.randomConfig and self.randomConfig.buff_fall == 1 then
      newBornData.dropToFloor = true
      newBornData.y = 15
    else
      newBornData.dropToFloor = false
      newBornData.y = 0
    end
    newBornData.z = 0
    local preBornData
    if self.bornMaxDistanceItem ~= nil then
      if newBornData.line == self.bornMaxDistanceItem.line or newBornData.line == TorchRelayScenePropsBornLine.Middle or self.bornMaxDistanceItem.line == TorchRelayScenePropsBornLine.Middle then
        preBornData = self.bornMaxDistanceItem
      else
        local index = #self.bornDataList
        while 0 < index do
          local bornDataCache = self.bornDataList[index]
          if bornDataCache.line == newBornData.line or bornDataCache.line == TorchRelayScenePropsBornLine.Middle then
            preBornData = bornDataCache
            break
          end
          index = index - 1
        end
      end
    end
    local originZ = 0
    if preBornData == nil and self.sceneData.index == 1 then
      originZ = self.logic.data.stage.start_position
    elseif preBornData ~= nil then
      originZ = preBornData.z
    end
    newBornData.z = originZ + deltaZ
    if self.bornMaxDistanceItem == nil or newBornData.z > self.bornMaxDistanceItem.z then
      self.bornMaxDistanceItem = newBornData
    end
    table.insert(self.bornDataList, newBornData)
    local bound = newBornData.props.config.length * 0.5
    canBornMinZ = math.max(bound, self.randomConfig.minBornDistance)
    deltaZ = math.random(canBornMinZ, canBornMaxZ)
  until sceneSizeZ < newBornData.z + deltaZ
  for i, v in ipairs(self.bornDataList) do
    Logger.Log("Props id:" .. v.props.id .. "   line:" .. v.line .. "   pos:" .. string.format("( %s , %s )", v.x, v.z))
  end
end

function TorchRelayBattleScene:CreateAllProps()
  for i, v in ipairs(self.bornDataList) do
    local param = {}
    param.propsType = v.propsType
    param.bornData = v
    param.sceneRoot = self.sceneRoot
    param.logic = self.logic
    self.scenePropsList[i] = self.logic.scenePropsPool:Get(param)
    table.insert(self.scenePropsListDic[v.props.config.type], self.scenePropsList[i])
  end
end

function TorchRelayBattleScene:RandomPropsMainType()
  if self.buffRandomWeight >= 10000 then
    return TorchRelayScenePropsMainType.Buff
  elseif self.buffRandomWeight <= 0 then
    return TorchRelayScenePropsMainType.Obstacles
  end
  local randomNum = math.random(1, 10000)
  if randomNum <= self.buffRandomWeight then
    return TorchRelayScenePropsMainType.Buff
  end
  return TorchRelayScenePropsMainType.Obstacles
end

function TorchRelayBattleScene:RandomProps(list)
  local totalWeight = 0
  local randomList = {}
  for i, v in ipairs(list) do
    if not self.propsNumCheck[v.id] or 0 < self.propsNumCheck[v.config.id] then
      totalWeight = totalWeight + v.weight
      table.insert(randomList, v)
    end
  end
  if table.count(randomList) == 0 then
    return
  end
  return self:RandomPropsReal(randomList, totalWeight)
end

function TorchRelayBattleScene:RandomPropsReal(list, totalWeight)
  local tarWeight = math.random(1, totalWeight)
  local curWeight = 0
  for i, v in ipairs(list) do
    curWeight = curWeight + v.weight
    if tarWeight <= curWeight then
      if self.propsNumCheck[v.config.id] then
        if 0 < self.propsNumCheck[v.config.id] then
          self.propsNumCheck[v.config.id] = self.propsNumCheck[v.config.id] - 1
          return v
        else
          Logger.LogError("[TorchRelay]\228\184\141\229\186\148\232\175\165\232\181\176\229\136\176\232\191\153\233\135\140\229\149\138")
        end
      else
        return v
      end
    end
  end
  Logger.LogError(" [TorchRelay] [RandomProps]   tarWeight weight is " .. tarWeight .. ",   can't match it!")
end

function TorchRelayBattleScene:GetOffsetX(line)
  if line == TorchRelayScenePropsBornLine.Left then
    return TorchConstant.PROPS_BORN_LINE_LEFT_X
  elseif line == TorchRelayScenePropsBornLine.Middle then
    return TorchConstant.PROPS_BORN_LINE_MIDDLE_X
  else
    return TorchConstant.PROPS_BORN_LINE_RIGHT_X
  end
end

function TorchRelayBattleScene:GetScenePropsListByType(mainType)
  return self.scenePropsListDic[mainType]
end

function TorchRelayBattleScene:DropAllItems()
  if self.dropTimerFunc == nil then
    function self.dropTimerFunc(temp)
      self:OnDropTimerTriggered(temp)
    end
  end
  if self.dropTimer == nil then
    self.dropTimer = TimerManager:GetInstance():GetTimer(0.3, self.dropTimerFunc, nil, false, false, false)
  end
  self.dropTimer:Start()
end

function TorchRelayBattleScene:OnDropTimerTriggered()
  local function GetNextDropItem()
    if self.scenePropsList then
      for i, v in pairs(self.scenePropsList) do
        if v.bornData and v.bornData.dropToFloor then
          return v
        end
      end
    end
  end
  
  local dropItem = GetNextDropItem()
  if not dropItem then
    self:StopDropTimer()
    return
  else
    dropItem:DoDropToFloor()
  end
end

function TorchRelayBattleScene:StopDropTimer()
  if self.dropTimer ~= nil then
    self.dropTimer:Stop()
    self.dropTimer = nil
  end
end

function TorchRelayBattleScene:BornDataRecord()
end

return TorchRelayBattleScene
