local UILWSeasonStoveCenterCarrierRuleView = BaseClass("UILWSeasonStoveCenterCarrierRuleView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RuleItem = require("UI.LWSeason2.UILWSeasonStoveCenterCarrierRule.Component.UILWSeasonStoveCenterCarrierRuleItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_text_path = "PopUpTitle/Content/ScrollView/Viewport/Content/DetailText"
local content_path = "PopUpTitle/Content/ScrollView/Viewport/Content"
local item_path = "PopUpTitle/Content/ScrollView/Viewport/Content/item"

function UILWSeasonStoveCenterCarrierRuleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonStoveCenterCarrierRuleView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonStoveCenterCarrierRuleView:ComponentDefine()
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
  self.desc_text:SetText("<margin=22>" .. Localization:GetString("season_s2_alliance_prosperity_info"))
end

function UILWSeasonStoveCenterCarrierRuleView:ComponentDestroy()
  self.btn_back = nil
  self.desc_text = nil
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
end

function UILWSeasonStoveCenterCarrierRuleView:UpdateData()
  local goItem, theItem
  local mgr = DataCenter.AllianceMineManager
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
  for level = 2, 200 do
    local meta = mgr:GetAllianceMineTemplate(level + BuildingTypes.SEASON_STOVE_CENTER)
    if not meta then
      break
    end
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = "item_" .. level
    goItem:SetActive(true)
    theItem = self.content:AddComponent(RuleItem, goItem.name)
    theItem:ReInit(level, meta)
    if meta.max_level ~= level then
    else
      break
    end
  end
end

return UILWSeasonStoveCenterCarrierRuleView
