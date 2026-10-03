local AllyDrillBaseHugeSandWorm = BaseClass("AllyDrillBaseHugeSandWorm")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local newBossStatus = {
  idle = "idle",
  stun = "stun",
  born = "born",
  hit = "hit",
  dead = "dead",
  attack = "attack",
  rage = "rage",
  skill = "skill"
}
local thumbType = {stun = "stun", crit = "crit"}
local bossInitRY = 135
local InBaseStatusModelLabelHeight = 7
local InBaseStatusModelLabelSize = 1
local InBossStatusModelLabelHeight = 12
local InBossStatusModelLabelSize = 1.2

function AllyDrillBaseHugeSandWorm:__init(allyDrillBase, transform)
  self.transform = transform
  self.allyDrillBase = allyDrillBase
  self.rage = false
  self.critTipsDatas = {}
  self.TipTimers = {}
  self.TipTimerId = 1
end

function AllyDrillBaseHugeSandWorm:__delete()
  self:Destroy()
end

function AllyDrillBaseHugeSandWorm:Destroy()
  self:ClearBornEffect()
  self:ClearStunEffect()
  if self.sandDeadTimer then
    self.sandDeadTimer:Stop()
    self.sandDeadTimer = nil
  end
  if self.ThumbsUpCritTip then
    self.ThumbsUpCritTip.gameObject:GameObjectRecycleAll()
    self.ThumbsUpCritTip = nil
  end
  if self.bossSkinMeshRender then
    self.bossSkinMeshRender.sharedMaterial = self.bossNormalMaterial
  end
  if not self.bossRageMaterial then
    CS.UnityEngine.Object.Destroy(self.bossRageMaterial)
    self.bossRageMaterial = nil
  end
  if self.rageChangeTimer then
    self.rageChangeTimer:Stop()
    self.rageChangeTimer = nil
  end
  if self.delayResetRotationTimer then
    self.delayResetRotationTimer:Stop()
    self.delayResetRotationTimer = nil
  end
  if self.TipTimers then
    for i, timer in pairs(self.TipTimers) do
      timer:Stop()
    end
  end
  self.TipTimers = nil
  self.rage = nil
  self.critTipsDatas = nil
  self.TipTimerId = nil
  self.showBossBornFinsh = nil
  self.initSandColor = nil
  self.initEmission = nil
  self.initRimPow = nil
  self.initBossSize = nil
  self.targetSandColor = nil
  self.targetEmission = nil
  self.targetRimPow = nil
  self.targetBossSize = nil
  self.changingTime = nil
  self.allyDrillBase = nil
  self.sliderNode = nil
  self.sliderBar = nil
  self.sliderSprite = nil
  self.sliderText = nil
  self.timeNode = nil
  self.timeText = nil
  self.transform = nil
  self.stageNode = nil
  self.stageText = nil
  self.showBossTime = nil
  self.isMoveObj = nil
  self.showBossEffectTime = nil
  self.bossSkinMeshRender = nil
  self.bossNormalMaterial = nil
  self.rageStatusAttackTime = nil
  self.rageStatusAttackTarget = nil
  self.initRageStatus = nil
  self.buildAnimation = nil
  self.worldModeNode = nil
end

function AllyDrillBaseHugeSandWorm:Init()
  self.desNameText = self.transform:Find("Icon/IconSprite/Des/DesNameText"):GetComponent(typeof(CS.SuperTextMesh))
  self.modelLabel = self.transform:Find("ModelLabel").gameObject
  self.modelLabel:SetActive(true)
  self.modelLabelRoot = self.transform:Find("ModelLabel/Root").gameObject
  self.sliderNode = self.transform:Find("ModelLabel/Root/Slider").gameObject
  self.sliderBar = self.transform:Find("ModelLabel/Root/Slider/SliderBar")
  self.sliderSprite = self.sliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.sliderText = self.transform:Find("ModelLabel/Root/Slider/SliderText"):GetComponent(typeof(CS.TextMeshProEx))
  self.stageNode = self.transform:Find("ModelLabel/Root/Stage").gameObject
  self.stageText = self.transform:Find("ModelLabel/Root/Stage/StageText"):GetComponent(typeof(CS.TextMeshProEx))
  self.timeNode = self.transform:Find("ModelLabel/Root/Time").gameObject
  self.timeText = self.transform:Find("ModelLabel/Root/Time/TimeText"):GetComponent(typeof(CS.TextMeshProEx))
  self.nameText = self.transform:Find("ModelLabel/Root/Name/NameText"):GetComponent(typeof(CS.TextMeshProEx))
  self.modelLabelBg = self.transform:Find("ModelLabel/Root/LabelBg").gameObject
  self.worldModeNode = self.transform:Find("Model/WorldModel").gameObject
  self.bossNode = self.transform:Find("Model/WorldModel/hero").gameObject
  self.bossAnimation = self.bossNode:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self.bossAnimation.transform:Set_localEulerAngles(0, 0, 0)
  self.buildNode = self.transform:Find("Model/WorldModel/A_build_tongmengjunyan").gameObject
  self.buildAnimation = self.buildNode:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self.appearEff = self.transform:Find("Model/WorldModel/Eff_A_build_tongmengjunyan_born_smoke").gameObject
  self.appearEff:SetActive(false)
  self.disappearEff = self.transform:Find("Model/WorldModel/Eff_daditu_lianmengboss_tuichu").gameObject
  self.disappearEff:SetActive(false)
  self.bossSkinMeshRender = self.transform:Find("Model/WorldModel/hero/sandworm/To_unity/skin"):GetComponent(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  self.bossNormalMaterial = self.bossSkinMeshRender.sharedMaterial
  self.bossNode.transform.rotation = Quaternion.Euler(0, bossInitRY, 0)
  self.ThumbsUpCritTip = self.transform:Find("ModelLabel/ThumbsUpCritTip")
  self.ThumbsUpCritTip.gameObject:GameObjectCreatePool()
  self.ThumbsUpCritTip.gameObject:SetActive(false)
  self:InitName()
  self:RefreshView()
  if not self.isMoveObj and DataCenter.AllyDrillBaseManager:CheckDrillBaseIsMove(self.allyDrillBase.uuid) then
    local troop = CS.SceneManager.World:GetTroop(self.allyDrillBase.uuid)
    if troop then
      troop:SetVisible(false)
    end
  end
end

function AllyDrillBaseHugeSandWorm:InitName()
  local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.allyDrillBase.marchInfo.monsterId)
  local bossName = Localization:GetString(meta.name)
  local bossLv = meta.level
  local bossNameAndLevel = Localization:GetString("140205", bossLv, bossName)
  local nameStr = Localization:GetString("311026", self.allyDrillBase.marchInfo.allianceAbbr, bossNameAndLevel)
  self.desNameText.text = self.allyDrillBase.marchInfo.allianceAbbr
  self.nameText.text = nameStr
end

function AllyDrillBaseHugeSandWorm:RefreshPerformanceState(inAttackBoss)
  if inAttackBoss then
    self.bossNode:SetActive(true)
    self.buildNode:SetActive(false)
    self.sliderNode:SetActive(true)
    self.stageNode:SetActive(true)
    self.HeadHeight = InBossStatusModelLabelHeight
    self.modelLabelRoot.transform:Set_localScale(InBossStatusModelLabelSize, InBossStatusModelLabelSize, InBossStatusModelLabelSize)
    self:UpdateLabelHeight()
    self.modelLabelBg.transform:Set_localScale(1, 1, 1)
  else
    self.sliderNode:SetActive(false)
    self.stageNode:SetActive(false)
    self.bossNode:SetActive(false)
    self.buildNode:SetActive(true)
    self.HeadHeight = InBaseStatusModelLabelHeight
    self.modelLabelRoot.transform:Set_localScale(InBaseStatusModelLabelSize, InBaseStatusModelLabelSize, InBaseStatusModelLabelSize)
    self:UpdateLabelHeight()
    self.modelLabelBg.transform:Set_localScale(1, 0.7, 1)
  end
end

function AllyDrillBaseHugeSandWorm:RefreshView()
  local bossInfo = self.allyDrillBase.bossInfo
  if not bossInfo or not bossInfo.readyTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local oldStage = self.stage
  local newBossInfo = self.allyDrillBase.bossInfo.dataS3
  self.stageText.text = Localization:GetString("new_alliance_boss_tips_14", newBossInfo.stage)
  if now < bossInfo.readyTime then
    self.stage = AllyDrillStage.PrepareStage
    self.nextTime = bossInfo.readyTime
    self:RefreshPerformanceState(false)
    if DataCenter.AllyDrillBaseManager:CheckNeedShowCreateEffect(self.allyDrillBase.uuid) then
      self:ShowCreateEffect()
      DataCenter.AllyDrillBaseManager:ClearNeedShowCreateEffect()
    else
      self.buildAnimation:Play("idle")
    end
  elseif bossInfo.battleStartTime <= 0 then
    self:RefreshPerformanceState(false)
    self.buildAnimation:Play("idle")
    if bossInfo.actEndTime then
      if now < bossInfo.actEndTime then
        self.stage = AllyDrillStage.ReadyStage
        self.nextTime = bossInfo.actEndTime
      else
        self.stage = AllyDrillStage.End
        self.nextTime = nil
      end
    else
      self.stage = AllyDrillStage.ReadyStage
      self.nextTime = nil
    end
  elseif now < bossInfo.battleEndTime and (newBossInfo.stage < 3 or newBossInfo.stage == 3 and 0 < newBossInfo.curHp) then
    self.stage = AllyDrillStage.AttackStage
    if oldStage ~= nil and oldStage ~= self.stage then
      self:RefreshPerformanceState(false)
      self:ShowBornAnim()
    elseif self.showBossBornFinsh == nil then
      self:RefreshPerformanceState(true)
      if newBossInfo.dizzinessState == 1 then
        local severTimeNow = UITimeManager:GetInstance():GetServerTime()
        local dizzinessTime = newBossInfo.dizzinessTime or 0
        if not self.dizzinessEndTime and severTimeNow < dizzinessTime then
          self.dizzinessEndTime = dizzinessTime
          self:ChangeSandWormAnim(newBossStatus.stun)
          self:ShowStunEffect()
          if self.bossStage then
            self:AddThumbStunUp(newBossInfo.dizzinessUid, newBossInfo.dizzinessUser)
          end
        elseif self.dizzinessEndTime then
          if severTimeNow > dizzinessTime then
            self.dizzinessEndTime = nil
            if self.bossStage ~= nil and newBossInfo.stage > self.bossStage then
              if newBossInfo.stage >= 3 then
                self:ChangeSandWormAnim(newBossStatus.rage)
              else
                self:ChangeSandWormAnim(newBossStatus.skill)
              end
            elseif not self.delayResetRotationTimer then
              self:ChangeSandWormAnim(newBossStatus.idle)
            end
            self:ClearStunEffect()
          else
            if self.bossStage and dizzinessTime > self.dizzinessEndTime then
              self:AddThumbStunUp(newBossInfo.dizzinessUid, newBossInfo.dizzinessUser)
            end
            self.dizzinessEndTime = dizzinessTime
          end
        else
          self:ClearStunEffect()
          if self.bossStage ~= nil and newBossInfo.stage > self.bossStage then
            if newBossInfo.stage >= 3 then
              self:ChangeSandWormAnim(newBossStatus.rage)
            else
              self:ChangeSandWormAnim(newBossStatus.skill)
            end
          elseif not self.delayResetRotationTimer then
            self:ChangeSandWormAnim(newBossStatus.idle)
          end
        end
      else
        if self.dizzinessEndTime then
          self.dizzinessEndTime = nil
        end
        self:ClearStunEffect()
        if self.bossStage ~= nil and newBossInfo.stage > self.bossStage then
          if newBossInfo.stage >= 3 then
            self:ChangeSandWormAnim(newBossStatus.rage)
          else
            self:ChangeSandWormAnim(newBossStatus.skill)
          end
        elseif not self.delayResetRotationTimer then
          self:ChangeSandWormAnim(newBossStatus.idle)
        end
      end
      self:ChangeSandWormRage(newBossInfo.stage >= 3)
    end
    local sliderValue = 1
    if 0 < newBossInfo.totalHp then
      sliderValue = newBossInfo.curHp / newBossInfo.totalHp
    end
    self.sliderBar.localPosition = Vector3.New(sliderValue * 2.5 - 2.5, -0.22, 0)
    self.sliderSprite.size = Vector2.New(sliderValue * 5, 0.5)
    self.sliderText.text = string.percentage(newBossInfo.curHp, newBossInfo.totalHp, 2)
    self.bossStage = newBossInfo.stage
    self.nextTime = bossInfo.battleEndTime
  else
    self.stage = AllyDrillStage.SettleStage
    if oldStage ~= nil and oldStage ~= self.stage then
      self:RefreshPerformanceState(true)
      self:ShowDieAnim()
    else
      self:RefreshPerformanceState(false)
      self.buildAnimation:Play("idle")
    end
    self.nextTime = nil
  end
end

function AllyDrillBaseHugeSandWorm:OnUpdateSec()
  if self.stage == nil then
    self:RefreshView()
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.nextTime and now > self.nextTime then
    self:RefreshView()
  end
  if self.stage == AllyDrillStage.PrepareStage then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.nextTime - now)
    self.timeText.text = Localization:GetString("2010331", timeStr)
  elseif self.stage == AllyDrillStage.ReadyStage then
    self.timeText.text = Localization:GetString("2010349")
  elseif self.stage == AllyDrillStage.AttackStage then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.nextTime - now)
    self.timeText.text = Localization:GetString("2010329", timeStr)
  else
    self.timeText.text = Localization:GetString("2010333")
  end
  if self.showBossTime and now > self.showBossTime then
    self.bossNode:SetActive(true)
    self:ChangeSandWormAnim(newBossStatus.born)
    self.buildNode:SetActive(false)
    self.showBossTime = nil
  end
  if self.showBossEffectTime and now > self.showBossEffectTime then
    self.showBossEffectTime = nil
    self:ShowBornEffect()
  end
  if self.showBossBornFinsh and now > self.showBossBornFinsh then
    self.showBossBornFinsh = nil
    self:RefreshPerformanceState(true)
  end
  if self.dizzinessEndTime and now > self.dizzinessEndTime then
    self:ChangeSandWormAnim(newBossStatus.idle)
    self:ClearStunEffect()
    self.dizzinessEndTime = nil
  end
  if self.rageStatusAttackTime and now > self.rageStatusAttackTime then
    self:DoAttackTargetPosOnce(self.rageStatusAttackTarget, true)
    self.rageStatusAttackTime = nil
  end
  self:PopShowThumbCritUpPerSec()
end

function AllyDrillBaseHugeSandWorm:ShowCreateEffect()
  self.appearEff:SetActive(true)
  self.buildAnimation:Play("born")
  self.buildAnimation:PlayQueued("idle")
end

function AllyDrillBaseHugeSandWorm:SetMoveState(isHide)
  if isHide then
    self.appearEff:SetActive(false)
  elseif self.showBossTime then
    self:ShowBornAnim()
  end
end

function AllyDrillBaseHugeSandWorm:OnDonateSuccess(msg)
  self.buildAnimation:Play("action")
end

function AllyDrillBaseHugeSandWorm:ShowBornAnim()
  self.buildAnimation:Play("die")
  local cur = UITimeManager:GetInstance():GetServerTime()
  self.showBossTime = cur + 4000
  self.showBossBornFinsh = cur + 5000
  self.showBossEffectTime = cur + 3000
end

function AllyDrillBaseHugeSandWorm:ShowDieAnim()
  if self.sandDeadTimer then
    self.sandDeadTimer:Stop()
    self.sandDeadTimer = nil
  end
  self:ChangeSandWormAnim(newBossStatus.dead)
  self:ClearStunEffect()
  self.sandDeadTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.disappearEff:SetActive(true)
    self:RefreshPerformanceState(false)
    self.buildAnimation:Play("idle")
  end, 3)
end

function AllyDrillBaseHugeSandWorm:ChangeSandWormAnim(status)
  if not self.bossAnimation then
    return
  end
  self.bossAnimation:ForceCleanAllQueuedStates()
  if status == newBossStatus.born then
    self.bossAnimation:CrossFade(newBossStatus.born, 0.1)
    self.bossAnimation:CrossFadeQueued(newBossStatus.idle, 0.1, CS.UnityEngine.QueueMode.CompleteOthers)
  elseif status == newBossStatus.idle then
    self.bossAnimation:Play(newBossStatus.idle)
  elseif status == newBossStatus.attack then
    self.bossAnimation:CrossFade(newBossStatus.attack, 0.1)
    self.bossAnimation:CrossFadeQueued(newBossStatus.idle, 0.1, CS.UnityEngine.QueueMode.CompleteOthers)
  elseif status == newBossStatus.stun then
    self.bossAnimation:Play(newBossStatus.stun)
  elseif status == newBossStatus.hit then
    self.bossAnimation:CrossFade(newBossStatus.hit, 0.1)
    self.bossAnimation:CrossFadeQueued(newBossStatus.idle, 0.1, CS.UnityEngine.QueueMode.CompleteOthers)
  elseif status == newBossStatus.dead then
    self.bossAnimation:CrossFade(newBossStatus.dead, 0.1)
  elseif status == newBossStatus.rage then
    self.bossAnimation:CrossFade(newBossStatus.rage, 0.1)
    self.bossAnimation:CrossFadeQueued(newBossStatus.idle, 0.1, CS.UnityEngine.QueueMode.CompleteOthers)
  elseif status == newBossStatus.skill then
    self.bossAnimation:CrossFade(newBossStatus.skill, 0.1)
    self.bossAnimation:CrossFadeQueued(newBossStatus.idle, 0.1, CS.UnityEngine.QueueMode.CompleteOthers)
  end
end

function AllyDrillBaseHugeSandWorm:ShowBornEffect()
  local prefabName = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_tongmengjunyan_monster_born.prefab"
  self:ClearBornEffect()
  self.bornEffectReq = ResourceManager:InstantiateAsync(prefabName)
  self.bornEffectReq:completed("+", function()
    if self.bornEffectReq.isError then
      return
    end
    local go = self.bornEffectReq.gameObject
    go.transform:SetParent(self.transform)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go:SetActive(true)
  end)
  self.bornEffectDelayDestoryTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ClearBornEffect()
  end, 3)
end

function AllyDrillBaseHugeSandWorm:ClearBornEffect()
  if self.bornEffectReq then
    self.bornEffectReq:Destroy()
    self.bornEffectReq = nil
  end
  if self.bornEffectDelayDestoryTimer then
    self.bornEffectDelayDestoryTimer:Stop()
    self.bornEffectDelayDestoryTimer = nil
  end
end

function AllyDrillBaseHugeSandWorm:UpdateLabelHeight()
  self.modelLabel.transform:Set_localPosition(0, self.HeadHeight, 0)
end

function AllyDrillBaseHugeSandWorm:ShowStunEffect()
  local prefabName = "Assets/Main/Prefabs/Effect/World/Sandworm/BigSandwormStunVFX.prefab"
  self:ClearStunEffect()
  self.stunEffectReq = ResourceManager:InstantiateAsync(prefabName)
  self.stunEffectReq:completed("+", function()
    if self.stunEffectReq.isError then
      return
    end
    local go = self.stunEffectReq.gameObject
    go.transform:SetParent(self.worldModeNode.transform)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_positionY(ResetPosition.x, self.HeadHeight, ResetPosition.z)
    go.transform:Set_localScale(2, 2, 2)
    go:SetActive(true)
  end)
end

function AllyDrillBaseHugeSandWorm:ClearStunEffect()
  if self.stunEffectReq then
    self.stunEffectReq:Destroy()
    self.stunEffectReq = nil
  end
end

local SandomM_N_ColorR = 1
local SandomM_N_ColorG = 1
local SandomM_N_ColorB = 1
local SandomM_N_Em_Ints = 0
local SandomM_N_Rim_Pow = 0
local SandomM_R_ColorR = 0.68
local SandomM_R_ColorG = 0.47
local SandomM_R_ColorB = 0.43
local SandomM_R_Em_Ints = 2
local SandomM_R_Rim_Pow = 1
local Sandom_N_Size = 1
local Sandom_R_Size = 1.5

function AllyDrillBaseHugeSandWorm:BeginRageChangeTimer()
  if self.rageChangeTimer then
    self.rageChangeTimer:Stop()
    self.rageChangeTimer = nil
  end
  self.rageChangeTimer = TimerManager:GetInstance():GetTimer(0, self.OnChangingRage, self, false, true, false)
  self.rageChangeTimer:Start()
end

function AllyDrillBaseHugeSandWorm:OnChangingRage()
  if self.changingTime < 0.5 then
    self.changingTime = self.changingTime + Time.deltaTime
    local scale = math.min(self.changingTime / 0.5, 1)
    local onMinScale = 1 - scale
    local cR = onMinScale * self.initSandColor.r + scale * self.targetSandColor.r
    local cG = onMinScale * self.initSandColor.g + scale * self.targetSandColor.g
    local cB = onMinScale * self.initSandColor.b + scale * self.targetSandColor.b
    local curColor = Color.New(cR, cG, cB, 1)
    local emission = onMinScale * self.initEmission + scale * self.targetEmission
    local rimPow = onMinScale * self.initRimPow + scale * self.targetRimPow
    self:SetSandWormMatPro(curColor, emission, rimPow)
    local size = onMinScale * self.initBossSize + scale * self.targetBossSize
    self.bossNode.transform:Set_localScale(size, size, size)
    self.HeadHeight = size * InBossStatusModelLabelHeight
    self:UpdateLabelHeight()
  else
    self.changingTime = 0
    self:SetSandWormMatPro(self.targetSandColor, self.targetEmission, self.targetRimPow)
    self.bossNode.transform:Set_localScale(self.targetBossSize, self.targetBossSize, self.targetBossSize)
    self.HeadHeight = self.targetBossSize * InBossStatusModelLabelHeight
    self:UpdateLabelHeight()
    self.rageChangeTimer:Stop()
    self.rageChangeTimer = nil
  end
  if self.stunEffectReq and IsNotNull(self.stunEffectReq.gameObject) then
    self.stunEffectReq.gameObject.transform:Set_positionY(ResetPosition.x, self.HeadHeight, ResetPosition.z)
  end
end

function AllyDrillBaseHugeSandWorm:ChangeSandWormRage(isRage)
  if not self.bossNormalMaterial then
    return
  end
  if not self.bossRageMaterial then
    self.bossRageMaterial = CS.UnityEngine.Material(self.bossNormalMaterial)
    self.bossSkinMeshRender.sharedMaterial = self.bossRageMaterial
  end
  if isRage then
    if self.initRageStatus and self.rage == false then
      self.initSandColor = Color.New(SandomM_N_ColorR, SandomM_N_ColorG, SandomM_N_ColorB, 1)
      self.initEmission = SandomM_N_Em_Ints
      self.initRimPow = SandomM_N_Rim_Pow
      self.initBossSize = Sandom_N_Size
      self.targetSandColor = Color.New(SandomM_R_ColorR, SandomM_R_ColorG, SandomM_R_ColorB, 1)
      self.targetEmission = SandomM_R_Em_Ints
      self.targetRimPow = SandomM_R_Rim_Pow
      self.targetBossSize = Sandom_R_Size
      self.changingTime = 0
      self:SetSandWormMatPro(self.initSandColor, self.initEmission, self.initRimPow)
      self.bossNode.transform:Set_localScale(self.initBossSize, self.initBossSize, self.initBossSize)
      self.HeadHeight = self.initBossSize * InBossStatusModelLabelHeight
      self:UpdateLabelHeight()
      self:BeginRageChangeTimer()
    else
      self:SetSandWormMatPro(Color.New(SandomM_R_ColorR, SandomM_R_ColorG, SandomM_R_ColorB, 1), SandomM_R_Em_Ints, SandomM_R_Rim_Pow)
      self.bossNode.transform:Set_localScale(Sandom_R_Size, Sandom_R_Size, Sandom_R_Size)
      self.HeadHeight = Sandom_R_Size * InBossStatusModelLabelHeight
      self:UpdateLabelHeight()
    end
  elseif self.initRageStatus and self.rage then
    self.initSandColor = Color.New(SandomM_R_ColorR, SandomM_R_ColorG, SandomM_R_ColorB, 1)
    self.initEmission = SandomM_R_Em_Ints
    self.initRimPow = SandomM_R_Rim_Pow
    self.initBossSize = Sandom_R_Size
    self.targetSandColor = Color.New(SandomM_N_ColorR, SandomM_N_ColorG, SandomM_N_ColorB, 1)
    self.targetEmission = SandomM_N_Em_Ints
    self.targetRimPow = SandomM_N_Rim_Pow
    self.targetBossSize = Sandom_N_Size
    self.changingTime = 0
    self:SetSandWormMatPro(self.initSandColor, self.initEmission, self.initRimPow)
    self.bossNode.transform:Set_localScale(self.initBossSize, self.initBossSize, self.initBossSize)
    self.HeadHeight = self.initBossSize * InBossStatusModelLabelHeight
    self:UpdateLabelHeight()
    self:BeginRageChangeTimer()
  else
    self:SetSandWormMatPro(Color.New(SandomM_N_ColorR, SandomM_N_ColorG, SandomM_N_ColorB, 1), SandomM_N_Em_Ints, SandomM_N_Rim_Pow)
    self.bossNode.transform:Set_localScale(Sandom_N_Size, Sandom_N_Size, Sandom_N_Size)
    self.HeadHeight = Sandom_N_Size * InBossStatusModelLabelHeight
    self:UpdateLabelHeight()
  end
  if self.stunEffectReq and IsNotNull(self.stunEffectReq.gameObject) then
    self.stunEffectReq.gameObject.transform:Set_positionY(ResetPosition.x, self.HeadHeight, ResetPosition.z)
  end
  self.rage = isRage
  self.initRageStatus = true
end

function AllyDrillBaseHugeSandWorm:SetSandWormMatPro(color, emission, rimpow)
  if not self.bossRageMaterial then
    return
  end
  self.bossRageMaterial:SetColor("_BaseColor", color)
  self.bossRageMaterial:SetFloat("_EmissionIns", emission)
  self.bossRageMaterial:SetFloat("_RimPow", rimpow)
  self.bossRageMaterial:SetFloat("_USERIM", 1)
end

function AllyDrillBaseHugeSandWorm:ShowSkillEffect(type)
  if type == 0 then
    self:ChangeSandWormAnim(newBossStatus.skill)
  elseif type == 1 then
    self:ChangeSandWormAnim(newBossStatus.attack)
  end
end

function AllyDrillBaseHugeSandWorm:DoAttackTargetPosOnce(targetPos, force)
  if self.dizzinessEndTime then
    return
  end
  if not force and self.delayResetRotationTimer then
    return
  end
  local selfPos = Vector3.New(self.transform.position.x, self.transform.position.y, self.transform.position.z)
  local lookRot = Vector3.Normalize(targetPos - selfPos)
  lookRot = Quaternion.LookRotation(lookRot, Vector3.up)
  self.bossNode.transform.rotation = lookRot
  self:ChangeSandWormAnim(newBossStatus.attack)
  if force and self.delayResetRotationTimer then
    self.delayResetRotationTimer:Stop()
    self.delayResetRotationTimer = nil
  end
  self.delayResetRotationTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.bossNode.transform.rotation = Quaternion.Euler(0, bossInitRY, 0)
    self.delayResetRotationTimer:Stop()
    self.delayResetRotationTimer = nil
  end, 1.6)
end

function AllyDrillBaseHugeSandWorm:CheckDoAttack(marchInfo)
  if marchInfo.allianceUid == self.allyDrillBase.marchInfo.allianceUid then
    local targetPos
    if marchInfo:GetMarchType() == NewMarchType.ALLIANCE_BOSS_SAND then
      targetPos = SceneUtils.TileIndexToWorld(marchInfo.targetPos, ForceChangeScene.World)
      self:DoAttackTargetPosOnce(targetPos, true)
    else
      targetPos = SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World)
      self:DoAttackTargetPosOnce(targetPos, false)
    end
  end
end

function AllyDrillBaseHugeSandWorm:DoReactionWhenSingleMarchChange(marchInfo)
  if marchInfo.allianceUid == self.allyDrillBase.marchInfo.allianceUid and marchInfo:GetMarchType() == NewMarchType.ALLIANCE_BOSS_SAND then
    local now = UITimeManager:GetInstance():GetServerTime()
    local deadLineAttack = marchInfo.endTime - 2000
    if now < deadLineAttack then
      self.rageStatusAttackTime = deadLineAttack
      self.rageStatusAttackTarget = SceneUtils.TileIndexToWorld(marchInfo.targetPos, ForceChangeScene.World)
    else
      self.rageStatusAttackTime = nil
      self.rageStatusAttackTarget = nil
    end
  end
end

function AllyDrillBaseHugeSandWorm:ShowCritTipEffect(arr)
  self:AddThumbCritUps(arr)
end

function AllyDrillBaseHugeSandWorm:AddThumbCritUps(arr)
  if arr then
    local len = #arr
    for i = len, 1, -1 do
      arr[i].type = thumbType.crit
      table.insert(self.critTipsDatas, arr[i])
    end
  end
end

function AllyDrillBaseHugeSandWorm:AddThumbStunUp(uid, dizzinessUser)
  if dizzinessUser then
    local data = {}
    data.type = thumbType.stun
    data.abbr = dizzinessUser.abbr
    data.name = dizzinessUser.name
    data.uid = uid
    data.pic = dizzinessUser.pic
    data.picVer = dizzinessUser.picVer
    table.insert(self.critTipsDatas, data)
  end
end

function AllyDrillBaseHugeSandWorm:PopShowThumbCritUpPerSec()
  local len = #self.critTipsDatas
  if 0 < len then
    local tipData = self.critTipsDatas[len]
    local itemObj = self.ThumbsUpCritTip.gameObject:GameObjectSpawn(self.modelLabel.transform)
    itemObj:SetActive(true)
    local playerName = itemObj.transform:Find("bg/txtName"):GetComponent(typeof(CS.TextMeshProEx))
    playerName.text = string.format("[%s]%s", tipData.abbr, tipData.name)
    local descLabel = itemObj.transform:Find("bg/txt"):GetComponent(typeof(CS.TextMeshProEx))
    local headIcon = itemObj.transform:Find("bg/headIcon")
    if tipData.type == thumbType.stun then
      descLabel.text = Localization:GetString("new_alliance_boss_tips_19")
      if headIcon then
        headIcon.gameObject:SetActive(true)
        local unity_icon = headIcon.gameObject:GetComponent(typeof(CS.UIPlayerHead))
        local specifiedRes
        local playerUid = tipData.uid
        local pic = tipData.headPic or tipData.pic
        local picVer = tipData.headPicVer or tipData.picVer or tipData.picver
        if pic and pic ~= "" and type(pic) == "string" then
          local pic1, pic2 = string.match(pic, "(Assets/Main/.*)(Assets/Main/.*)")
          if pic1 and pic2 then
            specifiedRes = pic2
          end
        end
        if specifiedRes then
          unity_icon:UseSpecifiedRes(specifiedRes)
        elseif not pic and not picVer then
          unity_icon:UseSystemHead()
        else
          unity_icon:SetData(tipData.uid, pic, toInt(picVer), false)
        end
        local collider = itemObj.transform:Find("bg/btn"):GetComponent(typeof(CS.TouchObjectEventTrigger))
        
        function collider.onPointerClick()
          if playerUid then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, playerUid)
          end
        end
        
        TimerManager:GetInstance():DelayInvoke(function()
          if collider then
            collider.onPointerClick = nil
          end
        end, 3)
      end
    else
      descLabel.text = Localization:GetString("new_alliance_boss_tips_20")
      if headIcon then
        headIcon.gameObject:SetActive(false)
      end
    end
    local timerId = self.TipTimerId
    local tipTimer = TimerManager:GetInstance():DelayInvoke(function()
      itemObj:GameObjectRecycle()
      self.TipTimers[timerId] = nil
    end, 1.5)
    self.TipTimers[timerId] = tipTimer
    self.TipTimerId = self.TipTimerId + 1
    table.remove(self.critTipsDatas, len)
  end
end

return AllyDrillBaseHugeSandWorm
