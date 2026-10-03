local CityMovingEffectManager = BaseClass("CityMovingEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local CityDomeShowEffect = require("Scene.CityMovingEffect.CityDomeShowEffect")
local CityDomeHideEffect = require("Scene.CityMovingEffect.CityDomeHideEffect")

local function __init(self)
  self.allShowEffect = {}
  self.OnCreateShowEffect = {}
  self.allHideEffect = {}
  self.OnCreateHideEffect = {}
  self:AddListener()
end

local function __delete(self)
  for k, v in pairs(self.allShowEffect) do
    local request = v.request
    v:OnDestroy()
    request:Destroy()
  end
  self.allShowEffect = nil
  for k, v in pairs(self.allHideEffect) do
    local request = v.request
    v:OnDestroy()
    request:Destroy()
  end
  self.allHideEffect = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ShowDomeShowEffect, self.ShowDomeShowEffectSignal)
  EventManager:GetInstance():AddListener(EventId.ShowDomeHideEffect, self.ShowDomeHideEffectSignal)
  EventManager:GetInstance():AddListener(EventId.UICreateFakePlaceBuild, self.OnCreateFakePlaceBuild)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ShowDomeShowEffect, self.ShowDomeShowEffectSignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowDomeHideEffect, self.ShowDomeHideEffectSignal)
  EventManager:GetInstance():RemoveListener(EventId.UICreateFakePlaceBuild, self.OnCreateFakePlaceBuild)
end

local function ShowDomeShowEffectSignal(data)
  if data ~= nil then
    local str = string.split(data, ";")
    if 3 <= #str then
      local uuid = tonumber(str[1])
      local pointId = tonumber(str[2])
      local range = tonumber(str[3])
      local effPrefab = str[4]
      local serverId = LuaEntry.Player:GetCurServerId()
      local world = CS.SceneManager.World
      if world then
        local info = world:GetPointInfoByUuid(uuid)
        if info ~= nil then
          serverId = info.serverId
        end
      end
      CityMovingEffectManager:GetInstance():ShowDomeShowEffect(uuid, pointId, range, effPrefab, serverId)
    end
  end
end

local function ShowDomeHideEffectSignal(data)
  if data ~= nil then
    local str = string.split(data, ";")
    if 3 <= #str then
      local uuid = tonumber(str[1])
      local pointId = tonumber(str[2])
      local range = tonumber(str[3])
      local serverId = LuaEntry.Player:GetCurServerId()
      local world = CS.SceneManager.World
      if world then
        local info = world:GetPointInfoByUuid(uuid)
        if info ~= nil then
          serverId = info.serverId
        end
      end
      CityMovingEffectManager:GetInstance():ShowDomeHideEffect(uuid, pointId, range, serverId)
    end
  end
end

local function ShowDomeShowEffect(self, bUuid, posIndex, range, effPrefab, serverId)
  local param = {}
  param.bUuid = bUuid
  param.posIndex = posIndex
  param.serverId = serverId
  if self.allShowEffect[bUuid] then
    self:RemoveCityDomeShowEffect(bUuid)
  elseif self.OnCreateShowEffect[bUuid] then
    self.OnCreateShowEffect[bUuid]:Destroy()
    self.OnCreateShowEffect[bUuid] = nil
  end
  local prefabName = effPrefab
  if string.IsNullOrEmpty(prefabName) then
    prefabName = "Assets/_Art/Effect/prefab/scene/Build/Dabenqianyi/VFX_world_zhucheng_qianyi_hui.prefab"
  end
  local request = ResourceManager:InstantiateAsync(prefabName)
  self.OnCreateShowEffect[bUuid] = request
  request:completed("+", function()
    self.OnCreateShowEffect[bUuid] = nil
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    if CS.SceneManager.World and CS.SceneManager.World.DynamicObjNode then
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    end
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    param.endTime = MOVE_CITY_EFFECT_DURATION + UITimeManager:GetInstance():GetServerSeconds()
    local effect = CityDomeShowEffect.New()
    effect:OnCreate(request)
    effect:ReInit(param)
    self.allShowEffect[bUuid] = effect
  end)
end

local function RemoveCityDomeShowEffect(self, bUuid)
  local temp = self.allShowEffect[bUuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    request:Destroy()
    self.allShowEffect[bUuid] = nil
  end
end

local function ShowDomeHideEffect(self, bUuid, posIndex, range, serverId)
  local param = {}
  param.bUuid = bUuid
  param.posIndex = posIndex
  param.serverId = serverId
  if self.allHideEffect[bUuid] == nil and self.OnCreateHideEffect[bUuid] == nil then
    local prefabName = "Assets/_Art/Effect/prefab/scene/Build/Dabenqianyi/VFX_world_zhucheng_qianyi.prefab"
    local request = ResourceManager:InstantiateAsync(prefabName)
    self.OnCreateHideEffect[bUuid] = request
    request:completed("+", function()
      self.OnCreateHideEffect[bUuid] = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      if CS.SceneManager.World and CS.SceneManager.World.DynamicObjNode then
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      end
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      param.endTime = MOVE_CITY_EFFECT_DURATION + UITimeManager:GetInstance():GetServerSeconds()
      local effect = CityDomeHideEffect.New()
      effect:OnCreate(request)
      effect:ReInit(param)
      self.allHideEffect[bUuid] = effect
    end)
    local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
    local hasVirus, theEffectId, theVirusMaxEffectId = SeasonUtil.HasVirus()
    if hasVirus and theVirusMaxEffectId ~= nil and theVirusMaxEffectId ~= 0 and info ~= nil and info.PointType == WorldPointType.PlayerBuilding then
      cast(info, typeof(CS.BuildPointInfo))
      do
        local statusList = info.status
        if hasVirus and statusList ~= nil and 0 < statusList.Count then
          local count = statusList.Count
          for i = 0, count - 1 do
            local oneStatus = statusList[i]
            if oneStatus and oneStatus.Id == theVirusMaxEffectId and oneStatus.ExpireTime then
              local now = UITimeManager:GetInstance():GetServerTime()
              local cfgTime = LuaEntry.DataConfig:TryGetNum("season_virus", "k2", 30)
              local deltaTime = oneStatus.BeginTime + cfgTime * 1000 - now
              if deltaTime < 233 then
                local effectPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_Common_duboom_002.prefab"
                CS.SceneManager.World:CreateBattleVFX(effectPath, 7, function(go)
                  if SceneUtils.GetIsInWorld() and go ~= nil then
                    local curServerId = LuaEntry.Player:GetCurServerId()
                    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
                    go.transform.position = SceneUtils.TileIndexToWorld(posIndex, ForceChangeScene.World, curServerId)
                    go.transform:Set_localScale(1, 1, 1)
                    go:SetActive(true)
                  end
                end)
              end
              break
            end
          end
        end
      end
    end
  end
end

local function RemoveCityDomeHideEffect(self, bUuid)
  local temp = self.allHideEffect[bUuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    request:Destroy()
    self.allHideEffect[bUuid] = nil
  end
end

local function OnCreateFakePlaceBuild()
  local tempBuild = CS.SceneManager.World.preCreateBuild
  if tempBuild ~= nil and tempBuild.city ~= nil then
    local nameStr = LuaEntry.Player:GetFullName() or ""
    local countryFlag = LuaEntry.Player.countryFlag or DefaultNation
    local banFlag = LuaEntry.Player:IsFromBIGCHINAorUsingLangZH()
    local cityLabels = tempBuild.city.gameObject:GetComponentsInChildren(typeof(CS.UIWorldLabel), true)
    if cityLabels and cityLabels.Length > 0 then
      for i = 0, cityLabels.Length - 1 do
        local cityLabel = cityLabels[i]
        cityLabel:ShowFlag(not banFlag)
        if not banFlag then
          cityLabel:SetFlag(countryFlag)
        end
        cityLabel:SetName(nameStr)
        cityLabel:SetLevel(LuaEntry.Player.level)
      end
    else
      local levelTrans = tempBuild.city.transform:Find("ModelGo/CityLabel/levelLabel/LevelLabel/LevelText")
      if levelTrans then
        local levelText = levelTrans:GetComponent(typeof(CS.SuperTextMesh))
        if levelText then
          levelText.text = DataCenter.BuildManager.MainLv
        end
      end
      local nameTrans = tempBuild.city.transform:Find("ModelGo/CityLabel/NameLabel/NameText")
      if nameTrans then
        local nameText = nameTrans:GetComponent(typeof(CS.SuperTextMesh))
        if nameText then
          nameText.text = nameStr
        end
      end
      local bgTrans = tempBuild.city.transform:Find("ModelGo/CityLabel/NameLabel")
      if bgTrans then
        local bg = bgTrans:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        if bg then
          bg:LoadSprite("Assets/Main/Sprites/UI/UITitleTag/appellation_icon_arena")
        end
      end
      local levelTrans2 = tempBuild.city.transform:Find("Icon/CityLabel/LevelLabel/LevelLabel/LevelText")
      if levelTrans2 then
        local levelText = levelTrans2:GetComponent(typeof(CS.SuperTextMesh))
        if levelText then
          levelText.text = DataCenter.BuildManager.MainLv
        end
      end
      local flagTran = tempBuild.city.transform:Find("ModelGo/CityLabel/NameLabel/Flag")
      if flagTran then
        local flagSr = flagTran:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        if flagSr then
          if banFlag then
            flagSr.gameObject:SetActive(false)
          else
            flagSr.gameObject:SetActive(true)
            local template = DataCenter.NationTemplateManager:GetNationTemplate(countryFlag)
            flagSr:LoadSprite(template:GetNationFlagPath())
          end
        end
      end
    end
  end
end

CityMovingEffectManager.__init = __init
CityMovingEffectManager.__delete = __delete
CityMovingEffectManager.AddListener = AddListener
CityMovingEffectManager.RemoveListener = RemoveListener
CityMovingEffectManager.ShowDomeShowEffectSignal = ShowDomeShowEffectSignal
CityMovingEffectManager.ShowDomeHideEffectSignal = ShowDomeHideEffectSignal
CityMovingEffectManager.ShowDomeShowEffect = ShowDomeShowEffect
CityMovingEffectManager.RemoveCityDomeShowEffect = RemoveCityDomeShowEffect
CityMovingEffectManager.ShowDomeHideEffect = ShowDomeHideEffect
CityMovingEffectManager.RemoveCityDomeHideEffect = RemoveCityDomeHideEffect
CityMovingEffectManager.OnCreateFakePlaceBuild = OnCreateFakePlaceBuild
return CityMovingEffectManager
