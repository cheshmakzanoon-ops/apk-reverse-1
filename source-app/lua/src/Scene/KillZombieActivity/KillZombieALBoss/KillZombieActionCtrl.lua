local KillZombieActionCtrl = BaseClass("KillZombieActionCtrl")
local FlyText3DManager = require("Scene.InvasionAisilla.FlyText3DManager")
local UILWTeamHeadBubble = require("UI.LWUIZoneMobilization.Scene.UILWTeamHeadBubble")
local FSM = require("Framework.Common.FSM")
local AlKirovLaunchBornState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovLaunchBornState")
local AlKirovBornState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovBornState")
local AlKirovLaunchIdleState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovLaunchIdleState")
local AlKirovLaunchRecycleState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovLaunchRecycleState")
local AlKirovIdleState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovIdleState")
local AlKirovAttackState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovAttackState")
local AlKirovChargeState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovChargeState")
local ALKirovBeHitState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.ALKirovBeHitState")
local AlKirovWeaknessState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovWeaknessState")
local AlKirovLeaveState = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieALBossState.AlKirovLeaveState")
local CS = _ENV.CS
local ResourceManager = CS.GameEntry.Resource
local UITimeManager = _ENV.UITimeManager
local Localization = CS.GameEntry.Localization
local ChallengeZombieAlBossStatus = _ENV.ChallengeZombieAlBossStatus
local baseLodIcon = "Assets/Main/Sprites/LodIcon/zyf_daditu_01.png"
local feitingLodIcon = "Assets/Main/Sprites/LodIcon/zyf_daditu_02.png"
KillZombieActionCtrl.FsmState = {
  None = 0,
  LaunchBorn = 1,
  LaunchIdle = 2,
  Recycle = 3,
  Idle = 4,
  Born = 5,
  Attack = 6,
  Charge = 7,
  BeHit = 8,
  Weakness = 9,
  Leave = 10
}
KillZombieActionCtrl.LaunchAnim = {
  Born = "born",
  Idle = "idle",
  Recycle = "recycle"
}
KillZombieActionCtrl.Anim = {
  Born = "born",
  Idle = "idle",
  Escape = "escape",
  Attack = "attack",
  BeHit = "be_hit",
  Charge = "charge",
  ChargeFail = "charge_fail",
  ChargeFailPose = "charge_fail_pose",
  Recover = "recover"
}
KillZombieActionCtrl.EffectFlag = {
  IdleLight = 1,
  IdleFire = 2,
  AttackFire = 3,
  ShieldLoop = 4,
  ShieldBeHit = 5,
  ShieldBroken = 6,
  Frenzy = 7,
  Airflow = 8,
  BornFire = 9,
  Fire1 = 10,
  Fire2 = 11,
  Fire3 = 12,
  Dizziness = 13,
  Boom = 14,
  DizzinessHit = 15
}
local LaunchAnim = KillZombieActionCtrl.LaunchAnim
local Anim = KillZombieActionCtrl.Anim
local FsmState = KillZombieActionCtrl.FsmState
local EffectFlag = KillZombieActionCtrl.EffectFlag
local EffectPath = {
  [EffectFlag.IdleLight] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_longmendiao_deng.prefab",
  [EffectFlag.IdleFire] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_longmendiao_huohua.prefab",
  [EffectFlag.AttackFire] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_jiqiang.prefab",
  [EffectFlag.ShieldLoop] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Shield_Loop_Root_M.prefab",
  [EffectFlag.ShieldBeHit] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Hit_Root_M.prefab",
  [EffectFlag.ShieldBroken] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Crack_Root_M.prefab",
  [EffectFlag.Frenzy] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Fury_Root_M.prefab",
  [EffectFlag.Airflow] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Propeller_Loop_Root_M.prefab",
  [EffectFlag.BornFire] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_born_kaihuo_blue.prefab",
  [EffectFlag.Dizziness] = "Assets/Main/Prefabs/Effect/World/Sandworm/BigSandwormStunVFX.prefab",
  [EffectFlag.Fire1] = "Assets/Main/Prefabs/World/Kirov/Eff_A_build_jiluofu_feiting_03_red_World_Fire_100p.prefab",
  [EffectFlag.Fire2] = "Assets/Main/Prefabs/World/Kirov/Eff_A_build_jiluofu_feiting_03_red_World_Fire_60p.prefab",
  [EffectFlag.Fire3] = "Assets/Main/Prefabs/World/Kirov/Eff_A_build_jiluofu_feiting_03_red_World_Fire_30p.prefab",
  [EffectFlag.Boom] = "Assets/Main/Prefabs/World/Saiji/Eff_s_S1_zibao.prefab",
  [EffectFlag.DizzinessHit] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/jiluofu2/Eff_s_jiluofu_zhanshenfeidan.prefab"
}
local worldModelPath = "Model/WorldModel"
local frenzyNodePath = "A_build_jiluofu_feiting_03_blue_frenzy"
local LAUNCH_EFFECT_ROOT = "A_build_jiluofu_longmendiao_skin/To_unity/DeformationSystem/Root"
local KIROV_EFFECT_ROOT = "A_build_jiluofu_feiting_03_skin/To_unity/DeformationSystem/Root/Roo_z/Root_M"
local ParentRoot = {
  [EffectFlag.IdleLight] = LAUNCH_EFFECT_ROOT,
  [EffectFlag.IdleFire] = LAUNCH_EFFECT_ROOT
}
local LOCAL_POS = {
  [EffectFlag.Dizziness] = {
    x = 2,
    y = 4,
    z = 0
  }
}

local function __init(self, marchInfo, transform)
  self:Init(marchInfo, transform)
end

local function __delete(self)
  self:Destroy()
  self.hpSliderPos3 = nil
  self.hpSliderScale2 = nil
  self.shieldSliderPos3 = nil
  self.shieldSliderScale2 = nil
  self.frenzySliderPos3 = nil
  self.frenzySliderScale2 = nil
end

local function Init(self, marchInfo, transform)
  self:InitData(marchInfo)
  self:InitModelData(transform)
  self:InitFsm()
  self:InitView()
end

local function InitData(self, marchInfo)
  self.marchInfo = marchInfo
  local maxDmg = 0
  if marchInfo then
    self.uuid = marchInfo.uuid
    local challengeInfo = marchInfo.allianceChallengeInfo
    self.challengeInfo = challengeInfo
    if challengeInfo then
      local configId = challengeInfo.configId
      local bossId = configId and GetTableData(TableName.activity_challenge_zombie, configId, "advanced_challenge_boss")
      if bossId then
        local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
        local dmgProgress = template and template.alliance_progress
        if dmgProgress then
          maxDmg = dmgProgress and dmgProgress[#dmgProgress] or 0
        end
      end
    end
  end
  self.maxDmg = maxDmg
  self.fsmState = FsmState.None
  self.allEffect = {}
  self.nodeGos = {}
  self.lastStatus = nil
  self.curStatus = nil
  self.stage = nil
  self.timer = nil
  self.hpSliderPos3 = Vector3.New(0, 0, 0)
  self.hpSliderScale2 = Vector2.New(1, 1)
  self.shieldSliderPos3 = Vector3.New(0, 0, 0)
  self.shieldSliderScale2 = Vector2.New(1, 1)
  self.frenzySliderPos3 = Vector3.New(0, 0, 0)
  self.frenzySliderScale2 = Vector2.New(1, 1)
  self.modelNode = nil
  self.worldModel = nil
  self.frenzyScale = LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k22", 1)
  self.headBubbleHandle = nil
  self.headBubble = nil
end

local function InitModelData(self, transform)
  self.transform = transform
  self.worldModel = transform:Find(worldModelPath)
  local modelLabel = transform:Find("Model/ModelLabel")
  self.modelLabel = modelLabel.gameObject
  self.modelLabel:SetActive(true)
  self.worldModeNode = transform:Find("Model/WorldModel")
  self.lodIcon = transform:Find("Icon/IconSprite"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hpSliderNode = modelLabel:Find("HpSlider").gameObject
  self.hpSliderNode:SetActive(false)
  self.hpSliderBar = modelLabel:Find("HpSlider/HpSliderBar")
  self.hpSliderSprite = self.hpSliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hpSliderText = modelLabel:Find("HpSlider/HpSliderText"):GetComponent(typeof(CS.SuperTextMesh))
  self.hpTitleText = modelLabel:Find("HpSlider/SliderBg/HpTitleText"):GetComponent(typeof(CS.SuperTextMesh))
  self.hpTitleText.text = Localization:GetString("challenge_zombie_alliance_score_hp")
  self.timingText = modelLabel:Find("HpSlider/TimingTextBg/HpTimingText"):GetComponent(typeof(CS.SuperTextMesh))
  self.shieldSliderNode = modelLabel:Find("ShieldHpSlider").gameObject
  self.shieldSliderNode:SetActive(false)
  self.shieldSliderBar = modelLabel:Find("ShieldHpSlider/ShieldSliderBar")
  self.shieldSliderSprite = self.shieldSliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.shieldSliderText = modelLabel:Find("ShieldHpSlider/ShieldSliderText"):GetComponent(typeof(CS.SuperTextMesh))
  self.frenzySliderNode = modelLabel:Find("FrenzyCdSlider").gameObject
  self.frenzySliderNode:SetActive(false)
  self.frenzySliderBar = modelLabel:Find("FrenzyCdSlider/FrenzySliderBar")
  self.frenzySliderSprite = self.frenzySliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.frenzySliderText = modelLabel:Find("FrenzyCdSlider/FrenzySliderText"):GetComponent(typeof(CS.SuperTextMesh))
  self.prepareTimeNode = modelLabel:Find("PrepareTime").gameObject
  self.prepareTimeNode:SetActive(false)
  self.prepareText = modelLabel:Find("PrepareTime/StateText"):GetComponent(typeof(CS.TextMeshProEx))
  self.prepareText.text = Localization:GetString("challenge_zombie_preview_time")
  self.prepareTimeText = modelLabel:Find("PrepareTime/TimeText"):GetComponent(typeof(CS.TextMeshProEx))
  local damageTextMgr = ObjectPool:GetInstance():Load(FlyText3DManager)
  self.damageTextMgr = damageTextMgr
  self.damageTextMgr:Init(self)
end

function KillZombieActionCtrl:DelayDestroy(time)
  self:ShowLeaveEffect()
  if self.delayBossEscape then
    self.delayBossEscape:Stop()
    self.delayBossEscape = nil
  end
  self.delayBossEscape = TimerManager:GetInstance():DelayInvoke(function()
    self:OnBossEscape()
    self.delayBossEscape = nil
  end, 0.3)
end

local function Destroy(self)
  if self.damageTextMgr ~= nil then
    self.damageTextMgr:Destroy()
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.delayBossEscape then
    self.delayBossEscape:Stop()
    self.delayBossEscape = nil
  end
  self:ClearLeaveEffect()
  self:ResetNode()
  self.nodeGos = nil
  self.modelNode = nil
  self.worldModel = nil
  self.simpleAnimation = nil
  self.showNodePath = nil
  self.marchInfo = nil
  self.transform = nil
  self.uuid = nil
  if self.modelLabel then
    self.modelLabel:SetActive(false)
  end
  self.modelLabel = nil
  self.hpSliderNode = nil
  self.hpSliderBar = nil
  self.hpSliderSprite = nil
  self.hpSliderText = nil
  self.timingText = nil
  self.shieldSliderNode = nil
  self.shieldSliderBar = nil
  self.shieldSliderSprite = nil
  self.shieldSliderText = nil
  self.frenzySliderNode = nil
  self.frenzySliderBar = nil
  self.frenzySliderSprite = nil
  self.frenzySliderText = nil
  self.prepareTimeNode = nil
  self.prepareText = nil
  self.prepareTimeText = nil
  self.fsmState = nil
  self:ClearEffect()
  self.maxDmg = nil
  self.lastStatus = nil
  self.curStatus = nil
  self.stage = nil
  self.challengeInfo = nil
  self.hpSliderPos3 = Vector3.New(0, 0, 0)
  self.hpSliderScale2 = Vector2.New(1, 1)
  self.shieldSliderPos3 = Vector3.New(0, 0, 0)
  self.shieldSliderScale2 = Vector2.New(1, 1)
  self.frenzySliderPos3 = Vector3.New(0, 0, 0)
  self.frenzySliderScale2 = Vector2.New(1, 1)
  self.frenzyScale = nil
  self.lodIcon = nil
  if self.headBubbleHandle then
    self.headBubbleHandle:Destroy()
    self.headBubbleHandle = nil
  end
  if self.headBubble then
    self.headBubble:Delete()
    self.headBubble = nil
  end
end

local function InitView(self)
  self.curStatus = self.challengeInfo and self.challengeInfo.curStatus or ChallengeZombieAlBossStatus.None
  self:RefreshState(self.curStatus)
  self:RefreshView()
  self.curStatus = self.challengeInfo and self.challengeInfo.curStatus
  self.lastStatus = self.curStatus
end

local function InitFsm(self)
  self.fsm = FSM.New()
  self.fsm:AddState(FsmState.LaunchBorn, AlKirovLaunchBornState.New(self))
  self.fsm:AddState(FsmState.LaunchIdle, AlKirovLaunchIdleState.New(self))
  self.fsm:AddState(FsmState.Recycle, AlKirovLaunchRecycleState.New(self))
  self.fsm:AddState(FsmState.Born, AlKirovBornState.New(self))
  self.fsm:AddState(FsmState.Idle, AlKirovIdleState.New(self))
  self.fsm:AddState(FsmState.Attack, AlKirovAttackState.New(self))
  self.fsm:AddState(FsmState.Charge, AlKirovChargeState.New(self))
  self.fsm:AddState(FsmState.BeHit, ALKirovBeHitState.New(self))
  self.fsm:AddState(FsmState.Weakness, AlKirovWeaknessState.New(self))
  self.fsm:AddState(FsmState.Leave, AlKirovLeaveState.New(self))
end

local function ChangeState(self, state, ...)
  if self.fsm then
    if self.fsmState == state then
      return
    end
    self.fsmState = state
    self.fsm:ChangeState(state, ...)
  end
end

local function RefreshMarchInfo(self, marchInfo)
  self.marchInfo = marchInfo
  self.uuid = marchInfo and marchInfo.uuid
  local challengeInfo = marchInfo and marchInfo.allianceChallengeInfo
  self.challengeInfo = challengeInfo
  if self.maxDmg == nil or self.maxDmg == 0 then
    local maxDmg = 0
    if challengeInfo then
      local configId = challengeInfo.configId
      local bossId = configId and GetTableData(TableName.activity_challenge_zombie, configId, "advanced_challenge_boss")
      if bossId then
        local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
        local dmgProgress = template and template.alliance_progress
        if dmgProgress then
          maxDmg = dmgProgress and dmgProgress[#dmgProgress] or 0
        end
      end
    end
    self.maxDmg = maxDmg
  end
  if self.marchInfo == nil or self.challengeInfo == nil then
    self.modelLabel:SetActive(false)
  end
  self:InitView()
end

local function RefreshView(self)
  if self.challengeInfo and self.fsmState then
    local curStatus = self.curStatus
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curStatus == ChallengeZombieAlBossStatus.Prepare then
      local offsetTime = self.challengeInfo.statusEndTime - curTime
      if offsetTime <= 0 then
        self.prepareTimeNode:SetActive(false)
      else
        self.prepareTimeText.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(offsetTime)
        self.prepareTimeNode:SetActive(true)
      end
    else
      self.prepareTimeNode:SetActive(false)
      self.hpSliderNode:SetActive(true)
      self:RefreshHpSlider()
      local offsetTime = self.challengeInfo.endTime - curTime
      if 0 < offsetTime then
        local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(offsetTime)
        self.timingText.text = timeStr
      end
      if curStatus == ChallengeZombieAlBossStatus.Normal then
        self:SetChargeGroupActive(false)
        self:SetFrenzyGroupActive(false)
      elseif curStatus == ChallengeZombieAlBossStatus.Frenzy then
        self:RefreshFrenzySlider(curTime)
        self:SetChargeGroupActive(false)
        self:SetFrenzyGroupActive(true)
      elseif curStatus == ChallengeZombieAlBossStatus.Charge then
        self:RefreshChargeHpSlider(curTime)
        self:SetChargeGroupActive(true)
        self:SetFrenzyGroupActive(false)
      elseif curStatus == ChallengeZombieAlBossStatus.ChargeWaiting then
        self:SetChargeGroupActive(true)
        self.shieldSliderNode:SetActive(false)
        self:SetFrenzyGroupActive(false)
      elseif curStatus == ChallengeZombieAlBossStatus.Weakness then
        self:SetChargeGroupActive(false)
        self:SetFrenzyGroupActive(false)
      end
    end
  end
end

local function RefreshState(self, curStatus)
  if self.challengeInfo then
    if curStatus == ChallengeZombieAlBossStatus.Prepare then
      self:ChangeModel("A_build_jiluofu_longmendiao_blue")
      if self.simpleAnimation then
        local length = self.simpleAnimation:GetClipLength(LaunchAnim.Born)
        local startTime = self.challengeInfo.statusStartTime
        local endTime = self.challengeInfo.statusEndTime
        local curTs = UITimeManager:GetInstance():GetServerTime()
        if 0 < startTime and curTs - startTime < length * 1000 then
          self:ChangeState(FsmState.LaunchBorn, endTime)
        else
          length = self.simpleAnimation:GetClipLength(LaunchAnim.Recycle)
          local remain = endTime - curTs
          if 0 < endTime and remain > length / 2 * 1000 and remain <= length * 1000 then
            self:ChangeState(FsmState.Recycle)
          else
            self:ChangeState(FsmState.LaunchIdle, endTime)
          end
        end
      else
        self:ChangeState(FsmState.LaunchIdle, self.challengeInfo.statusEndTime)
      end
      self.lodIcon:LoadSprite(baseLodIcon)
    else
      if self.lastStatus == ChallengeZombieAlBossStatus.Frenzy and curStatus ~= ChallengeZombieAlBossStatus.Frenzy then
        self:RefreshFrenzyEffect(false)
      end
      if curStatus == ChallengeZombieAlBossStatus.Frenzy then
        self:RefreshFrenzyEffect(true)
      else
        self:ChangeModel("A_build_jiluofu_feiting_03_blue")
        if curStatus == ChallengeZombieAlBossStatus.Normal then
          if self.fsmState == nil or self.fsmState < FsmState.Idle then
            self:ChangeState(FsmState.Idle)
          end
        elseif curStatus == ChallengeZombieAlBossStatus.Charge or curStatus == ChallengeZombieAlBossStatus.ChargeWaiting then
          self:ChangeState(FsmState.Charge)
        elseif curStatus == ChallengeZombieAlBossStatus.Weakness then
          self:ChangeState(FsmState.Weakness, self.challengeInfo.statusStartTime, self.challengeInfo.statusEndTime)
        end
      end
      local count = self.challengeInfo.count
      if count == 1 then
        self:PlayEffect(EffectFlag.Fire3)
      elseif count == 2 then
        self:RemoveEffect(EffectFlag.Fire3)
        self:PlayEffect(EffectFlag.Fire2)
      elseif count == 3 then
        self:RemoveEffect(EffectFlag.Fire2)
        self:PlayEffect(EffectFlag.Fire1)
      end
      self.lodIcon:LoadSprite(feitingLodIcon)
    end
  end
end

local function SetChargeGroupActive(self, active)
  self.shieldSliderNode:SetActive(active)
  self:RefreshShieldEffect(active)
end

local function SetFrenzyGroupActive(self, active)
  self.frenzySliderNode:SetActive(active)
end

local function RefreshHpSlider(self)
  if self.marchInfo and self.challengeInfo then
    local sliderValue = 0
    local curDmg = self.challengeInfo.allianceDamage
    if 0 < self.maxDmg then
      sliderValue = Mathf.Clamp01(curDmg / self.maxDmg)
    end
    local localPosition = self.hpSliderBar.localPosition
    self.hpSliderPos3.x = (sliderValue - 1) * 4 / 2
    self.hpSliderPos3.y = localPosition.y
    self.hpSliderBar.localPosition = self.hpSliderPos3
    self.hpSliderScale2.x = sliderValue * 4
    self.hpSliderScale2.y = 0.43
    self.hpSliderSprite.size = self.hpSliderScale2
    self.hpSliderText.text = string.GetFormattedGiga2(curDmg)
  end
end

local function RefreshChargeHpSlider(self, curTime)
  if self.challengeInfo then
    local sliderValue = 0
    local startTime = self.challengeInfo.statusStartTime
    local endTime = self.challengeInfo.statusEndTime
    if 0 < startTime and 0 < endTime then
      local shieldMaxHp = endTime - startTime
      local curPros = curTime - startTime
      if 0 <= curPros and shieldMaxHp >= curPros and 0 <= shieldMaxHp then
        sliderValue = curPros / shieldMaxHp
        sliderValue = Mathf.Clamp01(curPros / shieldMaxHp)
        local localPosition = self.shieldSliderBar.localPosition
        self.shieldSliderPos3.x = (sliderValue - 1) * 6.98 / 2
        self.shieldSliderPos3.y = localPosition.y
        self.shieldSliderBar.localPosition = self.shieldSliderPos3
        self.shieldSliderScale2.x = sliderValue * 6.98
        self.shieldSliderScale2.y = 0.41
        self.shieldSliderSprite.size = self.shieldSliderScale2
        local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(endTime - curTime)
        self.shieldSliderText.text = timeStr
      end
    else
      self.shieldSliderNode:SetActive(false)
    end
  end
end

local function RefreshFrenzySlider(self, curTs)
  if self.challengeInfo and curTs then
    local sliderValue = 1
    local startTime = self.challengeInfo.statusStartTime
    local endTime = self.challengeInfo.statusEndTime
    if 0 < startTime and 0 < endTime then
      local maxPros = endTime - startTime
      local curPros = maxPros - (curTs - startTime)
      if 0 <= curPros and maxPros >= curPros and 0 < maxPros then
        sliderValue = Mathf.Clamp01(curPros / maxPros)
        local localPosition = self.frenzySliderBar.localPosition
        local width = 6.95
        self.frenzySliderPos3.x = (sliderValue - 1) * width / 2
        self.frenzySliderPos3.y = localPosition.y
        self.frenzySliderBar.localPosition = self.frenzySliderPos3
        self.frenzySliderScale2.x = sliderValue * width
        self.frenzySliderScale2.y = 0.35
        self.frenzySliderSprite.size = self.frenzySliderScale2
        local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(endTime - curTs)
        self.frenzySliderText.text = timeStr
      else
        self.frenzySliderNode:SetActive(false)
      end
    end
  end
end

local function OnUpdateSec(self)
  self:RefreshView()
end

local function OnUpdate(self)
  if self.damageTextMgr then
    self.damageTextMgr:OnUpdate()
  end
  if self.fsm then
    self.fsm:OnUpdate()
  end
end

local function OnHurt(self, t)
  local dmg = t.lostHp or 0
  self:ShowDamageText(dmg, 1)
  if t.players then
    self:PlayHeadBubble(t.players)
  end
  if self.fsmState == FsmState.Idle then
    self:ChangeState(FsmState.BeHit)
  elseif self.fsmState == FsmState.Charge then
    self:ChangeState(FsmState.BeHit, true)
  end
end

local function OnBossEscape(self)
  self.modelLabel:SetActive(false)
  self:ChangeState(FsmState.Leave)
end

local function ChangeAttackState(self)
  self:ChangeState(FsmState.Attack, self.curStatus)
end

local function PlayAnimation(self, animName, callback)
  if self.simpleAnimation == nil then
    return
  end
  if string.IsNullOrEmpty(animName) then
    return
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if callback then
    local length = self.simpleAnimation:GetClipLength(animName)
    if 0 < length then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        callback()
        if self.timer then
          self.timer:Stop()
          self.timer = nil
        end
      end, length)
    else
      callback()
    end
  end
  if self.simpleAnimation:IsPlaying(animName) then
    self.simpleAnimation:Rewind(animName)
  end
  self.simpleAnimation:Play(animName)
end

local function PlayEffect(self, flag, duration, callback, finishCb)
  if flag then
    if self.allEffect == nil then
      return
    end
    return self:InstantiateAsync(flag, duration, callback, finishCb)
  end
end

local function InstantiateAsync(self, flag, duration, callback, finishCb)
  local path = EffectPath[flag]
  if path then
    local data = self.allEffect[flag]
    if not data then
      data = {}
      self.allEffect[flag] = data
    else
      self:RemoveEffect(flag)
    end
    local req = CS.GameEntry.Resource:InstantiateAsync(path)
    data.request = req
    req:completed("+", function(req)
      if req.isError then
        req:Destroy()
        return
      end
      if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.World then
        req:Destroy()
        return
      end
      local go = req.gameObject
      local tf = go.transform
      tf.localScale = VecZero
      if flag == EffectFlag.DizzinessHit then
        if IsNotNull(self.worldModel) then
          tf.parent = self.worldModel.transform
        elseif self.modelNode then
          tf.parent = self.modelNode.transform
        end
      elseif self.modelNode then
        local parentPath = ParentRoot[flag]
        parentPath = parentPath or KIROV_EFFECT_ROOT
        local parent = self.modelNode.transform:Find(parentPath)
        if parent then
          tf.parent = parent
        end
      end
      local localPos = LOCAL_POS[flag] or ResetPosition
      tf:Set_localPosition(localPos.x, localPos.y, localPos.z)
      tf:Set_localRotation(0, 0, 0, 1)
      go:SetActive(true)
      if callback then
        callback()
      end
      tf.localScale = ResetScale
      if duration and 0 < duration then
        local timer = TimerManager:GetInstance():DelayInvoke(function()
          if finishCb then
            finishCb()
          end
          self:RemoveEffect(flag)
        end, duration)
        data.delayTimer = timer
      end
      data.effectObj = req.gameObject
    end)
    return req
  end
end

local function RemoveEffect(self, flag)
  if self.allEffect then
    local data = self.allEffect[flag]
    if data ~= nil then
      if data.delayTimer then
        data.delayTimer:Stop()
        data.delayTimer = nil
      end
      if data.request then
        data.request:Destroy()
        data.request = nil
      end
      data.effectObj = nil
    end
  end
end

local function ClearEffect(self)
  if self.allEffect then
    for _, v in pairs(self.allEffect) do
      if v then
        if v.delayTimer then
          v.delayTimer:Stop()
          v.delayTimer = nil
        end
        if v.request then
          v.request:Destroy()
          v.request = nil
        end
        v.effectObj = nil
      end
    end
    self.allEffect = nil
  end
end

local function ChangeModel(self, showModelData)
  if self.showNodePath == showModelData then
    return
  end
  self:ResetNode()
  if not string.IsNullOrEmpty(showModelData) then
    local go = self.nodeGos[showModelData]
    if IsNull(go) then
      local trans = self.worldModel:Find(showModelData)
      if not IsNull(trans) then
        go = trans.gameObject
        go:SetActive(true)
        self.modelNode = go
        self.nodeGos[showModelData] = go
      end
    else
      go:SetActive(true)
      self.modelNode = go
    end
  end
  self.showNodePath = showModelData
  self.simpleAnimation = self.modelNode and self.modelNode:GetComponentInChildren(typeof(CS.SimpleAnimation))
end

local function ResetNode(self)
  if self.modelNode then
    self.modelNode:SetActive(false)
    self.modelNode = nil
  end
  self.simpleAnimation = nil
end

local function ShowKirovNode(self)
  if self.modelNode then
    local nodePath = "A_build_jiluofu_longmendiao_skin/To_unity/DeformationSystem/Root/GuaDian/A_build_jiluofu_feiting_03_blue"
    local node = self.modelNode.transform:Find(nodePath)
    if node then
      node.gameObject:SetActive(true)
    end
  end
end

local function GetAnimLength(self, anim)
  local length = self.simpleAnimation and self.simpleAnimation:GetClipLength(anim) or 0
  return length
end

local function RefreshShieldEffect(self, show)
  if show then
    self:PlayEffect(EffectFlag.ShieldLoop)
  else
    if self.lastStatus == ChallengeZombieAlBossStatus.Charge or self.lastStatus == ChallengeZombieAlBossStatus.ChargeWaiting then
      self:PlayEffect(EffectFlag.ShieldBroken, 5)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_break, false)
    end
    self:RemoveEffect(EffectFlag.ShieldLoop)
    self:RemoveEffect(EffectFlag.ShieldBeHit)
  end
end

local function RefreshFrenzyEffect(self, show)
  if show then
    self:ChangeModel(frenzyNodePath)
    if self.worldModel then
      self.worldModel.transform.localScale = Vector3.one * self.frenzyScale
    end
    self:PlayEffect(EffectFlag.Frenzy)
  else
    self:RemoveEffect(EffectFlag.Frenzy)
    if self.worldModel then
      self.worldModel.transform.localScale = Vector3.one
    end
    self:ChangeModel("A_build_jiluofu_feiting_03_blue")
  end
  self:ChangeState(FsmState.Idle)
end

local function ShowDamageText(self, damage, time)
  if damage and 0 < damage and time and 0 < time then
    local pos = self.hpSliderNode.transform.position
    local param = self.damageTextMgr:GetParam()
    local style = 1 < damage and FlyText3DType.Crit or FlyText3DType.Normal
    param.style = style
    param.damage = damage
    param.position = Vector3.New(pos.x + 4, pos.y, pos.z)
    param.duration = time
    param.hasOffset = true
    self.damageTextMgr:GenText(param)
  end
end

local function PlayHeadBubble(self, param)
  if param == nil then
    return
  end
  if self.headBubble then
    self.headBubble:Refresh(param)
    if self.headBubbleHandle then
      local trans = self.headBubbleHandle.gameObject.transform
      local pos = self.transform.position
      trans.position = Vector3.New(pos.x, pos.y + 1.28, pos.z)
    end
    return
  end
  if self.headBubbleHandle then
    return
  end
  local headBubbleHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWUIZoneMobilization/Component/UILWTeamHeadBubble.prefab")
  headBubbleHandle:completed("+", function(handle)
    local bubble
    local ok, msg = xpcall(function()
      local trans = handle.gameObject.transform
      bubble = UILWTeamHeadBubble.New(param, trans)
      trans:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
      local pos = self.transform.position
      trans.position = Vector3.New(pos.x, pos.y + 1.28, pos.z)
    end, debug.traceback)
    if ok and bubble ~= nil then
      self.headBubble = bubble
    else
      Logger.LogError(msg)
      ok, msg = xpcall(function()
        if bubble ~= nil then
          bubble:Dispose()
        end
      end, debug.traceback)
      if not ok and handle and not IsNull(handle.gameObject) then
        handle.gameObject:SetActive(false)
      end
    end
  end)
  self.headBubbleHandle = headBubbleHandle
end

function KillZombieActionCtrl:ShowLeaveEffect()
  local prefabName = "Assets/Main/Prefabs/Effect/World/Jiluofu/Eff_jiluofu_feiting_chuansong_shangsheng_blue.prefab"
  self:ClearLeaveEffect()
  self.leaveEffectReq = ResourceManager:InstantiateAsync(prefabName)
  self.leaveEffectReq:completed("+", function()
    if self.leaveEffectReq.isError then
      return
    end
    local go = self.leaveEffectReq.gameObject
    go.transform:SetParent(self.worldModeNode.transform)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_positionY(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_localScale(1, 1, 1)
    go:SetActive(true)
  end)
end

function KillZombieActionCtrl:ClearLeaveEffect()
  if self.leaveEffectReq then
    self.leaveEffectReq:Destroy()
    self.leaveEffectReq = nil
  end
end

KillZombieActionCtrl.__init = __init
KillZombieActionCtrl.__delete = __delete
KillZombieActionCtrl.Init = Init
KillZombieActionCtrl.InitModelData = InitModelData
KillZombieActionCtrl.InitData = InitData
KillZombieActionCtrl.InitFsm = InitFsm
KillZombieActionCtrl.Destroy = Destroy
KillZombieActionCtrl.RefreshMarchInfo = RefreshMarchInfo
KillZombieActionCtrl.RefreshView = RefreshView
KillZombieActionCtrl.OnUpdateSec = OnUpdateSec
KillZombieActionCtrl.RefreshHpSlider = RefreshHpSlider
KillZombieActionCtrl.ShowDamageText = ShowDamageText
KillZombieActionCtrl.PlayAnimation = PlayAnimation
KillZombieActionCtrl.OnUpdate = OnUpdate
KillZombieActionCtrl.OnHurt = OnHurt
KillZombieActionCtrl.RefreshState = RefreshState
KillZombieActionCtrl.InitView = InitView
KillZombieActionCtrl.PlayEffect = PlayEffect
KillZombieActionCtrl.InstantiateAsync = InstantiateAsync
KillZombieActionCtrl.RemoveEffect = RemoveEffect
KillZombieActionCtrl.ClearEffect = ClearEffect
KillZombieActionCtrl.OnBossEscape = OnBossEscape
KillZombieActionCtrl.ChangeState = ChangeState
KillZombieActionCtrl.RefreshChargeHpSlider = RefreshChargeHpSlider
KillZombieActionCtrl.RefreshFrenzySlider = RefreshFrenzySlider
KillZombieActionCtrl.ChangeModel = ChangeModel
KillZombieActionCtrl.ResetNode = ResetNode
KillZombieActionCtrl.ShowKirovNode = ShowKirovNode
KillZombieActionCtrl.GetAnimLength = GetAnimLength
KillZombieActionCtrl.ChangeAttackState = ChangeAttackState
KillZombieActionCtrl.RefreshShieldEffect = RefreshShieldEffect
KillZombieActionCtrl.RefreshFrenzyEffect = RefreshFrenzyEffect
KillZombieActionCtrl.SetChargeGroupActive = SetChargeGroupActive
KillZombieActionCtrl.SetFrenzyGroupActive = SetFrenzyGroupActive
KillZombieActionCtrl.PlayHeadBubble = PlayHeadBubble
return KillZombieActionCtrl
