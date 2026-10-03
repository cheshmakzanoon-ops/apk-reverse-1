local BuildMainZeroUpgradeOneScene = BaseClass("BuildMainZeroUpgradeOneScene")
local main_build_path = "building_400001"
local dome_path = "building_dome_6"
local all_timeline_path = ""
local rocket_go_path = "RocketGo"
local bubble_anim_path = "BuildStateIcon/Go"
local bubble_trigger_path = "BuildStateIcon/Go/Trigger"
local build_wai_path = "Build_wai"
local build_nei_path = "Build_nei"
local effect_go_path = "EffectGo"
local BubbleAnimName = {
  Show = "EnterBubble",
  Idle = "NormalBubble"
}
local BuildTime = 3
local MainBuildTile = 3
local BuildDomeTime = 3
local DomeTile = 3
local BuildBeforeDomeTime = 0
local BuildDomeDeltaTime = 1.3
local HideEffectTime = 1.0
local HideRocketTime = 0.5

local function OnCreate(self, go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
  self.main_build = self.transform:Find(main_build_path):GetComponent(typeof(CS.BuildingGrowEffect))
  self.dome = self.transform:Find(dome_path):GetComponent(typeof(CS.BuildingGrowEffect))
  self.rocket_go = self.transform:Find(rocket_go_path)
  self.bubble_anim = self.transform:Find(bubble_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.bubble_trigger = self.transform:Find(bubble_trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bubble_trigger.onPointerClick()
    self:OnClick()
  end
  
  self.build_wai = self.transform:Find(build_wai_path)
  self.build_nei = self.transform:Find(build_nei_path)
  self.effect_go = self.transform:Find(effect_go_path)
  self.dome.gameObject:SetActive(false)
end

local function ComponentDestroy(self)
  if self.bubble_trigger then
    self.bubble_trigger.onPointerClick = nil
    self.bubble_trigger = nil
  end
  self.director = nil
  self.main_build = nil
  self.rocket_go = nil
  self.bubble_anim = nil
  self.build_wai = nil
  self.build_nei = nil
  self.dome = nil
  self.effect_go = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.showTimer = nil
  
  function self.show_timer_action(temp)
    self:ShowTimeCallBack()
  end
  
  self.hideEffectTimer = nil
  
  function self.hide_effect_timer_action(temp)
    self:HideEffectTimerCallBack()
  end
  
  self.hideRocketTimer = nil
  
  function self.hide_rocket_timer_action(temp)
    self:HideRocketTimerCallBack()
  end
  
  self.domeTimer = nil
  
  function self.dome_timer_action(temp)
    self:DomeTimerCallBack()
  end
end

local function DataDestroy(self)
  self:DeleteDomeTimer()
  self:DeleteHideEffectTimer()
  self:DeleteHideRocketTimer()
  self:DeleteShowTimer()
  self.show_timer_action = nil
  self.hide_effect_timer_action = nil
  self.hide_rocket_timer_action = nil
  self.dome_timer_action = nil
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  local originalPos = self:GetOriginalPos()
  self.transform.position = originalPos
  self.director.time = 0
  self.director:Stop()
  self.rocket_go.gameObject:SetActive(false)
  self.main_build.gameObject:SetActive(false)
  self.build_nei.gameObject:SetActive(false)
  self.build_wai.gameObject:SetActive(false)
  self.effect_go.gameObject:SetActive(false)
  self.bubble_anim.gameObject:SetActive(false)
  self:PlayDomedAnim()
  self:AddDomeTimer()
end

local function GetOriginalPos(self)
  return self.param.pos
end

local function PlayBuildAnim(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.main_build:StartBuild(0, BuildingTypes.FUN_BUILD_MAIN, curTime, curTime + BuildTime, MainBuildTile, LuaEntry.Player:GetUid(), false, false)
end

local function PlayDomedAnim(self)
  if self.dome ~= nil then
    self.dome.gameObject:SetActive(true)
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Dome_Scan, false)
    end, BuildBeforeDomeTime)
    self.dome:StartBuild(0, 0, curTime + BuildBeforeDomeTime, curTime + BuildDomeTime, DomeTile, LuaEntry.Player:GetUid(), true, false, true)
  end
end

local function DeleteShowTimer(self)
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
end

local function ShowTimeCallBack(self)
  self:DeleteShowTimer()
  self.bubble_anim:Play(BubbleAnimName.Idle)
end

local function OnClick(self)
  self.effect_go.gameObject:SetActive(true)
  self.bubble_anim.gameObject:SetActive(false)
  self:AddHideEffectTimer()
  self:AddHideRocketTimer()
  local needParam = {}
  needParam.click = true
  DataCenter.GuideManager:SetCompleteNeedParam(needParam)
  DataCenter.GuideManager:CheckGuideComplete()
end

local function GetGuideObj(self)
  return self.bubble_trigger.gameObject
end

local function AddHideEffectTimer(self)
  if self.hideEffectTimer == nil then
    self.hideEffectTimer = TimerManager:GetInstance():GetTimer(HideEffectTime, self.hide_effect_timer_action, self, true, false, false)
  end
  self.hideEffectTimer:Start()
end

local function DeleteHideEffectTimer(self)
  if self.hideEffectTimer ~= nil then
    self.hideEffectTimer:Stop()
    self.hideEffectTimer = nil
  end
end

local function HideEffectTimerCallBack(self)
  self:DeleteHideEffectTimer()
  self.effect_go.gameObject:SetActive(false)
  self.main_build.gameObject:SetActive(true)
  self.build_nei.gameObject:SetActive(true)
  self.build_wai.gameObject:SetActive(true)
  self.director.time = 0
  self.director:Play()
  self:PlayBuildAnim()
end

local function DeleteHideRocketTimer(self)
  if self.hideRocketTimer ~= nil then
    self.hideRocketTimer:Stop()
    self.hideRocketTimer = nil
  end
end

local function HideRocketTimerCallBack(self)
  self:DeleteHideRocketTimer()
  self.rocket_go.gameObject:SetActive(false)
end

local function AddHideRocketTimer(self)
  if self.hideRocketTimer == nil then
    self.hideRocketTimer = TimerManager:GetInstance():GetTimer(HideRocketTime, self.hide_rocket_timer_action, self, true, false, false)
  end
  self.hideRocketTimer:Start()
end

local function AddDomeTimer(self)
  if self.domeTimer == nil then
    self.domeTimer = TimerManager:GetInstance():GetTimer(BuildDomeTime + BuildDomeDeltaTime, self.dome_timer_action, self, true, false, false)
  end
  self.domeTimer:Start()
end

local function DeleteDomeTimer(self)
  if self.domeTimer ~= nil then
    self.domeTimer:Stop()
    self.domeTimer = nil
  end
end

local function DomeTimerCallBack(self)
  self:DeleteDomeTimer()
  DataCenter.BuildZeroUpgradeEffectManager.GuideTimelineMarkerSignal(GuideTimeLineShowMarkerType.End)
end

BuildMainZeroUpgradeOneScene.OnCreate = OnCreate
BuildMainZeroUpgradeOneScene.OnDestroy = OnDestroy
BuildMainZeroUpgradeOneScene.ComponentDefine = ComponentDefine
BuildMainZeroUpgradeOneScene.ComponentDestroy = ComponentDestroy
BuildMainZeroUpgradeOneScene.DataDefine = DataDefine
BuildMainZeroUpgradeOneScene.DataDestroy = DataDestroy
BuildMainZeroUpgradeOneScene.ReInit = ReInit
BuildMainZeroUpgradeOneScene.GetOriginalPos = GetOriginalPos
BuildMainZeroUpgradeOneScene.PlayBuildAnim = PlayBuildAnim
BuildMainZeroUpgradeOneScene.PlayDomedAnim = PlayDomedAnim
BuildMainZeroUpgradeOneScene.DeleteShowTimer = DeleteShowTimer
BuildMainZeroUpgradeOneScene.ShowTimeCallBack = ShowTimeCallBack
BuildMainZeroUpgradeOneScene.OnClick = OnClick
BuildMainZeroUpgradeOneScene.GetGuideObj = GetGuideObj
BuildMainZeroUpgradeOneScene.AddHideEffectTimer = AddHideEffectTimer
BuildMainZeroUpgradeOneScene.DeleteHideEffectTimer = DeleteHideEffectTimer
BuildMainZeroUpgradeOneScene.HideEffectTimerCallBack = HideEffectTimerCallBack
BuildMainZeroUpgradeOneScene.DeleteHideRocketTimer = DeleteHideRocketTimer
BuildMainZeroUpgradeOneScene.HideRocketTimerCallBack = HideRocketTimerCallBack
BuildMainZeroUpgradeOneScene.AddHideRocketTimer = AddHideRocketTimer
BuildMainZeroUpgradeOneScene.AddDomeTimer = AddDomeTimer
BuildMainZeroUpgradeOneScene.DeleteDomeTimer = DeleteDomeTimer
BuildMainZeroUpgradeOneScene.DomeTimerCallBack = DomeTimerCallBack
return BuildMainZeroUpgradeOneScene
