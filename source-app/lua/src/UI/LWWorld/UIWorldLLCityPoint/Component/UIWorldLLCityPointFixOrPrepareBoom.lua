local base = UIBaseContainer
local UIWorldLLCityPointFixOrPrepareBoom = BaseClass("UIWorldLLCityPointFixOrPrepareBoom", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIWorldLLCityPointFixOrPrepareBoom:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldLLCityPointFixOrPrepareBoom:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCityPointFixOrPrepareBoom:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTips1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.sliderProgressBuild = self.viewSkin:AddComponent(self, UISlider, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function UIWorldLLCityPointFixOrPrepareBoom:ComponentDestroy()
  self.viewSkin = nil
  self.textTips1 = nil
  self.sliderProgressBuild = nil
  self.imgIcon = nil
  self.textProgress = nil
end

function UIWorldLLCityPointFixOrPrepareBoom:DataDefine()
end

function UIWorldLLCityPointFixOrPrepareBoom:DataDestroy()
end

function UIWorldLLCityPointFixOrPrepareBoom:OnAddListener()
  base.OnAddListener(self)
end

function UIWorldLLCityPointFixOrPrepareBoom:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWorldLLCityPointFixOrPrepareBoom:Refresh(info)
  self.info = info
  local clientState = self.info.clientState
  self.startTime = 0
  self.endTime = 0
  if clientState == LLConst.LLBuildingState.Rebuilding then
    self.startTime = info.fixStartTime
    self.endTime = info.fixEndTime
    self.textTips1:SetLocalText("zonewar_landlord_limit_1065")
    self.imgIcon:LoadSpriteAsync("Assets/Main/Sprites/UI/Landlord/lrb_jinmai_zhujiemian_xiujian.png")
  elseif clientState == LLConst.LLBuildingState.WillExplode then
    if self.info.isOldCity then
      self.startTime = (DataCenter.LandlordMgr:GetActCurStageInfo() and DataCenter.LandlordMgr:GetActCurStageInfo().sTime or 0) * 1000
      self.endTime = DataCenter.LandlordMgr:GetPreviewBoomTime()
    else
      self.startTime = info.overTime
      local boomTime = self.info.landlordCityTemplate.boom_time
      self.endTime = self.startTime + boomTime * 1000
    end
    self.textTips1:SetLocalText("zonewar_landlord_limit_1036")
    self.imgIcon:LoadSpriteAsync("Assets/Main/Sprites/UI/Landlord/lrb_jinmai_zhujiemian_baozha.png")
  end
  self:Update1000MS()
end

function UIWorldLLCityPointFixOrPrepareBoom:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.startTime and curTime <= self.endTime then
    local deltaTime = curTime - self.startTime
    local totalTime = self.endTime - self.startTime
    self.sliderProgressBuild:SetValue(deltaTime / totalTime)
    self.textProgress:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
  else
    self.sliderProgressBuild:SetValue(curTime < self.startTime and 0 or 1)
    self.textProgress:SetText(curTime < self.startTime and "0.0%" or "100.0%")
  end
end

return UIWorldLLCityPointFixOrPrepareBoom
