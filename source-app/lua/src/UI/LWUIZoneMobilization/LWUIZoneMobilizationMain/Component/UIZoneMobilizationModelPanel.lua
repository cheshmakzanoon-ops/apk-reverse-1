local UIZoneMobilizationModelPanel = BaseClass("UIZoneMobilizationModelPanel", UIBaseContainer)
local base = UIBaseContainer
local UIZoneMobilizationModel = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.Component.UIZoneMobilizationModel")
local Localization = CS.GameEntry.Localization
local click_path = "Click"
local place_root_path = "Click/PlaceRoot"
local u_i_model_root_path = "Click/UIModelRoot"
local u_i_model_path = "Click/UIModelRoot/UIModel"
local point_text_group_path = "PointTextGroup"
local point_text_path = "PointTextGroup/PointText"
local click_point_path = "PointTextGroup/PointText/ClickPoint"
local red_point_path = "PointTextGroup/PointText/RedPoint"
local UIModelDataTabType = {
  [ZoneMobilizationTabType.Donated] = "ui_donate_model_3d",
  [ZoneMobilizationTabType.Attack] = "ui_attack_model_3d",
  [ZoneMobilizationTabType.Defend] = "ui_defend_model_3d"
}
UIZoneMobilizationModelPanel.EffectFlag = {
  Upgrade = 1,
  IdleLight = 2,
  IdleFire = 3,
  FlyawayDonated = 4,
  FlyawayAttack = 5,
  FlyawayDefend = 6,
  Attack = 7,
  Fire1 = 8,
  Fire2 = 9,
  Fire3 = 10
}
UIZoneMobilizationModelPanel.EffectPath = {
  [UIZoneMobilizationModelPanel.EffectFlag.Upgrade] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_longmendiao_shengji_ui.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.IdleLight] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_longmendiao_deng_ui.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.IdleFire] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_longmendiao_huohua_ui.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.FlyawayDonated] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_feiting_chuansong_loop_up_blue_ui.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.FlyawayAttack] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_feiting_chuansong_loop_down_blue_ui.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.FlyawayDefend] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_feiting_chuansong_loop_down_red_ui.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.Attack] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_s_jiluofu_feiting_jiqiang_ui.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.Fire1] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_A_build_jiluofu_feiting_03_red_UI_Fire_100p.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.Fire2] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_A_build_jiluofu_feiting_03_red_UI_Fire_60p.prefab",
  [UIZoneMobilizationModelPanel.EffectFlag.Fire3] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/UI/Eff_A_build_jiluofu_feiting_03_red_UI_Fire_30p.prefab"
}

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
  self.place_root = self:AddComponent(UIBaseContainer, place_root_path)
  self.u_i_model_root = self:AddComponent(UIBaseContainer, u_i_model_root_path)
  self.u_i_model = self:AddComponent(UIZoneMobilizationModel, u_i_model_path)
  self.u_i_model:Init(Draw2DUIModelType.Airship)
  self.point_text_group = self:AddComponent(UIBaseContainer, point_text_group_path)
  self.point_text = self:AddComponent(UITextMeshProUGUIEx, point_text_path)
  self.click_point = self:AddComponent(UIButton, click_point_path)
  self.click_point:SetOnClick(BindCallback(self, self.OnItemClick))
  self.red_point = self:AddComponent(UIImage, red_point_path)
end

local function ComponentDestroy(self)
  self.click = nil
  self.place_root = nil
  self.u_i_model_root = nil
  self.u_i_model = nil
  self.point_text_group = nil
  self.point_text = nil
  self.click_point = nil
  self.red_point = nil
end

local function DataDefine(self)
  self.tabType = nil
  self.stage = 0
  self.pointId = nil
  self.jumpPoint = nil
  self.bossState = nil
  self.stageType = nil
end

local function DataDestroy(self)
  self.tabType = nil
  self.stage = nil
  self.pointId = nil
  self.jumpPoint = nil
  self.bossState = nil
  self.stageType = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateDonatedProgressRewardData, self.OnUpdateDonatedProgressRewardData)
  self:AddUIListener(EventId.OnZoneMobilizationRedPointChanged, self.CheckPosRedPoint)
end

local function OnRemoveListener(self)
  self:AddUIListener(EventId.UpdateDonatedProgressRewardData, self.OnUpdateDonatedProgressRewardData)
  self:RemoveUIListener(EventId.OnZoneMobilizationRedPointChanged, self.CheckPosRedPoint)
  base.OnRemoveListener(self)
end

local function RefreshPanel(self, tabType, stage)
  if tabType == nil or tabType == ZoneMobilizationTabType.All or stage <= 0 then
    return
  end
  self.tabType = tabType
  self.stage = stage
  local stageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
  if tabType == ZoneMobilizationTabType.Attack then
    local zoneMobilizationAttackInfoData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationAttackInfoData()
    if zoneMobilizationAttackInfoData then
      self.stage = zoneMobilizationAttackInfoData.stage
      if self.stage and 0 < self.stage then
        stageType = DataCenter.LWZoneMobilizationManager:GetStageType(self.stage)
      end
    end
  end
  local pointId = DataCenter.LWZoneMobilizationManager:GetPointId()
  self.pointId = pointId
  self.stageType = stageType
  self:CheckPosRedPoint()
  if stageType == ZoneMobilizationStageType.Donated or stageType == ZoneMobilizationStageType.Sprint then
    self:SetModelShow(pointId <= 0)
    self:SetSelfPointShow(true)
  elseif stageType == ZoneMobilizationStageType.SettlementShow then
    self:SetBattleModelShow()
    self:SetBattlePointShow()
  elseif stageType == ZoneMobilizationStageType.Battle_Place then
    self:SetModelShow(false, true)
    self:SetTransferPointShow()
  elseif stageType == ZoneMobilizationStageType.Battle_Transfer then
    self:SetModelShow(false, true)
    self:SetTransferPointShow(true)
  elseif stageType == ZoneMobilizationStageType.Battle then
    local show = self:SetBattleModelShow()
    self:SetBattlePointShow(show)
  end
end

local function SetSelectState(self, isSelect)
  self.selectState:SetActive(isSelect)
end

local function OnItemClick(self)
  if self.tabType == ZoneMobilizationTabType.Donated then
    if self.red_point:GetActive() then
      self:CheckPosRedPoint(true)
    end
    if self.stageType > ZoneMobilizationStageType.Battle_Transfer and self.stageType ~= ZoneMobilizationStageType.Sprint then
      UIUtil.ShowTipsId("zone_mobilization_donate_end_tips")
      return
    end
    if DataCenter.LWZoneMobilizationManager:TryGetReward() then
      return
    end
    DataCenter.LWZoneMobilizationManager:DonateTabGotoPointHandler()
  else
    if self.bossState == ZoneMobilizationBossStatusFlag.Death then
      UIUtil.ShowTipsId("zone_mobilization_kill_tips")
      return
    elseif self.bossState == ZoneMobilizationBossStatusFlag.Escape then
      UIUtil.ShowTipsId("zone_mobilization_flee_tips")
      return
    end
    if self.jumpPoint and self.jumpPoint > 0 then
      if self.stageType == ZoneMobilizationStageType.Battle_Place and self.tabType == ZoneMobilizationTabType.Attack then
        DataCenter.LWZoneMobilizationManager:GotoPutBoss(self.jumpPoint)
      else
        DataCenter.LWZoneMobilizationManager:GotoWorldPoint(self.jumpPoint, self.serverId)
      end
    end
  end
end

local function SetModelShow(self, showPlace, judgeOpposite)
  local tabType = self.tabType
  showPlace = showPlace and tabType == ZoneMobilizationTabType.Donated
  self.place_root:SetActive(showPlace)
  self.u_i_model_root:SetActive(false)
  if showPlace then
    return
  end
  if self.stage == nil or self.stage <= 0 then
    return
  end
  local stageTemplate = DataCenter.LWZoneMobilizationStageTemplateManager:GetTemplate(self.stage)
  if stageTemplate == nil then
    return
  end
  local modelData = stageTemplate[UIModelDataTabType[tabType]]
  if not string.IsNullOrEmpty(modelData) then
    local pathArr = string.split(modelData, "|")
    if 1 < #pathArr then
      if tabType == ZoneMobilizationTabType.Donated then
        local donateInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDonatedInfoData()
        if donateInfo then
          local index = 1
          if donateInfo:IsCurStageFullProgress() and not donateInfo:IsCanReceiveDonatedStageReward() then
            index = 2
          end
          self.u_i_model:ReInit(pathArr[index], self:GetEffectListAndAnim())
          self.u_i_model_root:SetActive(true)
        end
      end
    else
      if judgeOpposite and tabType == ZoneMobilizationTabType.Defend then
        local defendInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
        if defendInfo == nil or defendInfo.bossSrcPointId == nil or defendInfo.bossSrcPointId == 0 then
          return
        end
      end
      self.u_i_model:ReInit(pathArr[1], self:GetEffectListAndAnim())
      self.u_i_model_root:SetActive(true)
    end
  end
end

local function SetBattleModelShow(self)
  self.place_root:SetActive(false)
  self.u_i_model_root:SetActive(false)
  local tabType = self.tabType
  self.bossState = ZoneMobilizationBossStatusFlag.None
  local gone = false
  if tabType == ZoneMobilizationTabType.Attack then
    local attackInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationAttackInfoData()
    if attackInfo then
      self.bossState = attackInfo.bossState
      if attackInfo.bossState > ZoneMobilizationBossStatusFlag.Alive then
        gone = true
      end
    end
  elseif tabType == ZoneMobilizationTabType.Defend then
    local defendInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
    if defendInfo then
      self.bossState = defendInfo.bossState
      if defendInfo.bossState > ZoneMobilizationBossStatusFlag.Alive then
        gone = true
      end
    end
  end
  local hasModel = false
  if self.stage and self.stage > 0 then
    local stageTemplate = DataCenter.LWZoneMobilizationStageTemplateManager:GetTemplate(self.stage)
    if stageTemplate then
      local modelData = stageTemplate[UIModelDataTabType[tabType]]
      if not string.IsNullOrEmpty(modelData) then
        local pathArr = string.split(modelData, "|")
        if #pathArr <= 1 then
          self.u_i_model:ReInit(pathArr[1], self:GetEffectListAndAnim())
          self.u_i_model_root:SetActive(true)
          hasModel = true
        end
      end
    end
  end
  return not gone and hasModel
end

local function SetPointShow(self, showPos, serverId, point)
  serverId = serverId or DataCenter.LWZoneMobilizationManager.serverId
  self.serverId = serverId
  self.jumpPoint = point
  showPos = showPos and point and 0 < point
  if showPos and serverId and 0 < serverId and point and 0 < point then
    local pos = SceneUtils.IndexToTilePos(point, ForceChangeScene.World)
    local posStr = Localization:GetString("zone_mobilization_coordinates", serverId, pos.x, pos.y)
    self.point_text:SetText(posStr)
  end
  self.point_text_group:SetActive(showPos)
end

local function SetSelfPointShow(self, donate)
  if donate and self.tabType and self.tabType == ZoneMobilizationTabType.Donated then
    self:SetPointShow(true, nil, self.pointId)
  else
    self:SetPointShow()
  end
end

local function SetTransferPointShow(self, selfTransfer)
  if self.tabType == ZoneMobilizationTabType.Donated then
    self:SetPointShow(true, nil, self.pointId)
  elseif self.tabType == ZoneMobilizationTabType.Attack then
    if selfTransfer then
      local serverId, pointId
      local attackInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationAttackInfoData()
      if attackInfo and attackInfo.bossPointId and attackInfo.bossPointId > 0 then
        serverId = attackInfo.bossServerId
        pointId = attackInfo.bossPointId
      end
      self:SetPointShow(false, serverId, pointId)
    else
      self:SetPointShow(false, nil, self.pointId)
    end
  elseif self.tabType == ZoneMobilizationTabType.Defend then
    local serverId, pointId
    local defendInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
    if defendInfo and defendInfo.bossPointId and defendInfo.bossPointId > 0 then
      serverId = DataCenter.LWZoneMobilizationManager.serverId
      pointId = defendInfo.bossPointId
    end
    self:SetPointShow(false, serverId, pointId)
  end
end

local function SetBattlePointShow(self, show)
  if show then
    if self.tabType == ZoneMobilizationTabType.Attack then
      local attackInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationAttackInfoData()
      if attackInfo then
        self:SetPointShow(true, attackInfo.bossServerId, attackInfo.bossPointId)
      else
        self:SetPointShow()
      end
    elseif self.tabType == ZoneMobilizationTabType.Defend then
      local defendInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
      if defendInfo then
        self:SetPointShow(true, nil, defendInfo.bossPointId)
      else
        self:SetPointShow()
      end
    end
  else
    self:SetPointShow()
  end
end

local function GetFingerArrowTargetRoot(self)
  return self.u_i_model_root
end

local function GetEffectListAndAnim(self)
  local effectList, anim
  local tabType = self.tabType
  if tabType == ZoneMobilizationTabType.Donated then
    if self.stageType == ZoneMobilizationStageType.Donated or self.stageType == ZoneMobilizationStageType.Sprint then
      effectList = {}
      table.insert(effectList, self.EffectPath[self.EffectFlag.IdleLight])
      table.insert(effectList, self.EffectPath[self.EffectFlag.IdleFire])
    elseif self.stageType == ZoneMobilizationStageType.Battle_Transfer then
      effectList = {}
      table.insert(effectList, self.EffectPath[self.EffectFlag.FlyawayDonated])
    end
  elseif tabType == ZoneMobilizationTabType.Attack then
    if self.stageType == ZoneMobilizationStageType.Battle_Transfer then
      effectList = {}
      table.insert(effectList, self.EffectPath[self.EffectFlag.FlyawayAttack])
      anim = "transmitting"
    elseif self.stageType == ZoneMobilizationStageType.Battle or self.stageType == ZoneMobilizationStageType.SettlementShow then
      effectList = {}
      table.insert(effectList, self.EffectPath[self.EffectFlag.Attack])
      anim = "attack"
    end
  elseif tabType == ZoneMobilizationTabType.Defend then
    if self.stageType == ZoneMobilizationStageType.Battle_Place or self.stageType == ZoneMobilizationStageType.Battle_Transfer then
      local defendInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
      if defendInfo ~= nil and defendInfo.bossSrcPointId ~= nil and defendInfo.bossSrcPointId ~= 0 then
        effectList = {}
        table.insert(effectList, self.EffectPath[self.EffectFlag.FlyawayDefend])
        anim = "transmitting"
      end
    elseif self.stageType == ZoneMobilizationStageType.Battle or self.stageType == ZoneMobilizationStageType.SettlementShow then
      effectList = {}
      local zoneMobilizationDefendInfoData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
      if zoneMobilizationDefendInfoData then
        local totalHp = GetTableData(TableName.ZoneMobilizationBoss, zoneMobilizationDefendInfoData.bossId, "rallyboss_hp")
        local bossCurHp = zoneMobilizationDefendInfoData.curHp
        local progress = bossCurHp / totalHp
        if 0.7 <= progress then
          table.insert(effectList, self.EffectPath[self.EffectFlag.Fire3])
        elseif 0.3 <= progress then
          table.insert(effectList, self.EffectPath[self.EffectFlag.Fire2])
        else
          table.insert(effectList, self.EffectPath[self.EffectFlag.Fire1])
        end
      end
    end
  end
  return effectList, anim
end

local function OnUpdateDonatedProgressRewardData(self)
  if self.tabType == ZoneMobilizationTabType.Donated then
    self.u_i_model:PlayEffect(self.EffectPath[self.EffectFlag.Upgrade], 5)
  end
end

local function CheckPosRedPoint(self, refresh)
  local showRedPoint = false
  if self.tabType == ZoneMobilizationTabType.Donated and DataCenter.LWZoneMobilizationManager:GetPosRedPoint() then
    if refresh then
      DataCenter.LWZoneMobilizationManager:SetPosRedPoint()
      return
    end
    showRedPoint = true
  end
  self.red_point:SetActive(showRedPoint)
end

UIZoneMobilizationModelPanel.OnCreate = OnCreate
UIZoneMobilizationModelPanel.OnDestroy = OnDestroy
UIZoneMobilizationModelPanel.OnEnable = OnEnable
UIZoneMobilizationModelPanel.OnDisable = OnDisable
UIZoneMobilizationModelPanel.ComponentDefine = ComponentDefine
UIZoneMobilizationModelPanel.ComponentDestroy = ComponentDestroy
UIZoneMobilizationModelPanel.DataDefine = DataDefine
UIZoneMobilizationModelPanel.DataDestroy = DataDestroy
UIZoneMobilizationModelPanel.OnAddListener = OnAddListener
UIZoneMobilizationModelPanel.OnRemoveListener = OnRemoveListener
UIZoneMobilizationModelPanel.RefreshPanel = RefreshPanel
UIZoneMobilizationModelPanel.SetSelectState = SetSelectState
UIZoneMobilizationModelPanel.OnItemClick = OnItemClick
UIZoneMobilizationModelPanel.SetModelShow = SetModelShow
UIZoneMobilizationModelPanel.SetBattleModelShow = SetBattleModelShow
UIZoneMobilizationModelPanel.SetPointShow = SetPointShow
UIZoneMobilizationModelPanel.SetSelfPointShow = SetSelfPointShow
UIZoneMobilizationModelPanel.SetTransferPointShow = SetTransferPointShow
UIZoneMobilizationModelPanel.SetBattlePointShow = SetBattlePointShow
UIZoneMobilizationModelPanel.GetFingerArrowTargetRoot = GetFingerArrowTargetRoot
UIZoneMobilizationModelPanel.GetEffectListAndAnim = GetEffectListAndAnim
UIZoneMobilizationModelPanel.OnUpdateDonatedProgressRewardData = OnUpdateDonatedProgressRewardData
UIZoneMobilizationModelPanel.CheckPosRedPoint = CheckPosRedPoint
return UIZoneMobilizationModelPanel
