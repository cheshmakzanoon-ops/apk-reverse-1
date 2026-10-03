local KillZombieALKirovModelPanel = BaseClass("KillZombieALKirovModelPanel", UIBaseContainer)
local base = UIBaseContainer
local KillZombieALKirovModel = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieALKirovModel")
local Localization = CS.GameEntry.Localization
local click_path = "Click"
local u_i_model_path = "Click/UIModel"
local point_text_group_path = "TextRoot/PointTextGroup"
local point_text_path = "TextRoot/PointTextGroup/PointText"
local click_point_path = "TextRoot/PointTextGroup/PointText/ClickPoint"
local title_text_path = "NameGroup/TitleText"
local level_icon_path = "NameGroup/LevelIcon"
local personal_dmg_text_path = "TextRoot/DmgRoot/PersonalDmgText"
local al_dmg_text_path = "TextRoot/DmgRoot/AlDmgText"
local dmg_root_path = "TextRoot/DmgRoot"
local red_point_path = "TextRoot/PointTextGroup/RedPoint"
local UI_MODEL_DATA = "ui_attack_model_3d"
local EffectFlag = {
  IdleLight = 1,
  IdleFire = 2,
  Attack = 3,
  Fire1 = 4,
  Fire2 = 5,
  Fire3 = 6
}
local EffectPath = {
  [EffectFlag.IdleLight] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_longmendiao_deng_ui.prefab",
  [EffectFlag.IdleFire] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_longmendiao_huohua_ui.prefab",
  [EffectFlag.Attack] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_feiting_jiqiang_ui.prefab",
  [EffectFlag.Fire1] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_A_build_jiluofu_feiting_03_red_UI_Fire_100p.prefab",
  [EffectFlag.Fire2] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_A_build_jiluofu_feiting_03_red_UI_Fire_60p.prefab",
  [EffectFlag.Fire3] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_A_build_jiluofu_feiting_03_red_UI_Fire_30p.prefab"
}
local BATTLE_GUARD_TIME = 4
local SETTLEMENT_GUARD_TIME = {867, 2534}
local LAUNCH_STATION_MODEL_PATH = "A_build_jiluofu_longmendiao_blue_UI"
local BOSS_MODEL_PATH = "A_build_jiluofu_feiting_03_blue_UI"
local BOX_MODEL_PATH = "O_env_baoxiang_1_5"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.click = self:AddComponent(UIButton, click_path)
  self.click:SetOnClick(BindCallback(self, self.OnItemClick))
  self.u_i_model = self:AddComponent(KillZombieALKirovModel, u_i_model_path)
  self.point_text_group = self:AddComponent(UIBaseContainer, point_text_group_path)
  self.point_text = self:AddComponent(UITextMeshProUGUIEx, point_text_path)
  self.click_point = self:AddComponent(UIButton, click_point_path)
  self.click_point:SetOnClick(BindCallback(self, self.OnItemClick))
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.level_icon = self:AddComponent(UIButton, level_icon_path)
  self.personal_dmg_text = self:AddComponent(UITextMeshProUGUIEx, personal_dmg_text_path)
  self.al_dmg_text = self:AddComponent(UITextMeshProUGUIEx, al_dmg_text_path)
  self.dmg_root = self:AddComponent(UIBaseContainer, dmg_root_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
end

local function ComponentDestroy(self)
  self.click = nil
  self.u_i_model = nil
  self.point_text_group = nil
  self.point_text = nil
  self.click_point = nil
  self.title_text = nil
  self.level_icon = nil
  self.personal_dmg_text = nil
  self.al_dmg_text = nil
  self.dmg_root = nil
  self.red_point = nil
end

local function DataDefine(self)
  self.pointId = nil
  self.jumpPoint = nil
  self.bossState = nil
  self.stageType = nil
end

local function DataDestroy(self)
  self.pointId = nil
  self.jumpPoint = nil
  self.bossState = nil
  self.stageType = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener()
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshPanel(self, bossId)
  if bossId == nil or bossId == 0 then
    return
  end
  self.bossId = bossId
  local newAlData = DataCenter.ActivityKillZombieManager.newAlData
  self:SetModelShow(bossId, newAlData)
  self:SetPointShow(newAlData)
  self:SetDamageText(newAlData)
  self:UpdateNameLevel(bossId)
end

local function SetModelShow(self, bossId, newAlData)
  if bossId == nil or bossId <= 0 then
    return
  end
  local stage = ChallengeZombieAlBossStage.None
  if newAlData and newAlData.bossUuid ~= nil and self.bossId == newAlData.bossId then
    stage = newAlData.stage
  end
  self.red_point:SetActive(DataCenter.ActivityKillZombieManager:GetNewChallengeRedPoint())
  self.stage = stage
  local startTime = newAlData and newAlData.stageStartTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if stage <= ChallengeZombieAlBossStage.Prepare then
    self.u_i_model:ChangeModelType(Draw2DUIModelType.KillZombieKirov, LAUNCH_STATION_MODEL_PATH, {
      EffectPath[EffectFlag.IdleLight],
      EffectPath[EffectFlag.IdleFire]
    }, "idle")
  elseif stage == ChallengeZombieAlBossStage.Battle then
    local offset = curTime - startTime
    if 0 < offset and offset < BATTLE_GUARD_TIME then
      self.u_i_model:ChangeModelType(Draw2DUIModelType.KillZombieKirov, LAUNCH_STATION_MODEL_PATH, nil, "recycle", function()
        self.u_i_model:ReInit(BOSS_MODEL_PATH, self:GetAttackFireEffect(), "attack")
      end)
    else
      self.u_i_model:ChangeModelType(Draw2DUIModelType.KillZombieKirov, BOSS_MODEL_PATH, self:GetAttackFireEffect(), "attack")
    end
  elseif stage == ChallengeZombieAlBossStage.Settlement then
    local offset = curTime - startTime
    if 0 < offset then
      if offset < SETTLEMENT_GUARD_TIME[1] then
        self.u_i_model:ChangeModelType(Draw2DUIModelType.KillZombieKirov, BOSS_MODEL_PATH, nil, "leave", function()
          self.u_i_model:ChangeModelType(Draw2DUIModelType.KillZombieBox, BOX_MODEL_PATH, nil, "born")
        end)
      elseif offset < SETTLEMENT_GUARD_TIME[2] then
        self.u_i_model:ChangeModelType(Draw2DUIModelType.KillZombieBox, BOX_MODEL_PATH, nil, "born")
      else
        self.u_i_model:ChangeModelType(Draw2DUIModelType.KillZombieBox, BOX_MODEL_PATH, nil, "idle")
      end
    else
      self.u_i_model:ChangeModelType(Draw2DUIModelType.KillZombieBox, BOX_MODEL_PATH, nil, "idle")
    end
  end
end

local function SetPointShow(self, newAlData)
  local showPos = self.stage >= ChallengeZombieAlBossStage.Prepare and self.stage <= ChallengeZombieAlBossStage.Settlement
  local point = newAlData and newAlData.bossPointId or 0
  local bossServerId = newAlData and newAlData.bossServerId or nil
  showPos = showPos and point and 0 < point
  self.point = 0
  if showPos then
    local serverId = bossServerId or LuaEntry.Player:GetSourceServerId()
    if serverId and 0 < serverId and point and 0 < point then
      local pos = SceneUtils.IndexToTilePos(point, ForceChangeScene.World)
      local posStr = Localization:GetString("zone_mobilization_coordinates", serverId, pos.x, pos.y)
      self.point_text:SetText(posStr)
    end
    self.point = point
  end
  self.point_text_group:SetActive(showPos)
end

local function SetDamageText(self, newAlData)
  local showDmg = false
  if self.stage == ChallengeZombieAlBossStage.Battle or self.stage == ChallengeZombieAlBossStage.Settlement then
    showDmg = true
    if newAlData then
      local dmgText1 = string.GetFormattedGiga2(newAlData.personalDamage)
      self.personal_dmg_text:SetLocalText("challenge_zombie_person_score", dmgText1)
      local dmgText2 = string.GetFormattedGiga2(newAlData.allianceDamage)
      self.al_dmg_text:SetLocalText("challenge_zombie_alliance_score", dmgText2)
    end
  end
  self.dmg_root:SetActive(showDmg)
end

local function UpdateNameLevel(self, bossId)
  local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
  if template then
    local icon = template.progress_score_icon
    if not string.IsNullOrEmpty(icon) then
      self.level_icon:LoadSprite(icon)
    end
    if self.stage <= ChallengeZombieAlBossStage.Prepare then
      self.title_text:SetLocalText(template.building_name)
    elseif self.stage < ChallengeZombieAlBossStage.Settlement then
      local monsterId = template.world_monster
      if 0 < monsterId then
        local name = GetTableData(TableName.Monster, monsterId, "name")
        self.title_text:SetLocalText(name)
      end
    elseif self.stage == ChallengeZombieAlBossStage.Settlement then
      self.title_text:SetLocalText("challenge_zombie_box_title")
    end
  end
end

local function GetAttackFireEffect(self)
  local newAlData = DataCenter.ActivityKillZombieManager.newAlData
  if newAlData then
    local weaknessLevel = newAlData.weaknessLevel
    local effectList = {}
    if weaknessLevel == 1 then
      table.insert(effectList, EffectPath[EffectFlag.Fire3])
    elseif weaknessLevel == 2 then
      table.insert(effectList, EffectPath[EffectFlag.Fire2])
    elseif weaknessLevel == 3 then
      table.insert(effectList, EffectPath[EffectFlag.Fire1])
    end
    table.insert(effectList, EffectPath[EffectFlag.Attack])
    return effectList
  end
end

local function OnItemClick(self)
  self:UIBroadcast(EventId.ChallengeZombieOnUIModelClicked)
end

KillZombieALKirovModelPanel.OnCreate = OnCreate
KillZombieALKirovModelPanel.OnDestroy = OnDestroy
KillZombieALKirovModelPanel.OnEnable = OnEnable
KillZombieALKirovModelPanel.OnDisable = OnDisable
KillZombieALKirovModelPanel.ComponentDefine = ComponentDefine
KillZombieALKirovModelPanel.ComponentDestroy = ComponentDestroy
KillZombieALKirovModelPanel.DataDefine = DataDefine
KillZombieALKirovModelPanel.DataDestroy = DataDestroy
KillZombieALKirovModelPanel.OnAddListener = OnAddListener
KillZombieALKirovModelPanel.OnRemoveListener = OnRemoveListener
KillZombieALKirovModelPanel.RefreshPanel = RefreshPanel
KillZombieALKirovModelPanel.OnItemClick = OnItemClick
KillZombieALKirovModelPanel.SetModelShow = SetModelShow
KillZombieALKirovModelPanel.SetPointShow = SetPointShow
KillZombieALKirovModelPanel.GetAttackFireEffect = GetAttackFireEffect
KillZombieALKirovModelPanel.SetDamageText = SetDamageText
KillZombieALKirovModelPanel.UpdateNameLevel = UpdateNameLevel
return KillZombieALKirovModelPanel
