local UILWAlJoinItem = BaseClass("UILWAlJoinItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIAllianceInfoHorizontalPanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoHorizontalPanel")
local join_title_text_path = "ItemJoinBtn/ItemJoinBtnTxt"
local join_btn_path = "ItemJoinBtn"
local item_apply_btn_path = "ItemApplyBtn"
local item_apply_btn_txt_path = "ItemApplyBtn/ItemApplyBtnTxt"
local join_condition_content_path = "JoinConditionContent"
local power_condition_text_path = "JoinConditionContent/PowerConditionText"
local base_level_condition_text_path = "JoinConditionContent/BaseLevelConditionText"
local JOIN_TITLE_TXT = 110037
local APPLY_TXT = 110090
local APPLIED_TXT = 455005
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")

function UILWAlJoinItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlJoinItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlJoinItem:ComponentDefine()
  self.joinTitleText = self:AddComponent(UIText, join_title_text_path)
  self.joinBtn = self:AddComponent(UIButton, join_btn_path)
  self.joinBtn:SetOnClick(function()
    local alliance_cross_join = LuaEntry.DataConfig:CheckSwitch("alliance_cross_join")
    if alliance_cross_join or LuaEntry.Player:IsLoginSourceServer() then
      self:JoinClick(0)
      AlPostEventLog.PostEventLog_ListJoin_Action(AlPostEventLog.JoinAction.Join)
    else
      UIUtil.ShowTipsId("season_tips166")
    end
  end)
  self.joinTitleText:SetLocalText(JOIN_TITLE_TXT)
  self.item_apply_btn = self:AddComponent(UIButton, item_apply_btn_path)
  self.item_apply_btn:SetOnClick(function()
    local alliance_cross_join = LuaEntry.DataConfig:CheckSwitch("alliance_cross_join")
    if alliance_cross_join or LuaEntry.Player:IsLoginSourceServer() then
      if self.alData.applied == 1 then
        self.view.ctrl:SendCancelApplyMessageToServer(self.alData.uid)
        AlPostEventLog.PostEventLog_ListJoin_Action(AlPostEventLog.JoinAction.CancelApply)
      else
        self:JoinClick(1)
        AlPostEventLog.PostEventLog_ListJoin_Action(AlPostEventLog.JoinAction.Apply)
      end
    else
      UIUtil.ShowTipsId("season_tips166")
    end
  end)
  self.item_apply_btn_txt = self:AddComponent(UIText, item_apply_btn_txt_path)
  self.join_condition_content = self:AddComponent(UIBaseContainer, join_condition_content_path)
  self.power_condition_text = self:AddComponent(UIText, power_condition_text_path)
  self.base_level_condition_text = self:AddComponent(UIText, base_level_condition_text_path)
  self.infoPanel = self:AddComponent(UIAllianceInfoHorizontalPanel, "InnerPanel")
end

function UILWAlJoinItem:ComponentDestroy()
  self.joinTitleText = nil
  self.joinBtn = nil
  self.item_apply_btn = nil
  self.item_apply_btn_txt = nil
  self.join_condition_content = nil
  self.power_condition_text = nil
  self.base_level_condition_text = nil
  self.infoPanel = nil
end

function UILWAlJoinItem:DataDefine()
  self.alData = {}
  self.canJoin = nil
end

function UILWAlJoinItem:DataDestroy()
  self.alData = nil
  self.canJoin = nil
end

function UILWAlJoinItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlJoinItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlJoinItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CLICK_ALLIANCE_ITEM, self.RefreshItemState)
end

function UILWAlJoinItem:OnRemoveListener()
  self:RemoveUIListener(EventId.CLICK_ALLIANCE_ITEM, self.RefreshItemState)
  base.OnRemoveListener(self)
end

function UILWAlJoinItem:RefreshItemState(allianceId)
  if self.alData ~= nil and self.alData.uid == allianceId then
    local currentAlliance = self.view.ctrl:GetOneAlByUid(allianceId)
    if currentAlliance then
      local extendData = self.view.ctrl:GetOneAlExtendData(currentAlliance)
      if self.extendData and extendData then
        extendData.showBest = self.extendData.showBest
      end
      self:SetData(currentAlliance, extendData)
    end
  end
end

function UILWAlJoinItem:SetData(data, extendData)
  if not data or not extendData then
    return
  end
  self.alData = data
  self.extendData = extendData
  self.infoPanel:RefreshByBaseInfo(self.alData, extendData.showBest, DataCenter.AllianceFeatureManager.joinAllianceListScoreShowNum)
  self.join_condition_content:SetActive(false)
  local isEnoughCondition = extendData.isEnoughCondition
  self.canJoin = extendData.canJoin
  if not isEnoughCondition then
    self.join_condition_content:SetActive(true)
    self.power_condition_text:SetActive(self.alData.applyPowerLimit > 0)
    local symbol = " \226\137\165 "
    if self.alData.applyPowerLimit > 0 then
      local playerPower = LuaEntry.Player.power
      if playerPower < self.alData.applyPowerLimit then
        self.power_condition_text:SetText(Localization:GetString("alliance_system002") .. symbol .. "<color=#F53C3D>" .. self.alData.applyPowerLimit .. "</color>")
      else
        self.power_condition_text:SetText(Localization:GetString("alliance_system002") .. symbol .. "<color=#099B3D>" .. self.alData.applyPowerLimit .. "</color>")
      end
    end
    self.base_level_condition_text:SetActive(0 < self.alData.applyLevelLimit)
    if 0 < self.alData.applyLevelLimit then
      local baseLevel = DataCenter.BuildManager.MainLv
      if baseLevel < self.alData.applyLevelLimit then
        self.base_level_condition_text:SetText(Localization:GetString("alliance_system003") .. symbol .. "<color=#F53C3D>" .. self.alData.applyLevelLimit .. "</color>")
      else
        self.base_level_condition_text:SetText(Localization:GetString("alliance_system003") .. symbol .. "<color=#099B3D>" .. self.alData.applyLevelLimit .. "</color>")
      end
    end
    self.item_apply_btn:SetActive(false)
    self.joinBtn:SetActive(false)
    return
  end
  if self.alData.applied == 1 then
    self.item_apply_btn:SetActive(true)
    CS.UIGray.SetGray(self.item_apply_btn.transform, true, true)
    self.item_apply_btn_txt:SetLocalText(APPLIED_TXT)
    self.joinBtn:SetActive(false)
  else
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    self.joinBtn:SetActive(self.canJoin)
    local showApply = self.alData.recruitTotal == 1 and not hasAlliance
    self.item_apply_btn:SetActive(showApply)
    if showApply then
      self.item_apply_btn_txt:SetLocalText(APPLY_TXT)
      CS.UIGray.SetGray(self.item_apply_btn.transform, false, true)
    end
  end
end

function UILWAlJoinItem:JoinClick(state)
  if DataCenter.AllianceBaseDataManager:IsInJoinAllianceCdTime(true) then
    return
  end
  self.view.ctrl:SendAlApplyMessageToServer(self.alData.uid, state, self.alData.language)
end

function UILWAlJoinItem:GetArrowPos()
  return self.joinBtn.transform.position
end

function UILWAlJoinItem:SetInteractable(active)
  self.joinBtn:SetInteractable(active)
  self.canJoin = active
end

function UILWAlJoinItem:OnClickAllianceFlagBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.alData.allianceName, self.alData.uid)
end

return UILWAlJoinItem
