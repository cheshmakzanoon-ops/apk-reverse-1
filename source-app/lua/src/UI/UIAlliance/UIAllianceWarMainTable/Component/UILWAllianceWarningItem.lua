local UILWAllianceWarningItem = BaseClass("UILWAllianceWarningItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local battle_arr_path = "mainContent/battleArr"
local left_player_head_path = "mainContent/left/leftHead/lUIPlayerHead"
local left_other_head_icon_path = "mainContent/left/leftHead/lHeadIcon"
local left_name_txt_path = "mainContent/left/leftNameTxt"
local left_pos_txt_path = "mainContent/left/lPos/leftPosTxt"
local left_status_img_path = "mainContent/left/leftStatusImg"
local right_player_head_path = "mainContent/right/rightHead/rUIPlayerHead"
local right_other_head_icon_path = "mainContent/right/rightHead/rHeadIcon"
local right_name_txt_path = "mainContent/right/rightNameTxt"
local right_pos_txt_path = "mainContent/right/rPos/rightPosTxt"
local right_status_img_path = "mainContent/right/rightStatusImg"
local endTime_path = "mainContent/Txt_EndTime"
local status_path = "mainContent/Txt_Status"
local attack_icon = "Assets/Main/Sprites/UI/UILWAlliance/lyp_tongmen_gerenzhanbao_jingong.png"
local defence_icon = "Assets/Main/Sprites/UI/UILWAlliance/lyp_tongmen_gerenzhanbao_fangshou.png"

function UILWAllianceWarningItem:OnCreate()
  base.OnCreate(self)
  self.battle_arr = self:AddComponent(UIBaseContainer, battle_arr_path)
  self._endTime_txt = self:AddComponent(UIText, endTime_path)
  self._status = self:AddComponent(UIText, status_path)
  self._status:SetLocalText(390228)
  self.left_player_head = self:AddComponent(UICommonHead, left_player_head_path)
  self.left_other_head_icon = self:AddComponent(UIImage, left_other_head_icon_path)
  self.left_name = self:AddComponent(UIText, left_name_txt_path)
  self.left_pos_txt = self:AddComponent(UIText, left_pos_txt_path)
  self.left_pos_btn = self:AddComponent(UIButton, left_pos_txt_path)
  self.left_pos_btn:SetOnClick(function()
    self:OnLeftPosClick()
  end)
  self.left_status_img = self:AddComponent(UIImage, left_status_img_path)
  self.right_player_head = self:AddComponent(UICommonHead, right_player_head_path)
  self.right_other_head_icon = self:AddComponent(UIImage, right_other_head_icon_path)
  self.right_name = self:AddComponent(UIText, right_name_txt_path)
  self.right_pos_txt = self:AddComponent(UIText, right_pos_txt_path)
  self.right_pos_btn = self:AddComponent(UIButton, right_pos_txt_path)
  self.right_pos_btn:SetOnClick(function()
    self:OnRightPosClick()
  end)
  self.right_status_img = self:AddComponent(UIImage, right_status_img_path)
  self._timer_personal = nil
  
  function self._timer_action_temp()
    self:UpdatePersonalTime()
  end
end

function UILWAllianceWarningItem:OnDestroy()
  self.battle_arr = nil
  self.left_pos_btn = nil
  self.left_name = nil
  self.right_pos_btn = nil
  self.right_name = nil
  self.right_pos_txt = nil
  self.right_player_head = nil
  self.right_other_head_icon = nil
  self.left_pos_txt = nil
  self.left_status_img = nil
  self.right_pos_txt = nil
  self.right_status_img = nil
  self.isguised = nil
  if self._timer_personal ~= nil then
    self._timer_personal:Stop()
    self._timer_personal = nil
  end
  base.OnDestroy(self)
end

function UILWAllianceWarningItem:RefreshData(isAlert)
  if self.data == nil or self.data.effectType == AlAlertType.AresMissile or self.data.effectType == AlAlertType.MissileFactory or self.data.effectType == AlAlertType.GoddessMummy then
    return
  end
  self.isguised = self.data.isAnonymity
  local selfUid = LuaEntry.Player.uid
  if self.data.isAtk == 1 then
    self.battle_arr:SetLocalScaleXYZ(1, 1, 1)
    self.left_status_img:LoadSprite(attack_icon)
    self.right_status_img:LoadSprite(defence_icon)
    self.leftPointId = self.data.startPos
    self.rightPointId = self.data.targetPos
    local leftPos = SceneUtils.IndexToTilePos(self.data.startPos, ForceChangeScene.World)
    local rightPos = SceneUtils.IndexToTilePos(self.data.targetPos, ForceChangeScene.World)
    local dataServer = self.data.server
    if dataServer == LuaEntry.Player:GetCurServerId() then
      self.left_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
      self.right_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, rightPos.x, rightPos.y)
    else
      self.left_pos_txt:SetLocalText("alliance_intelligence_coordinates", dataServer, leftPos.x, leftPos.y)
      self.right_pos_txt:SetLocalText("alliance_intelligence_coordinates", dataServer, rightPos.x, rightPos.y)
    end
    self.left_name:SetText(UIUtil.FormatAllianceAndName(self.data.allianceAbbr, self.data.ownerName))
    if selfUid == self.data.ownerUid then
      self.left_name:SetColor(Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1))
    else
      self.left_name:SetColor(Color.white)
    end
    self.left_player_head:SetActive(true)
    self.left_other_head_icon:SetActive(false)
    local framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.data.headSkinId, self.headSkinET, false)
    self.left_player_head:SetData(self.data.ownerUid, self.data.pic, self.data.picVer, nil, framePath)
    if self.isguised then
      self.left_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, "???", "???")
      self.left_name:SetText(Localization:GetString("season_mastery_173"))
    end
    self.right_name:SetText(DataCenter.AllianceAlertDataManager:GetTargetName(self.data))
    if self.data.target == MarchTargetType.ATTACK_CITY or self.data.target == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.data.target == MarchTargetType.ATTACK_EPIDEMIC_CITY then
      self.right_player_head:SetActive(true)
      self.right_other_head_icon:SetActive(false)
      framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.data.tHeadSkinId, self.data.tHeadSkinET, false)
      self.right_player_head:SetData(self.data.tUid, self.data.tPic, self.data.tPicVer, nil, framePath)
    else
      local headUrl, scale = DataCenter.AllianceAlertDataManager:GetTargetHeadIcon(self.data)
      if headUrl ~= nil then
        self.right_player_head:SetActive(false)
        self.right_other_head_icon:SetActive(true)
        self.right_other_head_icon:LoadSpriteAsyncWithCallback(headUrl, function()
          if self and self.right_other_head_icon then
            self.right_other_head_icon:SetNativeSize()
          end
        end)
        self.right_other_head_icon.transform:Set_localScale(scale, scale, scale)
      else
        self.right_player_head:SetActive(true)
        self.right_other_head_icon:SetActive(false)
      end
    end
  else
    self.battle_arr:SetLocalScaleXYZ(-1, 1, 1)
    self.left_status_img:LoadSprite(defence_icon)
    self.right_status_img:LoadSprite(attack_icon)
    self.leftPointId = self.data.targetPos
    self.rightPointId = self.data.startPos
    local dataServer = self.data.server
    if toInt(self.data.targetPos) > 0 then
      local leftPos = SceneUtils.IndexToTilePos(self.data.targetPos, ForceChangeScene.World)
      if dataServer == LuaEntry.Player:GetCurServerId() then
        self.left_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
      else
        self.left_pos_txt:SetLocalText("alliance_intelligence_coordinates", dataServer, leftPos.x, leftPos.y)
      end
    else
      self.left_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, "???", "???")
    end
    if toInt(self.data.startPos) > 0 then
      if self.isguised then
        self.right_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, "???", "???")
      else
        local rightPos = SceneUtils.IndexToTilePos(self.data.startPos, ForceChangeScene.World)
        if dataServer == LuaEntry.Player:GetCurServerId() then
          self.right_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, rightPos.x, rightPos.y)
        else
          self.right_pos_txt:SetLocalText("alliance_intelligence_coordinates", dataServer, rightPos.x, rightPos.y)
        end
      end
    else
      self.right_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, "???", "???")
    end
    if self.data.target == MarchTargetType.DARK_KNIGHT_CITY or self.data.target == MarchTargetType.BEHEMOTH_ATTACK_CITY then
      local meta = DataCenter.MonsterTemplateManager:TryGetMonsterTemplate(self.data.monsterId)
      if meta then
        self.right_name:SetLocalText(meta.name)
        self.right_player_head:SetActive(false)
        self.right_other_head_icon:SetActive(true)
        self.right_other_head_icon:LoadSpriteAsyncWithCallback(LoadPath.HeroIconsSmallPath .. meta.pic, function(texture)
          if self and self.right_other_head_icon then
            self.right_other_head_icon:SetNativeSize()
            self.right_other_head_icon.transform:Set_localScale(0.5, 0.5, 0.5)
          end
        end)
      end
    else
      if self.isguised then
        self.right_name:SetText(Localization:GetString("season_mastery_173"))
      else
        self.right_name:SetText(UIUtil.FormatAllianceAndName(self.data.allianceAbbr, self.data.ownerName))
      end
      self.right_player_head:SetActive(true)
      self.right_other_head_icon:SetActive(false)
      local framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.data.headSkinId, self.headSkinET, false)
      self.right_player_head:SetData(self.data.ownerUid, self.data.pic, self.data.picVer, nil, framePath)
    end
    self.left_name:SetText(DataCenter.AllianceAlertDataManager:GetTargetName(self.data))
    if self.data.target == MarchTargetType.ATTACK_CITY or self.data.target == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.data.target == MarchTargetType.ATTACK_EPIDEMIC_CITY then
      self.left_player_head:SetActive(true)
      self.left_other_head_icon:SetActive(false)
      local framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.data.tHeadSkinId, self.data.tHeadSkinET, false)
      self.left_player_head:SetData(self.data.tUid, self.data.tPic, self.data.tPicVer, nil, framePath)
      if selfUid == self.data.tUid then
        self.left_name:SetColor(Color.New(0.9607843137254902, 0.23529411764705882, 0.23921568627450981, 1))
      else
        self.left_name:SetColor(Color.white)
      end
    else
      self.left_name:SetColor(Color.white)
      local headUrl, scale = DataCenter.AllianceAlertDataManager:GetTargetHeadIcon(self.data)
      if headUrl ~= nil then
        self.left_player_head:SetActive(false)
        self.left_other_head_icon:SetActive(true)
        self.left_other_head_icon:LoadSpriteAsyncWithCallback(headUrl, function()
          if self and self.left_other_head_icon then
            self.left_other_head_icon:SetNativeSize()
          end
        end)
        self.left_other_head_icon.transform:Set_localScale(scale, scale, scale)
      else
        self.left_player_head:SetActive(true)
        self.left_other_head_icon:SetActive(false)
      end
    end
  end
  self:UpdatePersonalTime()
  self:AddPersonalTimer()
end

function UILWAllianceWarningItem:SetData(data)
  self.data = data
end

function UILWAllianceWarningItem:AddPersonalTimer()
  if self._timer_personal == nil then
    self._timer_personal = TimerManager:GetInstance():GetTimer(1, self._timer_action_temp, self, false, false, false)
    self._timer_personal:Start()
  end
end

function UILWAllianceWarningItem:UpdatePersonalTime()
  if self.data.status == MarchStatus.MOVING or self.data.status == MarchStatus.CHASING then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.data.endTime - curTime
    if deltaTime <= 0 then
      self._endTime_txt:SetLocalText(100150)
      if self._timer_personal ~= nil then
        self._timer_personal:Stop()
        self._timer_personal = nil
      end
    end
    self._endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  elseif self.data.status == MarchStatus.BEHEMOTH_ATTACK_CITY then
    self._endTime_txt:SetLocalText(100150)
    if self._timer_personal ~= nil then
      self._timer_personal:Stop()
      self._timer_personal = nil
    end
  else
    self._endTime_txt:SetText("00:00:00")
  end
end

function UILWAllianceWarningItem:OnLeftPosClick()
  if self.isguised and self.data.isAtk == 1 then
    UIUtil.ShowTipsId("season_mastery_174")
    return
  end
  self.view.ctrl:OnClickPosBtn(self.leftPointId, false, nil, self.data.server, self.data.worldId, self.data.worldType)
end

function UILWAllianceWarningItem:OnRightPosClick()
  if self.isguised and self.data.isAtk ~= 1 then
    UIUtil.ShowTipsId("season_mastery_174")
    return
  end
  self.view.ctrl:OnClickPosBtn(self.rightPointId, false, nil, self.data.server, self.data.worldId, self.data.worldType)
end

function UILWAllianceWarningItem:OnEnable()
  base.OnEnable(self)
end

function UILWAllianceWarningItem:OnDisable()
  base.OnDisable(self)
end

return UILWAllianceWarningItem
