local MailEffectTipItem = BaseClass("MailEffectTipItem", UIBaseContainer)
local base = UIBaseContainer
local line_path = "bg/line"
local jump_btn_txt_path = "bg/jumpBtn/jumpBtnTxt"

function MailEffectTipItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function MailEffectTipItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function MailEffectTipItem:ComponentDefine()
  self.desc = self:AddComponent(UIText, "bg/desc")
  self.value1 = self:AddComponent(UIText, "bg/value1")
  self.value2 = self:AddComponent(UIText, "bg/value2")
  self.jumpBtnN = self:AddComponent(UIButton, "bg/jumpBtn")
  self.jumpBtnN:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.lineObj = self:AddComponent(UIBaseContainer, line_path)
  self.btnText = self:AddComponent(UIText, jump_btn_txt_path)
end

function MailEffectTipItem:ComponentDestroy()
end

function MailEffectTipItem:DataDefine()
end

function MailEffectTipItem:DataDestroy()
end

function MailEffectTipItem:SetData(lang, leftValue, rightValue, gotoType, gotoParam)
  self.gotoType = gotoType
  self.gotoParam = gotoParam
  self.desc:SetLocalText(lang)
  self.value1:SetText(string.GetFormattedPercentStr(leftValue))
  self.value2:SetText(string.GetFormattedPercentStr(rightValue))
  self.lineObj:SetActive(true)
  local isContainGotoType = false
  for _, v in pairs(QuestGoType) do
    if v == toInt(gotoType) then
      isContainGotoType = true
      break
    end
  end
  self.jumpBtnN.gameObject:SetActive(isContainGotoType)
  self:RefreshBtnTextByGotoType()
end

function MailEffectTipItem:OnClickJumpBtn()
  if self.gotoType and self.gotoParam then
    GoToUtil.GoToByTypeAndParam(tonumber(self.gotoType), {
      tonumber(self.gotoParam)
    }, nil, false)
  end
end

function MailEffectTipItem:RefreshBtnTextByGotoType()
  if not self.gotoType then
    self.btnText:SetLocalText(100094)
    return
  end
  local intType = toInt(self.gotoType)
  if intType == QuestGoType.GoAllianceTech then
    self.btnText:SetLocalText("power_display_new_105")
  elseif intType == QuestGoType.GoMasterySkillPanel or self.gotoType == QuestGoType.GoMasteryMain then
    self.btnText:SetLocalText("power_display_new_106")
  elseif intType == QuestGoType.GoToSeasonActivity then
    self.btnText:SetLocalText("battle_report_btn_season")
  else
    self.btnText:SetLocalText(100094)
  end
end

function MailEffectTipItem:HideLine()
  self.lineObj:SetActive(false)
end

return MailEffectTipItem
