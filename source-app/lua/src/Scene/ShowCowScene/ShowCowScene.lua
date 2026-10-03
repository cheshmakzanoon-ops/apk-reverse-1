local ShowCowScene = BaseClass("ShowCowScene")
local all_timeline_path = "XS_a_animal_Cattle_Timeline"
local bubble_anim_path = "BubbleObj/BuildStateIcon/Go"
local bubble_trigger_path = "BubbleObj/BuildStateIcon/Go/Trigger"
local box_anim_path = "BubbleObj/A_animal_box/A_animal@box_skin"
local effect_anim_path = "BubbleObj/VFX_xinshou_dongwu_xiangzi_start"
local bubble_obj_path = "BubbleObj"
local name_text_path = "XS_a_animal_Cattle_Timeline/VFX_xinshou_nainiu_ziti/ziti_01"
local name_text_outline_path = "XS_a_animal_Cattle_Timeline/VFX_xinshou_nainiu_ziti/ziti_02"
local BubbleAnimName = {
  Show = "EnterBubble",
  Idle = "NormalBubble"
}
local AnimName = {Show = "show", Idle = "idle"}

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
  self.box_anim = self.transform:Find(box_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.effect_anim = self.transform:Find(effect_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.bubble_obj = self.transform:Find(bubble_obj_path)
  self.bubble_anim = self.transform:Find(bubble_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.name_text = self.transform:Find(name_text_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.name_text_outline = self.transform:Find(name_text_outline_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.bubble_trigger = self.transform:Find(bubble_trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bubble_trigger.onPointerClick()
    self:OnClick()
  end
end

local function ComponentDestroy(self)
  self.director = nil
  self.bubble_anim = nil
  self.bubble_trigger.onPointerClick = nil
  self.bubble_trigger = nil
  self.box_anim = nil
  self.effect_anim = nil
  self.bubble_obj = nil
  self.name_text = nil
  self.name_text_outline = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.showTimer = nil
  
  function self.show_timer_action(temp)
    self:ShowTimeCallBack()
  end
  
  self.showAnimTimer = nil
  
  function self.show_anim_timer_action(temp)
    self:ShowAnimTimeCallBack()
  end
  
  self.loopAnimTimer = nil
  
  function self.loop_anim_timer_action(temp)
    self:LoopAnimTimeCallBack()
  end
end

local function DataDestroy(self)
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  self:DeleteShowTimer()
  self.param = nil
  self.show_timer_action = nil
  self:DeleteShowAnimTimer()
  self.show_anim_timer_action = nil
  self:DeleteLoopAnimTimer()
  self.loop_anim_timer_action = nil
end

local function ReInit(self, param)
  self.param = param
  self.gameObject.transform:Set_position(param.pos.x, param.pos.y, param.pos.z)
  self.name_text.text = param.nameDes
  self.name_text_outline.text = param.nameDes
  self.bubble_obj.gameObject:SetActive(true)
  self.director.gameObject:SetActive(false)
  local animName = BubbleAnimName.Show
  local time = self.bubble_anim:GetClipLength(animName)
  if time ~= nil and 0 < time then
    self.bubble_anim:Play(animName)
    self.showTimer = TimerManager:GetInstance():GetTimer(time, self.show_timer_action, self, true, false, false)
    self.showTimer:Start()
  end
  animName = AnimName.Show
  time = self.box_anim:GetClipLength(animName)
  if time ~= nil and 0 < time then
    self.box_anim:Play(animName)
    self.effect_anim:Play(animName)
    self.showAnimTimer = TimerManager:GetInstance():GetTimer(time, self.show_anim_timer_action, self, true, false, false)
    self.showAnimTimer:Start()
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

local function DeleteShowAnimTimer(self)
  if self.showAnimTimer ~= nil then
    self.showAnimTimer:Stop()
    self.showAnimTimer = nil
  end
end

local function ShowAnimTimeCallBack(self)
  self:DeleteShowAnimTimer()
  local animName = AnimName.Idle
  local time = self.box_anim:GetClipLength(animName)
  if time ~= nil and 0 < time then
    self.box_anim:Play(animName)
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
  PastureAnimalManager:GetInstance():DoGuideShowAnim(self.param.queueType, self.param.qUuid, self.param.pos)
end

ShowCowScene.OnCreate = OnCreate
ShowCowScene.OnDestroy = OnDestroy
ShowCowScene.ComponentDefine = ComponentDefine
ShowCowScene.ComponentDestroy = ComponentDestroy
ShowCowScene.DataDefine = DataDefine
ShowCowScene.DataDestroy = DataDestroy
ShowCowScene.ReInit = ReInit
ShowCowScene.DeleteShowTimer = DeleteShowTimer
ShowCowScene.ShowTimeCallBack = ShowTimeCallBack
ShowCowScene.OnClick = OnClick
ShowCowScene.GetGuideObj = GetGuideObj
ShowCowScene.OnEnd = OnEnd
ShowCowScene.DeleteShowAnimTimer = DeleteShowAnimTimer
ShowCowScene.ShowAnimTimeCallBack = ShowAnimTimeCallBack
ShowCowScene.DeleteLoopAnimTimer = DeleteLoopAnimTimer
ShowCowScene.LoopAnimTimeCallBack = LoopAnimTimeCallBack
return ShowCowScene
