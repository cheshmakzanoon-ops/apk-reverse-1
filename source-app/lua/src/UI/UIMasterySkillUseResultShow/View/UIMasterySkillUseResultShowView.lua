local UIMasterySkillUseResultShowView = BaseClass("UIMasterySkillUseResultShowView", UIBaseView)
local base = UIBaseView
local panel_path = "UICommonRewardPopUp/Panel"
local text_title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local icon_path = "layout/Icon"
local des_text_path = "layout/DesText"

function UIMasterySkillUseResultShowView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIMasterySkillUseResultShowView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMasterySkillUseResultShowView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    if self.param and self.param.closeFunc then
      self.param.closeFunc()
    end
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UIText, text_title_path)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
end

function UIMasterySkillUseResultShowView:ComponentDestroy()
  self.panel = nil
  self.title_text = nil
  self.icon_image = nil
  self.des_text = nil
end

function UIMasterySkillUseResultShowView:DataDefine()
  self.param = self:GetUserData()
end

function UIMasterySkillUseResultShowView:DataDestroy()
  self.param = nil
end

function UIMasterySkillUseResultShowView:Init()
  if not self.param then
    return
  end
  if self.param.title then
    self.title_text:SetText(self.param.title)
  end
  if self.param.icon then
    self.icon_image:LoadSprite(self.param.icon)
  end
  if self.param.desc then
    self.des_text:SetText(self.param.desc)
  end
end

return UIMasterySkillUseResultShowView
