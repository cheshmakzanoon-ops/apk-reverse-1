local Resource = CS.GameEntry.Resource
local WorldMember = require("Scene.LWWorldMarch.WorldMember")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local MarchSticker = require("Scene.LWWorldMarch.MarchSticker")
local stickerPerfabPatch = "Assets/Main/Prefabs/UI/UIDecoration/mapStickerItem.prefab"
local AlBuildAssistSquad = BaseClass("AlBuildAssistSquad")

function AlBuildAssistSquad:Init(manager, guid, ownerUUID, heroes, formation, parent, scaleCtrl, displayLevel)
  self.heroes = heroes
  self.gameObject = CS.UnityEngine.GameObject("AlBuildAssistSquad")
  self.gameObject.transform:SetParent(parent, false)
  self.transform = self.gameObject.transform
  self.battleMgr = manager
  self.guid = guid
  self.ownerUid = ownerUUID
  self.members = {}
  self.cur_pos = Vector3.New(0, 0, 0)
  self.destination = nil
  self.formation = formation
  self.createdMember = 0
  self.lastTimeCheckNeedStop = 0
  self.scaleCtrl = scaleCtrl
  self.animNameCache = nil
  self.delayEvents = {}
  self.displayLevel = displayLevel or DisplaySettings.Levels.Low
end

function AlBuildAssistSquad:__delete()
  self:Destroy()
end

function AlBuildAssistSquad:Destroy()
  for _, v in pairs(self.members) do
    self.battleMgr:RemoveUnitTotal(v)
  end
  self.members = {}
  self.battleMgr = nil
  self.guid = nil
  self.cur_pos = nil
  self.destination = nil
  self.formation = nil
  self.createdMember = 0
  self.curStickerId = nil
  if self.gameObject then
    CS.UnityEngine.GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
  if self.iconsComp then
    self.iconsComp:Delete()
    self.iconsComp = nil
  end
  if self.iconsRoot then
    CS.UnityEngine.GameObject.Destroy(self.iconsRoot.gameObject)
    self.iconsRoot = nil
  end
  self.animNameCache = nil
  for _, v in pairs(self.delayEvents) do
    v:Stop()
  end
  if self.marchSticker then
    self.marchSticker:Delete()
    self.marchSticker = nil
  end
  self.delayEvents = {}
  self.heroes = nil
end

function AlBuildAssistSquad:OnCreate()
  self:CreateMembers()
  self:UpdateDisplayMode()
end

function AlBuildAssistSquad:ShowSticker(stickerId, bUuid, numParam)
  if not stickerId then
    return
  end
  self.curStickerId = stickerId
  self.curNumParam = numParam
  if self.marchSticker then
    self.marchSticker:ShowSticker(self.curStickerId, nil, self.curNumParam)
  else
    self:CreateSticker()
  end
end

function AlBuildAssistSquad:CreateSticker()
  local req = Resource:InstantiateAsync(stickerPerfabPatch)
  self.marchSticker = ObjectPool:GetInstance():Load(MarchSticker)
  self.marchSticker:Init(self.transform.parent, req, self.stickerData)
  req:completed("+", function()
    if req.isError then
      return
    end
    self.marchSticker:OnCreate()
    self.marchSticker:ShowSticker(self.curStickerId, nil, self.curNumParam)
  end)
end

function AlBuildAssistSquad:CreateMembers()
  if self.heroes == nil then
    Logger.LogError("heroes is nil")
    return
  end
  for slotIndex, heroData in pairs(self.heroes) do
    local hero = heroData
    local objId = self.battleMgr:GetNextObjId()
    local member
    member = ObjectPool:GetInstance():Load(WorldMember)
    member:Init(self.battleMgr, self, objId, nil, slotIndex, hero)
    member.isLeader = hero.isLeader
    table.insert(self.members, member)
    self.battleMgr:AddUnit(member)
    self:OnCreateFinish()
  end
end

function AlBuildAssistSquad:CheckCreateFinish()
  if self.createdMember >= #self.members then
    if self.scaleCtrl then
      self.transform:Set_localScale(self.scaleCtrl, self.scaleCtrl, self.scaleCtrl)
    end
    if self.animNameCache then
      self:PlayAnim(self.animNameCache)
    end
  end
end

function AlBuildAssistSquad:UpdateDisplayMode()
  for _, v in pairs(self.members) do
    v:UpdateDisplayMode()
  end
end

function AlBuildAssistSquad:OnCreateFinish()
  self.createdMember = self.createdMember + 1
  self:CheckCreateFinish()
end

function AlBuildAssistSquad:SetRotation(quat)
  self.transform.rotation = quat
end

function AlBuildAssistSquad:PlayAnim(anim, rewind)
  for _, v in pairs(self.members) do
    v:PlayAnim(anim, rewind)
  end
end

function AlBuildAssistSquad:Attack(targetPos, index)
  for _, v in pairs(self.members) do
    v:Attack(targetPos, index)
  end
end

function AlBuildAssistSquad:SetPosition(pos)
  self.cur_pos.x = pos.x
  self.cur_pos.z = pos.z
  self.transform.position = self.cur_pos
end

function AlBuildAssistSquad:GetPosition()
  return self.cur_pos
end

function AlBuildAssistSquad:GetMemberTotalCount()
  return table.count(self.heroes)
end

function AlBuildAssistSquad:OnUpdate()
  for _, v in pairs(self.members) do
    v:OnUpdate()
  end
end

function AlBuildAssistSquad:AddDelayEvent(event, delay)
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function AlBuildAssistSquad:SetOnFire(value)
  for _, v in pairs(self.members) do
    v:SetOnFire(value)
  end
end

return AlBuildAssistSquad
