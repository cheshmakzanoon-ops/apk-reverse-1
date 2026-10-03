local UILWAllianceGiftInfoView = BaseClass("MailCommonInfoItem", UIBaseView)
local base = UIBaseView
local LWAllianceGiftRewardItem = require("UI.UILWAlliance.UILWAllianceGiftInfo.Component.LWAllianceGiftRewardItem")
local txt_title_path = "ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local title_path = "ImgBg/giftInfoItem/ImgLace/Txt1"
local time_path = "ImgBg/giftInfoItem/ImgLace/TxtTime"
local name_path = "ImgBg/giftInfoItem/ImgLace/TxtName"
local content_txt_path = "ImgBg/giftInfoItem/DesText"
local item_content_path = "ImgBg/giftInfoItem/itemContent"
local get_btn_path = "ImgBg/giftInfoItem/Btn/Button"
local get_txt_path = "ImgBg/giftInfoItem/Btn/Button/btnTxt"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData(self:GetUserData())
  self.title = self:AddComponent(UIText, txt_title_path)
  self.title:SetLocalText(390445)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title = self:AddComponent(UIText, title_path)
  self.time = self:AddComponent(UIText, time_path)
  self.name = self:AddComponent(UIText, name_path)
  self.content = self:AddComponent(UIText, content_txt_path)
  self.get_btn = self:AddComponent(UIButton, get_btn_path)
  self.get_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnGetClick()
  end)
  self.get_txt = self:AddComponent(UIText, get_txt_path)
  self.get_txt:SetLocalText(170004)
  self.item_content = self:AddComponent(UIBaseContainer, item_content_path)
  self.cell_prefab = self.transform:Find("LWAllianceGiftRewardItem").gameObject
  self.cell_prefab:GameObjectCreatePool()
end

local function OnDestroy(self)
  self.title = nil
  self.time = nil
  self.name = nil
  self.content = nil
  self.cell_prefab.gameObject:GameObjectRecycleAll()
  self.cell_prefab = nil
  self.item_content = nil
  base.OnDestroy(self)
end

local function SetData(self)
  self.item_content:RemoveComponents(LWAllianceGiftRewardItem)
  self.cell_prefab.gameObject:GameObjectRecycleAll()
  self.dataInfo = self.view.ctrl:GetAllianceGiftData()
  self.title:SetText(self.dataInfo.title)
  self.time:SetText(self.dataInfo.time)
  self.name:SetText("")
  self.content:SetText("\n" .. self.dataInfo.name)
  local list = self.dataInfo.itemList
  if list ~= nil then
    for i = 1, table.length(list) do
      local item = self.cell_prefab:GameObjectSpawn(self.item_content.transform)
      item.name = "item" .. i
      local obj = self.item_content:AddComponent(LWAllianceGiftRewardItem, item.name)
      obj:RefreshData(list[i])
    end
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RetGiftInfoEvent, self.SetData)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RetGiftInfoEvent, self.SetData)
end

UILWAllianceGiftInfoView.OnCreate = OnCreate
UILWAllianceGiftInfoView.OnDestroy = OnDestroy
UILWAllianceGiftInfoView.OnEnable = OnEnable
UILWAllianceGiftInfoView.OnDisable = OnDisable
UILWAllianceGiftInfoView.SetData = SetData
UILWAllianceGiftInfoView.OnAddListener = OnAddListener
UILWAllianceGiftInfoView.OnRemoveListener = OnRemoveListener
return UILWAllianceGiftInfoView
