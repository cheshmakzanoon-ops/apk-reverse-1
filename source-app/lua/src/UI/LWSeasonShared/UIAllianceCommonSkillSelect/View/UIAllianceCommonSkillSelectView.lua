local base = UIBaseView
local UIAllianceCommonSkillSelectView = BaseClass("UIAllianceCommonSkillSelectView", base)
local UIAllianceCommonSkillSelectItem = require("UI.LWSeasonShared.UIAllianceCommonSkillSelect.Component.UIAllianceCommonSkillSelectItem")
local btn_CloseBtn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local btn_panel_path = "UICommonPopUpTitle/panel"
local sr_UICommonLoopListViewVertical_path = "Root/UICommonLoopListViewVertical"

function UIAllianceCommonSkillSelectView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.data = self:GetUserData()
  self:RefreshView()
end

function UIAllianceCommonSkillSelectView:OnDestroy()
  self.showDataList = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillSelectView:ComponentDefine()
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.btn_panel = self:AddComponent(UIButton, btn_panel_path)
  self.sr_UICommonLoopListViewVertical = self:AddComponent(UILoopListViewSimple, sr_UICommonLoopListViewVertical_path)
  self.btn_CloseBtn:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_panel:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.sr_UICommonLoopListViewVertical:Init(UIAllianceCommonSkillSelectItem)
end

function UIAllianceCommonSkillSelectView:ComponentDestroy()
  self.btn_CloseBtn = nil
  self.btn_panel = nil
  self.sr_UICommonLoopListViewVertical = nil
end

function UIAllianceCommonSkillSelectView:GetCanUseSkill()
  local showList = {}
  if self.data.config.skill_flag == AlOfficialSkillType.RefreshBall then
    local allSkillList = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillList(AlOfficialSkillType.RefreshBall)
    for _, v in pairs(allSkillList) do
      if v:InCd() then
        table.insert(showList, v)
      end
    end
  end
  table.sort(showList, function(a, b)
    return tonumber(a.skillId) < tonumber(b.skillId)
  end)
  return showList
end

function UIAllianceCommonSkillSelectView:RefreshView()
  self.showDataList = self:GetCanUseSkill()
  self.sr_UICommonLoopListViewVertical:Clear()
  for _, v in ipairs(self.showDataList) do
    self.sr_UICommonLoopListViewVertical:AddData(v)
  end
  self.sr_UICommonLoopListViewVertical:Show()
end

return UIAllianceCommonSkillSelectView
