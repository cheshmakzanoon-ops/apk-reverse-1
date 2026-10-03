local base = UIBaseContainer
local UIQueenOfBloodMonsterTipTab = BaseClass("UIQueenOfBloodMonsterTipTab", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIQueenOfBloodMonsterTipTab:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodMonsterTipTab:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodMonsterTipTab:ComponentDefine()
  self.btnTab1 = self:AddComponent(UIButton, "")
  self.btnTab1:SetOnClick(function()
    self:OnBtnTab1Click()
  end)
  self.compChoose = self:AddComponent(UIBaseComponent, "Bg/Choose")
end

function UIQueenOfBloodMonsterTipTab:ComponentDestroy()
  self.btnTab1 = nil
  self.compChoose = nil
end

function UIQueenOfBloodMonsterTipTab:DataDefine()
end

function UIQueenOfBloodMonsterTipTab:DataDestroy()
  self.index = nil
  self.callback = nil
end

function UIQueenOfBloodMonsterTipTab:OnAddListener()
  base.OnAddListener(self)
end

function UIQueenOfBloodMonsterTipTab:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIQueenOfBloodMonsterTipTab:OnBtnTab1Click()
  if self.callback then
    self.callback(self.index)
  end
end

function UIQueenOfBloodMonsterTipTab:SetData(index, callback)
  self.index = index
  self.callback = callback
end

function UIQueenOfBloodMonsterTipTab:SetSelect(isSelect)
  self.compChoose:SetActive(isSelect)
end

return UIQueenOfBloodMonsterTipTab
