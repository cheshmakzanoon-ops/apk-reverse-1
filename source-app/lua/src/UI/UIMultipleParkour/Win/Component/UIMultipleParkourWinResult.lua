local UIMultipleParkourWinResult = BaseClass("UIMultipleParkourWinResult", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local score_title_path = "scoreContent/scoreTitle"
local score_path = "scoreContent/score"
local elimination_title_path = "eliminationContent/eliminationTitle"
local elimination_path = "eliminationContent/elimination"
local full_title_path = "fullContent/fullTitle"
local full_path = "fullContent/full"
local content_path = "rewardList/Viewport/Content"

function UIMultipleParkourWinResult:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

function UIMultipleParkourWinResult:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourWinResult:ComponentDefine()
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.score_title = self:AddComponent(UITextMeshProUGUIEx, score_title_path)
  self.score = self:AddComponent(UITextMeshProUGUIEx, score_path)
  self.elimination_title = self:AddComponent(UITextMeshProUGUIEx, elimination_title_path)
  self.elimination = self:AddComponent(UITextMeshProUGUIEx, elimination_path)
  self.full_title = self:AddComponent(UITextMeshProUGUIEx, full_title_path)
  self.full = self:AddComponent(UITextMeshProUGUIEx, full_path)
  self.score_title:SetText(Localization:GetString("dev_multiple_stage_14"))
  self.elimination_title:SetText(Localization:GetString("dev_multiple_stage_15"))
  self.full_title:SetText(Localization:GetString("dev_multiple_stage_16"))
  self.rewardContent = self:AddComponent(UIBaseContainer, content_path)
end

function UIMultipleParkourWinResult:ComponentDestroy()
  self:DestroyAllReward()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.score_title = nil
  self.score = nil
  self.elimination_title = nil
  self.elimination = nil
  self.full_title = nil
  self.full = nil
  self.rewardContent = nil
end

function UIMultipleParkourWinResult:FadeIn()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.canvasGroup.alpha = 0
  self.fadeTween = CS.DG.Tweening.DOTween.To(function()
    return self.canvasGroup.alpha
  end, function(value)
    self.canvasGroup.alpha = value
  end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIMultipleParkourWinResult:RefreshView()
  local myScore, elimination, full = DataCenter.MultipleParkourManager:GetResultShowData()
  self.score:SetText(myScore)
  self.elimination:SetText(elimination)
  self.full:SetText(full)
  self:RefreshReward()
end

function UIMultipleParkourWinResult:DestroyAllReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for _, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIMultipleParkourWinResult:RefreshReward()
  self:DestroyAllReward()
  local reward = DataCenter.MultipleParkourManager.reward
  if reward == nil then
    return
  end
  local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
  self.model = {}
  if rewards ~= nil then
    local length = table.length(rewards)
    for i = 1, length do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "item" .. i
        local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(rewards[i])
      end)
    end
  end
end

return UIMultipleParkourWinResult
