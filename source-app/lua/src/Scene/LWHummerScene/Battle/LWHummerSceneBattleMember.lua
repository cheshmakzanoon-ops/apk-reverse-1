local Resource = CS.GameEntry.Resource
local FSM = require("Framework.Common.FSM")
local Const = require("Scene.LWBattle.Const")
local MemberStateStay = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateStay")
local MemberStateMove = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateMove")
local MemberStateDie = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateDie")
local MemberUpStateNoAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateNoAttack")
local MemberUpStateAutoAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
local MemberUpStateStationAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateStationAttack")
local MemberEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_ring_blue.prefab"
local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")
local LWHummerSceneBattleMember = BaseClass("LWHummerSceneBattleMember", base)

function LWHummerSceneBattleMember:Init(battleManager, guid, req, index, heroData)
  base.Init(self, battleManager, guid, heroData.meta)
  self.battleMgr = battleManager
  self.m_req = req
  self.guid = guid
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.fsm = nil
  self.upFsm = nil
  self.gameObject = nil
  self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 20)
  self.index = index
  self.heroData = heroData
  self.hero = nil
  self:InitHeroData()
  self.timeCount = 0
  self.curWorldPos = Vector3.zero
end

function LWHummerSceneBattleMember:DestroyView()
  base.DestroyView(self)
  if self.transform then
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end
  if self.cannon then
    self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.cannon = nil
  end
  self.gameObject = nil
  self.transform = nil
  if self.m_req ~= nil then
    self.m_req:Destroy()
    self.m_req = nil
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.upFsm then
    self.upFsm:Delete()
    self.upFsm = nil
  end
  if self.effReq ~= nil then
    self.effReq:Destroy()
    self.effReq = nil
  end
  self.firePoint = nil
end

function LWHummerSceneBattleMember:DestroyData()
  base.DestroyData(self)
  self.hero = nil
end

function LWHummerSceneBattleMember:OnCreate()
  if self.m_req ~= nil then
    self.gameObject = self.m_req.gameObject
    self.transform = self.gameObject.transform
  end
  local offset = Vector3.zero
  self:SetLocalPosition(offset)
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.curBlood = self.hero:GetMaxHp()
  self.maxBlood = self.curBlood
  self:ComponentDefine()
  self:InitFSM()
end

function LWHummerSceneBattleMember:InitHeroData()
  self.hero = nil
  self.hero = self.heroData
  if self.hero then
    self.meta = self.hero.meta
    self.isHuman = self.meta.is_human
    self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
    local skills = self.hero:GetAllUnlockSkills()
    for _, skillInfo in pairs(skills) do
      if skillInfo.skillTemplateData == nil then
        Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. skillInfo.id)
      end
      self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo)
    end
  end
end

function LWHummerSceneBattleMember:GetRawProperty(type)
  return self.hero:GetHeroProperty(type)
end

function LWHummerSceneBattleMember:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(MemberState.Stay, MemberStateStay.New(self))
  self.fsm:AddState(MemberState.Move, MemberStateMove.New(self))
  self.fsm:AddState(MemberState.Dead, MemberStateDie.New(self))
  self.fsm:ChangeState(MemberState.Stay)
  self.upFsm = FSM.New()
  self.upFsm:AddState(AttackState.AutoAttack, MemberUpStateAutoAttack.New(self))
  self.upFsm:AddState(AttackState.StationAttack, MemberUpStateStationAttack.New(self))
  self.upFsm:AddState(AttackState.HoldFire, MemberUpStateNoAttack.New(self))
  self.upFsm:ChangeState(AttackState.HoldFire)
end

function LWHummerSceneBattleMember:HandleInput(command, param)
  if command == MemberCommand.Move then
    self.fsm:ChangeState(MemberState.Move, param)
  elseif command == MemberCommand.Stay then
    self.fsm:ChangeState(MemberState.Stay, param)
  elseif command == MemberCommand.AutoAttack then
    self.upFsm:ChangeState(AttackState.AutoAttack, param)
  elseif command == MemberCommand.StationAttack then
    self.upFsm:ChangeState(AttackState.StationAttack, param)
  end
end

function LWHummerSceneBattleMember:ComponentDefine()
  base.ComponentDefine(self)
  self.collider.gameObject.layer = LayerMask.NameToLayer("Member")
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
  local appearanceMeta = self.hero.appearanceMeta
  local size = self.battleMgr.logic.data:GetBattleMemberScale()
  self.transform:Set_localScale(size, size, size)
  local fire_paths = appearanceMeta.fire_paths
  self.firePoints = {}
  for i = 1, #fire_paths do
    local fire_path = fire_paths[i]
    local firePoint = self.transform:Find(fire_path)
    if not firePoint or string.IsNullOrEmpty(fire_path) then
      Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. fire_path)
    end
    table.insert(self.firePoints, firePoint)
  end
  self.firePoint = self.firePoints[1]
  if self.isHuman then
    self.cannon = self.transform
  else
    local canon_path = appearanceMeta.canon_path
    self.cannon = self.transform:Find(canon_path)
    if not self.cannon then
      self.cannon = self.transform
      Logger.LogError("\231\130\174\229\143\176\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\230\179\168\230\132\143\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\231\130\174\229\143\176\232\183\175\229\190\132\239\188\154" .. canon_path)
    else
      self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    local canonFix = appearanceMeta.canon_rotation
    if canonFix and #canonFix == 3 then
      self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
    end
  end
  self.angular_speed_deg = self.meta.angular_speed * 60
  self.buffPoints = {}
  if not table.IsNullOrEmpty(appearanceMeta.buff_path) then
    for i = 1, #appearanceMeta.buff_path do
      if string.IsNullOrEmpty(appearanceMeta.buff_path[i]) then
        self.buffPoints[i] = nil
      else
        local buffPoint = self.transform:Find(appearanceMeta.buff_path[i])
        if IsNull(buffPoint) then
          Logger.LogError("buff\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. appearanceMeta.id .. "\239\188\140buff\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.buff_path[i])
        end
        self.buffPoints[i] = buffPoint
      end
    end
  end
  self.uiPoint = nil
  if not string.IsNullOrEmpty(appearanceMeta.ui_path) then
    self.uiPoint = self.transform:Find(appearanceMeta.ui_path)
    if not self.uiPoint then
      Logger.LogError("\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.ui_path)
    end
  end
  local effectParentTransform = self.uiPoint ~= nil and self.uiPoint or self.transform
  self.effReq = Resource:InstantiateAsync(MemberEffect)
  self.effReq:completed("+", function(effreq)
    if not (self.battleMgr and self.battleMgr.logic) or not self.battleMgr.logic.inLogic then
      effreq:Destroy()
      return
    end
    local effGo = effreq.gameObject
    effGo.transform:SetParent(effectParentTransform)
    effGo.transform:Set_localPosition(0, 0, 0)
  end)
end

function LWHummerSceneBattleMember:SetLocalPosition(pos)
  self.transform.localPosition = pos
end

function LWHummerSceneBattleMember:GetTransform()
  return self.transform
end

function LWHummerSceneBattleMember:GetCannonTransform()
  return self.cannon
end

function LWHummerSceneBattleMember:GetGameObject()
  return self.gameObject
end

function LWHummerSceneBattleMember:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate()
  end
  if self.upFsm then
    self.upFsm:OnUpdate()
  end
end

function LWHummerSceneBattleMember:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  EventManager:GetInstance():Broadcast(EventId.MemberBeAttack, {
    index = self.index,
    hp = self.curBlood / self.maxBlood
  })
  if self.curBlood <= 0 then
    self.fsm:ChangeState(MemberState.Dead)
    self.upFsm:ChangeState(AttackState.HoldFire)
  end
end

function LWHummerSceneBattleMember:CheckEnemyInAlertRange()
  return self.battleMgr and PveUtil.CheckHasUnitInSphereRange(self.battleMgr, self.transform.position, Const.MEMBER_ALERT_RADIUS, LayerMask.GetMask("Zombie"), nil, 1)
end

function LWHummerSceneBattleMember:GetCurBlood()
  return self.curBlood
end

function LWHummerSceneBattleMember:SetWeaponActive(active)
end

function LWHummerSceneBattleMember:GetFirePoint()
  return self.firePoint
end

function LWHummerSceneBattleMember:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id]
  end
  return self:GetFirePoint()
end

function LWHummerSceneBattleMember:GetMoveSpeed()
  return self.meta.speed_battle
end

function LWHummerSceneBattleMember:IsMoving()
  return self.fsm and self.fsm:GetStateIndex() == MemberState.Move
end

function LWHummerSceneBattleMember:GetUnitPositionInTeam()
  return DataCenter.PreviewSkillEffectManager.centerPointPos
end

function LWHummerSceneBattleMember:GetTeamZeroWorldPos()
  return DataCenter.PreviewSkillEffectManager.centerPointPos
end

function LWHummerSceneBattleMember:OnBeforExit()
  if self.transform then
    self.transform.parent = nil
  end
end

return LWHummerSceneBattleMember
