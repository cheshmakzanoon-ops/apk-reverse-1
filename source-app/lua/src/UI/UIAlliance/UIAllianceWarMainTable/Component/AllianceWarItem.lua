local AllianceWarItem = BaseClass("AllianceWarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local itembg_img_path = "mainContent/Common_supple"
local dir1_img_path = "mainContent/Common_supple/jiantou/Rect_MarchDir/Rect_MarchDir1"
local dir2_img_path = "mainContent/Common_supple/jiantou/Rect_MarchDir/Rect_MarchDir2"
local bg_btn_path = "mainContent/BgButton"
local left_pos_btn_path = "mainContent/left"
local left_pos_txt_path = "mainContent/left/leftPosTxt"
local left_name_path = "mainContent/left/leftNameTxt"
local distance_obj_path = "mainContent/left/Image"
local left_playerHead_path = "mainContent/left/lefthead/LeftUIPlayerHead/LeftHeadIcon"
local left_CityHead_path = "mainContent/left/lefthead/LeftUIPlayerHead/LeftCityHead"
local left_playerHeadFg_path = "mainContent/left/lefthead/LeftUIPlayerHead/lForeground"
local distance_txt_path = "mainContent/left/Image/distanceTxt"
local right_pos_btn_path = "mainContent/right"
local right_pos_txt_path = "mainContent/right/rightPosTxt"
local right_name_path = "mainContent/right/rightNameTxt"
local rightDistanceTxt_txt_path = "mainContent/right/rightDistanceTxt"
local right_righthead_path = "mainContent/right/righthead"
local right_playerHead_path = "mainContent/right/righthead/RightUIPlayerHead/RightHeadIcon"
local right_playerHeadFg_path = "mainContent/right/righthead/RightUIPlayerHead/rForeground"
local right_BossHead_path = "mainContent/right/righthead/RightUIPlayerHead/RightBossHead"
local right_CityHead_path = "mainContent/right/righthead/RightUIPlayerHead/RightCityHead"
local right_otherHead_path = "mainContent/right/otherhead"
local slider_rect_path = "mainContent/sliderBg"
local slider_path = "mainContent/sliderBg/Slider"
local slider_bg_path = "mainContent/sliderBg/Slider/FillArea/Fill"
local march_txt_path = "mainContent/sliderBg/Slider/FillArea/progressTxt"
local LmarchMax_rect_path = "mainContent/LeftMarchRect"
local RmarchMax_rect_path = "mainContent/RightMarchRect"
local LmarchMax_txt_path = "mainContent/LeftMarchRect/LMarchNumRect/LMarchMax_Txt"
local RmarchMax_txt_path = "mainContent/RightMarchRect/RMarchNumRect/RMarchMax_Txt"
local time_txt_path = "mainContent/sliderBg/TimeTxt"
local layout_rect = "mainContent/layout"
local join_btn_path = "mainContent/layout/joinButton"
local cancel_btn_path = "mainContent/layout/cancelButton"
local depart_btn_path = "mainContent/left/Depart_Btn"
local depart_txt_path = "mainContent/left/Depart_Btn/Depart_Txt"
local marchState = {
  [1] = "Common_pro_green",
  [2] = "Common_pro_yellow",
  [3] = "Common_pro_red"
}
local SliderLength = 488

local function OnCreate(self)
  base.OnCreate(self)
  self.isUpdate = false
  self.isJoin = false
  self.itemBg_img = self:AddComponent(UIImage, itembg_img_path)
  self.dir1_img = self:AddComponent(UIImage, dir1_img_path)
  self.dir2_img = self:AddComponent(UIImage, dir2_img_path)
  self.march_txt = self:AddComponent(UIText, march_txt_path)
  self.bg_btn = self:AddComponent(UIButton, bg_btn_path)
  self.bg_btn:SetOnClick(function()
    self:OnBgClick()
  end)
  self.left_pos_btn = self:AddComponent(UIButton, left_pos_btn_path)
  self.left_pos_btn:SetOnClick(function()
    self:OnLeftPosClick()
  end)
  self.left_name = self:AddComponent(UIText, left_name_path)
  self.left_pos_txt = self:AddComponent(UIText, left_pos_txt_path)
  self.distance_obj = self:AddComponent(UIBaseContainer, distance_obj_path)
  self.distance_txt = self:AddComponent(UIText, distance_txt_path)
  self.depart_btn = self:AddComponent(UIButton, depart_btn_path)
  self.depart_txt = self:AddComponent(UIText, depart_txt_path)
  self.depart_btn:SetOnClick(function()
    self:OnDepartClick()
  end)
  self.right_pos_btn = self:AddComponent(UIButton, right_pos_btn_path)
  self.right_pos_btn:SetOnClick(function()
    self:OnRightPosClick()
  end)
  self.right_name = self:AddComponent(UIText, right_name_path)
  self.right_pos_txt = self:AddComponent(UIText, right_pos_txt_path)
  self.rightDistance_txt = self:AddComponent(UIText, rightDistanceTxt_txt_path)
  self.right_righthead = self:AddComponent(UIBaseContainer, right_righthead_path)
  self.right_otherHead = self:AddComponent(UIImage, right_otherHead_path)
  self.slider_rect = self:AddComponent(UIBaseContainer, slider_rect_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self._sliderBg = self:AddComponent(UIImage, slider_bg_path)
  self.LmarchMax_rect = self:AddComponent(UIBaseContainer, LmarchMax_rect_path)
  self._LmarchNumTab = {}
  for i = 1, 6 do
    local rectpath = "mainContent/LeftMarchRect/LMemberNum" .. i
    self._LmarchNumTab[i] = self:AddComponent(UIImage, rectpath)
  end
  self.LmarchMax_txt = self:AddComponent(UIText, LmarchMax_txt_path)
  self.RmarchMax_rect = self:AddComponent(UIBaseContainer, RmarchMax_rect_path)
  self._RmarchNumTab = {}
  for i = 1, 6 do
    local rectpath = "mainContent/RightMarchRect/RMemberNum" .. i
    self._RmarchNumTab[i] = self:AddComponent(UIImage, rectpath)
  end
  self.RmarchMax_txt = self:AddComponent(UIText, RmarchMax_txt_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.layout_rect = self:AddComponent(UIBaseContainer, layout_rect)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(function()
    self:OnJoinClick()
  end)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancel_btn:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.left_playerHead = self:AddComponent(UIPlayerHead, left_playerHead_path)
  self.left_CityHead = self:AddComponent(UIBaseContainer, left_CityHead_path)
  self.left_playerHeadBg = self:AddComponent(UIImage, left_playerHeadFg_path)
  self.left_playerHeadBg.transform:SetAsLastSibling()
  self.right_playerHead = self:AddComponent(UIPlayerHead, right_playerHead_path)
  self.right_playerHeadBg = self:AddComponent(UIImage, right_playerHeadFg_path)
  self.right_playerHeadBg.transform:SetAsLastSibling()
  self.right_bossHead = self:AddComponent(UIBaseContainer, right_BossHead_path)
  self.right_CityHead = self:AddComponent(UIBaseContainer, right_CityHead_path)
  self:SetActive(true)
  self._timer_alliance = nil
  
  function self._timer_action(temp)
    self:UpdateSlider()
  end
end

local function OnDestroy(self)
  self.itemBg_img = nil
  self.dir1_img = nil
  self.dir2_img = nil
  self.march_txt = nil
  self.bg_btn = nil
  self.left_pos_btn = nil
  self.left_name = nil
  self.left_pos_txt = nil
  self.distance_obj = nil
  self.distance_txt = nil
  self.depart_btn = nil
  self.depart_txt = nil
  self.right_pos_btn = nil
  self.right_name = nil
  self.right_pos_txt = nil
  self.slider = nil
  self._sliderBg = nil
  self.LmarchMax_rect = nil
  self.RmarchMax_rect = nil
  self._LmarchNumTab = nil
  self._RmarchNumTab = nil
  self.LmarchMax_txt = nil
  self.RmarchMax_txt = nil
  self.layout_rect = nil
  self.time_txt = nil
  self.join_btn = nil
  self.cancel_btn = nil
  self.isUpdate = nil
  self.left_playerHead = nil
  self.left_CityHead = nil
  self.right_playerHead = nil
  self.right_bossHead = nil
  self.right_CityHead = nil
  self.goback_txt = nil
  if self._timer_alliance ~= nil then
    self._timer_alliance:Stop()
    self._timer_alliance = nil
  end
  base.OnDestroy(self)
end

local function RefreshData(self, isAlert)
  self.isAlert = isAlert
  if isAlert then
    self.alertInfo = DataCenter.AllianceAlertDataManager:GetAllianceAlertDataByKey(self.uuid)
    if not self.alertInfo then
      return
    end
    self.LmarchMax_rect:SetActive(false)
    self.RmarchMax_rect:SetActive(true)
    for i = 1, 6 do
      self._RmarchNumTab[i]:SetActive(false)
    end
    self.RmarchMax_txt:SetText(Localization:GetString("141098") .. " " .. self.alertInfo.num)
    self.layout_rect:SetActive(false)
    self.right_righthead:SetActive(true)
    self.right_pos_txt:SetActive(false)
    self.rightDistance_txt:SetActive(false)
    self.dir1_img:SetLocalScaleXYZ(1, 1, 1)
    self.dir2_img:SetLocalScaleXYZ(1, 1, 1)
    self.march_txt:SetLocalText(141100)
    self.time_txt:SetLocalText(141099)
    if self.alertInfo.atkAlAbbr and self.alertInfo.atkAlAbbr ~= "" then
      self.right_name:SetText("[" .. self.alertInfo.atkAlAbbr .. "]" .. self.alertInfo.atkName)
    else
      self.right_name:SetText(self.alertInfo.atkName)
    end
    self.right_otherHead:SetActive(false)
    self.right_playerHead:SetData(self.alertInfo.atkUid, self.alertInfo.atkPic, self.alertInfo.atkPicVer)
    if self.alertInfo.atkHeadFrame > 0 then
      self.right_playerHeadBg:SetActive(true)
    else
      self.right_playerHeadBg:SetActive(false)
    end
    self.slider:SetValue(1)
    self.itemBg_img:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_supple_red"))
    self._sliderBg:LoadSprite(string.format(LoadPath.CommonNewPath, marchState[3]))
    if self.alertInfo.type == AllianceAlertType.ALLIANCE_CITY then
      local nameKey = GetTableData(TableName.WorldCity, self.alertInfo.content, "name")
      self.left_name:SetLocalText(nameKey)
    else
      self.left_name:SetText("[" .. self.alertInfo.alAbbr .. "]" .. self.alertInfo.name)
    end
    self.left_name:SetColorRGBA(0.1607843, 0.7137255, 0.9411765, 1)
    self.left_CityHead:SetActive(self.alertInfo.type == AllianceAlertType.ALLIANCE_CITY)
    self.left_playerHead:SetActive(self.alertInfo.type ~= AllianceAlertType.ALLIANCE_CITY)
    self.left_playerHead:SetData(self.alertInfo.targetUid, self.alertInfo.pic, self.alertInfo.picVer)
    if self.alertInfo.headFrame == 1 then
      self.left_playerHeadBg:SetActive(true)
    else
      self.left_playerHeadBg:SetActive(false)
    end
    local rightPos = SceneUtils.IndexToTilePos(self.alertInfo.point)
    local distance = math.ceil(SceneUtils.TileDistance(rightPos, DataCenter.BuildManager.main_city_pos))
    self.left_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, rightPos.x, rightPos.y)
    self.distance_txt:SetText(distance .. Localization:GetString(GameDialogDefine.KILOMETRE))
    return
  end
  self.isUpdate = false
  self.dataInfo = self.view.ctrl:GetWarItemData(self.uuid)
  if self.dataInfo.createTime == 0 then
    return
  end
  self.right_otherHead:SetActive(false)
  self.right_righthead:SetActive(true)
  self.right_pos_txt:SetActive(true)
  self.rightDistance_txt:SetActive(true)
  self.LmarchMax_rect:SetActive(not self.dataInfo.isAttack)
  self.RmarchMax_rect:SetActive(self.dataInfo.isAttack)
  self.march_txt:SetLocalText(self.dataInfo.isAttack and 141034 or 141035)
  self.right_bossHead:SetActive(self.dataInfo.type == AllianceTeamType.ATTACK_BOSS)
  self.right_playerHead:SetActive(self.dataInfo.type ~= AllianceTeamType.ATTACK_BOSS)
  local leftPos = SceneUtils.IndexToTilePos(self.dataInfo.leftPointId, ForceChangeScene.World)
  local rightPos = SceneUtils.IndexToTilePos(self.dataInfo.rightPointId, ForceChangeScene.World)
  if self.dataInfo.isAttack then
    self.left_CityHead:SetActive(self.dataInfo.type == AllianceTeamType.ATTACK_AL_CITY)
    self.left_name:SetText(self.dataInfo.rightName)
    self.right_name:SetText(self.dataInfo.leftName)
    self.left_playerHead:SetActive(self.dataInfo.type ~= AllianceTeamType.ATTACK_AL_CITY)
    self.left_playerHead:SetData(self.dataInfo.targetUid, self.dataInfo.targetIcon, self.dataInfo.targetIconVer)
    if self.dataInfo.targetHeadBg then
      self.left_playerHeadBg:SetActive(true)
    else
      self.left_playerHeadBg:SetActive(false)
    end
    self.right_playerHead:SetData(self.dataInfo.attackUid, self.dataInfo.attackIcon, self.dataInfo.ownerIconVer)
    if self.dataInfo.ownerHeadBg then
      self.right_playerHeadBg:SetActive(true)
    else
      self.right_playerHeadBg:SetActive(false)
    end
    self.dir1_img:SetLocalScaleXYZ(1, 1, 1)
    self.dir2_img:SetLocalScaleXYZ(1, 1, 1)
    self.left_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, rightPos.x, rightPos.y)
    self.right_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
    self.itemBg_img:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_supple_red"))
  else
    self.right_name:SetText(self.dataInfo.rightName)
    self.left_name:SetText(self.dataInfo.leftName)
    self.left_playerHead:SetData(self.dataInfo.attackUid, self.dataInfo.attackIcon, self.dataInfo.ownerIconVer)
    if self.dataInfo.targetHeadBg then
      self.left_playerHeadBg:SetActive(true)
    else
      self.left_playerHeadBg:SetActive(false)
    end
    self.right_CityHead:SetActive(self.dataInfo.type == AllianceTeamType.ATTACK_AL_CITY)
    if self.dataInfo.type == AllianceTeamType.ATTACK_BOSS then
      self.right_playerHead:SetActive(false)
    else
      self.right_playerHead:SetActive(self.dataInfo.type ~= AllianceTeamType.ATTACK_AL_CITY)
      self.right_playerHead:SetData(self.dataInfo.targetUid, self.dataInfo.targetIcon, self.dataInfo.targetIconVer)
      if self.dataInfo.ownerHeadBg then
        self.right_playerHeadBg:SetActive(true)
      else
        self.right_playerHeadBg:SetActive(false)
      end
    end
    self.dir1_img:SetLocalScaleXYZ(-1, 1, 1)
    self.dir2_img:SetLocalScaleXYZ(-1, 1, 1)
    self.left_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
    self.right_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, rightPos.x, rightPos.y)
    self.itemBg_img:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_bg_item_supple"))
  end
  self.right_name:SetColorRGBA(0.9882353, 0.3176471, 0.3019608, 1)
  if self.dataInfo.isSelfAttack or self.dataInfo.cancel then
    self.left_name:SetColorRGBA(0.2941177, 0.8235294, 0.08235294, 1)
  else
    self.left_name:SetColorRGBA(0.1607843, 0.7137255, 0.9411765, 1)
  end
  self.distance_obj:SetActive(0 < self.dataInfo.leftDistance)
  self.distance_txt:SetText(self.dataInfo.leftDistance .. Localization:GetString(GameDialogDefine.KILOMETRE))
  self.rightDistance_txt:SetActive(0 < self.dataInfo.rightDistance)
  self.rightDistance_txt:SetText(self.dataInfo.rightDistance .. Localization:GetString(GameDialogDefine.KILOMETRE))
  self.depart_btn:SetActive(false)
  self.depart_txt:SetLocalText(141073)
  self.layout_rect:SetActive(true)
  local iscancel = self.dataInfo.cancel and self.view.ctrl:GetInMarchState(self.uuid) == false
  self.cancel_btn:SetActive(iscancel)
  for i = 1, 6 do
    if self.dataInfo.isAttack then
      self._RmarchNumTab[i]:SetActive(i <= self.dataInfo.assemblyMarchMax)
      if i <= self.dataInfo.canJoinNum then
        self._RmarchNumTab[i]:SetColorRGBA(0.7176471, 0.4, 0.1882353, 1)
      else
        self._RmarchNumTab[i]:SetColorRGBA(0.8039216, 0.7686275, 0.6980392, 1)
      end
    else
      self._LmarchNumTab[i]:SetActive(i <= self.dataInfo.assemblyMarchMax)
      if i <= self.dataInfo.canJoinNum then
        self._LmarchNumTab[i]:SetColorRGBA(0.7176471, 0.4, 0.1882353, 1)
      else
        self._LmarchNumTab[i]:SetColorRGBA(0.8039216, 0.7686275, 0.6980392, 1)
      end
    end
  end
  self.LmarchMax_txt:SetText(self.dataInfo.canJoinNum .. "/" .. self.dataInfo.assemblyMarchMax)
  self.RmarchMax_txt:SetText(self.dataInfo.canJoinNum .. "/" .. self.dataInfo.assemblyMarchMax)
  self:UpdateSlider()
  self:AddAllianceTimer()
  if self.dataInfo.join and self.dataInfo.canJoinNum == self.dataInfo.assemblyMarchMax then
    self.layout_rect:SetActive(false)
  elseif self.dataInfo.isAttack then
    self.layout_rect:SetActive(false)
  end
  if self.isUpdate then
    self.join_btn:SetActive(self.dataInfo.join and self.isJoin)
  else
    self.join_btn:SetActive(false)
  end
end

local function SetUuid(self, uuid)
  self.uuid = uuid
end

local function AddAllianceTimer(self)
  if self._timer_alliance == nil then
    self._timer_alliance = TimerManager:GetInstance():GetTimer(1, self._timer_action, self, false, false, false)
    self._timer_alliance:Start()
  end
end

local function UpdateSlider(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  local maxTime = 0
  local dialog = "141032"
  local march = 1
  if curTime < self.dataInfo.waitTime then
    self.isUpdate = true
    deltaTime = self.dataInfo.waitTime - curTime
    maxTime = self.dataInfo.waitTime - self.dataInfo.createTime
    dialog = "141032"
    march = 1
    self.isJoin = true
  elseif curTime < self.dataInfo.marchTime then
    self.isUpdate = true
    deltaTime = self.dataInfo.marchTime - curTime
    maxTime = self.dataInfo.marchTime - self.dataInfo.createTime
    dialog = "390789"
    march = 2
    self.isJoin = false
  else
    self.isUpdate = false
    self.isJoin = false
  end
  if not self.isUpdate then
    if curTime < self.dataInfo.marchendTime then
      dialog = "141033"
      deltaTime = self.dataInfo.marchendTime - curTime
      march = 2
    else
      dialog = 141029
      march = 3
    end
    self.depart_btn:SetActive(false)
  end
  if self.isUpdate then
    local tempValue = 1 - deltaTime / maxTime
    self.slider:SetValue(tempValue)
    self.time_txt:SetText(Localization:GetString(dialog) .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    self.join_btn:SetActive(self.dataInfo.join and self.isJoin)
  else
    self.slider:SetValue(1)
    if 0 < deltaTime then
      self.time_txt:SetText(Localization:GetString(dialog) .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.time_txt:SetLocalText(dialog)
    end
    self.join_btn:SetActive(false)
    self.cancel_btn:SetActive(false)
  end
  self._sliderBg:LoadSprite(string.format(LoadPath.CommonNewPath, marchState[march]))
  if self.dataInfo.cancel and self.dataInfo.canJoinNum == self.dataInfo.assemblyMarchMax and curTime > self.dataInfo.waitMemberTime and march ~= 2 and march ~= 3 and self.dataInfo.type == AllianceTeamType.ATTACK_BOSS then
    self.depart_btn:SetActive(true)
  end
end

local function OnLeftPosClick(self)
  if self.isAlert then
    self.view.ctrl:OnClickPosBtn(self.alertInfo.point, nil, nil, self.alertInfo.serverId, self.alertInfo.worldId, self.alertInfo.worldType)
    return
  end
  if self.dataInfo.isAttack then
    self.view.ctrl:OnClickPosBtn(self.dataInfo.rightPointId, nil, nil, self.dataInfo.serverId, self.dataInfo.worldId, self.dataInfo.worldType)
  else
    self.view.ctrl:OnClickPosBtn(self.dataInfo.leftPointId, nil, nil, self.dataInfo.worldId, self.dadataInfota.worldType)
  end
end

local function OnRightPosClick(self)
  if self.dataInfo.isAttack then
    self.view.ctrl:OnClickPosBtn(self.dataInfo.leftPointId, nil, nil, self.dataInfo.serverId, self.dataInfo.worldId, self.dataInfo.worldType)
  else
    self.view.ctrl:OnClickPosBtn(self.dataInfo.rightPointId, nil, nil, self.dataInfo.serverId, self.dataInfo.worldId, self.dataInfo.worldType)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnBgClick(self)
  if self.isAlert then
    self.view.ctrl:OpenAlertInfo(self.alertInfo, 2)
    return
  end
  if self.dataInfo.targetUid == LuaEntry.Player.uid then
    return
  end
  self.view.ctrl:OnOpenClick(self.uuid, true, self.dataInfo.isAttack)
end

local function OnJoinClick(self)
  self.view.ctrl:OnJoinClick(self.uuid)
end

local function OnCancelClick(self)
  UIUtil.ShowMessage(Localization:GetString("110151"), 2, nil, nil, function()
    self.view.ctrl:OnCancelClick(self.uuid)
  end, nil, nil)
end

local function OnGoBackClick(self)
  UIUtil.ShowMessage(Localization:GetString("110151", self.dataInfo.ownerName), 2, nil, nil, function()
    self.view.ctrl:OnRetreatClick(self.uuid, self.view.ctrl:IsHaveMeMarch(self.uuid))
  end, nil, nil)
end

local function OnDepartClick(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceTeamDirectMove, self.dataInfo.teamUuid)
end

local function GetSelfData(self)
  return self.dataInfo
end

AllianceWarItem.OnCreate = OnCreate
AllianceWarItem.OnDestroy = OnDestroy
AllianceWarItem.OnEnable = OnEnable
AllianceWarItem.OnDisable = OnDisable
AllianceWarItem.RefreshData = RefreshData
AllianceWarItem.OnLeftPosClick = OnLeftPosClick
AllianceWarItem.OnRightPosClick = OnRightPosClick
AllianceWarItem.SetUuid = SetUuid
AllianceWarItem.UpdateSlider = UpdateSlider
AllianceWarItem.AddAllianceTimer = AddAllianceTimer
AllianceWarItem.OnBgClick = OnBgClick
AllianceWarItem.OnJoinClick = OnJoinClick
AllianceWarItem.OnCancelClick = OnCancelClick
AllianceWarItem.GetSelfData = GetSelfData
AllianceWarItem.OnGoBackClick = OnGoBackClick
AllianceWarItem.OnDepartClick = OnDepartClick
return AllianceWarItem
