local UIMainBLBtnSeasonPowerTask = BaseClass("UIMainBLBtnSeasonPowerTask", UIAsyncContainer)
local base = UIAsyncContainer

function UIMainBLBtnSeasonPowerTask:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "btn")
  self.txt = self:AddComponent(UITextMeshProUGUIEx, "txt")
  self.btn:SetOnClick(function()
    if self.taskInfo then
      if self.taskInfo.state == TaskState.CanReceive or self.taskInfo.state == TaskState.Received then
        GoToUtil.GotoCityByCondBuildId(self.buildId, WorldTileBtnType.City_Upgrade)
      else
        DataCenter.ChapterTaskManager:QuestGoto(self.taskInfo)
      end
    end
  end)
  self.theItem = self.transform:Find("Tips").gameObject
  self.theItem:GameObjectCreatePool()
  self.taskInfo = nil
  self.num_need = nil
  self.num_max = nil
end

function UIMainBLBtnSeasonPowerTask:OnDestroy()
  self.btn = nil
  self.txt = nil
  self.theItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function UIMainBLBtnSeasonPowerTask:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainTaskUpdate, self.UpdateData)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateData)
  self:AddUIListener(EventId.PowerWorkerUpdated, self.UpdateData)
  self:AddUIListener(EventId.OnEnterCity, self.UpdateData)
  self:AddUIListener(EventId.OnEnterWorld, self.UpdateData)
  self:AddUIListener(EventId.PowerWorkerTaskUpdated, self.OnPowerWorkerTaskUpdated)
  self:UpdateData()
end

function UIMainBLBtnSeasonPowerTask:OnRemoveListener()
  self:RemoveUIListener(EventId.MainTaskUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateData)
  self:RemoveUIListener(EventId.PowerWorkerUpdated, self.UpdateData)
  self:RemoveUIListener(EventId.OnEnterCity, self.UpdateData)
  self:RemoveUIListener(EventId.OnEnterWorld, self.UpdateData)
  self:RemoveUIListener(EventId.PowerWorkerTaskUpdated, self.OnPowerWorkerTaskUpdated)
  base.OnRemoveListener(self)
end

function UIMainBLBtnSeasonPowerTask:OnPowerWorkerTaskUpdated(data)
  if IsNull(self.gameObject) then
    return
  end
  if data and self.taskInfo and toInt(self.taskInfo.id) == toInt(data.taskId) then
    local delta = toInt(data.num_new) - toInt(data.num_old)
    if 0 < delta then
      local goItem = self.theItem:GameObjectSpawn(self.transform)
      goItem:SetActive(true)
      goItem.transform:Set_localPosition(-18, -20, 0)
      local theCanvas = goItem.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
      local theTextMesh = goItem.transform:Find("num"):GetComponent(typeof(CS.TextMeshProUGUIEx))
      local sequence = DOTween.Sequence()
      theTextMesh.text = string.format("+%s", delta)
      theCanvas.alpha = 1
      sequence:Append(DOTween.To(function()
        return 1
      end, function(alpha)
        theCanvas.alpha = alpha
      end, 0, 2))
      sequence:Join(goItem.transform:DOLocalMove(Vector3.New(-18, 66, 0), 1.5))
      sequence:AppendCallback(function()
        goItem:GameObjectRecycle()
      end)
    end
  end
  self:UpdateData()
end

function UIMainBLBtnSeasonPowerTask:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  if not CS.SceneManager.IsInWorld() then
    self.btn:SetActive(false)
    self.txt:SetActive(false)
    return
  end
  local count = DataCenter.SeasonPowerWorkerManager:GetFormationCount()
  if 4 <= count then
    self.btn:SetActive(false)
    self.txt:SetActive(false)
    return
  end
  self.taskInfo = nil
  self.num_need = nil
  self.num_max = nil
  local taskInfo
  local dataList = DataCenter.SeasonPowerWorkerManager:GetPowerBuildInfo()
  if dataList then
    for buildId, data in pairs(dataList) do
      if data and data.taskInfo and data.taskInfo.state ~= TaskState.Received then
        taskInfo = data.taskInfo
        self.buildId = buildId
        self.taskInfo = taskInfo
        break
      end
    end
  end
  if taskInfo == nil then
    self.btn:SetActive(false)
    self.txt:SetActive(false)
  else
    local need, max, meta = taskInfo:GetTaskProgress()
    if need and max then
      if taskInfo.state == TaskState.NoComplete then
        self.txt:SetText(string.format("<color=#F97077>%s</color>/%s", need, max))
      else
        self.txt:SetText(string.format("<color=#5fef87>%s</color>/%s", need, max))
      end
      self.num_need = need
      self.num_max = max
    end
    self.btn:SetActive(true)
    self.txt:SetActive(true)
  end
end

return UIMainBLBtnSeasonPowerTask
