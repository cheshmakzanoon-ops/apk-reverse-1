local TroopNameLabelManager = BaseClass("TroopNameLabelManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local TroopNameLabel = require("Scene.TroopNameLabel.TroopNameLabel")
local TruckNameLabel = require("Scene.TroopNameLabel.TruckNameLabel")
local AssemblyNameLabel = require("Scene.TroopNameLabel.AssemblyNameLabel")
local CityStrongholdBoss = require("Scene.TroopNameLabel.CityStrongholdBoss")
local S1RestCityDefendMonster = require("Scene.TroopNameLabel.S1RestCityDefendMonster")
local SHOW_LOD_MAX = 2

local function __init(self)
  self.CityStrongholdBoss = {}
  self.allTips = {}
  self.OnCreateTips = {}
  self.cacheNameList = {}
  self.s1RestCityDefendMonster = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  for k, v in pairs(self.allTips) do
    local request = v.request
    v:OnDestroy()
    if request then
      request:Destroy()
    end
  end
  self.allTips = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.ShowCityStrongholdBoss, self.ShowCityStrongholdBossSignal)
  EventManager:GetInstance():AddListener(EventId.HideCityStrongholdBoss, self.HideCityStrongholdBossSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateCityStrongholdBoss, self.UpdateCityStrongholdBossSignal)
  EventManager:GetInstance():AddListener(EventId.ShowTroopName, self.ShowTroopNameSignal)
  EventManager:GetInstance():AddListener(EventId.HideTroopName, self.HideTroopNameSignal)
  EventManager:GetInstance():AddListener(EventId.CheckTroopStateIcon, self.CheckTroopStateIconSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.WorldMarchUpdateDisplayMode, self.UpdateDisplayMode)
  EventManager:GetInstance():AddListener(EventId.CityStrongholdMonsterDetailRefresh, self.UpdateStrongholdMonster)
  EventManager:GetInstance():AddListener(EventId.ShowS1RestCityDefendMonster, self.ShowS1RestCityDefendMonsterSignal)
  EventManager:GetInstance():AddListener(EventId.HideS1RestCityDefendMonster, self.HideS1RestCityDefendMonsterSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshS1RestCityDefendMonster, self.UpdateS1RestCityDefendMonsterSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.ShowCityStrongholdBoss, self.ShowCityStrongholdBossSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideCityStrongholdBoss, self.HideCityStrongholdBossSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateCityStrongholdBoss, self.UpdateCityStrongholdBossSignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowTroopName, self.ShowTroopNameSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideTroopName, self.HideTroopNameSignal)
  EventManager:GetInstance():RemoveListener(EventId.CheckTroopStateIcon, self.CheckTroopStateIconSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.WorldMarchUpdateDisplayMode, self.UpdateDisplayMode)
  EventManager:GetInstance():RemoveListener(EventId.CityStrongholdMonsterDetailRefresh, self.UpdateStrongholdMonster)
  EventManager:GetInstance():RemoveListener(EventId.ShowS1RestCityDefendMonster, self.ShowS1RestCityDefendMonsterSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideS1RestCityDefendMonster, self.HideS1RestCityDefendMonsterSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshS1RestCityDefendMonster, self.UpdateS1RestCityDefendMonsterSignal)
end

function TroopNameLabelManager.RemoveAllTips()
  local self = TroopNameLabelManager:GetInstance()
  for k, v in pairs(self.allTips) do
    local request = v.request
    v:OnDestroy()
    if request then
      request:Destroy()
    end
  end
  for k, v in pairs(self.OnCreateTips) do
    if v ~= nil and v[1] ~= nil then
      v[1]:Destroy()
    end
  end
  for k, v in pairs(self.CityStrongholdBoss) do
    if v then
      local request = v[1]
      local effect = v[2]
      if effect then
        effect:OnDestroy()
      end
      if request then
        request:Destroy()
      end
    end
  end
  for k, v in pairs(self.s1RestCityDefendMonster) do
    if v then
      local request = v[1]
      local effect = v[2]
      if effect then
        effect:OnDestroy()
      end
      if request then
        request:Destroy()
      end
    end
  end
  self.allTips = {}
  self.OnCreateTips = {}
  self.cacheNameList = {}
  self.CityStrongholdBoss = {}
  self.s1RestCityDefendMonster = {}
end

function TroopNameLabelManager.UpdateStrongholdMonster()
  local self = TroopNameLabelManager:GetInstance()
  for k, v in pairs(self.CityStrongholdBoss) do
    if v then
      local effect = v[2]
      if effect then
        effect:UpdateLod(toInt(self.lod))
      end
    end
  end
end

function TroopNameLabelManager.ShowCityStrongholdBossSignal(marchUuid)
  if marchUuid == nil or marchUuid == 0 then
    return
  end
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  if marchInfo == nil then
    return
  end
  local monsterId = marchInfo.monsterId
  local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  if monster == nil or monster.special ~= WorldMonsterSpecialType.CityStrongholdBOSS then
    return
  end
  local self = TroopNameLabelManager:GetInstance()
  local dataList = self.CityStrongholdBoss
  if dataList and dataList[marchUuid] == nil then
    local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/AllianceCityTip/AllianceBossTip.prefab")
    dataList[marchUuid] = {request, nil}
    local theDetail = DataCenter.SeasonDataManager:GetMonsterDetail(marchUuid)
    if theDetail == nil then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonMonsterDetail, marchUuid, marchInfo.serverId)
    end
    request:completed("+", function()
      if request.isError then
        return
      end
      local theWorld = CS.SceneManager.World
      if theWorld == nil then
        request:Destroy()
        return
      end
      local theMarchTroop = theWorld:GetTroop(marchUuid)
      if theMarchTroop == nil then
        request:Destroy()
        return
      end
      local go = request.gameObject
      go.name = "BossTip"
      go:SetActive(true)
      go.transform:SetParent(theMarchTroop:GetTransform())
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(-0.4, -3.5, 0)
      local autoFace = go:GetComponent(typeof(CS.AutoFaceToCamera))
      local adjustScales = go:GetComponent(typeof(CS.AutoAdjustScale))
      local adjustLod = go:GetComponent(typeof(CS.AutoAdjustLod))
      if not IsNull(autoFace) then
        autoFace.enabled = true
      end
      if not IsNull(adjustScales) then
        adjustScales.enabled = true
      end
      if not IsNull(adjustLod) then
        adjustLod.enabled = true
      end
      local effect = CityStrongholdBoss.New()
      effect:OnCreate(request)
      effect:ReInit(marchUuid, self.lodCache or 1)
      dataList[marchUuid] = {request, effect}
    end)
  end
end

function TroopNameLabelManager.UpdateCityStrongholdBossSignal(data)
  if data and data.dataHolder and data.dataHolder.strongholdBoss then
    local uuid = data.dataHolder.uuid.Data
    local maxNum = data.dataHolder.strongholdBoss.Data.dataHolder.maxNum.Data
    local curNum = data.dataHolder.strongholdBoss.Data.dataHolder.curNum.Data
    DataCenter.SeasonDataManager:UpdateMonsterDetail(uuid, {
      uuid = uuid,
      curNum = curNum,
      maxNum = maxNum
    })
  end
end

function TroopNameLabelManager.HideCityStrongholdBossSignal(marchUuid)
  if marchUuid == nil or marchUuid == 0 then
    return
  end
  local self = TroopNameLabelManager:GetInstance()
  local dataList = self.CityStrongholdBoss
  if dataList then
    local data = dataList[marchUuid]
    if data then
      local request = data[1]
      local effect = data[2]
      if effect then
        effect:OnDestroy()
      end
      if request then
        request:Destroy()
      end
    end
    dataList[marchUuid] = nil
  end
end

local function ChangeCameraLodSignal(lod)
  TroopNameLabelManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
  if self.lodCache ~= lod then
    self.lodCache = lod
    if self.lodCache >= 1 and self.lodCache <= SHOW_LOD_MAX then
      self:CreateCacheNameList()
    end
    for k, v in pairs(self.CityStrongholdBoss) do
      if v then
        local effect = v[2]
        if effect then
          effect:UpdateLod(lod)
        end
      end
    end
    for k, v in pairs(self.s1RestCityDefendMonster) do
      if v then
        local effect = v[2]
        if effect then
          effect:UpdateLod(lod)
        end
      end
    end
  end
end

local function CreateCacheNameList(self)
  if self.cacheNameList ~= nil then
    for k, v in pairs(self.cacheNameList) do
      self:CheckShowEffect(k)
    end
    self.cacheNameList = {}
  end
end

local function RemoveOneEffect(self, uuid)
  local temp = self.allTips[uuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    if request then
      request:Destroy()
    end
    self.allTips[uuid] = nil
  end
  temp = self.OnCreateTips[uuid]
  if temp ~= nil and temp[1] ~= nil then
    temp[1]:Destroy()
    self.OnCreateTips[uuid] = nil
  end
end

local function HideTroopNameSignal(uuid)
  TroopNameLabelManager:GetInstance():RemoveOneEffect(tonumber(uuid))
end

local function ShowTroopNameSignal(uuid)
  TroopNameLabelManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function CheckTroopStateIconSignal(uuid)
  TroopNameLabelManager:GetInstance():CheckTroopStateIcon(tonumber(uuid))
end

local function GetTipAssetAndClass(self, marchType)
  local uIAssets = marchType == NewMarchType.ASSEMBLY_MARCH and UIAssets.WorldTroopAssemblyName or UIAssets.WorldTroopName
  local luaScript = marchType == NewMarchType.ASSEMBLY_MARCH and AssemblyNameLabel or TroopNameLabel
  return uIAssets, luaScript
end

local function CheckAndReleaseOldTip(self, uuid, uIAssets, luaScript)
  local oldTip = self.allTips[uuid] ~= nil and "Scene.TroopNameLabel." .. self.allTips[uuid]._class_type.__cname ~= luaScript
  local oldCreateTip = self.OnCreateTips[uuid] ~= nil and self.OnCreateTips[uuid][2] ~= uIAssets
  if oldTip or oldCreateTip then
    self:RemoveOneEffect(uuid)
  end
end

local function CheckNeedShowNameByMarchType(marchType, targetType, virusLayer)
  return marchType == NewMarchType.NORMAL or marchType == NewMarchType.CROSS_NORMAL or marchType == NewMarchType.CROSS_SCOUT or marchType == NewMarchType.FAKE_ATTACK or marchType == NewMarchType.ASSEMBLY_MARCH or marchType == NewMarchType.SCOUT or marchType == NewMarchType.TREAT_VIRUS or marchType == NewMarchType.LOTTO_RECEIVE or marchType == NewMarchType.RESOURCE_HELP or marchType == NewMarchType.GOLLOES_EXPLORE or marchType == NewMarchType.GOLLOES_TRADE or marchType == NewMarchType.TRAIN or marchType == NewMarchType.ZONE_TRAIN or marchType == NewMarchType.ALL_OUT or marchType == NewMarchType.ZONE_MOBILIZATION_DONATE or marchType == NewMarchType.CAR_REBUILD or marchType == NewMarchType.MONSTER_CHALLENGE_DONATE or marchType == NewMarchType.DIRECT_MOVE_MARCH and toInt(virusLayer) > 0
end

local function CheckShowEffect(self, marchUuid)
  local world = CS.SceneManager.World
  if world == nil then
    return
  end
  local info = world:GetMarch(marchUuid)
  if info and info.isCameraFollow and info:GetMarchType() ~= NewMarchType.TRAIN and info:GetMarchType() ~= NewMarchType.ZONE_TRAIN or TroopHeadUIManager:GetInstance():HasHeadUI(marchUuid) then
    return
  end
  if not info then
    return
  end
  local marchTargetType = info:GetMarchTargetType()
  local marchType = info:GetMarchType()
  local baseVirusLayer = info.baseVirusLayer or 0
  local extraVirusLayer = info.extraVirusLayer or 0
  if marchType == NewMarchType.GOLLOES_EXPLORE and info:GetMarchStatus() == MarchStatus.GOLLOES_EXPLORING then
    return
  end
  if not CheckNeedShowNameByMarchType(marchType, marchTargetType, baseVirusLayer + extraVirusLayer) then
    return
  end
  local troop = world:GetTroop(marchUuid)
  if troop ~= nil then
    if troop:IsBattle() then
      return
    end
    local transform = troop:GetTransform()
    if transform == nil then
      return
    end
    local uIAssets, luaScript = self:GetTipAssetAndClass(marchType)
    self:CheckAndReleaseOldTip(marchUuid, uIAssets, luaScript)
    if self.allTips[marchUuid] == nil and self.OnCreateTips[marchUuid] == nil then
      if self.lodCache ~= nil and self.lodCache > SHOW_LOD_MAX then
        self.cacheNameList[marchUuid] = true
        return
      end
      local request = ResourceManager:InstantiateAsync(uIAssets, ObjectPoolTag.Normal, LoadPriority.Low)
      self.OnCreateTips[marchUuid] = {request, uIAssets}
      request:completed("+", function()
        local loadedUIAsset = self.OnCreateTips[marchUuid][2]
        self.OnCreateTips[marchUuid] = nil
        if CS.SceneManager.World == nil then
          return
        end
        if request.isError then
          return
        end
        if transform == nil then
          request:Destroy()
          return
        end
        local realInfo = CS.SceneManager.World:GetMarch(marchUuid)
        if not realInfo then
          request:Destroy()
          return
        end
        local realTargetType = realInfo:GetMarchTargetType()
        local realMarchType = realInfo:GetMarchType()
        local _baseVirusLayer = realInfo.baseVirusLayer or 0
        local _extraVirusLayer = realInfo.extraVirusLayer or 0
        if not CheckNeedShowNameByMarchType(realMarchType, realTargetType, _baseVirusLayer + _extraVirusLayer) then
          request:Destroy()
          return
        end
        local realUIAsset = self:GetTipAssetAndClass(realMarchType)
        if loadedUIAsset ~= realUIAsset then
          request:Destroy()
          self:CheckShowEffect(marchUuid)
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(transform)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform:Set_localPosition(0, 0, 0)
        local adjustLod = request.gameObject:GetComponent(typeof(CS.AutoAdjustLod))
        if not IsNull(adjustLod) then
          adjustLod.enabled = true
        end
        local labelUI = luaScript.New()
        labelUI:OnCreate(request)
        self.allTips[marchUuid] = labelUI
        self:ShowTroopName(marchUuid)
        self:CheckTroopStateIcon(marchUuid)
      end)
    elseif self.allTips[marchUuid] ~= nil then
      self:ShowTroopName(marchUuid)
      self:CheckTroopStateIcon(marchUuid)
    end
  end
end

local function CheckTroopStateIcon(self, marchUuid)
  if self.allTips[marchUuid] ~= nil then
    local info = CS.SceneManager.World:GetMarch(marchUuid)
    if info ~= nil then
      if info:GetMarchType() == NewMarchType.CAR_REBUILD then
        self.allTips[marchUuid]:CarRebuildState(info)
        return
      end
      if info:GetIsBroken() == true then
        self.allTips[marchUuid]:ShowIcon(TroopIconShowState.Broken)
      elseif info.ownerUid == LuaEntry.Player.uid and info:GetMarchStatus() == MarchStatus.STATION then
        self.allTips[marchUuid]:ShowIcon(TroopIconShowState.Idle)
      else
        self.allTips[marchUuid]:ShowIcon(TroopIconShowState.Hide)
      end
    end
  end
end

local function ShowTroopName(self, marchUuid)
  if self.allTips[marchUuid] ~= nil then
    local info = CS.SceneManager.World:GetMarch(marchUuid)
    if info ~= nil then
      self.allTips[marchUuid]:SetName(info)
    end
  end
end

local function UpdateDisplayMode(self)
  for marchUuid, tip in pairs(TroopNameLabelManager:GetInstance().allTips) do
    tip:UpdateDisplayMode(marchUuid)
  end
end

function TroopNameLabelManager.ShowS1RestCityDefendMonsterSignal(marchUuid)
  if marchUuid == nil or marchUuid == 0 then
    return
  end
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  if marchInfo == nil then
    return
  end
  local monsterId = marchInfo.monsterId
  local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  if monster == nil or monster.special ~= WorldMonsterSpecialType.S1RestCityDefendMonster then
    return
  end
  local self = TroopNameLabelManager:GetInstance()
  local dataList = self.s1RestCityDefendMonster
  if dataList and dataList[marchUuid] == nil then
    local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/LWOffSeason1/Recapture/S1RestCityDefendMonsterTip.prefab")
    dataList[marchUuid] = {request, nil}
    request:completed("+", function()
      if request.isError then
        return
      end
      local theMarchTroop = CS.SceneManager.World:GetTroop(marchUuid)
      if theMarchTroop == nil then
        return
      end
      local go = request.gameObject
      go.name = "BossTip"
      go:SetActive(true)
      go.transform:SetParent(theMarchTroop:GetTransform())
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(-0.4, -3.5, -4)
      local autoFace = go:GetComponent(typeof(CS.AutoFaceToCamera))
      local adjustScales = go:GetComponent(typeof(CS.AutoAdjustScale))
      local adjustLod = go:GetComponent(typeof(CS.AutoAdjustLod))
      if not IsNull(autoFace) then
        autoFace.enabled = true
      end
      if not IsNull(adjustScales) then
        adjustScales.enabled = true
      end
      if not IsNull(adjustLod) then
        adjustLod.enabled = true
      end
      local effect = S1RestCityDefendMonster.New()
      effect:OnCreate(request)
      effect:ReInit(marchUuid, self.lodCache or 1)
      dataList[marchUuid] = {request, effect}
    end)
  end
end

function TroopNameLabelManager.HideS1RestCityDefendMonsterSignal(marchUuid)
  if marchUuid == nil or marchUuid == 0 then
    return
  end
  local self = TroopNameLabelManager:GetInstance()
  local dataList = self.s1RestCityDefendMonster
  if dataList then
    local data = dataList[marchUuid]
    if data then
      local request = data[1]
      local effect = data[2]
      if effect then
        effect:OnDestroy()
      end
      if request then
        request:Destroy()
      end
    end
    dataList[marchUuid] = nil
  end
end

function TroopNameLabelManager.UpdateS1RestCityDefendMonsterSignal(marchUuid)
  local self = TroopNameLabelManager:GetInstance()
  local dataList = self.s1RestCityDefendMonster
  if dataList then
    local data = dataList[marchUuid]
    if data then
      local effect = data[2]
      if effect then
        effect:UpdateLod(self.lodCache or 1)
      end
    end
  end
end

TroopNameLabelManager.__init = __init
TroopNameLabelManager.__delete = __delete
TroopNameLabelManager.AddListener = AddListener
TroopNameLabelManager.RemoveListener = RemoveListener
TroopNameLabelManager.CheckTroopStateIcon = CheckTroopStateIcon
TroopNameLabelManager.ShowTroopName = ShowTroopName
TroopNameLabelManager.RemoveOneEffect = RemoveOneEffect
TroopNameLabelManager.CheckShowEffect = CheckShowEffect
TroopNameLabelManager.HideTroopNameSignal = HideTroopNameSignal
TroopNameLabelManager.ShowTroopNameSignal = ShowTroopNameSignal
TroopNameLabelManager.CheckTroopStateIconSignal = CheckTroopStateIconSignal
TroopNameLabelManager.ChangeCameraLodSignal = ChangeCameraLodSignal
TroopNameLabelManager.UpdateLod = UpdateLod
TroopNameLabelManager.CreateCacheNameList = CreateCacheNameList
TroopNameLabelManager.UpdateDisplayMode = UpdateDisplayMode
TroopNameLabelManager.CheckAndReleaseOldTip = CheckAndReleaseOldTip
TroopNameLabelManager.GetTipAssetAndClass = GetTipAssetAndClass
return TroopNameLabelManager
