local base = UIBaseContainer
local LWFollowItem = BaseClass("LWFollowItem", base)
local bluePath = "Assets/Main/Sprites/UI/LWCommon/Sprite/common_btn_blue.png"
local path = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png"

function LWFollowItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWFollowItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWFollowItem:OnEnable()
  base.OnEnable(self)
end

function LWFollowItem:OnDisable()
  base.OnDisable(self)
end

function LWFollowItem:ComponentDefine()
  self._server_txt = self:AddComponent(UIText, "Rect_Normal/Txt_Server")
  self._name_txt = self:AddComponent(UIText, "Rect_Normal/Txt_Name")
  self.headIconN = self:AddComponent(UICommonHead, "Rect_Normal/UIPlayerHead")
  self.headFgN = self:AddComponent(UIImage, "Rect_Normal/UIPlayerHead/Foreground")
  self.btn_txt = self:AddComponent(UIText, "Rect_Normal/challengeBtn/BtnTxt")
  self.btn = self:AddComponent(UIButton, "Rect_Normal/challengeBtn")
  self.btnIcon = self:AddComponent(UIImage, "Rect_Normal/challengeBtn/Image")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.headIconN:SetEnableClickShowInfo(true, true)
end

function LWFollowItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdateDataUserInfo)
end

function LWFollowItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdateDataUserInfo)
  base.OnRemoveListener(self)
end

function LWFollowItem:ComponentDestroy()
  self.btn = nil
  self._server_txt = nil
  self._name_txt = nil
  self.headIconN = nil
  self.headFgN = nil
end

function LWFollowItem:DataDefine()
  self.uid = nil
  self.userInfo = nil
  self.unFollow = false
  self.mainView = nil
end

function LWFollowItem:DataDestroy()
  self.uid = nil
  self.userInfo = nil
  self.unFollow = nil
  self.mainView = nil
end

function LWFollowItem:UpdateItem(data)
  self.uid = data.followeeId
  self:Refresh()
  self:UpdateBtnState()
end

function LWFollowItem:UpdateDataUserInfo(uid)
  if self.uid ~= uid then
    return
  end
  self:Refresh()
end

function LWFollowItem:Refresh()
  if not self.uid then
    return
  end
  self.userInfo = ChatInterface.getUserMgr():getChatUserInfo(self.uid)
  if self.userInfo ~= nil then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.userInfo.uid, self.userInfo.userName)
    if self.userInfo.allianceSimpleName ~= nil and self.userInfo.allianceSimpleName ~= "" then
      self._name_txt:SetText("[" .. self.userInfo.allianceSimpleName .. "]" .. showName)
    else
      self._name_txt:SetText(showName)
    end
    self._server_txt:SetLocalText(208236, self.userInfo:getServerId())
    self.headIconN:SetHeadAndFrame(self.userInfo.uid, self.userInfo.headPic, self.userInfo.headPicVer, false, self.userInfo.headSkinId, self.userInfo.headSkinET)
  end
end

function LWFollowItem:SetContentViewScript(mainView)
  self.mainView = mainView
end

function LWFollowItem:UpdateBtnState()
  if self.unFollow then
    self.btnIcon:LoadSprite(path)
    self.btn_txt:SetLocalText("follow_btn")
  else
    self.btnIcon:LoadSprite(bluePath)
    self.btn_txt:SetLocalText("following_btn")
  end
end

function LWFollowItem:ShowFollowTip()
  if self.unFollow then
    UIUtil.ShowTipsId("moment_unfollow_tips")
  else
    UIUtil.ShowTipsId("moment_follow_tips")
  end
end

function LWFollowItem:OnBtnClick()
  self.unFollow = not self.unFollow
  self.mainView:SetUnFollow(self.uid, self.unFollow)
  self:UpdateBtnState()
  self:ShowFollowTip()
end

return LWFollowItem
