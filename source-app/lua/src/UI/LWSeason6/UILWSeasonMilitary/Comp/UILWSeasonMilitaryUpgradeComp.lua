local base = UIBaseContainer
local p_text_upgrade_title_path = "title/p_text_upgrade_title"
local p_comp_upgrade_condition_1_path = "content/p_comp_upgrade_condition_1"
local p_comp_upgrade_condition_2_path = "content/p_comp_upgrade_condition_2"
local p_content_time_path = "content/p_content_time"
local content_time_path = "content/p_content_time/content_time"
local p_text_auto_upgrade_time_path = "content/p_content_time/content_time/p_text_auto_upgrade_time"
local p_text_auto_upgrade_level_limit_path = "content/p_text_auto_upgrade_level_limit"
local p_btn_claim_upgrade_path = "content/p_btn_claim_upgrade"
local UILWSeasonMilitaryConditionCell = require("UI.LWSeason6.UILWSeasonMilitary.Cell.UILWSeasonMilitaryConditionCell")
local UILWSeasonMilitaryUpgradeComp = BaseClass("UILWSeasonMilitaryUpgradeComp", UIBaseContainer)

function UILWSeasonMilitaryUpgradeComp:ComponentDefine()
  self.p_text_upgrade_title = self:AddComponent(UITextMeshProUGUIEx, p_text_upgrade_title_path)
  self.p_comp_upgrade_condition_1 = self:AddComponent(UILWSeasonMilitaryConditionCell, p_comp_upgrade_condition_1_path)
  self.p_comp_upgrade_condition_2 = self:AddComponent(UILWSeasonMilitaryConditionCell, p_comp_upgrade_condition_2_path)
  self.p_content_time = self:AddComponent(UIBaseContainer, p_content_time_path)
  self.content_time = self:AddComponent(UIBaseContainer, content_time_path)
  self.p_text_auto_upgrade_time = self:AddComponent(UITextMeshProUGUIEx, p_text_auto_upgrade_time_path)
  self.p_text_auto_upgrade_level_limit = self:AddComponent(UITextMeshProUGUIEx, p_text_auto_upgrade_level_limit_path)
  self.p_btn_claim_upgrade = self:AddComponent(UIButton, p_btn_claim_upgrade_path)
  self.p_btn_claim_upgrade:SetOnClick(BindCallback(self, self.OnUpgradeClicked))
end

function UILWSeasonMilitaryUpgradeComp:ComponentDestroy()
  self.p_text_upgrade_title = nil
  self.p_comp_upgrade_condition_1 = nil
  self.p_comp_upgrade_condition_2 = nil
  self.p_content_time = nil
  self.content_time = nil
  self.p_text_auto_upgrade_time = nil
  self.p_text_auto_upgrade_level_limit = nil
  self.p_btn_claim_upgrade = nil
end

function UILWSeasonMilitaryUpgradeComp:DataDefine()
  self.TickAct = false
  self.AllConditionValid = false
end

function UILWSeasonMilitaryUpgradeComp:DataDestroy()
  self.TickAct = false
  self.AllConditionValid = false
end

function UILWSeasonMilitaryUpgradeComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryUpgradeComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryUpgradeComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryUpgradeComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryUpgradeComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_time.transform)
  end
end

function UILWSeasonMilitaryUpgradeComp:InitData(data)
  if data ~= nil then
    self.Data = data
    local level = checknumber(data.Level)
    if self.Data.IsUpgrade then
      self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(level + 1)
    end
    if self.Data.IsPreview then
      self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(level)
    end
    if self.Cell == nil then
      self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(level)
    end
    if self.Cell ~= nil then
      self.AllConditionValid = false
      return true
    end
  end
  return false
end

function UILWSeasonMilitaryUpgradeComp:InitUi()
  if self.Data.IsUpgrade then
    self.p_text_upgrade_title:SetLocalText("season_military_promote_condition")
  else
    self.p_text_upgrade_title:SetLocalText("season_military_promote_condition_preview")
  end
end

function UILWSeasonMilitaryUpgradeComp:UpdateData()
  self.AllConditionValid = false
  if self.Cell ~= nil then
    self.ManualUpgrade = checknumber(self.Cell.need_rank) == 0
    self.TickAct = not self.ManualUpgrade
    self.NextAutoUpgradeTime = DataCenter.SeasonMilitaryManager:GetNextAutoUpgradeTime()
    self.InfoData = DataCenter.SeasonMilitaryManager.InfoData
    return true
  end
  return false
end

function UILWSeasonMilitaryUpgradeComp:UpdateUi()
  self.p_comp_upgrade_condition_2:SetActive(false)
  self.AllConditionValid = true
  self.ScoreValid = true
  self.PreValid = true
  if checknumber(self.Cell.unlock_condition_type) > 0 then
    self.p_comp_upgrade_condition_2:SetActive(true)
    local buildingTaskData = {}
    buildingTaskData.Cell = self.Cell
    buildingTaskData.TaskType = checknumber(self.Cell.unlock_condition_type)
    self.p_comp_upgrade_condition_2:ReInit(buildingTaskData)
    self.PreValid = self.p_comp_upgrade_condition_2:IsValid()
    self.AllConditionValid = self.AllConditionValid and self.PreValid
  end
  if self.ManualUpgrade then
    local scoreTaskData = {}
    scoreTaskData.Cell = self.Cell
    scoreTaskData.TaskType = 0
    self.p_comp_upgrade_condition_1:ReInit(scoreTaskData)
    self.ScoreValid = self.p_comp_upgrade_condition_1:IsValid()
    self.AllConditionValid = self.AllConditionValid and self.ScoreValid
  else
    local rankTaskData = {}
    rankTaskData.Cell = self.Cell
    rankTaskData.TaskType = 3
    self.p_comp_upgrade_condition_1:ReInit(rankTaskData)
    self.AllConditionValid = false
  end
  self.p_content_time:SetActive(not self.ManualUpgrade)
  self.p_text_auto_upgrade_level_limit:SetActive(not self.ManualUpgrade)
  self.p_btn_claim_upgrade:SetActive(self.ManualUpgrade and self.Data.IsUpgrade)
  CS.UIGray.SetGray(self.p_btn_claim_upgrade.transform, not self.AllConditionValid, true)
end

function UILWSeasonMilitaryUpgradeComp:OnUpgradeClicked()
  if not self.ScoreValid then
    UIUtil.ShowTipsId("season_military_tips_lack_merit")
    return
  end
  if not self.PreValid then
    UIUtil.ShowTipsId("season_military_tips_condition_not_met")
    return
  end
  if not self.AllConditionValid then
    return
  end
  if self.InfoData == nil then
    return
  end
  DataCenter.SeasonMilitaryManager:SendLevelUp(self.InfoData:GetLevel())
end

function UILWSeasonMilitaryUpgradeComp:Update1000MS()
  if not self.TickAct then
    return
  end
  local leftTime = self.NextAutoUpgradeTime - UITimeManager:GetInstance():GetServerTime()
  if 0 <= leftTime then
    if self.InfoData ~= nil then
      local curLevel = self.InfoData:GetLevel()
      local maxManualLevel = DataCenter.SeasonMilitaryManager:GetMaxManualLevel()
      if curLevel >= maxManualLevel then
        self.p_content_time:SetActive(true)
        self.p_text_auto_upgrade_level_limit:SetActive(false)
        self.p_text_auto_upgrade_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
      else
        self.p_content_time:SetActive(false)
        self.p_text_auto_upgrade_level_limit:SetActive(true)
        local cell = DataCenter.SeasonMilitaryManager:GetMaxManualLevelCell()
        if cell ~= nil then
          self.p_text_auto_upgrade_level_limit:SetLocalText("season_military_promote_rank_condition_preview", cell:GetNameLoc())
        end
      end
    end
  else
    self.TickAct = false
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

return UILWSeasonMilitaryUpgradeComp
