local UILWAllianceListItem = BaseClass("UILWAllianceListItem", UIBaseContainer)
local base = UIBaseContainer
local UIAllianceInfoHorizontalPanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoHorizontalPanel")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local join_title_text_path = "ItemJoinBtnTxt"
local item_apply_btn_txt_path = "ItemApplyBtnTxt"
local join_condition_content_path = "JoinConditionContent"
local power_condition_text_path = "JoinConditionContent/PowerConditionText"
local base_level_condition_text_path = "JoinConditionContent/BaseLevelConditionText"
local JOIN_TITLE_TXT = 455007
local APPLY_TXT = 455006
local LANGUAGE_TITLE_TXT = 391095

function UILWAllianceListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAllianceListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceListItem:ComponentDefine()
  self.joinTitleText = self:AddComponent(UIText, join_title_text_path)
  self.joinTitleText:SetLocalText(JOIN_TITLE_TXT)
  self.item_apply_btn_txt = self:AddComponent(UIText, item_apply_btn_txt_path)
  self.item_apply_btn_txt:SetLocalText(APPLY_TXT)
  self.join_condition_content = self:AddComponent(UIBaseContainer, join_condition_content_path)
  self.power_condition_text = self:AddComponent(UIText, power_condition_text_path)
  self.base_level_condition_text = self:AddComponent(UIText, base_level_condition_text_path)
  self.infoPanel = self:AddComponent(UIAllianceInfoHorizontalPanel, "InnerPanel")
end

function UILWAllianceListItem:ComponentDestroy()
  self.joinTitleText = nil
  self.item_apply_btn_txt = nil
  self.join_condition_content = nil
  self.power_condition_text = nil
  self.base_level_condition_text = nil
  self.infoPanel = nil
end

function UILWAllianceListItem:DataDefine()
  self.alData = {}
end

function UILWAllianceListItem:DataDestroy()
  self.alData = nil
end

function UILWAllianceListItem:OnEnable()
  base.OnEnable(self)
end

function UILWAllianceListItem:OnDisable()
  base.OnDisable(self)
end

function UILWAllianceListItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAllianceListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAllianceListItem:SetData(data)
  if not data then
    return
  end
  self.alData = data
  self.infoPanel:RefreshByBaseInfo(self.alData, false, DataCenter.AllianceFeatureManager.joinAllianceListScoreShowNum)
  self.join_condition_content:SetActive(false)
  local isEnoughCondition = true
  if self.alData.applyLevelLimit > 0 or 0 < self.alData.applyPowerLimit then
    local playerPower = LuaEntry.Player.power
    if playerPower < self.alData.applyPowerLimit then
      isEnoughCondition = false
    end
    local baseLevel = DataCenter.BuildManager.MainLv
    if baseLevel < self.alData.applyLevelLimit then
      isEnoughCondition = false
    end
  end
  if not isEnoughCondition then
    self.join_condition_content:SetActive(true)
    self.power_condition_text:SetActive(0 < self.alData.applyPowerLimit)
    local symbol = " \226\137\165 "
    if 0 < self.alData.applyPowerLimit then
      local playerPower = LuaEntry.Player.power
      if playerPower < self.alData.applyPowerLimit then
        self.power_condition_text:SetText(Localization:GetString("alliance_system002") .. symbol .. "<color=#F53C3D>" .. self.alData.applyPowerLimit .. "</color>")
      else
        self.power_condition_text:SetText(Localization:GetString("alliance_system002") .. symbol .. "<color=#099B3D>" .. self.alData.applyPowerLimit .. "</color>")
      end
    end
    self.base_level_condition_text:SetActive(self.alData.applyLevelLimit > 0)
    if self.alData.applyLevelLimit > 0 then
      local baseLevel = DataCenter.BuildManager.MainLv
      if baseLevel < self.alData.applyLevelLimit then
        self.base_level_condition_text:SetText(Localization:GetString("alliance_system003") .. symbol .. "<color=#F53C3D>" .. self.alData.applyLevelLimit .. "</color>")
      else
        self.base_level_condition_text:SetText(Localization:GetString("alliance_system003") .. symbol .. "<color=#099B3D>" .. self.alData.applyLevelLimit .. "</color>")
      end
    end
    self.joinTitleText:SetActive(false)
    self.item_apply_btn_txt:SetActive(false)
    return
  end
  if self.alData.recruitTotal == 0 then
    self.joinTitleText:SetActive(true)
    self.item_apply_btn_txt:SetActive(false)
  else
    self.joinTitleText:SetActive(false)
    self.item_apply_btn_txt:SetActive(true)
  end
end

return UILWAllianceListItem
