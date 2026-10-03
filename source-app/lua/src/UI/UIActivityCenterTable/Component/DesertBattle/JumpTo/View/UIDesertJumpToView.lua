local UIDesertJumpToView = BaseClass("UIDesertJumpToView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIDesertJumpToItem = require("UI.UIActivityCenterTable.Component.DesertBattle.JumpTo.Component.UIDesertJumpToItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local cond1_path = "PopUpTitle/Common_bg_orange2/Content/cond1"
local cond2_path = "PopUpTitle/Common_bg_orange2/Content/cond2"
local cond3_path = "PopUpTitle/Common_bg_orange2/Content/cond3"
local cond4_path = "PopUpTitle/Common_bg_orange2/Content/cond4"
local cond5_path = "PopUpTitle/Common_bg_orange2/Content/cond5"
local cond6_path = "PopUpTitle/Common_bg_orange2/Content/cond6"
local btn_rules_path = "PopUpTitle/Common_bg_orange2/BtnRules"

function UIDesertJumpToView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIDesertJumpToView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertJumpToView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.cond1 = self:AddComponent(UIDesertJumpToItem, cond1_path)
  self.cond2 = self:AddComponent(UIDesertJumpToItem, cond2_path)
  self.cond3 = self:AddComponent(UIDesertJumpToItem, cond3_path)
  self.cond4 = self:AddComponent(UIDesertJumpToItem, cond4_path)
  self.cond5 = self:AddComponent(UIDesertJumpToItem, cond5_path)
  self.cond6 = self:AddComponent(UIDesertJumpToItem, cond6_path)
  self.btn_rules = self:AddComponent(UIButton, btn_rules_path)
  self.cond1:ReInit(BattlefieldEnterCheckType.AllianceIsValid, self.param)
  self.cond2:ReInit(BattlefieldEnterCheckType.BattlefieldMemberFull, self.param)
  self.cond3:ReInit(BattlefieldEnterCheckType.YouAreLowBeMember, self.param)
  self.cond4:ReInit(BattlefieldEnterCheckType.InBlackRect, self.param)
  self.cond5:SetActive(false)
  self.cond6:SetActive(false)
  self.btn_rules:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertJumpTo)
  end)
end

function UIDesertJumpToView:ComponentDestroy()
  self.cond1 = nil
  self.cond2 = nil
  self.cond3 = nil
  self.cond4 = nil
  self.cond5 = nil
  self.cond6 = nil
  self.btn_rules = nil
end

return UIDesertJumpToView
