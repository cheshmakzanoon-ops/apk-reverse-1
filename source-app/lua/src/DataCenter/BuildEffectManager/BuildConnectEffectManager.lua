local BuildConnectEffectManager = BaseClass("BuildConnectEffectManager")
local ResourceManager = CS.GameEntry.Resource
local BuildConnectEffect = require("UI.BuildConnectEffect.View.BuildConnectEffect")
local BuildConnectRoadBallEffect = require("Scene.BuildConnectEffect.BuildConnectRoadBallEffect")
local BuildConnectRoadEffect = require("Scene.BuildConnectEffect.BuildConnectRoadEffect")
local PerPointTime = 0.1
local ShowLinkDelay = 1.2
local ShowBallDelay = 0.1
local ShowPlugDelay = 0.1
local PlugDisplayTime = 1.5
local BallDuring = 5
local MaxBallCount = 3

local function __init(self)
  self.loadedConfig = false
  self.allEffect = {}
  self:AddListener()
end

local function __delete(self)
  for k, v in pairs(self.allEffect) do
    for k1, v1 in pairs(v) do
      local request = v1.request
      if v1.OnDestroy ~= nil then
        v1:OnDestroy()
      end
      if request ~= nil then
        request:Destroy()
      end
    end
  end
  self.loadedConfig = nil
  self.allEffect = nil
  self:RemoveListener()
end

local function LoadConfig(self)
  PerPointTime = LuaEntry.DataConfig:TryGetNum("connect_effect", "k1")
  ShowLinkDelay = LuaEntry.DataConfig:TryGetNum("connect_effect", "k2")
  ShowBallDelay = LuaEntry.DataConfig:TryGetNum("connect_effect", "k3")
  ShowPlugDelay = LuaEntry.DataConfig:TryGetNum("connect_effect", "k4")
  PlugDisplayTime = LuaEntry.DataConfig:TryGetNum("connect_effect", "k5")
  BallDuring = LuaEntry.DataConfig:TryGetNum("connect_effect", "k6")
  MaxBallCount = LuaEntry.DataConfig:TryGetNum("connect_effect", "k7")
end

local function Startup()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.BuildConnect, self.OnBuildConnectSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BuildConnect, self.OnBuildConnectSignal)
end

local function ShowOneEffect(self, posIndex, tile)
  if not self.loadedConfig then
    self:LoadConfig()
    self.loadedConfig = true
  end
  if self.allEffect[posIndex] == nil then
    self.allEffect[posIndex] = {}
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(posIndex, false)
  if not buildData then
    return
  end
  local list = CS.SceneManager.World:GetNearestPathForBuildingConnect(buildData.uuid)
  if not list or list.Count == 0 then
    return
  end
  local ballCount = math.min((list.Count - 1) // BallDuring, MaxBallCount)
  local ballTime = (ballCount * BallDuring + 1) * PerPointTime
  local linkParam = {}
  linkParam.posIndex = posIndex
  linkParam.tile = tile
  linkParam.list = list
  linkParam.ballTime = ballTime
  table.insert(self.allEffect[posIndex], {param = linkParam})
  linkParam.timer = TimerManager:GetInstance():GetTimer(ShowLinkDelay, self.BeforeShowLink, linkParam, true, false, false)
  linkParam.timer:Start()
end

local function BeforeShowLink(linkParam)
  DataCenter.BuildConnectEffectManager:ShowLink(linkParam)
  DataCenter.BuildConnectEffectManager.TimeCallBack(linkParam)
end

local function ShowLink(self, linkParam)
  local posIndex = linkParam.posIndex
  local tile = linkParam.tile
  local list = linkParam.list
  local ballTime = linkParam.ballTime
  local listCount = list.Count
  local destroyTime = ballTime + ShowBallDelay + ShowPlugDelay + PlugDisplayTime
  for i = 0, listCount - 1 do
    local lastPos
    if i ~= 0 then
      lastPos = list[i - 1]
    end
    local nextPos
    if i ~= listCount - 1 then
      nextPos = list[i + 1]
    end
    local curPos = list[i]
    local curIndex = SceneUtils.TilePosToIndex(curPos)
    local modelName = UIAssets.BuildConnectRoadEffectDire
    local openDir, dir = CommonUtil.GetDirByPos(lastPos, curPos, nextPos)
    if dir == ConnectDirection.TopToDown or dir == ConnectDirection.DownToTop or dir == ConnectDirection.LeftToRight or dir == ConnectDirection.RightToLeft or dir == ConnectDirection.Top or dir == ConnectDirection.Down or dir == ConnectDirection.Left or dir == ConnectDirection.Right then
      modelName = UIAssets.BuildConnectRoadEffect
    end
    local roadRequest = ResourceManager:InstantiateAsync(modelName)
    roadRequest:completed("+", function()
      if roadRequest.isError then
        return
      end
      roadRequest.gameObject:SetActive(true)
      roadRequest.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      roadRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = BuildConnectRoadEffect.New()
      effect:OnCreate(roadRequest)
      if self.allEffect[curIndex] == nil then
        self.allEffect[curIndex] = {}
      end
      table.insert(self.allEffect[curIndex], effect)
      local param = {}
      param.request = roadRequest
      param.dir = dir
      param.posIndex = curIndex
      effect:ReInit(param)
      param.timer = TimerManager:GetInstance():GetTimer(destroyTime, self.TimeCallBack, effect.param, true, false, false)
      param.timer:Start()
    end)
  end
  local ballParam = {}
  ballParam.posIndex = posIndex
  ballParam.tile = tile
  ballParam.list = list
  ballParam.ballTime = ballTime
  table.insert(self.allEffect[posIndex], {param = ballParam})
  ballParam.timer = TimerManager:GetInstance():GetTimer(ShowBallDelay, self.BeforeShowBall, ballParam, true, false, false)
  ballParam.timer:Start()
end

local function BeforeShowBall(ballParam)
  DataCenter.BuildConnectEffectManager:ShowBall(ballParam)
  DataCenter.BuildConnectEffectManager.TimeCallBack(ballParam)
end

local function ShowBall(self, ballParam)
  local posIndex = ballParam.posIndex
  local tile = ballParam.tile
  local list = ballParam.list
  local ballTime = ballParam.ballTime
  local listCount = list.Count
  local ballCount = 0
  local startI = listCount - 1 - BallDuring
  if startI < 0 then
    startI = 0
  end
  for i = startI, 0, -BallDuring do
    ballCount = ballCount + 1
    if i < 0 or ballCount > MaxBallCount then
      break
    end
    local startIndex = i
    local destroyTime = (listCount - i) * PerPointTime
    local roadBallRequest = ResourceManager:InstantiateAsync(UIAssets.BuildConnectRoadBallEffect)
    roadBallRequest:completed("+", function()
      if roadBallRequest.isError then
        return
      end
      roadBallRequest.gameObject:SetActive(true)
      roadBallRequest.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      roadBallRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = BuildConnectRoadBallEffect.New()
      effect:OnCreate(roadBallRequest)
      table.insert(self.allEffect[posIndex], effect)
      local param = {}
      param.posIndex = posIndex
      param.request = roadBallRequest
      param.path = list
      param.perMoveTime = PerPointTime
      param.startIndex = startIndex
      effect:ReInit(param)
      param.timer = TimerManager:GetInstance():GetTimer(destroyTime, self.TimeCallBack, effect.param, true, false, false)
      param.timer:Start()
    end)
  end
  local delay = ballTime + ShowPlugDelay
  local plugParam = {}
  plugParam.posIndex = posIndex
  plugParam.tile = tile
  table.insert(self.allEffect[plugParam.posIndex], {param = plugParam})
  plugParam.timer = TimerManager:GetInstance():GetTimer(delay, self.BeforeShowPlug, plugParam, true, false, false)
  plugParam.timer:Start()
end

local function BeforeShowPlug(plugParam)
  DataCenter.BuildConnectEffectManager:ShowPlug(plugParam)
  DataCenter.BuildConnectEffectManager.TimeCallBack(plugParam)
end

local function ShowPlug(self, plugParam)
  local posIndex = plugParam.posIndex
  local tile = plugParam.tile
  local request = ResourceManager:InstantiateAsync(UIAssets.BuildConnectEffect)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local buildConnectEffect = BuildConnectEffect.New()
    buildConnectEffect:OnCreate(request)
    table.insert(self.allEffect[posIndex], buildConnectEffect)
    local param = {}
    param.tile = tile
    param.posIndex = posIndex
    param.request = request
    param.modelHeight = CS.SceneManager.World:GetBuildingHeight(posIndex)
    buildConnectEffect:ReInit(param)
    param.timer = TimerManager:GetInstance():GetTimer(PlugDisplayTime, self.TimeCallBack, buildConnectEffect.param, true, false, false)
    param.timer:Start()
  end)
end

local function TimeCallBack(param)
  if param.timer ~= nil then
    param.timer:Stop()
    param.timer = nil
  end
  if param.request ~= nil then
    param.request:Destroy()
  end
  local list = DataCenter.BuildConnectEffectManager.allEffect[param.posIndex]
  if list ~= nil then
    for i = #list, 1, -1 do
      if list[i].param == param then
        table.remove(list, i)
      end
    end
  end
end

local function OnBuildConnectSignal(data)
  local bUuid = data
  if DataCenter.BuildManager:IsBuildInView(bUuid) then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
      if buildTemplate ~= nil then
        DataCenter.BuildConnectEffectManager:ShowOneEffect(buildData.pointId, buildTemplate.tileX, buildTemplate.tileY)
      end
    end
  end
end

BuildConnectEffectManager.__init = __init
BuildConnectEffectManager.__delete = __delete
BuildConnectEffectManager.LoadConfig = LoadConfig
BuildConnectEffectManager.Startup = Startup
BuildConnectEffectManager.AddListener = AddListener
BuildConnectEffectManager.RemoveListener = RemoveListener
BuildConnectEffectManager.ShowOneEffect = ShowOneEffect
BuildConnectEffectManager.OnBuildConnectSignal = OnBuildConnectSignal
BuildConnectEffectManager.TimeCallBack = TimeCallBack
BuildConnectEffectManager.BeforeShowLink = BeforeShowLink
BuildConnectEffectManager.ShowLink = ShowLink
BuildConnectEffectManager.BeforeShowBall = BeforeShowBall
BuildConnectEffectManager.ShowBall = ShowBall
BuildConnectEffectManager.BeforeShowPlug = BeforeShowPlug
BuildConnectEffectManager.ShowPlug = ShowPlug
return BuildConnectEffectManager
