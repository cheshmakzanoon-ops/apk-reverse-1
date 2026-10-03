local ActMonopolyShopBtnContent = BaseClass("ActMonopolyShopBtnContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local shopBtn_path = "ActivityTopGo/ShopBtn"
local shopText_path = "ActivityTopGo/ShopBtn/ShopText"
local shopBtnEffect_path = "ActivityTopGo/ShopBtn/Eff_ui_beizengmen_jinbi_chupeng"
local shopRedNum_path = "ActivityTopGo/ShopBtn/shopRedPoint/shopRedNum"
local icon_path = "ActivityTopGo/ShopBtn/Icon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.shopBtn = self:AddComponent(UIButton, shopBtn_path)
  self.shopBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShopBtnClick()
  end)
  self.shopText = self:AddComponent(UIText, shopText_path)
  self.shopRedNum = self:AddComponent(UIText, shopRedNum_path)
  self.shopBtnEffect = self:AddComponent(UIBaseContainer, shopBtnEffect_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.shopShowData = nil
  self.isPlayShopBtnAni = false
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self.shopShowData = self.activityDetailData:GetShopShowListData()
  if self.shopShowData.refreshTime < 0 then
    SFSNetwork.SendMessage(MsgDefines.RichManShopList, self.activityId, ActMonopolyDiceType.Normal)
  end
  self:SetShopBtnIcon()
  self:RefreshView()
end

local function RefreshView(self)
  self:RefreshShopBtnView()
  self:Update1000MS()
end

local function RefreshShopBtnView(self)
  if self.shopShowData == nil then
    return
  end
  self.shopBtn:SetActive(self.shopShowData.refreshTime > 0)
  local shopNum = self.shopShowData.dataArr and #self.shopShowData.dataArr or 0
  self.shopRedNum:SetText(shopNum)
  self.shopBtnEffect:SetActive(false)
end

local function OnShopBtnClick(self)
  if self.activityDetailData == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyShop, {anim = true}, self.activityId, self.activityDetailData)
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.shopShowData and self.shopShowData.refreshTime > 0 then
    local shopLeftTime = self.shopShowData.refreshTime * 1000 - curTime
    if shopLeftTime < 0 then
      shopLeftTime = 0
    end
    local shopCountDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(shopLeftTime)
    self.shopText:SetText(shopCountDownTimeStr)
    if shopLeftTime <= 0 then
      self.shopShowData = self.activityDetailData:GetShopShowListData()
      self:RefreshShopBtnView()
    end
  end
end

local function OnGetShopDataChangeMsg(self)
  if self.activityDetailData == nil then
    return
  end
  self.shopShowData = self.activityDetailData:GetShopShowListData()
  self:RefreshView()
end

local function SetShopBtnIcon(self)
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.activityInfo.richman_para)
  if paraTemp and not string.IsNullOrEmpty(paraTemp.shop_icon) then
    local path = string.format(UIAssets.UIActMonopolySpritePath, paraTemp.shop_icon)
    self.icon:LoadSprite(path)
  end
end

ActMonopolyShopBtnContent.OnCreate = OnCreate
ActMonopolyShopBtnContent.OnDestroy = OnDestroy
ActMonopolyShopBtnContent.ComponentDefine = ComponentDefine
ActMonopolyShopBtnContent.ComponentDestroy = ComponentDestroy
ActMonopolyShopBtnContent.DataDefine = DataDefine
ActMonopolyShopBtnContent.DataDestroy = DataDestroy
ActMonopolyShopBtnContent.SetData = SetData
ActMonopolyShopBtnContent.RefreshView = RefreshView
ActMonopolyShopBtnContent.Update1000MS = Update1000MS
ActMonopolyShopBtnContent.OnShopBtnClick = OnShopBtnClick
ActMonopolyShopBtnContent.RefreshShopBtnView = RefreshShopBtnView
ActMonopolyShopBtnContent.OnGetShopDataChangeMsg = OnGetShopDataChangeMsg
ActMonopolyShopBtnContent.SetShopBtnIcon = SetShopBtnIcon
return ActMonopolyShopBtnContent
