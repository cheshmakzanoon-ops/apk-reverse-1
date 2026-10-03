local base = UIBaseView
local HeroAwakenUpgradeStarEffectView = BaseClass("HeroAwakenUpgradeStarEffectView", base)
local HeroAwakenUpgradeSkillItem = require("UI/UILWHero/UIHeroDetailPanel/Component/HeroAwaken/HeroAwakenUpgradeSkillItem")

function HeroAwakenUpgradeStarEffectView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function HeroAwakenUpgradeStarEffectView:OnDestroy()
  if self.sequence ~= nil then
    self.sequence:Kill()
    self.sequence = nil
  end
  if self.closeCallback then
    self.closeCallback()
  end
  if self.soundId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function HeroAwakenUpgradeStarEffectView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTittleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compEffUiHeroawakenStarFull5 = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compEffUiHeroawakenStarFull4 = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compEffUiHeroawakenStarFull3 = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compEffUiHeroawakenStarFull2 = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compEffUiHeroawakenStarFull1 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compEffUiHeroawakenStarFullRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compHeroSpineContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textSkill = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compHeroAwakenUpgradeSkillItem = self.viewSkin:AddComponent(self, HeroAwakenUpgradeSkillItem, 11)
  self.textEffect = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.animatorHeroAwakenUpgradeStarEffect = self.viewSkin:AddComponent(self, UIAnimator, 13)
  self.compStarUnlockPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.imgStarEmptyIcon05 = self.viewSkin:AddComponent(self, UIImage, 15)
  self.imgStarEmptyIcon02 = self.viewSkin:AddComponent(self, UIImage, 16)
  self.imgStarEmptyIcon04 = self.viewSkin:AddComponent(self, UIImage, 17)
  self.imgStarEmptyIcon03 = self.viewSkin:AddComponent(self, UIImage, 18)
  self.imgStarEmptyIcon01 = self.viewSkin:AddComponent(self, UIImage, 19)
  self.compEffUiHeroawakenStarFullList = {
    self.compEffUiHeroawakenStarFull1,
    self.compEffUiHeroawakenStarFull2,
    self.compEffUiHeroawakenStarFull3,
    self.compEffUiHeroawakenStarFull4,
    self.compEffUiHeroawakenStarFull5
  }
  self.imgStarEmptyList = {
    self.imgStarEmptyIcon01,
    self.imgStarEmptyIcon02,
    self.imgStarEmptyIcon03,
    self.imgStarEmptyIcon04,
    self.imgStarEmptyIcon05
  }
end

function HeroAwakenUpgradeStarEffectView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTittleTxt = nil
  self.compEffUiHeroawakenStarFull5 = nil
  self.compEffUiHeroawakenStarFull4 = nil
  self.compEffUiHeroawakenStarFull3 = nil
  self.compEffUiHeroawakenStarFull2 = nil
  self.compEffUiHeroawakenStarFull1 = nil
  self.compEffUiHeroawakenStarFullRoot = nil
  self.compHeroSpineContainer = nil
  self.textSkill = nil
  self.compHeroAwakenUpgradeSkillItem = nil
  self.textEffect = nil
  self.animatorHeroAwakenUpgradeStarEffect = nil
  self.compStarUnlockPanel = nil
  self.imgStarEmptyIcon05 = nil
  self.imgStarEmptyIcon02 = nil
  self.imgStarEmptyIcon04 = nil
  self.imgStarEmptyIcon03 = nil
  self.imgStarEmptyIcon01 = nil
  self.imgStarEmptyList = nil
  self.compEffUiHeroawakenStarFullList = nil
end

function HeroAwakenUpgradeStarEffectView:DataDefine()
  self.clickSkillCallBack = BindCallback(self, self.OnClickSkillItem)
  self.heroData = nil
  self.rankLv = 0
  self.closeCallback = nil
  self.heroSpineReq = nil
  self.soundId = nil
end

function HeroAwakenUpgradeStarEffectView:DataDestroy()
  self.clickSkillCallBack = nil
  self.heroData = nil
  self.rankLv = nil
  self.closeCallback = nil
  self.heroSpineReq = nil
end

function HeroAwakenUpgradeStarEffectView:OnOpen()
  if self.sequence ~= nil then
    self.sequence:Kill()
    self.sequence = nil
  end
  local rankLv, heroData, closeCallback = self:GetUserData()
  self.rankLv = rankLv or 0
  self.heroData = heroData
  self.closeCallback = closeCallback
  local starCount = rankLv // 5
  local isUnlock = self.rankLv == 1
  local awakenTemplate = self.heroData:GetHeroAwakenTemplate()
  local skillData = self.heroData:GetHeroSkillBySlotIndex(HeroUtils.HeroAwakenReplaceSkillSlotIndex)
  for i, v in ipairs(self.imgStarEmptyList) do
    local isShowRedStar = not isUnlock and i < starCount
    if isShowRedStar then
      v:LoadSpriteAsync(HeroUtils.HeroAwakenBigRankStarImageAssetPathRed)
    else
      v:LoadSpriteAsync(HeroUtils.HeroAwakenBigRankStarImageAssetPathYellow)
    end
  end
  if isUnlock then
    self.textTittleTxt:SetLocalText("hero_awaken_limit_24")
    self.textSkill:SetLocalText("hero_awaken_limit_12")
    self.textEffect:SetLocalText(awakenTemplate.skill_short_desc)
  else
    self.textTittleTxt:SetLocalText("hero_awaken_limit_11")
    self.textSkill:SetLocalText("hero_awaken_limit_13")
    local effectDesc = skillData:GetEffectsDesc()
    for k, v in ipairs(effectDesc) do
      if v.unlockStar == starCount then
        self.textEffect:SetText(v.outDesc)
        break
      end
    end
  end
  if not isUnlock and 0 < starCount then
    local centerX, centerY, centerZ = self.compEffUiHeroawakenStarFull3.transform:Get_localPosition()
    self.compEffUiHeroawakenStarFullRoot.transform:Set_localPosition(centerX, centerY, centerZ)
    local targetPosX = 0
    local target = self.compEffUiHeroawakenStarFullList[starCount]
    if target then
      local x, _, _ = target.transform:Get_localPosition()
      targetPosX = x
    end
    local reqVfx = self:GameObjectInstantiateAsync(VfxAssets.HeroAwakenStarFull)
    reqVfx:completed("+", function(req)
      if req.isError then
        return
      end
      local pageObj = req.gameObject
      local transform = pageObj.transform
      transform:SetParent(self.compEffUiHeroawakenStarFullRoot.transform)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 0, 0)
      self.sequence = CS.DG.Tweening.DOTween.Sequence()
      self.sequence:AppendInterval(1)
      local moveTween = transform:DOLocalMoveX(targetPosX, 0.1):SetEase(CS.DG.Tweening.Ease.Linear)
      self.sequence:Append(moveTween)
    end)
  end
  self:LoadHeroSpine()
  self.compHeroAwakenUpgradeSkillItem:SetData(skillData, {
    showSkillName = false,
    showSkillLevel = false,
    showLock = false,
    showRedPoint = false,
    showStar = true,
    showNewTag = true
  }, self.clickSkillCallBack, false)
  if isUnlock then
    self.animatorHeroAwakenUpgradeStarEffect:Play("HeroAwakenUpgradeStarEffect_firstshow")
    self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Hero_Awaken_Upgrade_Star_Effect, false)
  else
    self.animatorHeroAwakenUpgradeStarEffect:Play("HeroAwakenUpgradeStarEffect_movein")
    self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Hero_Awaken_Upgrade_Full_Star, false)
  end
end

function HeroAwakenUpgradeStarEffectView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function HeroAwakenUpgradeStarEffectView:LoadHeroSpine()
  if self.heroSpineReq ~= nil then
    return
  end
  if self.heroData == nil then
    return
  end
  local spinePath = HeroUtils.GetHeroSpinePath(self.heroData.modelId, self.heroData:GetSkinId(), HeroSpineType.Normal)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  self.heroSpineReq = self:GameObjectInstantiateAsync(spinePath, function(request)
    if request.isError then
      return
    end
    if not self.compHeroSpineContainer then
      return
    end
    request.gameObject:SetActive(true)
    local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      rectTransform:SetParent(self.compHeroSpineContainer.transform)
      rectTransform:Set_localScale(1, 1, 1)
      rectTransform:Set_anchoredPosition(0, 0, 0)
    end
  end)
end

function HeroAwakenUpgradeStarEffectView:OnClickSkillItem(skillData, skillItem)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillDetailPanel, {anim = true}, skillData, skillItem)
end

return HeroAwakenUpgradeStarEffectView
