local UILWDominatorArchiveDetailCockatriceView = BaseClass("UILWDominatorArchiveDetailCockatriceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local utf8Tools = require("Common/Tools/utf8")
UILWDominatorArchiveDetailCockatriceView.DeltaDuration = 0.04

function UILWDominatorArchiveDetailCockatriceView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorArchiveDetailCockatriceView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorArchiveDetailCockatriceView:OnOpen()
  local id = self:GetUserData()
  self.template = DataCenter.DominatorTemplateManager:GetStoryShowTemplateById(id)
  if self.template == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.scrollHeight = self.compScroll.rectTransform.rect.height
  self.title = self.template:GetDetailTitle()
  self.titleLength = utf8Tools.len(self.title)
  self.titleDuration = self.titleLength * self.DeltaDuration
  self.main = self.template:GetDetailMain()
  self.mainLength = utf8Tools.len(self.main)
  self.mainDuration = self.mainLength * self.DeltaDuration
  self.final = self.template:GetDetailFinal()
  self.finalLength = utf8Tools.len(self.final)
  self.finalDuration = self.finalLength * self.DeltaDuration
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.progressTitle = 0
  local tweenTitle = CS.DG.Tweening.DOTween.To(function()
    return self.progressTitle
  end, function(p)
    self.progressTitle = p
    local text = self:GetPartString(self.progressTitle, "title")
    if self.textTitle then
      self.textTitle:SetText(text)
    end
  end, 1, self.titleDuration):SetEase(CS.DG.Tweening.Ease.Linear)
  self.sequence:Append(tweenTitle)
  self.sequence:AppendInterval(0.5)
  self.progressMain = 0
  local tweenMain = CS.DG.Tweening.DOTween.To(function()
    return self.progressMain
  end, function(p)
    self.progressMain = p
    local text = self:GetPartString(self.progressMain, "main")
    if self.textMain then
      self.textMain:SetText(text)
    end
    self:UpdateScrollRectPosition()
  end, 1, self.mainDuration):SetEase(CS.DG.Tweening.Ease.Linear)
  self.sequence:Append(tweenMain)
  self.sequence:AppendInterval(0.5)
  self.progressFinal = 0
  local tweenFinal = CS.DG.Tweening.DOTween.To(function()
    return self.progressFinal
  end, function(p)
    self.progressFinal = p
    local text = self:GetPartString(self.progressFinal, "final")
    if self.textFinal then
      self.textFinal:SetText(text)
    end
    self:UpdateScrollRectPosition()
  end, 1, self.finalDuration):SetEase(CS.DG.Tweening.Ease.Linear)
  self.sequence:Append(tweenFinal)
  self.sequence:OnComplete(function()
    if self.btnSkip then
      self.btnSkip:SetActive(false)
    end
    if self.textContinue then
      self.textContinue:SetActive(true)
    end
    self.isShowAll = true
  end)
  self.btnSkip:SetActive(true)
end

function UILWDominatorArchiveDetailCockatriceView:UpdateScrollRectPosition()
  if self.compContent == nil or self.scrollHeight == nil then
    return
  end
  local contentHeight = self.compContent.rectTransform.rect.height
  if contentHeight > self.scrollHeight then
    local delta = contentHeight - self.scrollHeight
    self.compContent.transform:Set_localPosition(0, delta, 0)
  end
end

function UILWDominatorArchiveDetailCockatriceView:GetPartString(progress, mode)
  local input = ""
  local length = 0
  if mode == "main" then
    input = self.main
    length = self.mainLength
  elseif mode == "title" then
    input = self.title
    length = self.titleLength
  elseif mode == "final" then
    input = self.final
    length = self.finalLength
  end
  local partLength = math.floor(progress * length)
  if partLength == 0 then
    return ""
  elseif partLength == length then
    return input
  else
    local res = utf8Tools.sub(input, 1, partLength)
    return res
  end
end

function UILWDominatorArchiveDetailCockatriceView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Root/TitleText")
  self.textTitle:SetText("")
  self.compScroll = self:AddComponent(UIBaseContainer, "Root/ScrollView")
  self.compContent = self:AddComponent(UIButton, "Root/ScrollView/Viewport/Content")
  self.compContent:SetOnClick(function()
    self:OnBtnContentClick()
  end)
  self.textMain = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/MainText")
  self.textMain:SetText("")
  self.textFinal = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/FinalText")
  self.textFinal:SetText("")
  self.textContinue = self:AddComponent(UIText, "Root/ContinueText")
  self.textContinue:SetText(Localization:GetString("dominator_cure_desc_9"))
  self.textContinue:SetActive(false)
  self.btnSkip = self:AddComponent(UIButton, "BtnSkip")
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.btnSkip:SetActive(false)
end

function UILWDominatorArchiveDetailCockatriceView:ComponentDestroy()
  self.btnPanel = nil
  self.textTitle = nil
  self.compScroll = nil
  self.compContent = nil
  self.textMain = nil
  self.textFinal = nil
  self.textContinue = nil
  self.btnSkip = nil
end

function UILWDominatorArchiveDetailCockatriceView:DataDefine()
  self.isShowAll = false
end

function UILWDominatorArchiveDetailCockatriceView:DataDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.isShowAll = nil
end

function UILWDominatorArchiveDetailCockatriceView:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorArchiveDetailCockatriceView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorArchiveDetailCockatriceView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWDominatorArchiveDetailCockatriceView:OnBtnSkipClick()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.btnSkip:SetActive(false)
  self.textContinue:SetActive(true)
  if self.title then
    self.textTitle:SetText(self.title)
  end
  if self.main then
    self.textMain:SetText(self.main)
  end
  if self.final then
    self.textFinal:SetText(self.final)
  end
  self.isShowAll = true
end

function UILWDominatorArchiveDetailCockatriceView:OnBtnContentClick()
  if not self.isShowAll then
    self:OnBtnSkipClick()
  else
    self:OnBtnPanelClick()
  end
end

return UILWDominatorArchiveDetailCockatriceView
