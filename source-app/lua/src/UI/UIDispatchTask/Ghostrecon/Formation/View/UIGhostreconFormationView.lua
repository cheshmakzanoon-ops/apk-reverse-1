local base = UIBaseView
local UIGhostreconFormationView = BaseClass("UIGhostreconFormationView", base)
local Localization = CS.GameEntry.Localization
local UIGhostreconFormationTopPanel = require("UI.UIDispatchTask.Ghostrecon.Formation.Component.UIGhostreconFormationTopPanel")
local UIGhostreconFormationSpecialConditionPanel = require("UI.UIDispatchTask.Ghostrecon.Formation.Component.UIGhostreconFormationSpecialConditionPanel")
local UIGhostreconFormationDispatchListPanel = require("UI.UIDispatchTask.Ghostrecon.Formation.Component.UIGhostreconFormationDispatchListPanel")
local UIGhostreconFormationHeroListPanel = require("UI.UIDispatchTask.Ghostrecon.Formation.Component.UIGhostreconFormationHeroListPanel")
local UIGhostreconFormationBtnPanel = require("UI.UIDispatchTask.Ghostrecon.Formation.Component.UIGhostreconFormationBtnPanel")
local UIGhostreconFormationConditionPanel = require("UI.UIDispatchTask.Ghostrecon.Formation.Component.UIGhostreconFormationConditionPanel")
local closePanel_path = "closeBg"
local titleText_path = "Root/TitleText"
local topPanel_path = "Root/InnerPanel/TopPanel"
local specialContionPanel_path = "Root/InnerPanel/SpecialConditionPanel"
local dispatchListPanel_path = "Root/InnerPanel/DispatchListPanel"
local heroListPanel_path = "Root/InnerPanel/HeroListPanel"
local btnPanel_path = "Root/BtnPanel"
local closeBtn_path = "Root/CloseBtn"
local conditionPanel_path = "Root/InnerPanel/ConditionPanel"

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
  self:Refresh()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.topPanel = self:AddComponent(UIGhostreconFormationTopPanel, topPanel_path)
  self.specialContionPanel = self:AddComponent(UIGhostreconFormationSpecialConditionPanel, specialContionPanel_path)
  self.dispatchListPanel = self:AddComponent(UIGhostreconFormationDispatchListPanel, dispatchListPanel_path)
  self.heroListPanel = self:AddComponent(UIGhostreconFormationHeroListPanel, heroListPanel_path)
  self.btnPanel = self:AddComponent(UIGhostreconFormationBtnPanel, btnPanel_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.conditionPanel = self:AddComponent(UIGhostreconFormationConditionPanel, conditionPanel_path)
  self.closePanel:SetOnClick(Bind(self, self.ctrl.CloseSelf))
  self.closeBtn:SetOnClick(Bind(self, self.ctrl.CloseSelf))
end

local function ComponentDestroy(self)
  self.closePanel = nil
  self.titleText = nil
  self.topPanel = nil
  self.specialContionPanel = nil
  self.dispatchListPanel = nil
  self.heroListPanel = nil
  self.btnPanel = nil
  self.closeBtn = nil
end

local function DataDefine(self)
  self.uuid, self.isJoin = self:GetUserData()
  self.clickHeroCellCallBack = BindCallback(self, self.OnClickHeroCell)
  self.selectedUUID = {}
  self.meetAllCondition = false
  self.meetAllSuperCondition = false
  self.teamMeetSuperCondionNums = {}
end

local function DataDestroy(self)
  self.uuid = nil
  self.isJoin = nil
  self.clickHeroCellCallBack = nil
  self.selectedUUID = nil
  self.cfg = nil
  self.meetAllCondition = nil
  self.meetAllSuperCondition = nil
end

local function Refresh(self)
  if self.isJoin then
    local data = DataCenter.ActGhostreconAllianceManager:GetAllianceTaskInfoByUUid(self.uuid)
    if data == nil then
      self.ctrl.CloseSelf()
      return
    end
    self.titleText:SetText(DataCenter.ActGhostreconManager:GetTeamName(data.leaderMemberInfo.memberInfo.name) .. #data.memberList .. "/" .. DataCenter.ActGhostreconManager:GetTeamMaxMemberNum())
    self.cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(data.cfgId)
    self.teamMeetSuperCondionNums = self.cfg:GetSuperCondionNumsByMemberList(data.memberList)
  else
    local data = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(self.uuid)
    self.titleText:SetLocalText("ghostrecon_activityname")
    self.cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(data.cfgId)
    self.teamMeetSuperCondionNums = self.cfg:GetSuperCondionNumsByMemberList(data.memberList)
  end
  local str = Localization:GetString(140205, self.cfg.level, Localization:GetString(self.cfg.nameId))
  self.topPanel:SetData(str, self.cfg.time)
  self.conditionPanel:SetData(self.cfg.conditions)
  if self.cfg.superCondions and #self.cfg.superCondions > 0 then
    self.specialContionPanel:SetActive(true)
    self.specialContionPanel:SetData(self.cfg, self.teamMeetSuperCondionNums)
    self.meetAllSuperCondition = self.specialContionPanel:RefreshSelectHero()
  else
    self.specialContionPanel:SetActive(false)
  end
  self.dispatchListPanel:SetAllEmpty()
  self.heroListPanel:SetData(self.ctrl:GetHeroList(self.cfg), self.clickHeroCellCallBack)
  self.btnPanel:SetData(self.uuid, self.cfg, self.isJoin)
  self:RefreshSelectHero()
end

local function RefreshSelectHero(self)
  local condNumTable = {
    0,
    0,
    0,
    0
  }
  local parsed_conditions = self.cfg.conditions
  local cond1Param, cond2Param, cond3Param, cond4Param
  for _, v in pairs(parsed_conditions) do
    local k = v.type
    if k == 1 then
      cond1Param = v.value
    elseif k == 2 then
      cond2Param = v.value
    elseif k == 3 then
      cond3Param = v.value
    elseif k == 4 then
      cond4Param = v.value
    end
  end
  local heroInfoList = {}
  self.dispatchListPanel:SetAllEmpty()
  for i, v in pairs(self.selectedUUID) do
    if v ~= nil then
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
      if heroData then
        self.dispatchListPanel:SetItemData(i, v, self.clickHeroCellCallBack)
        if cond1Param and heroData.heroType == cond1Param then
          condNumTable[1] = condNumTable[1] + 1
        end
        if cond2Param and cond2Param <= heroData.quality then
          condNumTable[2] = condNumTable[2] + 1
        end
        if cond3Param and cond3Param <= heroData:GetRank() then
          condNumTable[3] = condNumTable[3] + 1
        end
        if cond4Param and cond4Param <= heroData.level then
          condNumTable[4] = condNumTable[4] + 1
        end
        table.insert(heroInfoList, heroData)
      end
    end
  end
  self.meetAllCondition = self.conditionPanel:RefreshSelectHero(condNumTable)
  if self.cfg.superCondions and 0 < #self.cfg.superCondions then
    self.meetAllSuperCondition, self.teamMeetSuperCondionNums = self.specialContionPanel:RefreshSelectHero(heroInfoList)
  end
  self.btnPanel:Refresh(self.meetAllCondition)
end

local function OnClickHeroCell(self, transform, heroUuid)
  local emptyTable = {
    1,
    2,
    3
  }
  for i, v in pairs(self.selectedUUID) do
    emptyTable[i] = nil
    if v == heroUuid then
      self.selectedUUID[i] = nil
      local heroCell = self.heroListPanel:GetCellByHeroUUid(tostring(heroUuid))
      if heroCell then
        heroCell:SetSelected(false)
      end
      self:RefreshSelectHero()
      return
    end
  end
  emptyTable = table.values(emptyTable)
  if 0 < #emptyTable then
    local heroCell = self.heroListPanel:GetCellByHeroUUid(tostring(heroUuid))
    if heroCell then
      heroCell:SetSelected(true)
    end
    self.selectedUUID[emptyTable[1]] = heroUuid
    self:RefreshSelectHero()
  end
end

local function HasSelectUuid(self, uuid)
  if self.selectedUUID and uuid then
    for i, v in pairs(self.selectedUUID) do
      if v == uuid then
        return true
      end
    end
  end
  return false
end

local function OnFastJoinClick(self)
  local heroList, meetCondition = self.ctrl:GetRecommendHeroList(self.cfg, self.teamMeetSuperCondionNums)
  if heroList and meetCondition then
    for i, v in ipairs(self.selectedUUID) do
      local heroCell = self.heroListPanel:GetCellByHeroUUid(tostring(v))
      if heroCell then
        heroCell:SetSelected(false)
      end
    end
    self.selectedUUID = heroList
    for i, v in ipairs(self.selectedUUID) do
      local heroCell = self.heroListPanel:GetCellByHeroUUid(tostring(v))
      if heroCell then
        heroCell:SetSelected(true)
      end
    end
    self:RefreshSelectHero()
  else
    UIUtil.ShowTipsId("ghostrecon_055")
  end
end

UIGhostreconFormationView.OnCreate = OnCreate
UIGhostreconFormationView.OnDestroy = OnDestroy
UIGhostreconFormationView.OnEnable = OnEnable
UIGhostreconFormationView.OnDisable = OnDisable
UIGhostreconFormationView.ComponentDefine = ComponentDefine
UIGhostreconFormationView.ComponentDestroy = ComponentDestroy
UIGhostreconFormationView.DataDefine = DataDefine
UIGhostreconFormationView.DataDestroy = DataDestroy
UIGhostreconFormationView.Refresh = Refresh
UIGhostreconFormationView.RefreshSelectHero = RefreshSelectHero
UIGhostreconFormationView.OnClickHeroCell = OnClickHeroCell
UIGhostreconFormationView.HasSelectUuid = HasSelectUuid
UIGhostreconFormationView.OnFastJoinClick = OnFastJoinClick
return UIGhostreconFormationView
