local UIRewardItem = BaseClass("UIRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellBig = require("UI.UIHero2.UIHeroRecruitRewardNew.Component.UIHeroRecruitCellBig")
local UIItemCell = require("UI.UIHero2.Common.UIItemCell")
local StayShakeAni = ""
local DrawCardAni = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.rootAni = self:AddComponent(UIAnimator, "")
  self.rootAni:Enable(false)
  self.infoPanel = self:AddComponent(UIBaseContainer, "Root/InfoPanel")
  self.heroContent = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent")
  self.itemContent = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent")
  self.heroCell = self:AddComponent(UIHeroCellBig, "Root/InfoPanel/heroContent/UIHeroCellBig")
  self.itemCell = self:AddComponent(UIItemCell, "Root/InfoPanel/itemContent/UIItemCell")
  self.itemNum = self:AddComponent(UIText, "Root/InfoPanel/itemContent/itemNum")
  self.nameTxt = self:AddComponent(UIText, "Root/InfoPanel/nameTxtMask/nameTxt")
  self.bg = self:AddComponent(UIImage, "Root/InfoPanel/bg")
  self.frontMask = self:AddComponent(UIImage, "Root/InfoPanel/frontMask")
  self.btn = self:AddComponent(UIButton, "")
  self.changzhu_effect_1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/changzhu_effect_1")
  self.PurplePersistEffect3 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/changzhu_effect_1/PurplePersistEffect3")
  self.GoldenPersistEffect3 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/changzhu_effect_1/GoldenPersistEffect3")
  self.changzhu_effect_2 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/changzhu_effect_2")
  self.PurpleAppearEffect6 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/changzhu_effect_2/PurpleAppearEffect6")
  self.GoldenAppearEffect6 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/changzhu_effect_2/GoldenAppearEffect6")
  self.changzhu_effect_2_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/changzhu_effect_2Item")
  self.PurpleAppearEffect6_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/changzhu_effect_2Item/PurpleAppearEffect6Item")
  self.GoldenAppearEffect6_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/changzhu_effect_2Item/GoldenAppearEffect6Item")
  self.fanpai_effect_1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/fanpai_effect_1")
  self.PurplePersistEffect2 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/fanpai_effect_1/PurplePersistEffect2")
  self.GoldenPersistEffect2 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/fanpai_effect_1/GoldenPersistEffect2")
  self.fanpai_effect_2 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/fanpai_effect_2")
  self.PurpleAppearEffect5 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/fanpai_effect_2/PurpleAppearEffect5")
  self.GoldenAppearEffect5 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/fanpai_effect_2/GoldenAppearEffect5")
  self.fanpai_effect_2_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/fanpai_effect_2Item")
  self.PurpleAppearEffect5_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/fanpai_effect_2Item/PurpleAppearEffect5Item")
  self.GoldenAppearEffect5_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/fanpai_effect_2Item/GoldenAppearEffect5Item")
  self.doudong_effect_1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/doudong_effect_1")
  self.PurplePersistEffect1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/doudong_effect_1/PurplePersistEffect1")
  self.GoldenPersistEffect1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/doudong_effect_1/GoldenPersistEffect1")
  self.doudong_effect_2 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/doudong_effect_2")
  self.PurplePersistEffect4 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/doudong_effect_2/PurplePersistEffect4")
  self.GoldenPersistEffect4 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/doudong_effect_2/GoldenPersistEffect4")
  self.doudong_effect_2_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/doudong_effect_2Item")
  self.PurplePersistEffect4_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/doudong_effect_2Item/PurplePersistEffect4Item")
  self.GoldenPersistEffect4_item = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/NodeEffectRoot/doudong_effect_2Item/GoldenPersistEffect4Item")
  self.btn:SetOnClick(BindCallback(self, self.OnCellClick))
end

local function ComponentDestroy(self)
  self.rootNode = nil
  self.rootAni = nil
  self.infoPanel = nil
  self.heroContent = nil
  self.itemContent = nil
  self.heroCell = nil
  self.itemCell = nil
  self.itemNum = nil
  self.nameTxt = nil
  self.bg = nil
  self.frontMask = nil
  self.btn = nil
  self.changzhu_effect_1 = nil
  self.PurplePersistEffect3 = nil
  self.GoldenPersistEffect3 = nil
  self.changzhu_effect_2 = nil
  self.changzhu_effect_2_item = nil
  self.PurpleAppearEffect6 = nil
  self.PurpleAppearEffect6_item = nil
  self.GoldenAppearEffect6 = nil
  self.GoldenAppearEffect6_item = nil
  self.fanpai_effect_1 = nil
  self.PurplePersistEffect2 = nil
  self.GoldenPersistEffect2 = nil
  self.fanpai_effect_2 = nil
  self.fanpai_effect_2_item = nil
  self.PurpleAppearEffect5 = nil
  self.PurpleAppearEffect5_item = nil
  self.GoldenAppearEffect5 = nil
  self.GoldenAppearEffect5_item = nil
  self.doudong_effect_1 = nil
  self.PurplePersistEffect1 = nil
  self.GoldenPersistEffect1 = nil
  self.doudong_effect_2 = nil
  self.doudong_effect_2_item = nil
  self.PurpleAppearEffect4 = nil
  self.GoldenAppearEffect4 = nil
end

local function DataDefine(self)
  self.heroUuid = nil
  self.heroId = nil
end

local function DataDestroy(self)
  self.heroUuid = nil
  self.heroId = nil
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
  self.infoPanel:SetActive(true)
  self.heroContent:SetActive(false)
  self.itemContent:SetActive(false)
  self:CloseAllEffectShow()
  if type == 0 then
    local heroUuid = data.uuid
    self.heroContent:SetActive(true)
    self.heroCell:SetData(heroUuid)
    self.heroCell:DisableRedPoint()
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
    self.nameTxt:SetText(heroData:GetName())
    self:SetItemQualityView(heroData.quality)
    self:SetHeroEffectShow()
  elseif type == 2 then
    local id = data.GoodsId
    local num = data.addNumber
    self.heroId = tonumber(data.fromHero)
    self.heroId = DataCenter.HeroDataManager:GetHeroUuidByHeroId(self.heroId)
    self.itemContent:SetActive(true)
    self.itemCell:SetData(RewardType.GOODS, id, num)
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
    self:SetItemQualityView(color)
    self.nameTxt:SetText(DataCenter.RewardManager:GetNameByType(RewardType.GOODS, id))
    self.itemNum:SetText("x" .. num)
    if self.heroId ~= nil then
      self:SetHeroEffectShow(color)
      self.PurplePersistEffect3:SetActive(false)
      self.GoldenPersistEffect3:SetActive(false)
      self.PurpleAppearEffect6:SetActive(false)
      self.PurpleAppearEffect6_item:SetActive(false)
      self.GoldenAppearEffect6:SetActive(false)
      self.GoldenAppearEffect6_item:SetActive(false)
    end
  elseif type == 5 then
    local id = data.id
    local num = data.num
    local color = DataCenter.ResourceItemDataManager:GetResourceItemQuality(id)
    self.itemContent:SetActive(true)
    self.itemCell:SetData(RewardType.RESOURCE_ITEM, id, num)
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
    self:SetItemQualityView(color)
    local name = DataCenter.ResourceItemDataManager:GetName(id)
    self.nameTxt:SetText(name)
    self.itemNum:SetText("x" .. num)
  else
    local id = data.id
    local num = data.num
    local color = data.goodsColor
    self:SetItemQualityView(6)
    self.nameTxt:SetText("")
  end
end

local function SetItemQualityView(self, quality)
  if quality == 6 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 2))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 1))
    self.nameTxt:SetColorRGBA(1, 0.675, 0.6, 1)
  elseif quality == 5 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 4))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 3))
    self.nameTxt:SetColorRGBA(1, 0.808, 0.294, 1)
  elseif quality == 4 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 6))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 5))
    self.nameTxt:SetColorRGBA(0.988, 0.616, 1, 1)
  elseif quality == 3 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 8))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 7))
    self.nameTxt:SetColorRGBA(0.439, 0.902, 0.945, 1)
  elseif quality == 2 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 10))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 9))
    self.nameTxt:SetColorRGBA(0.302, 0.961, 0.69, 1)
  elseif quality == 1 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 12))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 11))
    self.nameTxt:SetColorRGBA(1, 1, 1, 1)
  end
end

local function SetHeroEffectShow(self, quality)
  local isPurpleHero = self.isPurpleHero
  local isOrangeHero = self.isOrangeHero
  self.isPurpleCard = self.isPurpleHero
  self.isOrangeCard = self.isOrangeHero
  if quality ~= nil then
    isPurpleHero = quality == HeroQualityType.Genius
    isOrangeHero = quality == HeroQualityType.Legendary
    self.isPurpleCard = isPurpleHero
    self.isOrangeCard = isOrangeHero
  end
  self.PurplePersistEffect3:SetActive(isPurpleHero)
  self.GoldenPersistEffect3:SetActive(isOrangeHero)
  self.PurpleAppearEffect6:SetActive(isPurpleHero)
  self.PurpleAppearEffect6_item:SetActive(isPurpleHero)
  self.GoldenAppearEffect6:SetActive(isOrangeHero)
  self.GoldenAppearEffect6_item:SetActive(isOrangeHero)
  self.PurplePersistEffect2:SetActive(isPurpleHero)
  self.GoldenPersistEffect2:SetActive(isOrangeHero)
  self.PurpleAppearEffect5:SetActive(isPurpleHero)
  self.PurpleAppearEffect5_item:SetActive(isPurpleHero)
  self.GoldenAppearEffect5:SetActive(isOrangeHero)
  self.GoldenAppearEffect5_item:SetActive(isOrangeHero)
  self.PurplePersistEffect1:SetActive(isPurpleHero)
  self.GoldenPersistEffect1:SetActive(isOrangeHero)
  self.PurplePersistEffect4:SetActive(isPurpleHero)
  self.PurplePersistEffect4_item:SetActive(isPurpleHero)
  self.GoldenPersistEffect4:SetActive(isOrangeHero)
  self.GoldenPersistEffect4_item:SetActive(isOrangeHero)
end

local function CloseAllEffectShow(self)
  self.PurplePersistEffect3:SetActive(false)
  self.GoldenPersistEffect3:SetActive(false)
  self.PurpleAppearEffect6:SetActive(false)
  self.PurpleAppearEffect6_item:SetActive(false)
  self.GoldenAppearEffect6:SetActive(false)
  self.GoldenAppearEffect6_item:SetActive(false)
  self.PurplePersistEffect2:SetActive(false)
  self.GoldenPersistEffect2:SetActive(false)
  self.PurpleAppearEffect5:SetActive(false)
  self.PurpleAppearEffect5_item:SetActive(false)
  self.GoldenAppearEffect5:SetActive(false)
  self.GoldenAppearEffect5_item:SetActive(false)
  self.PurplePersistEffect1:SetActive(false)
  self.GoldenPersistEffect1:SetActive(false)
  self.PurplePersistEffect4:SetActive(false)
  self.PurplePersistEffect4_item:SetActive(false)
  self.GoldenPersistEffect4:SetActive(false)
  self.GoldenPersistEffect4_item:SetActive(false)
end

local function OnCellClick(self)
  if self.callBackFunc ~= nil then
    self.callBackFunc()
  end
end

local function ResetAniVal(self)
  self.rootAni:Enable(false)
  self.rootNode:SetAnchoredPositionXY(0, 0)
  self.rootNode:SetEulerAnglesXYZ(0, 0, 0)
  self.rootNode:SetLocalScaleXYZ(1, 1, 1)
  self.rootAni:SetAnchoredPositionXY(0, 0)
  self.rootAni:SetEulerAnglesXYZ(0, 0, 0)
  self.rootAni:SetLocalScaleXYZ(1, 1, 1)
  self.infoPanel:SetEulerAnglesXYZ(0, 0, 0)
end

local function SetCoverView(self)
  self:ResetAniVal()
  self.infoPanel:SetActive(false)
  self.changzhu_effect_1:SetActive(false)
  self.changzhu_effect_2:SetActive(false)
  self.changzhu_effect_2_item:SetActive(false)
  self.fanpai_effect_1:SetActive(false)
  self.fanpai_effect_2:SetActive(false)
  self.fanpai_effect_2_item:SetActive(false)
  self.doudong_effect_1:SetActive(false)
  self.doudong_effect_2:SetActive(false)
  self.doudong_effect_2_item:SetActive(false)
end

local function SetNormalView(self)
  self:ResetAniVal()
  self.infoPanel:SetActive(true)
  self.changzhu_effect_1:SetActive(true)
  self.changzhu_effect_2:SetActive(true)
  self.changzhu_effect_2_item:SetActive(true)
  self.fanpai_effect_1:SetActive(false)
  self.fanpai_effect_2:SetActive(false)
  self.fanpai_effect_2_item:SetActive(false)
  self.doudong_effect_1:SetActive(false)
  self.doudong_effect_2:SetActive(false)
  self.doudong_effect_2_item:SetActive(false)
end

local function PlayWaitingOpenAni(self)
  self.rootAni:Enable(true)
  self.rootAni:Play("Eff_UIHeroRecruitRewardNew_doudong")
end

local function PlayOpenAni(self)
  self.rootAni:Enable(true)
  self.rootAni:Play("Eff_UIHeroRecruitRewardCellNew_fanpai")
end

local function SetData(self, lotteryId, index, data, callBackFunc)
  self.lotteryId = lotteryId
  self.index = index
  self.data = data
  self.callBackFunc = callBackFunc
  self.heroUuid = nil
  self.heroId = nil
  self:UpdateView()
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
UIRewardItem.OnCellClick = OnCellClick
UIRewardItem.SetCoverView = SetCoverView
UIRewardItem.SetNormalView = SetNormalView
UIRewardItem.PlayWaitingOpenAni = PlayWaitingOpenAni
UIRewardItem.PlayOpenAni = PlayOpenAni
UIRewardItem.SetData = SetData
UIRewardItem.ResetAniVal = ResetAniVal
UIRewardItem.SetHeroEffectShow = SetHeroEffectShow
UIRewardItem.CloseAllEffectShow = CloseAllEffectShow
UIRewardItem.SetItemQualityView = SetItemQualityView
return UIRewardItem
