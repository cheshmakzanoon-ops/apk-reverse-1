local base = UIBaseContainer
local FishBookItemComponent = BaseClass("FishBookItemComponent", UIBaseContainer)

function FishBookItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FishBookItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FishBookItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgIcon = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textWeight = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnLWInfoCircle = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnLWInfoCircle:SetOnClick(function()
    self:OnBtnLWInfoCircleClick()
  end)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnFishBookItem = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnFishBookItem:SetOnClick(function()
    self:OnBtnFishBookItemClick()
  end)
  self.compLock = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compUnlock = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.rawImgMask = self.viewSkin:AddComponent(self, UIRawImage, 9)
  self.textRankNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgRank = self.viewSkin:AddComponent(self, UIImage, 11)
end

function FishBookItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgIcon = nil
  self.textName = nil
  self.textWeight = nil
  self.btnLWInfoCircle = nil
  self.btnRank = nil
  self.btnFishBookItem = nil
  self.compLock = nil
  self.compUnlock = nil
  self.rawImgMask = nil
  self.textRankNum = nil
  self.imgRank = nil
end

function FishBookItemComponent:DataDefine()
end

function FishBookItemComponent:DataDestroy()
end

function FishBookItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function FishBookItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FishBookItemComponent:OnBtnLWInfoCircleClick()
  local meta = DataCenter.FishMetaManager:GetMeta(self.fishId)
  if meta then
    local minWeight, maxWeight = DataCenter.FishMetaManager:GetMinMaxWeight()
    minWeight = minWeight * meta.base_weight
    maxWeight = maxWeight * meta.base_weight
    local weightStr = string.format(meta.weight_type == 1 and "%.2fg - %.2fg" or "%.2fkg - %.2fkg", minWeight, maxWeight)
    UIUtil.ShowBubbleTipsAuto(weightStr, self.btnLWInfoCircle.transform.position, 14, -40, 0, nil, nil)
  end
end

function FishBookItemComponent:OnBtnRankClick()
  DataCenter.LWSoundManager:PlaySound(6100024, false)
  SFSNetwork.SendMessage(MsgDefines.SeasonFishGetFishRank, self.fishId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishRank, {anim = true}, self.fishId)
end

function FishBookItemComponent:OnBtnFishBookItemClick()
  DataCenter.LWSoundManager:PlaySound(6100021, false)
  local x = self.transform.position.x
  local y = self.transform.position.y
  local width = self.rectTransform.rect.width
  local height = self.rectTransform.rect.height
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishPondTip, {anim = true}, self.fishId, x, y, width, height)
end

function FishBookItemComponent:SetData(index, fishId)
  self.index = index
  self.fishId = fishId
  local meta = DataCenter.FishMetaManager:GetMeta(self.fishId)
  local data = DataCenter.FishingDataManager:GetMyFish(self.fishId)
  if meta then
    self.textName:SetLocalText(meta.name)
  end
  if data then
    self.compUnlock:SetActive(true)
    self.compLock:SetActive(false)
    local weightUnit = meta.weight_type == 1 and "%.2fg" or "%.2fkg"
    self.textWeight:SetText(string.format(weightUnit, data.hisMaxWeight))
    if not string.IsNullOrEmpty(meta.pic) then
      self.rawImgIcon:LoadSpriteAsyncWithCallback(meta.pic, function()
        if self.rawImgIcon then
          self.rawImgIcon:SetNativeSize()
        end
      end)
    end
    local scale = meta.collect_proportion or 1
    self.rawImgIcon:SetLocalScaleXYZ(scale * 0.66, scale * 0.66, scale * 0.66)
    if data.rank and data.rank > 0 then
      self.imgRank:SetActive(true)
      self.imgRank:LoadSpriteAsync(string.format("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang0%s.png", data.rank))
      self.textRankNum:SetText(data.rank)
    else
      self.imgRank:SetActive(false)
    end
  else
    self.compUnlock:SetActive(false)
    self.compLock:SetActive(true)
    if not string.IsNullOrEmpty(meta.pic) then
      self.rawImgMask:LoadSpriteAsyncWithCallback(meta.pic, function()
        if self.rawImgMask then
          self.rawImgMask:SetNativeSize()
        end
      end)
    end
    local scale = meta.collect_proportion or 1
    self.rawImgMask:SetLocalScaleXYZ(scale * 0.66, scale * 0.66, scale * 0.66)
  end
end

return FishBookItemComponent
