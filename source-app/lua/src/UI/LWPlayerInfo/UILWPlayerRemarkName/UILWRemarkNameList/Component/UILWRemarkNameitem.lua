local UILWRemarkNameitem = BaseClass("UILWRemarkNameitem", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "ImgBg/PlayerName",
    name = "PlayerName",
    type = UIText
  },
  {
    path = "ImgBg",
    name = "BtnClick",
    type = UIButton,
    onClick = function(self)
      self:OnBtnClick()
    end
  },
  {
    path = "ImgBg/UIPlayerHead",
    name = "PlayerHead",
    type = UICommonHead
  },
  {
    path = "ImgBg/ServeName",
    name = "ServeName",
    type = UIText
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self.playerUid = 0
end

local function OnDestroy(self)
  base.OnDestroy(self)
  self:ClearCompsByBook(compBook)
  self.playerUid = 0
end

local function OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnRefreshUserInfo)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnRefreshUserInfo)
end

local function OnRefreshUserInfo(self, uid)
  self.PlayerName:SetText(self.remarkName)
  if self.playerUid == uid then
    local userInfo = ChatInterface.getUserData(self.playerUid)
    if self.PlayerHead and userInfo then
      self.PlayerHead:SetData(userInfo.uid, userInfo.headPic, userInfo.headPicVer)
      self.ServeName:SetLocalText(208236, userInfo:getServerId())
    end
  end
end

local function SetItemShow(self, uid, remarkName)
  self.playerUid = uid
  self.remarkName = remarkName
  self:OnRefreshUserInfo(uid)
end

local function OnBtnClick(self)
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.playerUid)
end

UILWRemarkNameitem.OnCreate = OnCreate
UILWRemarkNameitem.OnDestroy = OnDestroy
UILWRemarkNameitem.OnAddListener = OnAddListener
UILWRemarkNameitem.OnRemoveListener = OnRemoveListener
UILWRemarkNameitem.SetItemShow = SetItemShow
UILWRemarkNameitem.OnBtnClick = OnBtnClick
UILWRemarkNameitem.OnRefreshUserInfo = OnRefreshUserInfo
return UILWRemarkNameitem
