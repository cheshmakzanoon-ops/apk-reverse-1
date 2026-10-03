local base = UIBaseContainer
local AllianceRateStarItem = BaseClass("AllianceRateStarItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local DEFAULT_FILL_AMOUNT = 0.5

function AllianceRateStarItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceRateStarItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceRateStarItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgStarImg1 = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgStarImg2 = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgStarImg3 = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgStarImg4 = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgStarImg5 = self.viewSkin:AddComponent(self, UIImage, 6)
  self.btnStarItem = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnStarItem:SetOnClick(function()
    self:OnBtnStarItemClick()
  end)
  self.compRateTextCenter = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compTipsIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.imgStarImgList = {
    self.imgStarImg1,
    self.imgStarImg2,
    self.imgStarImg3,
    self.imgStarImg4,
    self.imgStarImg5
  }
end

function AllianceRateStarItem:ComponentDestroy()
  self.viewSkin = nil
  self.textRate = nil
  self.imgStarImg1 = nil
  self.imgStarImg2 = nil
  self.imgStarImg3 = nil
  self.imgStarImg4 = nil
  self.imgStarImg5 = nil
  self.btnStarItem = nil
  self.compRateTextCenter = nil
  self.compTipsIcon = nil
  self.imgStarImgList = nil
end

function AllianceRateStarItem:DataDefine()
  self.scoreInfo = {}
  self.isClick = true
end

function AllianceRateStarItem:DataDestroy()
  self.scoreInfo = nil
  self.isClick = nil
end

function AllianceRateStarItem:OnBtnStarItemClick()
  if not self.isClick then
    return
  end
  local param = {}
  param.width = 376
  param.alignObject = self.compRateTextCenter
  param.yPosFix = -35
  param.xPadding = 20
  param.showArrow = true
  param.preferTop = true
  param.isMyChat = true
  param.chatThemeIndex = 1
  param.scoreInfo = self.scoreInfo or {}
  if not IsNull(self.compTipsIcon) and not IsNull(self.compTipsIcon.transform) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatAllianceInviteScoreTip, {anim = true}, param)
  end
end

function AllianceRateStarItem:RefreshByBaseInfo(scoreInfo)
  local pointNum = scoreInfo.comprehensiveScore or 0
  self.scoreInfo = scoreInfo
  self:RefreshTipsIcon()
  self.textRate:SetText(Mathf.RoundTo(pointNum, 1))
  for index, imgStarImg in ipairs(self.imgStarImgList) do
    local point_diff = pointNum - index + 1
    if 0 < point_diff then
      imgStarImg:SetActive(true)
      if 1 <= point_diff then
        imgStarImg:SetFillAmount(1)
      else
        imgStarImg:SetFillAmount(DEFAULT_FILL_AMOUNT)
      end
    else
      imgStarImg:SetActive(false)
    end
  end
end

function AllianceRateStarItem:RefreshTipsIcon()
  local scoreInfo = self.scoreInfo
  if not (self.scoreInfo.allianceScore and self.scoreInfo.powerScore and self.scoreInfo.rewardScore) or not self.scoreInfo.dailyTaskScore then
    self.compTipsIcon:SetActive(false)
    self.isClick = false
    return
  end
  if (not scoreInfo.r4LimitScore or scoreInfo.r4LimitScore == 0) and (not scoreInfo.blackIndustryScore or scoreInfo.blackIndustryScore == 0) then
    self.compTipsIcon:SetActive(false)
    self.isClick = true
    return
  end
  self.compTipsIcon:SetActive(true)
  self.isClick = true
end

return AllianceRateStarItem
