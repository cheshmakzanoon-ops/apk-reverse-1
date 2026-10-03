local NeedResCell = require("UI.UIResourceLack.Component.NeedResCell")
local UIResourceLackView = BaseClass("UIResourceLackView", UIBaseView)
local base = UIBaseView
local title_path = "ImgBg/title_main"
local des_path = "ImgBg/desTxt"
local return_btn_path = "Panel"
local close_btn_path = "ImgBg/CloseBtn"
local add_btn_path = "ImgBg/AddBtn"
local content_path = "ImgBg/Common_bg_need_resource"
local add_txt_path = "ImgBg/AddBtn/btnTxt"
local image_bg_path = "ImgBg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(120020)
  self.des = self:AddComponent(UIText, des_path)
  self.des:SetLocalText(120194)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.img_bg = self:AddComponent(UIImage, image_bg_path)
  self.add_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAddClick()
  end)
  self.add_txt = self:AddComponent(UIText, add_txt_path)
  self.add_txt:SetLocalText(100547)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  local k, v, startPt = self:GetUserData()
  if startPt ~= nil then
    local time = 0.3
    self.img_bg.transform:Set_position(startPt.x, startPt.y, startPt.z)
    self.img_bg.transform:Set_localScale(0.1, 0.1, 0.1)
    self.img_bg.transform:DOLocalMove(Vector3.New(0, -5, 0), time)
    self.img_bg.transform:DOScale(Vector3.one, time)
  end
end

local function ComponentDestroy(self)
  self:ClearList()
  self.title = nil
  self.des = nil
  self.content = nil
  self.add_btn = nil
  self.add_txt = nil
  self.close_btn = nil
  self.return_btn = nil
  self.img_bg = nil
end

local function DataDefine(self)
  self.lackItems = nil
end

local function DataDestroy(self)
  self.lackItems = nil
  self.extraData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.lackResource, self.ischeck, self.startPt, self.lackItems, self.extraData = self:GetUserData()
  self:ClearList()
  local resourceCount = 0
  if self.lackResource ~= nil and 0 < table.count(self.lackResource) then
    resourceCount = table.count(self.lackResource)
    table.walk(self.lackResource, function(k, v)
      self.model[k] = self:GameObjectInstantiateAsync(UIAssets.NeedResourceCell, function(request)
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
        local param = {}
        param.resourceType = k
        if self.ischeck then
          param.count = v
        else
          param.count = v - LuaEntry.Resource:GetCntByResType(k)
        end
        param.isRed = true
        self.needResourceCells[k] = self.content:AddComponent(NeedResCell, nameStr)
        self.needResourceCells[k]:ReInit(param)
      end)
    end)
  end
  if self.lackItems ~= nil and 0 < table.count(self.lackItems) then
    for k, v in ipairs(self.lackItems) do
      self.model[resourceCount + k] = self:GameObjectInstantiateAsync(UIAssets.NeedResourceCell, function(request)
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
        local param = {}
        param.itemId = v.itemId
        local own = 0
        local item = DataCenter.ItemData:GetItemById(param.itemId)
        if item ~= nil then
          own = item.count
        end
        param.count = v.count - own
        param.isRed = true
        self.needItemCells[k] = self.content:AddComponent(NeedResCell, nameStr)
        self.needItemCells[k]:ReInit(param)
      end)
    end
  end
end

local function ClearList(self)
  self.content:RemoveComponents(NeedResCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.needResourceCells = {}
  self.needItemCells = {}
  self.model = {}
end

local function OnAddClick(self)
  if self.extraData then
    GoToResLack.GotoOpenView(UIWindowNames.UIResourceLackNew, {anim = true}, self.extraData.resList, self.extraData.dis, nil, true)
  elseif self.lackResource ~= nil and table.count(self.lackResource) > 0 then
    local resourceType
    for k, v in pairs(self.lackResource) do
      resourceType = k
      break
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag, resourceType, self.lackResource)
  elseif self.lackItems ~= nil and 0 < table.count(self.lackItems) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemPurchases, {anim = true}, self.lackItems[1])
  end
  self.ctrl:CloseSelf()
end

UIResourceLackView.OnCreate = OnCreate
UIResourceLackView.OnDestroy = OnDestroy
UIResourceLackView.OnEnable = OnEnable
UIResourceLackView.OnDisable = OnDisable
UIResourceLackView.ComponentDefine = ComponentDefine
UIResourceLackView.ComponentDestroy = ComponentDestroy
UIResourceLackView.DataDefine = DataDefine
UIResourceLackView.DataDestroy = DataDestroy
UIResourceLackView.ReInit = ReInit
UIResourceLackView.ClearList = ClearList
UIResourceLackView.OnAddClick = OnAddClick
return UIResourceLackView
