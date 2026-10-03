local UIMultipleParkourLoseResult = BaseClass("UIMultipleParkourLoseResult", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local tip_Path = "tip"
local elimination_title_path = "eliminationContent/eliminationTitle"
local elimination_path = "eliminationContent/elimination"
local full_title_path = "fullContent/fullTitle"
local full_path = "fullContent/full"
local content_path = "rewardList/Viewport/Content"

function UIMultipleParkourLoseResult:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

function UIMultipleParkourLoseResult:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourLoseResult:ComponentDefine()
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.tip = self:AddComponent(UITextMeshProUGUIEx, tip_Path)
  self.elimination_title = self:AddComponent(UITextMeshProUGUIEx, elimination_title_path)
  self.elimination = self:AddComponent(UITextMeshProUGUIEx, elimination_path)
  self.full_title = self:AddComponent(UITextMeshProUGUIEx, full_title_path)
  self.full = self:AddComponent(UITextMeshProUGUIEx, full_path)
  self.tip:SetText(Localization:GetString("dev_multiple_stage_17"))
  self.elimination_title:SetText(Localization:GetString("dev_multiple_stage_15"))
  self.full_title:SetText(Localization:GetString("dev_multiple_stage_16"))
  self.rewardContent = self:AddComponent(UIBaseContainer, content_path)
end

function UIMultipleParkourLoseResult:ComponentDestroy()
  self:DestroyAllReward()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.tip = nil
  self.elimination_title = nil
  self.elimination = nil
  self.full_title = nil
  self.full = nil
  self.rewardContent = nil
end

function UIMultipleParkourLoseResult:FadeIn()
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

function UIMultipleParkourLoseResult:RefreshView()
  local myScore, elimination, full = DataCenter.MultipleParkourManager:GetResultShowData()
  self.elimination:SetText(elimination)
  self.full:SetText(full)
  self:RefreshReward()
end

function UIMultipleParkourLoseResult:DestroyAllReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for _, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIMultipleParkourLoseResult:RefreshReward()
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

return UIMultipleParkourLoseResult
