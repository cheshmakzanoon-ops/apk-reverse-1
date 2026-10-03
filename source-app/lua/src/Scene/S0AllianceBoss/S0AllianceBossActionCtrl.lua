local S0AllianceBossActionCtrl = BaseClass("S0AllianceBossActionCtrl")
local FSM = require("Framework.Common.FSM")
local BornState = require("Scene.S0AllianceBoss.BossState.S0AllianceBossBornState")
local IdleState = require("Scene.S0AllianceBoss.BossState.S0AllianceBossIdleState")
local AttackState = require("Scene.S0AllianceBoss.BossState.S0AllianceBossAttackState")
local WeaknessState = require("Scene.S0AllianceBoss.BossState.S0AllianceBossWeaknessState")
local RuinsState = require("Scene.S0AllianceBoss.BossState.S0AllianceBossRuinsState")
local ChangeStageState = require("Scene.S0AllianceBoss.BossState.S0AllianceBossChangeState")
local CS = _ENV.CS
local UITimeManager = _ENV.UITimeManager
local Localization = CS.GameEntry.Localization
local DirectorWrapMode = CS.UnityEngine.Playables.DirectorWrapMode
local TimelinePlayer = CS.TimelinePlayer
S0AllianceBossActionCtrl.FsmState = {
  None = 0,
  Idle = 1,
  Attack = 2,
  Born = 3,
  Change = 4,
  Weakness = 5,
  Ruins = 6
}
S0AllianceBossActionCtrl.BossAnim = {
  Born = "born",
  Idle = "idle",
  Death = "death",
  Born2 = "born2",
  Attack = "attack",
  Weakness = "weakness",
  Leave = "leave"
}
S0AllianceBossActionCtrl.BuildingAnim = {
  Born = "born",
  Idle = "idle",
  Idle2 = "idle2",
  Ruins = "ruins",
  Hold = "hold"
}
local FsmState = S0AllianceBossActionCtrl.FsmState
local BossState = {
  None = 0,
  Born = 1,
  Idle = 2,
  Attack = 3,
  Change = 4,
  Weakness = 5,
  Ruins = 6
}
local WORLD_MODEL_PATH = "Model/WorldModel"
local MODEL_LABEL_PATH = "ModelLabel/Root/ModelLabel_Boss"
local MODEL_LABEL_PATH_OTHER = "ModelLabel/Root/ModelLabel_Boss_Other"
local RUINS_MODEL_LABEL_PATH = "ModelLabel/Root/ModelLabel_Build"
local WORLD_BUILD_MODEL_PATH = "WorldModel/A_Build_new_junyanjianzhu"
local WORLD_BOSS_MODEL_PATH = "WorldModel/BossModel"
local BOSS_MATERIAL_NODE_PATH = {
  [1] = {
    "junyandog01/A_Monster@dog01_skin/To_unity/A_Monster_Dog1"
  },
  [2] = {
    "junyanboss01/A_Monster@boss01_skin/To_unity/sangshi_boss 1/sangshi_boss01",
    "junyanboss01/A_Monster@boss01_skin/To_unity/sangshi_boss 1/sangshi_boss02"
  },
  [3] = {
    "junyanBigbelly01/A_Monster@Bigbelly01_skin/To_unity/A_Monster_Bigbelly01 1"
  }
}
local BOSS_STAGE_MAT_PATH = {
  [1] = {
    {
      [1] = "Assets/Main/Material/S0AllianceBoss/A_Monster_dog01_tmjy_Blue.mat",
      [2] = "Assets/Main/Material/S0AllianceBoss/A_Monster_dog01_tmjy_Purple.mat",
      [3] = "Assets/Main/Material/S0AllianceBoss/A_Monster_dog01_tmjy_Orange.mat",
      [4] = "Assets/Main/Material/S0AllianceBoss/A_Monster_dog01_tmjy_Red.mat"
    }
  },
  [2] = {
    {
      [1] = "Assets/Main/Material/S0AllianceBoss/A_Monsterboss01_tmjy_Blue.mat",
      [2] = "Assets/Main/Material/S0AllianceBoss/A_Monsterboss01_tmjy_Purple.mat",
      [3] = "Assets/Main/Material/S0AllianceBoss/A_Monsterboss01_tmjy_Orange.mat",
      [4] = "Assets/Main/Material/S0AllianceBoss/A_Monsterboss01_tmjy_Red.mat"
    },
    {
      [1] = "Assets/Main/Material/S0AllianceBoss/A_Monsterboss01_B_tmjy_Blue.mat",
      [2] = "Assets/Main/Material/S0AllianceBoss/A_Monsterboss01_B_tmjy_Purple.mat",
      [3] = "Assets/Main/Material/S0AllianceBoss/A_Monsterboss01_B_tmjy_Orange.mat",
      [4] = "Assets/Main/Material/S0AllianceBoss/A_Monsterboss01_B_tmjy_Red.mat"
    }
  },
  [3] = {
    {
      [1] = "Assets/Main/Material/S0AllianceBoss/A_Monster_Bigbelly01_tmjy_Blue.mat",
      [2] = "Assets/Main/Material/S0AllianceBoss/A_Monster_Bigbelly01_tmjy_Purple.mat",
      [3] = "Assets/Main/Material/S0AllianceBoss/A_Monster_Bigbelly01_tmjy_Orange.mat",
      [4] = "Assets/Main/Material/S0AllianceBoss/A_Monster_Bigbelly01_tmjy_Red.mat"
    }
  }
}
local BOSS_NAME_TYPE = {
  junyandog01 = 1,
  junyanboss01 = 2,
  junyanBigbelly01 = 3
}
local DEFAULT_GO_NODE_PATH = "Go"
local ALLIANCE_SLIDER_WIDTH = 1.8
local SLIDER_HEIGHT = 0.158

local function __init(self, marchInfo, transform)
  self:Init(marchInfo, transform)
end

local function __delete(self)
  self:Destroy()
  self.hpSliderScale1 = nil
  self.hpSliderPos1 = nil
  self.hpSliderScale2 = nil
  self.hpSliderPos2 = nil
end

local function Init(self, marchInfo, transform)
  self:InitData(marchInfo)
  self:InitModelData(transform)
end

local function InitData(self, marchInfo)
  self.marchInfo = marchInfo
  self.maxStar = 0
  if marchInfo then
    self.uuid = marchInfo.uuid
    local s0AllianceBossInfo = marchInfo.s0AllianceBossInfo
    self.s0AllianceBossInfo = s0AllianceBossInfo
    self.isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
    if s0AllianceBossInfo then
      local bossId = s0AllianceBossInfo.cfgId
      local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
      if bossTemp then
        self.maxStar = bossTemp:GetMaxStar()
        self.allianceDmgArr = bossTemp.allianceDmg
        self.personalDmgArr = bossTemp.personalDmg
        self.allianceMaxDmg = bossTemp.allianceMaxDmg
        self.personalDmgMax = bossTemp.personalMaxDmg
        self.alliance_bonus = bossTemp.alliance_bonus
        self.modelPath = bossTemp.monster_prefab
      end
      self.endTime = s0AllianceBossInfo.battleEndTime
      self.startTime = s0AllianceBossInfo.battleStartTime
    end
  end
  self.fsmState = FsmState.None
  self.bossState = nil
  self.bossTimer = nil
  self.buildTimer = nil
  self.rewardTimer = nil
  self.hpSliderScale1 = Vector2.New(1, SLIDER_HEIGHT)
  self.hpSliderPos1 = Vector2.New(1, 1)
  self.hpSliderScale2 = Vector2.New(1, SLIDER_HEIGHT)
  self.hpSliderPos2 = Vector2.New(1, 1)
  self.worldModel = nil
  self.defaultGoNode = nil
  self.buildWorldModel = nil
  self.bossWorldModel = nil
  self.curPersonalDmg = -1
  self.curAllianceDmg = -1
  self.star = -1
  self.bossAttackInternal = DataCenter.S0AllianceBossDataManager:GetBossAttackInternal()
  self.lastCheckTime = nil
  self.rewardNode = nil
  self.rewardSimpleAnim = nil
  self.isInit = true
  self.isChange = false
  self.personalEffectTimer = 0
  self.allianceEffectTimer = 0
  self.bossType = nil
end

local function InitModelData(self, transform)
  self.transform = transform
  self.worldModel = transform:Find(WORLD_MODEL_PATH)
  if IsNull(self.worldModel) then
    Logger.LogError("S0AllianceBoss -- worldModel not found at path: " .. WORLD_MODEL_PATH)
    return
  end
  local defaultGoNodeTrans = self.worldModel:Find(DEFAULT_GO_NODE_PATH)
  if IsNull(defaultGoNodeTrans) then
    Logger.LogError("S0AllianceBoss -- defaultGoNodeTrans not found")
    return
  end
  self.defaultGoNode = defaultGoNodeTrans.gameObject
  if IsNull(self.defaultGoNode) then
    Logger.LogError("S0AllianceBoss -- defaultGoNode not found")
    return
  end
  if not CS.GameEntry.Resource:PrefabAssetsDownloaded(self.modelPath) then
    self.defaultGoNode:SetActive(true)
  else
    self.defaultGoNode:SetActive(false)
  end
  if not self.modelPath then
    Logger.LogError("S0AllianceBoss -- modelPath is nil, skip InitModelData")
    return
  end
  local initIndex = 0
  local req = CS.GameEntry.Resource:InstantiateAsync(self.modelPath)
  req:completed("+", function()
    if req.isError then
      return
    end
    self.defaultGoNode:SetActive(false)
    local go = req.gameObject
    go:SetActive(true)
    local trans = go.transform
    trans:SetParent(self.worldModel)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.buildWorldModel = trans:Find(WORLD_BUILD_MODEL_PATH)
    if IsNull(self.buildWorldModel) then
      Logger.LogError("S0AllianceBoss -- buildWorldModel not found")
      return
    end
    self.buildTimelinePlayer = self.buildWorldModel:GetComponentInChildren(typeof(TimelinePlayer))
    local bossWorldModel = trans:Find(WORLD_BOSS_MODEL_PATH)
    if IsNull(bossWorldModel) then
      Logger.LogError("S0AllianceBoss -- bossWorldModel not found")
      return
    end
    self.bossWorldModel = bossWorldModel.gameObject
    self.bossTimelinePlayer = self.bossWorldModel:GetComponentInChildren(typeof(TimelinePlayer))
    initIndex = initIndex + 1
    if initIndex == 2 then
      self:InitMaterial()
      self:InitFsm()
      self:InitModelLabel()
      self:OnCreate()
      self:ChangeMaterial(self.star)
    end
  end)
  self.modelReq = req
  local labelReq = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/World/S0AllianceBoss/ModelLabel_Boss_Root.prefab")
  labelReq:completed("+", function()
    if labelReq.isError then
      return
    end
    local go = labelReq.gameObject
    if IsNull(go) then
      return
    end
    go:SetActive(true)
    local trans = go.transform
    local labelTrans = transform:Find("ModelLabel")
    trans.name = "Root"
    if IsNotNull(labelTrans) then
      trans:SetParent(labelTrans)
    end
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    trans:Set_localRotation(0, 0, 0, 1)
    initIndex = initIndex + 1
    if initIndex == 2 then
      self:InitMaterial()
      self:InitFsm()
      self:InitModelLabel()
      self:OnCreate()
      self:ChangeMaterial(self.star)
    end
  end)
  self.modelLabelReq = labelReq
end

local function InitModelLabel(self)
  local path = MODEL_LABEL_PATH
  if self.isMine then
    local trans = self.transform:Find(MODEL_LABEL_PATH_OTHER)
    if IsNotNull(trans) then
      trans.gameObject:SetActive(false)
    end
  else
    path = MODEL_LABEL_PATH_OTHER
    local trans = self.transform:Find(MODEL_LABEL_PATH)
    if IsNotNull(trans) then
      trans.gameObject:SetActive(false)
    end
  end
  local labelTrans = self.transform:Find(path)
  if IsNull(labelTrans) then
    Logger.LogError("S0AllianceBoss -- labelTrans is nil, skip InitModelLabel")
    return
  end
  self.modelLabel = labelTrans.gameObject
  self.modelLabel:SetActive(false)
  local ruinsLabelTrans = self.transform:Find(RUINS_MODEL_LABEL_PATH)
  if IsNull(ruinsLabelTrans) then
    Logger.LogError("S0AllianceBoss -- ruinsLabelTrans is nil, skip InitModelLabel")
    return
  end
  self.ruinsModelLabel = ruinsLabelTrans.gameObject
  self.ruinsModelLabel:SetActive(false)
  local titleTrans = labelTrans:Find("txt_boss_name")
  if IsNull(titleTrans) then
    Logger.LogError("S0AllianceBoss -- titleTrans is nil, skip InitModelLabel")
    return
  end
  local titleText = titleTrans:GetComponent(typeof(CS.TextMeshProEx))
  self.titleText = titleText
  local ruinsTitleTrans = ruinsLabelTrans:Find("Node/txt_boss_name")
  if IsNull(ruinsTitleTrans) then
    Logger.LogError("S0AllianceBoss -- ruinsTitleTrans is nil, skip InitModelLabel")
    return
  end
  local ruinsTitleText = ruinsTitleTrans:GetComponent(typeof(CS.TextMeshProEx))
  if IsNull(ruinsTitleText) then
    Logger.LogError("S0AllianceBoss -- ruinsTitleText is nil, skip InitModelLabel")
    return
  end
  if self.marchInfo then
    local abbr = self.marchInfo.allianceAbbr
    local bossId = self.s0AllianceBossInfo.cfgId
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
    if bossTemp then
      local name = bossTemp.name
      local level = bossTemp.difficulty
      local nameStr = "Lv." .. level .. " " .. Localization:GetString(name)
      local monsterId = bossTemp.monsterId
      local monsterTemp = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
      if monsterTemp then
        local bossLevel = monsterTemp.level
        local bossName = monsterTemp.name
        local bossNameStr = "Lv." .. bossLevel .. " " .. Localization:GetString(bossName)
        self.bossName = Localization:GetString("s0_alliance_boss_placeholder", abbr, bossNameStr)
      end
      self.buildName = Localization:GetString("s0_alliance_boss_placeholder", abbr, nameStr)
      titleText.text = ""
      ruinsTitleText.text = self.buildName
    end
  end
  local ruinsTimingTitleTrans = ruinsLabelTrans:Find("Node/txt_battle_time")
  if IsNull(ruinsTimingTitleTrans) then
    Logger.LogError("S0AllianceBoss -- ruinsTimingTitleTrans is nil, skip InitModelLabel")
    return
  end
  local ruinsTimingTitleText = ruinsTimingTitleTrans:GetComponent(typeof(CS.TextMeshProEx))
  if IsNull(ruinsTimingTitleText) then
    Logger.LogError("S0AllianceBoss -- ruinsTimingTitleText is nil, skip InitModelLabel")
    return
  end
  ruinsTimingTitleText.text = Localization:GetString("s0_alliance_boss_end_tips")
  local timingTitleTrans = labelTrans:Find("txt_battle_time")
  if IsNull(timingTitleTrans) then
    Logger.LogError("S0AllianceBoss -- timingTitleTrans is nil, skip InitModelLabel")
    return
  end
  local timingTitleText = timingTitleTrans:GetComponent(typeof(CS.TextMeshProEx))
  if IsNull(timingTitleText) then
    Logger.LogError("S0AllianceBoss -- timingTitleText is nil, skip InitModelLabel")
    return
  end
  timingTitleText.text = Localization:GetString("s0_alliance_boss_time_remaining")
  local timingTrans = labelTrans:Find("txt_time")
  if IsNull(timingTrans) then
    Logger.LogError("S0AllianceBoss -- timingTrans is nil, skip InitModelLabel")
    return
  end
  self.timingText = timingTrans:GetComponent(typeof(CS.TextMeshProEx))
  if self.isMine then
    local personalTitleTrans = labelTrans:Find("img_bg_personal/txt_personal")
    if IsNull(personalTitleTrans) then
      Logger.LogError("S0AllianceBoss -- personalTitleTrans is nil, skip InitModelLabel")
      return
    end
    local personalTitleText = personalTitleTrans:GetComponent(typeof(CS.TextMeshProEx))
    if IsNull(personalTitleText) then
      Logger.LogError("S0AllianceBoss -- personalTitleText is nil, skip InitModelLabel")
      return
    end
    personalTitleText.text = Localization:GetString("s0_alliance_boss_personal_tab")
    self.personalDmgText = labelTrans:Find("img_bg_personal/txt_personal_num"):GetComponent(typeof(CS.TextMeshProEx))
    self.personalDmgSlider = labelTrans:Find("img_bg_personal/personal_slider/img_fill"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    local personal_slider_effect_path = "img_bg_personal/personal_slider/Eff_ui_AllianceBoss_alliance_slider"
    self.personalSliderEffect = labelTrans:Find(personal_slider_effect_path).gameObject
    if IsNotNull(self.personalSliderEffect) then
      self.personalSliderEffect:SetActive(false)
    end
  end
  local allianceTitleTrans = labelTrans:Find("img_bg_alliance/txt_alliance")
  if IsNull(allianceTitleTrans) then
    Logger.LogError("S0AllianceBoss -- allianceTitleTrans is nil, skip InitModelLabel")
    return
  end
  local allianceTitleText = allianceTitleTrans:GetComponent(typeof(CS.TextMeshProEx))
  if IsNull(allianceTitleText) then
    Logger.LogError("S0AllianceBoss -- allianceTitleText is nil, skip InitModelLabel")
    return
  end
  allianceTitleText.text = Localization:GetString("s0_alliance_boss_alliance_tab")
  self.allianceDmgText = labelTrans:Find("img_bg_alliance/txt_alliance_num"):GetComponent(typeof(CS.TextMeshProEx))
  self.allianceDmgSlider = labelTrans:Find("img_bg_alliance/alliance_slider/img_fill"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  local alliance_slider_effect_path = "img_bg_alliance/alliance_slider/Eff_ui_AllianceBoss_alliance_slider"
  self.allianceSliderEffect = labelTrans:Find(alliance_slider_effect_path).gameObject
  if IsNotNull(self.allianceSliderEffect) then
    self.allianceSliderEffect:SetActive(false)
  end
  local star1 = labelTrans:Find("img_bg_alliance/alliance_slider/star_light_01").gameObject
  if IsNull(star1) then
    Logger.LogError("S0AllianceBoss -- star1 is nil, skip InitModelLabel")
    return
  end
  star1:SetActive(false)
  local star2 = labelTrans:Find("img_bg_alliance/alliance_slider/star_light_02").gameObject
  if IsNull(star2) then
    Logger.LogError("S0AllianceBoss -- star2 is nil, skip InitModelLabel")
    return
  end
  star2:SetActive(false)
  local star3 = labelTrans:Find("img_bg_alliance/alliance_slider/star_light_03").gameObject
  if IsNull(star3) then
    Logger.LogError("S0AllianceBoss -- star3 is nil, skip InitModelLabel")
    return
  end
  star3:SetActive(false)
  local star4 = labelTrans:Find("img_bg_alliance/alliance_slider/star_light_04").gameObject
  if IsNull(star4) then
    Logger.LogError("S0AllianceBoss -- star4 is nil, skip InitModelLabel")
    return
  end
  star4:SetActive(false)
  local star5 = labelTrans:Find("img_bg_alliance/alliance_slider/star_light_05").gameObject
  if IsNull(star5) then
    Logger.LogError("S0AllianceBoss -- star5 is nil, skip InitModelLabel")
    return
  end
  star5:SetActive(false)
  self.starList = {
    star1,
    star2,
    star3,
    star4,
    star5
  }
  local rewardTrans = labelTrans:Find("Reward")
  if IsNull(rewardTrans) then
    Logger.LogError("S0AllianceBoss -- rewardTrans is nil, skip InitModelLabel")
    return
  end
  self.rewardNode = rewardTrans.gameObject
  self.rewardSimpleAnim = rewardTrans:GetComponent(typeof(CS.SimpleAnimation))
  local rewardTitleTrans = rewardTrans:Find("txt_alliance_Rewards")
  if IsNull(rewardTitleTrans) then
    Logger.LogError("S0AllianceBoss -- rewardTitleTrans is nil, skip InitModelLabel")
    return
  end
  local rewardTitleText = rewardTitleTrans:GetComponent(typeof(CS.TextMeshProEx))
  if IsNull(rewardTitleText) then
    Logger.LogError("S0AllianceBoss -- rewardTitleText is nil, skip InitModelLabel")
    return
  end
  rewardTitleText.text = Localization:GetString("s0_alliance_boss_alliance_reward_final")
  local rewardMultipleTrans = rewardTrans:Find("txt_multiple")
  if IsNull(rewardMultipleTrans) then
    Logger.LogError("S0AllianceBoss -- rewardMultipleTrans is nil, skip InitModelLabel")
    return
  end
  local rewardMultipleText = rewardMultipleTrans:GetComponent(typeof(CS.TextMeshProEx))
  if IsNull(rewardMultipleText) then
    Logger.LogError("S0AllianceBoss -- rewardMultipleText is nil, skip InitModelLabel")
    return
  end
  rewardMultipleText.text = ""
  self.rewardMultipleText = rewardMultipleText
  local rewardMultipleAfterTrans = rewardTrans:Find("txt_multiple_after")
  if IsNull(rewardMultipleAfterTrans) then
    Logger.LogError("S0AllianceBoss -- rewardMultipleAfterTrans is nil, skip InitModelLabel")
    return
  end
  local rewardMultipleAfterText = rewardMultipleAfterTrans:GetComponent(typeof(CS.TextMeshProEx))
  if IsNull(rewardMultipleAfterText) then
    Logger.LogError("S0AllianceBoss -- rewardMultipleAfterText is nil, skip InitModelLabel")
    return
  end
  rewardMultipleAfterText.text = ""
  self.rewardMultipleAfterText = rewardMultipleAfterText
end

local function Destroy(self)
  self.isDestroyed = true
  self:ResetMaterial()
  self.oriMatList = nil
  self.matNodeList = nil
  if self.allMatList then
    for _, stageMats in pairs(self.allMatList) do
      if stageMats then
        for _, mat in pairs(stageMats) do
          if mat then
            CS.UnityEngine.Object.Destroy(mat)
          end
        end
      end
    end
  end
  self.allMatList = nil
  self.allMatReqs = nil
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.bossTimer then
    self.bossTimer:Stop()
    self.bossTimer = nil
  end
  if self.buildTimer then
    self.buildTimer:Stop()
    self.buildTimer = nil
  end
  if self.rewardTimer then
    self.rewardTimer:Stop()
    self.rewardTimer = nil
  end
  self.worldModel = nil
  self.modelPath = nil
  self.defaultGoNode = nil
  if self.modelReq then
    self.modelReq:Destroy()
    self.modelReq = nil
  end
  if self.modelLabelReq then
    self.modelLabelReq:Destroy()
    self.modelLabelReq = nil
  end
  self.buildWorldModel = nil
  self.buildTimelinePlayer = nil
  self.bossWorldModel = nil
  self.bossTimelinePlayer = nil
  self.marchInfo = nil
  self.transform = nil
  self.uuid = nil
  if self.modelLabel then
    self.modelLabel:SetActive(false)
    self.modelLabel = nil
  end
  if self.ruinsModelLabel then
    self.ruinsModelLabel:SetActive(false)
    self.ruinsModelLabel = nil
  end
  self.titleText = nil
  self.timingText = nil
  self.personalDmgText = nil
  self.personalDmgSlider = nil
  self.personalSliderEffect = nil
  self.allianceDmgText = nil
  self.allianceDmgSlider = nil
  self.allianceSliderEffect = nil
  self.starList = nil
  self.rewardMultipleText = nil
  self.fsmState = nil
  self.bossState = nil
  self.s0AllianceBossInfo = nil
  self.hpSliderScale1 = Vector2.New(1, 1)
  self.hpSliderPos1 = Vector2.New(1, 1)
  self.hpSliderScale2 = Vector2.New(1, 1)
  self.hpSliderPos2 = Vector2.New(1, 1)
  self.allianceDmgArr = nil
  self.personalDmgArr = nil
  self.personalDmgMax = nil
  self.allianceMaxDmg = nil
  self.alliance_bonus = nil
  self.curPersonalDmg = nil
  self.curAllianceDmg = nil
  self.star = nil
  self.startTime = nil
  self.endTime = nil
  self.bossAttackInternal = nil
  self.lastCheckTime = nil
  self.rewardNode = nil
  self.rewardSimpleAnim = nil
  self.isInit = nil
  self.isChange = nil
  self.personalEffectTimer = nil
  self.allianceEffectTimer = nil
  self.isMine = nil
  self.bossType = nil
  self.curBuildAnimName = nil
  self.curBossAnimName = nil
end

local function OnCreate(self)
  self:RefreshState()
  self:RefreshView()
  self:RefreshHpSlider()
  self:RefreshTitleName()
  self.isInit = false
end

local function InitFsm(self)
  self.fsm = FSM.New()
  self.fsm:AddState(FsmState.Born, BornState.New(self))
  self.fsm:AddState(FsmState.Idle, IdleState.New(self))
  self.fsm:AddState(FsmState.Attack, AttackState.New(self))
  self.fsm:AddState(FsmState.Weakness, WeaknessState.New(self))
  self.fsm:AddState(FsmState.Ruins, RuinsState.New(self))
  self.fsm:AddState(FsmState.Change, ChangeStageState.New(self))
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
  self.maxStar = 0
  if marchInfo then
    self.uuid = marchInfo.uuid
    local s0AllianceBossInfo = marchInfo.s0AllianceBossInfo
    self.s0AllianceBossInfo = s0AllianceBossInfo
    self.isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
    if s0AllianceBossInfo then
      local bossId = s0AllianceBossInfo.cfgId
      local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
      if bossTemp then
        self.maxStar = bossTemp:GetMaxStar()
        self.allianceDmgArr = bossTemp.allianceDmg
        self.personalDmgArr = bossTemp.personalDmg
        self.allianceMaxDmg = bossTemp.allianceMaxDmg
        self.personalDmgMax = bossTemp.personalMaxDmg
        self.alliance_bonus = bossTemp.alliance_bonus
        self.modelPath = bossTemp.monster_prefab
      end
      self.endTime = s0AllianceBossInfo.battleEndTime
      self.startTime = s0AllianceBossInfo.battleStartTime
    end
  end
  if self.marchInfo == nil or self.s0AllianceBossInfo == nil then
    if self.modelLabel then
      self.modelLabel:SetActive(false)
    end
    if self.ruinsModelLabel then
      self.ruinsModelLabel:SetActive(false)
    end
  end
  self:RefreshState()
  self:RefreshView()
  self:RefreshHpSlider()
  self:RefreshTitleName()
end

local function RefreshTitleName(self)
  if IsNull(self.titleText) then
    return
  end
  local curTs = UITimeManager:GetInstance():GetServerTime()
  local offset = curTs - self.endTime
  if 0 <= offset then
    self.titleText.text = self.buildName or ""
  else
    self.titleText.text = self.bossName or ""
  end
end

local function RefreshView(self)
  if self.bossState == BossState.Ruins and not self.isInit then
    return
  end
  if self.s0AllianceBossInfo and self.fsmState then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if not table.IsNullOrEmpty(self.starList) then
      local curStar = self.s0AllianceBossInfo.rewardProgress
      if curStar ~= self.star then
        local count = #self.starList
        for i = 1, count do
          self.starList[i]:SetActive(i <= curStar)
        end
        if IsNotNull(self.rewardNode) and IsNotNull(self.rewardMultipleText) and IsNotNull(self.rewardMultipleAfterText) and self.alliance_bonus then
          local bonus = self.alliance_bonus[curStar + 1]
          if 1 < bonus then
            self.rewardNode:SetActive(true)
            if self.isInit then
              self.rewardMultipleText.text = "x" .. bonus
              self.rewardMultipleAfterText.text = ""
              self:SampleRewardAnimationAtTime("Default", 1)
              self.isChange = true
            elseif self.isChange then
              local lastBonus = self.alliance_bonus[self.star + 1]
              self.rewardMultipleAfterText.text = "x" .. bonus
              self.rewardMultipleText.text = "x" .. lastBonus
              self:PlayRewardAnimation("change")
            else
              self.rewardMultipleText.text = "x" .. bonus
              self.rewardMultipleAfterText.text = ""
              self:PlayRewardAnimation("Default")
              self.isChange = true
            end
          else
            self.rewardNode:SetActive(false)
          end
        elseif IsNotNull(self.rewardNode) then
          self.rewardNode:SetActive(false)
        end
        self.star = curStar
      end
    end
    if self.bossState ~= BossState.None and self.bossState ~= BossState.Ruins then
      if IsNull(self.timingText) then
        return
      end
      local offsetTime = self.endTime - curTime
      if 0 < offsetTime then
        local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(offsetTime)
        self.timingText.text = timeStr
      end
    end
  end
end

local function RefreshState(self)
  if self.startTime and self.s0AllianceBossInfo then
    if self.bossState == BossState.Ruins then
      if self.ruinsModelLabel then
        self.ruinsModelLabel:SetActive(true)
      end
      if self.modelLabel then
        self.modelLabel:SetActive(false)
      end
      if self.bossWorldModel then
        self.bossWorldModel:SetActive(false)
      end
      return
    end
    local curTs = UITimeManager:GetInstance():GetServerTime()
    local offset = self.endTime - curTs
    if offset <= 4500 then
      if self.bossWorldModel then
        self.bossWorldModel:SetActive(true)
      end
      self:ChangeToRuinsState(offset)
      return
    end
    if self.bossWorldModel then
      self.bossWorldModel:SetActive(true)
    end
    if self.ruinsModelLabel then
      self.ruinsModelLabel:SetActive(false)
    end
    if self.modelLabel then
      self.modelLabel:SetActive(true)
    end
    local damage = self.s0AllianceBossInfo.damage
    local maxDamage = self.allianceMaxDmg
    if damage >= maxDamage then
      self:ChangeState(FsmState.Weakness)
      self.bossState = BossState.Weakness
      return
    end
    offset = curTs - self.startTime
    if 0 <= offset and offset < 4000 then
      self.bossState = BossState.Born
      self:ChangeState(FsmState.Born)
    else
      local lastStarTime = self.s0AllianceBossInfo.lastStarTime
      if 0 < lastStarTime then
        offset = curTs - lastStarTime
        if 0 <= offset and offset < 7800 then
          local curStar = self.s0AllianceBossInfo.rewardProgress
          if curStar ~= self.maxStar then
            self:ChangeState(FsmState.Change, curStar)
            self.bossState = BossState.Change
            self.lastCheckTime = nil
          end
        else
          self:ChangeState(FsmState.Idle)
          self.bossState = BossState.Idle
        end
      else
        self:ChangeState(FsmState.Idle)
        self.bossState = BossState.Idle
      end
    end
  end
end

local function CheckBossAttack(self)
  if self.bossState ~= BossState.None and self.bossState ~= BossState.Weakness and self.bossState ~= BossState.Ruins then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.lastCheckTime == nil then
      self.lastCheckTime = curTime
      return
    end
    if curTime - self.lastCheckTime >= self.bossAttackInternal then
      self.lastCheckTime = curTime
      if self.fsmState < FsmState.Attack then
        self:ChangeState(FsmState.Attack)
        self.bossState = BossState.Attack
      end
    end
  end
end

local function CheckBossRuins(self)
  if self.bossState ~= BossState.None and self.bossState ~= BossState.Ruins and self.endTime and self.endTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local offset = self.endTime - curTime
    if offset <= 4500 then
      self:ChangeToRuinsState(offset)
    end
  end
end

local function RefreshHpSlider(self)
  if self.bossState == BossState.None or self.bossState == BossState.Ruins then
    return
  end
  if self.marchInfo and self.s0AllianceBossInfo then
    local damage = self.s0AllianceBossInfo.damage
    if self.curAllianceDmg ~= damage or self.isInit then
      local sliderValue = 0
      local curProgress = self.s0AllianceBossInfo.rewardProgress
      if damage >= self.allianceMaxDmg then
        sliderValue = 1
      elseif damage < self.allianceMaxDmg and 0 < self.allianceMaxDmg then
        local count = #self.allianceDmgArr - 1
        local perValue = 1 / count
        if curProgress == count then
          sliderValue = 1
        elseif curProgress == 0 then
          sliderValue = damage / self.allianceDmgArr[1] * perValue
        elseif 0 < damage then
          local curDmg = self.allianceDmgArr[curProgress]
          local nextDmg = self.allianceDmgArr[curProgress + 1]
          sliderValue = curProgress * perValue + (damage - curDmg) / (nextDmg - curDmg) * perValue
        end
        sliderValue = sliderValue < 1 and sliderValue or 1
      end
      if not self.isInit then
        local play, timer = self:PlayerSliderEffect(self.allianceSliderEffect, self.allianceEffectTimer)
        if play then
          self.allianceEffectTimer = timer
        end
      end
      if IsNotNull(self.allianceDmgSlider) then
        local localPosition = self.allianceDmgSlider.transform.localPosition
        self.hpSliderPos1.x = (sliderValue - 1) * ALLIANCE_SLIDER_WIDTH / 2
        self.hpSliderPos1.y = localPosition.y
        self.allianceDmgSlider.transform.localPosition = self.hpSliderPos1
        self.hpSliderScale1.x = sliderValue * ALLIANCE_SLIDER_WIDTH
        self.hpSliderScale1.y = SLIDER_HEIGHT
        self.allianceDmgSlider.size = self.hpSliderScale1
      end
      if IsNotNull(self.allianceDmgText) then
        if curProgress == self.maxStar then
          local dmgStr = string.GetFormattedStr2(damage)
          local maxDmgStr = string.GetFormattedStr2(self.allianceMaxDmg)
          self.allianceDmgText.text = dmgStr .. "/" .. maxDmgStr
        else
          local curMaxHp = self.allianceDmgArr[curProgress + 1]
          local dmgStr = string.GetFormattedStr2(damage)
          local maxDmgStr = string.GetFormattedStr2(curMaxHp)
          self.allianceDmgText.text = dmgStr .. "/" .. maxDmgStr
        end
        self.curAllianceDmg = damage
      end
    end
  end
  if not self.isMine then
    return
  end
  local curPersonalDmg = DataCenter.S0AllianceBossDataManager:GetCurPersonalDmg() or 0
  if curPersonalDmg ~= self.curPersonalDmg or self.isInit then
    local sliderValue = 0
    if curPersonalDmg > self.personalDmgMax then
      sliderValue = 1
    elseif curPersonalDmg <= self.personalDmgMax and 0 < self.personalDmgMax then
      sliderValue = curPersonalDmg / self.personalDmgMax
      sliderValue = sliderValue < 1 and sliderValue or 1
    end
    if not self.isInit and self.personalSliderEffect then
      local play, timer = self:PlayerSliderEffect(self.personalSliderEffect, self.personalEffectTimer)
      if play then
        self.personalEffectTimer = timer
      end
    end
    if IsNotNull(self.personalDmgSlider) then
      local localPosition = self.personalDmgSlider.transform.localPosition
      self.hpSliderPos2.x = (sliderValue - 1) * ALLIANCE_SLIDER_WIDTH / 2
      self.hpSliderPos2.y = localPosition.y
      self.personalDmgSlider.transform.localPosition = self.hpSliderPos2
      self.hpSliderScale2.x = sliderValue * ALLIANCE_SLIDER_WIDTH
      self.hpSliderScale2.y = SLIDER_HEIGHT
      self.personalDmgSlider.size = self.hpSliderScale2
    end
    local dmgStr = string.GetFormattedStr2(curPersonalDmg)
    local maxDmgStr = string.GetFormattedStr2(self.personalDmgMax)
    if IsNotNull(self.personalDmgText) then
      self.personalDmgText.text = dmgStr .. "/" .. maxDmgStr
    end
    self.curPersonalDmg = curPersonalDmg
  end
end

local function OnUpdateSec(self)
  self:RefreshView()
  self:CheckBossRuins()
  self:CheckBossAttack()
end

local function OnUpdate(self)
  if self.fsm then
    self.fsm:OnUpdate()
  end
end

local function HideBossModel(self)
  if self.bossWorldModel then
    self.bossWorldModel:SetActive(false)
  end
end

local function SetBossState(self, hide, cancel)
  if self.uuid then
    local troop = CS.SceneManager.World:GetTroop(self.uuid)
    if troop then
      troop:SetVisible(not hide)
      if not hide and cancel then
        self:ChangeState(FsmState.Ruins)
      end
    end
  end
end

local function ChangeToRuinsState(self, offset)
  self:ChangeState(FsmState.Ruins, offset)
  self.bossState = BossState.Ruins
  if self.ruinsModelLabel then
    self.ruinsModelLabel:SetActive(true)
  end
  if self.modelLabel then
    self.modelLabel:SetActive(false)
  end
end

local function PlayBossAnimation(self, animName, loop, rewind, startTime, callback)
  if self.bossTimelinePlayer == nil then
    return
  end
  if string.IsNullOrEmpty(animName) then
    return
  end
  if animName == self.curBossAnimName then
    return
  end
  self.curBossAnimName = animName
  if self.bossTimer then
    self.bossTimer:Stop()
    self.bossTimer = nil
  end
  local mode = loop and DirectorWrapMode.Loop or DirectorWrapMode.Hold
  startTime = startTime or 0
  local length = self.bossTimelinePlayer:PlayTimelineAt(animName, mode, rewind, startTime)
  if callback then
    if 0 < length then
      local timer
      timer = TimerManager:GetInstance():DelayInvoke(function()
        callback()
        if timer then
          timer:Stop()
          timer = nil
        end
      end, length)
      self.bossTimer = timer
    else
      callback()
    end
  end
end

local function PlayBuildAnimation(self, animName, loop, rewind, startTime, callback)
  if self.buildTimelinePlayer == nil then
    return
  end
  if string.IsNullOrEmpty(animName) then
    return
  end
  if animName == self.curBuildAnimName then
    return
  end
  self.curBuildAnimName = animName
  if self.buildTimer then
    self.buildTimer:Stop()
    self.buildTimer = nil
  end
  local mode = loop and DirectorWrapMode.Loop or DirectorWrapMode.Hold
  startTime = startTime or 0
  local length = self.buildTimelinePlayer:PlayTimelineAt(animName, mode, rewind, startTime)
  if callback then
    if 0 < length then
      local timer
      timer = TimerManager:GetInstance():DelayInvoke(function()
        callback()
        if timer then
          timer:Stop()
          timer = nil
        end
      end, length)
      self.buildTimer = timer
    else
      callback()
    end
  end
end

local function StopBuildAnimation(self)
  if self.buildTimelinePlayer == nil then
    return
  end
  self.buildTimelinePlayer:StopTimeline()
end

local function SampleRewardAnimationAtTime(self, animName, time)
  if IsNull(self.rewardSimpleAnim) then
    return
  end
  if string.IsNullOrEmpty(animName) then
    return
  end
  self.rewardSimpleAnim:SampleAnimationAtTime(animName, time)
end

local function PlayRewardAnimation(self, animName, callback)
  if IsNull(self.rewardSimpleAnim) then
    return
  end
  if string.IsNullOrEmpty(animName) then
    return
  end
  if self.rewardTimer then
    self.rewardTimer:Stop()
    self.rewardTimer = nil
  end
  if callback then
    local length = self.rewardSimpleAnim:GetClipLength(animName)
    if 0 < length then
      local timer
      timer = TimerManager:GetInstance():DelayInvoke(function()
        callback()
        if timer then
          timer:Stop()
          timer = nil
        end
      end, length)
      self.rewardTimer = timer
    else
      callback()
    end
  end
  if self.rewardSimpleAnim:IsPlaying(animName) then
    self.rewardSimpleAnim:Rewind(animName)
  end
  self.rewardSimpleAnim:Play(animName)
end

local function PlayerSliderEffect(self, effect, timer)
  if effect and timer then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    local offset = curTs - timer
    if 0.7 < offset then
      effect:SetActive(false)
      effect:SetActive(true)
      return true, curTs
    end
  end
end

local function InitMaterial(self)
  if self.bossWorldModel and self.bossTimelinePlayer then
    if self.bossType == nil then
      local bossType = 1
      local bossName = self.bossTimelinePlayer.transform.name
      for i, v in pairs(BOSS_NAME_TYPE) do
        if string.contains(bossName, i) then
          bossType = v
          break
        end
      end
      self.bossType = bossType
    end
    local nodePath = BOSS_MATERIAL_NODE_PATH[self.bossType]
    if nodePath then
      local matNodeList = {}
      local oriMatList = {}
      for i, v in ipairs(nodePath) do
        local node = self.bossWorldModel.transform:Find(v)
        if IsNotNull(node) then
          local renderer = node:GetComponent(typeof(CS.UnityEngine.SkinnedMeshRenderer))
          if IsNotNull(renderer) then
            matNodeList[i] = renderer
            oriMatList[i] = renderer.sharedMaterial
          end
        end
      end
      self.matNodeList = matNodeList
      self.oriMatList = oriMatList
      self.allMatList = {}
      self.allMatReqs = {}
    end
  end
end

local function ChangeMaterial(self, stage)
  if stage == self.stage or stage ~= nil and (stage < 1 or stage >= self.maxStar) then
    return
  end
  if self.matNodeList == nil then
    return
  end
  self.stage = stage
  if self.allMatList and self.allMatList[stage] then
    for i, v in pairs(self.matNodeList) do
      if v and self.allMatList[stage][i] then
        v.material = self.allMatList[stage][i]
      end
    end
  else
    local matList = BOSS_STAGE_MAT_PATH[self.bossType]
    if matList then
      self.allMatList[stage] = {}
      for i, v in ipairs(self.matNodeList) do
        if v then
          local path = matList[i][stage]
          local req = CS.GameEntry.Resource:LoadAssetAsync(path, typeof(CS.UnityEngine.Material))
          if req then
            function req.completed(handle)
              if self.isDestroyed then
                return
              end
              if handle.isError then
                Logger.LogError("S0AllianceBoss -- ChangeMaterial Load Material error ! path = " .. path)
                return
              end
              local mat = CS.UnityEngine.Material.Instantiate(handle.asset)
              v.material = mat
              self.allMatList[stage][i] = mat
            end
          end
          self.allMatReqs[#self.allMatReqs + 1] = req
        end
      end
    end
  end
end

local function ResetMaterial(self)
  if self.matNodeList and self.oriMatList then
    for i, v in ipairs(self.matNodeList) do
      if v then
        v.sharedMaterial = self.oriMatList[i]
      end
    end
  end
  if self.allMatReqs then
    for _, v in pairs(self.allMatReqs) do
      if v then
        v:Release()
      end
    end
  end
end

S0AllianceBossActionCtrl.__init = __init
S0AllianceBossActionCtrl.__delete = __delete
S0AllianceBossActionCtrl.Init = Init
S0AllianceBossActionCtrl.InitModelData = InitModelData
S0AllianceBossActionCtrl.InitModelLabel = InitModelLabel
S0AllianceBossActionCtrl.InitData = InitData
S0AllianceBossActionCtrl.InitFsm = InitFsm
S0AllianceBossActionCtrl.Destroy = Destroy
S0AllianceBossActionCtrl.RefreshMarchInfo = RefreshMarchInfo
S0AllianceBossActionCtrl.RefreshTitleName = RefreshTitleName
S0AllianceBossActionCtrl.RefreshView = RefreshView
S0AllianceBossActionCtrl.OnUpdateSec = OnUpdateSec
S0AllianceBossActionCtrl.RefreshHpSlider = RefreshHpSlider
S0AllianceBossActionCtrl.ChangeToRuinsState = ChangeToRuinsState
S0AllianceBossActionCtrl.PlayBossAnimation = PlayBossAnimation
S0AllianceBossActionCtrl.PlayBuildAnimation = PlayBuildAnimation
S0AllianceBossActionCtrl.OnUpdate = OnUpdate
S0AllianceBossActionCtrl.RefreshState = RefreshState
S0AllianceBossActionCtrl.CheckBossAttack = CheckBossAttack
S0AllianceBossActionCtrl.CheckBossRuins = CheckBossRuins
S0AllianceBossActionCtrl.OnCreate = OnCreate
S0AllianceBossActionCtrl.StopBuildAnimation = StopBuildAnimation
S0AllianceBossActionCtrl.SampleRewardAnimationAtTime = SampleRewardAnimationAtTime
S0AllianceBossActionCtrl.PlayRewardAnimation = PlayRewardAnimation
S0AllianceBossActionCtrl.PlayerSliderEffect = PlayerSliderEffect
S0AllianceBossActionCtrl.ChangeState = ChangeState
S0AllianceBossActionCtrl.HideBossModel = HideBossModel
S0AllianceBossActionCtrl.SetBossState = SetBossState
S0AllianceBossActionCtrl.InitMaterial = InitMaterial
S0AllianceBossActionCtrl.ChangeMaterial = ChangeMaterial
S0AllianceBossActionCtrl.ResetMaterial = ResetMaterial
return S0AllianceBossActionCtrl
