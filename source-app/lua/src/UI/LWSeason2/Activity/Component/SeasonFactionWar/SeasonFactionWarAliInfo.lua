local SeasonFactionWarAliInfo = BaseClass("SeasonFactionWarAliInfo", UIButton)
local base = UIButton
local Localization = CS.GameEntry.Localization
local res_info_r_path = "resInfoR"
local res_num_r_path = "resInfoR/resNumR"
local res_info_l_path = "resInfoL"
local res_num_l_path = "resInfoL/resNumL"
local icon1_path = "resInfoR/icon1"
local icon2_path = "resInfoL/icon2"

function SeasonFactionWarAliInfo:OnCreate()
  base.OnCreate(self)
  self.res_icon1 = self:AddComponent(UIImage, icon1_path)
  self.res_icon2 = self:AddComponent(UIImage, icon2_path)
  self.res_info_right = self:AddComponent(UIImage, res_info_r_path)
  self.res_num_right = self:AddComponent(UITextMeshProUGUIEx, res_num_r_path)
  self.res_info_left = self:AddComponent(UIImage, res_info_l_path)
  self.res_num_left = self:AddComponent(UITextMeshProUGUIEx, res_num_l_path)
  self.res_info_right:SetActive(false)
  self.res_info_left:SetActive(false)
  self.dropBtn = self:AddComponent(UIButton, "dropBtn")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.empty = self:AddComponent(UIImage, "empty")
  self:SetOnClick(function()
    if self.data and self.data.serverId and self.data.allianceId then
      UIUtil.TryShowAllianceInfo(self.data.serverId, self.data.allianceId, self.data.name)
    elseif self.canShowInvite and self.isDefence and LuaEntry.Player.allianceId == self.warAllianceId then
      local actObj = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
      if actObj and actObj.currStep == SeasonFactionDeclareWarStep.invite then
        if DataCenter.AllianceBaseDataManager:IsR4orR5() then
          self.doInviting = true
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarInviteDlg)
        else
          UIUtil.ShowTipsId(803040)
        end
      end
    end
  end)
  self.dropBtn:SetOnClick(function()
    if self.data == nil then
    elseif DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local name = UIUtil.FormatServerAllianceName(self.data.serverId, self.data.abbr, self.data.name)
      local msg = Localization:GetString("season_s2_faction_war_87", name)
      local allianceId = self.data.allianceId
      UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.SeasonFactionWarInviteCancel, allianceId)
      end, nil, nil, Localization:GetString("season_s2_faction_war_47"))
    else
      UIUtil.ShowTipsId(803040)
    end
  end)
  self.showEmptyIcon = true
  self.doInviting = false
  self.dropBtn:SetActive(false)
end

function SeasonFactionWarAliInfo:OnDestroy()
  self.name = nil
  self.empty = nil
  base.OnDestroy(self)
end

function SeasonFactionWarAliInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionWarInviteCancelUpdate, self.OnInviteCancel)
  self:AddUIListener(EventId.LWSeasonFactionWarInviteSendUpdate, self.OnInviteSend)
end

function SeasonFactionWarAliInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionWarInviteCancelUpdate, self.OnInviteCancel)
  self:RemoveUIListener(EventId.LWSeasonFactionWarInviteSendUpdate, self.OnInviteSend)
  base.OnRemoveListener(self)
end

function SeasonFactionWarAliInfo:OnInviteSend(t)
  if self.doInviting and t and t.allianceId then
    self:ReInit(t, true, self.warServerId, self.warAllianceId)
  end
  self.doInviting = false
end

function SeasonFactionWarAliInfo:OnInviteCancel(targetAllianceId)
  if self.data and targetAllianceId == self.data.allianceId then
    self.data = nil
    self.overTime = nil
    self:ReInit(nil, true, self.warServerId, self.warAllianceId)
  end
end

function SeasonFactionWarAliInfo:ReInit(data, defence, warServerId, warAllianceId)
  local inviteTime = DataCenter.SeasonFactionWarDataManager:GetCurrStep() == SeasonFactionDeclareWarStep.invite
  self.res_icon1:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
  self.res_icon2:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
  self.overTime = nil
  self.data = data
  self.warServerId = warServerId
  self.warAllianceId = warAllianceId
  self.isDefence = defence
  if data ~= nil and data.abbr ~= nil then
    self.theAllianceId = data.allianceId
    self.name:SetActive(true)
    self.empty:SetActive(false)
    self.aliText = UIUtil.FormatServerAllianceName(data.serverId, data.abbr, "\n" .. (data.name or ""))
    if defence and data.state ~= nil and data.state ~= 3 then
      local now = UITimeManager:GetInstance():GetServerTime()
      local state
      if data.state == 1 then
        state = Localization:GetString("390206")
      elseif now >= data.overTime then
        state = Localization:GetString("391049")
      else
        state = Localization:GetString("season_s2_faction_war_50")
        self.overTime = data.overTime
      end
      self.dropBtn:SetActive(LuaEntry.Player.allianceId == warAllianceId and warAllianceId ~= data.allianceId)
      self.stateTxt = state
      self.name:SetText(self.aliText .. [[

<color=#888888>]] .. self.stateTxt .. "</color>")
      self:Update1000MS()
    else
      self.name:SetText(self.aliText)
      self.dropBtn:SetActive(false)
    end
    if data.allianceId == LuaEntry.Player.allianceId then
      self:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_duizhan_list_3.png")
    else
      local compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(data.serverId)
      if compId == 1 then
        self.name:SetColorRGBA255(89, 24, 24, 255)
        self:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_duizhan_list_1.png")
      else
        self.name:SetColorRGBA255(40, 70, 119, 255)
        self:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_duizhan_list_2.png")
      end
    end
  else
    self.theAllianceId = nil
    self.name:SetActive(false)
    self.empty:SetActive(self.showEmptyIcon and defence and inviteTime)
    self.dropBtn:SetActive(false)
    self:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_list_bg1.png")
  end
end

function SeasonFactionWarAliInfo:Update1000MS()
  if self.overTime and self.name then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.overTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.name:SetText(self.aliText .. [[

<color=#888888>]] .. self.stateTxt .. " " .. showTime .. "</color>")
    else
      self.overTime = nil
      self.stateTxt = Localization:GetString("391049")
      self.name:SetText(self.aliText .. [[

<color=#888888>]] .. self.stateTxt .. "</color>")
    end
  end
end

function SeasonFactionWarAliInfo:CanShowInviteWhenEmpty(canShowInvite)
  self.canShowInvite = canShowInvite
end

function SeasonFactionWarAliInfo:IsEmpty()
  return self.data == nil
end

function SeasonFactionWarAliInfo:ShowEmptyIcon(showIt)
  local inviteTime = DataCenter.SeasonFactionWarDataManager:GetCurrStep() == SeasonFactionDeclareWarStep.invite
  self.showEmptyIcon = showIt
  self.empty:SetActive(self.data == nil and showIt and inviteTime)
end

function SeasonFactionWarAliInfo:UpdateResChangeInfo(alResChangeInfo)
  local alResChange = 0
  if alResChangeInfo and self.theAllianceId then
    alResChange = toInt(alResChangeInfo[self.theAllianceId])
  end
  if alResChange ~= 0 then
    local res_num_node
    if self.isDefence then
      self.res_info_right:SetActive(true)
      self.res_info_left:SetActive(false)
      res_num_node = self.res_num_right
    else
      self.res_info_right:SetActive(false)
      self.res_info_left:SetActive(true)
      res_num_node = self.res_num_left
    end
    if res_num_node then
      if 0 < alResChange then
        res_num_node:SetText("+" .. string.GetFormattedStr(alResChange))
        res_num_node:SetColorRGBA255(86, 245, 101, 255)
      else
        res_num_node:SetText(string.GetFormattedStr(alResChange))
        res_num_node:SetColorRGBA255(255, 115, 115, 255)
      end
    else
      self.res_info_right:SetActive(false)
      self.res_info_left:SetActive(false)
    end
  else
    self.res_info_right:SetActive(false)
    self.res_info_left:SetActive(false)
  end
end

return SeasonFactionWarAliInfo
