local ActEpidemicZoneBattleInfo = BaseClass("ActEpidemicZoneBattleInfo")

function ActEpidemicZoneBattleInfo:__init()
  self:ResetData()
end

function ActEpidemicZoneBattleInfo:__delete()
  self:ResetData()
end

function ActEpidemicZoneBattleInfo:ResetData()
  self.speedCount = 0
  self.speedMaxCount = 0
  self.speedCdTime = 0
  self.cureCdTime = 0
  self.skillCdTime = 0
  self.activeStartTime = 0
  self.activeEndTime = 0
  self.skillId = 0
  self.skillPoint = 0
  self.vsInfo = {}
  self.buildInfo = {}
  self.playerInfo = {}
  self.allianceMemberList = {}
  self.durationRecover = 0
  self.durationDamage = 0
  self.troopDamage = 0
  self.troopHeal = 0
  self.arbiterBrokenCount = 0
  self.arbiterUid = ""
  self.arbiterSkillEndTime = 0
end

function ActEpidemicZoneBattleInfo:ParseData(t)
  if t.cureCdTime then
    self.cureCdTime = t.cureCdTime
  end
  self:ParseSkillInfo(t.currSkillInfo)
  if t.vsInfo then
    self.vsInfo = {}
    for _, v in pairs(t.vsInfo) do
      self:ParseVsInfo(v)
    end
  end
  if t.buildInfo then
    self.buildInfo = {}
    for _, v in pairs(t.buildInfo) do
      self:ParseBuildInfo(v)
    end
  end
  self:ParseArbiterSkillState(t.arbiterUid, t.arbiterSkillEndTime)
end

function ActEpidemicZoneBattleInfo:ParseSkillInfo(t)
  if t == nil then
    return
  end
  if t.cdEndTime then
    self.skillCdTime = t.cdEndTime
  end
  if t.skillId then
    self.skillId = t.skillId
  end
  if t.skillPoint then
    self.skillPoint = t.skillPoint
  end
  if t.activeStartTime then
    self.activeStartTime = t.activeStartTime
  end
  if t.activeEndTime then
    self.activeEndTime = t.activeEndTime
  end
  if t.durationRecover then
    self.durationRecover = t.durationRecover
  end
  if t.durationDamage then
    self.durationDamage = t.durationDamage
  end
  if t.troopDamage then
    self.troopDamage = t.troopDamage
  end
  if t.troopHeal then
    self.troopHeal = t.troopHeal
  end
  if t.arbiterBrokenCount then
    self.arbiterBrokenCount = t.arbiterBrokenCount
  end
end

function ActEpidemicZoneBattleInfo:ParseVsInfo(t)
  self.vsInfo[t.role] = {
    role = t.role,
    count = t.count,
    score = t.score,
    speed = t.speed
  }
end

function ActEpidemicZoneBattleInfo:GetVsInfo(role)
  return self.vsInfo[role]
end

function ActEpidemicZoneBattleInfo:ParseBuildInfo(t)
  self.buildInfo[t.buildUUID] = {
    buildUUID = t.buildUUID,
    marchUUID = t.marchUUID,
    allianceId = t.allianceId,
    curHp = t.curHp,
    totalHp = t.totalHp
  }
end

function ActEpidemicZoneBattleInfo:GetBuildInfo(buildUUID)
  return self.buildInfo[buildUUID]
end

local function DealEffects(destDic, srcDic)
  if srcDic and destDic then
    for _, v in pairs(srcDic) do
      local id = tostring(v.lordEffectId)
      local newV = v.lordEffectVal
      local value = destDic[id] or 0
      destDic[id] = value + newV
    end
  end
end

function ActEpidemicZoneBattleInfo:ParseEffects(t)
  local effList = {}
  local effDic = {}
  local actMgr = DataCenter.ActEpidemicZoneManager
  local bfType = BattleFieldType.EpidemicZone
  local roleInfo = actMgr:GetCurRoleInfo()
  local tInsert = table.insert
  if roleInfo and roleInfo.skills then
    for _, id in pairs(roleInfo.skills) do
      local template = actMgr:GetTemplateSkillById(id)
      for _, type in pairs(template.types) do
        if type == 1 or type == 2 then
          tInsert(effList, {
            id = id,
            bfType = bfType,
            template = template
          })
          DealEffects(effDic, template.effects)
        end
      end
    end
  end
  local buff = t.buff
  if not table.IsNullOrEmpty(buff) then
    for _, v in pairs(buff) do
      local template = actMgr:GetTemplateBuffById(v.id)
      tInsert(effList, {
        id = v.id,
        expireTime = v.expireTime,
        bfType = bfType,
        template = template
      })
      DealEffects(effDic, template.effects)
    end
  end
  return effList, effDic
end

function ActEpidemicZoneBattleInfo:ParsePlayerInfo(t, role)
  local tb = self.playerInfo[role] or {}
  table.insert(tb, t)
  self.playerInfo[role] = tb
end

function ActEpidemicZoneBattleInfo:UpdateAllianceMemberList(allianceId, memberList)
  if memberList ~= nil then
    local theMemberList = {}
    table.walk(memberList, function(k, v)
      local member = AllianceMemberInfo.New()
      member:ParseData(v)
      if member.uid ~= nil and member.uid ~= "" then
        theMemberList[member.uid] = member
      end
    end)
    self.allianceMemberList[allianceId] = theMemberList
  end
end

function ActEpidemicZoneBattleInfo:GetAlMemberByPlayerUid(uid)
  for alId, list in pairs(self.allianceMemberList) do
    if list[uid] then
      return alId, list[uid]
    end
  end
end

function ActEpidemicZoneBattleInfo:ParseArbiterSkillState(uid, endTime)
  self.arbiterUid = uid
  if endTime ~= nil then
    self.arbiterSkillEndTime = endTime
  end
  if not string.IsNullOrEmpty(uid) then
    local theWorld = CS.SceneManager.World
    if theWorld == nil or not CS.SceneManager:IsInWorld() then
      return nil
    end
    local cityList = theWorld:GetAllMainBaseList()
    if cityList == nil then
      return nil
    end
    for _, v in pairs(cityList) do
      if v.ownerUid == uid then
        CityDomeProtectEffectManager:GetInstance():CheckShowEffect(v.uuid)
        break
      end
    end
  end
end

return ActEpidemicZoneBattleInfo
