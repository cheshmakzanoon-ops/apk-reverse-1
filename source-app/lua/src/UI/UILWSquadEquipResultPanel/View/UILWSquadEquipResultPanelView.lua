local UILWSquadEquipResultPanelView = BaseClass("UILWSquadEquipResultPanelView", UIBaseView)
local base = UIBaseView
local BagItem = require("UI.UILWBag.UILWBagMain.Component.UILWBagItem")
local root_path = "Root"
local back_btn_path = "UICommonPopUpTitle/CloseBtn"
local close_panel_path = "UICommonPopUpTitle/panel"
local confirm_btn_path = "Root/ConfirmBtn"
local prevEquipScroll_path = "Root/PrevContent/PrevEquipScroll/PrevEquipContent"
local nextEquipScroll_path = "Root/NextContent/NextEquipScroll/NextEquipContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local mergeData = self:GetUserData()
  self.msg = mergeData.msg
  self.deletedEquipsNum = mergeData.deletedEquipsNum
  if not self.msg then
    self.ctrl:CloseSelf()
    return
  end
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanel = self:AddComponent(UIButton, close_panel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirmBtn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirmBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.prevEquipScroll = self:AddComponent(UIBaseContainer, prevEquipScroll_path)
  self.nextEquipScroll = self:AddComponent(UIBaseContainer, nextEquipScroll_path)
end

local function ComponentDestroy(self)
  self.root = nil
  self.backBtn = nil
  self.closePanel = nil
  self.confirmBtn = nil
  self.prevEquipScroll = nil
  self.nextEquipScroll = nil
end

local function DataDefine(self)
  self.prevEquipItems = {}
  self.nextEquipItems = {}
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ClearScroll(self)
  self.prevEquipScroll:RemoveComponents(BagItem)
  self.nextEquipScroll:RemoveComponents(BagItem)
  for i, v in ipairs(self.prevEquipItems) do
    self:GameObjectDestroy(v)
  end
  for i, v in ipairs(self.nextEquipItems) do
    self:GameObjectDestroy(v)
  end
  self.prevEquipItems = {}
  self.nextEquipItems = {}
end

local function ReInit(self)
  local srcEquipShowDatas = {}
  if self.deletedEquipsNum and table.count(self.deletedEquipsNum) > 0 then
    for i, v in pairs(self.deletedEquipsNum) do
      local showData = {}
      showData.id = i
      showData.num = v
      table.insert(srcEquipShowDatas, showData)
    end
  end
  if self.msg.changes and 0 < #self.msg.changes then
    for i, v in pairs(self.msg.changes) do
      if 0 > v.changeNum then
        local showData = {}
        for _, _v in pairs(srcEquipShowDatas) do
          if v.cfgId == _v.id then
            showData = _v
            break
          end
        end
        showData.id = v.cfgId
        if showData.num == nil then
          showData.num = 0
        end
        showData.num = showData.num + -v.changeNum
        table.insert(srcEquipShowDatas, showData)
      end
    end
  end
  table.sort(srcEquipShowDatas, function(a, b)
    local aTemp = DataCenter.CommonEquipTemplateManager:GetTemplate(a.id)
    local bTemp = DataCenter.CommonEquipTemplateManager:GetTemplate(b.id)
    if aTemp and bTemp then
      return aTemp.level < bTemp.level
    end
    return a.id < b.id
  end)
  local dstEquipDatas = {}
  if self.msg.changes and 0 < #self.msg.changes then
    for i, v in pairs(self.msg.changes) do
      if 0 < v.changeNum then
        local showData = {}
        showData.id = v.cfgId
        showData.num = v.changeNum
        table.insert(dstEquipDatas, showData)
      end
    end
  end
  table.sort(dstEquipDatas, function(a, b)
    local aTemp = DataCenter.CommonEquipTemplateManager:GetTemplate(a.id)
    local bTemp = DataCenter.CommonEquipTemplateManager:GetTemplate(b.id)
    if aTemp and bTemp then
      return aTemp.level < bTemp.level
    end
    return a.id < b.id
  end)
  if not table.IsNullOrEmpty(srcEquipShowDatas) then
    for k, v in pairs(srcEquipShowDatas) do
      self.prevEquipItems[k] = self:GameObjectInstantiateAsync(UIAssets.UILWBagItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.prevEquipScroll.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_sizeDelta(125, 125)
        go.transform:Set_pivot(0.5, 0.5)
        local nameStr = tostring(k)
        go.name = nameStr
        local cell = self.prevEquipScroll:AddComponent(BagItem, nameStr)
        local showData = {}
        showData.data = DataCenter.CommonEquipDataManager:CreateFakeEquipFromTemplate(v.id, v.num)
        showData.type = BagItemType.CommonEquip
        showData.index = k
        showData.callBack = nil
        showData.showRedPoint = false
        cell:SetData(showData)
      end)
    end
  end
  if not table.IsNullOrEmpty(dstEquipDatas) then
    for k, v in pairs(dstEquipDatas) do
      self.nextEquipItems[k] = self:GameObjectInstantiateAsync(UIAssets.UILWBagItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.nextEquipScroll.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_sizeDelta(125, 125)
        go.transform:Set_pivot(0.5, 0.5)
        local nameStr = tostring(k)
        go.name = nameStr
        local cell = self.nextEquipScroll:AddComponent(BagItem, nameStr)
        local showData = {}
        showData.data = DataCenter.CommonEquipDataManager:CreateFakeEquipFromTemplate(v.id, v.num)
        showData.type = BagItemType.CommonEquip
        showData.index = k
        showData.callBack = nil
        showData.showRedPoint = false
        cell:SetData(showData)
      end)
    end
  end
end

UILWSquadEquipResultPanelView.OnCreate = OnCreate
UILWSquadEquipResultPanelView.OnDestroy = OnDestroy
UILWSquadEquipResultPanelView.OnEnable = OnEnable
UILWSquadEquipResultPanelView.OnDisable = OnDisable
UILWSquadEquipResultPanelView.ComponentDefine = ComponentDefine
UILWSquadEquipResultPanelView.ComponentDestroy = ComponentDestroy
UILWSquadEquipResultPanelView.DataDefine = DataDefine
UILWSquadEquipResultPanelView.DataDestroy = DataDestroy
UILWSquadEquipResultPanelView.OnAddListener = OnAddListener
UILWSquadEquipResultPanelView.OnRemoveListener = OnRemoveListener
UILWSquadEquipResultPanelView.ClearScroll = ClearScroll
UILWSquadEquipResultPanelView.ReInit = ReInit
return UILWSquadEquipResultPanelView
