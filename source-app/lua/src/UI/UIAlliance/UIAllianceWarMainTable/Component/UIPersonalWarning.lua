local UIPersonalWarning = BaseClass("UIPersonalWarning", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_btn_path = "mainContent/BgButton"
local left_pos_btn_path = "mainContent/left/layout/leftNameTxt/leftPosTxt/leftPosBtn"
local pos_txt_path = "mainContent/left/layout/leftNameTxt/leftPosTxt"
local left_name_path = "mainContent/left/layout/leftNameTxt"
local left_name_btn_path = "mainContent/left/layout/leftNameTxt/leftNameBtn"
local warningType_txt_path = "mainContent/left/WarningType_Txt"
local right_rect_path = "mainContent/right"
local right_pos_btn_path = "mainContent/right/rightNameTxt/rightPosBtn"
local right_pos_txt_path = "mainContent/right/rightPosTxt"
local right_name_path = "mainContent/right/rightNameTxt"
local right_endTime_path = "mainContent/right/Txt_EndTime"
local right_otherPos_path = "mainContent/right/Btn_OtherPos"
local des_txt_path = "mainContent/left/layout/DesTxt"
local btn_prevent_path = "mainContent/Btn_prevent"
local btn_relieve_path = "mainContent/Btn_relieve"
local img_typeBg_path = "mainContent/type_ImgBg"
local txt_typeIcon_path = "mainContent/type_ImgBg/type_imgIcon"
local see_btn_path = "mainContent/Btn_See"
local see_txt_path = "mainContent/Btn_See/Txt_See"
local seeArmy_btn_path = "mainContent/Btn_SeeArmy"

local function OnCreate(self)
  base.OnCreate(self)
  self.isUpdate = false
  self.bg_btn = self:AddComponent(UIButton, see_btn_path)
  self.see_txt = self:AddComponent(UIText, see_txt_path)
  self.see_txt:SetLocalText(110076)
  self.bg_btn:SetOnClick(function()
    self:OnBgClick()
  end)
  self.left_pos_btn = self:AddComponent(UIButton, left_pos_btn_path)
  self.left_pos_btn:SetOnClick(function()
    self:OnLeftPosClick()
  end)
  self.left_name = self:AddComponent(UIText, left_name_path)
  self.left_name_btn = self:AddComponent(UIButton, left_name_btn_path)
  self.left_name_btn:SetOnClick(function()
    self:OnLeftPlayerInfoClick()
  end)
  self._warningType_txt = self:AddComponent(UIText, warningType_txt_path)
  self._pos_txt = self:AddComponent(UIText, pos_txt_path)
  self.right_rect = self:AddComponent(UIBaseContainer, right_rect_path)
  self.right_pos_btn = self:AddComponent(UIButton, right_pos_btn_path)
  self.right_pos_btn:SetOnClick(function()
    self:OnRightPosClick()
  end)
  self.right_name = self:AddComponent(UIText, right_name_path)
  self._right_endTime_txt = self:AddComponent(UIText, right_endTime_path)
  self.right_pos_txt = self:AddComponent(UIText, right_pos_txt_path)
  self._des_txt = self:AddComponent(UIText, des_txt_path)
  self._btn_prevent = self:AddComponent(UIButton, btn_prevent_path)
  self._btn_prevent:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnHideWarning()
  end)
  self._btn_relieve = self:AddComponent(UIButton, btn_relieve_path)
  self._btn_relieve:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShowWarning()
  end)
  self._typeBg_img = self:AddComponent(UIImage, img_typeBg_path)
  self._typeIcon_img = self:AddComponent(UIImage, txt_typeIcon_path)
  self._timer_alliance = nil
  
  function self._timer_action(temp)
    self:UpdateAllianceTime()
  end
  
  self._timer_personal = nil
  
  function self._timer_action_temp(temp)
    self:UpdatePersonalTime()
  end
  
  self._seeArmy_btn = self:AddComponent(UIButton, seeArmy_btn_path)
  self._seeArmy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRightMarchPosClick()
  end)
end

local function OnDestroy(self)
  self.bg_btn = nil
  self.left_pos_btn = nil
  self.left_name = nil
  self._warningType_txt = nil
  self._pos_txt = nil
  self.right_pos_btn = nil
  self.right_name = nil
  self.right_pos_txt = nil
  self.isUpdate = nil
  self._des_txt = nil
  if self._timer_alliance ~= nil then
    self._timer_alliance:Stop()
    self._timer_alliance = nil
  end
  if self._timer_personal ~= nil then
    self._timer_personal:Stop()
    self._timer_personal = nil
  end
  base.OnDestroy(self)
end

local function SetBtnSeeState(self, state)
  if self.dataInfo then
    if self.dataInfo.type == WarningType.Scout then
      self.bg_btn:SetActive(false)
    else
      self.bg_btn:SetActive(state)
    end
  end
end

local function RefreshData(self)
  self.isUpdate = false
  self.right_rect:SetActive(true)
  if type(self.data) == "number" then
    self.bg_btn:SetActive(true)
    self.dataInfo = self.view.ctrl:GetWarItemData(self.data)
    local leftPos = SceneUtils.IndexToTilePos(self.dataInfo.leftPointId, ForceChangeScene.World)
    self._pos_txt:SetActive(true)
    self._pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
    self:UpdateAllianceTime()
    self:AddAllianceTimer()
    self._btn_prevent:SetActive(DataCenter.AllianceWarDataManager:GetIgnoreList(self.dataInfo.uuid) == 1)
    self._btn_relieve:SetActive(DataCenter.AllianceWarDataManager:GetIgnoreList(self.dataInfo.uuid) ~= 1)
    local list = self.view.ctrl:GetAllSoldiersInfo(self.data)
    local num = 0
    for i, v in pairs(list) do
      num = num + v
    end
    self._des_txt:SetLocalText(310160, string.GetFormattedSeperatorNum(num))
    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_img_redbg"))
    self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_icon_attack"))
  elseif self.data.isCross then
    self.right_rect:SetActive(false)
    self._btn_prevent:SetActive(false)
    self._btn_relieve:SetActive(false)
    self.bg_btn:SetActive(false)
    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_img_redbg"))
    self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_icon_attack"))
    self._warningType_txt:SetLocalText(110219, self.data.serverId)
  else
    self.bg_btn:SetActive(true)
    if self.data.isVirtual ~= nil and self.data.isVirtual == true then
      self._pos_txt:SetActive(false)
      self._des_txt:SetText("")
      self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_img_greenbg"))
      self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_icon_help"))
      self._warningType_txt:SetText("")
      self._btn_prevent:SetActive(false)
      self._btn_relieve:SetActive(false)
      self:UpdatePersonalTime()
      self:AddPersonalTimer()
    else
      self._pos_txt:SetActive(false)
      self.dataInfo = self.view.ctrl:GetPersonalItemData(self.data.ownerFormationUuid)
      if not self.dataInfo then
        if self._timer_personal ~= nil then
          self._timer_personal:Stop()
          self._timer_personal = nil
        end
        return
      end
      self._des_txt:SetText(self.dataInfo.soldierNum)
      if self.dataInfo.type == WarningType.Attack then
        self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_img_redbg"))
        self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_icon_attack"))
        self._warningType_txt:SetLocalText(110143)
      elseif self.dataInfo.type == WarningType.Scout then
        self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_img_orangebg"))
        self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_icon_scout"))
        self._warningType_txt:SetLocalText(110142)
      elseif self.dataInfo.type == WarningType.Assistance then
        self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_img_bluebg"))
        self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_icon_assemble"))
        self._warningType_txt:SetLocalText(110141)
      elseif self.dataInfo.type == WarningType.ResourceAssistance then
        self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_img_greenbg"))
        self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail, "UIalarm_icon_help"))
      end
      self:UpdatePersonalTime()
      self:AddPersonalTimer()
      self._btn_prevent:SetActive(not DataCenter.RadarAlarmDataManager:IsCancel(self.dataInfo.uuid))
      self._btn_relieve:SetActive(DataCenter.RadarAlarmDataManager:IsCancel(self.dataInfo.uuid))
    end
  end
  if type(self.data) ~= "number" then
    if not self.data.isCross then
      if self.data.isVirtual ~= nil and self.data.isVirtual == true then
        self.left_name:SetText(self.data.leftName)
        self.right_name:SetText(self.data.rightName)
      else
        self.left_name:SetText(self.dataInfo.leftName)
        self.right_name:SetText(self.dataInfo.rightName)
      end
    end
  else
    self.left_name:SetText(self.dataInfo.leftName)
    self.right_name:SetText(self.dataInfo.rightName)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.right_name.rectTransform)
end

local function SetData(self, data)
  self.data = data
end

local function AddAllianceTimer(self)
  if self._timer_alliance == nil then
    self._timer_alliance = TimerManager:GetInstance():GetTimer(1, self._timer_action, self, false, false, false)
    self._timer_alliance:Start()
  end
end

local function UpdateAllianceTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  local maxTime = 0
  local dialog = 141032
  if curTime < self.dataInfo.waitTime then
    self.isUpdate = true
    deltaTime = self.dataInfo.waitTime - curTime
    dialog = 141032
    self._warningType_txt:SetLocalText(141037)
  elseif curTime < self.dataInfo.marchTime then
    self.isUpdate = true
    deltaTime = self.dataInfo.marchTime - curTime
    dialog = 390789
    self._warningType_txt:SetLocalText(141039)
  else
    self.isUpdate = false
  end
  if not self.isUpdate then
    if curTime < self.dataInfo.marchendTime then
      dialog = 141033
    else
      dialog = 141029
    end
    self._warningType_txt:SetLocalText(141038)
  end
  if self.isUpdate then
    self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  elseif dialog == 141033 then
    self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.dataInfo.marchendTime - curTime))
  else
    self._right_endTime_txt:SetLocalText(dialog)
  end
end

local function AddPersonalTimer(self)
  if self._timer_personal == nil then
    self._timer_personal = TimerManager:GetInstance():GetTimer(1, self._timer_action_temp, self, false, false, false)
    self._timer_personal:Start()
  end
end

local function UpdatePersonalTime(self)
  if self.data.isVirtual ~= nil and self.data.isVirtual == true then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.data.endTime - curTime
    if deltaTime <= 0 then
      self._right_endTime_txt:SetText("00:00:00")
      if self._timer_personal ~= nil then
        self._timer_personal:Stop()
        self._timer_personal = nil
        return
      end
    end
    self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  elseif self.dataInfo.status == MarchStatus.MOVING or self.dataInfo.status == MarchStatus.CHASING then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.dataInfo.endTime - curTime
    if deltaTime <= 0 then
      self._right_endTime_txt:SetLocalText(100150)
      if self._timer_personal ~= nil then
        self._timer_personal:Stop()
        self._timer_personal = nil
      end
    end
    self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  else
    self._right_endTime_txt:SetText("00:00:00")
  end
end

local function OnLeftPosClick(self)
  if type(self.data) ~= "number" and self.data.isVirtual ~= nil and self.data.isVirtual == true then
    return
  end
  self.view.ctrl:OnClickPosBtn(self.dataInfo.leftPointId, false, nil, self.dataInfo.serverId, self.dataInfo.worldId, self.dataInfo.worldType)
end

local function OnRightPosClick(self)
  if type(self.data) ~= "number" and self.data.isVirtual ~= nil and self.data.isVirtual == true then
    return
  end
  self.view.ctrl:OnClickPosBtn(self.dataInfo.rightPointId, false, nil, self.dataInfo.serverId, self.dataInfo.worldId, self.dataInfo.worldType)
end

local function OnRightMarchPosClick(self)
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if type(self.data) ~= "number" then
    if self.data.isCross then
      GoToUtil.CloseAllWindows()
      local position = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
      if self.data.serverId ~= LuaEntry.Player:GetSelfServerId() then
        local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
        if crossBuildData ~= nil then
          local targetServerId = crossBuildData.server
          local pointId = crossBuildData.pointId
          if 0 < pointId then
            position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
            position.x = position.x - 1
            position.y = position.y
            position.z = position.z - 1
          end
        end
      end
      GoToUtil.GotoWorldPos(position, CS.SceneManager.World.InitZoom, nil, function()
      end, self.data.serverId, self.data.worldId, self.data.worldType)
    else
      if self.data.isVirtual ~= nil and self.data.isVirtual == true then
        return
      end
      local pos = self.data:GetMarchCurPos()
      self.view.ctrl:OnClickPosBtn(pos, true, self.data.uuid, self.data.serverId, self.data.worldId, self.data.worldType)
    end
  else
    local info = CS.SceneManager.World:GetMarch(self.dataInfo.leaderMarchUuid)
    if info then
      if info:GetMarchStatus() == MarchStatus.WAIT_RALLY then
        self.view.ctrl:OnClickPosBtn(self.dataInfo.leftPointId, false, nil, self.dataInfo.serverId, self.dataInfo.worldId, self.dataInfo.worldType)
      else
        local v3 = {}
        v3.x = info.position.x
        v3.y = info.position.y
        v3.z = info.position.z
        self.view.ctrl:OnClickPosBtn(v3, true, nil, self.dataInfo.serverId, self.dataInfo.worldId, self.dataInfo.worldType)
      end
    else
      self.view.ctrl:OnClickPosBtn(SceneUtils.TileToWorld(LuaEntry.Player:GetMainWorldPos()), true, nil, LuaEntry.Player:GetSelfServerId(), LuaEntry.Player:GetCurWorldId(), LuaEntry.Player:GetCurWorldType())
    end
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function GetSelfData(self)
  return self.dataInfo
end

local function OnBgClick(self)
  if type(self.data) ~= "number" and self.data.isVirtual ~= nil and self.data.isVirtual == true then
    return
  end
  if self.dataInfo.type and self.dataInfo.type == WarningType.Scout then
    return
  end
  self.view.ctrl:OnOpenClick(self.data, false)
end

local function SetRelieve(self, state)
  self._btn_relieve:SetActive(true)
  self._btn_prevent:SetActive(false)
end

local function OnHideWarning(self)
  if type(self.data) ~= "number" and self.data.isVirtual ~= nil and self.data.isVirtual == true then
    return
  end
  if type(self.data) == "number" then
    DataCenter.AllianceWarDataManager:SetIgnoreList(self.dataInfo.uuid, 2)
    EventManager:GetInstance():Broadcast(EventId.IgnoreAllianceMarch, false)
    self._btn_relieve:SetActive(true)
    self._btn_prevent:SetActive(false)
  else
    DataCenter.RadarAlarmDataManager:AddToCancelList(self.dataInfo.uuid)
    EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch, true)
    self._btn_relieve:SetActive(true)
    self._btn_prevent:SetActive(false)
  end
  UIUtil.ShowTipsId(141026)
end

local function OnShowWarning(self)
  if type(self.data) ~= "number" and self.data.isVirtual ~= nil and self.data.isVirtual == true then
    return
  end
  if type(self.data) == "number" then
    DataCenter.AllianceWarDataManager:SetIgnoreList(self.dataInfo.uuid, 1)
    EventManager:GetInstance():Broadcast(EventId.IgnoreAllianceMarch, true)
    self._btn_relieve:SetActive(false)
    self._btn_prevent:SetActive(true)
  else
    DataCenter.RadarAlarmDataManager:RemoveToCancelList(self.dataInfo.uuid, true)
    EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch, false)
    self._btn_relieve:SetActive(false)
    self._btn_prevent:SetActive(true)
  end
  UIUtil.ShowTipsId(141027)
end

local function OnLeftPlayerInfoClick(self)
  if type(self.data) ~= "number" then
    if self.data.isVirtual ~= nil and self.data.isVirtual == true then
      return
    end
    self.view.ctrl:OnLeftPlayerInfoClick(self.data.ownerUid)
  else
    self.view.ctrl:OnLeftPlayerInfoClick(self.dataInfo.attackUid)
  end
end

UIPersonalWarning.OnCreate = OnCreate
UIPersonalWarning.OnDestroy = OnDestroy
UIPersonalWarning.SetBtnSeeState = SetBtnSeeState
UIPersonalWarning.OnEnable = OnEnable
UIPersonalWarning.OnDisable = OnDisable
UIPersonalWarning.RefreshData = RefreshData
UIPersonalWarning.OnLeftPosClick = OnLeftPosClick
UIPersonalWarning.OnRightPosClick = OnRightPosClick
UIPersonalWarning.OnRightMarchPosClick = OnRightMarchPosClick
UIPersonalWarning.SetData = SetData
UIPersonalWarning.OnBgClick = OnBgClick
UIPersonalWarning.AddAllianceTimer = AddAllianceTimer
UIPersonalWarning.UpdateAllianceTime = UpdateAllianceTime
UIPersonalWarning.AddPersonalTimer = AddPersonalTimer
UIPersonalWarning.UpdatePersonalTime = UpdatePersonalTime
UIPersonalWarning.GetSelfData = GetSelfData
UIPersonalWarning.SetRelieve = SetRelieve
UIPersonalWarning.OnHideWarning = OnHideWarning
UIPersonalWarning.OnShowWarning = OnShowWarning
UIPersonalWarning.OnLeftPlayerInfoClick = OnLeftPlayerInfoClick
return UIPersonalWarning
