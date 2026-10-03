local UILWSeasonFactionWarRuleView = BaseClass("UILWSeasonFactionWarRuleView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RuleItem = require("UI.LWSeason2.UILWSeasonFactionWarRule.Component.UILWSeasonFactionWarRuleItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_text_path = "PopUpTitle/ScrollView/Viewport/Content/DescText"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local time_item_path = "PopUpTitle/ScrollView/Viewport/Content/TimeItem"
local scroll_view_path = "PopUpTitle/ScrollView"
local icon1_path = "PopUpTitle/ScrollView/Viewport/Content/item/Content/icon1"
local icon2_path = "PopUpTitle/ScrollView/Viewport/Content/item/Content/icon2"
local bg_path = "PopUpTitle/Common_bg_orange2/bg"

function UILWSeasonFactionWarRuleView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonFactionWarRuleView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionWarRuleView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionDeclareInfoUpdate, self.UpdateData)
end

function UILWSeasonFactionWarRuleView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionDeclareInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonFactionWarRuleView:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.dialog_title_text = self:AddComponent(UITextMeshProUGUIEx, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_s2_faction_war_14")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  if self.param == "DeclareWar" then
    local actData = DataCenter.SeasonFactionWarDataManager.DeclareWarActivityData
    if actData then
      self.desc_text:SetLocalText(actData.story)
    else
      self.desc_text:SetLocalText("season_s2_faction_war_15")
    end
    self.desc_text:SetActive(true)
  elseif self.param == "DeclareWarTime" then
    self.dialog_title_text:SetLocalText("458013")
    self.desc_text:SetActive(false)
  else
    self.desc_text:SetLocalText(self.param)
    self.desc_text:SetActive(true)
  end
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.theItem = self.transform:Find(time_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view:SetVerticalNormalizedPosition(1)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Snow then
    self.bg:SetActive(true)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRadarCenter/mjc_s2_leida_bingshuang.png")
  elseif seasonType == SeasonMapType.Mummy then
    self.bg:SetActive(true)
    self.bg:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/UI/FactionDeclareWar/mjc_s3_leida_shazi.png")
  elseif seasonType == SeasonMapType.Darkness then
    self.bg:SetActive(false)
  else
    self.bg:SetActive(false)
  end
end

function UILWSeasonFactionWarRuleView:ComponentDestroy()
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
  self.scroll_view = nil
  self.icon1 = nil
  self.icon2 = nil
  self.bg = nil
end

function UILWSeasonFactionWarRuleView:UpdateData()
  local mgr = DataCenter.SeasonFactionWarDataManager
  local goItem, theItem
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
  self.icon1:LoadSprite(mgr:GetCampIcon(1, false))
  self.icon2:LoadSprite(mgr:GetCampIcon(2, false))
  if self.param == "DeclareWar" or self.param == "DeclareWarTime" then
    local timeInfos = mgr.timeInfos
    if timeInfos then
      local roundNow = 0
      local actInfo = mgr:GetDeclareWarActInfo()
      if actInfo then
        roundNow = actInfo.round
      end
      table.sort(timeInfos, function(a, b)
        return a.round < b.round
      end)
      for k, v in ipairs(timeInfos) do
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "round_" .. k
        goItem:SetActive(true)
        theItem = self.content:AddComponent(RuleItem, goItem.name)
        theItem:ReInit(k, roundNow, v)
      end
      return
    end
  end
  for i = 1, 8 do
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = "round_" .. i
    goItem:SetActive(true)
    theItem = self.content:AddComponent(RuleItem, goItem.name)
    theItem:ReInit(i, 0, nil)
  end
end

return UILWSeasonFactionWarRuleView
