local UIMainAlarmObj = BaseClass("UIMainAlarmObj", UIBaseContainer)
local base = UIBaseContainer
local AttackType = {SingleAttack = 1, RallyAttack = 2}

function UIMainAlarmObj:OnCreate(id)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainAlarmObj:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainAlarmObj:OnEnable()
  base.OnEnable(self)
end

function UIMainAlarmObj:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Alarm_ScreenEffects_UpdateSetting, self.ShowAlarmEffect)
  self:AddUIListener(EventId.AlOfficialSkillAlertEffect, self.RefreshAllianceSkillTargetMe)
  self:AddUIListener(EventId.BuildMainZeroUpgradeSuccess, self.RefreshMarchItemTargetMe)
  self:AddUIListener(EventId.MarchItemTargetMeUpdate, self.RefreshMarchItemTargetMe)
  self:AddUIListener(EventId.Alarm_Investigation_UpdateSetting, self.RefreshMarchItemTargetMe)
  self:AddUIListener(EventId.Alarm_Open, self.RefreshMarchItemTargetMe)
  self:AddUIListener(EventId.AllianceWarNewStatusChanged, self.RefreshMarchItemTargetMe)
end

function UIMainAlarmObj:OnRemoveListener()
  self:RemoveUIListener(EventId.Alarm_ScreenEffects_UpdateSetting, self.ShowAlarmEffect)
  self:RemoveUIListener(EventId.AlOfficialSkillAlertEffect, self.RefreshAllianceSkillTargetMe)
  self:RemoveUIListener(EventId.BuildMainZeroUpgradeSuccess, self.RefreshMarchItemTargetMe)
  self:RemoveUIListener(EventId.MarchItemTargetMeUpdate, self.RefreshMarchItemTargetMe)
  self:RemoveUIListener(EventId.Alarm_Investigation_UpdateSetting, self.RefreshMarchItemTargetMe)
  self:RemoveUIListener(EventId.Alarm_Open, self.RefreshMarchItemTargetMe)
  self:RemoveUIListener(EventId.AllianceWarNewStatusChanged, self.RefreshMarchItemTargetMe)
  base.OnRemoveListener(self)
end

function UIMainAlarmObj:ComponentDefine()
  self.obj = self:AddComponent(UIBaseContainer, "obj")
  self.btn = self:AddComponent(UIButton, "obj/btn")
  self.btnImg = self:AddComponent(UIImage, "obj/btn/btnImg")
  self.timeText = self:AddComponent(UIText, "obj/timeTxt")
  self.redPoint = self:AddComponent(UIBaseContainer, "obj/RedPointNum")
  self.redPointNumer = self:AddComponent(UIText, "obj/RedPointNum/Text")
  self.timeBg = self:AddComponent(UIImage, "obj/timeBg")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  
  function self.timerAction()
    self:OnTimer()
  end
  
  self.beAttackContent = self:AddComponent(UIImage, "obj/BeAttackContent")
  self.BG1 = self:AddComponent(UIImage, "obj/BeAttackContent/BG1")
  self.BG2 = self:AddComponent(UIImage, "obj/BeAttackContent/BG2")
  self.headContent = self:AddComponent(UIBaseContainer, "obj/BeAttackContent/HeadContent")
  self.headComList = {}
  for i = 1, 3 do
    table.insert(self.headComList, self:AddComponent(UICommonHead, "obj/BeAttackContent/HeadContent/UIPlayerHead" .. i))
  end
  self.attackTypeIcon = self:AddComponent(UIImage, "obj/BeAttackContent/HeadContent/AttackTypeIcon")
  self.timeBg:SetActive(false)
  self.timeText:SetActive(false)
  self.redPoint:SetActive(false)
end

function UIMainAlarmObj:OnTimer()
  if not self.param then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local color = "<color=#FFFFFF>"
  if LuaEntry.DataConfig:CheckSwitch("alarm_beta") then
    local color = "<color=#FFA9A9>"
    local selfMarchTargetType = self.param:GetMarchTargetType()
    if selfMarchTargetType == MarchTargetType.ASSISTANCE_CITY or selfMarchTargetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY then
      color = "<color=#FFFFFF>"
    end
  end
  if self.param.startTime - curTime <= 0 and curTime < self.param.endTime then
    if self.param:GetMarchStatus() == MarchStatus.ZOMBIE_RUSH_WAITING then
      local alreadyTime = curTime - self.param.startTime
      if alreadyTime < self.waitingTime then
        self.timeText:SetText(string.format("%s%s</color>", color, UITimeManager:GetInstance():MilliSecondToFmtString(self.waitingTime - alreadyTime)))
      else
        self.timeText:SetText(string.format("%s%s</color>", color, UITimeManager:GetInstance():MilliSecondToFmtString(self.param.endTime - curTime)))
      end
    else
      self.timeText:SetText(string.format("%s%s</color>", color, UITimeManager:GetInstance():MilliSecondToFmtString(self.param.endTime - curTime)))
    end
  elseif 0 >= self.param.endTime - curTime and self.timer then
    self.timeBg:SetActive(false)
    self.timeText:SetActive(false)
    if self.view and self.view.ShowAlarmEffect then
      self.view:ShowAlarmEffect(nil)
    end
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainAlarmObj:ComponentDestroy()
  self.obj = nil
  self.btn = nil
  self.btnImg = nil
  self.redPoint = nil
  self.headComList = nil
  self.beAttackContent = nil
end

function UIMainAlarmObj:DataDefine()
  self.type = nil
  self.waitingTime = 0
end

function UIMainAlarmObj:DataDestroy()
  self.type = nil
  self.param = nil
  if self.timer then
    self.timeBg:SetActive(false)
    self.timeText:SetActive(false)
    if self.view and self.view.ShowAlarmEffect then
      self.view:ShowAlarmEffect(nil)
    end
    self.timer:Stop()
    self.timer = nil
  end
  self.timerAction = nil
  self.waitingTime = nil
end

function UIMainAlarmObj:ReInit(type)
  self.type = type
  self:RefreshData()
end

function UIMainAlarmObj:RefreshData(alarmDataList)
  if alarmDataList and 0 < #alarmDataList then
    self.firstAlarmData = self:FindFirstAlarmData(alarmDataList)
    if not self.param or self.param.uid ~= alarmDataList[1] then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      self.param = alarmDataList[1].march
      self.isMask = alarmDataList[1].isMask
      if 0 >= self.param.startTime - curTime or curTime < self.param.endTime then
        if self.param:GetMarchStatus() == MarchStatus.ASSISTANCE and (self.param:GetMarchTargetType() == MarchTargetType.ASSISTANCE_CITY or self.param:GetMarchTargetType() == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.param:GetMarchTargetType() == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY) then
          self.timeBg:SetActive(false)
          self.timeText:SetActive(false)
          if self.timer then
            self.timer:Stop()
            self.timer = nil
          end
        else
          if self.param:GetMarchStatus() == MarchStatus.ZOMBIE_RUSH_WAITING then
            self.waitingTime = DataCenter.LWZombieRushManager:GetWaitingTimeByRound(self.param.zombieRushRound)
          end
          self.timeBg:SetActive(true)
          self.timeText:SetActive(true)
          self:OnTimer()
          if not self.timer then
            self.timer = TimerManager:GetInstance():GetTimer(1, self.timerAction, self, false, false, false)
            self.timer:Start()
          end
        end
      elseif 0 >= self.param.endTime - curTime then
        return
      end
    end
    if LuaEntry.DataConfig:CheckSwitch("alarm_beta") then
      local marchTargetType = self.param:GetMarchTargetType()
      if marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.RALLY_FOR_CITY or marchTargetType == MarchTargetType.RALLY_EPIDEMIC_CITY or marchTargetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or marchTargetType == MarchTargetType.CROSS_ATTACK_CITY or marchTargetType == MarchTargetType.FAKE_ATTACK then
        self.btnImg:SetActive(false)
        self.beAttackContent:SetActive(true)
        self:OnUpdateHeads(alarmDataList)
      else
        self.btnImg:SetActive(true)
        self.btnImg:LoadSprite(AlarmImagePatch[marchTargetType])
        self.beAttackContent:SetActive(false)
      end
    else
      self.btnImg:LoadSprite(AlarmImagePatch[self.param:GetMarchTargetType()])
    end
    self:OnUpdateRedPot(alarmDataList)
  else
    self.firstAlarmData = nil
    self.param = nil
  end
  self:ShowAlarmEffect()
end

function UIMainAlarmObj:FindFirstAlarmData(alarmList)
  if alarmList and 0 < #alarmList then
    for i = 1, #alarmList do
      local march = alarmList[i].march
      local target = march:GetMarchTargetType()
      if AlarmType[target] ~= AlarmEffect.Help and not alarmList[i].isMask then
        return alarmList[i]
      end
    end
    for i = 1, #alarmList do
      local march = alarmList[i].march
      local target = march:GetMarchTargetType()
      if AlarmType[target] == AlarmEffect.Help and not alarmList[i].isMask then
        return alarmList[i]
      end
    end
  end
end

function UIMainAlarmObj:ShowAlarmEffect()
  if not self.view or not self.view.ShowAlarmEffect then
    return
  end
  self:PostLogToBI()
  if self.firstAlarmData then
    self.view:ShowAlarmEffect(self.firstAlarmData.march:GetMarchTargetType())
  else
    self.view:ShowAlarmEffect(nil)
  end
end

function UIMainAlarmObj:PostLogToBI()
  if self.firstAlarmData then
    local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_ALARM_OPEN) == 1
    local isScreenEffectsOn = CommonUtil.PlayerPrefsGetBool("ScreenEffects", true)
    local isInvestigationOn = CommonUtil.PlayerPrefsGetBool("Investigation", true)
    local alarmType = self.firstAlarmData.march:GetMarchTargetType()
    local biParams = {}
    biParams.completenum = storageCurExtra and 1 or 0
    biParams.computenum1 = isScreenEffectsOn and 1 or 0
    biParams.computenum2 = isInvestigationOn and 1 or 0
    biParams.i_common_num = alarmType or 0
    PostEventLog.Track("AlertScreenEffectCondition", biParams)
  end
end

function UIMainAlarmObj:OnUpdateRedPot(alarmDataList)
  local num = 0
  if self.type == AlarmUIOpenType.DesertBattleUI then
    for i = 1, #alarmDataList do
      if not alarmDataList[i].isMask then
        num = num + 1
      end
    end
  else
    num = self.view.ctrl:GetRedPotCountByType(UIMainFunctionInfo.Alarm, self.param:GetMarchTargetType())
  end
  self.redPoint:SetActive(0 < num)
  self.redPointNumer:SetText(num)
end

function UIMainAlarmObj:OnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlarm, {anim = true}, self.type)
end

function UIMainAlarmObj:RefreshAllianceSkillTargetMe()
  local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_ALARM_OPEN) == 1
  if storageCurExtra then
    local allEffectAlert = DataCenter.AllianceSkillManager:GetEffectAlert()
    if allEffectAlert then
      local theGuardianTower
      local now = UITimeManager:GetInstance():GetServerTime()
      for uuid, effect in pairs(allEffectAlert) do
        if effect and effect.mask_finish ~= true and effect.overTime ~= nil and now < effect.overTime and effect.skill_flag == AlOfficialSkillType.GuardianTower then
          theGuardianTower = effect
          break
        end
      end
      if theGuardianTower then
        if self.param == nil then
          self.redPoint:SetActive(true)
          self.redPointNumer:SetText(1)
          self.obj:SetActive(true)
        end
        self.btn:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/Ambassador/mjc_zjmgongjiyujing_S4_dianta.png")
      elseif self.param == nil then
        self.redPoint:SetActive(false)
        self.obj:SetActive(false)
      end
    end
  end
end

function UIMainAlarmObj:RefreshMarchItemTargetMe()
  local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_ALARM_OPEN) == 1
  if storageCurExtra then
    local alarmDataList
    if BattleFieldUtil.InBattleField() then
      alarmDataList = MarchUtil.GetDesertBattleAlarmList()
    else
      alarmDataList = MarchUtil.GetaLlarmList()
    end
    if LuaEntry.DataConfig:CheckSwitch("alarm_beta") then
      local typeMap = {}
      for k, v in pairs(alarmDataList) do
        typeMap[v] = v.march:GetMarchTargetType()
      end
      table.sort(alarmDataList, function(a, b)
        if not typeMap[a] or not typeMap[b] then
          return false
        end
        local aMarchType = typeMap[a]
        local bMarchType = typeMap[b]
        local aIsScout = aMarchType == MarchTargetType.SCOUT_CITY or aMarchType == MarchTargetType.SCOUT_WINTER_STORM_CITY or aMarchType == MarchTargetType.SCOUT_EPIDEMIC_CITY
        local bIsScout = bMarchType == MarchTargetType.SCOUT_CITY or bMarchType == MarchTargetType.SCOUT_WINTER_STORM_CITY or bMarchType == MarchTargetType.SCOUT_EPIDEMIC_CITY
        local aIsAssistance = aMarchType == MarchTargetType.ASSISTANCE_CITY or aMarchType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or aMarchType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY
        local bIsAssistance = bMarchType == MarchTargetType.ASSISTANCE_CITY or bMarchType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or bMarchType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY
        local aIsAttack = not aIsScout and not aIsAssistance
        local bIsAttack = not bIsScout and not bIsAssistance
        if not (not aIsAttack or bIsAttack) or bIsAttack and not aIsAttack then
          return aIsAttack
        elseif not (not aIsAssistance or bIsAssistance) or bIsAssistance and not aIsAssistance then
          return aIsAssistance
        elseif not (not aIsScout or bIsScout) or bIsScout and not aIsScout then
          return aIsScout
        else
          return a.march.endTime < b.march.endTime
        end
      end)
    end
    if alarmDataList and table.count(alarmDataList) > 0 then
      self.obj:SetActive(true)
      self:RefreshData(alarmDataList)
    else
      self.obj:SetActive(false)
      self:RefreshData(nil)
    end
    self:RefreshAllianceSkillTargetMe()
  else
    self.obj:SetActive(false)
    self:RefreshData(nil)
  end
end

local function GetAttackData(alarmDataList)
  local ret = {}
  for i = 1, #alarmDataList do
    local marchTargetType = alarmDataList[i].march:GetMarchTargetType()
    if marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.RALLY_FOR_CITY or marchTargetType == MarchTargetType.RALLY_EPIDEMIC_CITY or marchTargetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or marchTargetType == MarchTargetType.CROSS_ATTACK_CITY or marchTargetType == MarchTargetType.FAKE_ATTACK then
      table.insert(ret, alarmDataList[i])
    end
  end
  return ret
end

local function SetHead(headCom, ownerUid, pic, picVer, headSkinId, headSkinET)
  if headCom then
    headCom:SetHead(ownerUid, pic, picVer)
    headCom:SetEnableClickShowInfo(false, true)
    headCom:SetActive(true)
  end
end

local function SetAttackTypeIcon(iconCom, attackType)
  if iconCom then
    iconCom:SetActive(true)
    if attackType == AttackType.SingleAttack then
      iconCom:LoadSprite("Assets/Main/Sprites/UI/UILWAllianceAlarm/mjc_zhandoutixing_gongji")
    elseif attackType == AttackType.RallyAttack then
      iconCom:LoadSprite("Assets/Main/Sprites/UI/UILWAllianceAlarm/mjc_zhandoutixing_jijie")
    end
  end
end

function UIMainAlarmObj:OnUpdateHeads(alarmDataList)
  if alarmDataList then
    local attackDataList = GetAttackData(alarmDataList)
    local dataCount = 0
    local attackerUidMap = {}
    local attackType = AttackType.SingleAttack
    for i = 1, #attackDataList do
      local marchInfo = attackDataList[i].march
      if marchInfo then
        if not attackerUidMap[marchInfo.ownerUid] then
          dataCount = dataCount + 1
          attackerUidMap[marchInfo.ownerUid] = true
        end
        if marchInfo:GetMarchType() == NewMarchType.ASSEMBLY_MARCH then
          attackType = AttackType.RallyAttack
          local rallyData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(marchInfo.teamUuid)
          if rallyData then
            local memberList = table.values(rallyData.memberList)
            for k, v in pairs(memberList) do
              if not attackerUidMap[v.ownerUid] then
                dataCount = dataCount + 1
                attackerUidMap[v.ownerUid] = true
              end
            end
          end
        end
      end
    end
    local showCount = math.min(dataCount, 3)
    local finishedCount = 0
    for i = 1, #attackDataList do
      if showCount <= finishedCount then
        break
      end
      local marchInfo = attackDataList[i].march
      if marchInfo:GetMarchType() == NewMarchType.ASSEMBLY_MARCH then
        if attackerUidMap[marchInfo.ownerUid] then
          SetHead(self.headComList[finishedCount + 1], marchInfo.ownerUid, marchInfo.pic, marchInfo.picVer, marchInfo.headSkinId, marchInfo.headSkinET)
          finishedCount = finishedCount + 1
          attackerUidMap[marchInfo.ownerUid] = nil
        end
        local rallyData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(marchInfo.teamUuid)
        if rallyData then
          local memberList = table.values(rallyData.memberList)
          local maxShowCount = math.min(finishedCount + #memberList, showCount)
          local startIndex = finishedCount + 1
          for j = startIndex, maxShowCount do
            local data = memberList[j - startIndex + 1]
            if attackerUidMap[data.ownerUid] then
              SetHead(self.headComList[finishedCount + 1], data.ownerUid, data.ownerIcon, data.ownerIconVer, data.headSkinId, data.headSkinET)
              finishedCount = finishedCount + 1
              attackerUidMap[data.ownerUid] = nil
            end
          end
        end
      elseif marchInfo.armyInfos.Count == 1 and attackerUidMap[marchInfo.ownerUid] then
        SetHead(self.headComList[finishedCount + 1], marchInfo.ownerUid, marchInfo.pic, marchInfo.picVer, marchInfo.headSkinId, marchInfo.headSkinET)
        finishedCount = finishedCount + 1
        attackerUidMap[marchInfo.ownerUid] = nil
      end
    end
    for i = showCount + 1, 3 do
      self.headComList[i]:SetActive(false)
    end
    if 0 < showCount then
      SetAttackTypeIcon(self.attackTypeIcon, attackType)
    end
    self.BG1.transform:Set_sizeDelta(120 + (showCount - 1) * 20, 120)
    self.BG2.transform:Set_sizeDelta(200 + (showCount - 1) * 20, 200)
  end
end

return UIMainAlarmObj
