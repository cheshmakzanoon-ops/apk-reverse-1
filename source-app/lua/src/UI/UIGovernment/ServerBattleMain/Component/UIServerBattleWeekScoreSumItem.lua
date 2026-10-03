local UIServerBattleWeekScoreSumItem = BaseClass("UIServerBattleWeekScoreSumItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local IconImg_path = "SumIcon"
local slider1_path = "slider1"
local slider2_path = "slider2"
local text1_path = "score1txt"
local text2_path = "score2txt"

function UIServerBattleWeekScoreSumItem:OnCreate()
  base.OnCreate(self)
  self.IconImg = self:AddComponent(UIImage, IconImg_path)
  self.BtnIcon = self:AddComponent(UIButton, IconImg_path)
  self.BtnIcon:SetOnClick(function()
    if self.config and not string.IsNullOrEmpty(self.config.name) then
      UIUtil.ShowBubbleTips(Localization:GetString(self.config.name), self.IconImg.transform.position, 0, -42, 0)
    end
  end)
  self.Slider1 = self:AddComponent(UISlider, slider1_path)
  self.Slider2 = self:AddComponent(UISlider, slider2_path)
  self.TextValue1 = self:AddComponent(UIText, text1_path)
  self.TextValue2 = self:AddComponent(UIText, text2_path)
end

function UIServerBattleWeekScoreSumItem:OnDestroy()
  base.OnDestroy(self)
  self:ClearTween()
end

function UIServerBattleWeekScoreSumItem:OnDisable()
  base.OnDisable(self)
end

function UIServerBattleWeekScoreSumItem:ReInit(index, data, config, maxScore, playAnim)
  self.config = config
  local scoreA = 0
  local scoreB = 0
  if data.vs then
    scoreA = data.vs[1] and data.vs[1].score or 0
    scoreB = data.vs[2] and data.vs[2].score or 0
  end
  maxScore = math.max(scoreA, scoreB)
  self.TextValue1:SetText(string.GetFormattedStr2(scoreA))
  self.TextValue2:SetText(string.GetFormattedStr2(scoreB))
  self.IconImg:LoadSprite(config.icon)
  self.IconImg:SetNativeSize()
  self.Slider1:SetValue(scoreA / maxScore)
  self.Slider2:SetValue(scoreB / maxScore)
end

function UIServerBattleWeekScoreSumItem:UITweenSlider(slider, from, to, time)
  local sliderValue = from
  slider:SetValue(from)
  self:ClearTween()
  self.seq = DOTween.Sequence()
  self.seq:AppendInterval(time)
  local tween = DOTween.To(function()
    return sliderValue
  end, function(value)
    sliderValue = value
    slider:SetValue(value)
  end, to, 0.3 + 0.3 * time)
  tween:SetEase(CS.DG.Tweening.Ease.OutBack)
  self.seq:Append(tween)
end

function UIServerBattleWeekScoreSumItem:ClearTween()
  if self.tweener then
    self.tweener:Kill()
    self.tweener = nil
  end
end

return UIServerBattleWeekScoreSumItem
