local base = UIBaseView
local UILWBiuBiuPveFairResultView = BaseClass("UILWBiuBiuPveFairResultView", base)
local btn_back_path = "Buttom/BtnBack"
local btn_again_path = "Buttom/BtnAgain"

function UILWBiuBiuPveFairResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.battleResult = self:GetUserData()
  self:Refresh()
  DataCenter.LWSoundManager:PlaySound(5100015, false)
end

function UILWBiuBiuPveFairResultView:OnDestroy()
  if self.battleResult then
    self.battleResult.boot:Exit()
    self.battleResult = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuPveFairResultView:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_again = self:AddComponent(UIButton, btn_again_path)
  self.btn_back:SetOnClick(BindCallback(self, self.OnClickBack))
  self.btn_again:SetOnClick(BindCallback(self, self.OnClickAgain))
end

function UILWBiuBiuPveFairResultView:ComponentDestroy()
  self.btn_back = nil
  self.btn_again = nil
end

function UILWBiuBiuPveFairResultView:OnClickBack()
  self.ctrl:CloseSelf()
end

function UILWBiuBiuPveFairResultView:OnClickAgain()
  self.battleResult.boot:Next()
  self.battleResult = nil
  self.ctrl:CloseSelf()
end

function UILWBiuBiuPveFairResultView:Refresh()
end

return UILWBiuBiuPveFairResultView
