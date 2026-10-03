local base = UIBaseView
local UIRaceEntranceView = BaseClass("UIRaceEntranceView", base)
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local container_path = "Root/ContentContainer/Container"
local scroll_view_path = "Root/ContentContainer/Container/ScrollView"
local content_path = "Root/ContentContainer/Container/ScrollView/Content"
local center_view_path = "Root/ContentContainer/CenterView"
local CLS = "UI.UIRaceEntrance.Component.UIRaceEntranceItem"
local PREFAB = "Assets/Main/Prefabs/UI/UIRaceEntrance/UIRaceEntranceItem.prefab"

function UIRaceEntranceView:OnCreate()
  base.OnCreate(self)
  self.ctrl:SetView(self)
  self.curAct = nil
  self.cellIdx = 0
  self.cells = {}
  self.requests = {}
  self.contents = {}
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.text_title:SetLocalText("battlefield_entrance_building_name_1001")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.scroll_view = self:AddComponent(UIBaseComponent, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.center_view = self:AddComponent(UIBaseContainer, center_view_path)
  self.container = self:AddComponent(UIBaseContainer, container_path)
  local templates = RaceEntranceUtil.GetTemplates()
  local list = {}
  local i = 1
  local checkType = EnumActivity.ActDsbDuel.Type
  for k, _ in pairs(templates) do
    if k ~= checkType then
      list[i] = k
      i = i + 1
    end
  end
  self.showList = list
  RaceEntranceUtil.ReqTimeInfo()
  local actType = self:GetUserData()
  self:ReInit(actType)
end

function UIRaceEntranceView:OnDestroy()
  for _, v in pairs(self.requests) do
    v:Destroy()
    v = nil
  end
  local OpenSate = RaceEntranceUtil.OpenSate
  local templates = RaceEntranceUtil.GetTemplates()
  for _, v in pairs(templates) do
    if v.state ~= OpenSate.Lock then
      RaceEntranceUtil.SignUnlock(v.type)
    end
    if v.state == OpenSate.Open then
      RaceEntranceUtil.SignNew(v.type)
    end
  end
  self.cellIdx = 0
  self.cells = {}
  self.text_title = nil
  self.btn_back = nil
  self.scroll_view = nil
  self.content = nil
  self.center_view = nil
  self.curAct = nil
  self.requests = {}
  self.contents = {}
  EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntrance)
  base.OnDestroy(self)
end

function UIRaceEntranceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonInfoRefresh, self.OnDragonUpdate)
  self:AddUIListener(EventId.WinterStormInfoRefresh, self.OnWinterUpdate)
  self:AddUIListener(EventId.WinterStormMatchRefresh, self.OnWinterUpdate)
  self:AddUIListener(EventId.MeteoriteBattleInfoRefresh, self.OnMeteoriteUpdate)
  self:AddUIListener(EventId.EpidemicActInfoUpdate, self.OnEpidemicUpdate)
  self:AddUIListener(EventId.DsbDuelActInfoUpdate, self.OnDsbDuelUpdate)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.RefreshRaceEntranceTime, self.OnRETime)
end

function UIRaceEntranceView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonInfoRefresh, self.OnDragonUpdate)
  self:RemoveUIListener(EventId.WinterStormInfoRefresh, self.OnWinterUpdate)
  self:RemoveUIListener(EventId.WinterStormMatchRefresh, self.OnWinterUpdate)
  self:RemoveUIListener(EventId.MeteoriteBattleInfoRefresh, self.OnMeteoriteUpdate)
  self:RemoveUIListener(EventId.EpidemicActInfoUpdate, self.OnEpidemicUpdate)
  self:RemoveUIListener(EventId.DsbDuelActInfoUpdate, self.OnDsbDuelUpdate)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.RefreshRaceEntranceTime, self.OnRETime)
  base.OnRemoveListener(self)
end

function UIRaceEntranceView:OnDragonUpdate()
  if self.curAct == nil then
    self:RefreshCell(EnumActivity.ActDragon.Type)
  end
end

function UIRaceEntranceView:OnWinterUpdate()
  if self.curAct == nil then
    self:RefreshCell(EnumActivity.ActWinterStorm.Type)
  end
end

function UIRaceEntranceView:OnMeteoriteUpdate()
  if self.curAct == nil then
    self:RefreshCell(EnumActivity.ActMeteorite.Type)
  end
end

function UIRaceEntranceView:OnEpidemicUpdate()
  if self.curAct == nil then
    self:RefreshCell(EnumActivity.ActEpidemic.Type)
  end
end

function UIRaceEntranceView:OnDsbDuelUpdate()
  self:CheckDsbDuelActItem()
end

function UIRaceEntranceView:OnPassDay()
  if self.curAct == nil then
    for _, type in ipairs(self.showList) do
      RaceEntranceUtil.ReqActInfo(type)
    end
    RaceEntranceUtil.ReqActInfo(EnumActivity.ActDsbDuel.Type)
  end
end

function UIRaceEntranceView:OnRETime()
  if self.curAct == nil then
    self:ReInit()
  end
end

function UIRaceEntranceView:RefreshCell(actType)
  for i, type in ipairs(self.showList) do
    if type == actType then
      local v = RaceEntranceUtil.GetOneTemplate(actType)
      local script = self.cells[i]
      if script then
        script:RefreshData(v)
      end
    end
  end
end

function UIRaceEntranceView:OnBtnClick()
  if self.curAct ~= nil then
    self.curAct:SetActive(false)
    self.curAct = nil
    self:ReInit()
  else
    self.ctrl:CloseSelf()
  end
end

function UIRaceEntranceView:CheckBCross(template)
  local actType = template.type
  local bCross = false
  if actType == EnumActivity.ActDsbDuel.Type then
    bCross = not LuaEntry.Player:IsInSourceServer()
  end
  return bCross
end

function UIRaceEntranceView:ReInit(openType)
  if openType ~= nil then
    self:OpenActivity(openType)
    return
  end
  local templates = RaceEntranceUtil.GetTemplates()
  
  local function SortList(ta, tb)
    local a = templates[ta]
    local b = templates[tb]
    local bCrossA = self:CheckBCross(a)
    local bCrossB = self:CheckBCross(b)
    if bCrossA ~= bCrossB then
      return bCrossB
    end
    if a.state ~= b.state then
      return a.state > b.state
    end
    return a.id < b.id
  end
  
  table.sort(self.showList, SortList)
  self.scroll_view:SetActive(true)
  for i, type in ipairs(self.showList) do
    local idx = i
    local cell = self.cells[idx]
    local v = templates[type]
    if cell then
      cell:SetActive(true)
      cell:RefreshData(v)
    else
      self.cells[idx] = self:LoadComponentAsync(CLS, PREFAB, self.content, function()
        self.cells[idx]:SetActive(true)
        self.cells[idx]:RefreshData(v)
      end)
    end
  end
  self:CheckDsbDuelActItem()
end

function UIRaceEntranceView:OpenActivity(actType)
  local actInfo = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(actType)
  if actInfo == nil then
    return
  end
  if actType == EnumActivity.ActDragon.Type or actType == EnumActivity.ActWinterStorm.Type or actType == EnumActivity.ActEpidemic.Type then
    self:LoadInstance(actInfo.activityId, actType)
  elseif actType == EnumActivity.ActMeteorite.Type then
    DataCenter.ActMeteoriteBattleManager:OpenActWindowPls()
  elseif actType == EnumActivity.ActDsbDuel.Type then
    BattlefieldDsbDuelUtils.ActInfo:OpenActWindow()
  end
end

function UIRaceEntranceView:LoadInstance(activityId, type)
  local newContent = self.contents[activityId]
  if newContent then
    newContent:SetActive(true)
    if newContent.EntranceReEnter ~= nil then
      newContent:EntranceReEnter()
    end
    self.curAct = newContent
    self.scroll_view:SetActive(false)
    self:SetDsbDuelActItemActive(false)
    return
  end
  if self.requests[activityId] ~= nil then
    return
  end
  local actShowData = ActivityContentHandler[type]
  local request = CS.GameEntry.Resource:InstantiateAsync(actShowData.assetPath)
  self.requests[activityId] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      return
    end
    CommonUtil.CallAutoArabicMirrorManually(req)
    _go.name = tostring(activityId)
    local pTF = _go.transform
    pTF:SetParent(self.center_view.transform)
    pTF:Set_localScale(1, 1, 1)
    pTF:Set_localPosition(0, 0, 0)
    local class = require(actShowData.cls)
    newContent = self.center_view:AddComponent(class, _go.name)
    self.contents[activityId] = newContent
    newContent:SetActive(true)
    newContent:SetData(activityId)
    self.curAct = newContent
    self.scroll_view:SetActive(false)
    self:SetDsbDuelActItemActive(false)
  end)
end

function UIRaceEntranceView:SetDsbDuelActItemActive(active)
  if self.dsbTopItem and self.dsbTopItem:AsyncLoadDone() then
    self.dsbTopItem:SetActive(active)
  end
end

function UIRaceEntranceView:CheckDsbDuelActItem()
  local dsbActTemplate = RaceEntranceUtil.GetOneTemplate(EnumActivity.ActDsbDuel.Type)
  if BattlefieldDsbDuelUtils.ActInfo:CheckIfActOpen() and dsbActTemplate and not self:CheckBCross(dsbActTemplate) then
    BattlefieldDsbDuelUtils.ActInfo:CheckIsWeekEndNeedPop()
    local prefabPath, cls = self.ctrl:GetTopItemPrefabPathAndCls(EnumActivity.ActDsbDuel.Type)
    if self.dsbTopItem then
      if self.dsbTopItem:AsyncLoadDone() then
        self.dsbTopItem:SetActive(true)
        self.dsbTopItem:UpdateData()
      end
    else
      self.dsbTopItem = UIBaseComponent.LoadComponentAsync(self, cls, prefabPath, self.container, function(view)
        if IsNotNull(self.dsbTopItem.gameObject) then
          self.dsbTopItem:SetAsLastSibling()
          self.dsbTopItem:SetAnchoredPositionXY(0, 0)
          self.scroll_view.rectTransform:Set_sizeDelta(800, -240)
        end
      end)
    end
  else
    self:SetDsbDuelActItemActive(false)
    self.scroll_view.rectTransform:Set_sizeDelta(800, 0)
  end
end

return UIRaceEntranceView
