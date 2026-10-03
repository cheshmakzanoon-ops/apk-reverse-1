local base = UIBaseView
local UILWSeasonTetrisFailView = BaseClass("UILWSeasonTetrisFailView", base)
local btn_back_path = "Buttom/BtnBack"
local btn_again_path = "Buttom/BtnAgain"

function UILWSeasonTetrisFailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
  DataCenter.LWSoundManager:PlaySound(1000019, false)
end

function UILWSeasonTetrisFailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonTetrisFailView:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_again = self:AddComponent(UIButton, btn_again_path)
  self.btn_back:SetOnClick(BindCallback(self, self.OnBackClick))
  self.btn_again:SetOnClick(BindCallback(self, self.OnAgainClick))
end

function UILWSeasonTetrisFailView:ComponentDestroy()
  self.btn_back = nil
  self.btn_again = nil
end

function UILWSeasonTetrisFailView:OnAddListener()
  self:AddUIListener(EventId.SeasonTetrisResetUpdate, self.OnResetCallback)
end

function UILWSeasonTetrisFailView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisResetUpdate, self.OnResetCallback)
end

function UILWSeasonTetrisFailView:InitData()
  self.WaitReset = false
end

function UILWSeasonTetrisFailView:OnBackClick()
  self.ctrl:CloseSelf()
  DataCenter.SeasonTetrisManager:SendReset(false)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisCloseGame)
end

function UILWSeasonTetrisFailView:OnAgainClick()
  if self.WaitReset then
    return
  end
  DataCenter.SeasonTetrisManager:SendReset(true)
  self.WaitReset = true
end

function UILWSeasonTetrisFailView:OnResetCallback(evt)
  self.WaitReset = false
  self.ctrl:CloseSelf()
end

return UILWSeasonTetrisFailView
