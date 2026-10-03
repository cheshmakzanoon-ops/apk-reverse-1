local base = UIBaseContainer
local LWUIBerserkBossItemRender = BaseClass("LWUIBerserkBossItemRender", base)
local normalState_path = "NormalState"
local selectState_path = "SelectState"
local levelText_path = "LevelText"
local worldBossRawImage_path = "WorldBossRawImage"
local battleStateContent_path = "BattleStateContent"
local attackingState_path = "BattleStateContent/AttackingState"
local waitingState_path = "BattleStateContent/WaitingState"
local stateDesText_path = "BattleStateContent/StateDesText"
local deadState_path = "DeadState"
local btn_path = "Btn"
local redPoint_path = "RedPoint"

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
  self.normalState = self:AddComponent(UIBaseContainer, normalState_path)
  self.selectState = self:AddComponent(UIBaseContainer, selectState_path)
  self.levelText = self:AddComponent(UIText, levelText_path)
  self.worldBossRawImage = self:AddComponent(UIRawImage, worldBossRawImage_path)
  self.battleStateContent = self:AddComponent(UIBaseContainer, battleStateContent_path)
  self.attackingState = self:AddComponent(UIBaseContainer, attackingState_path)
  self.waitingState = self:AddComponent(UIBaseContainer, waitingState_path)
  self.stateDesText = self:AddComponent(UIText, stateDesText_path)
  self.deadState = self:AddComponent(UIBaseContainer, deadState_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.redPoint = self:AddComponent(UIBaseContainer, redPoint_path)
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
end

local function ComponentDestroy(self)
  self.normalState = nil
  self.selectState = nil
  self.levelText = nil
  self.worldBossRawImage = nil
  self.battleStateContent = nil
  self.attackingState = nil
  self.waitingState = nil
  self.stateDesText = nil
  self.deadState = nil
  self.btn = nil
  self.redPoint = nil
end

local function DataDefine(self)
  self.itemIndex = 1
  self.berserkBossInfo = nil
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.berserkBossInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateBerserkBossRewardAndAttackTimesData, self.RefreshBossState)
  self:AddUIListener(EventId.UpdateSingleBerserkBossInfoData, self.OnUpdateSingleBerserkBossInfoData)
  self:AddUIListener(EventId.ChangeSelectBerserkBoss, self.OnChangeSelectBerserkBoss)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateBerserkBossRewardAndAttackTimesData, self.RefreshBossState)
  self:RemoveUIListener(EventId.UpdateSingleBerserkBossInfoData, self.OnUpdateSingleBerserkBossInfoData)
  self:RemoveUIListener(EventId.ChangeSelectBerserkBoss, self.OnChangeSelectBerserkBoss)
  base.OnRemoveListener(self)
end

local function OnUpdateSingleBerserkBossInfoData(self, uuid)
  if self.berserkBossInfo ~= nil and self.berserkBossInfo.uuid == uuid then
    self:RefreshBossState()
  end
end

local function OnChangeSelectBerserkBoss(self, data)
  if self.berserkBossInfo ~= nil then
    local isSelect = data.uuid == self.berserkBossInfo.uuid
    self:RefreshSelectState(isSelect)
  end
end

local function InitData(self, index, berserkBossInfo, isSelect)
  self.itemIndex = index
  self.berserkBossInfo = berserkBossInfo
  if self.berserkBossInfo == nil then
    return
  end
  local activityBerserkBossTemplate = DataCenter.LWActivityBerserkBossTemplateManager:GetTemplate(self.berserkBossInfo.bossId)
  if activityBerserkBossTemplate ~= nil then
    self.levelText:SetText("Lv." .. tostring(activityBerserkBossTemplate.level))
    if not string.IsNullOrEmpty(activityBerserkBossTemplate.icon) then
      self.worldBossRawImage:LoadSpriteAuto(activityBerserkBossTemplate.icon)
    end
  end
  self:RefreshBossState()
  self:RefreshSelectState(isSelect)
end

local function RefreshBossState(self)
  self.deadState:SetActive(false)
  self.battleStateContent:SetActive(true)
  if self.berserkBossInfo:IsComingSoon() then
    self.waitingState:SetActive(true)
    self.attackingState:SetActive(false)
    self.stateDesText:SetLocalText("activity_berserkboss_state_01")
    self.redPoint:SetActive(false)
  elseif self.berserkBossInfo:IsAttacking() then
    self.waitingState:SetActive(false)
    self.attackingState:SetActive(true)
    self.stateDesText:SetLocalText("activity_berserkboss_state_02")
    local surplusTimes = DataCenter.LWBerserkBossManager:GetBerserkBossSurplusAttackTimes(self.berserkBossInfo.uuid)
    self.redPoint:SetActive(0 < surplusTimes)
  elseif DataCenter.LWBerserkBossManager:GetBerserkBossIsReceiveReward(self.berserkBossInfo.uuid) then
    self.waitingState:SetActive(false)
    self.attackingState:SetActive(true)
    self.stateDesText:SetLocalText("activity_berserkboss_state_03")
    self.redPoint:SetActive(true)
  elseif DataCenter.LWBerserkBossManager:GetBerserkBossIsDead(self.berserkBossInfo.uuid) then
    self.deadState:SetActive(true)
    self.battleStateContent:SetActive(false)
    self.redPoint:SetActive(false)
  end
end

local function RefreshSelectState(self, isSelect)
  self.normalState:SetActive(not isSelect)
  self.selectState:SetActive(isSelect)
end

local function BtnClick(self)
  if self.berserkBossInfo then
    EventManager:GetInstance():Broadcast(EventId.ChangeSelectBerserkBoss, self.berserkBossInfo)
  end
end

LWUIBerserkBossItemRender.OnCreate = OnCreate
LWUIBerserkBossItemRender.OnDestroy = OnDestroy
LWUIBerserkBossItemRender.OnEnable = OnEnable
LWUIBerserkBossItemRender.OnDisable = OnDisable
LWUIBerserkBossItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossItemRender.DataDefine = DataDefine
LWUIBerserkBossItemRender.DataDestroy = DataDestroy
LWUIBerserkBossItemRender.OnAddListener = OnAddListener
LWUIBerserkBossItemRender.OnRemoveListener = OnRemoveListener
LWUIBerserkBossItemRender.InitData = InitData
LWUIBerserkBossItemRender.RefreshSelectState = RefreshSelectState
LWUIBerserkBossItemRender.RefreshBossState = RefreshBossState
LWUIBerserkBossItemRender.BtnClick = BtnClick
LWUIBerserkBossItemRender.OnUpdateSingleBerserkBossInfoData = OnUpdateSingleBerserkBossInfoData
LWUIBerserkBossItemRender.OnChangeSelectBerserkBoss = OnChangeSelectBerserkBoss
return LWUIBerserkBossItemRender
