local ShowOstrichScene = BaseClass("ShowOstrichScene")
local all_timeline_path = "XS_a_animal_Ostrich_timeline"
local anim_path = "BubbleObj/XS_a_animal_Ostrich_eggs/A_animal@Ostrich_eggs_skin"
local bubble_anim_path = "BubbleObj/BuildStateIcon/Go"
local bubble_trigger_path = "BubbleObj/BuildStateIcon/Go/Trigger"
local effect_anim_path = "BubbleObj/VFX_xinshou_dongwu_egg_start"
local bubble_obj_path = "BubbleObj"
local name_text_path = "XS_a_animal_Ostrich_timeline/VFX_xinshou_liangxiang_tuoniao_ziti/ziti_01"
local name_text_outline_path = "XS_a_animal_Ostrich_timeline/VFX_xinshou_liangxiang_tuoniao_ziti/ziti_02"
local EggAnimName = {Show = "show", Idle = "idle"}
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
  self.effect_anim = self.transform:Find(effect_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.bubble_obj = self.transform:Find(bubble_obj_path)
  self.name_text = self.transform:Find(name_text_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.name_text_outline = self.transform:Find(name_text_outline_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.anim = self.transform:Find(anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.bubble_anim = self.transform:Find(bubble_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.bubble_trigger = self.transform:Find(bubble_trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bubble_trigger.onPointerClick()
    self:OnClick()
  end
end

local function ComponentDestroy(self)
  if self.bubble_trigger then
    self.bubble_trigger.onPointerClick = nil
    self.bubble_trigger = nil
  end
  self.director = nil
  self.effect_anim = nil
  self.bubble_obj = nil
  self.name_text = nil
  self.name_text_outline = nil
  self.anim = nil
  self.bubble_anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.effectTimer = nil
  self.showTimer = nil
  
  function self.effect_timer_action(temp)
    self:EffectTimeCallBack()
  end
  
  function self.show_timer_action(temp)
    self:ShowTimeCallBack()
  end
  
  self.loopAnimTimer = nil
  
  function self.loop_anim_timer_action(temp)
    self:LoopAnimTimeCallBack()
  end
end

local function DataDestroy(self)
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  self:DeleteEffectTimer()
  self:DeleteShowTimer()
  self:DeleteLoopAnimTimer()
  self.loop_anim_timer_action = nil
  self.param = nil
  self.effect_timer_action = nil
  self.show_timer_action = nil
end

local function ReInit(self, param)
  self.param = param
  self.gameObject.transform:Set_position(param.pos.x, param.pos.y, param.pos.z)
  self.name_text.text = param.nameDes
  self.name_text_outline.text = param.nameDes
  self.bubble_obj.gameObject:SetActive(true)
  self.director.gameObject:SetActive(false)
  local animName = EggAnimName.Show
  local time = self.anim:GetClipLength(animName)
  if time ~= nil and 0 < time then
    self.anim:Play(animName)
    self.effect_anim:Play(animName)
    self.effectTimer = TimerManager:GetInstance():GetTimer(time, self.effect_timer_action, self, true, false, false)
    self.effectTimer:Start()
  end
  animName = BubbleAnimName.Show
  time = self.bubble_anim:GetClipLength(animName)
  if time ~= nil and 0 < time then
    self.bubble_anim:Play(animName)
    self.showTimer = TimerManager:GetInstance():GetTimer(time, self.show_timer_action, self, true, false, false)
    self.showTimer:Start()
  end
end

local function DeleteEffectTimer(self)
  if self.effectTimer ~= nil then
    self.effectTimer:Stop()
    self.effectTimer = nil
  end
end

local function DeleteShowTimer(self)
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
end

local function EffectTimeCallBack(self)
  self:DeleteEffectTimer()
  local animName = EggAnimName.Idle
  local time = self.anim:GetClipLength(animName)
  if time ~= nil and 0 < time then
    self.anim:Play(animName)
    self.effect_anim:Play(animName)
    self.loopAnimTimer = TimerManager:GetInstance():GetTimer(time, self.loop_anim_timer_action, self, false, false, false)
    self.loopAnimTimer:Start()
  end
end

local function DeleteLoopAnimTimer(self)
  if self.loopAnimTimer ~= nil then
    self.loopAnimTimer:Stop()
    self.loopAnimTimer = nil
  end
end

local function LoopAnimTimeCallBack(self)
  self.effect_anim:Rewind()
end

local function ShowTimeCallBack(self)
  self:DeleteShowTimer()
  self.bubble_anim:Play(BubbleAnimName.Idle)
end

local function OnClick(self)
  local needParam = {}
  needParam.click = true
  DataCenter.GuideManager:SetCompleteNeedParam(needParam)
  DataCenter.GuideManager:CheckGuideComplete()
  self.bubble_obj.gameObject:SetActive(false)
  self.director.gameObject:SetActive(true)
end

local function GetGuideObj(self)
  return self.bubble_trigger.gameObject
end

local function OnEnd(self)
end

ShowOstrichScene.OnCreate = OnCreate
ShowOstrichScene.OnDestroy = OnDestroy
ShowOstrichScene.ComponentDefine = ComponentDefine
ShowOstrichScene.ComponentDestroy = ComponentDestroy
ShowOstrichScene.DataDefine = DataDefine
ShowOstrichScene.DataDestroy = DataDestroy
ShowOstrichScene.ReInit = ReInit
ShowOstrichScene.DeleteEffectTimer = DeleteEffectTimer
ShowOstrichScene.EffectTimeCallBack = EffectTimeCallBack
ShowOstrichScene.DeleteShowTimer = DeleteShowTimer
ShowOstrichScene.ShowTimeCallBack = ShowTimeCallBack
ShowOstrichScene.OnClick = OnClick
ShowOstrichScene.GetGuideObj = GetGuideObj
ShowOstrichScene.DeleteLoopAnimTimer = DeleteLoopAnimTimer
ShowOstrichScene.LoopAnimTimeCallBack = LoopAnimTimeCallBack
ShowOstrichScene.OnEnd = OnEnd
return ShowOstrichScene
