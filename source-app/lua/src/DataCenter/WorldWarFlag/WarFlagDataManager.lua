local WarFlagDataManager = BaseClass("WarFlagDataManager")
local WarFlagData = require("DataCenter.WorldWarFlag.WarFlagData")
local WarFlagMeta = require("DataCenter.WorldWarFlag.WarFlagMeta")

function WarFlagDataManager:__init()
  self.allAffectMe = {}
  self.allEffect = {}
  if not LocalController:instance():hasTable(TableName.LW_War_Flag) then
    return
  end
  self.allData = {}
  self.allMeta = {}
  LocalController:instance():visitTable(TableName.LW_War_Flag, function(id, lineData)
    if lineData ~= nil then
      local meta = WarFlagMeta.New()
      meta:InitConfig(lineData)
      if meta.id ~= nil then
        self.allMeta[meta.id] = meta
      end
    end
  end)
  self:AddUpdateTimer()
  self:AddListener()
end

function WarFlagDataManager:__delete()
  self:Destroy()
end

function WarFlagDataManager:Destroy()
  self:RemoveUpdateTimer()
  self:RemoveListener()
  self.allData = {}
  self.allMeta = {}
  self.allAffectMe = {}
  self.allEffect = {}
  self.isEffectDirty = nil
end

function WarFlagDataManager:AddListener()
  if not self.setEventListener then
    self.setEventListener = true
    EventManager:GetInstance():AddListener(EventId.OnExitWorldState, self.OnExitWorld)
    EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    EventManager:GetInstance():AddListener(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
    EventManager:GetInstance():AddListener(EventId.MoveCityPostProcess, self.OnMoveCityPostProcess)
  end
end

function WarFlagDataManager:RemoveListener()
  if self.setEventListener then
    EventManager:GetInstance():RemoveListener(EventId.OnExitWorldState, self.OnExitWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    EventManager:GetInstance():RemoveListener(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
    EventManager:GetInstance():RemoveListener(EventId.MoveCityPostProcess, self.OnMoveCityPostProcess)
    self.setEventListener = false
  end
end

function WarFlagDataManager:OnInitMessage()
  SFSNetwork.SendMessage(MsgDefines.WorldFlagGetCanEffect)
  if not self.curServerId then
    self.curServerId = LuaEntry.Player:GetCurServerId()
  end
end

function WarFlagDataManager:OnExitWorld()
  SFSNetwork.SendMessage(MsgDefines.WorldFlagGetCanEffect)
end

function WarFlagDataManager:OnEnterCrossServer()
  local self = DataCenter.WarFlagDataManager
  if self.curServerId and SeasonUtil.IsInSameMap(self.curServerId, ServerEnum.View) then
    return
  end
  self.curServerId = LuaEntry.Player:GetCurServerId()
  DataCenter.WarFlagDataManager:RemoveAllWarFlags()
end

function WarFlagDataManager:OnQuitCrossServer()
  local self = DataCenter.WarFlagDataManager
  if self.curServerId and SeasonUtil.IsInSameMap(self.curServerId, ServerEnum.View) then
    return
  end
  self.curServerId = LuaEntry.Player:GetCurServerId()
  SFSNetwork.SendMessage(MsgDefines.WorldFlagGetCanEffect)
end

function WarFlagDataManager:OnMoveCityPostProcess()
  DataCenter.WarFlagDataManager:RefreshAllAffectMe()
end

function WarFlagDataManager:HandleFlagAboutMe(msg)
  if self.allData == nil then
    return
  end
  self:RemoveAllWarFlags()
  if msg and msg.flags then
    for _, v in pairs(msg.flags) do
      local newWarFlagData = WarFlagData.New(v)
      self.allData[v.uuid] = newWarFlagData
    end
    self:RefreshAllAffectMe()
  end
  EventManager:GetInstance():Broadcast(EventId.WarFlagAdd)
end

function WarFlagDataManager:CreateWarFlags(msg)
  if msg and msg.flags then
    for _, v in pairs(msg.flags) do
      self:AddOrUpdateOneFlag(v)
    end
  end
end

function WarFlagDataManager:HandleOneFlagRemove(uuid)
  if self.allData[uuid] then
    local flagData = self.allData[uuid]
    self:RemoveOneFlag(flagData)
  end
end

function WarFlagDataManager:PushOneWarFlag(msg)
  self:AddOrUpdateOneFlag(msg)
  EventManager:GetInstance():Broadcast(EventId.WarFlagAdd)
end

function WarFlagDataManager:AddOrUpdateOneFlag(msg)
  if self.allData == nil then
    return
  end
  if self.allData[msg.uuid] then
    self.allData[msg.uuid]:ParseData(msg)
  else
    local newWarFlagData = WarFlagData.New(msg)
    self.allData[msg.uuid] = newWarFlagData
    self:AddAffectMe(newWarFlagData)
  end
  DataCenter.WarFlagManager:AddOrUpdateOneFlag(self.allData[msg.uuid])
end

function WarFlagDataManager:RemoveAllWarFlags()
  if self.allData == nil then
    return
  end
  DataCenter.WarFlagManager:RemoveAllWarFlags()
  for _, v in pairs(self.allData) do
    v:Destroy()
  end
  self.allEffect = {}
  self.allData = {}
  self.allAffectMe = {}
  self.isEffectDirty = false
end

function WarFlagDataManager:RemoveOneFlag(flagData)
  local uuid = flagData.uuid
  self:RemoveAffectMe(flagData)
  DataCenter.WarFlagManager:RemoveOneFlag(uuid)
  flagData:Destroy()
  self.allData[uuid] = nil
end

function WarFlagDataManager:GetMeta(metaId)
  if self.allData == nil then
    return nil
  end
  return self.allMeta[metaId]
end

function WarFlagDataManager:AddUpdateTimer()
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function WarFlagDataManager:RemoveUpdateTimer()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function WarFlagDataManager:OnUpdateSec()
  local now = UITimeManager:GetInstance():GetServerTime()
  for uuid, v in pairs(self.allData) do
    if now > v.endTime then
      self:RemoveOneFlag(v)
    end
  end
end

function WarFlagDataManager:GetAllFlagAffectMe()
  return self:GetFlagBuffByWorldIndex(LuaEntry.Player:GetMainWorldPos(), LuaEntry.Player:GetSelfServerId())
end

function WarFlagDataManager:GetFlagBuffByWorldIndex(index, serverId)
  if index <= 0 then
    return {}
  end
  if self.allData == nil then
    return {}
  end
  local ret = {}
  local v2 = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  local unique = SceneUtils.TileToUniqueTile(v2, serverId)
  for _, v in pairs(self.allData) do
    if v:IsInRange(unique.x, unique.y) and v:IsTargetMe() then
      table.insert(ret, v)
    end
  end
  return ret
end

function WarFlagDataManager:CheckHasFlag(index, serverId)
  if index <= 0 then
    return false
  end
  if self.allData == nil then
    return false
  end
  for _, v in pairs(self.allData) do
    if v:IsOccupied(index, serverId) then
      return true
    end
  end
  return false
end

function WarFlagDataManager:GetWarFlagGroup()
  local ret = {}
  if self.allMeta then
    for id, v in pairs(self.allMeta) do
      if v.temperature and v.temperature > 0 then
        local temp = DataCenter.HeatSourceTemplateManager:GetTemplate(v.temperature)
        if temp then
          ret[id] = temp.group
        end
      end
    end
  end
  return ret
end

function WarFlagDataManager:RefreshAllAffectMe()
  self.allEffect = {}
  self.allAffectMe = {}
  local mainPos = LuaEntry.Player:GetMainWorldPos()
  if mainPos <= 0 then
    return
  end
  local v2 = SceneUtils.IndexToTilePos(mainPos, ForceChangeScene.World)
  local unique = SceneUtils.TileToUniqueTile(v2, LuaEntry.Player:GetSelfServerId())
  for _, warFlagData in pairs(self.allData) do
    self:AddAffectMe(warFlagData, unique)
  end
end

function WarFlagDataManager:AddAffectMe(warFlagData, mainPosV2)
  if warFlagData and warFlagData.meta and warFlagData.meta.effect and table.IsNotEmpty(warFlagData.meta.effect) then
    if not mainPosV2 then
      local mainPos = LuaEntry.Player:GetMainWorldPos()
      if mainPos <= 0 then
        return
      end
      mainPosV2 = SceneUtils.IndexToTilePos(mainPos, ForceChangeScene.World)
      mainPosV2 = SceneUtils.TileToUniqueTile(mainPosV2, LuaEntry.Player:GetSelfServerId())
    end
    if warFlagData:IsInRange(mainPosV2.x, mainPosV2.y) and warFlagData:IsTargetMe() then
      local group = warFlagData.meta.group
      if not self.allAffectMe[group] then
        self.allAffectMe[group] = {}
      end
      self.allAffectMe[group][warFlagData.uuid] = warFlagData
      self.isEffectDirty = true
    end
  end
end

function WarFlagDataManager:RemoveAffectMe(warFlagData)
  if warFlagData.meta then
    local group = warFlagData.meta.group
    if self.allAffectMe[group] and self.allAffectMe[group][warFlagData.uuid] then
      self.allAffectMe[group][warFlagData.uuid] = nil
      self.isEffectDirty = true
    end
  end
end

function WarFlagDataManager:GetEffectById(id)
  if self.isEffectDirty then
    self:RefreshAllEffectValue()
  end
  return self.allEffect[id] or 0
end

function WarFlagDataManager:RefreshAllEffectValue()
  self.isEffectDirty = false
  self.allEffect = {}
  for _, flagDict in pairs(self.allAffectMe) do
    local flagList = {}
    for _, flagData in pairs(flagDict) do
      table.insert(flagList, flagData)
    end
    local count = #flagList
    if 0 < count then
      if 1 < count then
        table.sort(flagList, function(a, b)
          return a.meta.id > b.meta.id
        end)
      end
      local first = flagList[1]
      local maxOverlay = first.meta.max_overlay
      count = math.min(count, maxOverlay)
      for i = 1, count do
        for effId, effVal in pairs(flagList[i].meta.effect) do
          if not self.allEffect[effId] then
            self.allEffect[effId] = effVal
          else
            self.allEffect[effId] = self.allEffect[effId] + effVal
          end
        end
      end
    end
  end
end

return WarFlagDataManager
