local base = UIBaseView
local UIAllianceCommonSkillView = BaseClass("UIAllianceCommonSkillView", base)
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UIAllianceCommonSkillUpgrade = require("UI.LWSeasonShared.UIAllianceCommonSkill.Component.UIAllianceCommonSkillUpgrade")
local UIAllianceCommonSkillUse = require("UI.LWSeasonShared.UIAllianceCommonSkill.Component.UIAllianceCommonSkillUse")
local sr_UICommonToggleList_path = "Root/UICommonToggleList"
local btn_BtnBack_path = "Root/BottomBar/BtnBack"
local txt_TextTitle_path = "Root/TopBar/TitleContent/TextTitle"
local go_UIAllianceCommonSkillUpgrage_path = "Root/Content/UIAllianceCommonSkillUpgrade"
local go_UIAllianceUseCommonSkill_path = "Root/Content/UIAllianceCommonSkillUse"
UIAllianceCommonSkillView.ToggleType = {
  SKILL = 1,
  ALLIANCE_LEADER = 2,
  WAR_GOD = 3,
  GODDESS = 4,
  BUTLER = 5,
  RECRUITER = 6,
  MAX = 7
}
UIAllianceCommonSkillView.ToggleInfo = {
  [UIAllianceCommonSkillView.ToggleType.SKILL] = {
    name = "season_s6_government_skill_desc39"
  },
  [UIAllianceCommonSkillView.ToggleType.ALLIANCE_LEADER] = {
    name = "season_s6_government_skill_leader_skill",
    type = LWAlMemberOffcialType.Al_MASTER,
    desc = "season_s6_government_skill_leader_desc"
  },
  [UIAllianceCommonSkillView.ToggleType.WAR_GOD] = {
    name = "season_s6_government_skill_mars_skill",
    type = LWAlMemberOffcialType.Deputy_Al_Leader,
    desc = "season_alliance_government_skill_13"
  },
  [UIAllianceCommonSkillView.ToggleType.GODDESS] = {
    name = "season_s6_government_skill_goddess_skill",
    type = LWAlMemberOffcialType.War_Commander,
    desc = "season_s6_government_skill_goddess_desc"
  },
  [UIAllianceCommonSkillView.ToggleType.BUTLER] = {
    name = "season_s6_government_skill_butler_skill",
    type = LWAlMemberOffcialType.Al_Ambassadoe,
    desc = "alliance_government_10005_02"
  },
  [UIAllianceCommonSkillView.ToggleType.RECRUITER] = {
    name = "season_s6_government_skill_recruiter_skill",
    type = LWAlMemberOffcialType.Al_Goddess,
    desc = "season_s6_government_skill_recruiter_desc"
  }
}

function UIAllianceCommonSkillView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  DataCenter.AllianceGovernmentCommonSkillManager:ClearRed()
end

function UIAllianceCommonSkillView:OnDestroy()
  self.curTabIndex = nil
  for _, v in pairs(self.tabLogics) do
    v:SetActive(false)
  end
  self.tabLogics = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillView:ComponentDefine()
  self.btn_BtnBack = self:AddComponent(UIButton, btn_BtnBack_path)
  self.txt_TextTitle = self:AddComponent(UIText, txt_TextTitle_path)
  self.btn_BtnBack:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.sr_UICommonToggleList = self:AddComponent(UICommonToggleListComponent, sr_UICommonToggleList_path)
  self.go_UIAllianceCommonSkillUpgrage = self:AddComponent(UIAllianceCommonSkillUpgrade, go_UIAllianceCommonSkillUpgrage_path)
  self.go_UIAllianceUseCommonSkill = self:AddComponent(UIAllianceCommonSkillUse, go_UIAllianceUseCommonSkill_path)
  self.go_UIAllianceCommonSkillUpgrage:SetActive(false)
  self.go_UIAllianceUseCommonSkill:SetActive(false)
  self.tabLogics = {}
  local skillId = self:GetUserData()
  local toggleIndex = 1
  if skillId then
    local config = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(skillId)
    for type = UIAllianceCommonSkillView.ToggleType.ALLIANCE_LEADER, UIAllianceCommonSkillView.ToggleType.MAX - 1 do
      local tabInfo = UIAllianceCommonSkillView.ToggleInfo[type]
      if tabInfo.type == config.type then
        toggleIndex = type
        break
      end
    end
  end
  self:InitToggle(toggleIndex)
end

function UIAllianceCommonSkillView:ComponentDestroy()
  self.sr_UICommonToggleList = nil
  self.btn_BtnBack = nil
  self.txt_TextTitle = nil
  self.go_UIAllianceCommonSkillUpgrage = nil
  self.go_UIAllianceUseCommonSkill = nil
end

function UIAllianceCommonSkillView:OnToggleBySkillId(skillId)
  local toggleIndex = 1
  local config = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(skillId)
  for type = UIAllianceCommonSkillView.ToggleType.ALLIANCE_LEADER, UIAllianceCommonSkillView.ToggleType.MAX - 1 do
    local tabInfo = UIAllianceCommonSkillView.ToggleInfo[type]
    if tabInfo.type == config.type then
      toggleIndex = type
      break
    end
  end
  self.gotoSkillId = skillId
  self.sr_UICommonToggleList:SetSelectIndex(toggleIndex)
  self.sr_UICommonToggleList:ScrollToIndexTabFixY(toggleIndex)
end

function UIAllianceCommonSkillView:InitToggle(toggleIndex)
  local tabs = {}
  for index = self.ToggleType.SKILL, self.ToggleType.MAX - 1 do
    local tabInfo = self.ToggleInfo[index]
    local tabData = {}
    tabData.name = CS.GameEntry.Localization:GetString(tabInfo.name)
    table.insert(tabs, tabData)
  end
  local toggleListData = {}
  toggleListData.itemsDataList = tabs
  toggleListData.defaultSelectIndex = toggleIndex
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnToggle(index)
  end
  
  self.sr_UICommonToggleList:ReInit(toggleListData)
  self:OnToggle(toggleIndex)
  self.sr_UICommonToggleList:ScrollToIndexTabFixY(toggleIndex)
end

function UIAllianceCommonSkillView:OnToggle(index)
  if self.curTabIndex == index then
    return
  end
  if self.curTabIndex ~= nil then
    local lastTabLogic = self.tabLogics[self.curTabIndex]
    if lastTabLogic then
      lastTabLogic:SetActive(false)
    end
  end
  local tabLogic = self.tabLogics[index]
  if index == self.ToggleType.SKILL then
    if tabLogic == nil then
      tabLogic = self.go_UIAllianceCommonSkillUpgrage
      self.tabLogics[index] = tabLogic
    end
  elseif tabLogic == nil then
    tabLogic = self.go_UIAllianceUseCommonSkill
    self.tabLogics[index] = tabLogic
  end
  self.curTabIndex = index
  tabLogic:SetActive(true)
  tabLogic:ReInit(self.ToggleInfo[index].type, self.gotoSkillId)
  self.gotoSkillId = nil
end

function UIAllianceCommonSkillView:GetCurToggleInfo()
  return self.ToggleInfo[self.curTabIndex]
end

return UIAllianceCommonSkillView
