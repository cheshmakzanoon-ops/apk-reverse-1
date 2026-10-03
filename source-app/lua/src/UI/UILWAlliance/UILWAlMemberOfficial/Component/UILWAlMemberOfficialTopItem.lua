local UILWAlMemberOfficialTopItem = BaseClass("UILWAlMemberOfficialTopItem", UIBaseContainer)
local base = UIBaseContainer

function UILWAlMemberOfficialTopItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberOfficialTopItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberOfficialTopItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "")
  self.emptyIcon = self:AddComponent(UIBaseComponent, "Head/PlayerBtn/EmptyIcon")
  self.head = self:AddComponent(UICommonHead, "Head/PlayerBtn/UIPlayerHead")
  self.head:SetEnableClickShowInfo(true, true)
end

function UILWAlMemberOfficialTopItem:ComponentDestroy()
end

function UILWAlMemberOfficialTopItem:DataDefine()
end

function UILWAlMemberOfficialTopItem:DataDestroy()
end

function UILWAlMemberOfficialTopItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberOfficialTopItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberOfficialTopItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberOfficialTopItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberOfficialTopItem:SetData(type, playerInfo)
  self.icon:LoadSprite(LWAlMemberOffcialParam[type].Icon)
  if playerInfo then
    self.emptyIcon:SetActive(false)
    self.head:SetActive(true)
    local userId = playerInfo.uid
    local userPic = playerInfo.pic
    local userPicVer = playerInfo.picVer
    local headBg = playerInfo.headBg
    if playerInfo.GetHeadBgImg then
      headBg = playerInfo:GetHeadBgImg()
    end
    self.head:SetData(userId, userPic, userPicVer, true, headBg)
  else
    self.emptyIcon:SetActive(true)
    self.head:SetActive(false)
  end
end

return UILWAlMemberOfficialTopItem
