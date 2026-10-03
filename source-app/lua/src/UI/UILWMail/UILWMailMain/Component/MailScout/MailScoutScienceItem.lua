local MailScoutScienceItem = BaseClass("MailScoutScienceItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local icon_path = "btn/Icon"
local tab_name_path = "btn/TabName"
local pro_text_path = "btn/ProText"
local max_lv_go_path = "btn/MaxTextBg"
local max_lv_txt_path = "btn/MaxTextBg/MaxText"
local MAX_LV_TXT = GameDialogDefine.MAX

function MailScoutScienceItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailScoutScienceItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailScoutScienceItem:ComponentDefine()
  self.tabNameText = self:AddComponent(UIText, tab_name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.proText = self:AddComponent(UIText, pro_text_path)
  self.maxLvGo = self:AddComponent(UIBaseContainer, max_lv_go_path)
  self.maxLvText = self:AddComponent(UIText, max_lv_txt_path)
  self.maxLvText:SetLocalText(MAX_LV_TXT)
end

function MailScoutScienceItem:ComponentDestroy()
  self.tabNameText = nil
  self.icon = nil
  self.proText = nil
  self.maxLvGo = nil
  self.maxLvText = nil
end

function MailScoutScienceItem:DataDefine()
  self.tweenSeq = nil
end

function MailScoutScienceItem:DataDestroy()
  self.param = nil
  self.meta = nil
end

function MailScoutScienceItem:SetDataByCfgId(tabCfgId, progress, isHide)
  self.meta = DataCenter.ScienceTemplateManager:GetScienceTabTemplate(tabCfgId)
  self.progress = progress
  self:RefreshView(isHide)
end

function MailScoutScienceItem:RefreshView(isHide)
  self.tabNameText:SetLocalText(self.meta.name)
  local pro = self.progress
  if isHide then
    self.proText:SetActive(true)
    self.proText:SetText(GameDialogDefine.QUESTION_MARK)
    self.maxLvGo:SetActive(false)
  elseif 1 <= pro then
    self.proText:SetActive(false)
    self.maxLvGo:SetActive(true)
  else
    self.proText:SetActive(true)
    self.maxLvGo:SetActive(false)
    if 0 < pro and pro < 0.01 then
      self.proText:SetText(math.ceil(pro * 100) .. "%")
    else
      self.proText:SetText(math.floor(pro * 100) .. "%")
    end
  end
  self.icon:LoadSprite(string.format(LoadPath.UILWScience, self.meta.icon))
  self.icon:SetNativeSize()
end

return MailScoutScienceItem
