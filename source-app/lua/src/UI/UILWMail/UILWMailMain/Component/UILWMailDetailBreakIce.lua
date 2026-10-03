local UILWMailDetailBreakIce = BaseClass("UILWMailDetailBreakIce", UIBaseContainer)
local base = UIBaseContainer

function UILWMailDetailBreakIce:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailBreakIce:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailBreakIce:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailBreakIce:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailBreakIce:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailBreakIce:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailBreakIce:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailBreakIce:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailBreakIce:ComponentDefine()
  self.coordinateText = self:AddComponent(UIText, "scroll/viewport/content/top/CoordinateText")
  self.coordinateBtn = self:AddComponent(UIButton, "scroll/viewport/content/top/CoordinateText")
  self.coordinateBtn:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.coordinateText1 = self:AddComponent(UIText, "scroll/viewport/content/top/CoordinateText1")
  self.coordinateBtn1 = self:AddComponent(UIButton, "scroll/viewport/content/top/CoordinateText1")
  self.coordinateBtn1:SetOnClick(function()
    self:OnJumpClick1()
  end)
  self.coordinateText2 = self:AddComponent(UIText, "scroll/viewport/content/top/CoordinateText2")
  self.coordinateBtn2 = self:AddComponent(UIButton, "scroll/viewport/content/top/CoordinateText2")
  self.coordinateBtn2:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.timeText = self:AddComponent(UIText, "scroll/viewport/content/top/TimeText")
  self.head1 = self:AddComponent(UICommonHead, "scroll/viewport/content/top/head1")
  self.head2 = self:AddComponent(UICommonHead, "scroll/viewport/content/top/head2")
  self.playerName1 = self:AddComponent(UIText, "scroll/viewport/content/top/PlayerName1")
  self.playerName2 = self:AddComponent(UIText, "scroll/viewport/content/top/PlayerName2")
  self.scoutTip2 = self:AddComponent(UIText, "scroll/viewport/content/top/Tip2")
end

function UILWMailDetailBreakIce:ComponentDestroy()
  self.coordinateText = nil
  self.timeText = nil
  self.player_head1 = nil
  self.player_head2 = nil
  self.playerName1 = nil
  self.playerName2 = nil
  self.scoutTip2 = nil
end

function UILWMailDetailBreakIce:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeText:SetText(_strTime)
  self.head1.frameBg:SetActive(true)
  self.head2.frameBg:SetActive(true)
  local data = self.mailData:GetMailExt()
  self.data = data
  local framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.user.headSkinId, 0, false)
  self.head1:SetHead(data.user.uid, data.user.headPic, data.user.headPicVer, nil, framePath)
  self.head1:SetEnableClickShowInfo(true, true)
  self.playerName1:SetText(UIUtil.FormatServerAllianceName(data.user.sourceServerId, data.user.abbr, data.user.name))
  self.location2 = Vector2.New(data.pos.x, data.pos.y)
  framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.targetUser.headSkinId, 0, false)
  self.head2:SetHead(data.targetUser.uid, data.targetUser.headPic, data.targetUser.headPicVer, nil, framePath)
  self.head2:SetEnableClickShowInfo(true, true)
  self.playerName2:SetText(UIUtil.FormatServerAllianceName(data.targetUser.sourceServerId, data.targetUser.abbr, data.targetUser.name))
  self.coordinateText1:SetText("")
  self.coordinateText2:SetText(self.view.ctrl:FormatCoordinateText(self.location2, self.serverId2))
  if data.targetUser.uid == LuaEntry.Player.uid then
    self.scoutTip2:SetLocalText(GameDialogDefine.MAIL_SEASON_ICE_CRUSH_OTHER, data.dmg)
  else
    self.scoutTip2:SetLocalText(GameDialogDefine.MAIL_SEASON_ICE_CRUSH, data.dmg)
  end
end

function UILWMailDetailBreakIce:OnJumpClick1()
  if self.location1 ~= nil then
    self.view.ctrl:OnJumpClick(self.location1.x, self.location1.y, self.serverId1)
  end
end

function UILWMailDetailBreakIce:OnJumpClick2()
  if self.location2 ~= nil then
    self.view.ctrl:OnJumpClick(self.location2.x, self.location2.y, self.serverId2)
  end
end

return UILWMailDetailBreakIce
