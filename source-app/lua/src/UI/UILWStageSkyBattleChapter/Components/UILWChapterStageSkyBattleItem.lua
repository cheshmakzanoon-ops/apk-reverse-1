local base = UIBaseContainer
local UILWChapterStageSkyBattleItem = BaseClass("UILWChapterStageSkyBattleItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWChapterStageSkyBattleItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWChapterStageSkyBattleItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWChapterStageSkyBattleItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compNext = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 2)
  self.compLock = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compPass = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compSpecial = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.canvasGroup = self.viewSkin:AddComponent(self, UICanvasGroup, 8)
  self.compPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.imgPathline2 = self.viewSkin:AddComponent(self, UIImage, 10)
  self.imgPathline1 = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgPointIconGold = self.viewSkin:AddComponent(self, UIImage, 12)
  self.imgPointIconWhite = self.viewSkin:AddComponent(self, UIImage, 13)
  self.imgStar1 = self.viewSkin:AddComponent(self, UIImage, 14)
  self.imgStar2 = self.viewSkin:AddComponent(self, UIImage, 15)
  self.imgStar3 = self.viewSkin:AddComponent(self, UIImage, 16)
end

function UILWChapterStageSkyBattleItem:ComponentDestroy()
  self.viewSkin = nil
  self.compNext = nil
  self.compUIPlayerHead = nil
  self.compLock = nil
  self.compPass = nil
  self.compSpecial = nil
  self.textName = nil
  self.btnClick = nil
  self.canvasGroup = nil
  self.compPoint = nil
  self.imgPathline2 = nil
  self.imgPathline1 = nil
  self.imgPointIconGold = nil
  self.imgPointIconWhite = nil
  self.imgStar1 = nil
  self.imgStar2 = nil
  self.imgStar3 = nil
end

function UILWChapterStageSkyBattleItem:DataDefine()
end

function UILWChapterStageSkyBattleItem:DataDestroy()
  self.growthMode = nil
  self.onClick = nil
  if self.fadeTween then
    self.fadeTween:Kill()
  end
  self.fadeTween = nil
  if self.dropTween then
    self.dropTween:Kill()
  end
  self.dropTween = nil
end

function UILWChapterStageSkyBattleItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWChapterStageSkyBattleItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWChapterStageSkyBattleItem:Refresh(chapter, stageId, growthMode)
  self.growthMode = growthMode
  self.compNext:SetActive(false)
  self.compLock:SetActive(false)
  self.compPass:SetActive(false)
  self.compSpecial:SetActive(false)
  self.textName:SetActive(false)
  self.imgPointIconGold:SetActive(false)
  self.imgPointIconWhite:SetActive(false)
  self.imgStar1:SetActive(false)
  self.imgStar2:SetActive(false)
  self.imgStar3:SetActive(false)
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  local chapterCfgData = mgr:GetChapterCfgData(chapter)
  local isPassed = mgr.doneStageIds[stageId] == true
  self.imgPathline2:SetActive(isPassed)
  self.imgPathline1:SetActive(not isPassed)
  local special = tonumber(LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "special_level")) or 0
  if special == 1 then
    self.compSpecial:SetActive(true)
    self:__FadeIn(false)
    self.imgPointIconWhite:SetActive(true)
    return
  end
  local isNext = mgr.nextStageId == stageId
  if isNext then
    self.compNext:SetActive(true)
    self.compUIPlayerHead:SetAsMyself()
    self.imgPointIconGold:SetActive(true)
    self:__FadeIn(true)
    return
  end
  self.textName:SetActive(true)
  local order = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "order")
  self.textName:SetText(string.format("%d-%d", tonumber(chapter), tonumber(order)))
  if isPassed then
    self.compPass:SetActive(true)
    self.imgPointIconWhite:SetActive(true)
    local chapterExtraData = chapterCfgData.stageExtraInfos
    for i, extraData in ipairs(chapterExtraData) do
      if extraData.stageId == stageId then
        local starNum = extraData.star or 0
        self.imgStar1:SetActive(0 < starNum)
        self.imgStar2:SetActive(1 < starNum)
        self.imgStar3:SetActive(2 < starNum)
      end
    end
    return
  end
  self.compLock:SetActive(true)
  self.imgPointIconWhite:SetActive(true)
  self:__FadeIn(false)
end

function UILWChapterStageSkyBattleItem:__FadeIn(drop)
  if self.fadeTween then
    self.fadeTween:Kill()
  end
  self.canvasGroup:SetAlpha(0)
  self.fadeTween = self.canvasGroup:FadeIn(1, 0.5)
  if self.dropTween then
    self.dropTween:Kill()
  end
  if drop then
    self.compNext.transform.anchoredPosition = Vector2.New(0, 50)
    self.dropTween = self.compNext.transform:DOAnchorPosY(0, 0.25):SetDelay(0.25):SetEase(CS.DG.Tweening.Ease.InQuad)
  end
end

function UILWChapterStageSkyBattleItem:OnBtnClickClick()
  if self.onClick then
    self.onClick()
  end
end

function UILWChapterStageSkyBattleItem:SetOnClick(onClick)
  self.onClick = onClick
end

return UILWChapterStageSkyBattleItem
