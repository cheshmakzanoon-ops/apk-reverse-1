local UIRewardItem = BaseClass("UIRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIItemCell = require("UI.UIHero2.Common.UIItemCell")
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local worker_content_path = "Root/InfoPanel/workerContent"
local u_i_worker_show_cell_path = "Root/InfoPanel/workerContent/UIWorkerShowCell"
local img_new_path = "Root/InfoPanel/workerContent/ImgNew"
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
  self.itemCell = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent/UIItemCell")
  self.imgIcon = self:AddComponent(UIImage, "Root/InfoPanel/itemContent/UIItemCell/imgIcon")
  self.itemNum = self:AddComponent(UIText, "Root/InfoPanel/itemContent/itemNum")
  self.nameTxt = self:AddComponent(UIText, "Root/InfoPanel/nameTxtMask/nameTxt")
  self.worker_content = self:AddComponent(UIBaseContainer, worker_content_path)
  self.u_i_worker_show_cell = self:AddComponent(UIWorkerShowCell, u_i_worker_show_cell_path)
  self.img_new = self:AddComponent(UIImage, img_new_path)
  self.bg = self:AddComponent(UIImage, "Root/InfoPanel/bg")
  self.frontMask = self:AddComponent(UIImage, "Root/InfoPanel/frontMask")
  self.btn = self:AddComponent(UIButton, "")
  self.changzhu_effect_1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/changzhu_effect_1")
  self.PurplePersistEffect3 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/changzhu_effect_1/PurplePersistEffect3")
  self.GoldenPersistEffect3 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/changzhu_effect_1/GoldenPersistEffect3")
  self.changzhu_effect_2 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/changzhu_effect_2")
  self.PurpleAppearEffect6 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/changzhu_effect_2/PurpleAppearEffect6")
  self.GoldenAppearEffect6 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/changzhu_effect_2/GoldenAppearEffect6")
  self.fanpai_effect_1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/fanpai_effect_1")
  self.PurplePersistEffect2 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/fanpai_effect_1/PurplePersistEffect2")
  self.GoldenPersistEffect2 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/fanpai_effect_1/GoldenPersistEffect2")
  self.fanpai_effect_2 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/fanpai_effect_2")
  self.PurpleAppearEffect5 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/fanpai_effect_2/PurpleAppearEffect5")
  self.GoldenAppearEffect5 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/fanpai_effect_2/GoldenAppearEffect5")
  self.doudong_effect_1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/doudong_effect_1")
  self.PurplePersistEffect1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/doudong_effect_1/PurplePersistEffect1")
  self.GoldenPersistEffect1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1/doudong_effect_1/GoldenPersistEffect1")
  self.doudong_effect_2 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/doudong_effect_2")
  self.PurplePersistEffect4 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/doudong_effect_2/PurplePersistEffect4")
  self.GoldenPersistEffect4 = self:AddComponent(UIBaseContainer, "Root/InfoPanel/workerContent/NodeEffectRoot/doudong_effect_2/GoldenPersistEffect4")
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
  self.worker_content = nil
  self.u_i_worker_show_cell = nil
  self.img_new = nil
  self.bg = nil
  self.frontMask = nil
  self.btn = nil
  self.changzhu_effect_1 = nil
  self.PurplePersistEffect3 = nil
  self.GoldenPersistEffect3 = nil
  self.changzhu_effect_2 = nil
  self.PurpleAppearEffect6 = nil
  self.GoldenAppearEffect6 = nil
  self.fanpai_effect_1 = nil
  self.PurplePersistEffect2 = nil
  self.GoldenPersistEffect2 = nil
  self.fanpai_effect_2 = nil
  self.PurpleAppearEffect5 = nil
  self.GoldenAppearEffect5 = nil
  self.doudong_effect_1 = nil
  self.PurplePersistEffect1 = nil
  self.GoldenPersistEffect1 = nil
  self.doudong_effect_2 = nil
  self.PurpleAppearEffect4 = nil
  self.GoldenAppearEffect4 = nil
end

local function DataDefine(self)
  self.workerId = nil
end

local function DataDestroy(self)
  self.workerId = nil
end

local function UpdateView(self)
  local data = self.data
  local rewardType = data.type
  self.rewardType = rewardType
  self.infoPanel:SetActive(true)
  self.heroContent:SetActive(false)
  self.itemContent:SetActive(false)
  self.worker_content:SetActive(false)
  self:CloseAllEffectShow()
  if rewardType == RewardType.WORKER then
    self.worker_content:SetActive(true)
    local workerUid = data.value.workerUid
    local workerId = data.value.workerId
    self.u_i_worker_show_cell:SetData(workerId)
    self.img_new:SetActive(true)
    local temp = DataCenter.WorkerTemplateManager:GetShowTemplateById(workerId)
    local quality = temp.quality
    self.isPurpleHero = quality == HeroQualityType.Genius
    self.isOrangeHero = quality == HeroQualityType.Legendary
    self.nameTxt:SetText(temp:GetName())
    self:SetItemQualityView(quality)
    self:SetHeroEffectShow()
  elseif rewardType == RewardType.GOODS then
    self.itemContent:SetActive(true)
    local itemId = tonumber(data.value.id)
    local add = data.value.num
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    local color = itemTemplate.color
    self:SetItemQualityView(color)
    self.imgIcon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId))
    self.nameTxt:SetText(DataCenter.RewardManager:GetNameByType(RewardType.GOODS, itemId))
    self.itemNum:SetText("x" .. add)
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
  self.GoldenAppearEffect6:SetActive(isOrangeHero)
  self.PurplePersistEffect2:SetActive(isPurpleHero)
  self.GoldenPersistEffect2:SetActive(isOrangeHero)
  self.PurpleAppearEffect5:SetActive(isPurpleHero)
  self.GoldenAppearEffect5:SetActive(isOrangeHero)
  self.PurplePersistEffect1:SetActive(isPurpleHero)
  self.GoldenPersistEffect1:SetActive(isOrangeHero)
  self.PurplePersistEffect4:SetActive(isPurpleHero)
  self.GoldenPersistEffect4:SetActive(isOrangeHero)
end

local function CloseAllEffectShow(self)
  self.PurplePersistEffect3:SetActive(false)
  self.GoldenPersistEffect3:SetActive(false)
  self.PurpleAppearEffect6:SetActive(false)
  self.GoldenAppearEffect6:SetActive(false)
  self.PurplePersistEffect2:SetActive(false)
  self.GoldenPersistEffect2:SetActive(false)
  self.PurpleAppearEffect5:SetActive(false)
  self.GoldenAppearEffect5:SetActive(false)
  self.PurplePersistEffect1:SetActive(false)
  self.GoldenPersistEffect1:SetActive(false)
  self.PurplePersistEffect4:SetActive(false)
  self.GoldenPersistEffect4:SetActive(false)
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
  self.fanpai_effect_1:SetActive(false)
  self.fanpai_effect_2:SetActive(false)
  self.doudong_effect_1:SetActive(false)
  self.doudong_effect_2:SetActive(false)
end

local function SetNormalView(self)
  self:ResetAniVal()
  self.infoPanel:SetActive(true)
  self.changzhu_effect_1:SetActive(true)
  self.changzhu_effect_2:SetActive(true)
  self.fanpai_effect_1:SetActive(false)
  self.fanpai_effect_2:SetActive(false)
  self.doudong_effect_1:SetActive(false)
  self.doudong_effect_2:SetActive(false)
end

local function PlayWaitingOpenAni(self)
  self.rootAni:Enable(true)
  self.rootAni:Play("Eff_UIHeroRecruitRewardNew_doudong")
end

local function PlayOpenAni(self)
  self.rootAni:Enable(true)
  self.rootAni:Play("Eff_UIHeroRecruitRewardCellNew_fanpai")
end

local function SetData(self, index, data, callBackFunc)
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
