local ZMBossActionCtrl = BaseClass("ZMBossActionCtrl")
local FlyText3DManager = require("Scene.InvasionAisilla.FlyText3DManager")
local UILWTeamHeadBubble = require("UI.LWUIZoneMobilization.Scene.UILWTeamHeadBubble")
local FSM = require("Framework.Common.FSM")
local LandingState = require("Scene.ZoneMobilization.ZMBoss.ZMBossState.ZMBossLandingState")
local TransmittingState = require("Scene.ZoneMobilization.ZMBoss.ZMBossState.ZMBossTransmittingState")
local IdleState = require("Scene.ZoneMobilization.ZMBoss.ZMBossState.ZMBossIdleState")
local DeathState = require("Scene.ZoneMobilization.ZMBoss.ZMBossState.ZMBossDeathState")
local MoveAwayState = require("Scene.ZoneMobilization.ZMBoss.ZMBossState.ZMBossMoveAwayState")
local AttackState = require("Scene.ZoneMobilization.ZMBoss.ZMBossState.ZMBossAttackState")
local BeHitState = require("Scene.ZoneMobilization.ZMBoss.ZMBossState.ZMBossBeHitState")
local CS = _ENV.CS
local UITimeManager = _ENV.UITimeManager
local Localization = CS.GameEntry.Localization
ZMBossActionCtrl.ActState = {
  None = 0,
  Transmitting = 1,
  Idle = 2,
  Landing = 3,
  Death = 4,
  MoveAway = 5,
  Attack = 6,
  BeHit = 7
}
ZMBossActionCtrl.Anim = {
  Born = "born",
  Idle = "idle",
  Death = "death",
  Attack = "attack",
  BeHit = "be_hit",
  Transmitting = "transmitting"
}
ZMBossActionCtrl.EffectFlag = {
  Transmitting = 1,
  Landing = 2,
  Fire = 3,
  ShieldLoop = 4,
  ShieldBeHit = 5,
  ShieldBroken = 6,
  Frenzy = 7,
  Airflow = 8,
  BornFire = 9,
  Death = 10,
  DeathBoom = 11
}
local Anim = ZMBossActionCtrl.Anim
local ActState = ZMBossActionCtrl.ActState
local EffectFlag = ZMBossActionCtrl.EffectFlag
local BossState = {
  None = 0,
  Normal = 1,
  Shield = 2,
  Frenzy = 4
}
local EffectPath = {
  [EffectFlag.Transmitting] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_chuansong_loop_down_%s.prefab",
  [EffectFlag.Landing] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_chuansong_born_%s.prefab",
  [EffectFlag.Fire] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_jiqiang.prefab",
  [EffectFlag.ShieldLoop] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Shield_Loop_Root_M.prefab",
  [EffectFlag.ShieldBeHit] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Hit_Root_M.prefab",
  [EffectFlag.ShieldBroken] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Crack_Root_M.prefab",
  [EffectFlag.Frenzy] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Fury_Root_M.prefab",
  [EffectFlag.Airflow] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/hudun/Eff_s_jiluofu_feiting_Propeller_Loop_Root_M.prefab",
  [EffectFlag.BornFire] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_born_kaihuo_%s.prefab",
  [EffectFlag.Death] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_dead_01_root.prefab",
  [EffectFlag.DeathBoom] = "Assets/_Art_LastWar/Effect/Prefab/S1/Eff_s_S1_zibao.prefab"
}
local DefaultSliderHeight = 4.2
local SecondSliderHeight = 3.2
local worldModelPath = "Model/WorldModel"
local delTextPath = "Assets/Main/Prefabs/UI/Common/UIWorldMonsterDelText.prefab"
local shield_timing_text_path = "ModelLabel/ShieldHpSlider/TimingTextBg/ShieldTimingText"
local eff_ui_zone_bloodbar_daodan_path = "ModelLabel/HpSlider/SliderBg/Eff_ui_zone_bloodbar_daodan"
local frenzyNodePath = "A_build_jiluofu_feiting_03_%s_frenzy"
local effect_root_path = "A_build_jiluofu_feiting_03_skin/To_unity/DeformationSystem/Root/Roo_z/Root_M"
local ParentRoot = {
  [EffectFlag.Transmitting] = "A_build_jiluofu_feiting_03_skin",
  [EffectFlag.Landing] = "A_build_jiluofu_feiting_03_skin",
  [EffectFlag.Death] = "A_build_jiluofu_feiting_03_skin/To_unity/DeformationSystem/Root"
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
  local maxHp = 0
  if marchInfo then
    self.uuid = marchInfo.uuid
    local zMBossInfo = marchInfo.zMBossInfo
    self.zMBossInfo = zMBossInfo
    local isSelf = zMBossInfo and zMBossInfo.bossSrcServer == LuaEntry.Player:GetSourceServerId()
    self.suffix = isSelf and "blue" or "red"
    if zMBossInfo and 0 < zMBossInfo.zMBossId then
      maxHp = GetTableData(TableName.ZoneMobilizationBoss, zMBossInfo.zMBossId, "rallyboss_hp")
    end
  end
  self.actState = ActState.None
  self.allEffect = {}
  self.nodeGos = {}
  self.deadTextReq = nil
  self.maxHp = maxHp
  self.state = nil
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
  self.modelLabel = self.transform:Find("ModelLabel").gameObject
  self.modelLabel:SetActive(true)
  self.hpSliderNode = self.transform:Find("ModelLabel/HpSlider").gameObject
  self.hpSliderNode:SetActive(false)
  self.hpSliderBar = self.transform:Find("ModelLabel/HpSlider/HpSliderBar")
  self.hpSliderSprite = self.hpSliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hpSliderText = self.transform:Find("ModelLabel/HpSlider/HpSliderText"):GetComponent(typeof(CS.SuperTextMesh))
  self.timingText = self.transform:Find("ModelLabel/HpSlider/TimingTextBg/HpTimingText"):GetComponent(typeof(CS.SuperTextMesh))
  self.shieldSliderNode = self.transform:Find("ModelLabel/ShieldHpSlider").gameObject
  self.shieldSliderNode:SetActive(false)
  self.shieldSliderBar = self.transform:Find("ModelLabel/ShieldHpSlider/ShieldSliderBar")
  self.shieldSliderSprite = self.shieldSliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.shieldSliderText = self.transform:Find("ModelLabel/ShieldHpSlider/ShieldSliderText"):GetComponent(typeof(CS.SuperTextMesh))
  self.shieldTimingText = self.transform:Find(shield_timing_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.frenzySliderNode = self.transform:Find("ModelLabel/FrenzyCdSlider").gameObject
  self.frenzySliderNode:SetActive(false)
  self.frenzySliderBar = self.transform:Find("ModelLabel/FrenzyCdSlider/FrenzySliderBar")
  self.frenzySliderSprite = self.frenzySliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.frenzySliderText = self.transform:Find("ModelLabel/FrenzyCdSlider/FrenzySliderText"):GetComponent(typeof(CS.SuperTextMesh))
  self.eff_ui_zone_bloodbar_daodan = self.transform:Find(eff_ui_zone_bloodbar_daodan_path).gameObject
  self.prepareTimeNode = self.transform:Find("ModelLabel/PrepareTime").gameObject
  self.prepareTimeNode:SetActive(false)
  self.prepareText = self.transform:Find("ModelLabel/PrepareTime/StateText"):GetComponent(typeof(CS.TextMeshProEx))
  self.prepareText.text = Localization:GetString("zone_mobilization_challenge_count")
  self.prepareTimeText = self.transform:Find("ModelLabel/PrepareTime/TimeText"):GetComponent(typeof(CS.TextMeshProEx))
  local damageTextMgr = ObjectPool:GetInstance():Load(FlyText3DManager)
  self.damageTextMgr = damageTextMgr
  self.damageTextMgr:Init(self)
end

local function Destroy(self)
  if self.damageTextMgr ~= nil then
    self.damageTextMgr:Delete()
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:ResetNode()
  self.suffix = nil
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
  self.shieldTimingText = nil
  self.frenzySliderNode = nil
  self.frenzySliderBar = nil
  self.frenzySliderSprite = nil
  self.frenzySliderText = nil
  self.eff_ui_zone_bloodbar_daodan = nil
  self.prepareTimeNode = nil
  self.prepareText = nil
  self.prepareTimeText = nil
  self.actState = nil
  if self.deadTextReq then
    self.deadTextReq:Destroy()
    self.deadTextReq = nil
  end
  self:ClearEffect()
  self.maxHp = nil
  self.state = nil
  self.stage = nil
  self.zMBossInfo = nil
  self.hpSliderPos3 = Vector3.New(0, 0, 0)
  self.hpSliderScale2 = Vector2.New(1, 1)
  self.shieldSliderPos3 = Vector3.New(0, 0, 0)
  self.shieldSliderScale2 = Vector2.New(1, 1)
  self.frenzySliderPos3 = Vector3.New(0, 0, 0)
  self.frenzySliderScale2 = Vector2.New(1, 1)
  self.frenzyScale = nil
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
  self:RefreshState()
  self:RefreshView()
  self.stage = self.zMBossInfo and self.zMBossInfo.stage
end

local function InitFsm(self)
  self.fsm = FSM.New()
  self.fsm:AddState(ActState.Landing, LandingState.New(self))
  self.fsm:AddState(ActState.Transmitting, TransmittingState.New(self))
  self.fsm:AddState(ActState.Idle, IdleState.New(self))
  self.fsm:AddState(ActState.Death, DeathState.New(self))
  self.fsm:AddState(ActState.MoveAway, MoveAwayState.New(self))
  self.fsm:AddState(ActState.Attack, AttackState.New(self))
  self.fsm:AddState(ActState.BeHit, BeHitState.New(self))
end

local function ChangeState(self, state, ...)
  if self.fsm then
    if self.actState == state then
      return
    end
    self.actState = state
    self.fsm:ChangeState(state, ...)
  end
end

local function RefreshMarchInfo(self, marchInfo)
  self.marchInfo = marchInfo
  self.zMBossInfo = marchInfo and marchInfo.zMBossInfo
  if self.marchInfo == nil or self.zMBossInfo == nil then
    self.modelLabel:SetActive(false)
  end
  self:InitView()
end

local function RefreshView(self)
  if self.zMBossInfo and self.actState then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.state == BossState.None then
      local offsetTime = self.zMBossInfo.transferEndTime - curTime
      if offsetTime <= 0 or self.actState == ActState.Landing then
        self.prepareTimeNode:SetActive(false)
      else
        self.prepareTimeText.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(offsetTime)
      end
    else
      local offsetTime = self.marchInfo.refreshTime - curTime
      if 0 < offsetTime then
        local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(offsetTime)
        self.timingText.text = timeStr
      end
      if self.state == BossState.Normal | BossState.Frenzy then
        self:RefreshFrenzySlider(curTime)
      elseif self.state == BossState.Normal | BossState.Shield then
        self:RefreshShieldTimingText(curTime)
      elseif self.state == BossState.Normal | BossState.Shield | BossState.Frenzy then
        self:RefreshFrenzySlider(curTime)
        self:RefreshShieldTimingText(curTime)
      end
    end
  end
end

local function RefreshState(self)
  if self.zMBossInfo then
    local stageType = DataCenter.LWZoneMobilizationManager:GetStageType(self.zMBossInfo.stage)
    self:RefreshUIShow(stageType)
    if stageType == ZoneMobilizationStageType.Battle_Transfer then
      self:ChangeToTransmittingState()
    elseif stageType == ZoneMobilizationStageType.Battle then
      if self.actState and self.actState > ActState.Idle then
        return
      end
      self:ChangeState(ActState.Idle)
    end
  end
end

local function RefreshUIShow(self, stageType)
  if self.zMBossInfo then
    local shieldHp = self.zMBossInfo.shieldHp
    local shieldEndTime = self.zMBossInfo.shieldEndTime
    local frenzyEndTime = self.zMBossInfo.frenzyEndTime
    local state1 = 0 < shieldEndTime and 0 < shieldHp and BossState.Shield or 0
    local state2 = 0 < frenzyEndTime and BossState.Frenzy or 0
    local state = state1 | state2
    local state3 = stageType == ZoneMobilizationStageType.Battle and BossState.Normal or BossState.None
    state = state | state3
    if self.state ~= state then
      if state == BossState.None then
        self.prepareTimeNode:SetActive(true)
      else
        self.prepareTimeNode:SetActive(false)
        self.hpSliderNode:SetActive(true)
        self:RefreshHpSlider()
        if state == BossState.Normal then
          self:SetShieldGroupActive(false)
          self:SetFrenzyGroupActive(false)
        elseif state == BossState.Normal | BossState.Shield then
          self:SetShieldGroupActive(true)
          self:SetFrenzyGroupActive(false)
          self.shieldSliderNode.transform.localPosition = Vector3.New(0, DefaultSliderHeight, 0)
        elseif state == BossState.Normal | BossState.Frenzy then
          self:SetShieldGroupActive(false)
          self:SetFrenzyGroupActive(true)
          self.frenzySliderNode.transform.localPosition = Vector3.New(0, DefaultSliderHeight, 0)
          self:RefreshHpSlider()
        elseif state == BossState.Normal | BossState.Shield | BossState.Frenzy then
          self:SetShieldGroupActive(true)
          self:SetFrenzyGroupActive(true)
          self.shieldSliderNode.transform.localPosition = Vector3.New(0, SecondSliderHeight, 0)
        end
      end
      self.state = state
      if self.state == BossState.Normal | BossState.Frenzy or self.state == BossState.Normal | BossState.Shield | BossState.Frenzy then
        self:RefreshFrenzyEffect(true)
      else
        self:RefreshFrenzyEffect(false)
      end
    end
  end
  self:RefreshSlider()
end

local function SetShieldGroupActive(self, active)
  self.shieldSliderNode:SetActive(active)
  self.eff_ui_zone_bloodbar_daodan:SetActive(active)
  local lastState = self.state
  self:RefreshShieldEffect(active, lastState)
  if active and lastState ~= nil and lastState ~= BossState.None then
    local duration = LuaEntry.DataConfig:TryGetNum("lock_banner", "k5", 1)
    self:PlayPlotBubble3D(duration)
  end
end

local function SetFrenzyGroupActive(self, active)
  self.frenzySliderNode:SetActive(active)
end

local function RefreshSlider(self)
  if self.state == BossState.Normal then
    self:RefreshHpSlider()
  elseif self.state == BossState.Normal | BossState.Shield then
    self:RefreshShieldHpSlider()
  elseif self.state == BossState.Normal | BossState.Shield | BossState.Frenzy then
    self:RefreshHpSlider()
    self:RefreshShieldHpSlider()
  end
end

local function RefreshHpSlider(self)
  if self.marchInfo and self.zMBossInfo then
    local sliderValue = 0
    local curHp = self.marchInfo.curHp
    if curHp <= self.maxHp and 0 < self.maxHp then
      sliderValue = curHp / self.maxHp
      sliderValue = sliderValue < 1 and sliderValue or 1
    end
    local localPosition = self.hpSliderBar.localPosition
    self.hpSliderPos3.x = (sliderValue - 1) * 4.33 / 2
    self.hpSliderPos3.y = localPosition.y
    self.hpSliderBar.localPosition = self.hpSliderPos3
    self.hpSliderScale2.x = sliderValue * 4.33
    self.hpSliderScale2.y = 0.41
    self.hpSliderSprite.size = self.hpSliderScale2
    self.hpSliderText.text = self.marchInfo.curHp .. "/" .. self.maxHp
  end
end

local function RefreshShieldHpSlider(self)
  if self.zMBossInfo then
    local sliderValue = 0
    local shieldHp = self.zMBossInfo.shieldHp
    local shieldMaxHp = self.zMBossInfo.shieldMaxHp
    if shieldHp <= shieldMaxHp and 0 < shieldMaxHp then
      sliderValue = shieldHp / shieldMaxHp
      sliderValue = sliderValue < 1 and sliderValue or 1
      local localPosition = self.shieldSliderBar.localPosition
      self.shieldSliderPos3.x = (sliderValue - 1) * 6.98 / 2
      self.shieldSliderPos3.y = localPosition.y
      self.shieldSliderBar.localPosition = self.shieldSliderPos3
      self.shieldSliderScale2.x = sliderValue * 6.98
      self.shieldSliderScale2.y = 0.41
      self.shieldSliderSprite.size = self.shieldSliderScale2
      self.shieldSliderText.text = shieldHp .. "/" .. shieldMaxHp
    end
  end
end

local function RefreshShieldTimingText(self, curTs)
  if self.zMBossInfo and curTs then
    local shieldEndTime = self.zMBossInfo.shieldEndTime
    if curTs <= shieldEndTime and 0 < shieldEndTime then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(shieldEndTime - curTs)
      self.shieldTimingText.text = timeStr
    else
      self.shieldSliderNode:SetActive(false)
    end
  end
end

local function RefreshFrenzySlider(self, curTs)
  if self.zMBossInfo and curTs then
    local sliderValue = 1
    local frenzyEndTime = self.zMBossInfo.frenzyEndTime
    local frenzyDuration = self.zMBossInfo.frenzyDuration * 1000
    if curTs <= frenzyEndTime and 0 < frenzyEndTime then
      sliderValue = (frenzyEndTime - curTs) / frenzyDuration
      sliderValue = sliderValue < 1 and sliderValue or 1
      local localPosition = self.frenzySliderBar.localPosition
      local width = 6.95
      self.frenzySliderPos3.x = (sliderValue - 1) * width / 2
      self.frenzySliderPos3.y = localPosition.y
      self.frenzySliderBar.localPosition = self.frenzySliderPos3
      self.frenzySliderScale2.x = sliderValue * width
      self.frenzySliderScale2.y = 0.35
      self.frenzySliderSprite.size = self.frenzySliderScale2
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(frenzyEndTime - curTs)
      self.frenzySliderText.text = timeStr
    else
      self.frenzySliderNode:SetActive(false)
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

local function PlayBeAttackAnimation(self)
  if self.actState == ActState.Idle then
    self:ChangeState(ActState.BeHit)
    if self.state == BossState.Normal | BossState.Shield or self.state == BossState.Normal | BossState.Shield | BossState.Frenzy then
      self:PlayEffect(EffectFlag.ShieldBeHit, 3)
    end
  end
end

local function OnHurt(self, t)
  local dmg = t.lostHp or 0
  self:ShowDamageText(dmg, 1)
  if t.players then
    self:PlayHeadBubble(t.players)
  end
  if self.marchInfo and 0 < self.marchInfo.curHp then
    self:PlayBeAttackAnimation()
  end
end

local function OnBossDeadOrRun(self, type)
  self.modelLabel:SetActive(false)
  type = type or 0
  if type == 0 then
    self:ChangeState(ActState.Death)
  elseif type == 1 then
    self:ChangeState(ActState.MoveAway, self.transform)
  end
end

local function ChangeAttackState(self)
  self:ChangeState(ActState.Attack)
end

local function ChangeToTransmittingState(self)
  if self.zMBossInfo and self.simpleAnimation then
    local length = self.simpleAnimation:GetClipLength(Anim.Born)
    self:ChangeState(ActState.Transmitting, self.zMBossInfo.transferEndTime - length * 1000)
  end
end

local function ChangeToIdleState(self)
  self:ChangeModel("A_build_jiluofu_feiting_03_%s")
  self:ChangeState(ActState.Idle)
end

local function DisplayDeadTipText(self, diaId)
  if string.IsNullOrEmpty(diaId) then
    return
  end
  local context = CS.GameEntry.Localization:GetString(diaId)
  
  local function setTextCallback(text)
    if text then
      text.text = context
    end
  end
  
  local req = CS.GameEntry.Resource:InstantiateAsync(delTextPath)
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
    tf.parent = self.transform
    local text = tf:Find("VFX_defeatNoUI/zi_text"):GetComponent(typeof(CS.TextMeshProEx))
    setTextCallback(text)
    tf:Set_localPosition(0, 3.55, 0)
    tf.localScale = ResetScale
    go:SetActive(true)
  end)
  self.deadTextReq = req
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
    path = string.format(path, self.suffix)
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
      if self.modelNode then
        local parentPath = ParentRoot[flag]
        parentPath = parentPath or effect_root_path
        local parent = self.modelNode.transform:Find(parentPath)
        if parent then
          tf.parent = parent
        end
      end
      tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
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
  if self.deadTextReq then
    self.deadTextReq:Destroy()
    self.deadTextReq = nil
  end
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
  showModelData = showModelData or self:GetShowModelData()
  if self.showNodePath == showModelData then
    return
  end
  self:ResetNode()
  if not string.IsNullOrEmpty(showModelData) then
    local nodeName = string.format(showModelData, self.suffix)
    local go = self.nodeGos[nodeName]
    if IsNull(go) then
      local trans = self.worldModel:Find(nodeName)
      if not IsNull(trans) then
        go = trans.gameObject
        go:SetActive(true)
        self.modelNode = go
        self.nodeGos[nodeName] = go
      end
    else
      go:SetActive(true)
      self.modelNode = go
    end
  end
  self.showNodePath = showModelData
  self.simpleAnimation = self.modelNode and self.modelNode:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self:PlayEffect(EffectFlag.Airflow)
end

local function GetShowModelData(self)
  if self.zMBossInfo and CS.SceneManager.World then
    local modelData = GetTableData(TableName.ZoneMobilizationStage, self.zMBossInfo.stage, "world_model_3d")
    return modelData
  end
end

local function ResetNode(self)
  if self.modelNode then
    self.modelNode:SetActive(false)
    self.modelNode = nil
  end
  self.simpleAnimation = nil
end

local function RefreshShieldEffect(self, show, lastState)
  if show then
    self:PlayEffect(EffectFlag.ShieldLoop)
  else
    if lastState == BossState.Normal | BossState.Shield or lastState == BossState.Normal | BossState.Shield | BossState.Frenzy then
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
    self:ChangeModel()
  end
  self:ChangeState(ActState.Idle)
end

local function ShowDamageText(self, damage, time)
  if damage and 0 < damage and time and 0 < time then
    local pos = self.hpSliderNode.transform.position
    local param = self.damageTextMgr:GetParam()
    local style = 1 < damage and FlyText3DType.Crit or FlyText3DType.Normal
    if self.state == BossState.Normal | BossState.Shield or self.state == BossState.Normal | BossState.Shield | BossState.Frenzy then
      style = FlyText3DType.ShieldBreaking
    end
    param.style = style
    param.damage = damage
    param.position = Vector3.New(pos.x + 4, pos.y, pos.z)
    param.duration = time
    param.hasOffset = true
    self.damageTextMgr:GenText(param)
  end
end

local function PlayPlotBubble3D(self, duration)
  if self.transform and duration and self.marchInfo then
    local bubbleParams = {}
    local contents = LuaEntry.DataConfig:TryGetStr("zone_mobilization", "k26", "")
    if string.IsNullOrEmpty(contents) then
      return
    end
    local contentArr = string.split(contents, "|")
    if contentArr == nil or #contentArr == 0 then
      return
    end
    local random = math.random(#contentArr)
    local content = Localization:GetString(contentArr[random])
    bubbleParams.fakePlotMeta = {duration = duration, contentString = content}
    bubbleParams.followTarget = self.transform
    local targetPos = self.transform.position
    local pic = self.marchInfo.pic
    if string.IsNullOrEmpty(pic) then
      local monsterId = self.marchInfo.monsterId
      if 0 < monsterId then
        local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
        if monster ~= nil then
          pic = monster.pic
        end
      end
    end
    pic = "Assets/Main/Sprites/HeroIconsSmall/" .. pic .. ".png"
    local playerInfo = {
      uid = self.marchInfo.ownerUid,
      pic = pic,
      picVer = self.marchInfo.picVer
    }
    bubbleParams.anchor = Vector3.New(targetPos.x - 3, targetPos.y + 9, targetPos.z)
    bubbleParams.mode = "3D"
    bubbleParams.playerInfo = playerInfo
    bubbleParams.headType = 1
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
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
      trans.position = self.transform.position
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
      trans.position = self.transform.position
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

ZMBossActionCtrl.__init = __init
ZMBossActionCtrl.__delete = __delete
ZMBossActionCtrl.Init = Init
ZMBossActionCtrl.InitModelData = InitModelData
ZMBossActionCtrl.InitData = InitData
ZMBossActionCtrl.InitFsm = InitFsm
ZMBossActionCtrl.Destroy = Destroy
ZMBossActionCtrl.RefreshMarchInfo = RefreshMarchInfo
ZMBossActionCtrl.RefreshView = RefreshView
ZMBossActionCtrl.OnUpdateSec = OnUpdateSec
ZMBossActionCtrl.RefreshUIShow = RefreshUIShow
ZMBossActionCtrl.RefreshHpSlider = RefreshHpSlider
ZMBossActionCtrl.ShowDamageText = ShowDamageText
ZMBossActionCtrl.PlayAnimation = PlayAnimation
ZMBossActionCtrl.OnUpdate = OnUpdate
ZMBossActionCtrl.PlayBeAttackAnimation = PlayBeAttackAnimation
ZMBossActionCtrl.OnHurt = OnHurt
ZMBossActionCtrl.RefreshState = RefreshState
ZMBossActionCtrl.InitView = InitView
ZMBossActionCtrl.PlayEffect = PlayEffect
ZMBossActionCtrl.InstantiateAsync = InstantiateAsync
ZMBossActionCtrl.RemoveEffect = RemoveEffect
ZMBossActionCtrl.DisplayDeadTipText = DisplayDeadTipText
ZMBossActionCtrl.ClearEffect = ClearEffect
ZMBossActionCtrl.OnBossDeadOrRun = OnBossDeadOrRun
ZMBossActionCtrl.ChangeState = ChangeState
ZMBossActionCtrl.RefreshSlider = RefreshSlider
ZMBossActionCtrl.RefreshShieldHpSlider = RefreshShieldHpSlider
ZMBossActionCtrl.RefreshShieldTimingText = RefreshShieldTimingText
ZMBossActionCtrl.RefreshFrenzySlider = RefreshFrenzySlider
ZMBossActionCtrl.ChangeModel = ChangeModel
ZMBossActionCtrl.GetShowModelData = GetShowModelData
ZMBossActionCtrl.ChangeToTransmittingState = ChangeToTransmittingState
ZMBossActionCtrl.ResetNode = ResetNode
ZMBossActionCtrl.ChangeAttackState = ChangeAttackState
ZMBossActionCtrl.RefreshShieldEffect = RefreshShieldEffect
ZMBossActionCtrl.RefreshFrenzyEffect = RefreshFrenzyEffect
ZMBossActionCtrl.SetShieldGroupActive = SetShieldGroupActive
ZMBossActionCtrl.SetFrenzyGroupActive = SetFrenzyGroupActive
ZMBossActionCtrl.PlayPlotBubble3D = PlayPlotBubble3D
ZMBossActionCtrl.PlayHeadBubble = PlayHeadBubble
ZMBossActionCtrl.ChangeToIdleState = ChangeToIdleState
return ZMBossActionCtrl
