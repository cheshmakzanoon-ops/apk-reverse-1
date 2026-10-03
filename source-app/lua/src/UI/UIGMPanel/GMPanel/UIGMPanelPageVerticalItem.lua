local base = UIBaseContainer
local UIGMPanelPageVerticalItem = BaseClass("UIGMPanelPageVerticalItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIGMPanelPageVerticalItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMPanelPageVerticalItem:OnDestroy()
  self.data = nil
  self.index = nil
  if self.dComponent then
    self.dComponent:Delete()
    self.dComponent = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelPageVerticalItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTmpName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnTips = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnTips:SetOnClick(function()
    self:OnBtnTipsClick()
  end)
  self.compCommonRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compDynamicRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.btnFav = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnFav:SetOnClick(function()
    self:OnBtnFavClick()
  end)
  self.imgFav = self.viewSkin:AddComponent(self, UIImage, 8)
end

function UIGMPanelPageVerticalItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIcon = nil
  self.textTmpName = nil
  self.btnTips = nil
  self.compCommonRoot = nil
  self.compDynamicRoot = nil
  self.btnFav = nil
  self.imgFav = nil
end

function UIGMPanelPageVerticalItem:DataDefine()
end

function UIGMPanelPageVerticalItem:DataDestroy()
end

function UIGMPanelPageVerticalItem:OnAddListener()
  base.OnAddListener(self)
end

function UIGMPanelPageVerticalItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMPanelPageVerticalItem:ReInitCommon()
  if self.data then
    self.compCommonRoot:SetActive(true)
    self:RefreshSkin()
    if type(self.data.name) == "function" then
      self.textTmpName:SetText(self.data.name())
    else
      self.textTmpName:SetText(self.data.name)
    end
    self.imgBg:SetActive(self.index % 2 == 0)
    if self.data.tips then
      self.btnTips:SetActive(true)
    else
      self.btnTips:SetActive(false)
    end
  else
    self.compCommonRoot:SetActive(false)
  end
  self:RefreshFavState()
end

function UIGMPanelPageVerticalItem:GetCurrentDynamicRenderer()
end

function UIGMPanelPageVerticalItem:ReInitDynamic()
  local wantStyle = self.data and self.data.style
  if self.currentStyle == wantStyle then
    if self.dComponent then
      self.dComponent:SetActive(true)
      self.dComponent:ReInit(self.data, self)
    end
  elseif wantStyle then
    if self.dComponent then
      self.dComponent:Delete()
      self.dComponent = nil
    end
    self.currentStyle = wantStyle
    self.dComponent = UIAsyncLoaderBridge.New(self, "dComponent", self.compDynamicRoot.transform, self.currentStyle.prefab, self.currentStyle.lua, false, Bind(self, self.ReInitDynamic))
    self.dComponent:SetActive(true)
  elseif self.dComponent then
    self.dComponent:SetActive(false)
  end
end

function UIGMPanelPageVerticalItem:ReInit(index, data)
  self.data = data
  self.index = index
  self:ReInitCommon()
  self:ReInitDynamic()
end

function UIGMPanelPageVerticalItem:OnBtnTipsClick()
  if self.data and self.data.tips then
    self.data.tips(self.dComponent)
  end
end

function UIGMPanelPageVerticalItem:RefreshFavState()
  if self.data then
    if not self.data.pageName or not self.data.name then
      self.btnFav:SetActive(false)
      return
    end
    self.btnFav:SetActive(true)
    local favImg = DataCenter.GMManager:IsInFav(self.data) and "Assets/Main/Sprites/UI/GMPanel/gmFav1.png" or "Assets/Main/Sprites/UI/GMPanel/gmFav0.png"
    self.imgFav:LoadSpriteAuto(favImg)
  end
end

function UIGMPanelPageVerticalItem:OnBtnFavClick()
  if not (self.data and self.data.pageName) or not self.data.name then
    return
  end
  local inFav = DataCenter.GMManager:IsInFav(self.data)
  if inFav and DataCenter.GMManager:RemoveFav(self.data) then
    UIUtil.ShowTips("\228\187\142\230\148\182\232\151\143\228\184\173\231\167\187\233\153\164")
    self:RefreshFavState()
    EventManager:GetInstance():Broadcast(EventId.GM_Fav_Refresh)
  elseif not inFav and DataCenter.GMManager:AddFav(self.data) then
    UIUtil.ShowTips("\229\183\178\229\138\160\229\133\165\230\148\182\232\151\143\229\164\185")
    self:RefreshFavState()
    EventManager:GetInstance():Broadcast(EventId.GM_Fav_Refresh)
  end
end

function UIGMPanelPageVerticalItem:RefreshSkin(skin)
  if not self.data then
    return
  end
  local icon = self.data.iconGet and self.data.iconGet() or self.data.icon
  skin = skin or GMUtils.GetSkinPath()
  self.imgIcon:LoadSpriteAuto(icon)
  self.imgIcon:SetAspectSize(80)
  if self.dComponent then
    self.dComponent:RefreshSkin(skin)
  end
end

return UIGMPanelPageVerticalItem
