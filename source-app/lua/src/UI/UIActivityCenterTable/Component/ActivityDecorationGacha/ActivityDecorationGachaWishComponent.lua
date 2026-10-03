local base = UIBaseContainer
local ActivityDecorationUpgradeWishComponent = BaseClass("ActivityDecorationUpgradeWishComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationUpgradeWishComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationUpgradeWishComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationUpgradeWishComponent:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "")
  self.imgWish = self:AddComponent(UIImage, "WishImage")
  self.compAddImage = self:AddComponent(UIBaseContainer, "AddImage")
  self.btnAddImage = self:AddComponent(UIButton, "AddImage")
  self.btnAddImage:SetOnClick(function()
    self:OnBtnAddImageClick()
  end)
  self.imgWishProgressBg = self:AddComponent(UIImage, "WishProgressBaseImage")
  self.imgWishProgress = self:AddComponent(UIImage, "WishProgressImage")
  self.compRedWish = self:AddComponent(UIBaseContainer, "RedWish")
  self.textRedWish = self:AddComponent(UIText, "RedWish/RedWishText")
  self.btnWishChange = self:AddComponent(UIButton, "WishChangeBtn")
  self.btnWishChange:SetOnClick(function()
    self:OnBtnWishChangeClick()
  end)
  self.textWithProgress = self:AddComponent(UIText, "WithProgressText")
  self.imgWishDecoration = self:AddComponent(UIImage, "WishDecorationImage")
  self.btnWishDecoration = self:AddComponent(UIButton, "WishDecorationImage")
  self.btnWishDecoration:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.compEffectRoot = self:AddComponent(UIBaseContainer, "EffectRoot")
  self.compEffectAdd = self:AddComponent(UIBaseContainer, "AddImage/Eff_ui_s_UIDecorationGachaMain_AddImage_glow")
  self.btnWish = self:AddComponent(UIButton, "WishBtn")
  self.btnWish:SetOnClick(function()
    self:OnBtnWishClick()
  end)
end

function ActivityDecorationUpgradeWishComponent:ComponentDestroy()
  self:RemoveHighLight()
  self.imgWish = nil
  self.compAddImage = nil
  self.btnAddImage = nil
  self.imgWishProgress = nil
  self.compRedWish = nil
  self.btnWishChange = nil
  self.textWithProgress = nil
  self.imgWishDecoration = nil
  self.btnWishDecoration = nil
  self.compEffectRoot = nil
  self.imgWishProgressBg = nil
  self.anim = nil
  self.btnWish = nil
end

function ActivityDecorationUpgradeWishComponent:AddHighLight()
  if self.effectRequest ~= nil then
    return
  end
  self.effectRequest = self:GameObjectInstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/UI/UIDecorationGachaMain/Eff_ui_s_UIDecorationGachaMain_dajiang_huxi.prefab", function(request)
    if request.isError or self.compEffectRoot == nil then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compEffectRoot.transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.name = "effect"
  end)
end

function ActivityDecorationUpgradeWishComponent:RemoveHighLight()
  if self.effectRequest ~= nil then
    self:GameObjectDestroy(self.effectRequest)
    self.effectRequest = nil
  end
end

function ActivityDecorationUpgradeWishComponent:DataDefine()
end

function ActivityDecorationUpgradeWishComponent:DataDestroy()
end

function ActivityDecorationUpgradeWishComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationUpgradeWishComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationUpgradeWishComponent:ReInit(activityId)
  self.activityId = activityId
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local animName
  local curSelectWishData = activityData:GetCurSelectWishData()
  local isSelected = curSelectWishData ~= nil
  self.compAddImage:SetActive(not isSelected)
  self.compEffectAdd:SetActive(not isSelected)
  self.imgWish:SetActive(isSelected)
  self.imgWishDecoration:SetActive(isSelected)
  self.btnWishChange:SetActive(isSelected)
  if isSelected then
    local itemDataTemplate = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(self.activityId, curSelectWishData.itemId)
    if itemDataTemplate ~= nil then
      self.imgWishDecoration:LoadSpriteAuto(itemDataTemplate:GetDecorationImage())
      self.imgWish:LoadSprite(itemDataTemplate:GetWishBaseImagePath())
    end
  else
    animName = "Eff_anim_UI_UIDecorationGachaMain_WishContent_jiahao"
  end
  local curScore = activityData:GetCurWishScore()
  local maxScore = activityData:GetPity()
  if maxScore ~= 0 then
    self.imgWishProgress:SetFillAmount(0.19 * math.min(curScore / maxScore, 1))
  end
  self.textWithProgress:SetText(tostring(curScore) .. "/" .. tostring(maxScore))
  self.compRedWish:SetActive(curScore >= maxScore)
  if curScore >= maxScore then
    self.textRedWish:SetText(tostring(math.floor(curScore / maxScore)))
    self:AddHighLight()
    if animName == nil then
      animName = "Eff_Con_UI_UIDecorationGachaMain_WishContent_jiangping"
    end
  else
    self:RemoveHighLight()
  end
  if animName ~= nil then
    self.anim:Play(animName)
  else
    self.anim:Play("kong")
  end
end

function ActivityDecorationUpgradeWishComponent:OnBtnAddImageClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDecorationGachaWish, {anim = true}, {
    activityId = self.activityId
  })
end

function ActivityDecorationUpgradeWishComponent:OnBtnWishChangeClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDecorationGachaWish, {anim = true}, {
    activityId = self.activityId
  })
end

function ActivityDecorationUpgradeWishComponent:OnBtnClaimClick()
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  if activityData:CanClaimWish() then
    DataCenter.ActivityDecorationGachaManager:SendClaimWishMessage(self.activityId)
  end
end

function ActivityDecorationUpgradeWishComponent:OnBtnWishClick()
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  if activityData:CanClaimWish() then
    DataCenter.ActivityDecorationGachaManager:SendClaimWishMessage(self.activityId)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDecorationGachaWish, {anim = true}, {
    activityId = self.activityId
  })
end

return ActivityDecorationUpgradeWishComponent
