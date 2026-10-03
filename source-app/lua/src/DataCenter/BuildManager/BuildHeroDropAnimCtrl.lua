local BuildHeroDropAnimCtrl = BaseClass("BuildHeroDropAnimCtrl")
local Resource = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local SceneManager = CS.SceneManager
local AirDropTimeLine1 = "Assets/Main/Prefabs/BuildingHero/zhishengjikongtou_Timeline.prefab"
local AirDropTimeLine2 = "Assets/Main/Prefabs/BuildingHero/zhishengjikongtou_Timeline02.prefab"
local AirDropEffectPrefabPath = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_tudou_somke.prefab"
local HeroBoxPrefabPath = "Assets/_Art_LastWar/Models/Characters/Object/A_pror_container_01/prefab/A_pror_container_01_1.prefab"
local HeroBoxOpenPrefabPath = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_xinshou_xiangzi_open.prefab"

function BuildHeroDropAnimCtrl:__init()
  self.quests = {}
  self.boxReqest = {}
end

function BuildHeroDropAnimCtrl:__delete()
  self.quests = nil
  self.boxReqest = nil
end

function BuildHeroDropAnimCtrl:IsPlaying()
  return next(self.quests) ~= nil
end

function BuildHeroDropAnimCtrl:CreateQuest(questID, position, dropOffset, boxOffset, dustOffset, onClickCallback, callerRef, callbackData)
  if self.quests[questID] ~= nil then
    printError("BuildHeroDropAnimCtrl:CreateQuest questID duplicate! questID = " .. questID)
    return
  end
  if not self:IsPlaying() then
    self.origZoom = SceneManager.World.Zoom
    SceneManager.World.CanMoving = false
  end
  local quest = {
    id = questID,
    pos = position,
    offset = dropOffset,
    bOffset = boxOffset,
    vOffset = dustOffset,
    onClick = onClickCallback,
    caller = callerRef,
    data = callbackData
  }
  self.quests[questID] = quest
  quest.timelineResHandle = Resource:InstantiateAsync(AirDropTimeLine1)
  quest.timelineResHandle:completed("+", function(req)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Env_HeroFirstEntry_Heli_TL, false)
    self:OnEnterTLResLoaded(quest)
  end)
end

function BuildHeroDropAnimCtrl:DestroyQuest(questID)
  local quest = self.quests[questID]
  if quest == nil then
    return
  end
  if quest.timelineResHandle ~= nil and not IsNull(quest.timelineResHandle) then
    quest.timelineResHandle:RealDestroy()
    quest.timelineResHandle = nil
  end
  self.quests[questID] = nil
end

function BuildHeroDropAnimCtrl:DestroyBox(questID)
  if self.boxReqest == nil then
    Logger.LogError("[BuildHeroDropAnimCtrl:DestroyBox] :logic error,")
    return
  end
  local boxReq = self.boxReqest[questID]
  if boxReq == nil or IsNull(boxReq) then
    return
  end
  boxReq:RealDestroy()
  self.boxReqest[questID] = nil
end

function BuildHeroDropAnimCtrl:QuestDone(questID)
  self:DestroyQuest(questID)
  if SceneManager.World.ExitTimeline ~= nil then
    SceneManager.World:ExitTimeline(self.timelineSyncHandle)
  end
  EventManager:GetInstance():Broadcast(EventId.GF_city_hero_drop_anim_done, questID)
  if not self:IsPlaying() then
    if self.origZoom > 0 and SceneManager.World.Zoom ~= self.origZoom then
      SceneManager.World:AutoZoom(self.origZoom, 0.2)
    end
    SceneManager.World.CanMoving = true
  end
end

function BuildHeroDropAnimCtrl:OnEnterTLResLoaded(quest)
  if SceneManager.CurrSceneID ~= SceneManagerSceneID.City then
    self:DestroyQuest(quest.id)
    return
  end
  quest.director = quest.timelineResHandle.gameObject:GetComponent(typeof(PlayableDirector))
  local timelineTrans = quest.timelineResHandle.gameObject.transform
  timelineTrans.parent = SceneManager.World.transform
  timelineTrans:Set_position(quest.pos.x + quest.offset.x, quest.pos.y + quest.offset.y, quest.pos.z + quest.offset.z)
  
  local function directorStopped()
    self:PlayAirDropEffect(quest)
    if SceneManager.CurrSceneID == SceneManagerSceneID.City then
      self:CreateBox(quest)
    else
      self:DestroyQuest(quest.id)
    end
  end
  
  if SceneManager.World.EnterTimeline ~= nil then
    local camInTimeline = timelineTrans:Find("Camera"):GetComponent(typeof(CS.UnityEngine.Camera))
    self.timelineSyncHandle = SceneManager.World:EnterTimeline(camInTimeline, 1)
    camInTimeline.enabled = false
  end
  quest.director:stopped("+", directorStopped)
  if not IsNull(quest.director) then
    quest.director:Play()
  end
end

function BuildHeroDropAnimCtrl:CreateBox(quest)
  local req = Resource:InstantiateAsync(HeroBoxPrefabPath)
  self.boxReqest[quest.id] = req
  req:completed("+", function()
    if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.City then
      req:RealDestroy()
      self.boxReqest[quest.id] = nil
      self:DestroyQuest(quest.id)
      return
    end
    req.gameObject.transform.parent = CS.SceneManager.World.transform
    req.gameObject.transform:Set_position(quest.pos.x + quest.bOffset.x, quest.pos.y + quest.bOffset.y, quest.pos.z + quest.bOffset.z)
    local trigger = req.gameObject.transform:Find(""):GetComponent(typeof(CS.TouchObjectEventTrigger))
    
    function trigger.onPointerClick()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Hero_FirstEntry_BoxOpen, false)
      if quest.clicked then
        return
      end
      quest.clicked = true
      if quest.onClick then
        quest.onClick(quest.caller, quest.data)
      end
      EventManager:GetInstance():Broadcast(EventId.GF_city_hero_drop_box_clicked, quest.id)
      local animation = req.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if animation then
        animation:Play("open")
      end
      self:PlayBoxOpenEffect(quest)
      TimerManager:GetInstance():DelayInvoke(function()
        if req then
          req:RealDestroy()
        end
        self.boxReqest[quest.id] = nil
      end, 2)
    end
    
    self:OnAirDropExit(quest)
  end)
end

function BuildHeroDropAnimCtrl:OnAirDropExit(quest)
  local exit_resource = Resource:InstantiateAsync(AirDropTimeLine2)
  exit_resource:completed("+", function(req)
    if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.City then
      exit_resource:RealDestroy()
      self:DestroyQuest(quest.id)
      return
    end
    self:QuestDone(quest.id)
    local exit_director = req.gameObject:GetComponent(typeof(PlayableDirector))
    req.gameObject.transform.parent = CS.SceneManager.World.transform
    req.gameObject.transform:Set_position(quest.pos.x + quest.offset.x, quest.pos.y + quest.offset.y, quest.pos.z + quest.offset.z)
    
    local function directorStopped()
      exit_resource:RealDestroy()
    end
    
    exit_director:stopped("+", directorStopped)
    if not IsNull(exit_director) then
      exit_director:Play()
    end
  end)
end

function BuildHeroDropAnimCtrl:PlayAirDropEffect(quest)
  local req = Resource:InstantiateAsync(AirDropEffectPrefabPath)
  req:completed("+", function(req)
    if req.isError then
      req:Destroy()
      return
    end
    if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.City then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    tf.localScale = VecZero
    tf.parent = CS.SceneManager.World.transform
    tf:Set_position(quest.pos.x + quest.vOffset.x, quest.pos.y + quest.vOffset.y, quest.pos.z + quest.vOffset.z)
    TimerManager:GetInstance():DelayInvoke(function()
      if req then
        req:Destroy()
      end
    end, 1)
  end)
end

function BuildHeroDropAnimCtrl:PlayBoxOpenEffect(quest)
  local req = Resource:InstantiateAsync(HeroBoxOpenPrefabPath)
  req:completed("+", function(req)
    if req.isError then
      req:Destroy()
      return
    end
    if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.City then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    tf.localScale = VecZero
    tf.parent = CS.SceneManager.World.transform
    tf:Set_position(quest.pos.x + quest.bOffset.x, quest.pos.y + quest.bOffset.y, quest.pos.z + quest.bOffset.z)
    tf:Set_localScale(3, 3, 3)
    TimerManager:GetInstance():DelayInvoke(function()
      if req then
        req:Destroy()
      end
    end, 1)
  end)
end

return BuildHeroDropAnimCtrl
