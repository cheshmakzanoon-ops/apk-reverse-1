local NeedResCell = require("UI.UIResourceLack.Component.NeedResCell")
local UIResourceItemLackView = BaseClass("UIResourceItemLackView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "ImgBg/title_main"
local des_path = "ImgBg/desTxt"
local return_btn_path = "Panel"
local close_btn_path = "ImgBg/CloseBtn"
local add_btn_path = "ImgBg/AddBtn"
local content_path = "ImgBg/Common_bg_need_resource"
local add_txt_path = "ImgBg/AddBtn/btnTxt_yellow_mid_new/Txt1"
local diamond_num_text_path = "ImgBg/AddBtn/btnTxt_yellow_mid_new/txt2"
local diamond_icon_path = "ImgBg/AddBtn/btnTxt_yellow_mid_new/txt2/icon"
local speed_item_path = "UIMainTopResourceCell"
local speed_item_icon_path = "UIMainTopResourceCell/root/resourceIcon"
local speed_item_num_path = "UIMainTopResourceCell/root/resourceNum"

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
  self.des:SetLocalText(GameDialogDefine.BUY_RESOURCE_ITEM)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.diamond_num_text = self:AddComponent(UIText, diamond_num_text_path)
  self.diamond_icon = self:AddComponent(UIImage, diamond_icon_path)
  self.speed_item = self:AddComponent(UIBaseContainer, speed_item_path)
  self.speed_item_icon = self:AddComponent(UIImage, speed_item_icon_path)
  self.speed_item_num = self:AddComponent(UIText, speed_item_num_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAddClick()
  end)
  self.add_txt = self:AddComponent(UIText, add_txt_path)
  self.add_txt:SetLocalText(100547)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    if self.param.closeAction ~= nil then
      self.param.closeAction()
    end
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    if self.param.closeAction ~= nil then
      self.param.closeAction()
    end
    self.ctrl:CloseSelf()
  end)
  self.speed_item:SetActive(false)
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
  self.diamond_num_text = nil
  self.diamond_icon = nil
  self.speed_item = nil
  self.speed_item_icon = nil
  self.speed_item_num = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.param = self:GetUserData()
  self:ClearList()
  table.walk(self.param.lackItems, function(k, v)
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
      param.resourceItemId = k
      param.count = v
      param.isRed = true
      self.needResourceCells[k] = self.content:AddComponent(NeedResCell, nameStr)
      self.needResourceCells[k]:ReInit(param)
    end)
  end)
  self.diamond_num_text:SetText(string.GetFormattedSeperatorNum(self.param.totalDiamond))
end

local function ClearList(self)
  self.content:RemoveComponents(NeedResCell)
  if self.model ~= nil then
    for _, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.needResourceCells = {}
  self.model = {}
end

local function OnAddClick(self)
  local gold = LuaEntry.Player.gold
  if gold < self.param.totalDiamond then
    GoToUtil.GotoPayTips(self.param.totalDiamond)
  else
    self.param.action()
    self.ctrl:CloseSelf()
  end
end

UIResourceItemLackView.OnCreate = OnCreate
UIResourceItemLackView.OnDestroy = OnDestroy
UIResourceItemLackView.OnEnable = OnEnable
UIResourceItemLackView.OnDisable = OnDisable
UIResourceItemLackView.ComponentDefine = ComponentDefine
UIResourceItemLackView.ComponentDestroy = ComponentDestroy
UIResourceItemLackView.DataDefine = DataDefine
UIResourceItemLackView.DataDestroy = DataDestroy
UIResourceItemLackView.ReInit = ReInit
UIResourceItemLackView.ClearList = ClearList
UIResourceItemLackView.OnAddClick = OnAddClick
return UIResourceItemLackView
