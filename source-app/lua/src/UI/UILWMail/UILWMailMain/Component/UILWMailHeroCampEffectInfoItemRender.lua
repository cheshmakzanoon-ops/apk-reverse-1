local UILWMailHeroCampEffectInfoItemRender = BaseClass("UILWMailHeroCampEffectInfoItemRender", UIBaseContainer)
local base = UIBaseContainer
local info_icon_path = "IconBG/InfoIcon"
local info_text_path = "InfoText"
local addition_text_path = "AdditionText"

function UILWMailHeroCampEffectInfoItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMailHeroCampEffectInfoItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailHeroCampEffectInfoItemRender:ComponentDefine()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
  self.info_icon = self:AddComponent(UIImage, info_icon_path)
  self.info_text = self:AddComponent(UIText, info_text_path)
  self.addition_text = self:AddComponent(UIText, addition_text_path)
end

function UILWMailHeroCampEffectInfoItemRender:ComponentDestroy()
  self.info_icon = nil
  self.info_text = nil
  self.addition_text = nil
end

function UILWMailHeroCampEffectInfoItemRender:ReInit(campEffectType, isExistExtraPowerData, para)
  if campEffectType ~= 0 then
    self.canvasGroup:SetAlpha(1)
    local campEffectConfig = DataCenter.CampEffectManager:GetTemplate(campEffectType)
    local path = string.format(LoadPath.HeroCommonPath, campEffectConfig.icon)
    self.info_icon:LoadSprite(path)
    self.info_text:SetLocalText(campEffectConfig.des)
    if isExistExtraPowerData then
      local effectPara = para
      if not effectPara or effectPara < 0 then
        effectPara = campEffectConfig.effect_para
      end
      self.addition_text:SetLocalText(campEffectConfig.effect_desc, effectPara * 100 .. "%")
    else
      self.addition_text:SetLocalText("new_arena_tips_89")
    end
  else
    self.canvasGroup:SetAlpha(0)
  end
end

return UILWMailHeroCampEffectInfoItemRender
