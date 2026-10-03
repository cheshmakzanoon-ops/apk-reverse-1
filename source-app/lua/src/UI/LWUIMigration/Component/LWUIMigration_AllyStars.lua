local base = UIBaseContainer
local LWUIMigration_AllyStars = BaseClass("LWUIMigration_AllyStars", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIMigration_AllyStars:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIMigration_AllyStars:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_AllyStars:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgStars = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTmpStarVal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnLWUIMigrationAllyStars = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnLWUIMigrationAllyStars:SetOnClick(function()
    self:OnBtnLWUIMigrationAllyStarsClick()
  end)
  self.compDropNode = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function LWUIMigration_AllyStars:ComponentDestroy()
  self.viewSkin = nil
  self.imgStars = nil
  self.textTmpStarVal = nil
  self.btnLWUIMigrationAllyStars = nil
  self.compDropNode = nil
end

function LWUIMigration_AllyStars:DataDefine()
end

function LWUIMigration_AllyStars:DataDestroy()
  self.scoreInfo = nil
end

function LWUIMigration_AllyStars:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigration_AllyStars:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIMigration_AllyStars:SetStars(scoreInfo)
  self.scoreInfo = scoreInfo
  local count = self.scoreInfo and self.scoreInfo.comprehensiveScore or 0
  local nCount = tonumber(count) or 0
  nCount = Mathf.Clamp(nCount, 0.0, 5.0)
  self.textTmpStarVal:SetText(string.format("%.1f", nCount))
  local starSize = 36
  local totalWidth = 36 * nCount
  self.imgStars:SetSizeDeltaXY(totalWidth, starSize)
end

function LWUIMigration_AllyStars:OnBtnLWUIMigrationAllyStarsClick()
  if not self.scoreInfo then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationScoreTips, {anim = true}, {
    position = self.compDropNode:GetPosition(),
    offset = {
      0,
      -70,
      -20,
      40
    },
    scores = {
      self.scoreInfo.allianceScore or 0,
      self.scoreInfo.powerScore or 0,
      self.scoreInfo.rewardScore or 0,
      self.scoreInfo.dailyTaskScore or 0
    }
  })
end

return LWUIMigration_AllyStars
