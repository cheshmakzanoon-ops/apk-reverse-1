local AccuRechargeOverlapDisplayView = BaseClass("AccuRechargeOverlapDisplayView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function AccuRechargeOverlapDisplayView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:InitView()
end

function AccuRechargeOverlapDisplayView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AccuRechargeOverlapDisplayView:OnEnable()
  base.OnEnable(self)
  if not self.soundHandle then
    self.soundHandle = DataCenter.LWSoundManager:PlaySound(202649, false)
  end
end

function AccuRechargeOverlapDisplayView:OnDisable()
  if self.soundHandle then
    DataCenter.LWSoundManager:StopSound(self.soundHandle)
    self.soundHandle = nil
  end
  base.OnDisable(self)
end

function AccuRechargeOverlapDisplayView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.rawImgRawImage1 = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.rawImgRawImagebg2 = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.rawImgRawImagebg3 = self.viewSkin:AddComponent(self, UIRawImage, 4)
end

function AccuRechargeOverlapDisplayView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.rawImgRawImage1 = nil
  self.rawImgRawImagebg2 = nil
  self.rawImgRawImagebg3 = nil
end

function AccuRechargeOverlapDisplayView:DataDefine()
  self.activityId = nil
  self.soundHandle = nil
end

function AccuRechargeOverlapDisplayView:DataDestroy()
  self.activityId = nil
  self.soundHandle = nil
end

function AccuRechargeOverlapDisplayView:OnAddListener()
  base.OnAddListener(self)
end

function AccuRechargeOverlapDisplayView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AccuRechargeOverlapDisplayView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function AccuRechargeOverlapDisplayView:InitView()
  local mergeTemplate = LocalController:instance():getLine(TableName.RECHARGE_MERGE, self.activityId)
  if not mergeTemplate then
    Logger.LogError("mergeTemplate not find,  id:" .. tostring(self.activityId))
    return
  end
  local howToPlay = mergeTemplate.full_howtoplay
  if string.IsNullOrEmpty(howToPlay) then
    Logger.LogError("howToPlay is nil")
    return
  end
  local howToPlayArr = string.split(howToPlay, "|")
  if 3 <= #howToPlayArr then
    self.rawImgRawImage1:LoadSpriteAsync(howToPlayArr[1])
    self.rawImgRawImagebg2:LoadSpriteAsync(howToPlayArr[2])
    self.rawImgRawImagebg3:LoadSpriteAsync(howToPlayArr[3])
  end
end

return AccuRechargeOverlapDisplayView
