local ShowMigrateScene = BaseClass("ShowMigrateScene")
local all_timeline_path = "XS_yimin_timeline_master_mov/XS_yimin_timelin_mov"
local click_go_path = "ClickObjGo"
local bubble_anim_path = "ClickObjGo/BuildStateIcon/Go"
local bubble_trigger_path = "ClickObjGo/BuildStateIcon/Go/Trigger"
local timeline_go_path = "XS_yimin_timeline_master_mov"
local StartTime = 0.8333333
local BubbleAnimName = {
  Show = "EnterBubble",
  Idle = "NormalBubble"
}

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
  self.timeline_go = self.transform:Find(timeline_go_path)
  self.click_go = self.transform:Find(click_go_path)
  self.bubble_anim = self.transform:Find(bubble_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.bubble_trigger = self.transform:Find(bubble_trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bubble_trigger.onPointerClick()
    self:OnClick()
  end
end

local function ComponentDestroy(self)
  self.director = nil
  self.timeline_go = nil
  self.click_go = nil
  self.bubble_anim = nil
  self.bubble_trigger.onPointerClick = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.showTimer = nil
  
  function self.show_timer_action(temp)
    self:ShowTimeCallBack()
  end
end

local function DataDestroy(self)
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  self:DeleteShowTimer()
  self.show_timer_action = nil
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.transform.position = self.param.pos
  self.director.time = 0
  self.director:Stop()
  self.click_go.gameObject:SetActive(true)
  self.timeline_go.gameObject:SetActive(false)
  self:OnClick()
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
  self.timeline_go.gameObject:SetActive(true)
  self.director.time = StartTime
  self.director:Play()
  self.click_go.gameObject:SetActive(false)
  local needParam = {}
  needParam.click = true
  DataCenter.GuideManager:SetCompleteNeedParam(needParam)
  DataCenter.GuideManager:CheckGuideComplete()
end

local function GetGuideObj(self)
  return self.bubble_trigger.gameObject
end

ShowMigrateScene.OnCreate = OnCreate
ShowMigrateScene.OnDestroy = OnDestroy
ShowMigrateScene.ComponentDefine = ComponentDefine
ShowMigrateScene.ComponentDestroy = ComponentDestroy
ShowMigrateScene.DataDefine = DataDefine
ShowMigrateScene.DataDestroy = DataDestroy
ShowMigrateScene.ReInit = ReInit
ShowMigrateScene.DeleteShowTimer = DeleteShowTimer
ShowMigrateScene.ShowTimeCallBack = ShowTimeCallBack
ShowMigrateScene.OnClick = OnClick
ShowMigrateScene.GetGuideObj = GetGuideObj
return ShowMigrateScene
