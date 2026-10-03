local base = UIBaseContainer
local AllianceWarEventItemComponent = BaseClass("AllianceWarEventItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local join_path = "Join"
local all_path = "All"

function AllianceWarEventItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceWarEventItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceWarEventItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnReminder = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnReminder:SetOnClick(function()
    self:OnBtnReminderClick()
  end)
  self.btnBuildingPos = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBuildingPos:SetOnClick(function()
    self:OnBtnBuildingPosClick()
  end)
  self.imgReminderIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textAllNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textEventName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textJoinNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textBuildingName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textTimeTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.imgBuilding = self.viewSkin:AddComponent(self, UIImage, 10)
  self.textEventDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textBuildingPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.join = self:AddComponent(UIButton, join_path)
  self.join:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("alliance_war_notice_UI_08", self.eventData.allianceJoinNum), self.join.transform.position, 0, -33, 0)
  end)
  self.all = self:AddComponent(UIButton, all_path)
  self.all:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("alliance_war_notice_UI_09", self.eventData.joinNum), self.all.transform.position, 0, -33, 0)
  end)
  self.building_raw = self:AddComponent(UIRawImage, "BuildingRaw")
  self.icon_ally = self:AddComponent(UIImage, "IconAlly")
end

function AllianceWarEventItemComponent:ComponentDestroy()
  self.icon_ally = nil
  if self.IconEffect then
    self:GameObjectDestroy(self.IconEffect)
    self.IconEffect = nil
  end
  self.viewSkin = nil
  self.btnReminder = nil
  self.btnBuildingPos = nil
  self.imgReminderIcon = nil
  self.textAllNum = nil
  self.textEventName = nil
  self.textJoinNum = nil
  self.textBuildingName = nil
  self.imgIcon = nil
  self.textTimeTxt = nil
  self.imgBuilding = nil
  self.textEventDesc = nil
  self.btnInfo = nil
  self.textBuildingPos = nil
end

function AllianceWarEventItemComponent:DataDefine()
end

function AllianceWarEventItemComponent:DataDestroy()
  self.eventData = nil
end

function AllianceWarEventItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceWarEventReminderChange, self.OnReminderChange)
end

function AllianceWarEventItemComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceWarEventReminderChange, self.OnReminderChange)
  base.OnRemoveListener(self)
end

function AllianceWarEventItemComponent:OnBtnInfoClick()
  if self.eventData and self.eventData.template and not string.IsNullOrEmpty(self.eventData.template.time_help) then
    local str = Localization:GetString(self.eventData.template.time_help)
    UIUtil.ShowBubbleTips(str, self.btnInfo.transform.position, 0, -33, 0, nil, nil, nil, nil, true)
  end
end

function AllianceWarEventItemComponent:OnBtnReminderClick()
  if self.eventData then
    self.eventData:SetReminder(not self.eventData.reminder)
  end
end

function AllianceWarEventItemComponent:RefreshReminder()
  if self.eventData.reminder then
    self.imgReminderIcon:LoadSprite("Assets/Main/Sprites/UI/UIAllianceWarEvent/mjc_lianmengzhanshi_icon_tixing3.png")
  else
    self.imgReminderIcon:LoadSprite("Assets/Main/Sprites/UI/UIAllianceWarEvent/mjc_lianmengzhanshi_icon_tixing2.png")
  end
end

function AllianceWarEventItemComponent:OnReminderChange(eventData)
  if eventData == self.eventData then
    self:RefreshReminder()
  end
end

function AllianceWarEventItemComponent:OnBtnBuildingPosClick()
  if self.eventData.point then
    local v3 = SceneUtils.TileIndexToWorld(self.eventData.point, ForceChangeScene.World)
    local serverId = self.eventData.serverId
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, serverId)
  end
end

function AllianceWarEventItemComponent:SetData(eventData)
  self.eventData = eventData
  if self.IconEffect then
    self:GameObjectDestroy(self.IconEffect)
  end
  self.IconEffect = self:GameObjectInstantiateAsync(eventData.template.icon_animation, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.imgIcon.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(0, 0, 0)
  end)
  self.btnInfo:SetActive(self.eventData and self.eventData.template and not string.IsNullOrEmpty(self.eventData.template.time_help))
  self.textEventName:SetLocalText(eventData.template.name)
  self.textEventDesc:SetLocalText(eventData.template.desc)
  self:RefreshReminder()
  local v2 = SceneUtils.IndexToTilePos(eventData.point, ForceChangeScene.World)
  self.textBuildingPos:SetText(UIUtil.FormatServerPosition(eventData.serverId, v2.x, v2.y))
  self.textTimeTxt:SetText()
  self:Update1000MS()
  self.textAllNum:SetText(eventData.joinNum)
  self.textJoinNum:SetText(eventData.allianceJoinNum)
  if eventData.type == AlWarEventType.ATTACK_OUTPOST_WAR or eventData.type == AlWarEventType.DEFENSE_OUTPOST_WAR then
    self.building_raw:SetActive(false)
    local buildMeta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(eventData.buildId)
    if buildMeta then
      self.imgBuilding:LoadSprite(buildMeta:GetIconPath())
      self.imgBuilding:SetActive(true)
      local cityFullName = buildMeta:GetFullName()
      self.textBuildingName:SetText(cityFullName)
      cityFullName = UIUtil.FormatServerAllianceName(eventData.serverId, eventData.abbr, cityFullName)
      self.textEventDesc:SetLocalText(eventData.template.desc, cityFullName)
      self.textBuildingName:SetActive(true)
    else
      self.imgBuilding:SetActive(false)
      self.textBuildingName:SetActive(false)
    end
  else
    self.building_raw:SetActive(false)
    local buildMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(eventData.buildId, eventData.serverId)
    if buildMeta then
      self.imgBuilding:LoadSprite(buildMeta:GetIconPath())
      self.imgBuilding:SetActive(true)
      local cityFullName = buildMeta:GetFullName()
      self.textBuildingName:SetText(cityFullName)
      cityFullName = UIUtil.FormatServerAllianceName(eventData.serverId, eventData.abbr, cityFullName)
      self.textEventDesc:SetLocalText(eventData.template.desc, cityFullName)
      self.textBuildingName:SetActive(true)
    else
      self.imgBuilding:SetActive(false)
      self.textBuildingName:SetActive(false)
    end
  end
  if self.icon_ally then
    local allyFriendMgr = DataCenter.SeasonAllyFriendManager
    if allyFriendMgr:IsMyAllianceFriend(eventData.allianceId) or allyFriendMgr:IsMyAllianceFriend(eventData.defAllianceId) then
      self.icon_ally:SetActive(true)
      self.icon_ally:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_jiemeng.png")
    else
      self.icon_ally:SetActive(false)
    end
  end
end

function AllianceWarEventItemComponent:Update1000MS()
  if self.eventData and self.eventData.endTime then
    if self.eventData.type == AlWarEventType.ATTACK_OUTPOST_WAR or self.eventData.type == AlWarEventType.DEFENSE_OUTPOST_WAR then
      self.textTimeTxt:SetText()
    else
      local now = UITimeManager:GetInstance():GetServerTime()
      self.textTimeTxt:SetLocalText("alliance_war_notice_UI_14", UITimeManager:GetInstance():MilliSecondToFmtString(self.eventData.endTime - now))
    end
  end
end

return AllianceWarEventItemComponent
