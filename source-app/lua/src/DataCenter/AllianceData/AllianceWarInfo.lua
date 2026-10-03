local AllianceWarInfo = BaseClass("AllianceWarInfo")

local function __init(self)
  self.uuid = ""
  self.type = 0
  self.worldId = 0
  self.worldType = 0
  self.attackPointId = 0
  self.attackUid = ""
  self.attackName = ""
  self.attackIcon = ""
  self.attackAllianceId = ""
  self.attackAllianceAbbr = ""
  self.targetPointId = 0
  self.targetUid = ""
  self.targetName = ""
  self.targetIcon = ""
  self.targetIconVer = 0
  self.monthCardEndTime = 0
  self.targetAllianceId = ""
  self.targetAllianceAbbr = ""
  self.targetContentId = 0
  self.createTime = 0
  self.waitTime = 0
  self.marchTime = 0
  self.currentSoldiers = 0
  self.maxSoldiers = 0
  self.assemblyMarchMax = 0
  self.memberList = {}
  self.leaderMarch = nil
  self.waitMemberTime = 0
  self.server = 0
  self.srcServer = 0
  self.headSkinId = 0
  self.headSkinET = 0
  self.bossHp = nil
  self.updateTime = 0
  self.targetBaseSkinId = 0
  self.targetLevel = 0
end

local function __delete(self)
  self.uuid = nil
  self.type = nil
  self.worldId = nil
  self.worldType = nil
  self.attackPointId = nil
  self.attackUid = nil
  self.attackName = nil
  self.attackIcon = nil
  self.attackAllianceId = nil
  self.attackAllianceAbbr = nil
  self.targetPointId = nil
  self.targetUid = nil
  self.targetName = nil
  self.targetIcon = nil
  self.targetIconVer = nil
  self.targetAllianceId = nil
  self.targetAllianceAbbr = nil
  self.targetContentId = nil
  self.createTime = nil
  self.waitTime = nil
  self.marchTime = nil
  self.currentSoldiers = nil
  self.maxSoldiers = nil
  self.assemblyMarchMax = nil
  self.memberList = nil
  self.leaderMarch = nil
  self.waitMemberTime = nil
  self.monthCardEndTime = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.bossHp = nil
  self.updateTime = 0
  self.targetBaseSkinId = 0
  self.targetLevel = 0
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.worldId ~= nil then
    self.worldId = message.worldId
  end
  if message.worldType ~= nil then
    self.worldType = message.worldType
  end
  if message.attackPointId ~= nil then
    self.attackPointId = message.attackPointId
  end
  if message.attackUid ~= nil then
    self.attackUid = message.attackUid
  end
  if message.attackName ~= nil then
    self.attackName = message.attackName
  end
  if message.attackIcon ~= nil then
    self.attackIcon = message.attackIcon
  end
  if message.attackAllianceId ~= nil then
    self.attackAllianceId = message.attackAllianceId
  end
  if message.attackAllianceAbbr ~= nil then
    self.attackAllianceAbbr = message.attackAllianceAbbr
  end
  if message.targetUuid ~= nil then
    self.targetUuid = message.targetUuid
  end
  if message.targetPointId ~= nil then
    self.targetPointId = message.targetPointId
  end
  if message.targetUid ~= nil then
    self.targetUid = message.targetUid
  end
  if message.targetName ~= nil then
    self.targetName = message.targetName
  end
  if message.targetIcon ~= nil then
    self.targetIcon = message.targetIcon
  end
  if message.targetIconVer ~= nil then
    self.targetIconVer = message.targetIconVer
  end
  if message.targetAAbbr ~= nil then
    self.targetAllianceAbbr = message.targetAAbbr
  end
  if message.targetAId ~= nil then
    self.targetAllianceId = message.targetAId
  end
  if message.targetContentId ~= nil then
    self.targetContentId = message.targetContentId
  end
  if message.currSoldiers ~= nil then
    self.currentSoldiers = message.currSoldiers
  end
  if message.maxSoldiers ~= nil then
    self.maxSoldiers = message.maxSoldiers
  end
  if message.assemblyMarchMax ~= nil then
    self.assemblyMarchMax = message.assemblyMarchMax
  end
  if message.createTime ~= nil then
    self.createTime = message.createTime
  end
  if message.waitTime ~= nil then
    self.waitTime = message.waitTime
  end
  if message.marchTime ~= nil then
    self.marchTime = message.marchTime
  end
  if message.waitMemberTime ~= nil then
    self.waitMemberTime = message.waitMemberTime
  end
  if message.leaderMarch ~= nil then
    local data = AllianceWarLeaderData.New()
    data:ParseData(message.leaderMarch)
    self.leaderMarch = data
  end
  if message.targetMonthCardEndTime then
    self.monthCardEndTime = message.targetMonthCardEndTime
  end
  if message.server then
    self.server = message.server
  end
  if message.srcServer then
    self.srcServer = message.srcServer
  end
  if message.members ~= nil then
    self.memberList = {}
    local list = message.members
    table.walk(list, function(k, v)
      local data = AllianceWarMemberData.New()
      data:ParseData(v)
      if data.uuid ~= nil and data.uuid ~= "" then
        self.memberList[data.uuid] = data
      end
    end)
  end
  if message.headSkinId then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET then
    self.headSkinET = message.headSkinET
  end
  if message.leaderRank then
    self.leaderRank = message.leaderRank
  end
  if message.leaderOffical then
    self.leaderOffical = message.leaderOffical
  end
  if message.running_hp then
    self.bossHp = message.running_hp
  else
    self.bossHp = nil
  end
  if message.targetBaseSkinId then
    self.targetBaseSkinId = message.targetBaseSkinId
  end
  if message.targetLevel then
    self.targetLevel = message.targetLevel
  end
  if message.fixedSoldierType then
    self.fixedSoldierType = message.fixedSoldierType
  end
  if message.teamHasLight then
    self.teamHasLight = message.teamHasLight
  else
    self.teamHasLight = false
  end
  self.updateTime = UITimeManager:GetInstance():GetServerTime()
end

function AllianceWarInfo:IsMummyMarch()
  return self.fixedSoldierType == SoldierType.Mummy
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

local function AlreadyGo(self)
  if self.leaderMarch and (self.leaderMarch.status == 1 or self.leaderMarch.status == 4) then
    return true
  end
  if self.leaderMarch and self.leaderMarch.teamUuid ~= 0 then
    local marchData = DataCenter.WorldMarchDataManager:GetMarch(self.leaderMarch.teamUuid)
    if marchData ~= nil and marchData.teamUuid == self.leaderMarch.teamUuid then
      return true
    end
  end
  return false
end

function AllianceWarInfo:IsTargetForCityGhost()
  if self.isCityGhost == nil then
    local monsterId = self.targetUid
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if monster ~= nil then
      self.isCityGhost = monster.special == WorldMonsterSpecialType.CityGhostBoss
    else
      self.isCityGhost = false
    end
  end
  return self.isCityGhost
end

function AllianceWarInfo:TryJumpToTarget(need_guide)
  if self.targetPointId and self.server then
    local worldPointPos = SceneUtils.TileIndexToWorld(toInt(self.targetPointId), ForceChangeScene.World)
    SceneUtils.ChangeToWorld(function()
      GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2, nil, toInt(self.server), 0)
      TimerManager:GetInstance():DelayInvoke(function()
        local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
        local param = {}
        param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
        param.arrowType = ArrowType.Building
        param.positionType = PositionType.Screen
        param.isPanel = false
        param.isAutoClose = 2
        DataCenter.ArrowManager:ShowArrow(param)
      end, 0.5)
    end)
  end
end

AllianceWarInfo.__init = __init
AllianceWarInfo.__delete = __delete
AllianceWarInfo.ParseData = ParseData
AllianceWarInfo.GetHeadBgImg = GetHeadBgImg
AllianceWarInfo.AlreadyGo = AlreadyGo
return AllianceWarInfo
