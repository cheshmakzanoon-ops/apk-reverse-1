local UILookForCareer = BaseClass("UILookForCareer", UIBaseView)
local base = UIBaseView
local UILookForCareerItem = require("UI.UILookForCareer.Component.UILookForCareerItem")
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local title_path = "UICommonMiniPopUpTitle/titleText"
local return_path = "UICommonMiniPopUpTitle/panel"
local close_path = "UICommonMiniPopUpTitle/CloseBtn"
local desc_path = "Desc"
local list_path = "List"
local confirm_btn_path = "ConfirmBtn"
local confirm_text_path = "ConfirmBtn/ConfirmText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(395405)
  self.return_btn = self:AddComponent(UIButton, return_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc_text:SetLocalText(395408)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirm()
  end)
  self.confirm_text = self:AddComponent(UIText, confirm_text_path)
  self.confirm_text:SetLocalText(GameDialogDefine.CONFIRM)
  self.list_go = self:AddComponent(UIBaseContainer, list_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.return_btn = nil
  self.close_btn = nil
  self.desc_text = nil
  self.confirm_btn = nil
  self.confirm_text = nil
  self.list_go = nil
end

local function DataDefine(self)
  self.itemList = {}
  self.selectedTypeList = {}
  self.isDirty = false
end

local function DataDestroy(self)
  self.itemList = nil
  self.selectedTypeList = nil
  self.isDirty = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateKonbini, self.OnBuyInKonbini)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateKonbini, self.OnBuyInKonbini)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  self.selectedTypeList = allianceBaseData.lookForCareers
  self:ShowItems()
end

local function ShowItems(self)
  self.itemList = {}
  local careerTypeList = DeepCopy(self:GetCareerTypeList())
  table.insert(careerTypeList, 1, 0)
  for _, careerType in ipairs(careerTypeList) do
    local req = Resource:InstantiateAsync(UIAssets.UILookForCareerItem)
    req:completed("+", function()
      if req.isError then
        return
      end
      if not self.gameObject then
        req:Destroy()
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(req)
      local go = req.gameObject
      go:SetActive(true)
      go.name = tostring(careerType)
      local tf = go.transform
      tf:SetParent(self.list_go.transform)
      tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.list_go:AddComponent(UILookForCareerItem, go)
      self.itemList[careerType] = item
      item:SetOnClick(function()
        self:OnSelect(careerType)
      end)
      if table.count(self.itemList) == #careerTypeList then
        self:RefreshItems()
      end
    end)
  end
end

local function ClearItems(self)
  self.list_go:RemoveComponents(UILookForCareerItem)
end

local function RefreshItems(self)
  local totalTypeCount = #self:GetCareerTypeList()
  local anyData = {}
  for careerType, item in pairs(self.itemList) do
    if careerType ~= CareerType.None then
      local data = {}
      data.careerType = careerType
      data.cur = #DataCenter.AllianceCareerManager:GetAllianceMemberPosListByCareer(careerType)
      data.max = DataCenter.AllianceCareerManager:GetCareerMaxNum(careerType)
      if data.cur >= data.max then
        data.state = UILookForCareerItem.State.Crossed
        anyData.state = UILookForCareerItem.State.Crossed
        if table.hasvalue(self.selectedTypeList, careerType) then
          table.removebyvalue(self.selectedTypeList, careerType)
          self.isDirty = true
        end
      elseif table.hasvalue(self.selectedTypeList, careerType) then
        data.state = UILookForCareerItem.State.Checked
      else
        data.state = UILookForCareerItem.State.Idle
      end
      item:SetData(data)
    end
  end
  anyData.careerType = CareerType.None
  if anyData.state == nil then
    if #self.selectedTypeList == totalTypeCount then
      anyData.state = UILookForCareerItem.State.Checked
    else
      anyData.state = UILookForCareerItem.State.Idle
    end
  end
  self.itemList[0]:SetData(anyData)
end

local function GetCareerTypeList(self)
  local list = DataCenter.PlayerCareerManager:GetCareerTypeList()
  table.sort(list)
  return list
end

local function OnSelect(self, careerType)
  local item = self.itemList[careerType]
  if item == nil then
    return
  end
  self.isDirty = true
  local data = item.data
  if data.careerType ~= CareerType.None then
    if data.state == UILookForCareerItem.State.Idle then
      if not table.hasvalue(self.selectedTypeList, careerType) then
        table.insert(self.selectedTypeList, careerType)
      end
    elseif data.state == UILookForCareerItem.State.Checked then
      table.removebyvalue(self.selectedTypeList, careerType)
    end
  elseif data.state == UILookForCareerItem.State.Idle then
    self.selectedTypeList = DeepCopy(self:GetCareerTypeList())
  elseif data.state == UILookForCareerItem.State.Checked then
    self.selectedTypeList = {}
  end
  self:RefreshItems()
end

local function OnConfirm(self)
  if self.isDirty then
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, self.selectedTypeList)
  end
  self.ctrl:CloseSelf()
end

UILookForCareer.OnCreate = OnCreate
UILookForCareer.OnDestroy = OnDestroy
UILookForCareer.OnEnable = OnEnable
UILookForCareer.OnDisable = OnDisable
UILookForCareer.ComponentDefine = ComponentDefine
UILookForCareer.ComponentDestroy = ComponentDestroy
UILookForCareer.DataDefine = DataDefine
UILookForCareer.DataDestroy = DataDestroy
UILookForCareer.OnAddListener = OnAddListener
UILookForCareer.OnRemoveListener = OnRemoveListener
UILookForCareer.ReInit = ReInit
UILookForCareer.ShowItems = ShowItems
UILookForCareer.ClearItems = ClearItems
UILookForCareer.RefreshItems = RefreshItems
UILookForCareer.GetCareerTypeList = GetCareerTypeList
UILookForCareer.OnSelect = OnSelect
UILookForCareer.OnConfirm = OnConfirm
return UILookForCareer
