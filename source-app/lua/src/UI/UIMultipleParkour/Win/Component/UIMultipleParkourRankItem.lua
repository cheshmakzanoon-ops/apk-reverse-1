local UIMultipleParkourRankItem = BaseClass("UIMultipleParkourRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIMultipleParkourRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMultipleParkourRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourRankItem:ComponentDefine()
  self.player_img = self:AddComponent(UIPlayerHead, "UIPlayerHead/HeadIcon")
  self.playerHeadFg = self:AddComponent(UIImage, "UIPlayerHead/Foreground")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "HeroName")
  self.score = self:AddComponent(UITextMeshProUGUIEx, "Score")
  self.fullTxt = self:AddComponent(UITextMeshProUGUIEx, "FullTxt")
  self.fullTxt:SetText(Localization:GetString("dev_multiple_stage_18"))
  self.barBg = self:AddComponent(UIBaseContainer, "ProgressBar")
  self.barInner = self:AddComponent(UIBaseContainer, "ProgressBar/Inner")
  self.deathState = self:AddComponent(UIBaseContainer, "deathState")
end

function UIMultipleParkourRankItem:ComponentDestroy()
  self.player_img = nil
  self.playerHeadFg = nil
  self.name = nil
  self.score = nil
  self.fullTxt = nil
  self.barBg = nil
  self.barInner = nil
  self.deathState = nil
end

function UIMultipleParkourRankItem:Refresh(data, topScore)
  self.player_img:SetData(data.playerId, data.pic, data.picver)
  if not string.IsNullOrEmpty(data.headSkinId) then
    self.playerHeadFg:SetActive(true)
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId)
    self.playerHeadFg:LoadSprite(headBgImg)
  else
    self.playerHeadFg:SetActive(false)
  end
  self.name:SetText(data.name or "")
  self.score:SetText(0)
  self.fullTxt:SetActive(topScore <= data.score)
  if 0 < topScore then
    local barSize = self.barBg:GetSizeDelta()
    self.barInner:SetSizeDelta(Vector2(0, barSize.y))
    self.progress = 0
    local percent = data.score / topScore
    self.tween = CS.DG.Tweening.DOTween.To(function()
      return self.progress
    end, function(p)
      self.progress = p
      local pValue = data.score * p
      self.score:SetText(string.GetFormattedStr(pValue))
      self.barInner:SetSizeDelta(Vector2(p * percent * barSize.x, barSize.y))
    end, 1, percent * 1):SetEase(CS.DG.Tweening.Ease.OutCubic)
  end
  self.deathState:SetActive(0 >= data.score)
end

return UIMultipleParkourRankItem
