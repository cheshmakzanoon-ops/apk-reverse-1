local InvasionAisillaCtrl = BaseClass("InvasionAisillaCtrl")
local FlyText3DManager = require("Scene.InvasionAisilla.FlyText3DManager")
local math_abs = math.abs
local CS = _ENV.CS
local World = CS.SceneManager.World
local UITimeManager = _ENV.UITimeManager
local Localization = CS.GameEntry.Localization
local StateFlag = {
  None = 0,
  Prepare = 1,
  Born = 2,
  Battling = 3
}
local AnimStateFlag = {
  Idle = 0,
  BornPoss = 1,
  Born = 2,
  Attack = 3,
  BeAttack = 4,
  Walk = 5,
  Dead = 6
}
local EffectFlag = {
  BornPoss = 1,
  Born = 2,
  Attack = 3,
  LeftEye = 4,
  RightEye = 5,
  BornAnim = 6
}
local BORN_POSE_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_Boss_aisila01_born_pose.prefab"
local BORN_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_Boss_aisila01_chusheng.prefab"
local ATTACK_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_Boss_aisila01_gongji_01.prefab"
local LEFT_EYE_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_Boss_aisila01_yanjing_01.prefab"
local RIGHT_EYE_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_Boss_aisila01_yanjing_02.prefab"
local BORN_ANIMATION_PATH = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_Boss_aisila01_shikuai_01.prefab"
local EffectPaths = {
  [EffectFlag.BornPoss] = BORN_POSE_EFFECT_PATH,
  [EffectFlag.Born] = BORN_EFFECT_PATH,
  [EffectFlag.Attack] = ATTACK_EFFECT_PATH,
  [EffectFlag.LeftEye] = LEFT_EYE_EFFECT_PATH,
  [EffectFlag.RightEye] = RIGHT_EYE_EFFECT_PATH,
  [EffectFlag.BornAnim] = BORN_ANIMATION_PATH
}
local delTextPath = "Assets/Main/Prefabs/UI/Common/UIWorldMonsterDelText.prefab"

local function __init(self, marchInfo, transform)
  self.marchInfo = marchInfo
  self.transform = transform
  self.state = StateFlag.None
  self.damageTextMgr = FlyText3DManager.New()
  self.MPB = nil
  self.renderer = nil
  self.defaultLayer = nil
  self.allEffect = {}
  self.forward = nil
  self.deadTextReq = nil
  self.actStatus = nil
  self:Init()
end

local function __delete(self)
  self:Destroy()
end

local function Destroy(self)
  if self.damageTextMgr ~= nil then
    self.damageTextMgr:Delete()
  end
  self.marchInfo = nil
  self.transform = nil
  self.uuid = nil
  self.bossInfo = nil
  self.simpleAnimation = nil
  if self.modelLabel then
    self.modelLabel:SetActive(false)
  end
  self.modelLabel = nil
  self.sliderNode = nil
  self.sliderBar = nil
  self.sliderSprite = nil
  self.sliderText = nil
  self.prepareTimeNode = nil
  self.prepareText = nil
  self.prepareTimeText = nil
  self.timingText = nil
  self.state = nil
  self.MPB = nil
  self.renderer = nil
  self.quad = nil
  self.root = nil
  self.parents = nil
  self.meshRenderGo = nil
  self.defaultLayer = nil
  if self.animReq then
    self.animReq:Destroy()
    self.animReq = nil
  end
  if self.deadTextReq then
    self.deadTextReq:Destroy()
    self.deadTextReq = nil
  end
  self:ClearAnimAndEffect()
  self.forward = nil
  self.actStatus = nil
end

local function Init(self)
  if self.marchInfo then
    self.uuid = self.marchInfo.uuid
    self.bossInfo = self.marchInfo.invasionBossInfo
    if self.bossInfo then
      local invasionId = self.bossInfo.invasionId
      local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.AdvancedMonsterInvasion), invasionId)
      local birthTime = 0
      if line ~= nil then
        birthTime = line:getValue("birth_time") or 0
      end
      self.birthTime = birthTime
    end
    self.quad = self.transform:Find("Model/A_Mongster@Boss_aisila01_skin/To_unity/A_Mongster_aisila02_mod/Quad").gameObject
    local parents = {}
    self.root = self.transform:Find("Model/A_Mongster@Boss_aisila01_skin/To_unity/DeformationSystem/Root")
    parents[EffectFlag.BornPoss] = self.root
    parents[EffectFlag.Born] = self.root
    parents[EffectFlag.Attack] = self.root
    parents[EffectFlag.LeftEye] = self.transform:Find("Model/A_Mongster@Boss_aisila01_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Neck0_M/Head_M/Eye_L/EyeEnd_L")
    parents[EffectFlag.RightEye] = self.transform:Find("Model/A_Mongster@Boss_aisila01_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Neck0_M/Head_M/Eye_R/EyeEnd_R")
    parents[EffectFlag.BornAnim] = self.root
    self.parents = parents
    self.meshRenderGo = self.transform:GetComponentInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer)).gameObject
  end
  self.modelNode = self.transform:Find("Model/A_Mongster@Boss_aisila01_skin").gameObject
  self.simpleAnimation = self.modelNode:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self.modelLabel = self.transform:Find("ModelLabel").gameObject
  self.modelLabel:SetActive(true)
  self.sliderNode = self.transform:Find("ModelLabel/Slider").gameObject
  self.sliderNode:SetActive(false)
  self.sliderBar = self.transform:Find("ModelLabel/Slider/SliderBar")
  self.sliderSprite = self.sliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.sliderText = self.transform:Find("ModelLabel/Slider/SliderText"):GetComponent(typeof(CS.SuperTextMesh))
  self.prepareTimeNode = self.transform:Find("ModelLabel/PrepareTime").gameObject
  self.prepareText = self.transform:Find("ModelLabel/PrepareTime/StateText"):GetComponent(typeof(CS.SuperTextMesh))
  self.prepareText.text = Localization:GetString("activity_berserkboss_state_01")
  self.prepareTimeText = self.transform:Find("ModelLabel/PrepareTime/TimeText"):GetComponent(typeof(CS.SuperTextMesh))
  self.timingText = self.transform:Find("ModelLabel/Slider/TimingTextBg/TimingText"):GetComponent(typeof(CS.SuperTextMesh))
  self:SetDragEffect(false)
  self:ReInit()
  self.damageTextMgr:Init(self)
end

local function ReInit(self)
  self:RefreshHpSlider()
  self:RefreshView()
  self:RefreshTrigger()
end

local function SetModelDefaultLayer(self, default)
  if self.defaultLayer == default then
    return
  end
  if self.meshRenderGo then
    self.defaultLayer = default
    local layer = default and "Default" or "PlaneShadowObject"
    self.meshRenderGo:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(layer))
  end
end

local function Refresh(self, marchInfo, transform)
  self.marchInfo = marchInfo
  self.transform = transform
  self.uuid = self.marchInfo.uuid
  self.bossInfo = self.marchInfo.invasionBossInfo
  self.sliderNode:SetActive(false)
  self:SetDragEffect(false)
  self:ReInit()
end

local function RefreshBossInfo(self, bossInfo)
  self.bossInfo = bossInfo
  local isPlanFuncOpen = DataCenter.ActivityMonsterInvasionDataManager:GetPlanTimeFuncOpen()
  local isOverPlanTime = DataCenter.ActivityMonsterInvasionDataManager:IsOverPlanTime()
  self.sliderNode:SetActive(bossInfo ~= nil and (not isPlanFuncOpen or isOverPlanTime))
  self:ReInit()
end

local function RefreshView(self)
  if self.actStatus == nil and self.bossInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.bossInfo.battleStartTime - curTime > 0 then
      self.prepareTimeText.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.bossInfo.battleStartTime - curTime)
    else
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.bossInfo.battleEndTime - curTime)
      self.timingText.text = timeStr
    end
  end
end

local function RefreshTrigger(self)
  if self.bossInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.birthTime == nil then
      local invasionId = self.bossInfo.invasionId
      local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.AdvancedMonsterInvasion), invasionId)
      local birthTime = 0
      if line ~= nil then
        birthTime = line:getValue("birth_time") or 0
      end
      self.birthTime = birthTime
    end
    if self.bossInfo.battleStartTime - curTime > self.birthTime * 1000 then
      if self.state ~= StateFlag.Prepare then
        self.quad:SetActive(true)
        self.prepareTimeNode:SetActive(true)
        self.sliderNode:SetActive(false)
        local duration = (self.bossInfo.battleStartTime - curTime) / 1000 - self.birthTime
        self:PlayEffect(EffectFlag.BornPoss, duration)
        if self.animReq == nil then
          self.animReq = self:PlayEffect(EffectFlag.BornAnim)
        end
        self:PlayAnimation("born_poss", AnimStateFlag.BornPoss)
        self.state = StateFlag.Prepare
      end
    elseif math_abs(self.bossInfo.battleStartTime - curTime - self.birthTime * 1000) <= 100.0 then
      if self.state ~= StateFlag.Born then
        self.prepareTimeNode:SetActive(true)
        self.sliderNode:SetActive(false)
        self:PlayEffect(EffectFlag.Born, 5.6, nil, function()
          self.quad:SetActive(false)
          self:PlayAnimation("idle", AnimStateFlag.Idle)
          if self.animReq then
            self.animReq:Destroy()
          end
        end)
        if self.animReq == nil then
          self.animReq = self:PlayEffect(EffectFlag.BornAnim)
        end
        TimerManager:GetInstance():DelayInvoke(function()
          if self.animReq and self.animReq.gameObject then
            local anim = self.animReq.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
            if anim then
              anim:Play("Default")
            end
          end
        end, 1.2)
        self:PlayAnimation("born", AnimStateFlag.Born)
        self.state = StateFlag.Born
      end
    elseif 0 < self.bossInfo.battleStartTime - curTime then
      if self.state == StateFlag.Born then
        return
      end
      self.quad:SetActive(false)
      self.prepareTimeNode:SetActive(true)
      self.sliderNode:SetActive(false)
      self.state = StateFlag.Born
      self:PlayAnimation("idle", AnimStateFlag.Idle)
      if self.animReq then
        self.animReq:Destroy()
      end
    else
      if self.state ~= StateFlag.Battling then
        self.quad:SetActive(false)
        self.sliderNode:SetActive(true)
        self.prepareTimeNode:SetActive(false)
        self:PlayAnimation("idle", AnimStateFlag.Idle)
        if self.animReq then
          self.animReq:Destroy()
        end
      end
      self.state = StateFlag.Battling
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
  self:RefreshTrigger()
  if self.animState == AnimStateFlag.Walk and self.transform and self.forward then
    self.transform.position = self.transform.position + self.forward * Time.deltaTime * 2
  end
end

local function IsMine(self)
  return self.marchInfo and self.marchInfo.allianceUid == LuaEntry.Player.allianceId
end

local function RefreshHpSlider(self)
  if self.bossInfo then
    local sliderValue = 1
    if self.bossInfo.maxHp > 0 then
      sliderValue = self.bossInfo.curHp / self.bossInfo.maxHp
    end
    local localPosition = self.sliderBar.localPosition
    self.sliderBar.localPosition = Vector3.New((sliderValue - 1) * 4.33 / 2, localPosition.y, 0)
    self.sliderSprite.size = Vector2.New(sliderValue * 4.33, 0.41)
    self.sliderText.text = tostring(self.bossInfo.curHp) .. "/" .. tostring(self.bossInfo.maxHp)
  end
end

local function ChangeAttackState(self)
  if self.attackDelayInvoke then
    self.attackDelayInvoke:Stop()
  end
  if self.beAttackDelayInvoke then
    self.beAttackDelayInvoke:Stop()
  end
  self:PlayAnimation("attack_skill_04", AnimStateFlag.Attack)
  self:PlayEffect(EffectFlag.Attack, 6.6)
  self:PlayEffect(EffectFlag.LeftEye, 5)
  self:PlayEffect(EffectFlag.RightEye, 5)
  self.attackDelayInvoke = TimerManager:GetInstance():DelayInvoke(function()
    self:PlayAnimation("idle", AnimStateFlag.Idle)
  end, 6.6)
end

local function ShowDamageText(self, damage, time)
  if damage and 0 < damage and time and 0 < time then
    local pos = self.sliderNode.transform.position
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

local function PlayAnimation(self, animName, animState)
  if string.IsNullOrEmpty(animName) then
    animName = "idle"
    animState = AnimStateFlag.Idle
  end
  self.animState = animState
  if animState == AnimStateFlag.BornPoss then
    self:SetModelDefaultLayer(true)
  elseif animState == AnimStateFlag.Born then
    self:SetModelDefaultLayer(true)
    TimerManager:GetInstance():DelayInvoke(function()
      if self then
        self:SetModelDefaultLayer(false)
      end
    end, 1.7)
    DataCenter.LWSoundManager:PlaySound(62002, false)
  else
    if animState == AnimStateFlag.Attack then
      DataCenter.LWSoundManager:PlaySound(62006, false)
    end
    self:SetModelDefaultLayer(false)
  end
  if self.simpleAnimation:IsPlaying(animName) then
    self.simpleAnimation:Rewind(animName)
  end
  self.simpleAnimation:Play(animName)
  if animState ~= AnimStateFlag.Walk then
    self.forward = nil
  end
end

local function PlayBeAttackAnimation(self)
  if self.animState == AnimStateFlag.Idle then
    if self.beAttackDelayInvoke then
      self.beAttackDelayInvoke:Stop()
    end
    self:PlayAnimation("hurt", AnimStateFlag.BeAttack)
    self.beAttackDelayInvoke = TimerManager:GetInstance():DelayInvoke(function()
      self:PlayAnimation("idle", AnimStateFlag.Idle)
    end, 2.6)
  end
end

local function OnHurt(self, damage, duration)
  self:ShowDamageText(damage, duration)
  if self.bossInfo and self.bossInfo.curHp > 0 then
    self:PlayBeAttackAnimation()
  end
end

local function SetDragEffect(self, isOn)
  if IsNull(self.MPB) then
    self.MPB = CS.UnityEngine.MaterialPropertyBlock()
  end
  if IsNull(self.renderer) then
    self.renderer = self.modelNode and self.modelNode:GetComponentInChildren(typeof(CS.UnityEngine.Renderer))
  end
  if self.MPB and self.renderer then
    self.MPB:SetFloat("_USERIM", isOn and 1 or 0)
    self.renderer:SetPropertyBlock(self.MPB)
  end
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
  local path = EffectPaths[flag]
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
      local parent = self.parents[flag] or self.root
      tf.parent = parent
      if flag == EffectFlag.BornPoss then
        tf:Set_localPosition(ResetPosition.x, ResetPosition.y + 2.5, ResetPosition.z)
      else
        tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      end
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

local function ChangeDeadState(self, status)
  self.actStatus = status
  if self.damageTextMgr ~= nil then
    self.damageTextMgr:ClearAllActive()
  end
  self:ClearAnimAndEffect()
  self.sliderNode:SetActive(false)
  self.timingText.gameObject:SetActive(false)
  local diaId
  if status then
    if status == InvasionAisillaActStatus.KILL then
      diaId = "pic_name_02"
      self:PlayAnimation("dead", AnimStateFlag.Dead)
      DataCenter.LWSoundManager:PlaySound(62003, false)
    elseif status == InvasionAisillaActStatus.ESCAPE then
      diaId = "activity_godzilla_battle_fail"
      if self.modelNode and self.modelNode.transform then
        self.forward = self.modelNode and self.modelNode.transform.forward
        self:PlayAnimation("walk", AnimStateFlag.Walk)
      end
    end
    self:DisplayDeadTipText(diaId)
  end
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

local function ClearAnimAndEffect(self)
  if self.attackDelayInvoke then
    self.attackDelayInvoke:Stop()
    self.attackDelayInvoke = nil
  end
  if self.beAttackDelayInvoke then
    self.beAttackDelayInvoke:Stop()
    self.beAttackDelayInvoke = nil
  end
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

InvasionAisillaCtrl.__init = __init
InvasionAisillaCtrl.__delete = __delete
InvasionAisillaCtrl.Destroy = Destroy
InvasionAisillaCtrl.Init = Init
InvasionAisillaCtrl.Refresh = Refresh
InvasionAisillaCtrl.RefreshBossInfo = RefreshBossInfo
InvasionAisillaCtrl.RefreshView = RefreshView
InvasionAisillaCtrl.OnUpdateSec = OnUpdateSec
InvasionAisillaCtrl.IsMine = IsMine
InvasionAisillaCtrl.RefreshHpSlider = RefreshHpSlider
InvasionAisillaCtrl.ChangeAttackState = ChangeAttackState
InvasionAisillaCtrl.ShowDamageText = ShowDamageText
InvasionAisillaCtrl.PlayAnimation = PlayAnimation
InvasionAisillaCtrl.OnUpdate = OnUpdate
InvasionAisillaCtrl.PlayBeAttackAnimation = PlayBeAttackAnimation
InvasionAisillaCtrl.OnHurt = OnHurt
InvasionAisillaCtrl.SetDragEffect = SetDragEffect
InvasionAisillaCtrl.RefreshTrigger = RefreshTrigger
InvasionAisillaCtrl.ReInit = ReInit
InvasionAisillaCtrl.PlayEffect = PlayEffect
InvasionAisillaCtrl.InstantiateAsync = InstantiateAsync
InvasionAisillaCtrl.SetModelDefaultLayer = SetModelDefaultLayer
InvasionAisillaCtrl.RemoveEffect = RemoveEffect
InvasionAisillaCtrl.ChangeDeadState = ChangeDeadState
InvasionAisillaCtrl.DisplayDeadTipText = DisplayDeadTipText
InvasionAisillaCtrl.ClearAnimAndEffect = ClearAnimAndEffect
return InvasionAisillaCtrl
