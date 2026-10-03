local BuildZeroUpgradeEffectManager = BaseClass("BuildZeroUpgradeEffectManager")
local ResourceManager = CS.GameEntry.Resource
local BuildCancelEffect = require("Scene.BuildZeroUpgradeEffect.BuildCancelEffect")
local BuildMainZeroUpgradeOneScene = require("Scene.BuildZeroUpgradeEffect.BuildMainZeroUpgradeOneScene")
local CancelEffectTime = 1
local BuildCancelEffectTime = 0.5

local function __init(self)
  self.cancelEffect = nil
  self.cancelRequest = nil
  self.cancelTimer = nil
  self.showEffect = nil
  self.showRequest = nil
  self.useGuideTimelineMarker = false
  self:AddListener()
end

local function __delete(self)
  self.useGuideTimelineMarker = nil
  self:RemoveListener()
  self:RemoveCancelEffect()
  self:RemoveShowEffect()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.GuideTimelineMarkerSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.GuideTimelineMarkerSignal)
end

local function RemoveCancelEffect(self)
  if self.cancelTimer ~= nil then
    self.cancelTimer:Stop()
    self.cancelTimer = nil
  end
  if self.cancelEffect ~= nil then
    self.cancelEffect:OnDestroy()
    self.cancelEffect = nil
  end
  if self.cancelRequest ~= nil then
    self.cancelRequest:Destroy()
    self.cancelRequest = nil
  end
end

local function RemoveShowEffect(self)
  if self.showEffect ~= nil then
    self.showEffect:OnDestroy()
    self.showEffect = nil
  end
  if self.showRequest ~= nil then
    self.showRequest:Destroy()
    self.showRequest = nil
  end
end

local function ShowCancelEffect(self)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if buildData ~= nil then
    self.cancelRequest = ResourceManager:InstantiateAsync(UIAssets.BuildCancelEffect)
    self.cancelRequest:completed("+", function()
      if self.cancelRequest.isError then
        return
      end
      self.cancelRequest.gameObject:SetActive(true)
      self.cancelRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = BuildCancelEffect.New()
      effect:OnCreate(self.cancelRequest)
      self.cancelEffect = effect
      local param = {}
      param.posIndex = buildData:GetCenterIndex()
      self.cancelEffect:ReInit(param)
      self.buildCancelTimer = TimerManager:GetInstance():GetTimer(BuildCancelEffectTime, self.BuildCancelTimeCallBack, nil, true, false, false)
      self.buildCancelTimer:Start()
      self.cancelTimer = TimerManager:GetInstance():GetTimer(CancelEffectTime, self.CancelTimeCallBack, nil, true, false, false)
      self.cancelTimer:Start()
    end)
  end
end

local function ShowShowEffect(self, pos)
  if DataCenter.BuildManager.MainLv == 0 then
    CS.BuildMainCityMessage.Instance:Send()
  end
  self.showRequest = ResourceManager:InstantiateAsync(UIAssets.BuildMainZeroUpgradeOneScene)
  self.showRequest:completed("+", function()
    if self.showRequest.isError then
      return
    end
    self.showRequest.gameObject:SetActive(true)
    self.showRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = BuildMainZeroUpgradeOneScene.New()
    effect:OnCreate(self.showRequest)
    self.showEffect = effect
    local param = {}
    param.pos = pos
    self.showEffect:ReInit(param)
    self.useGuideTimelineMarker = true
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRocketLanding, {anim = true, playEffect = false})
  end)
  DataCenter.GuideManager:DoNext()
end

local function CancelTimeCallBack()
  DataCenter.BuildZeroUpgradeEffectManager:RemoveCancelEffect()
  DataCenter.BuildZeroUpgradeEffectManager:ShowShowEffect()
  if DataCenter.BuildManager.MainLv == 0 then
    CS.BuildMainCityMessage.Instance:Send()
  end
end

local function BuildCancelTimeCallBack()
  DataCenter.BuildZeroUpgradeEffectManager:RemoveBuildCancelTimer()
  if DataCenter.BuildManager.MainLv == 0 then
    CS.SceneManager.World:ClearReInitObject()
  end
  DataCenter.GuideManager:SetCanShowBuild(false)
end

local function RemoveBuildCancelTimer(self)
  if self.buildCancelTimer ~= nil then
    self.buildCancelTimer:Stop()
    self.buildCancelTimer = nil
  end
end

local function CheckDoNext(self)
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and (template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete) then
    DataCenter.GuideManager:DoNext()
  end
end

local function GuideTimelineMarkerSignal(signalType)
  if DataCenter.BuildZeroUpgradeEffectManager.useGuideTimelineMarker then
    if signalType == GuideTimeLineShowMarkerType.End then
      DataCenter.BuildZeroUpgradeEffectManager.useGuideTimelineMarker = false
      DataCenter.BuildZeroUpgradeEffectManager:RemoveCancelEffect()
      DataCenter.BuildZeroUpgradeEffectManager:RemoveShowEffect()
      DataCenter.GuideManager:SetCanShowBuild(true)
      EventManager:GetInstance():Broadcast(EventId.ShowAllGuideObject)
      DataCenter.GuideManager:SetNoShowUIMain(false)
      DataCenter.BuildZeroUpgradeEffectManager:CheckDoNext()
    elseif signalType == GuideTimeLineShowMarkerType.Zero then
      DataCenter.BuildZeroUpgradeEffectManager:ShowDomeEffect()
    end
  end
end

local function ShowDomeEffect(self)
  if self.showEffect ~= nil then
    self.showEffect:PlayDomedAnim()
  end
end

local function GetGuideObj(self)
  if self.showEffect ~= nil then
    return self.showEffect:GetGuideObj()
  end
end

BuildZeroUpgradeEffectManager.__init = __init
BuildZeroUpgradeEffectManager.__delete = __delete
BuildZeroUpgradeEffectManager.AddListener = AddListener
BuildZeroUpgradeEffectManager.RemoveListener = RemoveListener
BuildZeroUpgradeEffectManager.RemoveCancelEffect = RemoveCancelEffect
BuildZeroUpgradeEffectManager.RemoveShowEffect = RemoveShowEffect
BuildZeroUpgradeEffectManager.ShowCancelEffect = ShowCancelEffect
BuildZeroUpgradeEffectManager.ShowShowEffect = ShowShowEffect
BuildZeroUpgradeEffectManager.CancelTimeCallBack = CancelTimeCallBack
BuildZeroUpgradeEffectManager.BuildCancelTimeCallBack = BuildCancelTimeCallBack
BuildZeroUpgradeEffectManager.RemoveBuildCancelTimer = RemoveBuildCancelTimer
BuildZeroUpgradeEffectManager.CheckDoNext = CheckDoNext
BuildZeroUpgradeEffectManager.GuideTimelineMarkerSignal = GuideTimelineMarkerSignal
BuildZeroUpgradeEffectManager.ShowDomeEffect = ShowDomeEffect
BuildZeroUpgradeEffectManager.GetGuideObj = GetGuideObj
return BuildZeroUpgradeEffectManager
