local Resource = CS.GameEntry.Resource
local Member = require("Scene.LWWorldMarch.Member")
local TacticalWeaponMember = require("Scene.LWWorldMarch.TacticalWeaponMember")
local WorldMember = require("Scene.LWWorldMarch.WorldMember")
local WorldDrone = require("Scene.LWWorldMarch.WorldDrone")
local WorldMummyMember = require("Scene.LWWorldMarch.WorldMummyMember")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local MarchSticker = require("Scene.LWWorldMarch.MarchSticker")
local stickerPerfabPatch = "Assets/Main/Prefabs/UI/UIDecoration/mapStickerItem.prefab"
local meteoritePerfabPatch = "Assets/Main/Prefabs/March/TroopMeteorite.prefab"
local CsMeteorite = typeof(CS.UICityMeteorite)
local Squad = BaseClass("Squad")

function Squad:Init(manager, guid, ownerUid, heroes, formation, parent, scaleCtrl, tacWeaponInfo, tacWeaponAppearanceId, displayLevel, collider, marchUuid)
  self.heroes = heroes
  if not self.gameObject or self.gameObject.transform.parent ~= parent then
    self.gameObject = CS.UnityEngine.GameObject("Squad")
    self.gameObject.transform:SetParent(parent, false)
    self.transform = self.gameObject.transform
  end
  self.battleMgr = manager
  self.guid = guid
  self.ownerUid = ownerUid
  self.members = {}
  self.tacWeaponMembers = {}
  self.cur_pos = Vector3.New(0, 0, 0)
  self.destination = nil
  self.formation = formation
  self.createdMember = 0
  self.createdWeaponMember = 0
  self.lastTimeCheckNeedStop = 0
  self.scaleCtrl = scaleCtrl
  self.animNameCache = nil
  self.superArmor = false
  self.superArmorDirty = true
  self.delayEvents = {}
  self.displayLevel = displayLevel or DisplaySettings.Levels.Low
  self.tacWeaponInfo = tacWeaponInfo
  self.tacWeaponAppearanceId = tacWeaponAppearanceId
  self.collider = collider
  self.marchUuid = marchUuid
  if IsNull(self.collider) then
    self.collider = nil
  end
  self.tacWeaponMembersAttack = false
  self:UpdateLod(DisplaySettings.currentLod)
end

function Squad:__delete()
  self:Destroy()
end

function Squad:Destroy()
  if self.members then
    for _, v in pairs(self.members) do
      self.battleMgr:RemoveUnitTotal(v)
    end
  end
  self.members = {}
  if self.tacWeaponMembers then
    for _, v in pairs(self.tacWeaponMembers) do
      self.battleMgr:RemoveUnitTotal(v)
    end
  end
  self.tacWeaponMembers = {}
  self.battleMgr = nil
  self.guid = nil
  self.cur_pos = nil
  self.destination = nil
  self.formation = nil
  self.createdMember = 0
  self.curStickerId = nil
  self.createdWeaponMember = 0
  self.tacWeaponMembersAttack = false
  if self.iconsComp then
    self.iconsComp:Delete()
    self.iconsComp = nil
  end
  self.animNameCache = nil
  if self.delayEvents then
    for _, v in pairs(self.delayEvents) do
      v:Stop()
    end
  end
  if self.marchSticker then
    self.marchSticker:Delete()
    self.marchSticker = nil
  end
  self:ClearMummy()
  self.delayEvents = {}
  self.heroes = nil
  self.tacWeaponInfo = nil
  self.collider = nil
  self:DestroyMeteoriteNode()
  self.marchUuid = nil
  if self.iconsRoot then
    CS.UnityEngine.GameObject.Destroy(self.iconsRoot.gameObject)
    self.iconsRoot = nil
  end
  if self.gameObject then
    CS.UnityEngine.GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
end

function Squad:OnCreate(isMummyMarch)
  self.isMummyMarch = isMummyMarch
  if isMummyMarch then
    self:RefreshMummyMembers()
  else
    self:CreateMembers()
  end
  self:CreateTacWeaponMembers()
  self:UpdateDisplayMode()
  self:UpdateMiscRenderers()
end

function Squad:ShowSticker(stickerId, bUuid, numParam, isSimpleMode)
  if not stickerId then
    return false
  end
  self.curStickerId = stickerId
  self.curNumParam = numParam
  self.isSimpleMode = isSimpleMode
  if self.marchSticker then
    self.marchSticker:ShowSticker(self.curStickerId, nil, self.curNumParam, isSimpleMode)
  else
    self:CreateSticker()
  end
  return true
end

function Squad:CreateSticker()
  local req = Resource:InstantiateAsync(stickerPerfabPatch)
  self.marchSticker = ObjectPool:GetInstance():Load(MarchSticker)
  self.marchSticker:Init(self.transform.parent, req, self.stickerData)
  req:completed("+", function()
    if req.isError then
      return
    end
    self.marchSticker:OnCreate()
    self.marchSticker:ShowSticker(self.curStickerId, nil, self.curNumParam, self.isSimpleMode)
  end)
end

function Squad:ClearMummy()
  if self.asyncMummyEffectDown then
    self.asyncMummyEffectDown:Delete()
    self.asyncMummyEffectDown = nil
  end
  if self.asyncMummyEffSand then
    self.asyncMummyEffSand:Delete()
    self.asyncMummyEffSand = nil
  end
  if self.asyncMummyBoss then
    self.asyncMummyBoss:Delete()
    self.asyncMummyBoss = nil
  end
  if self.asyncMummyGroup then
    self.asyncMummyGroup:Delete()
    self.asyncMummyGroup = nil
  end
  if self.season_mummy_member then
    self.season_mummy_member:Delete()
    self.season_mummy_member = nil
  end
  self.nodeEffectSand = nil
  self.nodeBossRoot = nil
  self.nodeMummyEffectDown = nil
  self.nodeSoldierGroup = nil
  self.memberMummyBoss = nil
  self.memberGroup = nil
end

function Squad:RefreshMummyEffectDown(show)
  if show == nil then
    local mummyEffDown, mummyBoss, mummyGroup, mummyEffSand = WorldSimpleModeUtils.ShowMummyMembers()
    show = mummyEffDown
  end
  if show then
    if not self.asyncMummyEffectDown then
      if self.nodeMummyEffectDown then
        self.asyncMummyEffectDown = UIAsyncNode.New("[mummy]effectDown", self.nodeMummyEffectDown, UIAssets.MummyEffDown, function(go)
          self:RefreshMummyEffectDown(nil)
        end)
      end
    else
      self.asyncMummyEffectDown:SetActive(true)
    end
  elseif self.asyncMummyEffectDown then
    self.asyncMummyEffectDown:SetActive(false)
  end
end

function Squad:RefreshMummyEffSand(show)
  if show == nil then
    local mummyEffDown, mummyBoss, mummyGroup, mummyEffSand = WorldSimpleModeUtils.ShowMummyMembers()
    show = mummyEffSand
  end
  if show then
    if not self.asyncMummyEffSand then
      if self.nodeEffectSand then
        self.asyncMummyEffSand = UIAsyncNode.New("[mummy]effectSand", self.nodeEffectSand, UIAssets.MummyEffSand, function(go)
          self:RefreshMummyEffSand(nil)
        end)
      end
    else
      self.asyncMummyEffSand:SetActive(true)
    end
  elseif self.asyncMummyEffSand then
    self.asyncMummyEffSand:SetActive(false)
  end
end

function Squad:RefreshMummyBoss(show)
  if show == nil then
    local mummyEffDown, mummyBoss, mummyGroup, mummyEffSand = WorldSimpleModeUtils.ShowMummyMembers()
    show = mummyBoss
  end
  if show then
    if not self.asyncMummyBoss then
      if self.nodeBossRoot then
        self.asyncMummyBoss = UIAsyncNode.New("[mummy]boss", self.nodeBossRoot, UIAssets.MummyMarchBoss, function(go)
          local mgr = ObjectPool:GetInstance()
          local member = mgr:Load(WorldMummyMember)
          local objId = self.battleMgr:GetNextObjId()
          member.isLeader = true
          member:Init(self.battleMgr, self, objId, go.transform, 99)
          if self.animNameCache ~= nil and self.rewindCache ~= nil then
            member:PlayAnim(self.animNameCache, self.rewindCache)
          end
          table.insert(self.members, member)
          self.battleMgr:AddUnit(member)
          member:UpdateDisplayMode()
          self.memberMummyBoss = member
          local mummyEffDown, mummyBoss, mummyGroup, mummyEffSand = WorldSimpleModeUtils.ShowMummyMembers()
          self.asyncMummyBoss:SetActive(mummyBoss)
        end)
      end
    else
      self.asyncMummyBoss:SetActive(true)
      if self.memberMummyBoss and self.animNameCache then
        self.memberMummyBoss:PlayAnim(self.animNameCache)
      end
    end
  elseif self.asyncMummyBoss then
    self.asyncMummyBoss:SetActive(false)
  end
end

function Squad:RefreshMummyGroup(show)
  if show == nil then
    local mummyEffDown, mummyBoss, mummyGroup, mummyEffSand = WorldSimpleModeUtils.ShowMummyMembers()
    show = mummyGroup
  end
  if show then
    if not self.asyncMummyGroup then
      if self.nodeBossRoot then
        self.asyncMummyGroup = UIAsyncNode.New("[mummy]group", self.nodeSoldierGroup, UIAssets.MummyMarchGroup, function(go)
          local mummyEffDown, mummyBoss, mummyGroup, mummyEffSand = WorldSimpleModeUtils.ShowMummyMembers()
          self.asyncMummyGroup:SetActive(mummyGroup)
          self.memberGroup = {}
          local mgr = ObjectPool:GetInstance()
          for i = 1, 16 do
            local tran = go.transform:Find("A_Monster_Zombie" .. i)
            if tran then
              local objId = self.battleMgr:GetNextObjId()
              local member = mgr:Load(WorldMummyMember)
              member.isLeader = false
              member:Init(self.battleMgr, self, objId, tran, i)
              if self.animNameCache ~= nil and self.rewindCache ~= nil then
                member:PlayAnim(self.animNameCache, self.rewindCache)
              end
              table.insert(self.members, member)
              table.insert(self.memberGroup, member)
              self.battleMgr:AddUnit(member)
              member:UpdateDisplayMode()
            else
              break
            end
          end
        end)
      end
    else
      self.asyncMummyGroup:SetActive(true)
      if self.memberGroup and self.animNameCache then
        for k, v in ipairs(self.memberGroup) do
          v:PlayAnim(self.animNameCache)
        end
      end
    end
  elseif self.asyncMummyGroup then
    self.asyncMummyGroup:SetActive(false)
  end
end

function Squad:RefreshMummyDetails()
  local mummyEffDown, mummyBoss, mummyGroup, mummyEffSand = WorldSimpleModeUtils.ShowMummyMembers()
  self:RefreshMummyEffectDown(mummyEffDown)
  self:RefreshMummyBoss(mummyBoss)
  self:RefreshMummyGroup(mummyGroup)
  self:RefreshMummyEffSand(mummyEffSand)
end

function Squad:RefreshMummyMembers()
  if self.heroes == nil then
    return
  end
  if not self.isMummyMarch then
    self:ClearMummy()
    return
  end
  if self.season_mummy_member == nil then
    local effectPath = "Assets/Main/SeasonRes/Shared/Prefabs/Soldier/Mummy_march.prefab"
    self.season_mummy_member = UIAsyncNode.New("season_mummy_member", self.transform, effectPath, function(go)
      local battleMgr = self.battleMgr
      if IsNotNull(go) and battleMgr ~= nil then
        local _t = go.transform
        _t:Set_localPosition(0, 0, 0)
        _t:Set_localScale(2.5, 2.5, 2.5)
        self.nodeMummyEffectDown = _t:Find("EffectDown")
        self.nodeSoldierGroup = _t:Find("SoldierGroup")
        self.nodeEffectSand = _t:Find("EffectSand")
        self.nodeBossRoot = _t:Find("BossRoot")
        self:RefreshMummyDetails()
        self:OnCreateFinish()
      end
    end)
  else
    self:RefreshMummyDetails()
  end
end

function Squad:CreateMembers()
  if self.heroes == nil then
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

function Squad:CreateTacWeaponMembers()
  if self.tacWeaponInfo == nil then
    self:OnCreateWeaponFinish()
    return
  end
  local appearanceId = self.tacWeaponAppearanceId
  if appearanceId == nil then
    appearanceId = self.tacWeaponInfo:GetAppearance()
  end
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  if not appearanceMeta then
    self:OnCreateWeaponFinish()
    Logger.LogError("tacWeapon appearanceMeta is nil")
    return
  end
  local objId = self.battleMgr:GetNextObjId()
  local member
  member = ObjectPool:GetInstance():Load(WorldDrone)
  member:Init(self.battleMgr, self, objId, nil, self.tacWeaponInfo, appearanceMeta)
  table.insert(self.tacWeaponMembers, member)
  self.battleMgr:AddUnit(member)
  self:OnCreateWeaponFinish()
end

function Squad:CheckCreateFinish()
  if self.createdMember >= #self.members + #self.tacWeaponMembers then
    if self.scaleCtrl then
      self.transform:Set_localScale(self.scaleCtrl, self.scaleCtrl, self.scaleCtrl)
    end
    if self.animNameCache then
      self:PlayAnim(self.animNameCache, self.rewindCache)
    end
  end
end

function Squad:UpdateDisplayMode()
  if self.members then
    for _, v in pairs(self.members) do
      v:UpdateDisplayMode()
    end
  end
  if self.tacWeaponMembers then
    for _, v in pairs(self.tacWeaponMembers) do
      v:UpdateDisplayMode()
    end
  end
  if self.season_mummy_member then
    self:RefreshMummyMembers()
  end
  if self.collider then
    local enableCollider = DisplaySettings.TroopCanClicked()
    if self.enableCollider ~= enableCollider then
      self.collider.enabled = enableCollider
      self.enableCollider = enableCollider
    end
  end
end

function Squad:OnCreateFinish()
  self.createdMember = self.createdMember + 1
  self:CheckCreateFinish()
end

function Squad:OnCreateWeaponFinish()
  self.createdMember = self.createdMember + 1
  self:CheckCreateFinish()
end

function Squad:SetRotation(quat)
  self.transform.rotation = quat
end

function Squad:PlayAnim(anim, rewind)
  if self.members then
    for _, v in pairs(self.members) do
      v:PlayAnim(anim, rewind)
    end
  end
  if self.tacWeaponMembers then
    for _, v in pairs(self.tacWeaponMembers) do
      v:PlayAnim(anim, rewind)
    end
  end
  self.animNameCache = anim
  self.rewindCache = rewind
end

function Squad:Attack(targetPos, index)
  if self.members then
    for _, v in pairs(self.members) do
      v:Attack(targetPos, index)
    end
  end
  if self.tacWeaponMembers then
    for _, v in pairs(self.tacWeaponMembers) do
      v:Attack(targetPos, index)
    end
  end
end

function Squad:SetPosition(pos)
  self.cur_pos.x = pos.x
  self.cur_pos.z = pos.z
  self.transform.position = self.cur_pos
end

function Squad:GetPosition()
  return self.cur_pos
end

function Squad:GetMemberTotalCount()
  return table.count(self.heroes)
end

function Squad:OnUpdate()
  if self.members then
    for _, v in pairs(self.members) do
      v:OnUpdate()
    end
  end
  if self.tacWeaponMembers then
    for _, v in pairs(self.tacWeaponMembers) do
      v:OnUpdate()
    end
  end
end

function Squad:AddDelayEvent(event, delay)
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function Squad:SetOnFire(value)
  if self.members then
    for _, v in pairs(self.members) do
      v:SetOnFire(value)
    end
  end
end

function Squad:UpdateMiscRenderers()
  if self.marchUuid and DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle() then
    local marchInfo = CS.SceneManager.World:GetMarch(self.marchUuid)
    if marchInfo then
      local crystalCount = marchInfo.crystal
      local nucleusCount = marchInfo.nucleus
      if 0 < crystalCount or 0 < nucleusCount then
        self:ShowMeteoriteCount(crystalCount, nucleusCount)
      else
        self:DestroyMeteoriteNode()
      end
    else
      self:DestroyMeteoriteNode()
    end
  end
end

function Squad:ShowMeteoriteCount(crystal, nucleus)
  if self.meteorite then
    if self.meteorite.comp then
      self.meteorite.comp:Refresh(crystal, nucleus)
    end
  else
    self.meteorite = {}
    self.meteorite.req = Resource:InstantiateAsync(meteoritePerfabPatch)
    self.meteorite.req:completed("+", function(req)
      if req.isError then
        return
      end
      local tran = req.gameObject.transform
      tran:SetParent(self.transform)
      tran.localPosition = Vector3.New(0, 0, 0)
      self.meteorite.comp = tran:GetComponent(CsMeteorite)
      self:ShowMeteoriteCount(crystal, nucleus)
    end)
  end
end

function Squad:DestroyMeteoriteNode()
  if self.meteorite then
    if self.meteorite.req then
      self.meteorite.req:Destroy()
    end
    self.meteorite = nil
  end
end

function Squad:RefreshMummyMarchSkin(isMummyMarch)
  if isMummyMarch ~= self.isMummyMarch then
    if self.members then
      for _, v in pairs(self.members) do
        self.battleMgr:RemoveUnitTotal(v)
      end
    end
    self.members = {}
    if isMummyMarch then
      self:RefreshMummyMembers()
    else
      self:ClearMummy()
      self:CreateMembers()
    end
    for _, v in pairs(self.members) do
      v:UpdateDisplayMode()
    end
  end
  self.isMummyMarch = isMummyMarch
end

function Squad:UpdateLod(lod)
  self.lod = lod
  self:RefreshMummyMembers()
end

return Squad
