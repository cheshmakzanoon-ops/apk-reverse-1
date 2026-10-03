local UILWAllianceSkillView = BaseClass("UILWAllianceSkillView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWAllianceSkillItem = require("UI.LWSeasonShared.UILWAllianceSkill.Component.UILWAllianceSkillItem")
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_bg_orange/titleText"
local close_btn_path = "PopUpTitle/Common_bg_orange/CloseBtn"
local content_path = "PopUpTitle/Common_bg_orange/ScrollView/Viewport/Content"
local skill_path = "PopUpTitle/Common_bg_orange/ScrollView/Viewport/Content/Skill"

function UILWAllianceSkillView:OnCreate()
  base.OnCreate(self)
  self.pointData = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillList)
end

function UILWAllianceSkillView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceSkillView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
  self:AddUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  self:AddUIListener(EventId.UpdateGuardianTowerSkillState, self.UpdateData)
end

function UILWAllianceSkillView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateGuardianTowerSkillState, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWAllianceSkillView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(skill_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.theItem:SetActive(false)
  self.title_text:SetLocalText("alliance_government_10005_09")
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UILWAllianceSkillView:ComponentDestroy()
  self.content:RemoveComponents(UILWAllianceSkillItem)
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.content = nil
end

function UILWAllianceSkillView:UpdateData()
  local goItem, theItem
  self.content:RemoveComponents(UILWAllianceSkillItem)
  self.theItem:GameObjectRecycleAll()
  goItem = self.theItem:GameObjectSpawn(self.content.transform)
  goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
  goItem:SetActive(true)
  theItem = self.content:AddComponent(UILWAllianceSkillItem, goItem.name)
  theItem:ReInit(LWAlMemberOffcialType.Al_Ambassadoe, self.pointData)
end

return UILWAllianceSkillView
