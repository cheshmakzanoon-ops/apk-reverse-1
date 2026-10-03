local UILWAlMemberItem = BaseClass("UILWAlMemberItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local player_btn_path = "PlayerBtn/UIPlayerHead"
local player_icon_path = "PlayerBtn/UIPlayerHead"
local gender_icon_path = "GenderIcon"
local name_txt_path = "NameText"
local power_txt_path = "PowerText"
local lv_text_path = "LvText"
local online_txt_path = "OnLineText"
local click_btn_path = "UseBtn"
local click_btn_text_path = "UseBtn/UseText"
local in_active_icon_path = "InActiveIcon"
local point_btn_path = "PointBtn"
local USE_BTN_TXT = 393011
local MALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nan.png"
local FEMALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nv.png"

function UILWAlMemberItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberItem:ComponentDefine()
  self.playerIcon = self:AddComponent(UICommonHead, player_icon_path)
  self.genderIcon = self:AddComponent(UIImage, gender_icon_path)
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.powerText = self:AddComponent(UIText, power_txt_path)
  self.lv_text = self:AddComponent(UIText, lv_text_path)
  self.onLineText = self:AddComponent(UIText, online_txt_path)
  self.in_active_icon = self:AddComponent(UIBaseContainer, in_active_icon_path)
  self.clickTextBtn = self:AddComponent(UIText, click_btn_text_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.playerBtn = self:AddComponent(UIButton, player_btn_path)
  self.playerBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.data.uid)
  end)
  self.clickTextBtn:SetLocalText(USE_BTN_TXT)
  self.pointBtn = self:TryAddComponent(UIButton, point_btn_path)
  if self.pointBtn then
    self.pointBtn:SetOnClick(function()
      self:OnPointBtnClick()
    end)
  end
end

function UILWAlMemberItem:ComponentDestroy()
  self.playerIcon = nil
  self.genderIcon = nil
  self.nameText = nil
  self.powerText = nil
  self.lv_text = nil
  self.onLineText = nil
  self.clickTextBtn = nil
  self.clickBtn = nil
  self.pointBtn = nil
end

function UILWAlMemberItem:DataDefine()
  self.data = {}
end

function UILWAlMemberItem:DataDestroy()
  self.data = nil
end

function UILWAlMemberItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
  self:AddUIListener(EventId.Al_MemberPoint, self.JumpAnotherWorld)
end

function UILWAlMemberItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
  self:RemoveUIListener(EventId.Al_MemberPoint, self.JumpAnotherWorld)
end

function UILWAlMemberItem:OnMemberKicked(playerId)
  if self.data and self.data.uid and self.data.uid == playerId then
    self.gameObject:SetActive(false)
  end
end

function UILWAlMemberItem:SetData(data)
  self.data = data
  local userId = data.uid
  local userPic = data.pic
  local userPicVer = data.picVer
  self.playerIcon:SetData(userId, userPic, userPicVer, true, data.headBg)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  self.nameText:SetText(showName)
  if self.data.uid == LuaEntry.Player.uid then
    self.nameText:SetColor(BlueColor)
  else
    self.nameText:SetColor(description1_color)
  end
  self.genderIcon:SetActive(false)
  if self.data.gender and self.data.gender > 0 and self.data.gender < 3 then
    self.genderIcon:SetActive(self.data.gender == 1 or self.data.gender == 2)
    if self.data.gender == 1 then
      self.genderIcon:LoadSprite(MALE_ICON_PATH)
    elseif self.data.gender == 2 then
      self.genderIcon:LoadSprite(FEMALE_ICON_PATH)
    end
  end
  self.powerText:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedSpecial(self.data.power))
  self.lv_text:SetLocalText(320439, self.data.mainCityLv)
  self.in_active_icon:SetActive(self.data.isInactive)
  if self.data.isSelfAlliance then
    self.onLineText:SetActive(true)
    self.onLineText:SetText(self.data.online_time)
    if self.data.isOnline then
      self.onLineText:SetColor(Color.New(0.3607843137254902, 0.8156862745098039, 0.6509803921568628, 1))
    else
      self.onLineText:SetColor(Color.New(0.49, 0.49, 0.49, 1))
    end
  else
    self.onLineText:SetActive(false)
  end
  self.clickBtn:SetActive(false)
  self.onLineText:SetLocalPositionXYZ(self.onLineText:GetLocalPosition().x, 0, self.onLineText:GetLocalPosition().z)
  if self.data.uid ~= LuaEntry.Player.uid then
    self.clickBtn:SetActive(true)
    self.onLineText:SetLocalPositionXYZ(self.onLineText:GetLocalPosition().x, 40, self.onLineText:GetLocalPosition().z)
  end
  if self.pointBtn then
    if self.data.isSelfAlliance and DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself() then
      local selfRank = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself().rank or 0
      if 4 <= selfRank then
        self.pointBtn:SetActive(true)
        local isFar = self.data.isFar
        if isFar then
          self.pointBtn:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/od_tongmeng_memberslocationicon_red.png")
        else
          self.pointBtn:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/od_tongmeng_memberslocationicon.png")
        end
      else
        self.pointBtn:SetActive(false)
      end
    else
      self.pointBtn:SetActive(false)
    end
  end
end

function UILWAlMemberItem:OnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMemberManager, {anim = true, hideTop = false}, self.data)
end

function UILWAlMemberItem:OnPointBtnClick()
  local data = self.data
  local jumpPointId = data.pointId
  local serverId
  if jumpPointId == nil or jumpPointId == 0 then
    DataCenter.AllianceMemberDataManager:UpdateMemberUid(data.uid)
    SFSNetwork.SendMessage(MsgDefines.AllianceMemberPoint, data.uid)
  elseif jumpPointId and 0 < jumpPointId then
    self.view.ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMain)
    local pos = SceneUtils.TileIndexToWorld(jumpPointId, ForceChangeScene.World)
    if not LuaEntry.Player:IsInSourceServer() then
      serverId = LuaEntry.Player:GetSourceServerId()
      GoToUtil.GotoWorldPos(pos, nil, nil, nil, serverId)
    else
      GoToUtil.GotoWorldPos(pos, nil, nil, nil)
    end
  else
    UIUtil.ShowTipsId(454136)
  end
end

function UILWAlMemberItem:JumpAnotherWorld()
  local data = self.data
  local jumpPointId, serverId, curUid = DataCenter.AllianceMemberDataManager:GetMemberPoint()
  if data and curUid == data.uid then
    if jumpPointId and 0 < jumpPointId then
      self.view.ctrl:CloseSelf()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMain)
      local pos = SceneUtils.TileIndexToWorld(jumpPointId, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(pos, nil, nil, nil, serverId)
    else
      UIUtil.ShowTipsId(454136)
    end
  end
end

return UILWAlMemberItem
