local UIActBountyHunterRulesView = BaseClass("UIActBountyHunterRulesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local LWUICommonActivityRulesPicGuidePanelComponent = require("UI.ActivityCommon.LWUICommonActivityRules.PicGuide.LWUICommonActivityRulesPicGuidePanelComponent")
local LWUICommonActivityRulesTextPanelComponent = require("UI.ActivityCommon.LWUICommonActivityRules.Text.LWUICommonActivityRulesTextPanelComponent")
local LWUIActBountyHunterRulesDropPanelComponent = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/Component/LWUIActBountyHunterRulesDropPanelComponent")

function UIActBountyHunterRulesView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:OnOpen()
end

function UIActBountyHunterRulesView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActBountyHunterRulesView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 4)
  self.compLWUICommonActivityRulesPicGuidePanel = self.viewSkin:AddComponent(self, LWUICommonActivityRulesPicGuidePanelComponent, 5)
  self.compLWUICommonActivityRulesTextPanel = self.viewSkin:AddComponent(self, LWUICommonActivityRulesTextPanelComponent, 6)
  self.textTitle:SetLocalText(302027)
end

function UIActBountyHunterRulesView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compUICommonToggleList = nil
  self.compLWUICommonActivityRulesPicGuidePanel = nil
  self.compLWUICommonActivityRulesTextPanel = nil
end

function UIActBountyHunterRulesView:DataDefine()
  self.hasInitTab = {}
end

function UIActBountyHunterRulesView:DataDestroy()
  self.hasInitTab = nil
end

function UIActBountyHunterRulesView:OnAddListener()
  base.OnAddListener(self)
end

function UIActBountyHunterRulesView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActBountyHunterRulesView:OnOpen()
  if self.activityId == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    self.ctrl:CloseSelf()
    return
  end
  self:InitToggle()
  PostEventLog.Track(PostEventLog.Defines.BountyHunterOpenRules)
end

function UIActBountyHunterRulesView:InitToggle()
  local data = {}
  local data1 = {}
  data1.name = Localization:GetString("activity_hunter_info_tab1")
  local data2 = {}
  data2.name = Localization:GetString("activity_hunter_info_tab3")
  data.itemsDataList = {data1, data2}
  
  function data.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  data.defaultSelectIndex = 1
  self.compUICommonToggleList:ReInit(data)
end

function UIActBountyHunterRulesView:OnSelectToggle(index, itemData)
  self.compLWUICommonActivityRulesPicGuidePanel:SetActive(index == 1)
  self.compLWUICommonActivityRulesTextPanel:SetActive(index == 2)
  if not self.hasInitTab[index] then
    self.hasInitTab[index] = true
    if index == 1 then
      local showTemp = self.activityInfo:GetShowConfigTemp()
      self.compLWUICommonActivityRulesPicGuidePanel:RefreshByActivityShowConfigTemplate(showTemp)
    elseif index == 2 then
      self.compLWUICommonActivityRulesTextPanel:RefreshByText(self.ctrl:GetStoryText(self.activityInfo))
    end
  end
end

function UIActBountyHunterRulesView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UIActBountyHunterRulesView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIActBountyHunterRulesView
