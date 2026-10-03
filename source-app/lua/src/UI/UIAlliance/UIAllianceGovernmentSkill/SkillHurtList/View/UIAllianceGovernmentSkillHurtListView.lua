local UIAllianceGovernmentSkillHurtListView = BaseClass("UIAllianceGovernmentSkillHurtListView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local HurtListItem = require("UI.UIAlliance.UIAllianceGovernmentSkill.SkillHurtList.Component.UIAllianceGovernmentSkillHurtListItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"

function UIAllianceGovernmentSkillHurtListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UIAllianceGovernmentSkillHurtListView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceGovernmentSkillHurtListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
end

function UIAllianceGovernmentSkillHurtListView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIAllianceGovernmentSkillHurtListView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("393017")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function UIAllianceGovernmentSkillHurtListView:ComponentDestroy()
  self:ClearScroll()
  self.btn_back = nil
end

function UIAllianceGovernmentSkillHurtListView:UpdateData()
  local skillType = self:GetUserData() or AlOfficialSkillType.AresMissile
  self.skillType = skillType
  local serverData = DataCenter.AllianceGovernmentSkillManager:GetUsedSkillStateDataByType(skillType)
  self.serverData = serverData
  if serverData and serverData.result and serverData.result.beAttackUserList then
    local beAttackUserList = serverData.result.beAttackUserList
    local dataCount = table.count(beAttackUserList)
    if 0 < dataCount then
      self.beAttackUserList = beAttackUserList
      self.ScrollView:SetTotalCount(dataCount)
      self.ScrollView:RefillCells()
    else
      self:ClearScroll()
    end
  else
    self:ClearScroll()
  end
end

function UIAllianceGovernmentSkillHurtListView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(HurtListItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.beAttackUserList[index], self.serverData, self.skillType)
  end
end

function UIAllianceGovernmentSkillHurtListView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, HurtListItem)
end

function UIAllianceGovernmentSkillHurtListView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(HurtListItem)
end

return UIAllianceGovernmentSkillHurtListView
