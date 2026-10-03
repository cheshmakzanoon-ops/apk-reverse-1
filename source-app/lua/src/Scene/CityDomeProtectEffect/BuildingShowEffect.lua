local BuildingShowEffect = BaseClass("BuildingShowEffect")
local ResourceManager = CS.GameEntry.Resource
local State = {show = 1, hide = 3}

local function OnCreate(self)
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self.timer = nil
  self.lod = 1
  self.posIndex = 0
  self.endTime = 0
  self.curState = State.hide
  self.nextStateTime = 0
  self.extraParam = nil
end

local function OnDestroy(self)
  if self.request ~= nil then
    self.request:Destroy()
  end
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self:DeleteTimer()
  self.lod = nil
  self.posIndex = nil
  self.endTime = nil
  self.curState = nil
  self.nextStateTime = nil
  self.extraParam = nil
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self, time)
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:DeleteTimer()
    self:TryRefreshShow()
  end, time / 1000)
end

local function ReInit(self, lod, posIndex, infoUuid, param, extraParam)
  self:DeleteTimer()
  local endTime = 0
  local statusId = 0
  for k, v in pairs(param) do
    statusId = k
    endTime = v
    break
  end
  self.lod = lod
  self.posIndex = posIndex
  self.infoUuid = infoUuid
  self.param = param
  self.extraParam = extraParam
  self.endTime = endTime
  self.curState = State.hide
  self.nextStateTime = 0
  self.statusId = statusId
  self:TryRefreshShow()
end

local function TryRefreshShow(self)
  local prefabName = "Assets/_Art_LastWar/Effect/Prefab/Zhucheng/Eff_zhucheng_yinyuejie_buff01.prefab"
  local statusTemp = DataCenter.StatusManager:GetTemplate(tostring(self.statusId))
  if statusTemp then
    local dataStr = statusTemp.buff_effect
    prefabName = dataStr or prefabName
  end
  if self.request == nil or self.request.PrefabPath ~= prefabName then
    if self.request ~= nil then
      self.request:Destroy()
      self.request = nil
      self.gameObject = nil
      self.transform = nil
    end
    local request = ResourceManager:InstantiateAsync(prefabName)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      self.gameObject = request.gameObject
      self.transform = request.gameObject.transform
      self:TryRefreshShowAfterLoad()
    end)
  elseif self.gameObject then
    self:TryRefreshShowAfterLoad()
  end
end

local function TryRefreshShowAfterLoad(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.endTime then
    self.curState = State.show
    self.nextStateTime = self.endTime - curTime + 100
  else
    self.curState = State.hide
    self.nextStateTime = 0
  end
  self.gameObject:SetActive(self.lod < 3 and self.curState == State.show)
  if self.transform then
    local serverId
    if self.extraParam and self.extraParam.serverId then
      serverId = self.extraParam.serverId
    end
    local pos = SceneUtils.TileIndexToWorld(self.posIndex, ForceChangeScene.World, serverId)
    pos.y = pos.y
    pos.x = pos.x
    self.transform.position = pos
  end
  if self.nextStateTime > 0 then
    self:AddTimer(self.nextStateTime)
  end
end

local function SetLod(self, lod)
  self.lod = lod
  self:TryRefreshShow()
end

BuildingShowEffect.OnCreate = OnCreate
BuildingShowEffect.OnDestroy = OnDestroy
BuildingShowEffect.ReInit = ReInit
BuildingShowEffect.AddTimer = AddTimer
BuildingShowEffect.DeleteTimer = DeleteTimer
BuildingShowEffect.TryRefreshShow = TryRefreshShow
BuildingShowEffect.TryRefreshShowAfterLoad = TryRefreshShowAfterLoad
BuildingShowEffect.SetLod = SetLod
return BuildingShowEffect
