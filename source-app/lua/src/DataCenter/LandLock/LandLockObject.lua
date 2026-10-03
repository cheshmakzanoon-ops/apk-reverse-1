local LandLockObject = BaseClass("LandLockObject")
local Resource = CS.GameEntry.Resource
local LandLockStaticObjects = require("DataCenter.LandLock.LandLockStaticObjects")
local root_path = "Root"
local alter_path = "Alter"
local lock_path = "Lock"
local LockPaths = {
  Normal = "Assets/_Art/Models/Environment/Interactive/JieSuoDiKuai_ui/prefab/O_env_landlock_suo.prefab",
  Axe = "Assets/_Art/Models/Environment/Interactive/JieSuoDiKuai_ui/prefab/O_env_jiesuo_fuzi.prefab",
  Wood = "Assets/_Art/Models/Environment/Interactive/JieSuoDiKuai_ui/prefab/O_env_jiesuodikuai_mutou.prefab"
}
local ManPath = "Assets/Main/Prefabs/CityScene/CitySpaceMan.prefab"
local AxePath = "Assets/_Art/Models/Soldier/Ben_weapons/prefab/A_soldie_ben_axe.prefab"
local ChopParticlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_shihuang_shouge.prefab"
local DropWoodPath = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_wood.prefab"
local GolloAlivePaths = {
  [1] = "Assets/_Art/Other/Mov/XS_tuohuang_pve/A_Monster_xjhd_01/prefab/A_monster_xjhd_01.prefab",
  [2] = "Assets/_Art/Other/Mov/XS_tuohuang_pve/A_Monster_xjhd_02/prefab/A_Monster_xjhd_02.prefab",
  [3] = "Assets/_Art/Other/Mov/XS_tuohuang_pve/A_Monster_xjhd_03/prefab/A_monster_xjhd_03.prefab"
}
local GolloDeadPath = "Assets/_Art/Other/Mov/XS_tuohuang_pve/A_build_th_mb/prefab/A_build_th_mb.prefab"
local ManDistance = 1.5
local ManAttackDuration = 2.5
local ManIdleDuration = 0.5
local ManCount = 8
local ChopDelay = 1
local ChopInterval = 0.467
local ChopDuration = 4.5
local ChopParticleDuration = 1
local GolloSpacingX = 2
local GolloSpacingZ = 2
local GolloPosDict = {
  [1] = {
    [1] = Vector3.New(0, 0, 0)
  },
  [2] = {
    [1] = Vector3.New(-0.5, 0, 0),
    [2] = Vector3.New(0.5, 0, 0)
  },
  [3] = {
    [1] = Vector3.New(-1, 0, 0),
    [2] = Vector3.New(0, 0, 0),
    [3] = Vector3.New(1, 0, 0)
  },
  [4] = {
    [1] = Vector3.New(-1.5, 0, 0),
    [2] = Vector3.New(-0.5, 0, 0),
    [3] = Vector3.New(0.5, 0, 0),
    [4] = Vector3.New(1.5, 0, 0)
  },
  [5] = {
    [1] = Vector3.New(-1, 0, 0.5),
    [2] = Vector3.New(0, 0, 0.5),
    [3] = Vector3.New(1, 0, 0.5),
    [4] = Vector3.New(-0.5, 0, -0.5),
    [5] = Vector3.New(0.5, 0, -0.5)
  },
  [6] = {
    [1] = Vector3.New(-1, 0, 0.5),
    [2] = Vector3.New(0, 0, 0.5),
    [3] = Vector3.New(1, 0, 0.5),
    [4] = Vector3.New(-1, 0, -0.5),
    [5] = Vector3.New(0, 0, -0.5),
    [6] = Vector3.New(1, 0, -0.5)
  },
  [7] = {
    [1] = Vector3.New(-1.5, 0, 0.5),
    [2] = Vector3.New(-0.5, 0, 0.5),
    [3] = Vector3.New(0.5, 0, 0.5),
    [4] = Vector3.New(1.5, 0, 0.5),
    [5] = Vector3.New(-1, 0, -0.5),
    [6] = Vector3.New(0, 0, -0.5),
    [7] = Vector3.New(1, 0, -0.5)
  },
  [8] = {
    [1] = Vector3.New(-1.5, 0, 0.5),
    [2] = Vector3.New(-0.5, 0, 0.5),
    [3] = Vector3.New(0.5, 0, 0.5),
    [4] = Vector3.New(1.5, 0, 0.5),
    [5] = Vector3.New(-1.5, 0, -0.5),
    [6] = Vector3.New(-0.5, 0, -0.5),
    [7] = Vector3.New(0.5, 0, -0.5),
    [8] = Vector3.New(1.5, 0, -0.5)
  }
}

local function __init(self, req)
  self.req = req
end

local function __delete(self)
  self.req = nil
end

local function Create(self, data)
  self.data = data
  self.isPlayingFinishAnim = false
  self.gameObject = self.req.gameObject
  self.transform = self.gameObject.transform
  self.rootTf = self.transform:Find(root_path)
  self.trees = {}
  self.reqs = {
    trees = {},
    men = {},
    axes = {},
    dynamicObjs = {},
    particles = {},
    drops = {},
    golloes = {},
    builds = {}
  }
  self.lockReq = nil
  self.lockGo = nil
  local lockTf = self.transform:Find(lock_path)
  if lockTf then
    self.lockGo = lockTf.gameObject
  end
  self.touchEvent = self.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
  if self.touchEvent then
    function self.touchEvent.onPointerClick()
      self:OnClick()
    end
    
    function self.touchEvent.onPointerDoubleClick()
      self:OnClick()
    end
  end
  self:CreateTrees(function()
    self:Refresh()
    self:CalmTrees()
  end)
end

local function Destroy(self)
  self.data = nil
  self.isPlayingFinishAnim = nil
  self.gameObject = nil
  self.transform = nil
  self.trees = nil
  self.rootTf = nil
  self.lockGo = nil
  if self.reqs then
    for _, v in pairs(self.reqs) do
      for _, req in pairs(v) do
        req:Destroy()
      end
    end
    self.reqs = nil
  end
  if self.lockReq then
    self.lockReq:Destroy()
    self.lockReq = nil
  end
  if self.touchEvent then
    self.touchEvent.onPointerClick = nil
    self.touchEvent.onPointerDoubleClick = nil
    self.touchEvent = nil
  end
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
end

local function Refresh(self)
  if IsNull(self.gameObject) then
    return
  end
  self:DoAlter()
  self:CullTrees()
  self:RefreshBuild()
  self:RefreshGolloes()
end

local function RefreshLock(self)
  local id = self.data.id
  local template = DataCenter.LandLockManager:GetTemplate(id)
  local prefabPath = ""
  if self.data.state == LandLockState.Hide then
    prefabPath = LockPaths.Normal
  elseif self.data.state == LandLockState.Locked then
    if template.bubbleType == LandLockBubbleType.Axe then
      prefabPath = LockPaths.Wood
    elseif template.bubbleType == LandLockBubbleType.Wood then
      prefabPath = LockPaths.Axe
    end
  end
  if prefabPath ~= "" then
    if self.lockReq ~= nil and self.lockReq.PrefabPath ~= prefabPath then
      self.lockReq:Destroy()
      self.lockReq = nil
      self.lockGo = nil
    end
    local pos = self.data:GetCenterWorldPos()
    if not IsNull(self.lockGo) then
      self.lockGo:SetActive(DataCenter.LandLockManager:IsLandLockInDome(id))
    elseif self.lockReq == nil then
      self.lockReq = Resource:InstantiateAsync(prefabPath)
      self.lockReq:completed("+", function(req)
        if req.isError or IsNull(self.gameObject) then
          req:Destroy()
          return
        end
        local go = req.gameObject
        local tf = go.transform
        go.name = "Lock_" .. id
        go:SetActive(DataCenter.LandLockManager:IsLandLockInDome(id))
        tf:SetParent(self.transform)
        tf.position = pos
        tf.rotation = Quaternion.identity
        tf.localScale = Vector3.one
        self.lockGo = go
      end)
    end
  elseif self.lockReq ~= nil then
    self.lockReq:Destroy()
    self.lockReq = nil
  end
end

local function RefreshBuild(self)
  if self.data:IsLandLockShowBuild() then
    local template = DataCenter.LandLockManager:GetTemplate(self.data.id)
    for i = 1, #template.showBuildIds do
      local buildId = DataCenter.BuildManager:GetBuildId(template.showBuildIds[i])
      local level = DataCenter.BuildManager:GetBuildLevel(template.showBuildIds[i])
      local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      local prefabPath = string.format(LoadPath.Building, buildLevelTemplate.model)
      local tilePos = {}
      local bPos = template.buildPosList[i]
      if bPos ~= nil then
        tilePos.x = DataCenter.BuildManager.main_city_pos.x + bPos.x
        tilePos.y = DataCenter.BuildManager.main_city_pos.y + bPos.y
      else
        tilePos = SceneUtils.IndexToTilePos(self.data:GetCenterPointId(), ForceChangeScene.City)
      end
      if not string.IsNullOrEmpty(buildLevelTemplate.model_full_path) then
        prefabPath = buildLevelTemplate.model_full_path
      end
      self.reqs.builds[i] = Resource:InstantiateAsync(prefabPath)
      self.reqs.builds[i]:completed("+", function(req)
        if req.isError or IsNull(self.gameObject) then
          req:Destroy()
          return
        end
        local go = req.gameObject
        local tf = go.transform
        go.name = "Build_" .. i
        go:SetActive(true)
        tf:SetParent(self.transform)
        tf.position = SceneUtils.TileToWorld(tilePos)
        tf.rotation = Quaternion.identity
        tf.localScale = Vector3.one
      end)
    end
  else
    for _, req in ipairs(self.reqs.builds) do
      req:Destroy()
    end
    self.reqs.builds = {}
  end
end

local function RefreshGolloes(self)
  if (self.data.state == LandLockState.Locked or self.data.state == LandLockState.Unlocked) and #self.data.pveList > 1 then
    local count = #self.data.pveList
    for i = 1, count do
      if self.reqs.golloes[i] == nil then
        local prefabPath
        local pos = self.data:GetCenterWorldPos() + self:GetGolloOffset(count, i)
        pos.y = pos.y + 0.05
        local rot = 0
        if i <= self.data:GetPveFinishCount() then
          prefabPath = GolloDeadPath
          pos.z = pos.z - 0.5
        else
          local n = (i - 1) % #GolloAlivePaths + 1
          prefabPath = GolloAlivePaths[n]
          pos.z = pos.z - 1
          rot = 180
        end
        self.reqs.golloes[i] = Resource:InstantiateAsync(prefabPath)
        self.reqs.golloes[i]:completed("+", function(req)
          if req.isError or IsNull(self.gameObject) then
            req:Destroy()
            return
          end
          local go = req.gameObject
          local tf = go.transform
          go.name = "Gollo_" .. i
          go:SetActive(true)
          tf:SetParent(self.transform)
          tf.position = pos
          tf.rotation = Quaternion.Euler(0, rot, 0)
          tf.localScale = Vector3.one * 1.5
          local anim = tf:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
          anim:SetTrigger("idle")
        end)
      end
    end
  else
    for _, req in ipairs(self.reqs.golloes) do
      req:Destroy()
    end
    self.reqs.golloes = {}
  end
end

local function GetGolloOffset(self, count, i)
  local offset = DeepCopy(GolloPosDict[count][i] or Vector3.zero)
  offset.x = offset.x * GolloSpacingX
  offset.z = offset.z * GolloSpacingZ
  return offset
end

local function GetTreeAnims(self, tree)
  local list = {}
  local arr = tree:GetComponentsInChildren(typeof(CS.SimpleAnimation))
  for i = 0, arr.Length - 1 do
    table.insert(list, arr[i])
  end
  return list
end

local function ChangeTreeState(self, tree, index)
  local stateName = string.format("state%02d", index)
  for i = 0, tree.childCount - 1 do
    local tf = tree:GetChild(i)
    if string.startswith(tf.gameObject.name, "sub") then
      self:ChangeTreeState(tf, index)
    else
      tf.gameObject:SetActive(tf.gameObject.name == stateName)
    end
  end
end

local function DoAlter(self)
  local alterTf = self.transform:Find(alter_path)
  if alterTf == nil then
    return
  end
  local dict = {}
  for _, alter in ipairs(self.data.alters) do
    local spls = string.split(alter, "_")
    local firstName = spls[1]
    local secondName = string.sub(alter, #firstName + 2, #alter)
    dict[firstName] = secondName
  end
  for i = 0, alterTf.childCount - 1 do
    local firstTf = alterTf:GetChild(i)
    local firstName = firstTf.gameObject.name
    local firstShow = dict[firstName] ~= nil
    firstTf.gameObject:SetActive(firstShow)
    if firstShow then
      for j = 0, firstTf.childCount - 1 do
        local secondTf = firstTf:GetChild(j)
        local secondName = secondTf.gameObject.name
        local secondShow = secondName == dict[firstName]
        secondTf.gameObject:SetActive(secondShow)
        local alter = firstName .. "_" .. secondName
        local useDynamicObj = false
        if self.data.dynamicObj[alter] ~= nil then
          for _, prefabPath in ipairs(self.data.dynamicObj[alter]) do
            local pathSpls = string.split(prefabPath, "/")
            local prefabName = pathSpls[#pathSpls]
            if string.endswith(prefabName, ".prefab") then
              prefabName = string.sub(prefabName, 1, #prefabName - 7)
            end
            if secondTf:Find(prefabName) == nil and self.reqs.dynamicObjs[prefabPath] == nil then
              useDynamicObj = true
              self.reqs.dynamicObjs[prefabPath] = Resource:InstantiateAsync(prefabPath)
              self.reqs.dynamicObjs[prefabPath]:completed("+", function(req)
                if req.isError or IsNull(self.gameObject) or firstTf == nil or secondTf == nil then
                  req:Destroy()
                  return
                end
                local go = req.gameObject
                local tf = go.transform
                go.name = prefabName
                tf:SetParent(secondTf)
                tf.localPosition = Vector3.zero
                tf.localRotation = Quaternion.identity
                self:CheckLastTimeline(secondTf, alter)
              end)
            end
          end
        end
        if not useDynamicObj then
          self:CheckLastTimeline(secondTf, alter)
        end
      end
    end
  end
end

local function CheckLastTimeline(self, secondTf, alter)
  if alter == self.data.alters[#self.data.alters] then
    local director = secondTf:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    if director ~= nil then
      local id = self.data.id
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.LandLockManager:OnLandLockTimeLineFinish(id, alter)
      end, director.duration)
    end
  end
end

local function PlayFinishAnim(self, callback)
  if self.isPlayingFinishAnim then
    return
  end
  if IsNull(self.gameObject) then
    if callback() then
      callback()
    end
    return
  end
  local id = self.data.id
  local template = DataCenter.LandLockManager:GetTemplate(id)
  if template.animOff then
    if callback then
      callback()
    end
    return
  end
  self.isPlayingFinishAnim = true
  self:ChopTrees(function()
    self.isPlayingFinishAnim = false
    if callback then
      callback()
    end
  end)
end

local function CreateTrees(self, callback)
  local t = LandLockStaticObjects[self.data.id]
  if t then
    local count = 0
    for i, v in ipairs(t) do
      self.reqs.trees[i] = Resource:InstantiateAsync(v.path)
      self.reqs.trees[i]:completed("+", function(req)
        if req.isError or IsNull(self.gameObject) then
          req:Destroy()
          return
        end
        local go = req.gameObject
        local tf = go.transform
        go.name = "Tree_" .. i
        tf:SetParent(self.rootTf)
        tf.localPosition = Vector3.New(v.x, v.y, v.z)
        table.insert(self.trees, tf)
        count = count + 1
        if count >= #t and callback then
          callback()
        end
      end)
    end
  elseif callback then
    callback()
  end
end

local function CalmTrees(self)
  for _, tree in ipairs(self.trees) do
    self:ChangeTreeState(tree, 1)
    local anims = self:GetTreeAnims(tree)
    for _, anim in ipairs(anims) do
      anim:Stop()
    end
  end
end

local function ChopTrees(self, callback)
  if table.IsNullOrEmpty(self.trees) then
    callback()
    return
  end
  local localCallback = callback
  for i, tree in ipairs(self.trees) do
    if tree.gameObject.activeSelf then
      local delay = math.random() * ChopDelay
      local rad = math.random() * math.pi * 2
      local manPos = tree.position + Vector3.New(math.cos(rad), 0, math.sin(rad)) * ManDistance
      local manRot = Quaternion.LookRotation(Vector3.New(tree.position.x - manPos.x, 0, tree.position.z - manPos.z))
      if i <= ManCount then
        TimerManager:GetInstance():DelayInvoke(function()
          if IsNull(self.gameObject) then
            if localCallback then
              localCallback()
              localCallback = nil
            end
            return
          end
          self.reqs.men[i] = Resource:InstantiateAsync(ManPath)
          self.reqs.men[i]:completed("+", function(req)
            if req.isError or IsNull(self.gameObject) then
              req:Destroy()
              return
            end
            local go = req.gameObject
            local tf = go.transform
            go:SetActive(true)
            tf:SetParent(self.transform)
            tf.position = manPos
            tf.rotation = manRot
            tf.localScale = Vector3.one
            local anim = tf:Find("A_soldie_ben/A_soldie@ben_skin"):GetComponent(typeof(CS.UnityEngine.Animator))
            anim:SetTrigger("attack")
            TimerManager:GetInstance():DelayInvoke(function()
              if IsNull(self.gameObject) or anim == nil then
                return
              end
              anim:SetTrigger("idle")
              TimerManager:GetInstance():DelayInvoke(function()
                if req ~= nil then
                  req:Destroy()
                end
              end, ManIdleDuration)
            end, ManAttackDuration)
            local weaponTf = tf:Find("A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/weapon")
            if weaponTf then
              weaponTf.gameObject:SetActive(true)
              self.reqs.axes[i] = Resource:InstantiateAsync(AxePath)
              self.reqs.axes[i]:completed("+", function(req)
                if req.isError or IsNull(self.gameObject) or weaponTf == nil then
                  req:Destroy()
                  return
                end
                local go = req.gameObject
                local tf = go.transform
                go:SetActive(true)
                tf:SetParent(weaponTf)
                tf.localPosition = Vector3.zero
                tf.localRotation = Quaternion.identity
                tf.localScale = Vector3.one * 0.8
              end)
            end
          end)
        end, delay)
      end
      for j = 2, 6 do
        TimerManager:GetInstance():DelayInvoke(function()
          if IsNull(self.gameObject) then
            return
          end
          self:ChangeTreeState(tree, j)
          local anims = self:GetTreeAnims(tree)
          for _, anim in ipairs(anims) do
            anim:Play("dig")
            self.reqs.particles[i] = Resource:InstantiateAsync(ChopParticlePath)
            self.reqs.particles[i]:completed("+", function(req)
              if req.isError or IsNull(self.gameObject) or anim == nil or IsNull(anim.gameObject) then
                req:Destroy()
                return
              end
              local go = req.gameObject
              local tf = go.transform
              go:SetActive(true)
              tf:SetParent(anim.transform)
              tf.localPosition = Vector3.zero
              tf.localScale = Vector3.one
              TimerManager:GetInstance():DelayInvoke(function()
                if req ~= nil then
                  req:Destroy()
                end
              end, ChopParticleDuration)
            end)
            self.reqs.drops[i] = Resource:InstantiateAsync(DropWoodPath)
            self.reqs.drops[i]:completed("+", function(req)
              if req.isError or IsNull(self.gameObject) or anim == nil or IsNull(anim.gameObject) then
                req:Destroy()
                return
              end
              local go = req.gameObject
              local tf = go.transform
              go:SetActive(true)
              tf.position = anim.transform.position
              tf.rotation = Quaternion.Euler(0, math.random(0, 359), 0)
              tf.localScale = Vector3.one
              local x = (math.random() - 0.5) * 0.5
              local z = (math.random() - 0.5) * 0.5
              local pos = anim.transform.position + Vector3.New(x, 1, z)
              local move = go:GetComponent(typeof(CS.RandMove))
              move:StartFly(pos, anim.gameObject, function()
                if req ~= nil then
                  req:Destroy()
                end
              end)
            end)
          end
        end, delay + (j - 2) * ChopInterval + 0.25)
      end
    end
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if localCallback then
      localCallback()
    end
  end, ChopDuration)
end

local function CullTrees(self)
  if table.IsNullOrEmpty(self.trees) then
    return
  end
  local range = DataCenter.CityDomeManager:GetDomeRangeCache()
  local exRadius = LandLockDomeExRadius[range]
  for _, tree in ipairs(self.trees) do
    local show = DataCenter.CityDomeManager:IsInDome(tree.position, exRadius)
    if show ~= tree.gameObject.activeSelf then
      tree.gameObject:SetActive(show)
    end
  end
end

local function OnClick(self)
  DataCenter.LandLockManager:ClickLandLockById(self.data.id)
end

LandLockObject.__init = __init
LandLockObject.__delete = __delete
LandLockObject.Create = Create
LandLockObject.Destroy = Destroy
LandLockObject.Refresh = Refresh
LandLockObject.RefreshLock = RefreshLock
LandLockObject.RefreshBuild = RefreshBuild
LandLockObject.RefreshGolloes = RefreshGolloes
LandLockObject.GetGolloOffset = GetGolloOffset
LandLockObject.GetTreeAnims = GetTreeAnims
LandLockObject.ChangeTreeState = ChangeTreeState
LandLockObject.DoAlter = DoAlter
LandLockObject.CheckLastTimeline = CheckLastTimeline
LandLockObject.PlayFinishAnim = PlayFinishAnim
LandLockObject.CreateTrees = CreateTrees
LandLockObject.CalmTrees = CalmTrees
LandLockObject.ChopTrees = ChopTrees
LandLockObject.CullTrees = CullTrees
LandLockObject.OnClick = OnClick
return LandLockObject
