local base = UIBaseView
local UIAllianceCommonSkillInfoView = BaseClass("UIAllianceCommonSkillInfoView", base)
local UIAllianceCommonSkillInfoItem = require("UI.LWSeasonShared.UIAllianceCommonSkillInfo.Component.UIAllianceCommonSkillInfoItem")
local item_a_path = "Scroll View/Content/item_a/itema"
local btn_CloseBtn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local btn_panel_path = "UICommonPopUpTitle/panel"
local go_item_a_path = "Scroll View/Content/item_a"
local go_itemb_path = "Scroll View/Content/wet/itemb"
local go_wet_path = "Scroll View/Content/wet"
local go_Content_path = "Scroll View/Content"
local txt_des_b_path = "Scroll View/Content/txt_des/txt_des_b"
local go_txt_des_path = "Scroll View/Content/txt_des"

function UIAllianceCommonSkillInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIAllianceCommonSkillInfoView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillInfoView:ComponentDefine()
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.btn_panel = self:AddComponent(UIButton, btn_panel_path)
  self.go_item_a = self:AddComponent(UIBaseContainer, go_item_a_path)
  self.go_itemb = self:AddComponent(UIBaseContainer, go_itemb_path)
  self.go_wet = self:AddComponent(UIBaseContainer, go_wet_path)
  self.go_Content = self:AddComponent(UIBaseContainer, go_Content_path)
  self.txt_des_b = self:AddComponent(UIText, txt_des_b_path)
  self.go_txt_des = self:AddComponent(UIBaseContainer, go_txt_des_path)
  self.btn_CloseBtn:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_panel:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.levelViews = {}
  for index = 1, 10 do
    local levelView = self:TryAddComponent(UIAllianceCommonSkillInfoItem, item_a_path .. index)
    if levelView then
      self.levelViews[index] = levelView
    end
  end
  self.goItemB = self.go_itemb.gameObject
  self.goItemB:GameObjectCreatePool()
end

function UIAllianceCommonSkillInfoView:ComponentDestroy()
  self.goItemB:GameObjectRecycleAll()
  self.goItemB = nil
  self.btn_CloseBtn = nil
  self.btn_panel = nil
  self.go_item_a = nil
  self.go_itemb = nil
  self.go_wet = nil
  self.go_Content = nil
  self.txt_des_b = nil
  self.go_txt_des = nil
end

function UIAllianceCommonSkillInfoView:ReInit()
  local levelConfig = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillLevelConfig()
  for index, view in ipairs(self.levelViews) do
    local config = levelConfig[index]
    view:ReInit(tostring(config.downValue), tostring(config.upValue), config.levelStr)
  end
  local skillList = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillList()
  for index, skill in ipairs(skillList) do
    local goItem = self.goItemB:GameObjectSpawn(self.go_wet.transform)
    goItem.name = UIUtil.GetLoopListItemIndex(index)
    local skillView = self.go_wet:AddComponent(UIAllianceCommonSkillInfoItem, goItem.name)
    local nameStr = CS.GameEntry.Localization:GetString(skill.scoreConfig.name)
    local pointValue = skill.scoreConfig.points
    local skillName = CS.GameEntry.Localization:GetString(skill.scoreConfig.skill_name)
    skillView:ReInit(skillName, nameStr, tostring(pointValue))
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go_txt_des.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt_des_b.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go_Content.transform)
end

return UIAllianceCommonSkillInfoView
