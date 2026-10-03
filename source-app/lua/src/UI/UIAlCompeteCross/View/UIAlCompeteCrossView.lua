local UIAlCompeteCrossView = BaseClass("UIAlCompeteCrossView", UIBaseView)
local base = UIBaseView

function UIAlCompeteCrossView:OnCreate()
  base.OnCreate(self)
  self._title_txt = self:AddComponent(UIText, "PointArea/Text_Title")
  self._title_txt:SetLocalText(110214)
  self._des_txt = self:AddComponent(UIText, "PointArea/Des")
  self._des_txt:SetLocalText(110215)
  self.close_btn = self:AddComponent(UIButton, "panel")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, "PointArea/UseBtn")
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._btn_txt = self:AddComponent(UIText, "PointArea/UseBtn/UseBtnName")
  self._btn_txt:SetLocalText(110006)
end

function UIAlCompeteCrossView:OnDestroy()
  base.OnDestroy(self)
end

function UIAlCompeteCrossView:OnEnable()
  base.OnEnable(self)
end

function UIAlCompeteCrossView:OnDisable()
  base.OnDisable(self)
end

return UIAlCompeteCrossView
