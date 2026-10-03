local base = UIBaseView
local LWUISheepFailView = BaseClass("LWUISheepFailView", base)
local btn_back_path = "Buttom/BtnBack"
local btn_again_path = "Buttom/BtnAgain"

function LWUISheepFailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
end

function LWUISheepFailView:OnDestroy()
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISheepFailView:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_again = self:AddComponent(UIButton, btn_again_path)
  self.btn_back:SetOnClick(BindCallback(self, self.OnBackClick))
  self.btn_again:SetOnClick(BindCallback(self, self.OnAgainClick))
end

function LWUISheepFailView:ComponentDestroy()
  self.btn_back = nil
  self.btn_again = nil
end

function LWUISheepFailView:OnBackClick()
  self.ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepCloseGame)
end

function LWUISheepFailView:OnAgainClick()
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  self.parent:Again()
  self.ctrl:CloseSelf()
end

function LWUISheepFailView:Refresh()
  self.parent = self:GetUserData()
end

return LWUISheepFailView
