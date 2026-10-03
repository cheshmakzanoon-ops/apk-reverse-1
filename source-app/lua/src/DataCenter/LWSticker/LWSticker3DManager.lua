local LWSticker3DManager = BaseClass("LWSticker3DManager")
local stickerPerfabPatch = "Assets/Main/Prefabs/UI/UIDecoration/mapStickerItem.prefab"
local MarchSticker = require("Scene.LWWorldMarch.MarchSticker")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource

function LWSticker3DManager:__init()
  self.sendCd = LuaEntry.DataConfig:TryGetNum("sticker_chat_limit", "k1", 5) * 1000
  self.curStageId = 0
  self.lodLevel = 1
  self.stickerReq = {}
  self.stickerList = {}
  self.AutoStickerList = nil
  self.ShowTime = {}
  self.FailureStickerDataLiveTime = 1000
  self.FailureStickerDataList = {}
  self.scoutSticker = {}
  self:AddListener()
end

function LWSticker3DManager:__delete()
  self.curStageId = nil
  self.lodLevel = nil
  self.AutoStickerList = nil
  self.ShowTime = {}
  self.FailureStickerDataList = {}
  if table.count(self.stickerReq) > 0 then
    for _, v in pairs(self.stickerReq) do
      v:Destroy()
    end
    self.stickerReq = {}
  end
  for i, sticker in pairs(self.stickerList) do
    if sticker then
      sticker:Delete()
    end
  end
  self.stickerList = {}
  for i, sticker in pairs(self.scoutSticker) do
    if sticker then
      sticker:Delete()
    end
  end
  self.scoutSticker = {}
  self:RemoveListener()
end

function LWSticker3DManager:Startup(initPayload)
  if initPayload == nil then
    return
  end
  self:UpdateAutoStickerList(initPayload.auto_sticker)
end

function LWSticker3DManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.OnWorldBuildOutView)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():AddListener(EventId.OnSquadCreated, self.OnSquadCreated)
  EventManager:GetInstance():AddListener(EventId.OnWorldBuildInView, self.OnSquadCreated)
  EventManager:GetInstance():AddListener(EventId.OnScoutMarchCreate, self.OnScoutMarchCreate)
end

function LWSticker3DManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.OnWorldBuildOutView)
  EventManager:GetInstance():RemoveListener(EventId.OnSquadCreated, self.OnSquadCreated)
  EventManager:GetInstance():RemoveListener(EventId.OnWorldBuildInView, self.OnSquadCreated)
  EventManager:GetInstance():RemoveListener(EventId.OnScoutMarchCreate, self.OnScoutMarchCreate)
end

function LWSticker3DManager.OnLodChange(lod)
  local mgr = DataCenter.LWSticker3DManager
  mgr.lodLevel = lod
end

function LWSticker3DManager:ShowSticker(type, stickerId, uuid, numParam, isSimpleMode, retryWhenFail)
  if IsNull(CS.SceneManager.World) or CS.SceneManager:IsInCity() then
    return
  end
  if self.lodLevel > 2 then
    return
  end
  local canShow, _ = self:CanShowSticker(uuid)
  if not canShow then
    if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
      local msg = string.format("\227\128\144\229\138\168\230\128\129\232\161\168\230\131\133\227\128\145 \232\161\168\230\131\133\232\162\171\229\191\189\231\149\165\239\188\140uuid\239\188\154 %s", uuid)
      UIUtil.ShowTips("\227\128\144DebugOnly\227\128\145 " .. msg, 3)
    end
    return
  end
  local success = false
  if type == WorldStickerType.March then
    success = self:ShowMarchSticker(stickerId, uuid, numParam, isSimpleMode)
  elseif type == WorldStickerType.Build then
    success = self:ShowCitySticker(stickerId, uuid, numParam, isSimpleMode)
  end
  if success then
    if self.ShowTime == nil then
      self.ShowTime = {}
    end
    self.ShowTime[checknumber(uuid)] = UITimeManager:GetInstance():GetServerTime()
  elseif retryWhenFail then
    self:AddToFailureList(type, stickerId, uuid, numParam)
  end
end

function LWSticker3DManager:AddToFailureList(type, stickerId, uuid, num)
  local stickerData = {
    type = type,
    stickerId = stickerId,
    uuid = uuid,
    numParam = num
  }
  self.FailureStickerDataList[checknumber(uuid)] = {
    time = UITimeManager:GetInstance():GetServerTime(),
    stickerData = stickerData
  }
  if table.count(self.FailureStickerDataList) > 100 then
    for sUuid, data in pairs(self.FailureStickerDataList) do
      local time = checknumber(data.time)
      local pastTime = UITimeManager:GetInstance():GetServerTime() - time
      if pastTime > self.FailureStickerDataLiveTime then
        self.FailureStickerDataList[sUuid] = nil
      end
    end
  end
end

function LWSticker3DManager:TryShowFailureMarchSticker(uuid)
  local data = table.TryGetValue(self.FailureStickerDataList, checknumber(uuid), nil)
  if data == nil then
    return
  end
  local time = checknumber(data.time)
  local pastTime = UITimeManager:GetInstance():GetServerTime() - time
  if pastTime >= self.FailureStickerDataLiveTime then
    self.FailureStickerDataList[checknumber(uuid)] = nil
    return
  end
  local isSimpleMode = not DisplaySettings.ShowDynamicWorldSticker()
  local stickerData = data.stickerData
  self:ShowSticker(stickerData.type, stickerData.stickerId, uuid, stickerData.numParam, isSimpleMode, false)
  self.FailureStickerDataList[checknumber(uuid)] = nil
end

function LWSticker3DManager.OnSquadCreated(evt)
  local squadUuid = checknumber(evt)
  DataCenter.LWSticker3DManager:TryShowFailureMarchSticker(squadUuid)
end

function LWSticker3DManager.OnScoutMarchCreate(evt)
  local marchUuid = checknumber(evt)
  DataCenter.LWSticker3DManager:TryShowFailureMarchSticker(marchUuid)
end

function LWSticker3DManager:SendMapSticker(type, uid, stickerId)
  local curCd = self.sendCd
  if self.sendStickerTime then
    curCd = UITimeManager:GetInstance():GetServerTime() - self.sendStickerTime
  end
  if curCd >= self.sendCd then
    self.sendStickerTime = UITimeManager:GetInstance():GetServerTime()
    local numParam
    if stickerId == 5 then
      numParam = math.random(1, 6)
    end
    SFSNetwork.SendMessage(MsgDefines.MapSticker, type, uid, stickerId, LuaEntry.Player:GetCurWorldId(), LuaEntry.Player:GetCrossServerId(), numParam)
    return true
  else
    local time = math.ceil((self.sendCd - curCd) / 1000)
    UIUtil.ShowTips(Localization:GetString("map_sticker_limit_tips", time))
    return false
  end
end

function LWSticker3DManager:CanShowSticker(uuid)
  local lastTime = checknumber(table.TryGetValue(self.ShowTime, checknumber(uuid), 0))
  local pastTime = UITimeManager:GetInstance():GetServerTime() - lastTime
  return pastTime >= self.sendCd, pastTime
end

function LWSticker3DManager:CreateSticker(parent, bUuid, stickerId, numParam, isSimpleMode, localPos)
  local req = Resource:InstantiateAsync(stickerPerfabPatch)
  local marchSticker = ObjectPool:GetInstance():Load(MarchSticker)
  marchSticker:Init(parent, req)
  req:completed("+", function()
    if req.isError then
      return
    end
    if self.props == nil then
      self.props = CS.UnityEngine.MaterialPropertyBlock()
    end
    localPos = localPos or Vector3.New(0, 2.3, 0)
    marchSticker:OnCreate(localPos, self.props)
    marchSticker:ShowSticker(stickerId, bUuid, numParam, isSimpleMode)
  end)
  self.stickerReq[checknumber(bUuid)] = req
  return marchSticker
end

function LWSticker3DManager:ShowMarchSticker(stickerId, marchUuid, numParam, isSimpleMode)
  local success = false
  local squad = DataCenter.WorldBattleManager:GetSquad(marchUuid)
  if squad then
    success = squad:ShowSticker(stickerId, marchUuid, numParam, isSimpleMode)
  end
  if not success then
    local worldTroop = CS.SceneManager.World:GetTroop(marchUuid)
    if worldTroop ~= nil then
      local model = worldTroop:GetModel()
      if IsNotNull(model) then
        local ticker = table.TryGetValue(self.scoutSticker, checknumber(marchUuid), nil)
        if ticker then
          ticker:ShowSticker(stickerId, marchUuid, numParam, isSimpleMode)
        else
          ticker = self:CreateSticker(model, marchUuid, stickerId, numParam, isSimpleMode)
          self.scoutSticker[checknumber(marchUuid)] = ticker
        end
        success = true
      end
    end
  end
  return success
end

function LWSticker3DManager.OnWorldBuildOutView(bUuid)
  local self = DataCenter.LWSticker3DManager
  local sticker = self.stickerList[bUuid]
  if not sticker then
    return
  end
  if sticker then
    sticker:Delete()
    self.stickerList[bUuid] = nil
  end
end

function LWSticker3DManager:ShowCitySticker(stickerId, bUuid, numParam, isSimpleMode)
  local build = CS.SceneManager.World:GetObjectByUuid(bUuid)
  if build then
    local sticker = self.stickerList[bUuid]
    if not sticker then
      local cityModel = build:GetGameObject()
      local localPos = self:GetBuildStickerTargetPos(cityModel, bUuid)
      local newSticker = self:CreateSticker(cityModel, bUuid, stickerId, numParam, isSimpleMode, localPos)
      self.stickerList[bUuid] = newSticker
    else
      self.stickerList[bUuid]:ShowSticker(stickerId, bUuid, numParam, isSimpleMode)
    end
    return true
  end
  return false
end

function LWSticker3DManager:GetBuildStickerTargetPos(parent, uuid)
  if parent == nil then
    return nil
  end
  if BattleFieldUtil.InBattleField() then
    local info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if info ~= nil and info.detail ~= nil then
      local pointId = 0
      if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
        pointId = info.pointIndex
      elseif BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
        pointId = info.detail.PointId
      elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
        pointId = info.detail.PointId
      end
      local pointIndex = checknumber(pointId)
      local headUI = table.TryGetValue(WorldBuildHeadUIManager:GetInstance().dragonTips, pointIndex, nil)
      if headUI ~= nil and headUI.GetHeadIcon ~= nil and IsNotNull(headUI:GetHeadIcon()) then
        return parent.transform:InverseTransformPoint(headUI:GetHeadIcon().transform.position)
      end
    end
  end
  return nil
end

function LWSticker3DManager:RemoveScoutSticker(uuid)
  if self.scoutSticker[uuid] then
    self.scoutSticker[uuid]:Delete()
    self.scoutSticker[uuid] = nil
  end
  if self.stickerReq[uuid] then
    self.stickerReq[uuid]:Destroy()
    self.stickerReq[uuid] = nil
  end
end

function LWSticker3DManager:IsAutoStickerFuncOpen()
  return LuaEntry.DataConfig:CheckSwitch("auto_play_sticker")
end

function LWSticker3DManager:IsCommonStickerTabOpen()
  if not self:IsAutoStickerFuncOpen() then
    return false
  end
  local openDay = LuaEntry.DataConfig:TryGetNum("auto_sticker_param", "k2", 21)
  local serverOpenDay = UITimeManager:GetInstance():GetOpenServerDay()
  return openDay <= serverOpenDay
end

function LWSticker3DManager:IsSpecialStickerTabOpen()
  if not self:IsAutoStickerFuncOpen() then
    return false
  end
  if self:IsDesertStickerFuncOpen() then
    return true
  end
  if self:IsWinterStickerFuncOpen() then
    return true
  end
  if self:IsEpidemicStickerFuncOpen() then
    return true
  end
  return false
end

function LWSticker3DManager:IsSpecialStickerFuncOpen(param)
  if not self:IsSpecialStickerTabOpen() then
    return false
  end
  param = checknumber(param)
  if param == 1 then
    return self:IsDesertStickerFuncOpen()
  elseif param == 2 then
    return self:IsWinterStickerFuncOpen()
  elseif param == 3 then
    return self:IsEpidemicStickerFuncOpen()
  end
  return false
end

function LWSticker3DManager:IsDesertStickerFuncOpen()
  local openDay = LuaEntry.DataConfig:TryGetNum("auto_sticker_param", "k3", 21)
  local serverOpenDay = UITimeManager:GetInstance():GetOpenServerDay()
  return openDay <= serverOpenDay
end

function LWSticker3DManager:IsWinterStickerFuncOpen()
  local openDay = LuaEntry.DataConfig:TryGetNum("auto_sticker_param", "k4", 49)
  local serverOpenDay = UITimeManager:GetInstance():GetOpenServerDay()
  return openDay <= serverOpenDay
end

function LWSticker3DManager:IsEpidemicStickerFuncOpen()
  local condition = LuaEntry.DataConfig:TryGetStr("auto_sticker_param", "k5", "")
  local season, seasonDay = string.string2_ii(condition, "|")
  local curSeason = SeasonUtil.GetSeason()
  local curSeasonDay = SeasonUtil.GetSeasonDay()
  if season > curSeason or curSeason == season and seasonDay > curSeasonDay then
    return false
  end
  return true
end

function LWSticker3DManager:UpdateAutoStickerList(map)
  if self.AutoStickerList == nil then
    self.AutoStickerList = {}
    LocalController:instance():visitTable(TableName.AUTO_STICKER, function(id, cell)
      self.AutoStickerList[checknumber(cell.auto_send_param)] = 0
    end)
  end
  if table.count(map) > 0 then
    for _, pair in pairs(map) do
      if table.containsKey(self.AutoStickerList, checknumber(pair.type)) then
        self.AutoStickerList[checknumber(pair.type)] = checknumber(pair.sticker)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.DecorationStickerAutoStickerUpdate)
  end
end

function LWSticker3DManager:GetAutoStickerId(autoType)
  return table.TryGetValue(self.AutoStickerList, checknumber(autoType), 0)
end

function LWSticker3DManager:SetAutoStickerId(autoType, stickerId, trigger)
  autoType = checknumber(autoType)
  if self.AutoStickerList == nil then
    self.AutoStickerList = {}
    LocalController:instance():visitTable(TableName.AUTO_STICKER, function(id, cell)
      self.AutoStickerList[checknumber(cell.auto_send_param)] = 0
    end)
  end
  if table.containsKey(self.AutoStickerList, autoType) then
    self.AutoStickerList[autoType] = checknumber(stickerId)
  end
  if trigger then
    EventManager:GetInstance():Broadcast(EventId.DecorationStickerAutoStickerSet, autoType)
  end
end

function LWSticker3DManager:SendSetAutoSticker()
  if not self:IsAutoStickerFuncOpen() then
    return
  end
  if table.count(self.AutoStickerList) == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AutoStickerSet, self.AutoStickerList)
end

function LWSticker3DManager:OnSetAutoCallback(payload)
  if payload == nil then
    return
  end
  self:UpdateAutoStickerList(payload.infos)
end

return LWSticker3DManager
