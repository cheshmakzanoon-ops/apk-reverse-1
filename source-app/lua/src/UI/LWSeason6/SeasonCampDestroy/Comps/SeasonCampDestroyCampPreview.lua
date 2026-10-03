local base = UIAsyncContainer
local SeasonCampDestroyCampPreview = BaseClass("SeasonCampDestroyCampPreview", base)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyCampPreview:OnCreate(view)
  base.OnCreate(self)
  self.view = view
  self:DataDefine()
  self:ComponentDefine()
end

function SeasonCampDestroyCampPreview:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyCampPreview:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compSeasonCampDestroyCampPreview = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.imgCampProgress0 = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgCampProgress1 = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textTmpRatio0 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpRatio1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compRect = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.btnToggle = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnToggle:SetOnClick(function()
    self:OnBtnToggleClick()
  end)
  self.compProgressBg = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textTmpToggleName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgCampIcon0 = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgCampIcon1 = self.viewSkin:AddComponent(self, UIImage, 12)
  self.btnShowCampStatus = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnShowCampStatus:SetOnClick(function()
    self:OnBtnShowCampStatusClick()
  end)
  self.imgCampIcon0:LoadSpriteAuto(SeasonUtil.GetSeason6CampMidIconPath(SeasonFactionType.Rebels))
  self.imgCampIcon1:LoadSpriteAuto(SeasonUtil.GetSeason6CampMidIconPath(SeasonFactionType.Gendarmerie))
  self.textTmpNotice:SetLocalText("season_s6_activity_1200112_desc02")
  self.textTmpToggleName:SetLocalText("season_s6_activity_1200116_btn_01")
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
  self.rawSize = self.compProgressBg:GetSizeDelta()
  self.rawSize.y = self.rawSize.y - 10
  self:RefreshServerMode()
end

function SeasonCampDestroyCampPreview:ComponentDestroy()
  self.viewSkin = nil
  self.compSeasonCampDestroyCampPreview = nil
  self.imgCampProgress0 = nil
  self.imgCampProgress1 = nil
  self.textTmpRatio0 = nil
  self.textTmpRatio1 = nil
  self.textTmpNotice = nil
  self.compRect = nil
  self.btnToggle = nil
  self.compProgressBg = nil
  self.textTmpToggleName = nil
  self.imgCampIcon0 = nil
  self.imgCampIcon1 = nil
  self.btnShowCampStatus = nil
end

function SeasonCampDestroyCampPreview:DataDefine()
  self.mgr = DataCenter.SeasonCampDestroyManager
end

function SeasonCampDestroyCampPreview:DataDestroy()
  self.mgr = nil
  self.view = nil
end

function SeasonCampDestroyCampPreview:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyCampPreview:OnRemoveListener()
  base.OnRemoveListener(self)
end

local campColor1 = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lv.png"
local campColor2 = "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_tongyong_jindutiao_lan.png"
local campColor_blue = "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_tongyong_jindutiao_lan.png"
local campColor_red = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_tongyong_jindutiao_hong.png"

function SeasonCampDestroyCampPreview:Refresh()
  if not self.mgr then
    return
  end
  local camp1 = self.mgr:GetCampInfoByType(SeasonFactionType.Rebels)
  local camp2 = self.mgr:GetCampInfoByType(SeasonFactionType.Gendarmerie)
  if camp1 and camp2 then
    local totalScore = camp1.score + camp2.score
    local ratio_0, ratio_1
    if 0 < totalScore then
      ratio_0 = camp1.score / totalScore
      ratio_1 = 1 - ratio_0
    else
      ratio_0 = 0.5
      ratio_1 = 0.5
    end
    local min = 0.08
    if ratio_0 < min then
      ratio_0 = min
      ratio_1 = 1 - ratio_0
    elseif min > ratio_1 then
      ratio_1 = min
      ratio_0 = 1 - ratio_1
    end
    self.compRect:SetActive(true)
    self.imgCampProgress0:SetSizeDeltaXY(self.rawSize.x * ratio_0, self.rawSize.y)
    self.imgCampProgress1:SetSizeDeltaXY(self.rawSize.x * ratio_1, self.rawSize.y)
    self.textTmpRatio0:SetText(string.GetFormattedSeparatorNum(camp1.score))
    self.textTmpRatio1:SetText(string.GetFormattedSeparatorNum(camp2.score))
    local myCamp = DataCenter.SeasonFactionWarDataManager.myCampId
    local camp1Sp = myCamp == SeasonFactionType.Rebels and campColor_blue or campColor_red
    local camp2Sp = myCamp == SeasonFactionType.Gendarmerie and campColor_blue or campColor_red
    self.imgCampProgress0:LoadSpriteAuto(camp1Sp)
    self.imgCampProgress1:LoadSpriteAuto(camp2Sp)
  else
    self.compRect:SetActive(false)
  end
end

function SeasonCampDestroyCampPreview:RefreshServerMode()
  local serverMode = self.view and self.view:IsServerMode()
  self.btnToggle:SetIconVisible(not serverMode)
end

function SeasonCampDestroyCampPreview:OnBtnToggleClick()
  local serverMode = self.view and self.view:IsServerMode()
  self.view:SetServerMode(not serverMode)
end

function SeasonCampDestroyCampPreview:OnBtnShowCampStatusClick()
  local uiParam = {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, uiParam, 3)
end

return SeasonCampDestroyCampPreview
