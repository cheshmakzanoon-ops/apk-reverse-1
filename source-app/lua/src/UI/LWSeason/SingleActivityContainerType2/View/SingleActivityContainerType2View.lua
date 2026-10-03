local SingleActivityContainerType2View = BaseClass("SingleActivityContainerType2View", UIBaseView)
local base = UIBaseView
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local content_path = "Root/Container/Content"

function SingleActivityContainerType2View:OnCreate()
  base.OnCreate(self)
  self.panelInstance = {}
  self.gotoParamData = nil
  self.activityAssetPath = nil
  self.activityClass = nil
  self.activityId, self.titleTxt, self.gotoParamData = self:GetUserData()
  self.activityId = tostring(self.activityId)
  self.ctrl:InitPanelStack()
  self:ComponentDefine()
  self:RefreshCurPanel(true)
end

function SingleActivityContainerType2View:OnDestroy()
  self.panelInstance = nil
  self.ctrl:DestroyPanelStack()
  base.OnDestroy(self)
end

function SingleActivityContainerType2View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SingleActivityContainerType2ClosePanel, self.RemovePanelAndRefreshNext)
  self:AddUIListener(EventId.SingleActivityContainerType2OpenPanel, self.PushNewPanel)
end

function SingleActivityContainerType2View:OnRemoveListener()
  self:RemoveUIListener(EventId.SingleActivityContainerType2ClosePanel, self.RemovePanelAndRefreshNext)
  self:RemoveUIListener(EventId.SingleActivityContainerType2OpenPanel, self.PushNewPanel)
  base.OnRemoveListener(self)
end

function SingleActivityContainerType2View:OnEnable()
  base.OnEnable(self)
  if self.activityData ~= nil and not string.IsNullOrEmpty(self.activityData.plot) and tonumber(self.activityData.plot) ~= nil then
    local key = "S1_PlayPlot_" .. self.activityId
    local cache = Setting:GetPrivateString(key)
    if cache ~= "ok" then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = self.activityData.plot,
        hideMainUI = true
      })
      Setting:SetPrivateString(key, "ok")
    end
  end
end

function SingleActivityContainerType2View:OnDisable()
  base.OnDisable(self)
end

function SingleActivityContainerType2View:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.OnCustomKeyCodeEscape))
  self.btn_back:SetActive(true)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function SingleActivityContainerType2View:RefreshCurPanel(needPush)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data and data.id then
    local handlerData = DataCenter.ActivityListDataManager:GetActivityShowData(data.id)
    if handlerData ~= nil and handlerData.assetPath ~= nil and handlerData.cls ~= nil then
      self.activityAssetPath = handlerData.assetPath
      self.activityClass = handlerData.cls
    end
    self.activityData = data
    self:LoadActivityAsset(needPush)
  else
    self.activityData = nil
  end
  if not string.IsNullOrEmpty(self.titleTxt) then
    self.text_title:SetText(self.titleTxt)
  elseif data then
    self.text_title:SetLocalText(data.name)
  end
end

function SingleActivityContainerType2View:LoadActivityAsset(push)
  if self.activityData == nil or self.activityAssetPath == nil or self.activityClass == nil then
    return
  end
  if push then
    self.ctrl:PushPanelInfo(self.activityId, self.activityClass, self.activityData)
  end
  local cacheCell = self.panelInstance[self.activityId]
  if cacheCell then
    if cacheCell.com then
      cacheCell.com:SetData(self.activityId, self.activityData, self.gotoParamData ~= nil and table.unpack(self.gotoParamData) or nil)
      cacheCell.com:SetActive(true)
      self.gotoParamData = nil
      return
    elseif cacheCell.req then
      return
    end
  else
    self.panelInstance[self.activityId] = {}
  end
  local activityIdCache = self.activityId
  local activityAssetData = self:GameObjectInstantiateAsync(self.activityAssetPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    go.transform:SetParent(self.content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = tostring(activityIdCache)
    rectTransform:Set_offsetMin(0, 0)
    rectTransform:Set_offsetMax(0, 0)
    local panelInfo = self.ctrl:GetPanelInfoByActivityId(activityIdCache)
    local cell = self.content:AddComponent(panelInfo.activityClass, go.name)
    local panelInfo = self.ctrl:GetCurPanelInfo()
    if panelInfo.activityId == activityIdCache then
      cell:SetData(panelInfo.activityId, panelInfo.activityData, self.gotoParamData ~= nil and table.unpack(self.gotoParamData) or nil)
      cell:SetActive(true)
      self.gotoParamData = nil
    else
      cell:SetActive(false)
    end
    self.panelInstance[activityIdCache].com = cell
  end)
  self.panelInstance[self.activityId].req = activityAssetData
end

function SingleActivityContainerType2View:HideCurPanel()
  local cacheCell = self.panelInstance[self.activityId]
  if cacheCell and cacheCell.com then
    cacheCell.com:SetActive(false)
  end
end

function SingleActivityContainerType2View:PushNewPanel(data)
  self:HideCurPanel()
  self.activityAssetPath = nil
  self.activityClass = nil
  self.activityId = tostring(data.activityId)
  self:RefreshCurPanel(true)
end

function SingleActivityContainerType2View:RemovePanelAndRefreshNext()
  self:HideCurPanel()
  self.activityAssetPath = nil
  self.activityClass = nil
  local panelInfo = self.ctrl:GetCurPanelInfo()
  self.activityId = panelInfo.activityId
  self:RefreshCurPanel()
end

return SingleActivityContainerType2View
