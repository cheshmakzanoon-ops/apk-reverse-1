local PveLineup = BaseClass("PveLineup")
local Const = require("Scene.BattlePveModule.Const")
local ResourceManager = CS.GameEntry.Resource
local _prefabPath = "Assets/Main/Prefabs/PVE/PVEScene.prefab"
local _prefab_special_Path = "Assets/Main/Prefabs/PVE/PVEScene_Special.prefab"
local _enemynames = {
  "pve_js/enemy01",
  "pve_js/enemy02",
  "pve_js/enemy03",
  "pve_js/enemy04",
  "pve_js/enemy05"
}
local _mynames = {
  "pve_js/our01",
  "pve_js/our02",
  "pve_js/our03",
  "pve_js/our04",
  "pve_js/our05"
}
local _reverseenemynames = {
  "pve_js/enemy05",
  "pve_js/enemy04",
  "pve_js/enemy03",
  "pve_js/enemy02",
  "pve_js/enemy01"
}
local _reversemynames = {
  "pve_js/our05",
  "pve_js/our04",
  "pve_js/our03",
  "pve_js/our02",
  "pve_js/our01"
}
local Zero = Vector3.zero

function PveLineup:__init()
  self.enemyPos = {}
  self.enemyPosObj = {}
  self.myPos = {}
  self.myPosObj = {}
  self.heroSignIcon = {}
  self.enemySignIcon = {}
  self.m_goMaterBlock = CS.UnityEngine.MaterialPropertyBlock()
  self.heroSignPropertyId = CS.UnityEngine.Shader.PropertyToID("_Color")
  self.timelineReq = nil
end

function PveLineup:__delete()
  self:RemoveTimeLine()
  self.enemyPos = nil
  self.enemyPosObj = nil
  self.myPos = nil
  self.myPosObj = nil
  self.heroSignIcon = nil
end

function PveLineup:__initPostions(isReverse)
  local enemy = _enemynames
  local my = _mynames
  if isReverse ~= nil and isReverse == true then
    enemy = _reverseenemynames
    my = _reversemynames
  end
  self.enemyPos = {}
  self.myPos = {}
  self.heroSignIcon = {}
  for k, v in ipairs(enemy) do
    local t = self.m_gameObject.transform:Find(v)
    local pos = Vector3.New(t.transform:Get_position())
    self.enemyPos[k] = pos
    self.enemyPosObj[k] = t
    self.enemySignIcon[k] = {
      iconQuality = t:Find("VFX_Quality").gameObject,
      render1 = t:Find("VFX_Quality"):GetComponent(typeof(CS.UnityEngine.Renderer)),
      render2 = t:Find("VFX_Quality/V_plane"):GetComponent(typeof(CS.UnityEngine.Renderer))
    }
    self.enemySignIcon[k].iconQuality:SetActive(false)
  end
  local myPosCount = #my
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local mineIndex, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
    local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    myPosCount = MarchUtil.GetMaxHeroValueByFormationIndex(formationInfo.index)
  elseif entranceType == PveEntrance.ArenaSetting or entranceType == PveEntrance.ArenaBattle or entranceType == PveEntrance.AdventureSetting or entranceType == PveEntrance.Adventure then
    myPosCount = MarchUtil.GetMaxHeroValueByFormationIndex(1)
  end
  local k5 = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k5")
  local arr = string.split(k5, ";")
  local level = DataCenter.BuildManager.MainLv
  local levelType = DataCenter.BattleLevel:GetLevelType()
  for k, v in ipairs(my) do
    local t = self.m_gameObject.transform:Find(v)
    if k <= myPosCount then
      t.gameObject:SetActive(true)
    else
      t.gameObject:SetActive(false)
    end
    local pos = Vector3.New(t.transform:Get_position())
    self.myPos[k] = pos
    self.myPosObj[k] = t
    self.heroSignIcon[k] = {
      iconAdd = t:Find("VFX_Add").gameObject,
      iconQuality = t:Find("VFX_Quality").gameObject,
      render1 = t:Find("VFX_Quality"):GetComponent(typeof(CS.UnityEngine.Renderer)),
      render2 = t:Find("VFX_Quality/V_plane"):GetComponent(typeof(CS.UnityEngine.Renderer)),
      iconLock = t:Find("VFX_Lock").gameObject,
      isLock = true
    }
    self.heroSignIcon[k].iconQuality:SetActive(false)
    if levelType == PveLevelType.BattleExpLevel or levelType == PveLevelType.RadarExpLevel then
      local heroMaxCount = DataCenter.BattleLevel:GetMaxHeroCount()
      if k <= heroMaxCount then
        self.heroSignIcon[k].isLock = false
        self.heroSignIcon[k].iconAdd:SetActive(true)
      end
    elseif levelType == PveLevelType.BattlePlayBackLevel then
    elseif arr ~= nil and k <= #arr then
      local id = tonumber(arr[k])
      if id ~= nil and level ~= nil and level >= id then
        self.heroSignIcon[k].isLock = false
        self.heroSignIcon[k].iconAdd:SetActive(true)
      else
      end
    end
    if self.heroSignIcon[k].isLock then
      self.heroSignIcon[k].iconAdd:SetActive(false)
      self.heroSignIcon[k].iconLock:SetActive(true)
    else
      self.heroSignIcon[k].iconAdd:SetActive(true)
      self.heroSignIcon[k].iconLock:SetActive(false)
    end
    if levelType == PveLevelType.AdventureLevel then
      local heroUuidList = DataCenter.AdventureManager:GetHeroUuidList()
      if k <= #heroUuidList then
        local heroUuid = heroUuidList[k]
        local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
        self.heroSignIcon[k].iconQuality:SetActive(true)
        self:SetHeroSignIcon(k, heroData.rarity)
      else
        self.heroSignIcon[k].iconQuality:SetActive(false)
      end
      self.heroSignIcon[k].isLock = false
      self.heroSignIcon[k].iconAdd:SetActive(false)
      self.heroSignIcon[k].iconLock:SetActive(false)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.PVE_Lineup_Init_End)
end

function PveLineup:HideAllStandEffect()
  for _, v in pairs(self.enemySignIcon) do
    v.iconQuality:SetActive(false)
  end
  for _, v in pairs(self.heroSignIcon) do
    v.iconQuality:SetActive(false)
    v.iconLock:SetActive(false)
  end
end

function PveLineup:Init(pos, lineup_type, rotation)
  local levelType = DataCenter.BattleLevel:GetLevelType()
  local path = _prefabPath
  if levelType == PveLevelType.BattleExpLevel or levelType == PveLevelType.BattlePlayBackLevel or levelType == PveLevelType.RadarExpLevel then
    path = _prefab_special_Path
  end
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.ArenaSetting or entranceType == PveEntrance.ArenaBattle or entranceType == PveEntrance.BattlePlayBack then
    path = _prefab_special_Path
  end
  self.m_req = ResourceManager:InstantiateAsync(path)
  self.m_req:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    self.m_gameObject = _go
    self.m_gameObject.transform.position = pos
    self.m_gameObject.transform.localRotation = Quaternion.Euler(0, rotation, 0)
    if 180 < rotation then
      self:__initPostions(true)
    else
      self:__initPostions(false)
    end
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType ~= PveEntrance.MineCave and entranceType ~= PveEntrance.ArenaSetting and entranceType ~= PveEntrance.AdventureSetting then
      EventManager:GetInstance():Broadcast(EventId.PVE_Lineup_LoadOK)
    elseif entranceType == PveEntrance.MineCave and DataCenter.MineCaveManager:CheckIfNeedPreloadEnemy() then
      EventManager:GetInstance():Broadcast(EventId.PVE_Lineup_LoadOK)
    end
  end)
end

function PveLineup:Destroy()
  self:RemoveTimeLine()
  if self.m_req ~= nil then
    self.m_req:Destroy()
    self.m_req = nil
  end
end

function PveLineup:IsLoadOK()
  return self.m_req ~= nil and self.m_req.isDone
end

function PveLineup:GetMyPosPosition(index)
  if 1 <= index and index <= #self.myPos then
    return self.myPos[index]
  end
  return Zero
end

function PveLineup:GetEnemyPosPosition(index)
  if 1 <= index and index <= #self.enemyPos then
    return self.enemyPos[index]
  end
  return Zero
end

function PveLineup:GetStandObj(campType, index)
  local posObj
  if campType == Const.CampType.Player then
    posObj = self.myPosObj
  else
    posObj = self.enemyPosObj
  end
  if index < 1 or index > table.count(posObj) then
    return nil
  end
  return posObj[index]
end

local function GetIntensity(intensity)
  return Mathf.Pow(2, intensity)
end

local SignColors = {
  [0] = {
    Center = Vector4.New(0, 0, 0, 0) * GetIntensity(1),
    Border = Vector4.New(0.4980392156862745, 0.4980392156862745, 0.4980392156862745, 1) * GetIntensity(1)
  },
  [1] = {
    Center = Vector4.New(0.7490196078431373, 0.10196078431372549, 0, 1) * GetIntensity(1.38),
    Border = Vector4.New(0.7490196078431373, 0.39215686274509803, 0.3176470588235294, 1) * GetIntensity(1)
  },
  [2] = {
    Center = Vector4.New(0.7490196078431373, 0.10588235294117647, 0.6666666666666666, 1) * GetIntensity(1.8),
    Border = Vector4.New(0.7490196078431373, 0.3176470588235294, 0.6862745098039216, 1) * GetIntensity(1)
  },
  [3] = {
    Center = Vector4.New(0.10980392156862745, 0.3058823529411765, 0.7490196078431373, 1) * GetIntensity(0.882),
    Border = Vector4.New(0.27450980392156865, 0.396078431372549, 0.7490196078431373, 1) * GetIntensity(1.416)
  },
  [4] = {
    Center = Vector4.New(0.3803921568627451, 0.7490196078431373, 0.2, 1) * GetIntensity(0.5983),
    Border = Vector4.New(0.3803921568627451, 0.7490196078431373, 0.2, 1) * GetIntensity(1.416)
  },
  [5] = {
    Center = Vector4.New(0.7490196078431373, 0.21568627450980393, 0, 1) * GetIntensity(1.35),
    Border = Vector4.New(0.7490196078431373, 0.21568627450980393, 0, 1) * GetIntensity(1.35)
  }
}
PveLineup.SignColors = SignColors

function PveLineup:SetHeroSignIcon(index, rarity)
  if rarity ~= nil then
    local vector1 = SignColors[rarity].Center
    vector1.w = 1
    local vector2 = SignColors[rarity].Border
    vector2.w = 1
    self.heroSignIcon[index].iconAdd:SetActive(false)
    self.heroSignIcon[index].iconLock:SetActive(false)
    self.heroSignIcon[index].iconQuality:SetActive(true)
    self.m_goMaterBlock:SetVector(self.heroSignPropertyId, vector1)
    self.heroSignIcon[index].render1:SetPropertyBlock(self.m_goMaterBlock)
    self.m_goMaterBlock:SetVector(self.heroSignPropertyId, vector2)
    self.heroSignIcon[index].render2:SetPropertyBlock(self.m_goMaterBlock)
  else
    self.heroSignIcon[index].iconQuality:SetActive(false)
    if self.heroSignIcon[index].isLock then
      self.heroSignIcon[index].iconAdd:SetActive(false)
      self.heroSignIcon[index].iconLock:SetActive(true)
    else
      self.heroSignIcon[index].iconAdd:SetActive(true)
      self.heroSignIcon[index].iconLock:SetActive(false)
    end
  end
end

function PveLineup:RefreshHeroSigns()
  local heroes = PveActorMgr:GetInstance():GetHeros()
  local len = table.count(self.heroSignIcon)
  for index = 1, len do
    local rarity
    if heroes[index] ~= nil then
      local heroData = DataCenter.BattleLevel:GetPveHeroData(heroes[index].uuid)
      if heroData ~= nil then
        rarity = heroData.rarity
      end
    end
    self:SetHeroSignIcon(index, rarity)
  end
end

function PveLineup:HidehHeroSigns()
  local heroes = PveActorMgr:GetInstance():GetHeros()
  local len = table.count(self.heroSignIcon)
  for index = 1, len do
    if heroes[index] == nil then
      self.heroSignIcon[index].iconAdd:SetActive(false)
    end
  end
  self:HideAllStandEffect()
end

function PveLineup:RefreshEnemySigns(rarities)
  local len = table.count(self.enemySignIcon)
  for index = 1, len do
    local rarity = rarities[index]
    self.enemySignIcon[index].iconQuality:SetActive(rarity ~= nil)
    if rarity ~= nil then
      local vector1 = SignColors[rarity].Center
      vector1.w = 1
      local vector2 = SignColors[rarity].Border
      vector2.w = 1
      self.m_goMaterBlock:SetVector(self.heroSignPropertyId, vector1)
      self.enemySignIcon[index].render1:SetPropertyBlock(self.m_goMaterBlock)
      self.m_goMaterBlock:SetVector(self.heroSignPropertyId, vector2)
      self.enemySignIcon[index].render2:SetPropertyBlock(self.m_goMaterBlock)
    end
  end
end

function PveLineup:ShowSelfAttackTimeLine(isOther)
  if self.m_gameObject == nil then
    return
  end
  if self.timelineReq == nil then
    local model = "Assets/_Art/Effect/prefab/PVE/VFX_pve_skill_timeline.prefab"
    if isOther then
      model = "Assets/_Art/Effect/prefab/PVE/VFX_pve_skill_timeline_guai.prefab"
    end
    self.timelineReq = ResourceManager:InstantiateAsync(model)
    self.timelineReq:completed("+", function()
      if self.timelineReq.isError then
        self.timelineReq = nil
        return
      end
      self.timelineReq.gameObject:SetActive(true)
      self.timelineReq.gameObject.transform:SetParent(self.m_gameObject.transform)
      self.timelineReq.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.timelineReq.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, 3)
      local director = self.timelineReq.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
      if director ~= nil then
        local root = director.playableGraph:GetRootPlayable(0)
        if root ~= nil and root.SetSpeed ~= nil then
          root:SetSpeed(1.0 * PveActorMgr:GetInstance():GetSpeedOffset())
        end
      end
    end)
  end
end

function PveLineup:RemoveTimeLine()
  if self.timelineReq ~= nil then
    self.timelineReq:Destroy()
    self.timelineReq = nil
  end
end

return PveLineup
