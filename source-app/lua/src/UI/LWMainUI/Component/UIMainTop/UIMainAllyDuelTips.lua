local UIMainAllyDuelTips = BaseClass("UIMainAllyDuelTips", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIMainAllyDuelTips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainAllyDuelTips:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainAllyDuelTips:ComponentDefine()
  self.tipBtn = self:AddComponent(UIButton, "gotoBtn")
  self.tipBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.name = self:AddComponent(UIText, "icon/name")
  self.icon = self:AddComponent(UIImage, "icon")
  self.gotoTxt = self:AddComponent(UIText, "gotoBtn/gotoTxt")
end

function UIMainAllyDuelTips:ComponentDestroy()
  self.tipBtn = nil
  self.name = nil
  self.gotoTxt = nil
end

function UIMainAllyDuelTips:DataDefine()
end

function UIMainAllyDuelTips:DataDestroy()
  self.meta = nil
end

function UIMainAllyDuelTips:Refresh(meta)
  local iconPath, nameKey = DataCenter.AllianceCompeteDataManager:GetMainUITip()
  if iconPath then
    self.icon:LoadSprite(iconPath)
  end
  if nameKey then
    self.name:SetLocalText(nameKey)
  end
  self.meta = meta
  if string.IsNullOrEmpty(meta.btn_name) then
    self.tipBtn:SetActive(false)
  else
    self.gotoTxt:SetLocalText(meta.btn_name)
    self.tipBtn:SetActive(true)
  end
end

function UIMainAllyDuelTips:OnBtnClick()
  DataCenter.ActivityTipsManager:OnBtnClick(self.meta)
end

return UIMainAllyDuelTips
