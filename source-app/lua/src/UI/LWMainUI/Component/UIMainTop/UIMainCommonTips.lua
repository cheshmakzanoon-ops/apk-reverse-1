local UIMainCommonTips = BaseClass("UIMainCommonTips", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIMainCommonTips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainCommonTips:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainCommonTips:ComponentDefine()
  self.tipBtn = self:AddComponent(UIButton, "bg/gotoBtn")
  self.tipBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.tipTxt = self:AddComponent(UIText, "bg/tipTxt")
  self.gotoTxt = self:AddComponent(UIText, "bg/gotoBtn/gotoTxt")
end

function UIMainCommonTips:ComponentDestroy()
  self.tipBtn = nil
  self.tipTxt = nil
  self.gotoTxt = nil
end

function UIMainCommonTips:DataDefine()
end

function UIMainCommonTips:DataDestroy()
  self.meta = nil
end

function UIMainCommonTips:Refresh(meta)
  self.meta = meta
  if not string.IsNullOrEmpty(meta.tipsContent) then
    self.tipTxt:SetText(meta.tipsContent)
  else
    self.tipTxt:SetLocalText(meta.tips)
  end
  if string.IsNullOrEmpty(meta.btn_name) then
    self.tipBtn:SetActive(false)
  else
    self.gotoTxt:SetLocalText(meta.btn_name)
    self.tipBtn:SetActive(true)
  end
end

function UIMainCommonTips:OnBtnClick()
  DataCenter.ActivityTipsManager:OnBtnClick(self.meta)
end

return UIMainCommonTips
