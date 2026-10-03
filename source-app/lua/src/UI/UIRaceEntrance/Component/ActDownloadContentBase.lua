local base = UIBaseContainer
local ActDownloadContentBase = BaseClass("ActDownloadContentBase", base)

function ActDownloadContentBase:OnCreate()
  base.OnCreate(self)
  self.btnLoading = self:AddComponent(UIButton, "Loading")
  self.btnLoading:SetOnClick(function()
    self:OnBtnLoadingClick()
  end)
end

function ActDownloadContentBase:OnDestroy()
  self:DestroyLoading()
  self.compAct = nil
  self.rootCls = nil
  self.rootPrefab = nil
  base.OnDestroy(self)
end

function ActDownloadContentBase:OnBtnLoadingClick()
end

function ActDownloadContentBase:SetData(activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self:RefreshLoading()
end

function ActDownloadContentBase:EntranceReEnter()
  if self.compAct ~= nil and self.compAct:AsyncLoadDone() then
    self.compAct:EntranceReEnter()
  end
end

function ActDownloadContentBase:DestroyLoading()
  if self.btnLoading then
    self.btnLoading:RemoveAllComponentes()
  end
  self.btnLoading = nil
  if self.loadingReq ~= nil then
    self.loadingReq:Destroy()
    self.loadingReq = nil
  end
  self.loadingReq = nil
  self.loadingComp = nil
end

function ActDownloadContentBase:RefreshLoading()
  local showLoading = RaceEntranceUtil.IsNeedShowLoading(self.activityId)
  if showLoading then
    if self.compAct then
      self.compAct:SetActive(false)
    end
    self.btnLoading:SetActive(true)
    if self.loadingReq == nil then
      self.loadingReq = RaceEntranceUtil.CreateLoading(self.activityId, self.btnLoading, "DownLoading", function(comp)
        comp:SetOffsetMinXY(0, -20)
        comp:SetOffsetMaxXY(0, 10)
        self.loadingComp = comp
      end, function()
        self:LoadAct()
      end)
    end
  else
    self:LoadAct()
  end
  return showLoading
end

function ActDownloadContentBase:LoadAct()
  self.btnLoading:SetActive(false)
  if self.compAct then
    self.compAct:SetActive(true)
    self.compAct:EntranceReEnter()
    return
  end
  if string.IsNullOrEmpty(self.rootCls) or string.IsNullOrEmpty(self.rootPrefab) then
    Logger.LogError("[ActDownloadContentBase] LoadAct path error: " .. self.activityId .. " , " .. tostring(self.rootCls) .. " , " .. tostring(self.rootPrefab))
    return
  end
  self.compAct = self:LoadComponentAsync(self.rootCls, self.rootPrefab, self, function()
    self.compAct:SetName("ActRoot")
    self.compAct:SetOffsetMinXY(0, 0)
    self.compAct:SetOffsetMaxXY(0, 0)
    self.compAct:SetActive(true)
    if self.rootLoadFinishCb then
      self.rootLoadFinishCb()
    end
    self.compAct:SetData(self.activityId)
  end)
end

function ActDownloadContentBase:SetRootCP(cls, prefab)
  self.rootCls = cls
  self.rootPrefab = prefab
end

function ActDownloadContentBase:SetLoadFinishCb(cb)
  self.rootLoadFinishCb = cb
end

return ActDownloadContentBase
