local UILWSeasonCrossOccupyDetailView = BaseClass("UILWSeasonCrossOccupyDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DetailItem = require("UI.LWSeason1.UILWSeasonCrossOccupyDetail.Component.UILWSeasonCrossOccupyDetailItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local tips1_path = "PopUpTitle/bg/tips1"
local info_btn1_path = "PopUpTitle/bg/InfoBtn1"
local tips2_path = "PopUpTitle/bg/tips2"
local info_btn2_path = "PopUpTitle/bg/InfoBtn2"
local local_path = "PopUpTitle/Local"
local cross_path = "PopUpTitle/Cross"
local value_total_path = "PopUpTitle/Common_bg_orange2/valueTotal"
local info_btn_cross_path = "PopUpTitle/InfoBtnCross"

function UILWSeasonCrossOccupyDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonCrossOccupyDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCrossOccupyDetailView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tips1 = self:AddComponent(UITextMeshProUGUIEx, tips1_path)
  self.info_btn1 = self:AddComponent(UIButton, info_btn1_path)
  self.tips2 = self:AddComponent(UITextMeshProUGUIEx, tips2_path)
  self.info_btn2 = self:AddComponent(UIButton, info_btn2_path)
  self.localServer = self:AddComponent(DetailItem, local_path)
  self.crossServer = self:AddComponent(DetailItem, cross_path)
  self.value_total = self:AddComponent(UITextMeshProUGUIEx, value_total_path)
  self.info_btn_cross = self:AddComponent(UIButton, info_btn_cross_path)
  self.info_btn1:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn1, nil, "power_level_tips_14", false)
  end)
  self.info_btn2:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn2, nil, "power_level_tips_13", false)
  end)
  self.info_btn_cross:SetOnClick(function()
    local msg = Localization:GetString("power_level_tips_15")
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end)
end

function UILWSeasonCrossOccupyDetailView:ComponentDestroy()
  self.btn_back = nil
  self.tips1 = nil
  self.info_btn1 = nil
  self.tips2 = nil
  self.info_btn2 = nil
  self.localServer = nil
  self.crossServer = nil
  self.value_total = nil
  self.info_btn_cross = nil
end

function UILWSeasonCrossOccupyDetailView:UpdateData()
  local CrossAttackStrongholdActivityType = EnumActivity.SeasonCrossAttackCityActivity.Type
  local CrossAttackCityActivityType = EnumActivity.SeasonCrossDeclareWarActivity.Type
  local hasCrossAttackStronghold = DataCenter.ActivityListDataManager:CheckIfActivityOpen(CrossAttackStrongholdActivityType)
  local hasCrossAttackCity = DataCenter.ActivityListDataManager:CheckIfActivityOpen(CrossAttackCityActivityType)
  local dailyDeclareNum = DataCenter.SeasonDataManager.dailyDeclareNum or 0
  local dailyOccupyNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyNum or 0
  local dailyOccupyMaxNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyMaxNum or 0
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  self.tips1:SetLocalText("season_s2_city_description_07", k6 - dailyDeclareNum, k6)
  self.tips2:SetLocalText("season_s1_citylist_02", dailyOccupyMaxNum - dailyOccupyNum, dailyOccupyMaxNum)
  self.info_btn1:SetActive(hasCrossAttackCity)
  self.info_btn2:SetActive(hasCrossAttackStronghold)
  self.localServer:ReInit(true)
  self.crossServer:ReInit(false)
end

return UILWSeasonCrossOccupyDetailView
