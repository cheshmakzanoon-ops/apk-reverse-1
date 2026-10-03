local base = UIBaseContainer
local LWMaxAdWatchAd = BaseClass("LWMaxAdWatchAd", base)
local button_path = "Button"
local bg_path = "Bg"
local red_dot_path = "RedDotWithoutNum"
local red_dot_num_path = "RedDotWithoutNum/RedDotNum"
local prefabPath = "Assets/Main/Prefabs/UI/LWUIMaxAd/LWMaxAdWatchAd.prefab"
local BG_DIRECTION = {
  [AdCollectionId.HeroRecruit] = 1,
  [AdCollectionId.WorkerRecruit] = 1,
  [AdCollectionId.Resource] = 1,
  [AdCollectionId.Train] = -1
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddUIListener(EventId.MaxAd_RefreshAdInfo, self.OnAdInfoChange)
end

local function OnDestroy(self)
  self:RemoveUIListener(EventId.MaxAd_RefreshAdInfo, self.OnAdInfoChange)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.button = nil
  self.bg = nil
  self.watchAdItem = nil
end

local function ComponentDestroy(self)
  self.button = nil
  self.bg = nil
  if self.watchAdItem then
    self:GameObjectDestroy(self.watchAdItem)
    self.watchAdItem = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWMaxAdWatchAd:RefreshView(adId)
  self.adId = adId
  if not DataCenter.MaxAdManager:IsAdsUnlock() then
    if self.go then
      self.go:SetActive(false)
    end
    return
  end
  if not DataCenter.MaxAdManager:IsAdShow(adId) then
    if self.go then
      self.go:SetActive(false)
    end
    return
  end
  if self.go then
    self.go:SetActive(true)
  end
  if self.hasInit then
    self:ReInit()
    return
  end
  if self.watchAdItem then
    return
  end
  self.watchAdItem = self:GameObjectInstantiateAsync(prefabPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.transform)
    trans:Set_localScale(1, 1, 1)
    trans:Set_anchoredPosition(0, 0)
    go.name = "WatchAdComp"
    self.go = go
    self.bg = self:AddComponent(UIImage, go.name .. "/" .. bg_path)
    self.redDot = self:AddComponent(UIBaseContainer, go.name .. "/" .. red_dot_path)
    self.redDotNum = self:AddComponent(UIText, go.name .. "/" .. red_dot_num_path)
    self.button = self:AddComponent(UIButton, go.name .. "/" .. button_path)
    self.button:SetSafeClickMode(true)
    self.button:SetOnClick(function()
      self:OnPlayBtnClick()
    end)
    self:ReInit()
    self.hasInit = true
  end)
end

function LWMaxAdWatchAd:ReInit()
  local dir = BG_DIRECTION[self.adId] or 1
  if self.bg then
    self.bg:SetLocalScaleXYZ(dir, 1, 1)
  end
  local data = DataCenter.MaxAdManager:GetAdCollectionById(self.adId)
  local count = 0
  if data.template ~= nil then
    count = data.template.times - data.serverData.rewardTimes
  end
  if self.redDot and self.redDotNum then
    self.redDot:SetActive(0 < count)
    self.redDotNum:SetText(count)
  end
end

function LWMaxAdWatchAd:OnAdInfoChange()
  self:RefreshView(self.adId)
end

function LWMaxAdWatchAd:OnPlayBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMaxAdDetail, {anim = true}, self.adId)
end

LWMaxAdWatchAd.OnCreate = OnCreate
LWMaxAdWatchAd.OnDestroy = OnDestroy
LWMaxAdWatchAd.OnEnable = OnEnable
LWMaxAdWatchAd.OnDisable = OnDisable
LWMaxAdWatchAd.ComponentDefine = ComponentDefine
LWMaxAdWatchAd.ComponentDestroy = ComponentDestroy
LWMaxAdWatchAd.DataDefine = DataDefine
LWMaxAdWatchAd.DataDestroy = DataDestroy
return LWMaxAdWatchAd
