local ScienceManager = BaseClass("ScienceManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.scienceTab = {}
end

local function __delete(self)
  self.scienceTab = nil
end

local function PushScienceChangeHandle(self, message)
  if message.science ~= nil then
    DataCenter.ScienceDataManager:UpdateOneData(message.science)
    local scienceId = message.science.itemId
    local template = self:GetScienceTemplate(scienceId)
    if template ~= nil then
      DataCenter.BuildManager:CheckShowBuildUnlockWhenScienceLevelUp(scienceId, template.level)
    end
    if message.scienceTabProgress ~= nil then
      DataCenter.ScienceDataManager:UpdateScienceTabProgress(message.scienceTabProgress)
    end
    EventManager:GetInstance():Broadcast(EventId.UPDATE_SCIENCE_DATA, message.science.itemId)
    if scienceId == 90002200 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelBoxTechUpPop, {anim = true}, 1)
    elseif scienceId == 90006200 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelBoxTechUpPop, {anim = true}, 2)
    end
  end
end

local function ScienceResearchNewMessageHandle(self, message)
  if message.errorCode == nil then
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    if message.gold ~= nil then
      LuaEntry.Player.gold = message.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if message.goodsRest ~= nil then
      DataCenter.ItemData:UpdateItems(message.goodsRest)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    end
    DataCenter.ResourceItemDataManager:RefreshItemList(message.rescource_item)
    local queue = message.queue
    if queue ~= nil then
      local itemObj = queue.itemObj
      if not table.IsNullOrEmpty(itemObj) then
        local itemId = itemObj.itemId
        DataCenter.QueueDataManager:UpdateQueueData(queue)
        local bUuid = queue.funcUuid
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(tonumber(bUuid))
        if buildData ~= nil then
          local signal = SFSObject.New()
          signal:PutLong("bUuid", buildData.uuid)
          signal:PutInt("queueType", NewQueueType.Science)
          signal:PutInt("itemId", itemId)
          EventManager:GetInstance():Broadcast(EventId.OnScienceQueueResearch, signal)
        end
      end
      local arrays = queue.itemCostArr
      if arrays ~= nil then
        for k, v in pairs(arrays) do
          DataCenter.ItemData:UpdateOneItem(v)
        end
      end
    end
    if message.science ~= nil then
      DataCenter.ScienceDataManager:UpdateOneData(message.science)
      local scienceId = message.science.itemId
      local template = self:GetScienceTemplate(scienceId)
      if template ~= nil then
        local alhelpData = DataCenter.AllianceHelpDataManager:GetSelfAllianceHelp(scienceId)
        UIUtil.ShowTips(Localization:GetString("200192", Localization:GetString(template.name)))
        DataCenter.BuildManager:CheckShowBuildUnlockWhenScienceLevelUp(scienceId, template.level)
      end
      EventManager:GetInstance():Broadcast(EventId.UPDATE_SCIENCE_DATA, scienceId)
    end
    if message.robot ~= nil then
      DataCenter.BuildQueueManager:UpdateQueueData(message.robot)
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function GetScienceTemplate(self, id)
  local level = self:GetScienceLevel(id)
  if level <= 0 then
    level = 1
  end
  return DataCenter.ScienceTemplateManager:GetScienceTemplate(id, level)
end

local function GetScienceName(self, id)
  local template = self:GetScienceTemplate(id)
  if template then
    return Localization:GetString(template.name)
  end
  return ""
end

local function GetScienceLevel(self, id)
  local science = DataCenter.ScienceDataManager:GetScienceById(id)
  if science ~= nil then
    return science.level
  end
  return 0
end

local function GetScienceMaxLevel(self, id)
  local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id)
  if template ~= nil then
    return template.max_level
  end
  return 0
end

local function GetScienceQueue(self)
  return DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Science)
end

local function GetScienceQueueByScienceId(self, scienceId)
  return DataCenter.QueueDataManager:GetQueueByScienceId(scienceId)
end

local function CheckResearchFinish(self)
  local queue = self:GetScienceQueue()
  if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
    local param = {}
    param.uuid = queue.uuid
    SFSNetwork.SendMessage(MsgDefines.QueueFinish, param)
    return true
  end
  return false
end

local function CheckResearchFinishByBuildUuid(self, bUuid)
  local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(bUuid)
  if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
    local param = {}
    param.uuid = queue.uuid
    SFSNetwork.SendMessage(MsgDefines.QueueFinish, param)
    return true
  end
  return false
end

local function GetSearchingScienceTemplate(self, uuid)
  local queue = DataCenter.QueueDataManager:GetQueueByUuid(uuid)
  if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" then
    local id = tonumber(queue.itemId)
    local level = 1
    local science = DataCenter.ScienceDataManager:GetScienceById(id)
    if science ~= nil then
      level = science.level + 1
    end
    return DataCenter.ScienceTemplateManager:GetScienceTemplate(id, level)
  end
end

local function HasScienceByIdAndLevel(self, id, level)
  local temp = DataCenter.ScienceDataManager:GetScienceById(id)
  return temp ~= nil and level <= temp.level
end

local function HasScienceById(self, id)
  local level = id % ScienceLevelCap
  local baseId = id - level
  return self:HasScienceByIdAndLevel(baseId, level)
end

local function GetGiftPack()
  local pack
  local str = LuaEntry.DataConfig:TryGetStr("building_recharge", "k1")
  if not string.IsNullOrEmpty(str) then
    local packId = string.split(str, ";")[2]
    pack = GiftPackManager.get(packId)
  end
  return pack
end

local function OpenScienceGiftView()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceGift)
end

local function HasUnlockSecondQueue()
  local queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science) or {}
  for _, v in pairs(queueList) do
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.funcUuid)
    if buildData and buildData.itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO then
      return true
    end
  end
  return false
end

local function HasExtraQueue()
  local queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science) or {}
  local queueCount = table.count(queueList)
  return 2 <= queueCount
end

local function GetHighestScienceBuildingLevel(self)
  local buildA = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_SCIENE)
  local hightestLevel = 0
  if buildA ~= nil then
    hightestLevel = buildA.level
  end
  local buildB = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
  if buildB ~= nil and hightestLevel < buildB.level then
    hightestLevel = buildB.level
  end
  local buildC = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_THREE)
  if buildC ~= nil and hightestLevel < buildC.level then
    hightestLevel = buildC.level
  end
  return hightestLevel
end

local function IsScienceBuild(self, buildId)
  return buildId == BuildingTypes.FUN_BUILD_SCIENE or buildId == BuildingTypes.LW_BUILE_SCIENCE_TWO
end

ScienceManager.__init = __init
ScienceManager.__delete = __delete
ScienceManager.PushScienceChangeHandle = PushScienceChangeHandle
ScienceManager.ScienceResearchNewMessageHandle = ScienceResearchNewMessageHandle
ScienceManager.GetScienceTemplate = GetScienceTemplate
ScienceManager.GetScienceName = GetScienceName
ScienceManager.GetScienceLevel = GetScienceLevel
ScienceManager.GetScienceMaxLevel = GetScienceMaxLevel
ScienceManager.GetScienceQueue = GetScienceQueue
ScienceManager.CheckResearchFinish = CheckResearchFinish
ScienceManager.GetSearchingScienceTemplate = GetSearchingScienceTemplate
ScienceManager.HasScienceByIdAndLevel = HasScienceByIdAndLevel
ScienceManager.HasScienceById = HasScienceById
ScienceManager.GetScienceQueueByScienceId = GetScienceQueueByScienceId
ScienceManager.CheckResearchFinishByBuildUuid = CheckResearchFinishByBuildUuid
ScienceManager.GetGiftPack = GetGiftPack
ScienceManager.OpenScienceGiftView = OpenScienceGiftView
ScienceManager.HasUnlockSecondQueue = HasUnlockSecondQueue
ScienceManager.GetHighestScienceBuildingLevel = GetHighestScienceBuildingLevel
ScienceManager.IsScienceBuild = IsScienceBuild
ScienceManager.HasExtraQueue = HasExtraQueue
return ScienceManager
