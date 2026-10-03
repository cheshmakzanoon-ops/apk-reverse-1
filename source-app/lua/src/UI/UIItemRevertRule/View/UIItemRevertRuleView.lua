local UIItemRevertRuleView = BaseClass("UIItemRevertRuleView", UIBaseView)
local base = UIBaseView
local UIItemRevertRuleAuto = require("UI.UIItemRevertRule.Auto.UIItemRevertRuleAuto")
local Localization = CS.GameEntry.Localization

function UIItemRevertRuleView:OnCreate()
  base.OnCreate(self)
  self.binder = UIItemRevertRuleAuto.New()
  self.binder:bind(self)
  self.btn_panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_LW_Btn_Close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  local isShowGoldDetail = DataCenter.PlayerInfoDataManager:ShowGoldDetail()
  if isShowGoldDetail then
    self.text8:SetActive(true)
    self.raw_image8:SetActive(true)
  else
    self.text8:SetActive(false)
    self.raw_image8:SetActive(false)
  end
  local k5 = LuaEntry.DataConfig:TryGetNum("undo_system", "k5")
  if k5 == nil then
    k5 = 1
  end
  local k6 = LuaEntry.DataConfig:TryGetNum("undo_system", "k6")
  if k6 == nil then
    k6 = 2
  end
  if CommonUtil.IsArabic() then
    self.viptext1:SetText("VIP 16+")
    self.remaining1:SetLocalText("undo_system_pic_2", k6)
    self.viptext2:SetText("VIP 0-15")
    self.remaining2:SetLocalText("undo_system_pic_3", k5)
  else
    self.viptext1:SetText("VIP 0-15")
    self.remaining1:SetLocalText("undo_system_pic_2", k5)
    self.viptext2:SetText("VIP 16+")
    self.remaining2:SetLocalText("undo_system_pic_3", k6)
  end
end

function UIItemRevertRuleView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  base.OnDestroy(self)
end

return UIItemRevertRuleView
