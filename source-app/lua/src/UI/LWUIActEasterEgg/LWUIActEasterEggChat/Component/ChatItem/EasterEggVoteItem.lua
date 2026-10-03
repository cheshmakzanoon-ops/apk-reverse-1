local base = UIBaseContainer
local EasterEggVoteItem = BaseClass("EasterEggVoteItem", base)
local M = EasterEggVoteItem
local Localization = CS.GameEntry.Localization
local topBlankHeight = 79.5
local bottomBlankHeight = 175
local CurState = {
  None = 0,
  OptionA = 1,
  OptionB = 2
}
local BlueColor = Color.New(0.4823529411764706, 0.8627450980392157, 0.9568627450980393, 1)
local RedColor = Color.New(1.0, 0.5764705882352941, 0.4823529411764706, 1)

function M:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function M:OnDestroy()
  self:KillSequence()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.textOptionA = self:AddComponent(UITextMeshProUGUIEx, "ANode/OptionAText")
  self.textOptionAVoteNum = self:AddComponent(UITextMeshProUGUIEx, "ABg/OptionAVoteNum")
  self.btnOptionASelect = self:AddComponent(UIButton, "BlueBg/OptionASelectBtn")
  self.btnOptionASelect:SetOnClick(function()
    self:OnBtnOptionASelectClick()
  end)
  self.textOptionB = self:AddComponent(UITextMeshProUGUIEx, "BNode/OptionBText")
  self.textOptionBVoteNum = self:AddComponent(UITextMeshProUGUIEx, "BBg/OptionBVoteNum")
  self.btnOptionBSelect = self:AddComponent(UIButton, "RedBg/OptionBSelectBtn")
  self.btnOptionBSelect:SetOnClick(function()
    self:OnBtnOptionBSelectClick()
  end)
  self.sliderRed = self:AddComponent(UISlider, "SilderNode/redSlider")
  self.sliderBlue = self:AddComponent(UISlider, "SilderNode/blueSlider")
  self.textOptionARate = self:AddComponent(UITextMeshProUGUIEx, "SilderNode/OptionARate")
  self.textOptionBRate = self:AddComponent(UITextMeshProUGUIEx, "SilderNode/OptionBRate")
  self.compSilderNode = self:AddComponent(UIBaseContainer, "SilderNode")
  self.simpleAni = self:AddComponent(UISimpleAnimation, "SilderNode")
  self.optionAImage = self:AddComponent(UIImage, "ANode/OptionAImage")
  self.optionBImage = self:AddComponent(UIImage, "BNode/OptionBImage")
  self.imgRedBg = self:AddComponent(UIImage, "RedBg")
  self.imgBlueBg = self:AddComponent(UIImage, "BlueBg")
  self.imgABg = self:AddComponent(UIImage, "ABg")
  self.imgBBg = self:AddComponent(UIImage, "BBg")
  self.textOptionATranslate = self:AddComponent(UITextMeshProUGUIEx, "ANode/OptionATranslateText")
  self.textOptionBTranslate = self:AddComponent(UITextMeshProUGUIEx, "BNode/OptionBTranslateText")
  self.selectBlueEffect = self.transform:Find("SilderNode/OptionAImage/Eff_ui_select_blue"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.selectRedEffect = self.transform:Find("SilderNode/OptionBImage/Eff_ui_select_red"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.vsImage = self:AddComponent(UIImage, "VS")
  ChatInterface.SetEmojiTextProperty(self.textOptionA)
  ChatInterface.SetEmojiTextProperty(self.textOptionB)
  ChatInterface.SetEmojiTextProperty(self.textOptionATranslate)
  ChatInterface.SetEmojiTextProperty(self.textOptionBTranslate)
end

function M:ComponentDestroy()
  self.textOptionA = nil
  self.textOptionAVoteNum = nil
  self.btnOptionASelect = nil
  self.textOptionB = nil
  self.textOptionBVoteNum = nil
  self.btnOptionBSelect = nil
  self.sliderRed = nil
  self.sliderBlue = nil
  self.textOptionARate = nil
  self.textOptionBRate = nil
  self.compSilderNode = nil
  self.simpleAni = nil
  self.optionAImage = nil
  self.optionBImage = nil
  self.imgRedBg = nil
  self.imgBlueBg = nil
  self.imgABg = nil
  self.imgBBg = nil
  self.textOptionATranslate = nil
  self.textOptionBTranslate = nil
  self.selectBlueEffect = nil
  self.selectRedEffect = nil
  self.vsImage = nil
end

function M:DataDefine()
  self.curState = nil
  self.eggInfo = nil
end

function M:DataDestroy()
  self.curState = nil
  self.eggInfo = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggChatOnVoteUpdate, self.OnRecVote)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggChatOnVoteUpdate, self.OnRecVote)
end

function M:KillSequence()
  if self.sliderAnimSeq then
    for _, v in ipairs(self.sliderAnimSeq) do
      if v then
        v:Kill()
      end
    end
    self.sliderAnimSeq = nil
  end
end

function M:UpdateItem(eggInfo)
  if not eggInfo then
    Logger.LogError("eggInfo is nil")
    return
  end
  self:ResetTranslate()
  self:UpdateAnswer(eggInfo)
end

function M:OnBtnOptionASelectClick()
  DataCenter.ActEasterEggManager:RequestVote(self.eggInfo:GetId(), 1)
end

function M:OnBtnOptionBSelectClick()
  DataCenter.ActEasterEggManager:RequestVote(self.eggInfo:GetId(), 2)
end

function M:UpdateAnswer(eggInfo, playAni)
  self.eggInfo = eggInfo
  local answer = eggInfo:GetMyVoteRes()
  if not answer then
    Logger.LogError("answer is nil")
    return
  end
  if answer == 0 then
    self.curState = CurState.None
  elseif answer == 1 then
    self.curState = CurState.OptionA
  elseif answer == 2 then
    self.curState = CurState.OptionB
  end
  self:SetItemByState()
  self.textOptionA:SetText(eggInfo.optionA)
  self.textOptionB:SetText(eggInfo.optionB)
  local textBTransPreferHeight = self.textOptionA.unity_tmpro:GetPreferredValues().y
  self.textOptionA:SetSizeDeltaY(textBTransPreferHeight)
  local textATransPreferHeight = self.textOptionA.unity_tmpro:GetPreferredValues().y
  self.textOptionB:SetSizeDeltaY(textATransPreferHeight)
  self.textOptionAVoteNum:SetActive(self.curState ~= CurState.None)
  self.textOptionBVoteNum:SetActive(self.curState ~= CurState.None)
  self.textOptionAVoteNum:SetText(Localization:GetString("activity_99144_ui_58", eggInfo.answerANum))
  self.textOptionBVoteNum:SetText(Localization:GetString("activity_99144_ui_58", eggInfo.answerBNum))
  if answer ~= 0 then
    self.blueRate = eggInfo.answerANum / (eggInfo.answerANum + eggInfo.answerBNum)
    self.redRate = eggInfo.answerBNum / (eggInfo.answerANum + eggInfo.answerBNum)
    self.sliderBlue:SetValue(self.blueRate + 0.01)
    self.sliderRed:SetValue(self.redRate + 0.01)
    if playAni then
      self:PlayProgressEff()
    else
      self.textOptionARate:SetText(string.format("%.2f%%", self.blueRate * 100))
      self.textOptionBRate:SetText(string.format("%.2f%%", self.redRate * 100))
    end
    if self.curState == CurState.OptionA then
      CS.UIGray.SetGray(self.optionBImage.transform, true)
      CS.UIGray.SetGray(self.textOptionB.transform, true)
      CS.UIGray.SetGray(self.optionAImage.transform, false)
      CS.UIGray.SetGray(self.textOptionA.transform, false)
      self.vsImage:SetColor(BlueColor)
      self.imgABg:LoadSprite("Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterEggChat/lrb_FHJ_toupiao_lanfang_bg02.png")
      self.imgRedBg:SetActive(false)
      self.imgBlueBg:SetActive(true)
    elseif self.curState == CurState.OptionB then
      CS.UIGray.SetGray(self.optionBImage.transform, false)
      CS.UIGray.SetGray(self.textOptionB.transform, false)
      CS.UIGray.SetGray(self.optionAImage.transform, true)
      CS.UIGray.SetGray(self.textOptionA.transform, true)
      self.vsImage:SetColor(RedColor)
      self.imgBBg:LoadSprite("Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterEggChat/lrb_FHJ_toupiao_hongfang_bg02.png")
      self.imgBlueBg:SetActive(false)
      self.imgRedBg:SetActive(true)
    end
  else
    self.imgABg:LoadSprite("Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterEggChat/lrb_FHJ_toupiao_lanfang_bg01.png")
    self.imgBBg:LoadSprite("Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterEggChat/lrb_FHJ_toupiao_hongfang_bg01.png")
    self.imgBlueBg:SetActive(true)
    self.imgRedBg:SetActive(true)
  end
  self:SetPos()
end

function M:SetItemByState()
  if self.curState == CurState.None then
    self.compSilderNode:SetActive(false)
    self.btnOptionASelect:SetActive(true)
    self.btnOptionBSelect:SetActive(true)
  else
    self.compSilderNode:SetActive(true)
    self.btnOptionASelect:SetActive(false)
    self.btnOptionBSelect:SetActive(false)
  end
end

function M:OnRecVote()
  self:UpdateAnswer(self.eggInfo, true)
end

function M:PlayProgressEff()
  self.sliderAnimSeq = {}
  self.sliderBlue:SetValue(0)
  self.sliderRed:SetValue(0)
  local blueRate = self.blueRate
  local sTxtBlue = DOTween.To(function(x)
    self.textOptionARate:SetText(math.floor(x) .. "%")
  end, 0, self.blueRate * 100, 0.3333333333333333):OnComplete(function()
    self.textOptionARate:SetText(math.floor(self.blueRate * 100) .. "%")
  end)
  table.insert(self.sliderAnimSeq, sTxtBlue)
  local sBlue = DOTween.Sequence()
  sBlue:Append(self.sliderBlue:DOValue(blueRate * 0.28, 0.16666666666666666))
  sBlue:Append(self.sliderBlue:DOValue(blueRate * 0.85, 0.05))
  sBlue:Append(self.sliderBlue:DOValue(blueRate * 0.95, 0.05))
  sBlue:Append(self.sliderBlue:DOValue(blueRate, 0.06666666666666667))
  table.insert(self.sliderAnimSeq, sBlue)
  local redRate = self.redRate
  local sTxtRed = DOTween.To(function(x)
    self.textOptionBRate:SetText(math.floor(x) .. "%")
  end, 0, self.redRate * 100, 0.3333333333333333):OnComplete(function()
    self.textOptionBRate:SetText(math.floor(self.redRate * 100) .. "%")
  end)
  table.insert(self.sliderAnimSeq, sTxtRed)
  local sRed = DOTween.Sequence()
  sRed:Append(self.sliderRed:DOValue(redRate * 0.28, 0.16666666666666666))
  sRed:Append(self.sliderRed:DOValue(redRate * 0.85, 0.05))
  sRed:Append(self.sliderRed:DOValue(redRate * 0.95, 0.05))
  sRed:Append(self.sliderRed:DOValue(redRate, 0.06666666666666667))
  table.insert(self.sliderAnimSeq, sRed)
  local sequence = DOTween.Sequence()
  sequence:AppendInterval(0.11666666666666667)
  sequence:AppendCallback(function()
    self.simpleAni:Play("Default")
  end)
  self.isPlaying = true
  sequence:AppendInterval(1)
  sequence:AppendCallback(function()
    EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityVotAniOver)
  end)
  if self.curState == CurState.OptionA then
    self.selectBlueEffect.gameObject:SetActive(true)
    self.selectBlueEffect:Play()
  elseif self.curState == CurState.OptionB then
    self.selectRedEffect:Play()
    self.selectRedEffect.gameObject:SetActive(true)
  end
end

function M:GetOptionAHeight()
  local optionA = self.textOptionA.unity_tmpro:GetPreferredValues().y
  local optionATranslateHeight = 0
  if self.textOptionATranslate:GetActive() then
    optionATranslateHeight = self.textOptionATranslate.unity_tmpro:GetPreferredValues().y
  end
  return topBlankHeight + optionA + optionATranslateHeight + bottomBlankHeight
end

function M:GetOptionBHeight()
  local optionB = self.textOptionB.unity_tmpro:GetPreferredValues().y
  local optionBTranslateHeight = 0
  if self.textOptionBTranslate:GetActive() then
    optionBTranslateHeight = self.textOptionBTranslate.unity_tmpro:GetPreferredValues().y
  end
  return topBlankHeight + optionB + optionBTranslateHeight + bottomBlankHeight
end

function M:GetHeight()
  local y = self:GetSizeDelta().y
  return y
end

function M:SetTranslateText(ATranslate, BTranslate)
  self.textOptionATranslate:SetActive(true)
  self.textOptionATranslate:SetText(ATranslate)
  local textATransPreferHeight = self.textOptionATranslate.unity_tmpro:GetPreferredValues().y
  self.textOptionATranslate:SetSizeDeltaY(textATransPreferHeight)
  self.textOptionBTranslate:SetActive(true)
  self.textOptionBTranslate:SetText(BTranslate)
  local textBTransPreferHeight = self.textOptionBTranslate.unity_tmpro:GetPreferredValues().y
  self.textOptionBTranslate:SetSizeDeltaY(textBTransPreferHeight)
  self:SetPos()
end

function M:ResetTranslate()
  self.textOptionATranslate:SetActive(false)
  self.textOptionBTranslate:SetActive(false)
end

function M:SetPos()
  local translateHeight = 0
  if self.textOptionATranslate:GetActive() then
    local posY = self.textOptionA:GetAnchoredPosition().y - self.textOptionA.unity_tmpro:GetPreferredValues().y - 20
    self.textOptionATranslate:SetAnchoredPositionXY(self.textOptionATranslate:GetAnchoredPosition().x, posY)
    translateHeight = self.textOptionATranslate.unity_tmpro:GetPreferredValues().y
  end
  local optionA = self.textOptionA.unity_tmpro:GetPreferredValues().y
  local optionAHeight = topBlankHeight + 28 + optionA + translateHeight + 139 + 32
  if self.textOptionBTranslate:GetActive() then
    local posY = self.textOptionB:GetAnchoredPosition().y - self.textOptionB.unity_tmpro:GetPreferredValues().y - 20
    self.textOptionBTranslate:SetAnchoredPositionXY(self.textOptionBTranslate:GetAnchoredPosition().x, posY)
    translateHeight = self.textOptionBTranslate.unity_tmpro:GetPreferredValues().y
  end
  local optionB = self.textOptionB.unity_tmpro:GetPreferredValues().y
  local optionBHeight = topBlankHeight + 28 + optionB + translateHeight + 139 + 32
  local width = self:GetSizeDelta().x
  local height = Mathf.Max(optionAHeight, optionBHeight)
  self:SetSizeDeltaXY(width, height)
end

return M
