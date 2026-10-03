local UILWPlayerDetailStatus = BaseClass("UILWPlayerDetailStatus", UIBaseContainer)
local base = UIBaseContainer
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

function UILWPlayerDetailStatus:OnCreate()
  base.OnCreate(self)
  self.hasHeartCount = nil
  self.data = nil
  self:ComponentDefine()
end

function UILWPlayerDetailStatus:OnAddListener()
  base.OnAddListener(self)
end

function UILWPlayerDetailStatus:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWPlayerDetailStatus:ComponentDefine()
  self.charmText = self:AddComponent(UIText, "charm/charmText")
  self.charmCom = self:AddComponent(UIBaseContainer, "charm")
  self.pop_anim_root = self:AddComponent(UICanvasGroup, "like/icon/PopAnim")
  self.heart_effect = self:AddComponent(UIBaseContainer, "like/icon/ActiveAnim")
  self.eff_heart = self.heart_effect.transform:GetComponent(TypeParticleSystem)
  self.pop_anim_text = self:AddComponent(UITextMeshProUGUIEx, "like/icon/PopAnim/PopAnimText")
  self.theHeartPopAnim = self.pop_anim_root.gameObject
  self.heart = self:AddComponent(UIButton, "like/icon")
  self.heart_text = self:AddComponent(UITextMeshProUGUIEx, "like/text")
  self.heartLayOut = self:AddComponent(UIBaseContainer, "")
  self.likeLayOut = self:AddComponent(UIBaseContainer, "like")
  self.heart:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "avatar_mainui_info003"
    param.alignObject = self.heart
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.heart_text:SetText("")
  self.pop_anim_root:SetActive(false)
  self.heart_effect:SetActive(false)
  self.theHeartPopAnim:GameObjectCreatePool()
end

function UILWPlayerDetailStatus:InitLike(data, firstShow)
  if not data then
    Logger.LogWarning("InitLike called but data is nil")
    return
  end
  local isSamePlayer = false
  if self.data and self.data.uid and data.uid then
    isSamePlayer = self.data.uid == data.uid
  end
  if firstShow then
    local isBirthdayThumbsUp = data.birthdayThumbsUpCountDiff and data.birthdayThumbsUpPlayerList and data.birthdayThumbsUpCountDiff > 0 and table.count(data.birthdayThumbsUpPlayerList) ~= 0
    local isThumbsUp = data.thumbsUpCountDiff and data.ThumbsUpPlayerList and 0 < data.thumbsUpCountDiff and table.count(data.ThumbsUpPlayerList) ~= 0
    local hasFreeGift = data.freeFollowHint ~= nil and 0 < data.freeFollowHint.countDiff and table.count(data.freeFollowHint.playerList) ~= 0
    local hasPayGift = data.payFollowHint ~= nil and 0 < data.payFollowHint.countDiff and table.count(data.payFollowHint.playerList) ~= 0
    if data.isSelf then
      if isBirthdayThumbsUp then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBirthdayThumbsUpGlory, {anim = true}, data)
      elseif isThumbsUp or hasFreeGift or hasPayGift then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerThumbsUpGlory, {anim = true}, data)
      end
    end
  elseif isSamePlayer and self.hasHeartCount ~= nil and self.heart then
    local heartCount = toInt(data.thumbsUpCount)
    local addCount = heartCount - toInt(self.hasHeartCount)
    if 0 < addCount then
      self.heart_effect:SetActive(true)
      self.eff_heart:Play()
      local effectItem = self.theHeartPopAnim:GameObjectSpawn(self.heart.transform)
      local textTrans = effectItem.transform:Find("PopAnimText")
      local unity_canvas_group = effectItem.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
      local unity_text = textTrans.gameObject:GetComponent(typeof(CS.TextMeshProUGUIEx))
      if unity_text and unity_canvas_group then
        unity_text.text = "+" .. addCount
        effectItem.name = "Count" .. heartCount
        effectItem:SetActive(true)
        unity_canvas_group.alpha = 1
        unity_canvas_group:DOFade(0, 0.75)
        if self.sequence then
          self.sequence:Kill()
          self.sequence = nil
        end
        self.sequence = CS.DG.Tweening.DOTween.Sequence()
        self.sequence:Join(effectItem.transform:DOLocalMove(Vector3.New(0, 50, 0), 0.75):SetEase(CS.DG.Tweening.Ease.OutCirc))
        self.sequence:AppendCallback(function()
          effectItem:GameObjectRecycle()
          self.eff_heart:Stop()
          self.heart_effect:SetActive(false)
        end)
      else
        effectItem:GameObjectRecycle()
      end
    end
  end
  local tempUpCount = toInt(data.thumbsUpCount)
  if not isSamePlayer then
    self.hasHeartCount = tempUpCount
  elseif not self.hasHeartCount or tempUpCount > self.hasHeartCount then
    self.hasHeartCount = tempUpCount
  end
  self.data = data
  self.heart_text:SetText(string.GetFormattedSeparatorNum(self.hasHeartCount))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.likeLayOut.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.heartLayOut.rectTransform)
end

function UILWPlayerDetailStatus:ComponentDestroy()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.theHeartPopAnim:GameObjectRecycleAll()
  self.charmText = nil
  self.charmCom = nil
  self.pop_anim_root = nil
  self.heart_effect = nil
  self.eff_heart = nil
  self.pop_anim_text = nil
  self.theHeartPopAnim = nil
  self.heart = nil
  self.heart_text = nil
  self.heartLayOut = nil
end

function UILWPlayerDetailStatus:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  self.data = nil
  base.OnDestroy(self)
end

function UILWPlayerDetailStatus:DataDestroy()
  self.hasHeartCount = nil
end

return UILWPlayerDetailStatus
