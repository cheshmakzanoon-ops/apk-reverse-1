local CityZoneFog = BaseClass("CityZoneFog")
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local Const = require("Scene.Monopoly.Const")
local FogWhitePath = "Assets/Main/Prefabs/FogOfWar/FogVolume.prefab"
local FogTileSize = 20
local FOWSystem = CS.FOWSystem
local InitFogTile = {
  Vector2.New(-6, -6),
  Vector2.New(0, -6),
  Vector2.New(6, -6),
  Vector2.New(-6, 0),
  Vector2.New(0, 0),
  Vector2.New(6, 0),
  Vector2.New(-6, 6),
  Vector2.New(0, 6),
  Vector2.New(6, 6),
  Vector2.New(0, -12),
  Vector2.New(6, -12),
  Vector2.New(-6, -18),
  Vector2.New(0, -18),
  Vector2.New(6, -18),
  Vector2.New(0, -24),
  Vector2.New(0, -30),
  Vector2.New(0, -36)
}
local InitFogTile_1_1_B = {
  Vector2.New(0, -12),
  Vector2.New(0, -18),
  Vector2.New(0, -24),
  Vector2.New(0, -30),
  Vector2.New(0, -36)
}
local InitFogTile_1_2_B = {
  Vector2.New(0, -6),
  Vector2.New(0, 0),
  Vector2.New(0, 6)
}
local InitFogTile_1_3_B = {
  Vector2.New(-6, -6),
  Vector2.New(6, -6),
  Vector2.New(-6, 0),
  Vector2.New(6, 0),
  Vector2.New(-6, 6),
  Vector2.New(6, 6),
  Vector2.New(6, -12),
  Vector2.New(-6, -18),
  Vector2.New(6, -18)
}
local InitFogTile2 = {
  Vector2.New(-13, -12),
  Vector2.New(-13, -20),
  Vector2.New(-13, -28),
  Vector2.New(-13, -36),
  Vector2.New(15, -12),
  Vector2.New(15, -20),
  Vector2.New(15, -28),
  Vector2.New(15, -36),
  Vector2.New(-7, -12),
  Vector2.New(-7, -20),
  Vector2.New(-7, -28),
  Vector2.New(-7, -36),
  Vector2.New(7, -12),
  Vector2.New(7, -20),
  Vector2.New(7, -28),
  Vector2.New(7, -36)
}
local InitFogLandBase = {
  Vector2.New(15, -4),
  Vector2.New(15, 4),
  Vector2.New(13, 12),
  Vector2.New(5, 12),
  Vector2.New(-3, 12),
  Vector2.New(-13, 12),
  Vector2.New(-13, 4),
  Vector2.New(-13, -4)
}
local InitFogTile3 = {
  Vector2.New(-19, 17),
  Vector2.New(-12, 17),
  Vector2.New(-4, 17),
  Vector2.New(4, 17),
  Vector2.New(12, 17),
  Vector2.New(18, 17),
  Vector2.New(-19, 4),
  Vector2.New(-19, -4),
  Vector2.New(-19, -12),
  Vector2.New(-19, -20),
  Vector2.New(-19, -28),
  Vector2.New(-19, -36),
  Vector2.New(19, 4),
  Vector2.New(19, -4),
  Vector2.New(19, -12),
  Vector2.New(19, -20),
  Vector2.New(19, -28),
  Vector2.New(19, -36)
}
local InitFogTile4 = {
  Vector2.New(24, 25),
  Vector2.New(25, 15),
  Vector2.New(25, 4),
  Vector2.New(25, -4),
  Vector2.New(25, -12),
  Vector2.New(25, -20),
  Vector2.New(25, -28),
  Vector2.New(25, -36)
}
local InitFogTileTrain = {
  Vector2.New(-28, 23),
  Vector2.New(-28, 13),
  Vector2.New(-28, 3),
  Vector2.New(-28, -7),
  Vector2.New(-28, -17),
  Vector2.New(-28, -27),
  Vector2.New(-28, -37),
  Vector2.New(-37, 0),
  Vector2.New(-37, -10),
  Vector2.New(-37, -20),
  Vector2.New(-37, -25)
}
local InitFogDispatchTask = {
  Vector2.New(-21, -17),
  Vector2.New(-21, -22),
  Vector2.New(-21, -32)
}
local FogTileFor35Lv = {
  Vector2.New(-25, 25),
  Vector2.New(-16, 25),
  Vector2.New(-6, 25),
  Vector2.New(4, 25),
  Vector2.New(14, 25),
  Vector2.New(24, 25),
  Vector2.New(-25, 30),
  Vector2.New(-15, 30)
}
local InitMonopolyV2Guide = Vector2.New(28, -10)

function CityZoneFog:__init()
  self.loadComplete = false
  self.unlockFogIds = {}
  self.unlockFogIds2 = {}
  self.unlockFogIds3 = {}
  self.unlockFogIds4 = {}
  self.unlockFogIds3_2 = {}
  self.unlockFogIdsTrain = {}
  self.unlockDispatchTask = {}
  self.fogLandBaseIds = {}
  self.fogLandLittleBaseIds = {}
  self.unlock35LvIds = {}
  self.unlockFogLandBase = {}
  self.unlockFogLittleLandBase = {}
  self.unlockFogFor35Lv = {}
  local posOffset = DataCenter.LWCivilizationSparkExtend:CityZoneFog_getPosOffset()
  local initFogTile = DataCenter.LWCivilizationSparkExtend:CityZoneFog_getInitFogTile(InitFogTile)
  for id, pos in ipairs(initFogTile) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.unlockFogIds[id] = SceneUtils.TileToWorld(tilePos)
  end
  local initFogTile2 = DataCenter.LWCivilizationSparkExtend:CityZoneFog_getInitFogTile2(InitFogTile2)
  for id, pos in ipairs(initFogTile2) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.unlockFogIds2[id] = SceneUtils.TileToWorld(tilePos)
  end
  for id, pos in ipairs(InitFogTile3) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.unlockFogIds3[id] = SceneUtils.TileToWorld(tilePos)
  end
  for id, pos in ipairs(InitFogTile4) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.unlockFogIds4[id] = SceneUtils.TileToWorld(tilePos)
  end
  for id, pos in ipairs(InitFogTileTrain) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.unlockFogIdsTrain[id] = SceneUtils.TileToWorld(tilePos)
  end
  for id, pos in ipairs(InitFogDispatchTask) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.unlockDispatchTask[id] = SceneUtils.TileToWorld(tilePos)
  end
  for id, pos in ipairs(InitFogLandBase) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.fogLandBaseIds[id] = SceneUtils.TileToWorld(tilePos)
  end
  local initFogTileLittleBase = DataCenter.LWCivilizationSparkExtend:CityZoneFog_getInitFogTileLittleBase()
  for id, pos in ipairs(initFogTileLittleBase) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.fogLandLittleBaseIds[id] = SceneUtils.TileToWorld(tilePos)
  end
  local tilePos = InitMonopolyV2Guide + DataCenter.BuildManager.main_city_pos + posOffset
  self.unlockV2MonopolyGuide = SceneUtils.TileToWorld(tilePos)
  for id, pos in ipairs(FogTileFor35Lv) do
    local tilePos = pos + DataCenter.BuildManager.main_city_pos + posOffset
    self.unlockFogFor35Lv[id] = SceneUtils.TileToWorld(tilePos)
  end
  if not DataCenter.LWBattleManager:IsOpenReturnOpt() then
    local field = typeof(CS.FOWSystem):GetField("mRevealers", 56)
    self.revealers = field:GetValue(nil)
  end
  
  function self.onFogLoadComplete()
    self:OnFogLoadComplete()
  end
  
  self:InitFog()
end

function CityZoneFog:__delete()
  self:Destroy()
end

function CityZoneFog:Destroy()
  if not IsNull(self.fowSystem) then
    if DataCenter.LWBattleManager:IsOpenReturnOpt() then
      if nil == self.revealers and self.fowSystem then
        self.revealers = FOWSystem.mRevealers
      end
      if self.revealers then
        self.revealers:Clear()
      end
    elseif self.revealers then
      self.revealers:Clear()
    end
    self.fowSystem:Clear()
    self.fowSystem = nil
  end
  if not IsNull(self.fogInst) then
    GameObject.Destroy(self.fogInst.gameObject)
    self.fogInst = nil
  end
  self.loadComplete = false
  self.unlockFogIds = nil
  self.onFogLoadComplete = nil
end

function CityZoneFog:InitFog()
  if DataCenter.LWBattleManager:IsOpenReturnOpt() then
    self.fowSystem = GameObject("FOWSystem"):AddComponent(typeof(CS.FOWSystem))
  else
    self.fowSystem = GameObject("FOWSystem", typeof(CS.FOWSystem)):GetComponent(typeof(CS.FOWSystem))
  end
  self.fowSystem.transform:Set_position(100, 0, 100)
  self.fowSystem.worldSize = 256
  self.fowSystem.textureSize = 256
  self.fowSystem.updateFrequency = 0.33
  self.fowSystem.textureBlendTime = 0.2
  self.fowSystem.blurIterations = 20
  self.fowSystem.isRevealRect = true
  if self.fowSystem.RegisterCompleteAction ~= nil then
    self.loadComplete = false
    self.fowSystem:RegisterCompleteAction(self.onFogLoadComplete)
  else
    self.loadComplete = true
    self:OnFogLoadComplete()
  end
  if DataCenter.LWBattleManager:IsOpenReturnOpt() then
    if nil == self.revealers and self.fowSystem then
      self.revealers = FOWSystem.mRevealers
    end
    if self.revealers then
      self.revealers:Clear()
    end
  elseif self.revealers then
    self.revealers:Clear()
  end
  local fogPath = FogWhitePath
  local meta = CS.SceneSkinManager.Instance:GetCurSkinMeta()
  if meta and meta.city_fog then
    fogPath = meta.city_fog
  end
  if meta and 0 < meta.city_camp_count and meta.city_camp_fog and 0 < meta.city_camp_fog.Length then
    local sourceServerId = LuaEntry.Player:GetSourceServerId()
    local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(sourceServerId)
    if campId == SeasonFactionType.Rebels and 0 < meta.city_camp_fog.Length then
      fogPath = meta.city_camp_fog[0]
    elseif campId == SeasonFactionType.Gendarmerie and meta.city_camp_fog.Length > 1 then
      fogPath = meta.city_camp_fog[1]
    end
  end
  if fogPath ~= nil and fogPath ~= "" and not Resource:HasAsset(fogPath) then
    fogPath = string.gsub(fogPath, "Assets/Main/Prefabs/FogOfWar/", "Assets/Main/Prefabs/FogOfWar/Season/")
  end
  if fogPath == nil or fogPath == "" or not Resource:HasAsset(fogPath) then
    Logger.LogError("city_fog is not exist , " .. tostring(fogPath))
    return
  end
  self.fogInst = Resource:InstantiateAsync(fogPath)
  self.fogInst:completed("+", function(req)
    local transform = req.gameObject.transform
    transform:SetParent(self.fowSystem.transform)
    local x, y, z = DataCenter.LWCivilizationSparkExtend:CityZoneFog_getFogInstXYZ()
    transform:Set_position(x, y, z)
    transform.localRotation = Quaternion.Euler(0, 0, 0)
  end)
end

function CityZoneFog:UnlockOneFogEx(fogId, fogTileCenter, x, y)
  self.unlockFogIds[fogId] = fogTileCenter
  if self.loadComplete then
    local revealer = CS.FOWRevealer()
    revealer:Init(fogTileCenter, Vector2.New(x * 0.5, y * 0.5))
  end
end

function CityZoneFog:UnlockLandBaseFogEx(fogId, fogTileCenter, x, y)
  if self.unlockFogLandBase[fogId] == nil and self.loadComplete then
    self.unlockFogLandBase[fogId] = fogTileCenter
    local revealer = CS.FOWRevealer()
    revealer:Init(fogTileCenter, Vector2.New(x * 0.5, y * 0.5))
  end
end

function CityZoneFog:UnlockLittleLandBaseFogEx(fogId, fogTileCenter, x, y)
  if self.unlockFogLittleLandBase[fogId] == nil and self.loadComplete then
    self.unlockFogLittleLandBase[fogId] = fogTileCenter
    local revealer = CS.FOWRevealer()
    revealer:Init(fogTileCenter, Vector2.New(x * 0.5, y * 0.5))
  end
end

function CityZoneFog:UnlockLand35LvFog(fogId, fogTileCenter, x, y)
  if self.unlock35LvIds[fogId] == nil and self.loadComplete then
    self.unlock35LvIds[fogId] = fogTileCenter
    local revealer = CS.FOWRevealer()
    revealer:Init(fogTileCenter, Vector2.New(x * 0.5, y * 0.5))
  end
end

function CityZoneFog:UnlockFog_1_1()
  for id, pos in pairs(self.unlockFogIds_1_1) do
    self:UnlockOneFogEx(id, pos, FogTileSize, FogTileSize)
  end
end

function CityZoneFog:UnlockFog_1_2()
  for id, pos in pairs(self.unlockFogIds_1_2) do
    self:UnlockOneFogEx(id, pos, FogTileSize, FogTileSize)
  end
end

function CityZoneFog:UnlockFog_1_3()
  for id, pos in pairs(self.unlockFogIds_1_3) do
    self:UnlockOneFogEx(id, pos, FogTileSize, FogTileSize)
  end
end

function CityZoneFog:UnLockTwo()
  for id, pos in pairs(self.unlockFogIds2) do
    self:UnlockOneFogEx(id, pos, 20, 20)
  end
  self:UnLockLandBase()
end

function CityZoneFog:UnLockLandBase()
  if DataCenter.MonopolyManager:GetV2UnlockData() == 1 then
    for id, pos in ipairs(self.fogLandBaseIds) do
      self:UnlockLandBaseFogEx(id, pos, 20, 20)
    end
    for id, pos in ipairs(self.fogLandLittleBaseIds) do
      self:UnlockLittleLandBaseFogEx(id, pos, 20, 20)
    end
    self:Unlock35Lv()
    return
  end
  local curLandLock = DataCenter.MonopolyManager:GetCurrentLandLock()
  local template = DataCenter.LandLockManager:GetTemplate(curLandLock)
  if template == nil then
    return
  end
  local fogs = template.city_fog
  if fogs then
    if DataCenter.LWCivilizationSparkExtend:LandLockManager_inV0Interval(curLandLock) then
      for i, v in ipairs(fogs) do
        local pos = self.fogLandLittleBaseIds[v]
        if pos then
          self:UnlockLittleLandBaseFogEx(v, pos, 20, 20)
        end
      end
    else
      for id, pos in ipairs(self.fogLandLittleBaseIds) do
        self:UnlockLittleLandBaseFogEx(id, pos, 20, 20)
      end
      for i, v in ipairs(fogs) do
        local pos = self.fogLandBaseIds[v]
        if pos then
          self:UnlockLandBaseFogEx(v, pos, 20, 20)
        end
      end
    end
  end
end

function CityZoneFog:UnLockThree()
  for id, pos in pairs(self.unlockFogIds3) do
    self:UnlockOneFogEx(id, pos, 30, 30)
  end
end

function CityZoneFog:UnLockFour()
  for id, pos in pairs(self.unlockFogIds4) do
    self:UnlockOneFogEx(id, pos, 30, 30)
  end
end

function CityZoneFog:UnLockTrain()
  for id, pos in pairs(self.unlockFogIdsTrain) do
    self:UnlockOneFogEx(id, pos, 20, 20)
  end
end

function CityZoneFog:UnlockDispatchTask()
  for id, pos in pairs(self.unlockDispatchTask) do
    self:UnlockOneFogEx(id, pos, 20, 20)
  end
end

function CityZoneFog:Unlock35Lv()
  if not DataCenter.MonopolyManager:GetIsUnlock35LvMonopolyId() then
    return
  end
  local startIdOf35Lv = DataCenter.MonopolyManager:Get35LvFirstMonopolyId()
  if not startIdOf35Lv then
    return
  end
  local landData = DataCenter.MonopolyManager:GetPlacealityDataById(startIdOf35Lv)
  if not landData then
    return
  end
  if not landData:CheckSeasonOpenCondition() then
    return
  end
  local template = DataCenter.LandLockManager:GetTemplate(landData.land_lock)
  if template == nil then
    return
  end
  local fogs = template.city_fog
  if fogs then
    for i, v in ipairs(fogs) do
      local pos = self.unlockFogFor35Lv[v]
      if pos then
        self:UnlockLand35LvFog(v, pos, 20, 20)
      end
    end
  end
end

function CityZoneFog:OnFogLoadComplete()
  self.loadComplete = true
  for id, pos in pairs(self.unlockFogIds) do
    self:UnlockOneFogEx(id, pos, FogTileSize, FogTileSize)
  end
  local isOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MONOPOLY_FUNCTION_OPEN)
  if 1 <= isOpen then
    self:UnLockTwo()
  end
  local id = DataCenter.MonopolyManager.player.curId
  if id and id >= Const.threeFogId then
    self:UnLockThree()
  end
  if DataCenter.MonopolyManager:GetV2UnlockData() == 1 then
    self:UnLockFour()
    self:Unlock35Lv()
  end
  if not DataCenter.LWMyStationDataManager:IsTruckFunctionLock() then
    self:UnLockTrain()
  end
  if DataCenter.ActDispatchTaskDataManager:CheckUnlock() then
    self:UnlockDispatchTask()
  end
end

function CityZoneFog:ShowFog()
  if IsNull(self.fowSystem) then
    self:InitFog()
  else
    self.fowSystem.gameObject:SetActive(true)
  end
end

function CityZoneFog:HideFog()
  if not IsNull(self.fowSystem) then
    self.fowSystem.gameObject:SetActive(false)
  end
end

return CityZoneFog
