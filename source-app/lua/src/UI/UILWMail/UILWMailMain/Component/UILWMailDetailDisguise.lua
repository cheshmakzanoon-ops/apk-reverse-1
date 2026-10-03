local UILWMailDetailDisguise = BaseClass("UILWMailDetailDisguise", UIBaseContainer)
local base = UIBaseContainer

function UILWMailDetailDisguise:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailDisguise:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailDisguise:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailDisguise:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailDisguise:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailDisguise:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailDisguise:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailDisguise:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailDisguise:ComponentDefine()
  self.coordinateText = self:AddComponent(UIText, "top/CoordinateText")
  self.coordinateBtn = self:AddComponent(UIButton, "top/CoordinateText")
  self.coordinateBtn:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.coordinateText1 = self:AddComponent(UIText, "top/CoordinateText1")
  self.coordinateBtn1 = self:AddComponent(UIButton, "top/CoordinateText1")
  self.coordinateBtn1:SetOnClick(function()
    self:OnJumpClick1()
  end)
  self.coordinateText2 = self:AddComponent(UIText, "top/CoordinateText2")
  self.coordinateBtn2 = self:AddComponent(UIButton, "top/CoordinateText2")
  self.coordinateBtn2:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.timeText = self:AddComponent(UIText, "top/TimeText")
  self.head1 = self:AddComponent(UICommonHead, "top/head1")
  self.head1:SetEnableClickShowInfo(true, true)
  self.head2 = self:AddComponent(UICommonHead, "top/head2")
  self.head2:SetEnableClickShowInfo(true, true)
  self.playerName1 = self:AddComponent(UIText, "top/PlayerName1")
  self.playerName2 = self:AddComponent(UIText, "top/PlayerName2")
  self.hunterText = self:AddComponent(UIText, "top/ScoutText2")
  self.hunterText:SetLocalText("season_mastery_s3_tips_15")
  self.preyText = self:AddComponent(UIText, "top/BeScoutText2")
  self.preyText:SetLocalText("season_mastery_s3_tips_16")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "bottom/Title")
  self.title:SetLocalText("season_mastery_s3_mail_1")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "bottom/Desc")
  self.masteryIcon = self:AddComponent(UIImage, "top/Image")
end

function UILWMailDetailDisguise:ComponentDestroy()
end

function UILWMailDetailDisguise:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local data = self.mailData:GetMailExt()
  local isPassive = data:IsPassive()
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeText:SetText(_strTime)
  self.location1 = SceneUtils.IndexToTilePos(data.atkUser.pointId, ForceChangeScene.World)
  self.serverId1 = data.atkUser.serverId
  self.location2 = SceneUtils.IndexToTilePos(data.defUser.pointId, ForceChangeScene.World)
  self.serverId2 = data.defUser.serverId
  self.coordinateText:SetText(self:FormatCoordinateText(self.location2, self.serverId2))
  self.coordinateText1:SetText(self:FormatCoordinateText(self.location1, self.serverId1))
  self.coordinateText2:SetText(self:FormatCoordinateText(self.location2, self.serverId2))
  local atkUser = data.atkUser
  self.head1:SetHeadAndFrame(atkUser.uid, atkUser.headPic, atkUser.headPicVer, nil, atkUser.headSkinId, atkUser.headSkinET)
  self.playerName1:SetText(UIUtil.FormatServerAllianceName(atkUser.serverId, atkUser.abbr, atkUser.name))
  local defUser = data.defUser
  self.head2:SetHeadAndFrame(defUser.uid, defUser.headPic, defUser.headPicVer, nil, defUser.headSkinId, defUser.headSkinET)
  self.playerName2:SetText(UIUtil.FormatServerAllianceName(defUser.serverId, defUser.abbr, defUser.name))
  self.title:SetColor(isPassive and Color(0.96, 0.24, 0.24, 1) or Color(0.03, 0.6, 0.29, 1))
  self.title:SetLocalText("season_mastery_s3_mail_1")
  self.desc:SetLocalText(isPassive and "season_mastery_s3_mail_3" or "season_mastery_s3_mail_2")
  local skillTemplate = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.CreateFakeMarch)
  if skillTemplate then
    self.masteryIcon:LoadSpriteAuto(skillTemplate:GetIconFullPath())
  end
end

function UILWMailDetailDisguise:OnJumpClick1()
  if self.location1 ~= nil then
    self.view.ctrl:OnJumpClick(self.location1.x, self.location1.y, self.serverId1)
  end
end

function UILWMailDetailDisguise:OnJumpClick2()
  if self.location2 ~= nil then
    self.view.ctrl:OnJumpClick(self.location2.x, self.location2.y, self.serverId2)
  end
end

function UILWMailDetailDisguise:FormatCoordinateText(pos, serverId)
  if serverId and 0 < serverId then
    return string.format("#%s X:%s,Y:%s", serverId, pos.x, pos.y)
  else
    return string.format("X:%s,Y:%s", pos.x, pos.y)
  end
end

return UILWMailDetailDisguise
