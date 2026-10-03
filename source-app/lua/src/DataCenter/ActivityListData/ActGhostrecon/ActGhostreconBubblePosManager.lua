local ActGhostreconBubblePosManager = BaseClass("ActGhostreconBubblePosManager")
local PrefabAssetPath = "Assets/Main/Prefabs/UI/ActivityCenter/Ghostrecon/%s.prefab"

local function __init(self)
  self.allBubble = nil
  self.randomPoolIndex = 0
  self.seasonSettings = nil
  self.loaded = false
end

local function __delete(self)
  self.allBubble = nil
  self.randomPoolIndex = nil
  self.seasonSettings = nil
  self.loaded = false
end

local function LoadBubblePosInfos(self, taskUUids)
  self:InitSeasonSettings()
  local curSetting = self:GetCurSetting()
  if curSetting == nil then
    return
  end
  if not self.loaded then
    self.loaded = true
    self.randomPoolIndex = CommonUtil.PlayerPrefsGetInt(SettingKeys.GHOSTRECON_BUBBLE_RANDOM_INDEX, #curSetting.poolNums)
    if self.randomPoolIndex < 1 or self.randomPoolIndex > #curSetting.poolNums then
      self.randomPoolIndex = 1
    end
    self.allBubble = {}
    for index, bubbleNum in ipairs(curSetting.poolNums) do
      local pool = {}
      for i = 1, bubbleNum do
        local posInfo = {}
        posInfo.poolIndex = index
        posInfo.index = i
        table.insert(pool, posInfo)
      end
      table.insert(self.allBubble, pool)
    end
    local allBubbleStr = CommonUtil.PlayerPrefsGetString(SettingKeys.GHOSTRECON_BUBBLE_POSINFO, "")
    local split1 = string.split(allBubbleStr, "|")
    for index, value in ipairs(split1) do
      if not string.IsNullOrEmpty(value) then
        local split2 = string.split(value, ",")
        local poolIndex = tonumber(split2[1])
        local index = tonumber(split2[2])
        if self.allBubble[poolIndex] and self.allBubble[poolIndex][index] then
          self.allBubble[poolIndex][index].uuid = tonumber(split2[3])
        end
      end
    end
  end
  local needReInit = false
  local needAddUUids = {}
  local needRemoveUUids = {}
  if not needReInit then
    local saveUUids = {}
    for poolIndex, pool in ipairs(self.allBubble) do
      for bubbleIndex, bubble in ipairs(pool) do
        if bubble.uuid then
          saveUUids[bubble.uuid] = 1
          if taskUUids[bubble.uuid] == nil then
            needRemoveUUids[bubble.uuid] = 1
          end
        end
      end
    end
    if not needReInit then
      for key, value in pairs(taskUUids) do
        if saveUUids[key] == nil then
          needAddUUids[key] = 1
        end
      end
    end
  end
  if needReInit then
    self.allBubble = {}
    for index, bubbleNum in ipairs(curSetting.poolNums) do
      local pool = {}
      for i = 1, bubbleNum do
        local posInfo = {}
        posInfo.poolIndex = index
        posInfo.index = i
        table.insert(pool, posInfo)
      end
      table.insert(self.allBubble, pool)
    end
    needAddUUids = taskUUids
  end
  local needSave = false
  for key, value in pairs(needAddUUids) do
    self:AddPointByUUid(key)
    needSave = true
  end
  for key, value in pairs(needRemoveUUids) do
    self:RemovePointByUUid(key)
    needSave = true
  end
  if needSave then
    self:SaveBubblePosInfos()
  end
end

local function GetPointByUUid(self, uuid)
  if self.allBubble == nil then
    self:LoadBubblePosInfos()
  end
  local poolId, bubbleId
  for poolIndex, pool in ipairs(self.allBubble) do
    for bubbleIndex, bubble in ipairs(pool) do
      if bubble.uuid == uuid then
        poolId = poolIndex
        bubbleId = bubbleIndex
        break
      end
    end
  end
  return poolId, bubbleId
end

local function SaveBubblePosInfos(self)
  if self.allBubble then
    local str
    for _, pool in ipairs(self.allBubble) do
      for _, bubble in ipairs(pool) do
        if bubble.uuid then
          local itemStr = bubble.poolIndex .. "," .. bubble.index .. "," .. bubble.uuid
          if str == nil then
            str = itemStr
          else
            str = str .. "|" .. itemStr
          end
        end
      end
    end
    CommonUtil.PlayerPrefsSetString(SettingKeys.GHOSTRECON_BUBBLE_POSINFO, str)
    CommonUtil.PlayerPrefsSetInt(SettingKeys.GHOSTRECON_BUBBLE_RANDOM_INDEX, self.randomPoolIndex)
  end
end

local function AddPointByUUid(self, uuid)
  local curSetting = self:GetCurSetting()
  local poolId, bubbleId
  for i = 1, #curSetting.poolNums do
    self.randomPoolIndex = self.randomPoolIndex + 1
    if self.randomPoolIndex > #curSetting.poolNums then
      self.randomPoolIndex = 1
    end
    poolId = self.randomPoolIndex
    bubbleId = self:GetFreeIndexByPoolIndex(self.randomPoolIndex)
    if bubbleId then
      break
    end
  end
  if bubbleId == nil then
    Logger.LogInfo("ActGhostreconBubblePosManager is Full")
  else
    self.allBubble[poolId][bubbleId].uuid = uuid
  end
end

local function GetFreeIndexByPoolIndex(self, poolIndex)
  local index
  local freeIndex = {}
  for index, value in ipairs(self.allBubble[poolIndex]) do
    if value.uuid == nil then
      table.insert(freeIndex, index)
    end
  end
  if 0 < #freeIndex then
    index = table.randomArrayValue(freeIndex)
  end
  return index
end

local function RemovePointByUUid(self, uuid)
  local poolId, bubbleId = self:GetPointByUUid(uuid)
  if poolId and bubbleId then
    self.allBubble[poolId][bubbleId].uuid = nil
  end
end

local function InitSeasonSettings(self)
  if self.seasonSettings == nil then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
    local para_4
    if actData and actData[1] and not string.IsNullOrEmpty(actData[1].para_4) then
      para_4 = actData[1].para_4
    end
    if para_4 then
      self.seasonSettings = {}
      local split1 = string.split(para_4, "|")
      for index, value in ipairs(split1) do
        local split2 = string.split(value, ",")
        local data = {}
        data.season = split2[1]
        data.prefabPath = split2[2]
        data.poolNums = {}
        for i = 3, #split2 do
          table.insert(data.poolNums, tonumber(split2[i]))
        end
        self.seasonSettings[tonumber(split2[1])] = data
      end
    end
  end
end

local function GetCurSetting(self)
  local season = DataCenter.SeasonDataManager:GetSeason() or 0
  local curSetting = self.seasonSettings[season] or self.seasonSettings[-1]
  return curSetting
end

local function GetBubblePanelPrefabPath(self)
  local curSetting = self:GetCurSetting()
  return string.format(PrefabAssetPath, curSetting.prefabPath)
end

ActGhostreconBubblePosManager.__init = __init
ActGhostreconBubblePosManager.__delete = __delete
ActGhostreconBubblePosManager.LoadBubblePosInfos = LoadBubblePosInfos
ActGhostreconBubblePosManager.SaveBubblePosInfos = SaveBubblePosInfos
ActGhostreconBubblePosManager.GetPointByUUid = GetPointByUUid
ActGhostreconBubblePosManager.AddPointByUUid = AddPointByUUid
ActGhostreconBubblePosManager.RemovePointByUUid = RemovePointByUUid
ActGhostreconBubblePosManager.GetFreeIndexByPoolIndex = GetFreeIndexByPoolIndex
ActGhostreconBubblePosManager.InitSeasonSettings = InitSeasonSettings
ActGhostreconBubblePosManager.GetCurSetting = GetCurSetting
ActGhostreconBubblePosManager.GetBubblePanelPrefabPath = GetBubblePanelPrefabPath
return ActGhostreconBubblePosManager
