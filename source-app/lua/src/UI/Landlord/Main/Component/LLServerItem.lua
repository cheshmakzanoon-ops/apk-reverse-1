local base = UIBaseContainer
local LLServerItem = BaseClass("LLServerItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LLServerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLServerItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLServerItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgSIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgSBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textS = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compTop = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compMore = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compHead = self.viewSkin:AddComponent(self, UICommonHead, 6)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.compHead:SetEnableClickShowInfo(true, true)
end

function LLServerItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgSIcon = nil
  self.imgSBg = nil
  self.textS = nil
  self.compTop = nil
  self.compMore = nil
  self.compHead = nil
  self.btn = nil
end

function LLServerItem:DataDefine()
end

function LLServerItem:DataDestroy()
  self.sInfo = nil
end

function LLServerItem:OnAddListener()
  base.OnAddListener(self)
end

function LLServerItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLServerItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.sInfo ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.sInfo.serverId)
  end
end

function LLServerItem:SetShowMore()
  self.compMore:SetActive(true)
end

function LLServerItem:SetServer(sInfo, group, stage)
  self.sInfo = sInfo
  self.imgSBg:SetActive(sInfo ~= nil)
  self.btn:SetActive(sInfo ~= nil)
  if sInfo == nil then
    self.imgSIcon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, LLConst.IMG_DEFAULT_SERVER_ICON))
    self.compMore:SetActive(group == LLConst.LandLordGroup.LORD)
    self.compTop:SetActive(false)
  else
    local sIcon = sInfo.icon
    if string.IsNullOrEmpty(sIcon) then
      sIcon = 511001
    end
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(sIcon)
    if itemCfg then
      self.imgSIcon:LoadSpriteAuto(string.format(LoadPath.ItemPath, itemCfg.icon))
    else
      self.imgSIcon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, LLConst.IMG_DEFAULT_SERVER_ICON))
    end
    self.textS:SetText(UIUtil.FormatServerName(sInfo.serverId))
    local path = LLConst.IMG_DEFAULT_SERVER_DI_HUI
    if group ~= LLConst.LandLordGroup.NONE then
      path = group == LLConst.LandLordGroup.LORD and LLConst.IMG_DEFAULT_SERVER_DI_LAN or LLConst.IMG_DEFAULT_SERVER_DI_HONG
    end
    self.imgSBg:LoadSpriteAuto(string.format(LoadPath.LandlordPath, path))
    self.compMore:SetActive(false)
    local king = sInfo.king
    self.compTop:SetActive(king ~= nil)
    if king ~= nil then
      local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(king.headSkinId, king.headSkinET)
      if not string.IsNullOrEmpty(headBgImg) and not string.startswith(headBgImg, "Assets/") then
        headBgImg = nil
      end
      self.compHead:SetHead(king.uid, king.pic, king.picVer, false, headBgImg)
    end
  end
end

function LLServerItem:HideTop()
  self.compTop:SetActive(false)
end

function LLServerItem:ShowMore(bShow)
  self.compMore:SetActive(bShow)
end

return LLServerItem
