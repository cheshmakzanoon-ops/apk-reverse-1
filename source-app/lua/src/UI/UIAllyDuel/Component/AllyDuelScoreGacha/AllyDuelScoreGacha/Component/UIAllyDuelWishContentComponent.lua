local base = UIBaseContainer
local UIAllyDuelWishContentComponent = BaseClass("UIAllyDuelWishContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAllyDuelWishContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllyDuelWishContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelWishContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.anim = self.viewSkin:AddComponent(self, UIAnimator, 1)
  self.imgWish = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgWishProgressBase = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgWishProgress = self.viewSkin:AddComponent(self, UIImage, 4)
  self.compRedWish = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textRedWish = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textWithProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgWishDecoration = self.viewSkin:AddComponent(self, UIImage, 8)
  self.btnWishDecorationImage = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnWishDecorationImage:SetOnClick(function()
    self:OnBtnWishDecorationImageClick()
  end)
  self.compEffectRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compTips = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnTipsBlock = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnTipsBlock:SetOnClick(function()
    self:OnBtnTipsBlockClick()
  end)
  self.compTips:SetActive(false)
end

function UIAllyDuelWishContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.anim = nil
  self.imgWish = nil
  self.imgWishProgressBase = nil
  self.imgWishProgress = nil
  self.compRedWish = nil
  self.textRedWish = nil
  self.textWithProgress = nil
  self.imgWishDecoration = nil
  self.btnWishDecorationImage = nil
  self.compEffectRoot = nil
  self.compTips = nil
  self.textTip = nil
  self.btnTipsBlock = nil
end

function UIAllyDuelWishContentComponent:DataDefine()
end

function UIAllyDuelWishContentComponent:DataDestroy()
end

function UIAllyDuelWishContentComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllyDuelScoreGachaShowGachaAnim, self.OnShowGachaAnim)
end

function UIAllyDuelWishContentComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.AllyDuelScoreGachaShowGachaAnim, self.OnShowGachaAnim)
  base.OnRemoveListener(self)
end

function UIAllyDuelWishContentComponent:ReInit(configId)
  self.configId = configId
  if self.configId == nil then
    return
  end
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData == nil then
    return
  end
  local animName
  local curSelectWishData = configData:GetCurSelectWishData()
  local isSelected = curSelectWishData ~= nil
  self.imgWish:SetActive(isSelected)
  self.imgWishDecoration:SetActive(isSelected)
  if curSelectWishData then
    local itemDataTemplate = DataCenter.AllyDuelScoreGachaManager:GetItemDataByItemId(self.configId, curSelectWishData.itemId)
    if itemDataTemplate ~= nil then
      self.imgWishDecoration:LoadSpriteAuto(itemDataTemplate:GetDecorationImage())
      self.imgWish:LoadSpriteAuto(itemDataTemplate:GetWishBaseImagePath())
    end
  end
  local curScore = configData:GetCurWishScore()
  local maxScore = configData:GetPity()
  if maxScore ~= 0 then
    self.imgWishProgress:SetFillAmount(0.19 * math.min(curScore / maxScore, 1))
  end
  self.textWithProgress:SetText(tostring(curScore) .. "/" .. tostring(maxScore))
  self.compRedWish:SetActive(curScore >= maxScore)
  if maxScore ~= 0 and curScore >= maxScore then
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

function UIAllyDuelWishContentComponent:OnBtnClaimClick()
  if self.configId == nil then
    return
  end
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData == nil then
    return
  end
  if configData:CanClaimWish() then
    DataCenter.AllyDuelScoreGachaManager:SendClaimWishMessage(self.configId)
  end
end

function UIAllyDuelWishContentComponent:AddHighLight()
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

function UIAllyDuelWishContentComponent:RemoveHighLight()
  if self.effectRequest ~= nil then
    self:GameObjectDestroy(self.effectRequest)
    self.effectRequest = nil
  end
end

function UIAllyDuelWishContentComponent:OnBtnWishDecorationImageClick()
  if self.configId == nil then
    return
  end
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData == nil then
    return
  end
  local curSelectWishData = configData:GetCurSelectWishData()
  if curSelectWishData == nil then
    return
  end
  if configData:CanClaimWish() then
    self:OnBtnClaimClick()
    return
  end
  local itemTemplate = DataCenter.AllyDuelScoreGachaManager:GetItemDataByItemId(self.configId, curSelectWishData.itemId)
  if itemTemplate and itemTemplate.itemTemplate then
    if LocalController:instance():hasLine(TableName.Firework, itemTemplate.itemTemplate.id) then
      local fireworkTemplate = LocalController:instance():getLine(TableName.Firework, itemTemplate.itemTemplate.id)
      if fireworkTemplate then
        local width = self.holder.rawImgRT.rectTransform.rect.width
        local height = self.holder.rawImgRT.rectTransform.rect.height
        self.holder:RefreshRT(itemTemplate.itemTemplate.id, toInt(width), toInt(height))
      end
    end
    self.textTip:SetLocalText(itemTemplate.itemTemplate.description)
  end
  self.compTips:SetActive(true)
  self.btnTipsBlock:SetActive(true)
end

function UIAllyDuelWishContentComponent:OnBtnTipsBlockClick()
  self.compTips:SetActive(false)
  self.btnTipsBlock:SetActive(false)
end

function UIAllyDuelWishContentComponent:OnShowGachaAnim(evtData)
  local configId = evtData.configId
  if self.configId ~= configId then
    return
  end
  self:ReInit(configId)
end

return UIAllyDuelWishContentComponent
