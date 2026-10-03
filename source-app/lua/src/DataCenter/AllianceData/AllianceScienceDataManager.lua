local AllianceScienceDataManager = BaseClass("AllianceScienceDataManager")

local function __init(self)
  self.alScienceList = {}
  self.alScienceEffectDic = {}
  self.maxNum = 0
  self.useNum = 0
  self.useGoldNum = 0
  self.maxGoldNum = 0
  self.timePoint = 0
  self.refreshTimeBlock = 0
end

local function InitData(self)
  self:InitAllScience()
end

local function __delete(self)
  self.alScienceList = nil
  self.alScienceEffectDic = nil
  self.maxNum = nil
  self.useNum = nil
  self.useGoldNum = nil
  self.maxGoldNum = nil
  self.timePoint = nil
  self.refreshTimeBlock = nil
end

local function InitAllScience(self)
  self.alScienceList = {}
  for i = 1, AlScienceMaxTab do
    local scienceList = self:GetScienceRowList(i)
    for j = 1, table.count(scienceList) do
      local listData = scienceList[j]
      for k = 1, table.count(listData) do
        local data = listData[k]
        local oneSciencedata = AllianceScienceData.New()
        oneSciencedata.scienceId = data.id
        oneSciencedata.maxLevel = data.max_lv
        oneSciencedata.icon = data.icon
        oneSciencedata.name = data.name
        oneSciencedata.info = data.info
        oneSciencedata.description = data.description
        oneSciencedata.description_tip = data.description_tip
        oneSciencedata.position = data.position
        oneSciencedata.rolation = data.relation
        self.alScienceList[oneSciencedata.scienceId] = oneSciencedata
      end
    end
  end
end

local function GetShowRedScienceId(self, tabIndex)
  local rowList = self:GetScienceRowList(tabIndex)
  local retScienceList = {}
  for j = 1, table.count(rowList) do
    local scienceList = rowList[j]
    local isShowRedColumn = false
    for k = 1, table.count(scienceList) do
      local data = scienceList[k]
      local info = self:GetOneAllianceScienceById(data.id)
      if info.curLevel < info.maxLevel then
        isShowRedColumn = true
        if info.currentPro < info.needPro then
          table.insert(retScienceList, info.scienceId)
        end
      end
    end
    if isShowRedColumn then
      return retScienceList
    end
  end
end

local function GetScienceRowList(self, tab)
  local showList = {}
  local rowList = DataCenter.AllianceScienceDataManager:GetAllianceScienceListByTab(tab)
  if rowList ~= nil then
    table.walk(rowList, function(k, v)
      local position = v.position
      local position_vec = string.split_ss_array(position, ";")
      if #position_vec == 2 then
        local column = tonumber(position_vec[1])
        if showList[column] == nil then
          showList[column] = {}
        end
        table.insert(showList[column], v)
      end
    end)
  end
  return showList
end

local function GetResDonateRestCount(self)
  return self.useNum
end

local function GetResDonateMaxCount(self)
  return self.maxNum
end

local function GetGoldDonateRestCount(self)
  return self.useGoldNum
end

local function GetGoldDonateMaxCount(self)
  return self.maxGoldNum
end

local function GetTimePoint(self)
  return self.timePoint
end

local function GetRefreshTimeBlock(self)
  return self.refreshTimeBlock
end

local function UpdateAllianceScienceServer(self, message)
  if not self.alScienceList then
    self.alScienceList = {}
  end
  local idx = 1
  if message.allianceScience ~= nil then
    table.walk(message.allianceScience, function(k, v)
      local scienceId = v.scienceId
      if 0 < scienceId then
        if self.alScienceList[scienceId] then
          self.alScienceList[scienceId]:ParseData(v)
        end
        if idx == 1 then
          idx = 2
          SFSNetwork.SendMessage(MsgDefines.AlScienceNumFresh, v.scienceId)
        end
      end
    end)
    self:UpdateAllianceScienceEffect()
  end
  self.getAllianceTechMessage = true
end

local function UpdateOneAllianceScience(self, message)
  if message.scienceId ~= nil then
    local id = message.scienceId
    if self.alScienceList[id] ~= nil then
      self.alScienceList[id]:ParseData(message)
      self:UpdateAllianceScienceEffect()
    end
  end
end

local function UpdateAllianceScienceRecommend(self, msg)
  for i, v in pairs(self.alScienceList) do
    v.state = 0
  end
  if msg.scienceId and 0 < tonumber(msg.scienceId) then
    self.alScienceList[msg.scienceId].state = 1
  end
  EventManager:GetInstance():Broadcast(EventId.OnAlScienceRecommendChange, msg.scienceId)
end

local function GetCurRecommendScience(self)
  for _, v in pairs(self.alScienceList) do
    if v.state == 1 then
      return v
    end
  end
  return nil
end

local function FindCanRecommendScience(self)
  local recommendScience
  if SeasonUtil.IsInSeason() and SeasonUtil.HasAllianceScienceData() then
    recommendScience = self:FindCanRecommendScienceByTab(3)
  end
  if recommendScience ~= nil then
    return recommendScience
  end
  for i = 1, 2 do
    local science = self:FindCanRecommendScienceByTab(i)
    if science ~= nil then
      return science
    end
  end
  return recommendScience
end

local function FindCanRecommendScienceByTab(self, tab)
  local recommendScience
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local rowList = self:GetScienceRowList(tab)
  local maxPro = -1
  for j = 1, table.count(rowList) do
    local scienceList = rowList[j]
    for k = 1, table.count(scienceList) do
      local data = scienceList[k]
      local info = self:GetOneAllianceScienceById(data.id)
      if info.curLevel >= info.maxLevel or info.needPro ~= 0 and info.currentPro >= info.needPro or curTime < info.finishTime or info.state == 1 or self:CheckIsLock(info) then
        break
      end
      if maxPro < info.currentPro then
        maxPro = info.currentPro
        recommendScience = info
      end
    end
  end
  return recommendScience
end

local function CheckIsLock(self, scienceData)
  if scienceData.science_condition ~= nil and scienceData.science_condition ~= "" then
    local condition_vec = string.split_ss_array(scienceData.science_condition, ";")
    for k = 1, #condition_vec do
      local condition = condition_vec[k]
      local level = tonumber(string.sub(condition, -2))
      local id = tonumber(condition) - level
      local pSciencedata = self:GetOneAllianceScienceById(id)
      if pSciencedata ~= nil then
        local curLevel = pSciencedata.curLevel
        if level <= curLevel then
        else
          return true
        end
      end
    end
  end
  return false
end

local function UpdateAllianceScienceEffect(self)
  self.alScienceEffectDic = {}
  for k, oneData in pairs(self.alScienceList) do
    local effectKey = oneData.para1
    local effectValue = oneData.para2
    local effectKey_arr = string.split_ii_array(effectKey, ";")
    local effectValue_arr = string.split_ss_array(effectValue, ";")
    for i = 1, table.count(effectKey_arr) do
      local eK = effectKey_arr[i]
      local eV = 0
      if effectValue_arr[i] ~= nil then
        eV = tonumber(effectValue_arr[i])
      end
      if self.alScienceEffectDic[eK] ~= nil then
        eV = self.alScienceEffectDic[eK] + eV
      end
      self.alScienceEffectDic[eK] = eV
    end
  end
end

local function GetAllianceScienceListByTab(self, tab)
  return DataCenter.AllianceScienceTemplateManager:GetAlScienceTabTemplate(tab)
end

local function GetOneAllianceScienceById(self, alScienceId)
  return self.alScienceList[alScienceId]
end

local function EndRefreshAllScienceNum(self, message)
  if message.maxNum ~= nil then
    self.maxNum = message.maxNum
  end
  if message.useNum ~= nil then
    self.useNum = message.useNum
  end
  if message.maxGoldNum ~= nil then
    self.maxGoldNum = message.maxGoldNum
  end
  if message.useGoldNum ~= nil then
    self.useGoldNum = message.useGoldNum
  end
  if message.timePoint ~= nil then
    self.timePoint = message.timePoint
  end
  if message.refreshTimeBlock ~= nil then
    self.refreshTimeBlock = message.refreshTimeBlock
  end
  if message.accPoint ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.accPoint)
  end
  if message.alliancepoint ~= nil then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil then
      data.alliancePoint = message.alliancepoint
      DataCenter.AllianceShopDataManager:SetAlliancePoint(message.alliancepoint)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end

local function GetCurrentSearchScience(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.alScienceList) do
    if curTime < v.finishTime then
      return v
    end
  end
end

local function GetAllianceScienceEffectById(self, effect)
  local effectValue = 0
  if self.alScienceEffectDic[effect] ~= nil then
    effectValue = self.alScienceEffectDic[effect]
  end
  return effectValue
end

local function GetAllianceScienceRedpointCount(self)
  local curNum = self:GetResDonateRestCount()
  return curNum
end

function AllianceScienceDataManager:OnLeaveAlliance()
  self.alScienceEffectDic = {}
end

local function GetCanDonate(self)
  if self.useNum <= 0 then
    return false
  end
  return true
end

AllianceScienceDataManager.__init = __init
AllianceScienceDataManager.__delete = __delete
AllianceScienceDataManager.InitData = InitData
AllianceScienceDataManager.InitAllScience = InitAllScience
AllianceScienceDataManager.GetScienceRowList = GetScienceRowList
AllianceScienceDataManager.GetResDonateRestCount = GetResDonateRestCount
AllianceScienceDataManager.GetResDonateMaxCount = GetResDonateMaxCount
AllianceScienceDataManager.GetGoldDonateRestCount = GetGoldDonateRestCount
AllianceScienceDataManager.GetGoldDonateMaxCount = GetGoldDonateMaxCount
AllianceScienceDataManager.GetTimePoint = GetTimePoint
AllianceScienceDataManager.GetRefreshTimeBlock = GetRefreshTimeBlock
AllianceScienceDataManager.UpdateAllianceScienceServer = UpdateAllianceScienceServer
AllianceScienceDataManager.UpdateOneAllianceScience = UpdateOneAllianceScience
AllianceScienceDataManager.GetAllianceScienceListByTab = GetAllianceScienceListByTab
AllianceScienceDataManager.GetOneAllianceScienceById = GetOneAllianceScienceById
AllianceScienceDataManager.EndRefreshAllScienceNum = EndRefreshAllScienceNum
AllianceScienceDataManager.GetCurrentSearchScience = GetCurrentSearchScience
AllianceScienceDataManager.GetAllianceScienceEffectById = GetAllianceScienceEffectById
AllianceScienceDataManager.UpdateAllianceScienceEffect = UpdateAllianceScienceEffect
AllianceScienceDataManager.GetShowRedScienceId = GetShowRedScienceId
AllianceScienceDataManager.UpdateAllianceScienceRecommend = UpdateAllianceScienceRecommend
AllianceScienceDataManager.GetAllianceScienceRedpointCount = GetAllianceScienceRedpointCount
AllianceScienceDataManager.GetCurRecommendScience = GetCurRecommendScience
AllianceScienceDataManager.FindCanRecommendScience = FindCanRecommendScience
AllianceScienceDataManager.FindCanRecommendScienceByTab = FindCanRecommendScienceByTab
AllianceScienceDataManager.CheckIsLock = CheckIsLock
AllianceScienceDataManager.GetCanDonate = GetCanDonate
return AllianceScienceDataManager
