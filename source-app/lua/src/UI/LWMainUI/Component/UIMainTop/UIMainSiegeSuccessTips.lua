local UIMainSiegeSuccessTips = BaseClass("UIMainSiegeSuccessTips", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local name_path = "name"
local go_btn_path = "GoToBtn"
local red_path = "GoToBtn/Red"
local title_path = "title"
local go_to_text_path = "GoToBtn/GoToText"

function UIMainSiegeSuccessTips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainSiegeSuccessTips:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainSiegeSuccessTips:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.red = self:AddComponent(UIImage, red_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.go_to_text = self:AddComponent(UITextMeshProUGUIEx, go_to_text_path)
end

function UIMainSiegeSuccessTips:ComponentDestroy()
end

function UIMainSiegeSuccessTips:DataDefine()
end

function UIMainSiegeSuccessTips:DataDestroy()
  self.meta = nil
  self.newOccupy = nil
end

function UIMainSiegeSuccessTips:Refresh(meta)
  self.newOccupy = DataCenter.WorldAllianceCityDataManager:GetFirstNewOccupy()
  self.reward = DataCenter.WorldAllianceCityDataManager:GetOccupyRewardByCityId(self.newOccupy.cityId)
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.newOccupy.cityId)
  self.name:SetText(Localization:GetString("140205", cityMeta.level, Localization:GetString(cityMeta.name)))
  self.icon:LoadSprite(cityMeta:GetIconPath(false))
  self.red:SetActive(self.reward)
  self.go_to_text:SetLocalText(meta.btn_name)
  self.title:SetLocalText(meta.tips)
  self.meta = meta
end

function UIMainSiegeSuccessTips:OnBtnClick()
  DataCenter.ActivityTipsManager:OnBtnClick(self.meta)
end

return UIMainSiegeSuccessTips
