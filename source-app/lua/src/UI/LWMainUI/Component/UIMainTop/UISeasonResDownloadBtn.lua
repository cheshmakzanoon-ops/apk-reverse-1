local base = UIAsyncContainer
local UISeasonResDownloadBtn = BaseClass("UISeasonResDownloadBtn", base)

local function FilterErrMsg(errMsg)
  if errMsg == nil or errMsg == "" then
    return "NoErr"
  end
  local str1, str2 = string.match(errMsg, [[
([^
]+)[
]([^
]+)]])
  if str1 ~= nil then
    return str1
  end
  return tostring(errMsg)
end

function UISeasonResDownloadBtn:OnCreate()
  base.OnCreate(self)
  self.timer = nil
  self.timer_tick = 0.1
  
  function self.timer_action(temp)
    self:TimerAction()
  end
  
  self.lastTotalProgress = nil
  self:ComponentDefine()
  self:AddUIListener(EventId.LWSeasonResourceDownloadStart, self.ReInit)
  self:AddUIListener(EventId.LWSeasonResourceDownloadFinish, self.DownloadFinish)
  self:AddUIListener(EventId.LWSeasonResourceDownloadStop, self.OnDownloadStop)
  self:AddUIListener(EventId.LWUnpackResourceRewardUpdate, self.ReInit)
end

function UISeasonResDownloadBtn:OnDestroy()
  self:RemoveUIListener(EventId.LWSeasonResourceDownloadStart, self.ReInit)
  self:RemoveUIListener(EventId.LWSeasonResourceDownloadFinish, self.DownloadFinish)
  self:RemoveUIListener(EventId.LWSeasonResourceDownloadStop, self.OnDownloadStop)
  self:RemoveUIListener(EventId.LWUnpackResourceRewardUpdate, self.ReInit)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonResDownloadBtn:ComponentDefine()
  self.download_btn = self:AddComponent(UIButton, "")
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "BtnText")
  self.slider = self:AddComponent(UIImage, "slider")
  self.download_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UISeasonResDownloadBtn:ComponentDestroy()
  self:DeleteTimer()
  self.download_btn = nil
  self.btn_text = nil
  self.slider = nil
end

function UISeasonResDownloadBtn:TimerAction()
  if self.loader and self.isDownloading then
    local totalProgress = self.loader.TotalProgress
    local nTotalProgress = toInt(totalProgress * 100)
    self.slider:SetFillAmount(totalProgress)
    self.btn_text:SetText(nTotalProgress .. "%")
    self.lastTotalProgress = totalProgress
    DataCenter.EventCollectManager.OnDownloadStep(self.configId, nTotalProgress)
  end
  if CS.CommonUtils.IsDebug() then
    if self.debugTimer == nil then
      self.debugTimer = 0
    end
    self.debugTimer = self.debugTimer + 1
    if self.debugTimer == 12 then
      self.debugTimer = 0
      Logger.LogInfo(string.format("UISeasonResDownloadBtn TimerAction configId = %s , loader_is_nil = %s , %s , %s", tostring(self.configId), self.loader == nil, tostring(self.lastTotalProgress), self.isDownloading))
    end
  end
end

function UISeasonResDownloadBtn:OnDownloadStop(packageId)
  if self.configId == packageId then
    self.isDownloading = false
    Logger.LogInfo("UISeasonResDownloadBtn OnDownloadStop configId = " .. tostring(packageId))
  end
end

function UISeasonResDownloadBtn:OnBtnClick()
  if self.configId then
    local packageId = toInt(self.configId)
    local errMsg
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonResourceDownload, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, packageId)
    if self.loader == nil then
      errMsg = "loader is nil"
    else
      errMsg = FilterErrMsg(self.loader.errMsg)
    end
    if SeasonUtil.IsSeasonResDownloaded(packageId) then
      self.gameObject:SetActive(false)
      self:DeleteTimer()
      if LuaEntry.Player:CheckUnpackResourceReward(packageId) then
        Logger.LogInfo(string.format("UISeasonResDownloadBtn HasReward %s , %s , %s", packageId, tostring(self.lastTotalProgress), errMsg))
      else
        SFSNetwork.SendMessage(MsgDefines.LwSeasonResRqReward, packageId)
        Logger.LogInfo(string.format("UISeasonResDownloadBtn RqReward %s , %s , %s", packageId, tostring(self.lastTotalProgress), errMsg))
      end
    else
      Logger.LogInfo(string.format("UISeasonResDownloadBtn %s , %s , %s", packageId, tostring(self.lastTotalProgress), errMsg))
    end
  end
end

function UISeasonResDownloadBtn:ReInit()
  self.loader = nil
  self.isDownloading = false
  self:UpdateData()
end

function UISeasonResDownloadBtn:DownloadFinish(configId)
  pcall(function()
    DataCenter.EventCollectManager.OnDownloadFinish(configId)
  end)
  if configId ~= nil and configId ~= self.configId then
    SeasonUtil.IsSeasonResDownloaded(configId)
  elseif self.configId then
    SeasonUtil.IsSeasonResDownloaded(self.configId)
  end
  local key = "SeasonResDownloadId" .. tostring(configId)
  UIUtil.GetTodayActiveCount(key, true)
  Logger.LogInfo("UISeasonResDownloadBtn DownloadFinish configId = " .. tostring(configId) .. " , " .. key)
  self.loader = nil
  self.isDownloading = false
  self:DeleteTimer()
  self:UpdateData()
end

function UISeasonResDownloadBtn:UpdateData()
  if IsNotNull(self.gameObject) then
    local theConfigId, needInPreviewMode = SeasonUtil.GetSeasonResourcePackName(true)
    self.configId = theConfigId
    self:CheckDownloadStatus(self.configId)
  end
end

function UISeasonResDownloadBtn:CheckDownloadStatus(configId)
  if configId and self.configId == configId then
    self.loader = nil
    self.isDownloading = false
    if SeasonUtil.IsSeasonResDownloaded(configId) then
      self:DeleteTimer()
      if LuaEntry.Player:CheckUnpackResourceReward(configId) then
        self.gameObject:SetActive(false)
        return
      end
      self.slider:SetActive(true)
      self.btn_text:SetActive(true)
      self.btn_text:SetText("100%")
      self.slider:SetFillAmount(1)
      Logger.LogInfo("UISeasonResDownloadBtn IsSeasonResDownloaded configId = " .. tostring(configId))
    else
      self.loader = CS.DownloadManifestManager.Instance:GetLoadManifestData(configId)
      if self.loader then
        if self.loader.isDone then
          if not string.IsNullOrEmpty(self.loader.errMsg) then
            self.slider:SetActive(false)
            self.btn_text:SetActive(false)
            Logger.LogInfo("UISeasonResDownloadBtn error " .. FilterErrMsg(self.loader.errMsg))
          else
            Logger.LogInfo("UISeasonResDownloadBtn logic error")
            CS.DownloadManifestManager.Instance:StopDownload(configId)
          end
          self:DeleteTimer()
        else
          self.isDownloading = not self.loader.IsPaused
          self.slider:SetActive(true)
          self.btn_text:SetActive(true)
          self.lastTotalProgress = self.loader.TotalProgress
          if self.lastTotalProgress ~= nil then
            self.slider:SetFillAmount(self.lastTotalProgress)
            self.btn_text:SetText(toInt(self.lastTotalProgress * 100) .. "%")
          end
          self:TimerAction()
          self:AddTimer()
        end
      else
        if self.lastTotalProgress ~= nil then
          self.slider:SetActive(true)
          self.btn_text:SetActive(true)
          self.slider:SetFillAmount(self.lastTotalProgress)
          self.btn_text:SetText(toInt(self.lastTotalProgress * 100) .. "%")
        else
          self.slider:SetActive(true)
          self.btn_text:SetActive(true)
          self.slider:SetFillAmount(0)
          self.btn_text:SetText("0%")
        end
        self:AddTimer()
      end
      Logger.LogInfo(string.format("UISeasonResDownloadBtn %s , loader_is_nil = %s , %s , %s", configId, self.loader == nil, tostring(self.lastTotalProgress), self.isDownloading))
    end
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

function UISeasonResDownloadBtn:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(self.timer_tick or 0.1, self.timer_action, self, false, false, false)
    self.timer:Start()
    Logger.LogInfo("UISeasonResDownloadBtn AddTimer")
  end
end

function UISeasonResDownloadBtn:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
    Logger.LogInfo("UISeasonResDownloadBtn DeleteTimer")
  end
end

return UISeasonResDownloadBtn
