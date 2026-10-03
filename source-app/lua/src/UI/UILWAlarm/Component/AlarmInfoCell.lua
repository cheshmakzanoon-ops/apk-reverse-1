local AlarmInfoCell = BaseClass("AlarmInfoCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

local function GetBaseInfoFromMarchData(march)
  local marchType = march:GetMarchType()
  if marchType == NewMarchType.RUNNING_BOSS or marchType == NewMarchType.SANDFISH or marchType == NewMarchType.DARKNESS_MONSTER or marchType == NewMarchType.ALLIANCE_BOSS_SAND then
    local monsterId = march.monsterId
    local meta = DataCenter.MonsterTemplateManager:TryGetMonsterTemplate(monsterId)
    if meta then
      local name = Localization:GetString(meta.name)
      local level = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, meta.level)
      return {
        ownerName = level .. " " .. name,
        pic = LoadPath.HeroIconsSmallPath .. meta.pic
      }
    end
  elseif marchType == NewMarchType.RUNNING_MUMMY or marchType == NewMarchType.MUMMY then
    local meta = DataCenter.MonsterTemplateManager:TryGetMonsterTemplate(march.monsterId)
    if meta then
      local name = Localization:GetString(meta.name, march.ownerName)
      local level = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, meta.level)
      return {
        ownerName = level .. " " .. name,
        pic = LoadPath.HeroIconsSmallPath .. meta.pic
      }
    end
  elseif marchType == NewMarchType.ZOMBIE_RUSH then
    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(march.allianceBuildingCfgId)
    if template then
      local nameStr = Localization:GetString(template.name, template.level)
      return {
        ownerName = nameStr,
        pic = string.format(LoadPath.UIAlliance, template.icon)
      }
    end
  end
  return {
    ownerName = march.ownerName,
    pic = march.pic
  }
end

function AlarmInfoCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AlarmInfoCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AlarmInfoCell:OnEnable()
  base.OnEnable(self)
end

function AlarmInfoCell:OnDisable()
  base.OnDisable(self)
end

local zombie_rush_tips_text_path = "Top/ZombieRushTipsText"

function AlarmInfoCell:ComponentDefine()
  self.playerHerd = self:AddComponent(UICommonHead, "Top/UIPlayerHead")
  self.title = self:AddComponent(UIText, "Top/title")
  self.typeIcon = self:AddComponent(UIImage, "Top/typeIcon")
  self.startPosText = self:AddComponent(UIText, "Top/Pos/startPos")
  self.startPosBtn = self:AddComponent(UIButton, "Top/Pos/startPos")
  self.curPosText = self:AddComponent(UIText, "Top/Pos/endPos")
  self.curPosBtn = self:AddComponent(UIButton, "Top/Pos/endPos")
  self.timeText = self:AddComponent(UIText, "Top/Slider/Text")
  self.timeSlider = self:AddComponent(UISlider, "Top/Slider")
  self.sliderIcon = self:AddComponent(UIImage, "Top/Slider/Fill Area/Fill")
  self.assistanceText = self:AddComponent(UIText, "Top/assistanceText")
  self.btnGoHome = self:AddComponent(UIButton, "Top/title/btnGoHome")
  self.heroContent = self:AddComponent(UIBaseContainer, "HeroContent")
  self.heroCellContainers = {}
  self.heroSlots = {}
  for i = 1, 6 do
    local path = string.format("HeroContent/ScrollRect/Viewport/heros/Hero%s", i)
    local heroCell = self:AddComponent(UIBaseContainer, path)
    self.heroCellContainers[i] = heroCell
    local heroSlot = self:AddComponent(UIImage, string.format("HeroContent/ScrollRect/Viewport/heros/Hero%s/slot%s", i, i))
    self.heroSlots[i] = heroSlot
  end
  self.rallyPlayer = self:AddComponent(UIBaseContainer, "RallyPlayer")
  self.rallyPlayerContent = self:AddComponent(UIBaseContainer, "RallyPlayer/ScrollRect/Viewport/Players")
  if not IsNull(self.transform:Find(zombie_rush_tips_text_path)) then
    self.zombie_rush_tips_text = self:AddComponent(UITextMeshProUGUIEx, zombie_rush_tips_text_path)
    self.zombie_rush_tips_text:SetActive(false)
  end
  self.curPosBtn:SetOnClick(function()
    self:CurPosClick()
  end)
  self.startPosBtn:SetOnClick(function()
    self:StartPosClick()
  end)
  
  function self.timerAction()
    self:OnTimer()
  end
  
  self.btnGoHome:SetOnClick(function()
    self:TeamFallback()
  end)
  self.btnGoHome:SetActive(false)
end

function AlarmInfoCell:OnTimer()
  if not self.param then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.param.startTime - curTime <= 0 or curTime < self.param.endTime then
    if self.param:GetMarchStatus() == MarchStatus.ZOMBIE_RUSH_WAITING then
      local alreadyTime = curTime - self.param.startTime
      local progressValue = 0
      local stateStr = ""
      if alreadyTime < self.waitingTime then
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.waitingTime - alreadyTime))
        progressValue = alreadyTime / self.waitingTime
        stateStr = Localization:GetString("zombieRush_state_01")
      else
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.param.endTime - curTime))
        progressValue = (alreadyTime - self.waitingTime) / (self.param.endTime - self.param.startTime - self.waitingTime)
        stateStr = Localization:GetString("zombieRush_state_03")
      end
      self.timeSlider:SetValue(progressValue)
      if self.zombie_rush_tips_text then
        self.zombie_rush_tips_text:SetLocalText("zombieRush_tips_25", self.param.zombieRushRound, self.zombieRushMaxRound, stateStr)
      end
    else
      self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.param.endTime - curTime))
      local dur = (curTime - self.param.startTime) / (self.param.endTime - self.param.startTime)
      self.timeSlider:SetValue(dur)
      if self.param:GetMarchType() == NewMarchType.ZOMBIE_RUSH and self.zombie_rush_tips_text then
        self.zombie_rush_tips_text:SetLocalText("zombieRush_tips_25", self.param.zombieRushRound, self.zombieRushMaxRound, Localization:GetString("zombieRush_state_02"))
      end
    end
  elseif 0 >= self.param.endTime - curTime and self.timer then
    self.timeSlider:SetValue(1)
    self.timer:Stop()
    self.timer = nil
  end
end

local function SetHeroData(item, heroData)
  if not item then
    return
  end
  if not heroData then
    item:SetActive(false)
    return
  end
  item:SetActive(true)
  local isDominator = heroData.dominatorInfo ~= nil
  if isDominator then
    item:InitWithConfigId(heroData.dominatorInfo.dominatorId, nil, nil, heroData.dominatorInfo.dominatorRank)
  else
    local rank = 0
    if heroData.heroRankLevel then
      rank = heroData.heroRankLevel
    end
    local weaponLevel = 0
    if heroData.weaponLevel then
      weaponLevel = heroData.weaponLevel
    end
    local awakenLv = 0
    if heroData.awakenLv then
      awakenLv = heroData.awakenLv
    end
    local skinId = 0
    if heroData.skinId then
      skinId = heroData.skinId
    end
    item:InitWithConfigId(heroData.heroId, nil, heroData.heroLevel, rank, weaponLevel, awakenLv, skinId)
  end
end

local function SetHeroCell(self, i, isDominator, heroData)
  if heroData == nil and isDominator then
    self.heroCellContainers[i]:SetActive(false)
  else
    self.heroCellContainers[i]:SetActive(true)
    if self.heroCells[i] then
      SetHeroData(self.heroCells[i], heroData)
    elseif heroData and not self.heroCellReqs[i] then
      local req = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/Alarm/UIAlarmHeroCellSmall.prefab", function(req)
        local obj = req.gameObject
        if IsNull(obj) then
          return
        end
        local container = self.heroCellContainers[i]
        if not IsNull(container) then
          obj.transform:SetParent(container.transform)
          obj.transform.localScale = Vector3.one
          obj.transform:Set_pivot(0.5, 0.5)
          obj.transform.localPosition = Vector3.zero
          local name = string.format("HeadCell%s", i)
          obj.name = name
          local heroCell = self:AddComponent(UIHeroCellSmall, string.format("HeroContent/ScrollRect/Viewport/heros/Hero%s/%s", i, name))
          SetHeroData(heroCell, heroData)
          self.heroCells[i] = heroCell
        end
      end)
      self.heroCellReqs[i] = req
    end
    if heroData then
      self.heroSlots[i]:SetEnable(false)
    else
      self.heroSlots[i]:SetEnable(true)
    end
  end
end

local function SetRallyHeads(self)
  local rallyData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.param.teamUuid)
  if rallyData then
    local memberList = table.values(rallyData.memberList)
    for i = 1, #memberList do
      local v = memberList[i]
      if v and not self.headCellReqs[i] then
        do
          local req = self:GameObjectInstantiateAsync(UIAssets.UIPlayerHead, function(req)
            local obj = req.gameObject
            if IsNull(obj) then
              return
            end
            local container = self.rallyPlayerContent
            if not IsNull(container) then
              obj.transform:SetParent(container.transform)
              obj.transform.localScale = Vector3.one
              obj.transform:Set_pivot(0.5, 0.5)
              obj.transform.localPosition = Vector3.zero
              obj.transform:Set_sizeDelta(100, 100)
              local name = string.format("HeadCell%s", i)
              obj.name = name
              local headCell = self.rallyPlayerContent:AddComponent(UICommonHead, name)
              local framePath = DataCenter.DecorationDataManager:GetHeadFrame(v.headSkinId, v.headSkinET)
              headCell:SetHead(v.ownerUid, v.ownerIcon, v.ownerIconVer, nil, framePath)
              headCell:SetEnableClickShowInfo(true, true)
              self.headCells[i] = headCell
            end
          end)
          self.headCellReqs[i] = req
        end
      end
    end
  end
end

function AlarmInfoCell:Update1000MS()
  if self.param and self.param.type == "OfficialSkill" and self.param.data and self.param.data.skill_flag == AlOfficialSkillType.GuardianTower then
    local now = UITimeManager:GetInstance():GetServerTime()
    local activeTime = toInt(self.param.data.activeTime)
    local onceActiveTime = 10000
    local during_time = 300000
    if self.param.nextActiveTime then
      onceActiveTime = toInt(self.param.onceActiveTime)
      activeTime = toInt(self.param.nextActiveTime)
      during_time = toInt(self.param.during_time)
      if now > activeTime and 0 < onceActiveTime and during_time >= now - activeTime then
        repeat
          activeTime = activeTime + onceActiveTime
        until now < activeTime
        self.param.nextActiveTime = activeTime
      end
    else
      local mgrSkill = DataCenter.AllianceGovernmentSkillManager
      local skill_cfg = mgrSkill:GetTemplatesById(self.param.data.skillId)
      if skill_cfg ~= nil and skill_cfg.skill_flag == AlOfficialSkillType.GuardianTower then
        onceActiveTime = math.max(toInt(skill_cfg.skill_para8) * 1000, 5000)
        during_time = toInt(skill_cfg.during_time) * 1000
        if now > activeTime and 0 < onceActiveTime and during_time >= now - activeTime then
          repeat
            activeTime = activeTime + onceActiveTime
          until now < activeTime
        else
          return
        end
        self.param.during_time = during_time
        self.param.onceActiveTime = onceActiveTime
        self.param.nextActiveTime = activeTime
      else
        return
      end
    end
    local NextTime = activeTime - now
    if 0 <= NextTime then
      self.timeText:SetLocalText("130076", math.ceil(NextTime / 1000))
      self.timeSlider:SetValue(NextTime / onceActiveTime)
    end
  end
end

function AlarmInfoCell:ReInit(param, openType)
  local inBattleField = BattleFieldUtil.InBattleField()
  local isInBigMap = SeasonUtil.InSeasonBigMapMode()
  self.openType = openType
  self.zombieRushMaxRound = 0
  if param and param.type == "OfficialSkill" then
    self.param = param
    self.timeSlider:SetActive(true)
    self.assistanceText:SetActive(false)
    self.btnGoHome:SetActive(false)
    self.playerHerd:UseSpecifiedRes("Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/Ambassador/mjc_guanzhijineng_icon_dianta.png")
    self.title:SetLocalText("alliance_government_10005_19")
    self.typeIcon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/Ambassador/mjc_zjmgongjiyujing_S4_dianta.png")
    self.sliderIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_youujian_jindutiao_3.png")
    self.curPosText:SetActive(false)
    self.timeText:SetActive(true)
    self.timeSlider:SetActive(true)
    if param and param.data and param.data.targetPointId and 0 < param.data.targetPointId then
      local tilePosFrom = SceneUtils.IndexToTilePos(param.data.targetPointId, ForceChangeScene.World)
      self.param.homePos = param.data.targetPointId
      self.startPosText:SetActive(true)
      self.startPosText:SetText(string.format("(x%s,y%s)", tilePosFrom.x, tilePosFrom.y))
    else
      self.startPosText:SetActive(false)
    end
    self:Update1000MS()
    return
  end
  self.param = param.march
  if self.param:GetMarchType() == NewMarchType.ZOMBIE_RUSH then
    self.waitingTime = DataCenter.LWZombieRushManager:GetWaitingTimeByRound(self.param.zombieRushRound)
    local template = DataCenter.LWZombieRushTemplateManager:GetTemplate(self.param.zombieRushId)
    if template ~= nil then
      self.zombieRushMaxRound = template:GetMaxRoundValue()
    end
  end
  local v3 = SceneUtils.IndexToTilePos(self.param.homePos, ForceChangeScene.World)
  local baseInfo = GetBaseInfoFromMarchData(self.param)
  local worldPos = self.param:GetMarchCurPos()
  local curPos = SceneUtils.WorldToTile(worldPos)
  local titleStr = UIUtil.FormatAllianceAndName(self.param.allianceAbbr, baseInfo.ownerName)
  local marchTargetType = self.param:GetMarchTargetType()
  if self.param:GetMarchStatus() == MarchStatus.ASSISTANCE and (marchTargetType == MarchTargetType.ASSISTANCE_CITY or marchTargetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY) then
    titleStr = string.format("<color=#54c4f2>%s</color>", titleStr)
    self.timeSlider:SetActive(false)
    self.assistanceText:SetActive(true)
  else
    self.timeSlider:SetActive(true)
    self.assistanceText:SetActive(false)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if 0 >= self.param.startTime - curTime or curTime < self.param.endTime then
      self:OnTimer()
      self.timer = TimerManager:GetInstance():GetTimer(1, self.timerAction, self, false, false, false)
      self.timer:Start()
    elseif 0 >= self.param.endTime - curTime then
      self.timeSlider:SetValue(1)
      return
    end
  end
  self.title:SetText(titleStr)
  if 0 < self.param.homePos then
    local fromServer = 0
    if not inBattleField and isInBigMap then
      fromServer = self.param.srcServer
    end
    if 0 < toInt(fromServer) then
      self.startPosText:SetText(string.format("#%s(x%s,y%s)", fromServer, math.modf(v3.x), math.modf(v3.y)))
    else
      self.startPosText:SetText(string.format("(x%s,y%s)", math.modf(v3.x), math.modf(v3.y)))
    end
  else
    self.startPosText:SetText("(x=?,y=?)")
  end
  local marchType = self.param:GetMarchType()
  if marchType == NewMarchType.ZOMBIE_RUSH then
    self.curPosText:SetActive(false)
    if self.zombie_rush_tips_text then
      self.zombie_rush_tips_text:SetActive(true)
    end
  else
    local theServerId = 0
    if not inBattleField and isInBigMap then
      if self.param.srcServer == self.param.targetServer then
        theServerId = self.param.srcServer or self.param.targetServer or 0
      else
        theServerId = DataCenter.SeasonDataManager:GetNinePalacesServerByWorldPos(worldPos)
      end
    end
    self.curPosText:SetActive(true)
    if 0 < toInt(theServerId) then
      self.curPosText:SetText(string.format("#%s(x%s,y%s)", theServerId, math.modf(curPos.x), math.modf(curPos.y)))
    else
      self.curPosText:SetText(string.format("(x%s,y%s)", math.modf(curPos.x), math.modf(curPos.y)))
    end
    if self.zombie_rush_tips_text then
      self.zombie_rush_tips_text:SetActive(false)
    end
  end
  local isAttackByMonster = false
  if marchType == NewMarchType.RUNNING_BOSS or marchType == NewMarchType.RUNNING_MUMMY or marchType == NewMarchType.MUMMY or marchType == NewMarchType.ZOMBIE_RUSH or marchType == NewMarchType.DARKNESS_MONSTER or marchType == NewMarchType.ALLIANCE_BOSS_SAND then
    isAttackByMonster = true
    self.playerHerd:SetData(nil, baseInfo.pic, self.param.picVer)
  elseif MarchUtil.IsWerewolf(self.param) then
    self.playerHerd:ShowWerewolf()
  else
    local framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.param.headSkinId, self.param.headSkinET)
    self.playerHerd:SetHead(self.param.ownerUid, self.param.pic, self.param.picVer, nil, framePath)
  end
  if self.param.IsMummyMarch and self.param:IsMummyMarch() then
    if marchType == NewMarchType.ASSEMBLY_MARCH then
      self.typeIcon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/ljq_s3_yujing_jijie_02.png")
    else
      self.typeIcon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/ljq_s3_yujing_jijie_01.png")
    end
  elseif self.param.teamUuid then
    local teamData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.param.teamUuid)
    if teamData and teamData.fixedSoldierType == SoldierType.Mummy then
      self.typeIcon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/ljq_s3_yujing_jijie_02.png")
    else
      self.typeIcon:LoadSprite(AlarmImagePatch[marchTargetType])
    end
  else
    self.typeIcon:LoadSprite(AlarmImagePatch[marchTargetType])
  end
  self.btnGoHome:SetActive(MarchTargetTypeShowTeamFallback[marchTargetType] or false)
  self.playerHerd:SetEnableClickShowInfo(not self.param.isAnonymity)
  if marchTargetType == MarchTargetType.ASSISTANCE_CITY or marchTargetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY then
    self.sliderIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_youujian_jindutiao_2.png")
  else
    self.sliderIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_youujian_jindutiao_3.png")
  end
  if self.param.isAnonymity then
    self.startPosText:SetText("(x=?,y=?)")
    self.curPosText:SetText("(x=?,y=?)")
    self.title:SetLocalText("season_mastery_173")
  end
  if LuaEntry.DataConfig:CheckSwitch("alarm_beta") then
    local isRally = self.param:GetMarchType() == NewMarchType.ASSEMBLY_MARCH
    local isScout = self.param:GetMarchType() == NewMarchType.SCOUT
    self.heroContent:SetActive(not isRally and not isScout and not isAttackByMonster)
    if not isRally and not isScout and not isAttackByMonster and 0 < self.param.armyInfos.Count then
      local armyInfo = self.param.armyInfos[0]
      if not armyInfo then
        return
      end
      local csHeroData = armyInfo.HeroInfos
      local setList = {}
      for i = 0, 5 do
        local isDominator = i == 5
        local data = i < csHeroData.Count and csHeroData[i] or nil
        if data and data.index then
          SetHeroCell(self, data.index, isDominator, data)
          setList[data.index] = true
        end
      end
      for i = 1, 6 do
        local isDominator = i == 6
        if not setList[i] then
          SetHeroCell(self, i, isDominator, nil)
        end
      end
    end
    self.rallyPlayer:SetActive(isRally)
    if isRally then
      SetRallyHeads(self)
    end
  end
end

function AlarmInfoCell:StartPosClick()
  if self.param.isAnonymity then
    UIUtil.ShowTipsId("season_mastery_174")
    return
  end
  if self.param.homePos == nil or self.param.homePos <= 0 then
    return
  end
  local openType = self.openType
  local worldId = self.param.worldId
  local srcServer = self.param.srcServer
  local serverId = self.param.serverId
  local pos = SceneUtils.TileIndexToWorld(self.param.homePos, ForceChangeScene.World)
  if self.view and self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
  if openType == AlarmUIOpenType.MainUI then
    GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, nil, function()
    end, srcServer, 0)
  elseif openType == AlarmUIOpenType.DesertBattleUI then
    GoToUtil.GotoDragonPos(pos, -1, nil, function()
    end, serverId, worldId)
  end
end

function AlarmInfoCell:CurPosClick()
  if self.param.isAnonymity then
    UIUtil.ShowTipsId("season_mastery_174")
    return
  end
  if self.openType == AlarmUIOpenType.MainUI then
    GoToUtil.GotoMarchCurPos(self.param, CS.SceneManager.World.InitZoom)
  elseif self.openType == AlarmUIOpenType.DesertBattleUI then
    GoToUtil.GotoDragonPos(self.param:GetMarchCurPos(), -1, nil, function()
    end, self.param.serverId, self.param.worldId)
  end
  if self.view and self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

function AlarmInfoCell:ComponentDestroy()
  self.playerHerd = nil
  self.title = nil
  self.typeIcon = nil
  self.startPosText = nil
  self.startPosBtn = nil
  self.curPosText = nil
  self.curPosBtn = nil
  self.zombie_rush_tips_text = nil
  self.heroCellContainers = nil
  self.heroSlots = nil
  if self.heroCellReqs then
    self:RemoveComponents(UIHeroCellSmall)
    for _, req in pairs(self.heroCellReqs) do
      self:GameObjectDestroy(req)
    end
    self.heroCellReqs = nil
    self.heroCells = nil
  end
  if self.headCellReqs then
    self.rallyPlayerContent:RemoveComponents(UICommonHead)
    for _, req in pairs(self.headCellReqs) do
      self:GameObjectDestroy(req)
    end
    self.headCellReqs = nil
    self.headCells = nil
  end
end

function AlarmInfoCell:DataDefine()
  self.param = {}
  self.waitingTime = 0
  self.heroCells = {}
  self.heroCellReqs = {}
  self.headCells = {}
  self.headCellReqs = {}
end

function AlarmInfoCell:TeamFallback()
  local marchTargetType = self.param:GetMarchTargetType()
  if not MarchTargetTypeShowTeamFallback[marchTargetType] then
    return
  end
  if not self.param.uuid or not self.param.targetUuid then
    return
  end
  local baseInfo = GetBaseInfoFromMarchData(self.param)
  UIUtil.ShowMessage(Localization:GetString("300031", baseInfo and baseInfo.ownerName), 2, "100288", "100289", function()
    DataCenter.FormationAssistanceDataManager:TryRetreatMarchTeam(self.param.targetUuid, self.param.uuid)
  end, nil, nil)
end

function AlarmInfoCell:DataDestroy()
  self.param = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timerAction = nil
  self.waitingTime = nil
end

return AlarmInfoCell
