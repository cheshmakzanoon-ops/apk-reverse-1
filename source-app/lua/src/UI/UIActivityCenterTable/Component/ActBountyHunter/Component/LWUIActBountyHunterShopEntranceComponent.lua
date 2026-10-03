local base = UIBaseContainer
local LWUIActBountyHunterShopEntranceComponent = BaseClass("LWUIActBountyHunterShopEntranceComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local shopBtn_path = ""
local shopText_path = "ShopText"
local shopRedNum_path = "shopRedPoint/shopRedNum"
local icon_path = "Icon"

function LWUIActBountyHunterShopEntranceComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterShopEntranceComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterShopEntranceComponent:ComponentDefine()
  self.shopBtn = self:AddComponent(UIButton, shopBtn_path)
  self.shopBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShopBtnClick()
  end)
  self.shopText = self:AddComponent(UIText, shopText_path)
  self.shopRedNum = self:AddComponent(UIText, shopRedNum_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

function LWUIActBountyHunterShopEntranceComponent:ComponentDestroy()
  self.shopBtn = nil
  self.shopText = nil
  self.shopRedNum = nil
  self.icon = nil
end

function LWUIActBountyHunterShopEntranceComponent:DataDefine()
end

function LWUIActBountyHunterShopEntranceComponent:DataDestroy()
end

function LWUIActBountyHunterShopEntranceComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActBountyHunterShopEntranceComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterShopEntranceComponent:SetData(activityId)
  self.activityId = activityId
  self.activityData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if self.activityData == nil then
    self:SetActive(false)
    return
  end
  self:RefreshView()
end

function LWUIActBountyHunterShopEntranceComponent:RefreshView()
  self.curShowData = nil
  if self.activityData == nil then
    self:SetActive(false)
    return
  end
  local showData = self.activityData:GetEarliestEventShopData()
  local isShow = showData ~= nil
  self:SetActive(isShow)
  if isShow then
    self.curShowData = showData
    local redCount = self.activityData:GetEventShopDataCount()
    self.shopRedNum:SetText(redCount)
    self:Update1000MS()
    if self.activityData.hunterActTmpParaData and not string.IsNullOrEmpty(self.activityData.hunterActTmpParaData.eventshop_icon) then
      self.icon:LoadSprite(self.activityData.hunterActTmpParaData.eventshop_icon)
    end
  end
end

function LWUIActBountyHunterShopEntranceComponent:OnShopBtnClick()
  if self.activityId == nil or self.curShowData == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActBountyHunterShop, {anim = true}, self.activityId)
end

function LWUIActBountyHunterShopEntranceComponent:Update1000MS()
  if not self.curShowData then
    return
  end
  local expireTime = tonumber(self.curShowData.durationTime)
  if not expireTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = expireTime - curTime
  local shopCountDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(leftTime, 0))
  self.shopText:SetText(shopCountDownTimeStr)
  if leftTime < 0 then
    self:RefreshView()
  end
end

function LWUIActBountyHunterShopEntranceComponent:OnEventDataUpdate()
  self:RefreshView()
end

return LWUIActBountyHunterShopEntranceComponent
