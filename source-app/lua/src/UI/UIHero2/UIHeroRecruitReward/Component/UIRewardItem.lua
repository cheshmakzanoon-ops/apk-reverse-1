local UIRewardItem = BaseClass("UIRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIItemCell = require("UI.UIHero2.Common.UIItemCell")

local function OnCreate(self, lotteryId, index, data)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.lotteryId = lotteryId
  self.index = index
  self.data = data
  self.isPurpleHero = false
  self.isOrangeHero = false
  self.isMaster = false
  self.flipped = false
  self:SetTouchEnabled(false)
  self.flipSequence = nil
  self:ResetAllEffect()
  self:UpdateView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rootNode = self:AddComponent(UIBaseContainer, "Root")
  self.infoPanel = self:AddComponent(UIBaseContainer, "Root/InfoPanel")
  self.heroCell = self:AddComponent(UIHeroCellBig, "Root/InfoPanel/UIHeroCellBig")
  self.itemCell = self:AddComponent(UIItemCell, "Root/InfoPanel/UIItemCell")
  self.itemBg = self:AddComponent(UIImage, "Root/InfoPanel/UIItemCell/imgQuality")
  self.imgMask = self:AddComponent(UIImage, "Root/InfoPanel/UIItemCell/imgMask")
  self.btn = self:AddComponent(UIButton, "")
  self.imgCover = self:AddComponent(UIImage, "Root/CoverPanel")
  self.btnCover = self:AddComponent(UIButton, "Root/CoverPanel")
  self.nameTxt = self:AddComponent(UIText, "Root/InfoPanel/nameTxtMask/nameTxt")
  self.greenPersistEffect = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeEffectPersist/GreenPersistEffect")
  self.bluePersistEffect = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeEffectPersist/BluePersistEffect")
  self.purplePersistEffect = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeEffectPersist/PurplePersistEffect")
  self.purplePersistEffect1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/NodeEffectPersist1/PurplePersistEffect1")
  self.purplePersistEffect2 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeEffectPersist/PurplePersistEffect/PurpleFront/VFX_ui_kapai_violet_fanpai02_front01")
  self.purplePersistEffect3 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeEffectPersist/PurplePersistEffect/PurpleFront/VFX_ui_kapai_violet_fanpai02_front")
  self.orangePersistEffect = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeEffectPersist/GoldenPersistEffect/")
  self.orangePersistEffect1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/NodeEffectPersist1/GoldenPersistEffect1")
  self.orangePersistEffect2 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeEffectPersist/GoldenPersistEffect/GoldenFront/VFX_ui_kapai_golden_fanpai02_front01")
  self.orangePersistEffect3 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeEffectPersist/GoldenPersistEffect/GoldenFront/VFX_ui_kapai_golden_fanpai02_front")
  self.greenAppearEffect = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeAppear/GreenAppearEffect")
  self.blueAppearEffect = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeAppear/BlueAppearEffect")
  self.purpleAppearEffect = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeAppear/PurpleAppearEffect")
  self.purpleAppearEffect1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeAppear/PurpleAppearEffect/Vfx_ui_kaipai_violet_show_later01")
  self.purpleAppearEffect2 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeAppear/PurpleAppearEffect/Vfx_ui_kaipai_violet_show_later")
  self.orangeAppearEffect = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeAppear/GoldenAppearEffect")
  self.orangeAppearEffect1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeAppear/GoldenAppearEffect/Vfx_ui_kaipai_golden_show_later01")
  self.orangeAppearEffect2 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot/NodeAppear/GoldenAppearEffect/Vfx_ui_kaipai_golden_show_later")
  self.purpleChargeEffect = self:AddComponent(UIBaseContainer, "Root/CoverPanel/PurpleChargeEffect")
  self.purpleChargeEffect1 = self:AddComponent(UIBaseContainer, "Root/CoverPanel/PurpleChargeEffect/ChargeFront/VFX_ui_kapai_violet_xuli_front")
  self.purpleChargeEffect2 = self:AddComponent(UIBaseContainer, "Root/CoverPanel/PurpleChargeEffect/ChargeFront/VFX_ui_kapai_violet_xuli_front _zi_01")
  self.orangeChargeEffect = self:AddComponent(UIBaseContainer, "Root/CoverPanel/OrangeChargeEffect")
  self.orangeChargeEffect1 = self:AddComponent(UIBaseContainer, "Root/CoverPanel/OrangeChargeEffect/ChargeFront/VFX_ui_kapai_violet_xuli_front_chengse")
  self.orangeChargeEffect2 = self:AddComponent(UIBaseContainer, "Root/CoverPanel/OrangeChargeEffect/ChargeFront/VFX_ui_kapai_violet_xuli_front_chengse01")
  self.btnCover:SetOnClick(BindCallback(self, self.OnCoverClick))
  self.btn:SetOnClick(BindCallback(self, self.OnCellClick))
end

local function ComponentDestroy(self)
  self.heroCell = nil
  if self.flipSequence ~= nil then
    self.flipSequence:Pause()
    self.flipSequence:Kill()
    self.flipSequence = nil
  end
  if self.flipSequence1 then
    self.flipSequence1:Pause()
    self.flipSequence1:Kill()
    self.flipSequence1 = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.heroUuid = nil
end

local function UpdateView(self)
  local data = self.data
  local type = data.type
  self.rewardType = type
  if type == 2 then
    local id = data.GoodsId
    local num = data.addNumber
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    if itemTemplate and itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
      local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(toInt(itemTemplate.para2))
      if not string.IsNullOrEmpty(heroUuid) then
        local heroPieces = GetTableData(HeroUtils.GetHeroXmlName(), toInt(itemTemplate.para2), "hero_pieces")
        local vec = string.split(heroPieces, "|")
        if table.count(vec) == 2 and toInt(vec[2]) == num then
          type = 0
          data.uuid = heroUuid
        end
      end
    end
  end
  self.imgCover.transform.eulerAngles = Vector3.zero
  self.infoPanel.transform.eulerAngles = Vector3.New(0, 90, 0)
  self.imgCover:SetActive(true)
  self.infoPanel:SetActive(true)
  self.heroCell:SetActive(false)
  self.itemCell:SetActive(false)
  if type == 0 then
    local heroUuid = data.uuid
    self.heroCell:SetData(heroUuid)
    self.heroCell:DisableRedPoint()
    self.heroCell:SetActive(true)
    self.heroUuid = heroUuid
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    self.quality = heroData.quality
    self.isPurpleHero = heroData.quality == HeroQualityType.Genius
    self.isOrangeHero = heroData.quality == HeroQualityType.Legendary
    self.isMaster = heroData.isMaster
    local colorStr = "green"
    if heroData.quality == HeroQualityType.Normal then
      colorStr = "white"
    elseif heroData.quality == HeroQualityType.Excellent then
      colorStr = "green"
    elseif heroData.quality == HeroQualityType.Outstanding then
      colorStr = "blue"
    elseif heroData.quality == HeroQualityType.Genius then
      colorStr = "purple"
    elseif heroData.quality == HeroQualityType.Legendary then
      colorStr = "orange"
    end
    self.imgCover:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/ui_recruit_cover_%s.png", colorStr))
    self.nameTxt:SetText(heroData:GetName())
  elseif type == 2 then
    local id = data.GoodsId
    local num = data.addNumber
    self.itemCell:SetData(RewardType.GOODS, id, num)
    self.itemCell:SetActive(true)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    local color = itemTemplate.color
    local colorStr = ""
    if color == ItemColor.WHITE then
      colorStr = "white"
    elseif color == ItemColor.GREEN then
      colorStr = "green"
    elseif color == ItemColor.BLUE then
      colorStr = "blue"
    elseif color == ItemColor.PURPLE then
      colorStr = "purple"
    elseif color == ItemColor.ORANGE then
      colorStr = "orange"
    end
    self.imgCover:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/ui_recruit_cover_%s.png", colorStr))
    self.itemBg:LoadSpriteAuto(HeroUtils.GetRarityIconPath(color, true))
    self.imgMask:LoadSprite(HeroUtils.GetRarityMaskPath(color))
    self.nameTxt:SetText(DataCenter.RewardManager:GetNameByType(RewardType.GOODS, id))
  elseif type == 5 then
    local id = data.id
    local num = data.num
    local color = DataCenter.ResourceItemDataManager:GetResourceItemQuality(id)
    self.itemCell:SetData(RewardType.RESOURCE_ITEM, id, num)
    self.itemCell:SetActive(true)
    local colorStr = ""
    if color == ItemColor.WHITE then
      colorStr = "white"
    elseif color == ItemColor.GREEN then
      colorStr = "green"
    elseif color == ItemColor.BLUE then
      colorStr = "blue"
    elseif color == ItemColor.PURPLE then
      colorStr = "purple"
    elseif color == ItemColor.ORANGE then
      colorStr = "orange"
    end
    self.imgCover:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/ui_recruit_cover_%s.png", colorStr))
    self.itemBg:LoadSpriteAuto(HeroUtils.GetRarityIconPath(color, true))
    self.imgMask:LoadSprite(HeroUtils.GetRarityMaskPath(color))
    local name = DataCenter.ResourceItemDataManager:GetName(id)
    self.nameTxt:SetText(name)
  else
    local id = data.id
    local num = data.num
    local color = data.goodsColor
    self.nameTxt:SetText("")
  end
end

local function StopAllAnimation(self)
  self:ResetAllEffect()
  local rootRt = self.rootNode.rectTransform
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(1, 1, 1)
  rootRt:Set_localPosition(0, 0, 0)
  local canvasGroup = self.rootNode.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  canvasGroup.alpha = 1
  self.imgCover.transform.eulerAngles = Vector3.New(0, 90, 0)
  self.infoPanel.transform.eulerAngles = Vector3.zero
  self.flipped = true
  if self.flipSequence ~= nil then
    self.flipSequence:Pause()
    self.flipSequence:Kill()
    self.flipSequence = nil
  end
  if self.flipSequence1 then
    self.flipSequence1:Pause()
    self.flipSequence1:Kill()
    self.flipSequence1 = nil
  end
end

local function PlaySpreadAnimation(self, delay)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Effect_Recruit_Card_Befall, false)
  local rootRt = self.rootNode.rectTransform
  local canvasGroup = self.rootNode.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  DOTween.Kill(rootRt)
  canvasGroup.alpha = 0
  rootRt:Set_localScale(0.9, 1, 1)
  rootRt:Set_localPosition(0, 100, 0)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  self.flipSequence1 = sequence
  sequence:AppendInterval(delay)
  sequence:AppendCallback(function()
    self:PlayAppearEffect()
  end)
  sequence:AppendInterval(0.05)
  local duration1 = 0.16
  local duration2 = 0.32
  sequence:Append(canvasGroup:DOFade(1, duration1))
  sequence:Join(rootRt:DOScale(1, duration1))
  sequence:Join(rootRt:DOLocalMoveY(0, duration2))
end

local function OnCoverClick(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Effect_Recruit_Card_Click, false)
end

local function OnCellClick(self)
  if self.heroUuid ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, self.heroUuid, {
      self.heroUuid
    })
  else
    local itemId = self.data.GoodsId
    local id = self.data.id
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.transform.position
    local ScreenSize = CS.UnityEngine.Screen
    local ScreenWidth = ScreenSize.width
    local _screenPos = PosConverse.UIWorldToScreenPos(self.transform.position)
    local param = UIHeroTipView.Param.New()
    if self.rewardType == 2 then
      param.content = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, itemId) .. [[


]] .. DataCenter.RewardManager:GetDescByType(RewardType.GOODS, itemId)
    elseif self.rewardType == 5 then
      param.content = DataCenter.RewardManager:GetNameByType(RewardType.RESOURCE_ITEM, id) .. [[


]] .. DataCenter.RewardManager:GetDescByType(RewardType.RESOURCE_ITEM, id)
    end
    if _screenPos.x + 50 * scaleFactor + 240 * scaleFactor > ScreenWidth - 25 then
      param.dir = UIHeroTipView.Direction.LEFT
      position = position - Vector3.New(50, 0, 0)
    else
      param.dir = UIHeroTipView.Direction.RIGHT
      position = position + Vector3.New(50, 0, 0)
    end
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function DoFlip(self, bLastCard, callback)
  local needShowCg = DataCenter.HeroDataManager:IsNewHero(self.heroUuid) and DataCenter.HeroDataManager:NeedShowNewHeroWindow(self.heroUuid)
  DataCenter.LWSoundManager:PlaySound((self.isPurpleHero or self.isOrangeHero) and SoundAssetId.Effect_Recruit_Card_Flip2 or SoundAssetId.Effect_Recruit_Card_Flip1, false)
  if not bLastCard and not needShowCg and not self.isPurpleHero and not self.isOrangeHero then
    TimerManager:GetInstance():DelayInvoke(callback, HeroUtils.AniConfig.flipInterval)
  end
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  self.flipSequence = sequence
  sequence:Append(self.rootNode.transform:DOScale(1.3, 0.15):SetEase(CS.DG.Tweening.Ease.OutCubic))
  sequence:Append(self.rootNode.transform:DOScale(1, 0.1):SetEase(CS.DG.Tweening.Ease.InCubic))
  sequence:AppendInterval(0.05)
  if self.isPurpleHero then
    self:PlayPurpleChargeEffect()
    sequence:AppendInterval(0.3)
    sequence:Join(0.15, self.rootNode.transform:DOShakePosition(1.2, Vector3.New(25, 25, 1), 30):SetEase(CS.DG.Tweening.Ease.OutQuad))
  end
  if self.isOrangeHero then
    self:PlayOrangeChargeEffect()
    sequence:AppendInterval(0.3)
    sequence:Join(0.15, self.rootNode.transform:DOShakePosition(1.2, Vector3.New(25, 25, 1), 30):SetEase(CS.DG.Tweening.Ease.OutQuad))
  end
  sequence:AppendCallback(function()
    if needShowCg then
      TimerManager:GetInstance():DelayInvoke(function()
        if DataCenter.HeroDataManager:NeedShowNewHeroWindow(self.heroUuid) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, self.heroUuid, {
            self.heroUuid
          }, nil, true)
        end
      end, 0.13)
    end
  end)
  sequence:Append(self.imgCover.transform:DORotate(Vector3.New(0, 270, 0), 0.25, CS.DG.Tweening.RotateMode.FastBeyond360))
  if self.isPurpleHero or self.isOrangeHero then
    sequence:Join(self.rootNode.transform:DOScale(2, 0.3):SetEase(CS.DG.Tweening.Ease.OutQuint))
  end
  local delay2 = (self.isPurpleHero or self.isOrangeHero) and 0 or 0.1
  sequence:AppendCallback(function()
    TimerManager:GetInstance():DelayInvoke(function()
      self:PlayPersistEffect()
    end, delay2)
  end)
  sequence:Append(self.infoPanel.transform:DORotate(Vector3.zero, 0.25, CS.DG.Tweening.RotateMode.Fast):SetEase(CS.DG.Tweening.Ease.OutCirc))
  if self.isPurpleHero or self.isOrangeHero then
    sequence:Join(self.rootNode.transform:DOScale(1, 0.1):SetEase(CS.DG.Tweening.Ease.InOutSine))
  end
  sequence:OnComplete(function()
    if not needShowCg and (bLastCard or self.isPurpleHero or self.isOrangeHero) and callback then
      callback()
    end
    self.imgCover.transform.eulerAngles = Vector3.New(0, 90, 0)
    self.infoPanel.transform.eulerAngles = Vector3.zero
    self.flipped = true
  end)
  self.addExpSequence = sequence
  return needShowCg
end

local function IsFlipped(self)
  return self.flipped
end

local function IsPurpleHero(self)
  return self.isPurpleHero
end

local function ResetAllEffect(self)
  self.greenAppearEffect:SetActive(false)
  self.blueAppearEffect:SetActive(false)
  self.purpleAppearEffect:SetActive(false)
  self.purpleAppearEffect1:SetActive(false)
  self.purpleAppearEffect2:SetActive(false)
  self.orangeAppearEffect:SetActive(false)
  self.orangeAppearEffect1:SetActive(false)
  self.orangeAppearEffect2:SetActive(false)
  self.purpleChargeEffect:SetActive(false)
  self.purpleChargeEffect1:SetActive(false)
  self.purpleChargeEffect2:SetActive(false)
  self.orangeChargeEffect:SetActive(false)
  self.orangeChargeEffect1:SetActive(false)
  self.orangeChargeEffect2:SetActive(false)
  self.greenPersistEffect:SetActive(false)
  self.bluePersistEffect:SetActive(false)
  self.purplePersistEffect:SetActive(false)
  self.purplePersistEffect1:SetActive(false)
  self.orangePersistEffect:SetActive(false)
  self.orangePersistEffect1:SetActive(false)
  self.orangePersistEffect2:SetActive(false)
  self.orangePersistEffect3:SetActive(false)
  self.purplePersistEffect2:SetActive(false)
  self.purplePersistEffect3:SetActive(false)
end

local function PlayAppearEffect(self)
  self.greenAppearEffect:SetActive(false)
  self.blueAppearEffect:SetActive(false)
  self.purpleAppearEffect:SetActive(self.isPurpleHero)
  self.purpleAppearEffect1:SetActive(self.isPurpleHero)
  self.purpleAppearEffect2:SetActive(false)
  self.orangeAppearEffect:SetActive(self.isOrangeHero)
  self.orangeAppearEffect1:SetActive(self.isOrangeHero)
  self.orangeAppearEffect2:SetActive(false)
end

local function PlayPurpleChargeEffect(self)
  self.purpleChargeEffect:SetActive(true)
  if self.isPurpleHero then
    self.purpleChargeEffect1:SetActive(true)
    self.purpleChargeEffect2:SetActive(false)
  end
end

local function PlayOrangeChargeEffect(self)
  self.orangeChargeEffect:SetActive(true)
  if self.isOrangeHero then
    self.orangeChargeEffect1:SetActive(true)
    self.orangeChargeEffect2:SetActive(false)
  end
end

local function PlayPersistEffect(self)
  self.greenPersistEffect:SetActive(false)
  self.bluePersistEffect:SetActive(false)
  self.purplePersistEffect:SetActive(self.isPurpleHero)
  self.purplePersistEffect1:SetActive(self.isPurpleHero)
  self.orangePersistEffect:SetActive(self.isOrangeHero)
  self.purplePersistEffect2:SetActive(self.isPurpleHero and self.isMaster)
  self.purplePersistEffect3:SetActive(self.isPurpleHero and not self.isMaster)
  self.orangePersistEffect1:SetActive(self.isOrangeHero)
  self.orangePersistEffect2:SetActive(self.isOrangeHero and self.isMaster)
  self.orangePersistEffect3:SetActive(self.isOrangeHero and not self.isMaster)
end

local function SetTouchEnabled(self, b)
  self.btn:SetInteractable(b)
end

UIRewardItem.OnCreate = OnCreate
UIRewardItem.OnDestroy = OnDestroy
UIRewardItem.OnEnable = OnEnable
UIRewardItem.OnDisable = OnDisable
UIRewardItem.ComponentDefine = ComponentDefine
UIRewardItem.ComponentDestroy = ComponentDestroy
UIRewardItem.DataDefine = DataDefine
UIRewardItem.DataDestroy = DataDestroy
UIRewardItem.UpdateView = UpdateView
UIRewardItem.PlaySpreadAnimation = PlaySpreadAnimation
UIRewardItem.OnCoverClick = OnCoverClick
UIRewardItem.OnCellClick = OnCellClick
UIRewardItem.DoFlip = DoFlip
UIRewardItem.IsFlipped = IsFlipped
UIRewardItem.IsPurpleHero = IsPurpleHero
UIRewardItem.ResetAllEffect = ResetAllEffect
UIRewardItem.PlayAppearEffect = PlayAppearEffect
UIRewardItem.PlayPurpleChargeEffect = PlayPurpleChargeEffect
UIRewardItem.PlayPersistEffect = PlayPersistEffect
UIRewardItem.SetTouchEnabled = SetTouchEnabled
UIRewardItem.StopAllAnimation = StopAllAnimation
UIRewardItem.PlayOrangeChargeEffect = PlayOrangeChargeEffect
return UIRewardItem
