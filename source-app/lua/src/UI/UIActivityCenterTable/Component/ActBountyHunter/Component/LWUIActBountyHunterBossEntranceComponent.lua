local base = UIBaseContainer
local LWUIActBountyHunterBossEntranceComponent = BaseClass("LWUIActBountyHunterBossEntranceComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local shopBtn_path = ""
local shopText_path = "ShopText"
local shopRedNum_path = "shopRedPoint/shopRedNum"
local icon_path = "Icon"
local bg_path = "Bg"

function LWUIActBountyHunterBossEntranceComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterBossEntranceComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterBossEntranceComponent:ComponentDefine()
  self.shopBtn = self:AddComponent(UIButton, shopBtn_path)
  self.shopBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShopBtnClick()
  end)
  self.shopText = self:AddComponent(UIText, shopText_path)
  self.shopRedNum = self:AddComponent(UIText, shopRedNum_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.imgBg = self:AddComponent(UIImage, bg_path)
end

function LWUIActBountyHunterBossEntranceComponent:ComponentDestroy()
  self.shopBtn = nil
  self.shopText = nil
  self.shopRedNum = nil
  self.icon = nil
  self.imgBg = nil
end

function LWUIActBountyHunterBossEntranceComponent:DataDefine()
end

function LWUIActBountyHunterBossEntranceComponent:DataDestroy()
end

function LWUIActBountyHunterBossEntranceComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActBountyHunterBossEntranceComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterBossEntranceComponent:SetData(activityId, sceneViewer)
  self.activityId = activityId
  self.sceneViewer = sceneViewer
  self.activityData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if self.activityData == nil then
    self:SetActive(false)
    return
  end
  self:RefreshView()
end

function LWUIActBountyHunterBossEntranceComponent:RefreshView()
  self.curShowData = nil
  if self.activityData == nil then
    self:SetActive(false)
    return
  end
  local showData = self.activityData:GetEarliestEventBossData()
  local redCount = self.activityData:GetEventBossDataCount()
  local isShow = showData ~= nil and 0 < redCount
  self:SetActive(isShow)
  if isShow then
    self.curShowData = showData
    self.shopRedNum:SetText(redCount)
    if self.activityData.hunterActTmpParaData and not string.IsNullOrEmpty(self.activityData.hunterActTmpParaData.main_boss_btn) then
      self.icon:LoadSprite(self.activityData.hunterActTmpParaData.main_boss_btn)
    end
  end
end

function LWUIActBountyHunterBossEntranceComponent:OnShopBtnClick()
  UIUtil.ShowTipsId("activity_hunter_alert18")
end

function LWUIActBountyHunterBossEntranceComponent:OnEventDataUpdate()
  self:RefreshView()
end

return LWUIActBountyHunterBossEntranceComponent
