local UIMainCrossServerBubbleTips = BaseClass("UIMainCrossServerBubbleTips", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bubble_text_path = "BubbleText"

function UIMainCrossServerBubbleTips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainCrossServerBubbleTips:OnDestroy()
  self:RemoveSequence()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainCrossServerBubbleTips:OnEnable()
  base.OnEnable(self)
end

function UIMainCrossServerBubbleTips:OnDisable()
  base.OnDisable(self)
end

function UIMainCrossServerBubbleTips:ComponentDefine()
  self.root = self:AddComponent(UICanvasGroup, "")
  self.bubble_text = self:AddComponent(UITextMeshProUGUIEx, bubble_text_path)
  self.root:SetAlpha(0)
end

function UIMainCrossServerBubbleTips:ComponentDestroy()
  self.root = nil
  self.bubble_text = nil
end

function UIMainCrossServerBubbleTips:DataDefine()
  self.tipsTimeInterval = LuaEntry.DataConfig:TryGetNum("crossserver_tip_time", "k1")
  self.tweenSequence = nil
  self.isShow = false
end

function UIMainCrossServerBubbleTips:DataDestroy()
  self.tipsTimeInterval = nil
  self.tweenSequence = nil
  self.isShow = nil
end

function UIMainCrossServerBubbleTips:ShowBubbleTips(languageId)
  if self.isShow then
    self.root:SetAlpha(0)
    self.root:SetActive(false)
  end
  self:RemoveSequence()
  self.isShow = true
  self.root:SetActive(true)
  self.bubble_text:SetLocalText(languageId)
  self.tweenSequence = CS.DG.Tweening.DOTween.Sequence()
  self.tweenSequence:Append(self.root:FadeIn(0.3))
  self.tweenSequence:AppendInterval(self.tipsTimeInterval)
  self.tweenSequence:Append(self.root:FadeOut(0.3))
  self.tweenSequence:AppendCallback(function()
    if self.root then
      self.root:SetActive(false)
      self.isShow = false
    end
  end)
end

function UIMainCrossServerBubbleTips:RemoveSequence()
  if self.tweenSequence then
    self.tweenSequence:Kill()
    self.tweenSequence = nil
  end
end

function UIMainCrossServerBubbleTips:ImmediatelyStop()
  self:RemoveSequence()
  if self.root then
    self.root:SetActive(false)
    self.isShow = false
  end
end

return UIMainCrossServerBubbleTips
