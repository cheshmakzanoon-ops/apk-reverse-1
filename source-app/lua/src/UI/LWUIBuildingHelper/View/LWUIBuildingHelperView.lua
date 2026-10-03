local LWUIBuildingHelperView = BaseClass("LWUIBuildingHelperView", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  self:ShowPanel()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.content = self:AddComponent(UIBaseContainer, "Content")
  self.compTapToContinue = self:AddComponent(UIBaseContainer, "TapToContinue")
end

local Helper2Guide = {
  [BuildingTypes.LW_BUILD_ARMY_YARD] = 1108,
  [BuildingTypes.LW_BUILD_PARKINGLOT] = 1109,
  [BuildingTypes.LW_BUILD_MILITARY_CAMP] = 1112
}

local function ComponentDestroy(self)
  self.title = nil
  self.btnPanel = nil
  self.content = nil
  self.textType1Desc1 = nil
  self.textType1Desc2 = nil
  self.textType1Desc3 = nil
  self.textType1Desc4 = nil
  self.textType1Desc5 = nil
  self.compTapToContinue = nil
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  if self.req and self.req.gameObject then
    self.req:Destroy()
    self.req = nil
  end
  if self.param == BuildingTypes.LW_BUILD_PUB then
    local freeRecruitLottery = DataCenter.LotteryDataManager:GetFreeRecruitLotteryData()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, false, false, freeRecruitLottery)
  elseif Helper2Guide[self.param] then
    DataCenter.LWGuideFlowManager:TryTriggerFlexibly(Helper2Guide[self.param])
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowPanel(self)
  self.compTapToContinue.gameObject:SetActive(false)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnPanel:SetInteractable(false)
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.BuildingHelper)
  local line = LocalController:instance():getLine(tableName, self.param)
  local title = line.title
  if title ~= nil and not string.IsNullOrEmpty(title) then
    self.title:SetLocalText(title)
  else
    local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param)
    self.title:SetLocalText(building.name)
  end
  local soundId = line.open_sound_id
  if soundId and 0 < soundId then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.BuildingHelper)
  local line = LocalController:instance():getLine(tableName, self.param)
  local prefab_path = line.prefab_path
  local req = CS.GameEntry.Resource:InstantiateAsync(prefab_path)
  req:completed("+", function()
    if req.isError then
      return
    end
    self.req.gameObject.transform.position = self.content.transform.position
    self.req.gameObject.transform:SetParent(self.content.transform)
    self.req.gameObject.transform.localScale = Vector3.New(1, 1, 1)
    local animator = self.req.gameObject.transform:GetComponent(typeof(CS.UnityEngine.Animator))
    local anim = line.anim
    animator:Play(anim)
    local des1 = self.req.gameObject.transform:Find("Type1/Type1_Icon1/Type1_Desc1")
    if des1 then
      self.textType1Desc1 = des1:GetComponent(typeof(CS.TextMeshProUGUIEx))
      local desc_1 = line.desc_1
      self.textType1Desc1:SetLocalText(desc_1)
    end
    local des2 = self.req.gameObject.transform:Find("Type1/Type1_Icon2/Type1_Desc2")
    if des2 then
      self.textType1Desc2 = des2:GetComponent(typeof(CS.TextMeshProUGUIEx))
      local desc_2 = line.desc_2
      self.textType1Desc2:SetLocalText(desc_2)
    end
    local des3 = self.req.gameObject.transform:Find("Type1/Type1_Icon3/Type1_Desc3")
    if des3 then
      self.textType1Desc3 = des3:GetComponent(typeof(CS.TextMeshProUGUIEx))
      local desc_3 = line.desc_3
      self.textType1Desc3:SetLocalText(desc_3)
    end
    local des4 = self.req.gameObject.transform:Find("Type1/Type1_Icon4/Type1_Desc4")
    if des4 then
      self.textType1Desc4 = des4:GetComponent(typeof(CS.TextMeshProUGUIEx))
      local desc_4 = line.desc_4
      self.textType1Desc4:SetLocalText(desc_4)
    end
    local des5 = self.req.gameObject.transform:Find("Type1/Type1_Icon5/Type1_Desc5")
    if des5 then
      self.textType1Desc5 = des5:GetComponent(typeof(CS.TextMeshProUGUIEx))
      local desc_5 = line.desc_5
      self.textType1Desc5:SetLocalText(desc_5)
    end
  end)
  self.req = req
  self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.closeTimer = nil
    self.compTapToContinue.gameObject:SetActive(true)
    self.btnPanel:SetInteractable(true)
  end, 1.5)
end

local function OnBtnPanelClick(self)
  EventManager:GetInstance():Broadcast(EventId.PlayRadarGuide)
  self.ctrl:CloseSelf()
end

LWUIBuildingHelperView.OnCreate = OnCreate
LWUIBuildingHelperView.OnDestroy = OnDestroy
LWUIBuildingHelperView.OnEnable = OnEnable
LWUIBuildingHelperView.OnDisable = OnDisable
LWUIBuildingHelperView.ComponentDefine = ComponentDefine
LWUIBuildingHelperView.ComponentDestroy = ComponentDestroy
LWUIBuildingHelperView.DataDefine = DataDefine
LWUIBuildingHelperView.DataDestroy = DataDestroy
LWUIBuildingHelperView.OnAddListener = OnAddListener
LWUIBuildingHelperView.OnRemoveListener = OnRemoveListener
LWUIBuildingHelperView.ShowPanel = ShowPanel
LWUIBuildingHelperView.OnBtnPanelClick = OnBtnPanelClick
return LWUIBuildingHelperView
