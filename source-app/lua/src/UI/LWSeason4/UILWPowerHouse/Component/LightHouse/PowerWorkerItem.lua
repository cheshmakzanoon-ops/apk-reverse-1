local PowerWorkerItem = BaseClass("PowerWorkerItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local icon_build_path = "bg/icon_build"
local build_path = "Build"
local info_path = "Build/info"
local task_title_path = "Build/info/task_title"
local task_desc_path = "Build/info/task_desc"
local goto_fix_btn_path = "Build/gotoFixBtn"
local btn_fix_des_path = "Build/gotoFixBtn/BtnFixDes"
local worker_path = "Worker"
local worker_title_path = "Worker/worker_title"
local worker_time_start_path = "Worker/worker_time_start"
local worker_desc_path = "Worker/worker_desc"
local worker_time_use_path = "Worker/bottom/worker_time_use"
local worker_callback_path = "Worker/bottom/worker_callback"
local worker_pos_path = "Worker/worker_pos"
local worker_status_path = "Worker/worker_status"

function PowerWorkerItem:OnCreate()
  base.OnCreate(self)
  self.icon_build = self:AddComponent(UIButton, icon_build_path)
  self.build = self:AddComponent(UIBaseContainer, build_path)
  self.task_title = self:AddComponent(UITextMeshProUGUIEx, task_title_path)
  self.task_desc = self:AddComponent(UITextMeshProUGUIEx, task_desc_path)
  self.goto_fix_btn = self:AddComponent(UIButton, goto_fix_btn_path)
  self.btn_fix_des = self:AddComponent(UITextMeshProUGUIEx, btn_fix_des_path)
  self.worker = self:AddComponent(UIBaseContainer, worker_path)
  self.worker_title = self:AddComponent(UITextMeshProUGUIEx, worker_title_path)
  self.worker_time_start = self:AddComponent(UITextMeshProUGUIEx, worker_time_start_path)
  self.worker_desc = self:AddComponent(UITextMeshProUGUIEx, worker_desc_path)
  self.worker_time_use = self:AddComponent(UITextMeshProUGUIEx, worker_time_use_path)
  self.worker_callback = self:AddComponent(UIButton, worker_callback_path)
  self.worker_pos = self:AddComponent(UIImage, worker_pos_path)
  self.worker_pos:SetActive(false)
  self.worker_status = self:AddComponent(UIImage, worker_status_path)
  self.worker_status:SetActive(false)
  self.worker_time_start:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.goto_fix_btn:SetOnClick(function()
    local buildData = self.buildData
    if buildData ~= nil then
      local worldPointPos = buildData:GetCenterVec()
      GoToUtil.CloseAllWindows()
      SceneUtils.ChangeToCity(function()
        GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2)
        TimerManager:GetInstance():DelayInvoke(function()
          local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
          local param = {}
          param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
          param.arrowType = ArrowType.Building
          param.positionType = PositionType.Screen
          param.isPanel = false
          param.isAutoClose = 2
          DataCenter.ArrowManager:ShowArrow(param)
        end, 0.5)
      end)
    end
  end)
  self.worker_callback:SetOnClick(function()
    local message = Localization:GetString("season_s4_building_ui_info43")
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.CallbackPowerWorker, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if self.workerData then
        local workerData = self.workerData
        if workerData and workerData.marchUuid and workerData.state == PowerWorkerStatus.MARCH then
          local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(workerData.marchUuid)
          if marchInfo ~= nil then
            local marchTargetType = marchInfo:GetMarchTargetType()
            if marchTargetType == MarchTargetType.POWER_WORKER_BACK or marchTargetType == MarchTargetType.BACK_HOME then
              self.worker_status:SetActive(false)
              return
            end
          end
          MarchUtil.CallbackMyPowerWorker(workerData.marchUuid, workerData.uuid)
          return
        end
      end
      if self.workerUuid then
        SFSNetwork.SendMessage(MsgDefines.CallbackMyPowerWorker, self.workerUuid)
        return
      end
      local workerData = DataCenter.SeasonPowerWorkerManager:GetPowerWorkerByBuild(self.build_id, self.buildUuid)
      if workerData and workerData.uuid then
        SFSNetwork.SendMessage(MsgDefines.CallbackMyPowerWorker, workerData.uuid)
      else
        UIUtil.ShowTipsId("120632")
      end
    end, function()
    end)
  end)
  self.icon_build:SetOnClick(function()
    if self.workerData then
      local workerData = self.workerData
      if not workerData or workerData.state == PowerWorkerStatus.WAIT then
      elseif workerData.state == PowerWorkerStatus.CHARGE_SELF then
      elseif workerData.state == PowerWorkerStatus.CHARGE_OTHER or workerData.state == PowerWorkerStatus.CHARGE_SUPPLIES then
        local uid = workerData.userInfo and workerData.userInfo.uid
        local member
        if uid then
          member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
        end
        local pointId = workerData.pointId
        local serverId = workerData.serverId
        if member then
          pointId = workerData.pointId or member.pointId
          serverId = workerData.serverId or member.serverId
        end
        if pointId and serverId then
          do
            local worldPointPos = SceneUtils.TileIndexToWorld(toInt(pointId), ForceChangeScene.World)
            GoToUtil.CloseAllWindows()
            SceneUtils.ChangeToWorld(function()
              GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2, nil, toInt(serverId), 0)
              TimerManager:GetInstance():DelayInvoke(function()
                local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
                local param = {}
                param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
                param.arrowType = ArrowType.Building
                param.positionType = PositionType.Screen
                param.isPanel = false
                param.isAutoClose = 2
                DataCenter.ArrowManager:ShowArrow(param)
              end, 0.5)
            end)
            return
          end
        end
      elseif workerData.state == PowerWorkerStatus.MARCH then
        local serverId = workerData.serverId
        if serverId == nil or serverId == 0 then
          serverId = LuaEntry.Player:GetCurServerId()
        end
        GoToUtil.CloseAllWindows()
        GoToUtil.JumpToMarchByUuid(workerData.marchUuid, serverId, 0)
        return
      end
    end
    if self.buildUuid then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
      if buildData ~= nil then
        local worldPointPos = buildData:GetCenterVec()
        GoToUtil.CloseAllWindows()
        SceneUtils.ChangeToCity(function()
          GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2)
          TimerManager:GetInstance():DelayInvoke(function()
            local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
            local param = {}
            param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
            param.arrowType = ArrowType.Building
            param.positionType = PositionType.Screen
            param.isPanel = false
            param.isAutoClose = 2
            DataCenter.ArrowManager:ShowArrow(param)
          end, 0.5)
        end)
      end
    end
  end)
end

function PowerWorkerItem:OnDestroy()
  self.icon_build = nil
  self.build = nil
  self.task_title = nil
  self.task_desc = nil
  self.goto_fix_btn = nil
  self.btn_fix_des = nil
  self.worker = nil
  self.worker_title = nil
  self.worker_time_start = nil
  self.worker_desc = nil
  self.worker_time_use = nil
  self.worker_callback = nil
  self.worker_pos = nil
  self.worker_status = nil
  base.OnDestroy(self)
end

function PowerWorkerItem:OnDisable()
  base.OnDisable(self)
end

function PowerWorkerItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PowerWorkerUpdated, self.OnPowerWorkerUpdated)
end

function PowerWorkerItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PowerWorkerUpdated, self.OnPowerWorkerUpdated)
  base.OnRemoveListener(self)
end

function PowerWorkerItem:OnPointerClick(clickPos)
  if self.worker_time_start == nil then
    return
  end
  local linkId = self.worker_time_start:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local linkMsg = base64.decode(linkId)
  linkMsg = rapidjson.decode(linkMsg)
  if linkMsg ~= nil and linkMsg.action == "Jump" then
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

function PowerWorkerItem:OnPowerWorkerUpdated()
  if self.build_id and self.build_index then
    self:ReInit(self.build_id, self.build_index)
  end
end

function PowerWorkerItem:ReInit(build_id, build_index)
  self.build_index = build_index
  self.build_id = build_id
  self.workerData = nil
  self.formation = nil
  local data = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(build_id, true)
  if data and data.level ~= 0 then
    local worker = DataCenter.SeasonPowerWorkerManager:GetPowerWorkerByBuild(self.build_id, data.uuid)
    local formation = DataCenter.SeasonPowerWorkerManager:GetFormationByBuild(self.build_id, data.uuid)
    if formation == nil and worker == nil then
      self:ShowBuilding(build_id, data)
    else
      self:ShowWorker(build_id, data, formation, worker)
    end
  else
    self:ShowBuilding(build_id, data)
  end
end

function PowerWorkerItem:ShowBuilding(build_id, data)
  local txt_color = "#ffffff"
  self.build_id = build_id
  self.buildData = data
  self.buildUuid = data.uuid
  self.worker:SetActive(false)
  self.build:SetActive(true)
  if data == nil or data.level == 0 then
    txt_color = "#F97077"
    self.icon_build:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_fadianji02.png")
    self.btn_fix_des:SetLocalText("season_s4_building_ui_info42")
  else
    local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(build_id, 1)
    if cfg ~= nil then
      local taskInfo = DataCenter.TaskManager:FindTaskInfo(cfg.finish_quest)
      if taskInfo == nil or taskInfo.state == TaskState.NoComplete then
        txt_color = "#f53c3d"
      else
        txt_color = "#099b4a"
      end
    end
    self.icon_build:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_fadianji01.png")
    self.btn_fix_des:SetLocalText("season_s4_building_ui_info28")
  end
  local cfg = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(build_id)
  if cfg ~= nil then
    self.task_title:SetLocalText(cfg.name)
    self.task_desc:SetText(string.format("<color=%s>%s</color>", txt_color, Localization:GetString(cfg.des)))
  end
end

function PowerWorkerItem:ShowWorker(build_id, data, formation, workerData)
  self.build_id = build_id
  self.buildData = data
  self.buildUuid = data.uuid
  self.workerData = workerData
  self.formation = formation
  self.worker:SetActive(true)
  self.build:SetActive(false)
  self.icon_build:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_diangong_02.png")
  if workerData == nil then
    workerData = DataCenter.SeasonPowerWorkerManager:GetPowerWorkerByBuild(build_id, self.buildUuid)
    self.workerData = workerData
  end
  self.worker_time_start:SetText("")
  self.worker_title:SetText(Localization:GetString("season_s4_building_ui_btn02") .. " NO." .. self.build_index)
  if workerData then
    local isOut = workerData.state ~= PowerWorkerStatus.WAIT and workerData.state ~= PowerWorkerStatus.CHARGE_SELF
    if workerData.state == PowerWorkerStatus.WAIT then
      self.worker_desc:SetLocalText("season_s4_building_ui_info44")
    elseif workerData.state == PowerWorkerStatus.CHARGE_SELF then
      self.worker_desc:SetLocalText("season_s4_building_ui_info45", self.build_index)
      self.worker_status:SetActive(true)
    elseif workerData.state == PowerWorkerStatus.CHARGE_OTHER then
      self.worker_desc:SetLocalText("season_s4_building_ui_info47", workerData.userInfo.name or "")
      self.worker_status:SetActive(true)
    elseif workerData.state == PowerWorkerStatus.MARCH then
      local marchInfo = CS.SceneManager.World:GetMarch(workerData.marchUuid)
      if workerData.isPowerWorkerMarch or marchInfo ~= nil and marchInfo.type == CS.NewMarchType.POWER_WORKER then
        self.worker_desc:SetLocalText("season4_tips120")
      else
        self.worker_desc:SetLocalText("season_s4_manual_tittle41108")
      end
      self.worker_status:SetActive(false)
    elseif workerData.state == PowerWorkerStatus.CHARGE_SUPPLIES then
      local config = workerData.suppliesConfig and LocalController:instance():getLine(TableName.LWIceSupplies, workerData.suppliesConfig)
      local name = config and Localization:GetString(config.name) or ""
      self.worker_desc:SetLocalText("season4_supplies_UI_15", name)
      self.worker_status:SetActive(true)
    elseif workerData.state == PowerWorkerStatus.CHARGE_GOLD_TREE then
      self.worker_desc:SetLocalText("season_s4_golden_tree_UI_54")
      self.worker_status:SetActive(true)
    else
      self.worker_desc:SetText("")
    end
    if workerData and workerData.marchUuid and workerData.state == PowerWorkerStatus.MARCH then
      local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(workerData.marchUuid)
      if marchInfo ~= nil then
        local marchTargetType = marchInfo:GetMarchTargetType()
        if marchTargetType == MarchTargetType.POWER_WORKER_BACK or marchTargetType == MarchTargetType.BACK_HOME then
          isOut = false
          self.worker_status:SetActive(false)
        end
      end
    end
    self.worker_callback:SetActive(isOut)
    self.worker_time_use:SetText("")
    local uid = workerData.userInfo and workerData.userInfo.uid
    local member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
    local pointId = workerData.pointId
    local serverId = workerData.serverId
    if member then
      pointId = pointId or member.pointId
      serverId = serverId or member.serverId
    end
    if pointId and serverId then
      local nPointId = toInt(pointId)
      if 1 < nPointId then
        self.worker_time_start:SetText(UIUtil.MakeJumpLink(nPointId, serverId, 0))
      end
    end
    self:Update1000MS()
  else
    self.worker_desc:SetText("")
    self.worker_time_start:SetText("")
    self.worker_time_use:SetText("")
  end
end

function PowerWorkerItem:Update1000MS()
  if self.workerData then
    local now = UITimeManager:GetInstance():GetServerTime()
    local useTime = now - (self.workerData.time or self.workerData.stateUpdateTime or 0)
    local msg = Localization:GetString("season_s4_building_ui_info56")
    self.worker_time_use:SetText(msg .. UITimeManager:GetInstance():MilliSecondToFmtString(useTime))
  end
end

return PowerWorkerItem
