local UIFactoryAddTipView = BaseClass("UIFactoryAddTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "panel/title_main"
local return_btn_path = "panel"
local close_btn_path = "panel/CloseBtn"
local tips_txt_path = "panel/desTxt"
local btn_path = "panel/AddBtn"
local btn_des_path = "panel/AddBtn/btnTxtObj/Txt1"
local btn_num_path = "panel/AddBtn/btnTxtObj/txt2"
local btn_num_icon_path = "panel/AddBtn/btnTxtObj/txt2/icon"

local function OnCreate(self)
  base.OnCreate(self)
  local a, b = self:GetUserData()
  self.buildUuid = tonumber(a)
  self.buildId = tonumber(b)
  self.title = self:AddComponent(UIText, title_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn_des = self:AddComponent(UIText, btn_des_path)
  self.btn_num = self:AddComponent(UIText, btn_num_path)
  self.btn_num_icon = self:AddComponent(UIImage, btn_num_icon_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAddClick()
  end)
end

local function OnDestroy(self)
  self.title = nil
  self.tips_txt = nil
  self.btn = nil
  self.btn_des = nil
  self.btn_num = nil
  self.close_btn = nil
  self.return_btn = nil
  self.btn_num_icon = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  self.title:SetLocalText(GameDialogDefine.BUY)
  self.tips_txt:SetLocalText(GameDialogDefine.FACTORY_BUY_BOX)
  self.btn_des:SetLocalText(GameDialogDefine.CONFIRM)
  local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(self.buildUuid)
  if factoryData ~= nil then
    local currentBuyNum = factoryData.unlocked + 1
    local items = DataCenter.FactoryDataManager:GetTypePriceByBuildid(self.buildId)
    for k, v in pairs(items) do
      if currentBuyNum == v.id then
        self.btn_num_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(v.type))
        self.btn_num:SetText(math.floor(v.count))
      end
    end
  end
end

local function OnAddClick(self)
  SFSNetwork.SendMessage(MsgDefines.UnLockPlanZone, self.buildUuid)
  self.ctrl:CloseSelf()
end

UIFactoryAddTipView.OnCreate = OnCreate
UIFactoryAddTipView.OnDestroy = OnDestroy
UIFactoryAddTipView.OnEnable = OnEnable
UIFactoryAddTipView.OnDisable = OnDisable
UIFactoryAddTipView.RefreshData = RefreshData
UIFactoryAddTipView.OnAddClick = OnAddClick
return UIFactoryAddTipView
