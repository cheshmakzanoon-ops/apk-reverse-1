local UILWSeasonStoveCenterRuleView = BaseClass("UILWSeasonStoveCenterRuleView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RuleItem = require("UI.LWSeason2.UILWSeasonStoveCenterRule.Component.UILWSeasonStoveCenterRuleItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_text_path = "PopUpTitle/Content/ScrollView/Viewport/Content/DetailText"
local content_path = "PopUpTitle/Content/ScrollView/Viewport/Content"
local item_path = "PopUpTitle/Content/ScrollView/Viewport/Content/item"

function UILWSeasonStoveCenterRuleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonStoveCenterRuleView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonStoveCenterRuleView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.desc_text:SetActive(true)
  self.desc_text:SetText("<margin=22>" .. Localization:GetString("season_s2_alliance_building_desc01"))
end

function UILWSeasonStoveCenterRuleView:ComponentDestroy()
  self.btn_back = nil
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
end

function UILWSeasonStoveCenterRuleView:UpdateData()
  local goItem, theItem
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
  for level = 1, 6 do
    local cityInfo = DataCenter.AllianceCityTemplateManager:GetCityByLevel(level)
    if cityInfo == nil then
      break
    end
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = "item_" .. level
    goItem:SetActive(true)
    theItem = self.content:AddComponent(RuleItem, goItem.name)
    theItem:ReInit(level, cityInfo)
  end
end

return UILWSeasonStoveCenterRuleView
