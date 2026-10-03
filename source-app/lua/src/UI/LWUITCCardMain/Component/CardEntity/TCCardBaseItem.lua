local TCCardBaseItem = BaseClass("TCCardBaseItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ani_root_path = "AniRoot"
local card_img_path = "AniRoot/ScaleRoot/CardImg/CardIconImg"
local level_text_path = "AniRoot/ScaleRoot/LevelText"
local select_point_path = "AniRoot/ScaleRoot/SelectPoint"
local simple_frame_img_path = "AniRoot/ScaleRoot/CardImg/SimpleFrameImg"
local deluxe_frame_img_path = "AniRoot/ScaleRoot/CardImg/DeluxeFrameImg"
local equip_item_path = "AniRoot/ScaleRoot/EquipItem"
local bg_path = "AniRoot/ScaleRoot/CardImg/bg"
TCCardBaseItem.STANDARD_SIZE = {x = 130.9235, y = 195.1564}
TCCardBaseItem.VISUAL_SIZE = {x = 130.9235, y = 195.1564}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveNewTag()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.cardImg = self:AddComponent(UIImage, card_img_path)
  self.levelText = self:AddComponent(UIText, level_text_path)
  self.selectObj = self:AddComponent(UIBaseContainer, select_point_path)
  self.clickBtn = self:AddComponent(UIButton, ani_root_path)
  self.clickBtn:SetOnClick(function()
    self:BeClick()
  end)
  self.simpleFrameImg = self:AddComponent(UIImage, simple_frame_img_path)
  self.deluxeFrameImg = self:AddComponent(UIImage, deluxe_frame_img_path)
  self.simpleAni = self:TryAddComponent(UISimpleAnimation, "")
  self.vfx_openBox = self:TryAddComponent(UIVfx, "AniRoot/ScaleRoot/vfx_openBox")
  self.canvasGroup = self:TryAddComponent(UICanvasGroup, "AniRoot")
  self.vfx_openBoxSingleFront = self:TryAddComponent(UIVfx, "AniRoot/ScaleRoot/vfx_openBoxSingleFront")
  self.longPressBtn = self:TryAddComponent(UIButton_LongPress, ani_root_path)
  if self.longPressBtn then
    self.longPressBtn:SetLongPressAction(function(eventData)
      self:BeLongPress(eventData)
    end)
  else
    self.eventTrigger = nil
  end
  self.equipFlag = self:TryAddComponent(UIBaseContainer, equip_item_path)
  self.equipFlagTips = self:TryAddComponent(UITextMeshProUGUIEx, "AniRoot/ScaleRoot/EquipItem/InUseTipText")
  self.bg = self:TryAddComponent(UIImage, bg_path)
  self.deskIcon = self:AddComponent(UIImage, "AniRoot/ScaleRoot/deskIcon")
  self.selectObjBorder = self:TryAddComponent(UIRawImage, "AniRoot/ScaleRoot/SelectPoint/BG")
  self.selectObjChildIcon = self:TryAddComponent(UIImage, "AniRoot/ScaleRoot/SelectPoint/Image")
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.clickFunc = nil
  self.longPressFunc = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCCardBaseItem:SetData(cardData, displayConfig)
  self.cardData = cardData
  self.cardId = cardData:GetCardId()
  self.cardUuid = cardData.uuid
  self.cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.cardId)
  self.cardLevel = cardData:GetLevel()
  self.cardStar = cardData:GetStar()
  self.displayConfig = displayConfig
  self.showType = TacticalCardShowType.SimpleShow
  self:RefreshView()
  self:SetSelectObjState(false)
  self:CheckDisplayConfig(displayConfig)
  self:RefreshFrameImg()
end

function TCCardBaseItem:SetConfigData(cardId, cardLevel, cardStar, displayConfig)
  self.cardData = nil
  self.cardId = cardId
  self.cardUuid = nil
  self.cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.cardId)
  self.cardLevel = cardLevel
  self.cardStar = cardStar
  self.displayConfig = displayConfig
  self.showType = TacticalCardShowType.SimpleShow
  self:RefreshView()
  self:SetSelectObjState(false)
  self:CheckDisplayConfig(displayConfig)
  self:RefreshFrameImg()
end

function TCCardBaseItem:RefreshView()
  if not self.cardTemplate then
    return
  end
  if self.cardData then
    self.levelText:SetText(TacticalCardUtil.GetLevelStr(self.cardData))
  else
    self.levelText:SetText(TacticalCardUtil.GetLevelStrLv(self.cardLevel))
  end
  if self.cardTemplate and self.cardTemplate.icon then
    self.cardImg:LoadSprite(self.cardTemplate.icon)
  end
  if self.cardTemplate and self.cardTemplate.deck ~= nil then
    local deckTemplate = LocalController:instance():getLine(TableName.BATTLE_CARD_DECK, self.cardTemplate.deck)
    if deckTemplate then
      self.deskIcon:SetActive(true)
      self.deskIcon:LoadSpriteAsync(string.format(LoadPath.UILWTC, deckTemplate.deck_icon_up))
    else
      self.deskIcon:SetActive(false)
    end
  end
end

function TCCardBaseItem:SetSelectObjState(isSelect)
  self.selectObj:SetActive(isSelect)
end

function TCCardBaseItem:SetClickFunc(clickFunc)
  self.clickFunc = clickFunc
  self.isCanClick = true
end

function TCCardBaseItem:SetLongPressFunc(longPressFunc)
  self.longPressFunc = longPressFunc
end

function TCCardBaseItem:BeClick()
  if self.clickFunc then
    self.clickFunc(self.cardId, self.cardUuid, self.cardLevel, self.cardStar, self.cardData, self)
  end
end

function TCCardBaseItem:BeLongPress(eventData)
  if self.longPressFunc then
    self.longPressFunc(self.cardId, self.cardUuid, self.cardLevel, self.cardStar, self.cardData, self)
  end
end

function TCCardBaseItem:CheckDisplayConfig(displayConfig)
  if not displayConfig then
    self.levelText:SetActive(true)
    self.showType = TacticalCardShowType.SimpleShow
    self:SetEquipState(false)
    self:SetBgShow(false)
    return
  end
  if displayConfig.isShowLv ~= nil then
    self.levelText:SetActive(displayConfig.isShowLv)
  end
  if displayConfig.isDeluxeShow then
    self.showType = TacticalCardShowType.DeluxeShow
  end
  if displayConfig.isShowEquipFlag then
    self:SetEquipState(self.cardData:IsEquip())
  end
  if displayConfig.isShowDeck ~= nil and self.deskIcon ~= nil then
    self.deskIcon:SetActive(displayConfig.isShowDeck)
  end
  if displayConfig.showEquipCustomFunc then
    local isShowEquip, tipsId = displayConfig.showEquipCustomFunc(self.cardData)
    self:SetEquipState(isShowEquip, tipsId)
  end
  self:SetBgShow(displayConfig.showBg == true)
end

local Type_CS_Image = typeof(CS.UnityEngine.UI.Image)
local Type_CS_RectTransform = typeof(CS.UnityEngine.RectTransform)
local GameObject = CS.UnityEngine.GameObject

function TCCardBaseItem:ShowNewTag()
  if self.newTag == nil then
    local go = GameObject("newTag")
    go:AddComponent(Type_CS_Image)
    local rectTransform = go:GetComponent(Type_CS_RectTransform)
    rectTransform:SetParent(self.clickBtn.transform)
    rectTransform:SetAsLastSibling()
    self.newTag = self:AddComponent(UIImage, "AniRoot/newTag")
    self.newTag:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_img_new.png")
    self.newTag:SetLocalScaleXYZ(1.35, 1.35, 1.35)
    self.newTag:SetAnchoredPositionXY(86, 106, 0)
    self.newTag:SetSizeDeltaXY(87, 35)
  end
  self.newTag:SetEnable(true)
end

function TCCardBaseItem:HideNewTag()
  if self.newTag then
    self.newTag:SetEnable(false)
  end
end

function TCCardBaseItem:RemoveNewTag()
  if self.newTag then
    local go = self.newTag.gameObject
    if not IsNull(go) then
      local transform = go.transform
      self:RemoveComponent(self.newTag:GetName(), UIImage)
      transform:SetParent(nil)
      CS.UnityEngine.GameObject.Destroy(go)
    else
      Logger.LogError("newTag gameObject is null")
    end
    self.newTag = nil
  end
end

function TCCardBaseItem:RefreshFrameImg()
  if not self.cardTemplate then
    self.simpleFrameImg:SetActive(false)
    self.deluxeFrameImg:SetActive(false)
    return
  end
  local cardType = self.cardTemplate.type
  local quality = self.cardTemplate.color
  local frameImgPath = TacticalCardUtil.GetCardFrameByQuality(cardType, self.showType, quality)
  local frameImg = self.showType == TacticalCardShowType.SimpleShow and self.simpleFrameImg or self.deluxeFrameImg
  self.simpleFrameImg:SetActive(self.showType == TacticalCardShowType.SimpleShow)
  self.deluxeFrameImg:SetActive(self.showType == TacticalCardShowType.DeluxeShow)
  if frameImg and frameImgPath then
    frameImg:LoadSprite(frameImgPath)
  end
end

function TCCardBaseItem:PlayAni(aniName)
  if not self.simpleAni then
    return
  end
  self.simpleAni:Play(aniName)
end

function TCCardBaseItem:PlayAniQueue(aniName)
  if not self.simpleAni then
    return
  end
  self.simpleAni:PlayQueued(aniName)
end

function TCCardBaseItem:SetCanvasGroupAlpha(value)
  self.canvasGroup:SetAlpha(value)
end

function TCCardBaseItem:ShowOpenBoxSingleFrontVfx()
  if self.vfx_openBoxSingleFront then
    self.vfx_openBoxSingleFront:PlayByStay(VfxAssets.TCCardOpenBoxCardFrontVfx)
  end
end

function TCCardBaseItem:SetEquipState(isShow, tipsId)
  if not self.equipFlag then
    return
  end
  self.equipFlag:SetActive(isShow)
  if self.equipFlagTips ~= nil then
    if tipsId ~= nil then
      self.equipFlagTips:SetLocalText(tipsId)
    else
      self.equipFlagTips:SetLocalText("battle_card_using_now")
    end
  end
end

function TCCardBaseItem:SetBgShow(show)
  if self.bg then
    self.bg:SetActive(show)
  end
end

TCCardBaseItem.OnCreate = OnCreate
TCCardBaseItem.OnDestroy = OnDestroy
TCCardBaseItem.OnEnable = OnEnable
TCCardBaseItem.OnDisable = OnDisable
TCCardBaseItem.ComponentDefine = ComponentDefine
TCCardBaseItem.ComponentDestroy = ComponentDestroy
TCCardBaseItem.DataDefine = DataDefine
TCCardBaseItem.DataDestroy = DataDestroy
TCCardBaseItem.OnAddListener = OnAddListener
TCCardBaseItem.OnRemoveListener = OnRemoveListener
return TCCardBaseItem
