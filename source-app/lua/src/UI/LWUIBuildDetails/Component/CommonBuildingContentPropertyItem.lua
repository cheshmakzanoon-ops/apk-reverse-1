local CommonBuildingContentPropertyItem = BaseClass("CommonBuildingContentPropertyItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local tip_btn_path = "tipBtn"
local effect_txt_path = "effectTxt"
local value_text_path = "ValueContainer/ValueText"
local eff_path = "Eff"

function CommonBuildingContentPropertyItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function CommonBuildingContentPropertyItem:OnDestroy()
  self:CloseAniSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonBuildingContentPropertyItem:DataDefine()
  self.property = nil
  self.curBuildData = nil
  self.aniSeq = nil
  self.recordVal = nil
end

function CommonBuildingContentPropertyItem:DataDestroy()
  self.property = nil
  self.curBuildData = nil
  self.aniSeq = nil
  self.recordVal = nil
end

function CommonBuildingContentPropertyItem:ComponentDefine()
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.effect_txt = self:AddComponent(UITextMeshProUGUIEx, effect_txt_path)
  self.value_text = self:AddComponent(UITextMeshProUGUIEx, value_text_path)
  self.eff = self:AddComponent(UIBaseContainer, eff_path)
  self.eff:SetActive(false)
  self.tip_btn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
end

function CommonBuildingContentPropertyItem:ComponentDestroy()
  self.tip_btn = nil
  self.effect_txt = nil
  self.value_text = nil
  self.eff = nil
end

function CommonBuildingContentPropertyItem:ReInit(property, curBuildData)
  local lang = Localization.Language
  local LanguageType = CS.GameFramework.Localization.Language
  self.property = property
  self.curBuildData = curBuildData
  self:CloseAniSeq()
  self.eff:SetActive(false)
  self.effect_txt:SetText(self.property.describe)
  self.value_text:SetText(self.property.valueText)
  if lang == LanguageType.German then
    self.effect_txt:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineLeft)
  end
  local effectId = self.property.effectId
  local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
  local tipKey = effectLine.worker_hall_desc_building
  local tipShow = not string.IsNullOrEmpty(tipKey)
  self.tip_btn:SetActive(tipShow)
end

function CommonBuildingContentPropertyItem:OnTipBtnClick()
  local effectId = self.property.effectId
  local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
  local tipKey = effectLine.worker_hall_desc_building
  local tipShow = not string.IsNullOrEmpty(tipKey)
  if not tipShow then
    return
  end
  local content = Localization:GetString(tipKey)
  UIUtil.ShowBubbleTips(content, self.tip_btn.transform.position, 0, -20, 20)
end

function CommonBuildingContentPropertyItem:CloseAniSeq()
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

function CommonBuildingContentPropertyItem:RecordCurVal()
  self.recordVal = self.property.valueText
end

function CommonBuildingContentPropertyItem:TryPlayAni()
  if self.recordVal == self.property.valueText then
    return
  end
  self:CloseAniSeq()
  self.aniSeq = DOTween.Sequence()
  self.aniSeq:AppendInterval(0.3)
  self.aniSeq:AppendCallback(function()
    self.eff:SetActive(false)
    self.eff:SetActive(true)
  end)
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

return CommonBuildingContentPropertyItem
