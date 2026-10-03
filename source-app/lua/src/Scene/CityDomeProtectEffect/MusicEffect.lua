local MusicEffect = BaseClass("MusicEffect")
local ResourceManager = CS.GameEntry.Resource
local willHideTime = 1000
local State = {
  show = 1,
  willHide = 2,
  hide = 3
}

local function OnCreate(self)
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self.simpleAnim = nil
  self.timer = nil
  self.showGameObject = nil
  self.hideGameObject = nil
  self.lod = 1
  self.posIndex = 0
  self.endTime = 0
  self.curState = State.hide
  self.nextStateTime = 0
end

local function OnDestroy(self)
  if self.request ~= nil then
    self.request:Destroy()
  end
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self.simpleAnim = nil
  self:DeleteTimer()
  self.showGameObject = nil
  self.hideGameObject = nil
  self.lod = nil
  self.posIndex = nil
  self.endTime = nil
  self.curState = nil
  self.nextStateTime = nil
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

local function ReInit(self, lod, posIndex, endTime, statusId)
  self:DeleteTimer()
  self.lod = lod
  self.posIndex = posIndex
  self.endTime = endTime
  self.curState = State.hide
  self.nextStateTime = 0
  self.statusId = statusId
  self:TryRefreshShow()
end

local function TryRefreshShow(self)
  local prefabName = "Assets/_Art_LastWar/Effect/Prefab/Zhucheng/Eff_zhucheng_yinyuejie_buff01.prefab"
  local showPath = "Eff_zhucheng_yinyuejie_yinfu"
  local hidePath = "Eff_zhucheng_yinyuejie_yinfuxiaoshi"
  local statusTemp = DataCenter.StatusManager:GetTemplate(tostring(self.statusId))
  if statusTemp then
    local dataStr = statusTemp.buff_effect
    local buffData = string.split(dataStr, "|")
    if buffData and #buffData <= 3 then
      prefabName = buffData[1] or prefabName
      showPath = buffData[2] or showPath
      hidePath = buffData[3] or hidePath
    end
  end
  if self.request == nil then
    local request = ResourceManager:InstantiateAsync(prefabName)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      self.gameObject = request.gameObject
      self.transform = request.gameObject.transform
      local targetTransform = showPath and self.transform:Find(showPath)
      if targetTransform then
        self.showGameObject = targetTransform.gameObject
      end
      targetTransform = hidePath and self.transform:Find(hidePath)
      if targetTransform then
        self.hideGameObject = targetTransform.gameObject
      end
      self:TryRefreshShowAfterLoad()
    end)
  elseif self.gameObject then
    self:TryRefreshShowAfterLoad()
  end
end

local function TryRefreshShowAfterLoad(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.endTime - willHideTime then
    self.curState = State.show
    self.nextStateTime = self.endTime - willHideTime - curTime + 100
  elseif curTime < self.endTime then
    self.curState = State.willHide
    self.nextStateTime = self.endTime - curTime + 100
  else
    self.curState = State.hide
    self.nextStateTime = 0
  end
  self.gameObject:SetActive(self.lod < 3 and (self.curState == State.show or self.curState == State.willHide))
  if self.showGameObject then
    self.showGameObject:SetActive(self.curState == State.show)
  end
  if self.hideGameObject then
    self.hideGameObject:SetActive(self.curState == State.willHide)
  end
  if self.transform then
    local pos = SceneUtils.TileIndexToWorld(self.posIndex)
    pos.y = pos.y + 5
    pos.x = pos.x + 2
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

MusicEffect.OnCreate = OnCreate
MusicEffect.OnDestroy = OnDestroy
MusicEffect.ReInit = ReInit
MusicEffect.AddTimer = AddTimer
MusicEffect.DeleteTimer = DeleteTimer
MusicEffect.TryRefreshShow = TryRefreshShow
MusicEffect.TryRefreshShowAfterLoad = TryRefreshShowAfterLoad
MusicEffect.SetLod = SetLod
return MusicEffect
