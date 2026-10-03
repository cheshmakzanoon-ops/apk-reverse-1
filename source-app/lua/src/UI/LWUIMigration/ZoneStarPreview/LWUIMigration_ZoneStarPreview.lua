local LWUIMigration_ZoneStarPreview = BaseClass("LWUIMigration_ZoneStarPreview", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIMigration_AllyTagItem = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyTagItem")
local LWUIMigration_DesertTimeSelection = require("UI.LWUIMigration.Component.LWUIMigration_DesertTimeSelection")

function LWUIMigration_ZoneStarPreview:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshView()
end

function LWUIMigration_ZoneStarPreview:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_ZoneStarPreview:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpName0 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmpName1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpName2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpName3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpName4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTmpName5 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTmpName6 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textTmpCityLv = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTmpCityName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTmpTopTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textTmpBottomTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgSmallIcon = self.viewSkin:AddComponent(self, UIImage, 13)
  self.imgIconStar = self.viewSkin:AddComponent(self, UIImage, 14)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle:SetLocalText("migration_activity_recommend_limit30_1001")
  self.textTmpName0:SetText("???")
  self.textTmpName1:SetText("???")
  self.textTmpName2:SetText("???")
  self.textTmpName3:SetText("???")
  self.textTmpName4:SetText("???")
  self.textTmpName5:SetLocalText("208236", self.serverId)
  self.textTmpName6:SetText("???")
  self.textTmpCityLv:SetText("7")
  self.textTmpCityName:SetLocalText("302304")
  self.textTmpTopTips:SetLocalText("migration_activity_recommend_limit30_1003")
  self.textTmpBottomTips:SetLocalText("migration_activity_recommend_limit30_1002")
end

function LWUIMigration_ZoneStarPreview:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textTmpName0 = nil
  self.textTmpName1 = nil
  self.textTmpName2 = nil
  self.textTmpName3 = nil
  self.textTmpName4 = nil
  self.textTmpName5 = nil
  self.textTmpName6 = nil
  self.textTmpCityLv = nil
  self.textTmpCityName = nil
  self.textTmpTopTips = nil
  self.textTmpBottomTips = nil
  self.imgSmallIcon = nil
  self.imgIconStar = nil
  self.btnPanel = nil
  self.btnClose = nil
end

function LWUIMigration_ZoneStarPreview:DataDefine()
  local args = self:GetUserData() or {}
  self.zoneStar = args.star or 0
  self.serverId = args.serverId or 0
end

function LWUIMigration_ZoneStarPreview:DataDestroy()
end

function LWUIMigration_ZoneStarPreview:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigration_ZoneStarPreview:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIMigration_ZoneStarPreview:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIMigration_ZoneStarPreview:RefreshView()
  if self.zoneStar then
    local cfg = LocalController:instance():getLine(TableName.LW_Migration_Zone_Star, self.zoneStar)
    if cfg then
      self.imgSmallIcon:LoadSpriteAuto(cfg.icon)
      self.imgSmallIcon:SetAspectSize(74)
      self.imgIconStar:LoadSpriteAuto(cfg.icon)
      self.imgIconStar:SetAspectSize(135)
    end
  end
end

function LWUIMigration_ZoneStarPreview:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return LWUIMigration_ZoneStarPreview
