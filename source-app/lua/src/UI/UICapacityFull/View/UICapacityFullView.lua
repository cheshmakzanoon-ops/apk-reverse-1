local UICapacityFullView = BaseClass("UICapacityFullView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICapacityFullItem = require("UI.UICapacityFull.Component.UICapacityFullItem")
local title_path = "ImgBg/titleText"
local return_btn_path = "panel"
local close_btn_path = "ImgBg/CloseBtn"
local content_path = "ImgBg/Common_bg_need_resource"
local restxt_path = "ImgBg/Res_Rect/Res_Txt"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self.capacity = self:GetUserData()
  self:ComponentDefine()
end

local function OnDestroy(self)
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

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.resTxt = self:AddComponent(UIText, restxt_path)
  if self.capacity then
    self.title_text:SetLocalText(162104)
    self.resTxt:SetLocalText(121269)
  else
    self.title_text:SetLocalText(128001)
    self.resTxt:SetLocalText(110199)
  end
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.panel_btn = self:AddComponent(UIButton, return_btn_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self:ClearList()
  self.title_text = nil
  self.content = nil
  self.panel_btn = nil
  self.close_btn = nil
end

local function DataDefine(self)
  self.lackResource = {}
end

local function DataDestroy(self)
  self.lackResource = nil
end

local function ReInit(self)
  self.lackResource = self.ctrl:GetShowList(self.capacity)
  self.model = {}
  self:ClearList()
  for i = 1, #self.lackResource do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.ResourceLackItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.needResourceCells[i] = self.content:AddComponent(UICapacityFullItem, nameStr)
      self.needResourceCells[i]:ReInit(self.lackResource[i])
      if i == 1 then
        self.needResourceCells[i]:ShowRecommend(true)
      end
    end)
  end
end

local function ClearList(self)
  self.content:RemoveComponents(UICapacityFullItem)
  if next(self.model) then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.needResourceCells = {}
end

local function CheckShowArrow(self)
  self.delayTimer = nil
  if DataCenter.ArrowTipTemplateManager:IsCanShowArrow(ArrowType.LackResource) and self.needResourceCells ~= nil and self.needResourceCells[1] ~= nil then
    local param = {}
    param.position = self.needResourceCells[1].transform.position + Vector3.New(0, 80 * self.transform.lossyScale.y, 0)
    param.arrowType = ArrowType.LackResource
    param.positionType = PositionType.Screen
    DataCenter.ArrowManager:ShowArrow(param)
  end
end

UICapacityFullView.OnCreate = OnCreate
UICapacityFullView.OnDestroy = OnDestroy
UICapacityFullView.OnEnable = OnEnable
UICapacityFullView.OnDisable = OnDisable
UICapacityFullView.OnAddListener = OnAddListener
UICapacityFullView.OnRemoveListener = OnRemoveListener
UICapacityFullView.ComponentDefine = ComponentDefine
UICapacityFullView.ComponentDestroy = ComponentDestroy
UICapacityFullView.DataDefine = DataDefine
UICapacityFullView.DataDestroy = DataDestroy
UICapacityFullView.ReInit = ReInit
UICapacityFullView.ClearList = ClearList
UICapacityFullView.CheckShowArrow = CheckShowArrow
return UICapacityFullView
