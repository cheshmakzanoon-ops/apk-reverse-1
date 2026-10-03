local base = UIBaseView
local UILWGGGoPveFairResultView = BaseClass("UILWGGGoPveFairResultView", base)
local btn_back_path = "Buttom/BtnBack"
local btn_again_path = "Buttom/BtnAgain"

function UILWGGGoPveFairResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.battleResult = self:GetUserData()
  self:Refresh()
  DataCenter.LWSoundManager:PlaySound(6100037, false)
end

function UILWGGGoPveFairResultView:OnDestroy()
  if self.battleResult then
    self.battleResult.boot:Exit()
    self.battleResult = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWGGGoPveFairResultView:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_again = self:AddComponent(UIButton, btn_again_path)
  self.btn_back:SetOnClick(BindCallback(self, self.OnClickBack))
  self.btn_again:SetOnClick(BindCallback(self, self.OnClickAgain))
end

function UILWGGGoPveFairResultView:ComponentDestroy()
  self.btn_back = nil
  self.btn_again = nil
end

function UILWGGGoPveFairResultView:OnClickBack()
  self.ctrl:CloseSelf()
end

function UILWGGGoPveFairResultView:OnClickAgain()
  self.battleResult.boot:Next()
  self.battleResult = nil
  self.ctrl:CloseSelf()
end

function UILWGGGoPveFairResultView:Refresh()
end

return UILWGGGoPveFairResultView
