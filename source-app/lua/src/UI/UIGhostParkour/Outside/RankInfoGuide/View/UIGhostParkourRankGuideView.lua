local UIGhostParkourRankGuideView = BaseClass("UIGhostParkourRankGuideView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIGhostParkourRankGuideView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:UpdateLogo()
  CommonUtil.PlayerPrefsSetBool(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_RANK_PAGE, false)
end

function UIGhostParkourRankGuideView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRankGuideView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRankName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.rawImgImgLogo = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.rawImgImgLogoBg = self.viewSkin:AddComponent(self, UIRawImage, 5)
end

function UIGhostParkourRankGuideView:ComponentDestroy()
  self.viewSkin = nil
  self.textRankName = nil
  self.rawImgImgLogo = nil
  self.textDesc = nil
  self.btnClose = nil
  self.rawImgImgLogoBg = nil
end

function UIGhostParkourRankGuideView:DataDefine()
  self.tier = self:GetUserData()
end

function UIGhostParkourRankGuideView:DataDestroy()
end

function UIGhostParkourRankGuideView:OnAddListener()
  base.OnAddListener(self)
end

function UIGhostParkourRankGuideView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGhostParkourRankGuideView:OnBtnCloseClick()
  EventManager:GetInstance():Broadcast(EventId.GhostParkourGuideRefresh)
  self.ctrl:CloseSelf()
end

function UIGhostParkourRankGuideView:UpdateLogo()
  self.textDesc:SetLocalText("ghost_parkour_guide_instructions")
  if self.tier then
    local config = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(self.tier)
    local rankName = ""
    local bgPath = ""
    if config then
      rankName = config.tier_name
      bgPath = config.big_icon_bg
    end
    self.rawImgImgLogoBg:LoadSpriteAsyncWithCallback(bgPath, function(sprite)
      if self.rawImgImgLogoBg then
        self.rawImgImgLogoBg:SetNativeSize()
      end
    end)
    self.textRankName:SetLocalText(rankName)
  end
end

return UIGhostParkourRankGuideView
