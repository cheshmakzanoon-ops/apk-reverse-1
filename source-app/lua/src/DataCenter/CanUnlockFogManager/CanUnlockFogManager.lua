local CanUnlockFogManager = BaseClass("CanUnlockFogManager")
local Data = CS.GameEntry.Data
local ResourceManager = CS.GameEntry.Resource
local FogCanUnlockEffect = require("Scene.FogCanUnlockEffect.FogCanUnlockEffect")
local PerUnlockTime = 250.0
local FogUnlockGapTime = 500.0
local UpdateTime = 50.0
local WaitAnimationTime = 1000.0
local UnlockSort = {
  [CanUnlockFogSmallDirection.LeftDown] = {
    CanUnlockFogSmallDirection.LeftDown,
    CanUnlockFogSmallDirection.RightDown,
    CanUnlockFogSmallDirection.RightTop,
    CanUnlockFogSmallDirection.LeftTop
  },
  [CanUnlockFogSmallDirection.RightDown] = {
    CanUnlockFogSmallDirection.RightDown,
    CanUnlockFogSmallDirection.RightTop,
    CanUnlockFogSmallDirection.LeftTop,
    CanUnlockFogSmallDirection.LeftDown
  },
  [CanUnlockFogSmallDirection.RightTop] = {
    CanUnlockFogSmallDirection.RightTop,
    CanUnlockFogSmallDirection.LeftTop,
    CanUnlockFogSmallDirection.LeftDown,
    CanUnlockFogSmallDirection.RightDown
  },
  [CanUnlockFogSmallDirection.LeftTop] = {
    CanUnlockFogSmallDirection.LeftTop,
    CanUnlockFogSmallDirection.RightTop,
    CanUnlockFogSmallDirection.RightDown,
    CanUnlockFogSmallDirection.LeftDown
  }
}
local UnlockChangeOther = {
  [CanUnlockFogSmallDirection.LeftDown] = {
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.LeftDown,
      animName = FogCanUnlockEffectAnimName.CanLockToUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.LeftTop,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.RightDown,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Left,
      smallDirection = CanUnlockFogSmallDirection.RightDown,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Down,
      smallDirection = CanUnlockFogSmallDirection.LeftTop,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    }
  },
  [CanUnlockFogSmallDirection.RightDown] = {
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.RightDown,
      animName = FogCanUnlockEffectAnimName.CanLockToUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.LeftDown,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.RightTop,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Right,
      smallDirection = CanUnlockFogSmallDirection.LeftDown,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Down,
      smallDirection = CanUnlockFogSmallDirection.RightTop,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    }
  },
  [CanUnlockFogSmallDirection.RightTop] = {
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.RightTop,
      animName = FogCanUnlockEffectAnimName.CanLockToUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.RightDown,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.LeftTop,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Right,
      smallDirection = CanUnlockFogSmallDirection.LeftTop,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Top,
      smallDirection = CanUnlockFogSmallDirection.RightDown,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    }
  },
  [CanUnlockFogSmallDirection.LeftTop] = {
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.LeftTop,
      animName = FogCanUnlockEffectAnimName.CanLockToUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.RightTop,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Own,
      smallDirection = CanUnlockFogSmallDirection.LeftDown,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Left,
      smallDirection = CanUnlockFogSmallDirection.RightTop,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    },
    {
      unlockFogDirection = UnlockFogDirection.Top,
      smallDirection = CanUnlockFogSmallDirection.LeftDown,
      animName = FogCanUnlockEffectAnimName.LockToCanUnlock
    }
  }
}

local function __init(self)
  self.allFogEffect = {}
  self.unlockParam = nil
  self:AddListener()
end

local function __delete(self)
  self.allFogEffect = nil
  self.unlockParam = nil
  self:RemoveListener()
end

local function Startup()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.UnlockFogAnim, self.UnlockFogAnimSignal)
  EventManager:GetInstance():AddListener(EventId.FarmGuideFakePlantShowState, self.FarmGuideFakePlantShowStateSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.UnlockFogAnim, self.UnlockFogAnimSignal)
  EventManager:GetInstance():RemoveListener(EventId.FarmGuideFakePlantShowState, self.FarmGuideFakePlantShowStateSignal)
end

local function ShowAllEffect(self)
  if not DataCenter.GuideManager:IsShowPrologue() then
    self:RemoveAll()
    local canUnlockFogList = Data.Fog:GetCanUnlockFog()
    for k, v in pairs(canUnlockFogList) do
      local param = {}
      for k1, v1 in pairs(v) do
        param[k1] = v1
      end
      self:ShowOneCanUnLockFog(k, param, true)
    end
  end
end

local function RemoveAll(self)
  for k, v in pairs(self.allFogEffect) do
    if v.request ~= nil then
      v.request:Destroy()
    end
  end
  self.allFogEffect = {}
end

local function ShowOneCanUnLockFog(self, fogId, perSmallState, isShow)
  self.allFogEffect[fogId] = {}
  local req = ResourceManager:InstantiateAsync(UIAssets.FogCanUnlock)
  self.allFogEffect[fogId].request = req
  req:completed("+", function()
    if req.isError then
      return
    end
    req.gameObject:SetActive(true)
    req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = FogCanUnlockEffect.New()
    effect:OnCreate(req)
    self.allFogEffect[fogId].fogCanUnlock = effect
    local param = {}
    param.fogId = fogId
    param.perSmallState = perSmallState
    effect:ReInit(param)
    local leftDownAnim = self.allFogEffect[fogId][CanUnlockFogSmallDirection.LeftDown]
    if leftDownAnim ~= nil then
      effect:PlayAnim(CanUnlockFogSmallDirection.LeftDown, leftDownAnim)
    end
    local rightDownAnim = self.allFogEffect[fogId][CanUnlockFogSmallDirection.RightDown]
    if rightDownAnim ~= nil then
      effect:PlayAnim(CanUnlockFogSmallDirection.RightDown, rightDownAnim)
    end
    local rightTopAnim = self.allFogEffect[fogId][CanUnlockFogSmallDirection.RightTop]
    if rightTopAnim ~= nil then
      effect:PlayAnim(CanUnlockFogSmallDirection.RightTop, rightTopAnim)
    end
    local leftTopAnim = self.allFogEffect[fogId][CanUnlockFogSmallDirection.LeftTop]
    if leftTopAnim ~= nil then
      effect:PlayAnim(CanUnlockFogSmallDirection.LeftTop, leftTopAnim)
    end
  end)
end

local function RemoveOneCanUnLockFog(self, fogId)
  if self.allFogEffect[fogId] ~= nil and self.allFogEffect[fogId].request ~= nil then
    self.allFogEffect[fogId].fogCanUnlock:Delete()
    self.allFogEffect[fogId].fogCanUnlock = nil
    self.allFogEffect[fogId].request:Destroy()
    self.allFogEffect[fogId].request = nil
    self.allFogEffect[fogId] = nil
  end
end

local function UnlockFogAnimSignal(data)
  if not DataCenter.GuideManager:IsShowPrologue() and data ~= nil then
    local fogStr = tostring(data)
    local fogIds = string.split(fogStr, ";")
    DataCenter.CanUnlockFogManager:InitData(fogIds)
    DataCenter.CanUnlockFogManager:StartOpenFog(fogIds)
  end
end

local function InitData(self, fogIds)
  table.walk(fogIds, function(_, k)
    local fogId = toInt(k)
    if self.allFogEffect[fogId] ~= nil then
      DataCenter.CanUnlockFogManager:UnlockFog(fogId, CanUnlockFogSmallDirection.LeftDown)
    end
  end)
end

local function StartOpenFog(self, fogIds)
  table.walk(fogIds, function(_, k)
    local fogId = toInt(k)
    CS.SceneManager.World:UnlockFogOfWar(fogId)
    local param = {}
    param.fogId = fogId
    SFSNetwork.SendMessage(MsgDefines.CityUnlockFog, param)
  end)
  if table.count(self.unlockParam) > 0 then
    self.unlockParam.timer = TimerManager:GetInstance():GetTimer(UpdateTime / 1000, self.UnlockTimeCallBack, nil, false, false, false)
    self.unlockParam.timer:Start()
    self:DoUnlock()
  end
end

local function CheckAndStartOpenFog(self)
  if self.fogIds == nil or #self.fogIds == 0 then
    return
  end
  DataCenter.CanUnlockFogManager:UnlockFog(toInt(self.fogIds[1]), CanUnlockFogSmallDirection.LeftDown)
end

local function UnlockFog(self, fogId, smallDire)
  if self.allFogEffect[fogId] ~= nil then
    if self.unlockParam == nil then
      self.unlockParam = {}
    end
    if self.unlockParam.fogs == nil then
      self.unlockParam.fogs = {}
    end
    local tmp = {}
    tmp.fogId = {}
    local fog = fogId
    tmp.fogId[UnlockFogDirection.Own] = fog
    fog = Data.Fog:GetFogIdByOffset(fogId, -1, 0)
    tmp.fogId[UnlockFogDirection.Left] = fog
    self:CheckCanLoadOne(fog)
    fog = Data.Fog:GetFogIdByOffset(fogId, 1, 0)
    tmp.fogId[UnlockFogDirection.Right] = fog
    self:CheckCanLoadOne(fog)
    fog = Data.Fog:GetFogIdByOffset(fogId, 0, 1)
    tmp.fogId[UnlockFogDirection.Top] = fog
    self:CheckCanLoadOne(fog)
    fog = Data.Fog:GetFogIdByOffset(fogId, 0, -1)
    tmp.fogId[UnlockFogDirection.Down] = fog
    self:CheckCanLoadOne(fog)
    tmp.unlockDirection = UnlockSort[smallDire]
    tmp.index = 1
    tmp.startTime = FogUnlockGapTime * table.count(self.unlockParam.fogs) + UITimeManager:GetInstance():GetServerTime()
    table.insert(self.unlockParam.fogs, tmp)
  end
end

local function CheckCanLoadOne(self, fogId)
  if not Data.Fog:IsUnlockByFogId(fogId) and self.allFogEffect[fogId] == nil then
    local param = {}
    param[CanUnlockFogSmallDirection.LeftDown] = CanUnlockFogSmallState.DeepColor
    param[CanUnlockFogSmallDirection.RightDown] = CanUnlockFogSmallState.DeepColor
    param[CanUnlockFogSmallDirection.RightTop] = CanUnlockFogSmallState.DeepColor
    param[CanUnlockFogSmallDirection.LeftTop] = CanUnlockFogSmallState.DeepColor
    self:ShowOneCanUnLockFog(fogId, param, false)
  end
end

local function DoUnlock(self)
  if self.unlockParam ~= nil and self.unlockParam.fogs ~= nil then
    local isAllComplete = true
    local now = UITimeManager:GetInstance():GetServerTime()
    table.walk(self.unlockParam.fogs, function(_, v)
      if v.alreadySend == true then
        return
      end
      local count = table.count(v.unlockDirection)
      if count < v.index and now >= v.startTime + count * PerUnlockTime then
        if now > WaitAnimationTime + v.startTime + count * PerUnlockTime then
          local fogId = v.fogId[UnlockFogDirection.Own]
          v.alreadySend = true
          self:RemoveOneCanUnLockFog(fogId)
        else
          isAllComplete = false
        end
      else
        if now >= v.startTime + (v.index - 1) * PerUnlockTime then
          local dir = v.unlockDirection[v.index]
          local list = UnlockChangeOther[dir]
          if list ~= nil then
            for _, k in ipairs(list) do
              self:DoSmallAnim(v.fogId[k.unlockFogDirection], k.smallDirection, k.animName)
            end
            v.index = v.index + 1
            local id = Data.Fog:GetSpecialFogIdByFodIdAndDirection(v.fogId[UnlockFogDirection.Own], dir)
            CS.SceneManager.World:UnlockFogOfWar2x2(id)
          else
            local a = 1
          end
        end
        isAllComplete = false
      end
    end)
    if isAllComplete == true then
      self.unlockParam.fogs = nil
      self.unlockParam.timer:Stop()
      self.unlockParam.timer = nil
    end
  end
end

local function DoSmallAnim(self, fogId, smallDire, animName)
  if self.allFogEffect[fogId] ~= nil then
    if self.allFogEffect[fogId].fogCanUnlock ~= nil then
      self.allFogEffect[fogId].fogCanUnlock.gameObject:SetActive(true)
      self.allFogEffect[fogId].fogCanUnlock:CheckDoAnim(smallDire, animName)
    else
      self.allFogEffect[fogId][smallDire] = animName
    end
  end
end

local function UnlockTimeCallBack()
  DataCenter.CanUnlockFogManager:DoUnlock()
end

local function FarmGuideFakePlantShowStateSignal(isShow)
  DataCenter.CanUnlockFogManager:SetFogActive(isShow)
end

local function SetFogActive(self, isShow)
  for k, v in pairs(self.allFogEffect) do
    v.fogCanUnlock.gameObject:SetActive(isShow)
  end
end

CanUnlockFogManager.__init = __init
CanUnlockFogManager.__delete = __delete
CanUnlockFogManager.Startup = Startup
CanUnlockFogManager.AddListener = AddListener
CanUnlockFogManager.RemoveListener = RemoveListener
CanUnlockFogManager.ShowAllEffect = ShowAllEffect
CanUnlockFogManager.ShowOneCanUnLockFog = ShowOneCanUnLockFog
CanUnlockFogManager.RemoveOneCanUnLockFog = RemoveOneCanUnLockFog
CanUnlockFogManager.UnlockFogAnimSignal = UnlockFogAnimSignal
CanUnlockFogManager.UnlockFog = UnlockFog
CanUnlockFogManager.CheckCanLoadOne = CheckCanLoadOne
CanUnlockFogManager.DoUnlock = DoUnlock
CanUnlockFogManager.DoSmallAnim = DoSmallAnim
CanUnlockFogManager.UnlockTimeCallBack = UnlockTimeCallBack
CanUnlockFogManager.RemoveAll = RemoveAll
CanUnlockFogManager.FarmGuideFakePlantShowStateSignal = FarmGuideFakePlantShowStateSignal
CanUnlockFogManager.SetFogActive = SetFogActive
CanUnlockFogManager.CheckAndStartOpenFog = CheckAndStartOpenFog
CanUnlockFogManager.StartOpenFog = StartOpenFog
CanUnlockFogManager.InitData = InitData
return CanUnlockFogManager
