local KingPowerHistoryView = BaseClass("KingPowerHistoryView", UIBaseView)
local base = UIBaseView
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"

function KingPowerHistoryView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function KingPowerHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function KingPowerHistoryView:OnAddListener()
  base.OnAddListener(self)
end

function KingPowerHistoryView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function KingPowerHistoryView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("457005")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function KingPowerHistoryView:ComponentDestroy()
  self.btn_back = nil
end

function KingPowerHistoryView:UpdateData()
end

return KingPowerHistoryView
