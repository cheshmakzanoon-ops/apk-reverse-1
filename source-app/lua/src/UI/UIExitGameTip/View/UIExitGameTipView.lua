local UIExitGameTipView = BaseClass("UIExitGameTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UpperCenter = CS.UnityEngine.TextAnchor.UpperCenter
local title_path = "Layout/UICommonPopBg/TitleTxt"
local return_btn_path = "panel"
local close_btn_path = "Layout/UICommonPopBg/CloseBtn"
local tips_txt_path = "Layout/ScrollView/Viewport/Content/DesName"
local btn_1_path = "Layout/BtnGo/LeftBtn"
local btn_1_txt_path = "Layout/BtnGo/LeftBtn/LeftBtnName"

local function OnCreate(self)
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.btn_1 = self:AddComponent(UIButton, btn_1_path)
  self.btn_1_txt = self:AddComponent(UIText, btn_1_txt_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.scrollView = self:AddComponent(UILayoutElement, "Layout/ScrollView")
  self.content = self:AddComponent(UIBaseComponent, "Layout/ScrollView/Viewport/Content")
  self.btn_1:SetOnClick(function()
    self:ExitGame()
  end)
  self.title:SetLocalText(100378)
  self.tips_txt:SetLocalText(100838)
  self.btn_1_txt:SetLocalText(393010)
end

local function OnDestroy(self)
  self.titleText = nil
  self.tipText = nil
  self.text1 = nil
  self.text2 = nil
  self.action1 = nil
  self.closeAction = nil
  self.action2 = nil
  self.title = nil
  self.tips_txt = nil
  self.btn_1 = nil
  self.btn_1_txt = nil
  self.close_btn = nil
  self.return_btn = nil
  self.closeIsShow = nil
  self.isChangeImg = nil
  self.isBuy = nil
  base.OnDestroy(self)
end

local function ExitGame(self)
  CS.ApplicationLaunch.Instance:Quit()
end

UIExitGameTipView.OnCreate = OnCreate
UIExitGameTipView.OnDestroy = OnDestroy
UIExitGameTipView.ExitGame = ExitGame
return UIExitGameTipView
