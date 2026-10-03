local base = UIBaseContainer
local UIWorldLLCityPointNormalBattle = BaseClass("UIWorldLLCityPointNormalBattle", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIWorldLLCityPointNormalBattle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldLLCityPointNormalBattle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCityPointNormalBattle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTips1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnDetail1 = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnDetail1:SetOnClick(function()
    self:OnBtnDetail1Click()
  end)
  self.sliderProgressBuild = self.viewSkin:AddComponent(self, UISlider, 3)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgProgress = self.viewSkin:AddComponent(self, UIImage, 5)
end

function UIWorldLLCityPointNormalBattle:ComponentDestroy()
  self.viewSkin = nil
  self.textTips1 = nil
  self.btnDetail1 = nil
  self.sliderProgressBuild = nil
  self.textProgress = nil
  self.imgProgress = nil
end

function UIWorldLLCityPointNormalBattle:DataDefine()
  self.compSpeed = nil
end

function UIWorldLLCityPointNormalBattle:DataDestroy()
  self.compSpeed = nil
end

function UIWorldLLCityPointNormalBattle:OnAddListener()
  base.OnAddListener(self)
end

function UIWorldLLCityPointNormalBattle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWorldLLCityPointNormalBattle:OnBtnDetail1Click()
  if self.compSpeed == nil then
    self.compSpeed = self:LoadComponentAsync(LLConst.CLS_DETAIL_SPEED, LLConst.PREFAB_DETAIL_SPEED, self.holder, function(view)
      self:RefreshCompSpeed()
    end)
  end
  local worldPos = self.btnDetail1:GetPosition()
  local targetP = self.holder.transform:InverseTransformPoint(worldPos)
  self.compSpeed:SetTargetPos(targetP, true)
end

function UIWorldLLCityPointNormalBattle:RefreshCompSpeed()
  if self.compSpeed and self.compSpeed:AsyncLoadDone() then
    local effectValue = self.data.effectValue
    local startOccupyTime = self.data.tmpOwnerCampId ~= LLConst.LandLordGroup.NONE and self.data.occupyStartTime
    self.compSpeed:SetExtraValue((effectValue or 0) + 1, startOccupyTime)
  end
end

local RED_FILL_IMG = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_tongyong_jindutiao_hong.png"
local BLUE_FILL_IMG = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lan.png"

function UIWorldLLCityPointNormalBattle:Refresh(data)
  if self.activeSelf then
    self.data = data
    local isMeLord = DataCenter.LandlordMgr:GetMyGroup() == LLConst.LandLordGroup.LORD
    self.textTips1:SetLocalText(isMeLord and "zonewar_landlord_limit_1037" or "zonewar_landlord_limit_1035")
    self:Update1000MS()
    local tmpOwnerCampId = self.data.tmpOwnerCampId
    local myCampId = DataCenter.LandlordMgr:GetMyGroup()
    if tmpOwnerCampId ~= LLConst.LandLordGroup.NONE then
      self.imgProgress:LoadSpriteAuto(tmpOwnerCampId == myCampId and BLUE_FILL_IMG or RED_FILL_IMG)
    else
      self.imgProgress:LoadSpriteAuto(RED_FILL_IMG)
    end
    self:RefreshCompSpeed()
  end
end

function UIWorldLLCityPointNormalBattle:Update1000MS()
  local maxProgress = self.data.progressMax
  local tmpOwnerCampId = self.data.tmpOwnerCampId
  if tmpOwnerCampId == LLConst.LandLordGroup.NONE then
    self.sliderProgressBuild:SetValue(self.data.progress / maxProgress)
    self.textProgress:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(toInt(self.data.progress)), string.GetFormattedSeparatorNum(toInt(maxProgress))))
  else
    local progress = DataCenter.LandlordMgr:CalculateOccupyCurProgress(self.data.occupyStartTime, self.data.occupyStartProgress, maxProgress, self.data.tmpOwnerCampId, self.data.effectValue, false)
    self.sliderProgressBuild:SetValue(progress / maxProgress)
    self.textProgress:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(toInt(progress)), string.GetFormattedSeparatorNum(toInt(maxProgress))))
  end
end

return UIWorldLLCityPointNormalBattle
