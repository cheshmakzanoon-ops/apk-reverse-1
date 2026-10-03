local p_text_title_path = "top/p_text_title"
local p_btn_back_path = "top/p_btn_back"
local p_text_desc_path = "mid/p_text_desc"
local p_toggle_today_path = "p_toggle_today"
local p_text_today_path = "p_toggle_today/p_text_today"
local p_btn_battle_path = "bottom/p_btn_battle"
local p_text_battle_path = "bottom/p_btn_battle/p_text_battle"
local p_btn_drink_path = "bottom/p_btn_drink"
local p_text_drink_path = "bottom/p_btn_drink/p_text_drink"
local base = UIBaseView
local LWMakingCoffeeTipsView = BaseClass("LWMakingCoffeeTipsView", UIBaseView)

function LWMakingCoffeeTipsView:ComponentDefine()
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_back = self:AddComponent(UIButton, p_btn_back_path)
  self.p_btn_back:SetOnClick(BindCallback(self, self.OnBackClicked))
  self.p_text_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_desc_path)
  self.p_toggle_today = self:AddComponent(UIToggle, p_toggle_today_path)
  self.p_text_today = self:AddComponent(UITextMeshProUGUIEx, p_text_today_path)
  self.p_btn_battle = self:AddComponent(UIButton, p_btn_battle_path)
  self.p_btn_battle:SetOnClick(BindCallback(self, self.OnBattleClicked))
  self.p_text_battle = self:AddComponent(UITextMeshProUGUIEx, p_text_battle_path)
  self.p_btn_drink = self:AddComponent(UIButton, p_btn_drink_path)
  self.p_btn_drink:SetOnClick(BindCallback(self, self.OnDrinkClicked))
  self.p_text_drink = self:AddComponent(UITextMeshProUGUIEx, p_text_drink_path)
end

function LWMakingCoffeeTipsView:ComponentDestroy()
  self.p_text_title = nil
  self.p_btn_back = nil
  self.p_text_desc = nil
  self.p_toggle_today = nil
  self.p_text_today = nil
  self.p_btn_battle = nil
  self.p_text_battle = nil
  self.p_btn_drink = nil
  self.p_text_drink = nil
end

function LWMakingCoffeeTipsView:DataDefine()
end

function LWMakingCoffeeTipsView:DataDestroy()
end

function LWMakingCoffeeTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function LWMakingCoffeeTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWMakingCoffeeTipsView:OnAddListener()
  base.OnAddListener(self)
end

function LWMakingCoffeeTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWMakingCoffeeTipsView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function LWMakingCoffeeTipsView:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function LWMakingCoffeeTipsView:InitUi()
  self.p_text_title:SetLocalText("season_coffee_killmonster_tips_title")
  self.p_text_desc:SetLocalText("season_coffee_killmonster_tips_new")
  self.p_text_drink:SetLocalText("season_coffee_killmonster_tips_btn1")
  self.p_text_battle:SetLocalText("season_coffee_killmonster_tips_btn2")
  self.p_text_today:SetLocalText(110103)
  self.p_toggle_today:SetIsOn(false)
  self.p_toggle_today:SetOnValueChanged(nil)
  self.p_toggle_today:SetIsOn(false)
  self.p_toggle_today:SetOnValueChanged(function()
    local day = -1
    if self.p_toggle_today:GetIsOn() then
      day = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
    end
    CommonUtil.PlayerPrefsSetInt("COFFEE_ATTACK", day)
  end)
end

function LWMakingCoffeeTipsView:OnBackClicked()
  self.ctrl:CloseSelf()
end

function LWMakingCoffeeTipsView:OnBattleClicked()
  if self.Data ~= nil and self.Data.Action ~= nil then
    self.ctrl:CloseSelf()
    self.Data.Action()
  end
end

function LWMakingCoffeeTipsView:OnDrinkClicked()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWMakingCoffeeView, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

return LWMakingCoffeeTipsView
