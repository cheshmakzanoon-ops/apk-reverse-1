local LandLockReceive = BaseClass("LandLockReceive")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource

local function __init(self)
  self.transform = nil
  self.gameObject = nil
  self.id = 0
  self.req = nil
  self.tilePos = nil
end

local function __delete(self)
  self.transform = nil
  self.gameObject = nil
  self.id = nil
  self.req = nil
  self.tilePos = nil
end

local function Init(self, id, pointId, rewardType)
  self.id = id
  local h, v = 8, 5
  local hvStrs = string.split(LuaEntry.DataConfig:TryGetStr("land_unlock", "k5") or "", ";")
  if #hvStrs == 2 then
    h = tonumber(hvStrs[1])
    v = tonumber(hvStrs[2])
  end
  local x = math.random(-h, h)
  local y = math.random(-v, v)
  local tilePos = SceneUtils.IndexToTilePos(pointId)
  tilePos.x = tilePos.x + x
  tilePos.y = tilePos.y + y
  self.tilePos = tilePos
  if rewardType == LandLockRewardType.CallChest then
    self.fallPrefab = "Assets/Main/Prefabs/World/LandLockCallChest.prefab"
    
    function self.doFallAnim()
      local rand = math.random(1, 5)
      local anim = self.transform:Find("XS_kongtou@jls_skin"):GetComponent(typeof(CS.SimpleAnimation))
      anim:Play("fall" .. rand)
    end
    
    self.fallTime = 3
    self.landingPrefab = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_kongtou.prefab"
    
    function self.doAfterLanding()
      if self.req ~= nil then
        self.req:Destroy()
      end
    end
    
    self.landingTime = 2
  elseif rewardType == LandLockRewardType.CallSoldier then
    self.fallPrefab = "Assets/Main/Prefabs/World/LandLockCallSoldier_Fall.prefab"
    
    function self.doFallAnim()
      local director = self.transform:Find("KT_jiangluo_Timeline"):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
      director:Play()
    end
    
    self.fallTime = 3
    self.landingPrefab = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_kongtou.prefab"
    
    function self.doAfterLanding()
      if self.req ~= nil then
        self.req:Destroy()
      end
    end
    
    self.landingTime = 2
  end
end

local function PlayFall(self)
  self.req = Resource:InstantiateAsync(self.fallPrefab)
  self.req:completed("+", function()
    if self.req.isError or CS.SceneManager.IsInPVE() then
      self.req:Destroy()
      return
    end
    local world = CS.SceneManager.World
    if world == nil then
      self.req:Destroy()
      return
    end
    self.gameObject = self.req.gameObject
    self.gameObject:SetActive(true)
    self.gameObject.name = "LandLockReceive_Fall_" .. (self.id or 0)
    self.transform = self.gameObject.transform
    self.transform:SetParent(world.DynamicObjNode)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform.position = SceneUtils.TileToWorld(self.tilePos)
    self.doFallAnim()
    TimerManager:GetInstance():DelayInvoke(function()
      self:PlayLanding()
    end, self.fallTime)
  end)
end

local function PlayLanding(self)
  if self.req == nil then
    return
  end
  self.req:Destroy()
  self.req = Resource:InstantiateAsync(self.landingPrefab)
  self.req:completed("+", function()
    if self.req.isError or CS.SceneManager.IsInPVE() then
      self.req:Destroy()
      return
    end
    local world = CS.SceneManager.World
    if world == nil then
      self.req:Destroy()
      return
    end
    self.gameObject = self.req.gameObject
    self.gameObject:SetActive(true)
    self.gameObject.name = "LandLockReceive_Landing_" .. (self.id or 0)
    self.transform = self.gameObject.transform
    self.transform:SetParent(world.DynamicObjNode)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform.position = SceneUtils.TileToWorld(self.tilePos)
    TimerManager:GetInstance():DelayInvoke(function()
      self.doAfterLanding()
    end, self.landingTime)
  end)
end

local function WalkToMain(self)
  if self.req == nil then
    return
  end
  local mainPos = SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos)
  self.transform:LookAt(mainPos)
  self.transform:DOMove(mainPos, 4):SetSpeedBased():SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
    if self.req ~= nil then
      self.req:Destroy()
    end
  end)
  local anim = self.transform:Find("A_soldie@jqb_skin"):GetComponent(typeof(CS.SimpleAnimation))
  anim:Play("run")
end

LandLockReceive.__init = __init
LandLockReceive.__delete = __delete
LandLockReceive.OnCreate = OnCreate
LandLockReceive.OnDestroy = OnDestroy
LandLockReceive.Init = Init
LandLockReceive.PlayFall = PlayFall
LandLockReceive.PlayLanding = PlayLanding
LandLockReceive.WalkToMain = WalkToMain
return LandLockReceive
