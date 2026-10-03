local LWSeasonMilitaryCenterRuleView = BaseClass("LWSeasonMilitaryCenterRuleView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RuleItem = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenterRule.Component.LWSeasonMilitaryCenterRuleItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_text_path = "PopUpTitle/Content/ScrollView/Viewport/Content/DetailText"
local content_path = "PopUpTitle/Content/ScrollView/Viewport/Content"
local item_path = "PopUpTitle/Content/ScrollView/Viewport/Content/item"
local t1_path = "PopUpTitle/Content/ScrollView/Viewport/Content/title/Content/t1"
local t2_path = "PopUpTitle/Content/ScrollView/Viewport/Content/title/Content/t2"

function LWSeasonMilitaryCenterRuleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function LWSeasonMilitaryCenterRuleView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonMilitaryCenterRuleView:ComponentDefine()
  self.t1 = self:AddComponent(UITextMeshProUGUIEx, t1_path)
  self.t2 = self:AddComponent(UITextMeshProUGUIEx, t2_path)
  self.t1:SetLocalText("151050")
  self.t2:SetLocalText("season_s3_spices_tips")
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(BuildingTypes.SEASON_MUMMY_CENTER)
  if meta then
    self.desc_text:SetActive(true)
    self.desc_text:SetText("<margin=22>" .. Localization:GetString(meta.desc))
  else
    self.desc_text:SetActive(false)
  end
end

function LWSeasonMilitaryCenterRuleView:ComponentDestroy()
  self.btn_back = nil
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
end

function LWSeasonMilitaryCenterRuleView:UpdateData()
  local goItem, theItem
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
  local mgr = DataCenter.AllianceMineManager
  local meta = mgr:GetAllianceMineTemplate(BuildingTypes.SEASON_MUMMY_CENTER)
  for level = 1, meta.max_level do
    local buildInfo = mgr:GetAllianceMineTemplate(level + BuildingTypes.SEASON_MUMMY_CENTER)
    if buildInfo == nil or buildInfo.hour_product_stone == nil or buildInfo.hour_product_stone[ResourceType.AllianceStone] == nil then
      break
    end
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = "item_" .. level
    goItem:SetActive(true)
    theItem = self.content:AddComponent(RuleItem, goItem.name)
    theItem:ReInit(level, buildInfo)
  end
end

return LWSeasonMilitaryCenterRuleView
