local UICommonResItem = BaseClass("UICommonResItem", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  rewardType,
  itemId,
  count,
  iconName,
  itemColor,
  itemName,
  itemDesc,
  enableClick
}
local delete_path = "delete"
local double_mark_path = "DoubleMark"
local this_path = "clickBtn"
local num_text_path = "clickBtn/NumText"
local img_arrow_path = "clickBtn/Img_Arrow"
local flag_path = "clickBtn/FlagGo"
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local select_path = "clickBtn/select"
local item_bg_path = "clickBtn/item_bg"
local hero_quality_path = "clickBtn/HeroQuality"
local name_text_path = "clickBtn/NameText"
local camp_path = "clickBtn/ImgCamp"
local img_extra_mark_path = "Img_ExtraMark"
local img_recapture_mark_path = "Img_RecaptureMark"
local img_rece_path = "clickBtn/ImgRece"
local DEFAULT_MULTIPLE = 2
local DEFAULT_MULTIPLE_ICON = "zyf_kongtouzhaohuan_huode_x2"

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

local function ComponentDefine(self)
  self.seasonType = nil
  self.item_bg = self:TryAddComponent(UIImage, item_bg_path)
  if self.item_bg then
    self.item_bg:SetActive(true)
  end
  self.hero_quality = self:TryAddComponent(UIImage, hero_quality_path)
  if self.hero_quality then
    self.hero_quality:SetActive(false)
  end
  self.name_text = self:TryAddComponent(UIText, name_text_path)
  self.imgCamp = self:TryAddComponent(UIImage, camp_path)
  if self.imgCamp then
    self.imgCamp:SetActive(false)
  end
  self.canvasGroup = self:TryAddComponent(UICanvasGroup, this_path)
  self.delete = self:TryAddComponent(UIBaseComponent, delete_path)
  self:SetDelete(false)
  self.num_text = self:TryAddComponent(UIText, num_text_path)
  if self.num_text then
    self.num_text:SetText("")
  end
  self.img_arrow = self:TryAddComponent(UIImage, img_arrow_path)
  self:SetArrowState(false)
  self.flag = self:TryAddComponent(UIBaseContainer, flag_path)
  self:SetFlagActive(false)
  self.item_quality = self:TryAddComponent(UIImage, item_quality_path)
  if self.item_quality then
    self.item_quality:SetActive(false)
  end
  self.item_icon = self:TryAddComponent(UIImage, item_icon_path)
  self.flag_text = self:TryAddComponent(UIText, flag_text_path)
  if self.flag_text then
    self.flag_text:SetText("")
  end
  self.double_mark = self:TryAddComponent(UIImage, double_mark_path)
  if self.double_mark then
    self.double_mark:LoadSprite(string.format(LoadPath.UImystery, DEFAULT_MULTIPLE_ICON))
    self.double_mark:SetActive(false)
  end
  self.btn = self:TryAddComponent(UIButton, this_path)
  if self.btn then
    self.btn:SetOnClick(function()
      self:OnBtnClick()
    end)
  end
  self.select = self:TryAddComponent(UIImage, select_path)
  self.img_extra_mark = self:TryAddComponent(UIImage, img_extra_mark_path)
  if self.img_extra_mark then
    self.img_extra_mark:SetActive(false)
  end
  self.img_recapture_mark = self:TryAddComponent(UIImage, img_recapture_mark_path)
  if self.img_recapture_mark then
    self.img_recapture_mark:SetActive(false)
  end
  self.rece_flag = self:TryAddComponent(UIBaseContainer, img_rece_path)
  self.anim = self:TryAddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
  self.canvasGroup = nil
  self.delete = nil
  self.num_text = nil
  self.img_arrow = nil
  self.flag = nil
  self.item_quality = nil
  self.item_icon = nil
  self.btn = nil
  self.select = nil
  self.item_bg = nil
  self.hero_quality = nil
  self.imgCamp = nil
  self.seasonType = nil
  self.anim = nil
end

local function DataDefine(self)
  self.commonResItem = nil
end

local function DataDestroy(self)
  if self.effectResHandle ~= nil then
    self.effectResHandle:Destroy()
    self.effectResHandle = nil
  end
  if self.commonResItem then
    self.commonResItem:OnDestroy()
    ObjectPool:GetInstance():Save(self.commonResItem)
    self.commonResItem = nil
  end
end

local function OnBtnClick(self)
  if self.commonResItem then
    self.commonResItem:OnBtnClick()
  end
end

local function ReInit(self, param)
  local renderName = UICommonResItemUtil.GetItemRenderByParam(param)
  if renderName then
    if self.commonResItem then
      self.commonResItem:OnDestroy()
      ObjectPool:GetInstance():Save(self.commonResItem)
      self.commonResItem = nil
    end
    local path = "UI.UICommonResItem.UICommonResItemV2." .. renderName
    local renderScript = require(path)
    if renderScript then
      local pooledItem = ObjectPool:GetInstance():Load(renderScript)
      if pooledItem then
        self.commonResItem = pooledItem
        self.commonResItem:SetHolder(self)
        self.commonResItem:OnCreate()
        if self.commonResItem ~= nil and type(self.commonResItem.SetSeasonType) == "function" then
          self.commonResItem:SetSeasonType(self.seasonType)
        end
        self.commonResItem:ReInit(param)
      end
    end
  end
end

local function ParseInfo(self, info)
  local data = DataCenter.RewardManager:ParseRewardInfo(info)
  if data then
    self:ReInit(data)
  end
  return data
end

local function SetItemIconImage(self, imageName)
  if self.item_icon and not string.IsNullOrEmpty(imageName) then
    self.item_icon:LoadSpriteAuto(imageName)
  end
end

local function SetItemQualityImage(self, imageName)
  self.qualityIndex = 1
  if imageName then
    if string.endswith(imageName, ".png") then
      local num = string.match(imageName, "%d+")
      if num then
        self.qualityIndex = toInt(num)
      end
    end
    self.item_quality:LoadSprite(imageName)
  end
end

local function SetItemCountActive(self, value)
  if self.num_text and self.itemCountActive ~= value then
    self.itemCountActive = value
    self.num_text.gameObject:SetActive(value)
  end
end

local function SetItemCount(self, value)
  if self.itemCount ~= value and self.num_text then
    self.itemCount = value
    if type(value) == "number" then
      self.num_text:SetText(string.GetFormattedStr(value))
    else
      self.num_text:SetText(value)
    end
    if self.num_text and not self.num_text:HasTextComponent() then
      Logger.LogError("commonresitem lost textComponent")
    end
  end
end

local function SetReceflagActive(self, value)
  local bool = value and true or false
  if self.rece_flag then
    self.rece_flag:SetActive(bool)
  end
end

local function SetItemCountColor(self, value)
  if self.num_text and value then
    self.num_text:SetColor(value)
  end
end

local function SetFlagActive(self, value)
  if self.flag and self.flagActive ~= value then
    self.flagActive = value
    self.flag:SetActive(value)
  end
end

local function SetFlagText(self, value)
  if self.flag_text and self.flagText ~= value then
    self.flagText = value
    self.flag_text:SetText(value)
  end
end

local function SetNameText(self, value, minSize, maxSize)
  if self.name_text then
    if self.nameText ~= value then
      self.nameText = value
      self.name_text:SetText(value)
    end
    if minSize then
      self.name_text:SetBestFitMinSize(minSize)
    else
      self.name_text:SetBestFitMinSize(12)
    end
    if maxSize then
      self.name_text:SetBestFitMaxSize(maxSize)
    else
      self.name_text:SetBestFitMaxSize(20)
    end
  end
end

local function GetResName(self)
  return self.nameText and self.nameText or ""
end

local function GetPosition(self)
  return self.btn.rectTransform.position
end

local function SetGray(self, isGray, canClick)
  CS.UIGray.SetGray(self.hero_quality.transform, isGray, canClick)
  CS.UIGray.SetGray(self.item_quality.transform, isGray, canClick)
  CS.UIGray.SetGray(self.item_icon.transform, isGray, canClick)
end

local function SetDelete(self, value)
  local bool = value and true or false
  if self.delete then
    self.delete:SetActive(bool)
  end
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(bool and 0.4 or 1)
  end
end

local function ShowResAdvance(self)
  if self.num_text and self.itemCount then
    if type(self.itemCount) == "number" then
      self.num_text:SetText(string.format("<color=#5fef87>%s</color>", string.GetFormattedStr(self.itemCount)))
    else
      self.num_text:SetText(string.format("<color=#5fef87>%s</color>", self.itemCount))
    end
  end
end

local function SetArrowState(self, show)
  if self.img_arrow then
    self.img_arrow:SetActive(show)
    self:CloseTweenSeq()
    if show then
      self.img_arrow:SetLocalScaleXYZ(0.9, 0.9, 0.9)
      self.img_arrow.transform.localPosition = Vector3.New(-38, 38)
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:AppendInterval(0.1)
      self.tweenSeq:Append(self.img_arrow.transform:DOLocalMoveY(48, 0.3)):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
    end
  end
end

local function CloseTweenSeq(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

local function SetImgQuailtyShow(self, show)
  local bool = show and true or false
  if self.item_quality then
    self.item_quality:SetActive(bool)
  end
end

local function SetDoubleMark(self, show)
  local bool = show and true or false
  if self.double_mark then
    self.double_mark:SetActive(bool)
  end
end

local function SetMultiMarkIcon(self, multiple)
  if not multiple then
    return
  end
  local multiNum = multiple
  local iconName = MultipleMarkIcon[multiNum] or DEFAULT_MULTIPLE_ICON
  if self.double_mark then
    self.double_mark:LoadSprite(string.format(LoadPath.UImystery, iconName))
  end
end

local function SetRewardMarkState(self, trainRewardState)
  if self.img_extra_mark then
    self.img_extra_mark:SetActive(trainRewardState == TrainRewardState.Extra)
  end
  if self.img_recapture_mark then
    self.img_recapture_mark:SetActive(trainRewardState == TrainRewardState.Recapture)
  end
end

local function SetCustomNumText(self, str)
  if self.num_text then
    self.num_text:SetText(str)
  end
end

local function SetCustomSelectIcon(self, path)
  if self.select then
    self.select:LoadSpriteAuto(path)
  end
end

local function ShowMultiMark(self, multiVal)
  if multiVal and 1 < multiVal then
    self:SetDoubleMark(true)
  end
end

local function HideMultiMark(self)
  self:SetDoubleMark(false)
end

local function ConvertGiftBoxQuality(self, quality)
  if quality == 1 or quality == 6 then
    return ItemColor.GREEN
  elseif quality == 2 then
    return ItemColor.BLUE
  elseif quality == 3 then
    return ItemColor.PURPLE
  elseif quality == 4 then
    return ItemColor.ORANGE
  elseif quality == 5 then
    return ItemColor.GOLDEN
  end
end

function UICommonResItem:SetSeasonType(seasonType)
  self.seasonType = seasonType
end

function UICommonResItem:SetRewardEffect(scale)
  local s = scale or 1
  if self.qualityIndex then
    local path = ""
    if self.qualityIndex == 5 then
      path = CommonRewardEffectQualityPath.Quality5
    else
      path = CommonRewardEffectQualityPath.Quality4
    end
    if self.effectResHandle ~= nil then
      self.effectResHandle:Destroy()
      self.effectResHandle = nil
    end
    if string.IsNullOrEmpty(path) then
      return
    end
    local request = CS.GameEntry.Resource:InstantiateAsync(path)
    self.effectResHandle = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.effectResHandle = nil
        return
      end
      request.gameObject:SetActive(true)
      local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if rectTransform ~= nil and self.item_icon then
        rectTransform:SetParent(self.item_icon.transform, false)
        rectTransform:Set_localScale(s, s, s)
        rectTransform:Set_anchoredPosition(0, 0)
      end
    end)
  end
end

function UICommonResItem:PlayAnimator(animationName)
  if self.anim then
    self.anim:Play(animationName, 0, 0)
  end
end

function UICommonResItem:SetRewardAlpha(value)
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(value)
  end
end

UICommonResItem.Param = Param
UICommonResItem.OnCreate = OnCreate
UICommonResItem.OnDestroy = OnDestroy
UICommonResItem.ComponentDefine = ComponentDefine
UICommonResItem.ComponentDestroy = ComponentDestroy
UICommonResItem.DataDefine = DataDefine
UICommonResItem.DataDestroy = DataDestroy
UICommonResItem.OnBtnClick = OnBtnClick
UICommonResItem.ReInit = ReInit
UICommonResItem.ParseInfo = ParseInfo
UICommonResItem.SetItemIconImage = SetItemIconImage
UICommonResItem.SetItemQualityImage = SetItemQualityImage
UICommonResItem.SetItemCountActive = SetItemCountActive
UICommonResItem.SetItemCount = SetItemCount
UICommonResItem.SetItemCountColor = SetItemCountColor
UICommonResItem.SetFlagActive = SetFlagActive
UICommonResItem.SetFlagText = SetFlagText
UICommonResItem.SetNameText = SetNameText
UICommonResItem.GetPosition = GetPosition
UICommonResItem.GetResName = GetResName
UICommonResItem.SetGray = SetGray
UICommonResItem.SetDelete = SetDelete
UICommonResItem.ShowResAdvance = ShowResAdvance
UICommonResItem.SetArrowState = SetArrowState
UICommonResItem.CloseTweenSeq = CloseTweenSeq
UICommonResItem.SetImgQuailtyShow = SetImgQuailtyShow
UICommonResItem.SetReceflagActive = SetReceflagActive
UICommonResItem.SetDoubleMark = SetDoubleMark
UICommonResItem.SetRewardMarkState = SetRewardMarkState
UICommonResItem.SetMultiMarkIcon = SetMultiMarkIcon
UICommonResItem.SetCustomNumText = SetCustomNumText
UICommonResItem.SetCustomSelectIcon = SetCustomSelectIcon
UICommonResItem.ShowMultiMark = ShowMultiMark
UICommonResItem.HideMultiMark = HideMultiMark
UICommonResItem.ConvertGiftBoxQuality = ConvertGiftBoxQuality
return UICommonResItem
