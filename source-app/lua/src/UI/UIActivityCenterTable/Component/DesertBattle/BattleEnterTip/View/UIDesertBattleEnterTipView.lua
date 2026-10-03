local UIDesertBattleEnterTipView = BaseClass("UIDesertBattleEnterTipView", UIBaseView)
local base = UIBaseView
local black_path = "black"
local close_btn_path = "Bg/CloseBtn"
local s_num_path = "Bg/Solider/SNum"
local s_slider_path = "Bg/Solider/SSlider"
local s_ready_path = "Bg/Solider/SReady"
local h_num_path = "Bg/Hospital/HNum"
local h_slider_path = "Bg/Hospital/HSlider"
local num1_path = "Bg/Hospital/layout/di1/Num1"
local num2_path = "Bg/Hospital/layout/di2/Num2"
local h_ready_path = "Bg/Hospital/HReady"
local btn_path = "Bg/Btn"
local check_path = "Bg/Check/Box"

function UIDesertBattleEnterTipView:OnCreate()
  base.OnCreate(self)
  self.black = self:AddComponent(UIButton, black_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.s_num = self:AddComponent(UITextMeshProUGUIEx, s_num_path)
  self.s_slider = self:AddComponent(UISlider, s_slider_path)
  self.s_ready = self:AddComponent(UIImage, s_ready_path)
  self.h_num = self:AddComponent(UITextMeshProUGUIEx, h_num_path)
  self.h_slider = self:AddComponent(UISlider, h_slider_path)
  self.num1 = self:AddComponent(UITextMeshProUGUIEx, num1_path)
  self.num2 = self:AddComponent(UITextMeshProUGUIEx, num2_path)
  self.h_ready = self:AddComponent(UIImage, h_ready_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.check = self:AddComponent(UIToggle, check_path)
  self.check:SetIsOn(true)
  self.black:SetOnClick(BindCallback(self, self.OnBtnGo))
  self.close_btn:SetOnClick(BindCallback(self, self.OnBtnGo))
  self.btn:SetOnClick(BindCallback(self, self.OnBtnGo))
  local strPercent = "-100%"
  self.num1:SetText(strPercent)
  self.num2:SetText(strPercent)
  local info = BattleFieldUtil.GetSoldiersInfo()
  local sMax = 0
  if info and info.id then
    sMax = info.total
  end
  self.s_num:SetText(sMax .. "/" .. sMax)
  self.s_slider:SetValue(1)
  self.h_num:SetText(0 .. "/\226\136\158")
  self.h_slider:SetValue(0)
end

function UIDesertBattleEnterTipView:OnDestroy()
  self.black = nil
  self.close_btn = nil
  self.s_num = nil
  self.s_slider = nil
  self.s_ready = nil
  self.h_num = nil
  self.h_slider = nil
  self.num1 = nil
  self.num2 = nil
  self.h_ready = nil
  self.btn = nil
  self.check = nil
  base.OnDestroy(self)
end

function UIDesertBattleEnterTipView:OnBtnGo()
  if self.check:GetIsOn() then
    CommonUtil.PlayerPrefsSetString(TipEnterDragonWorld, tostring(UITimeManager:GetInstance():GetServerSeconds()))
  end
  local cb = self:GetUserData()
  self.ctrl:CloseSelf()
  if cb then
    cb()
  end
end

return UIDesertBattleEnterTipView
