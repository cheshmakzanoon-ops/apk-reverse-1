local UILWMailDetailAttackRuinBuilding = BaseClass("UILWMailDetailAttackRuinBuilding", UIBaseContainer)
local base = UIBaseContainer

function UILWMailDetailAttackRuinBuilding:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailAttackRuinBuilding:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailAttackRuinBuilding:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailAttackRuinBuilding:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailAttackRuinBuilding:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailAttackRuinBuilding:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailAttackRuinBuilding:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailAttackRuinBuilding:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailAttackRuinBuilding:ComponentDefine()
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
  self.playerName1 = self:AddComponent(UIText, "scroll/viewport/content/top/PlayerName1")
  self.tips2 = self:AddComponent(UIText, "scroll/viewport/content/top/Tip2")
end

function UILWMailDetailAttackRuinBuilding:ComponentDestroy()
  self.coordinateText = nil
  self.timeText = nil
  self.player_head1 = nil
  self.playerName1 = nil
  self.tips2 = nil
end

function UILWMailDetailAttackRuinBuilding:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeText:SetText(_strTime)
  self.head1.frameBg:SetActive(true)
  local data = self.mailData:GetMailSFSObj()
  self.data = data
  self.serverId1 = data.atkServerId
  self.serverId2 = data.serverId
  local framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET, false)
  self.head1:SetHead(data.atkUid, data.atkPic, data.atkPicVer, nil, framePath)
  self.head1:SetEnableClickShowInfo(true, true)
  self.playerName1:SetText(UIUtil.FormatServerAllianceName(self.serverId1, data.atkAbbr, data.atkAbbrName))
  local pos1 = SceneUtils.IndexToTilePos(data.atkPoint, ForceChangeScene.World)
  self.location1 = Vector2.New(pos1.x, pos1.y)
  local pos2 = SceneUtils.IndexToTilePos(data.point, ForceChangeScene.World)
  self.location2 = Vector2.New(pos2.x, pos2.y)
  local txtPos2 = self.view.ctrl:FormatCoordinateText(self.location2)
  self.coordinateText:SetText(txtPos2)
  self.coordinateText1:SetText(self.view.ctrl:FormatCoordinateText(self.location1))
  self.coordinateText2:SetText(txtPos2)
  self.tips2:SetLocalText("Teleport_Territory_mailDes_1", data.dmg, data.exp)
end

function UILWMailDetailAttackRuinBuilding:OnJumpClick1()
  if self.location1 ~= nil then
    self.view.ctrl:OnJumpClick(self.location1.x, self.location1.y, self.serverId1)
  end
end

function UILWMailDetailAttackRuinBuilding:OnJumpClick2()
  if self.location2 ~= nil then
    self.view.ctrl:OnJumpClick(self.location2.x, self.location2.y, self.serverId2)
  end
end

return UILWMailDetailAttackRuinBuilding
