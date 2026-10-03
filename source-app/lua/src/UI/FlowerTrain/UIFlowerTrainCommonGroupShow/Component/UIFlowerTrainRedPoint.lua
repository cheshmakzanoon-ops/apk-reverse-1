local base = UIBaseContainer
local UIFlowerTrainRedPoint = BaseClass("UIFlowerTrainRedPoint", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local numIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_hongdian_shuzi.png"
local defaultIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_hongdian_xiao.png"

function UIFlowerTrainRedPoint:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFlowerTrainRedPoint:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainRedPoint:ComponentDefine()
  self.imgBg = self:AddComponent(UIImage, "bg")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "Num")
  self.textNum:SetActive(false)
end

function UIFlowerTrainRedPoint:ComponentDestroy()
  self.imgBg = nil
  self.textNum = nil
end

function UIFlowerTrainRedPoint:DataDefine()
  self.rewardIconPath = DataCenter.CommonRedPointManager:GetRewardPointIcon()
end

function UIFlowerTrainRedPoint:DataDestroy()
end

function UIFlowerTrainRedPoint:SetId(redPointId)
  self.redPointId = redPointId
end

function UIFlowerTrainRedPoint:SetType(priority, extraType)
  if priority == nil then
    self.priority = CommonRedPointPriority.Level1
  else
    self.priority = priority
  end
  if extraType == nil then
    self.extraType = CommonRedPointExtraType.normal
  else
    self.extraType = extraType
  end
end

function UIFlowerTrainRedPoint:SetNum(rewardNum, tipNum)
  if self.priority == nil then
    return
  end
  self.rewardNum = rewardNum or 0
  self.tipNum = tipNum or 0
  if 0 < self.tipNum then
    if DataCenter.CommonRedPointManager.FirstLogin then
      self:SetActive(false)
      return
    end
    if self.extraType == CommonRedPointExtraType.Hide then
      self:SetActive(false)
      return
    end
    if self.redPointId and DataCenter.CommonRedPointManager:CheckHide(self.redPointId) then
      base.SetActive(self, false)
      return
    end
    base.SetActive(self, true)
    self.textNum:SetActive(true)
    self.textNum:SetText(UIUtil.ShowRedNumCheckMax(self.tipNum))
    self.imgBg:SetActive(true)
    if self.imgBg:LoadSprite(numIconPath) then
      self.imgBg:SetNativeSize()
      self.imgBg:SetAnchoredPositionXY(0, 0)
    end
  elseif self.rewardNum > 0 then
    if DataCenter.CommonRedPointManager.FirstLogin and self.priority ~= CommonRedPointPriority.Level1 then
      self:SetActive(false)
      return
    end
    if self.extraType == CommonRedPointExtraType.Hide then
      self:SetActive(false)
      return
    end
    if self.redPointId and DataCenter.CommonRedPointManager:CheckHide(self.redPointId) then
      base.SetActive(self, false)
      return
    end
    base.SetActive(self, true)
    self.textNum:SetActive(false)
    self.imgBg:SetActive(true)
    if self.rewardIconPath and self.imgBg:LoadSprite(self.rewardIconPath) then
      self.imgBg:SetNativeSize()
    end
  else
    self:SetActive(false)
  end
end

function UIFlowerTrainRedPoint:SetDefaultVisible(visible)
  if self.priority == nil then
    return
  end
  self.textNum:SetActive(false)
  if visible then
    if DataCenter.CommonRedPointManager.FirstLogin then
      self:SetActive(false)
      return
    end
    if self.extraType == CommonRedPointExtraType.Hide then
      self:SetActive(false)
      return
    end
    if self.redPointId and DataCenter.CommonRedPointManager:CheckHide(self.redPointId) then
      base.SetActive(self, false)
      return
    end
    base.SetActive(self, true)
    self.imgBg:SetActive(true)
    if self.imgBg:LoadSprite(defaultIconPath) then
      self.imgBg:SetNativeSize()
      self.imgBg:SetAnchoredPositionXY(3, 3.3)
    end
  else
    self:SetActive(false)
  end
end

function UIFlowerTrainRedPoint:SetForceTipNum(tipNum)
  local visible = 0 < tipNum
  if visible then
    base.SetActive(self, true)
    self.textNum:SetActive(true)
    self.textNum:SetText(UIUtil.ShowRedNumCheckMax(tipNum))
    self.imgBg:SetActive(true)
    if self.imgBg:LoadSprite(numIconPath) then
      self.imgBg:SetNativeSize()
      self.imgBg:SetAnchoredPositionXY(0, 0)
    end
  else
    self:SetActive(false)
  end
end

function UIFlowerTrainRedPoint:SetForceTipVisible(visible)
  self.textNum:SetActive(false)
  if visible then
    base.SetActive(self, true)
    self.imgBg:SetActive(true)
    if self.imgBg:LoadSprite(defaultIconPath) then
      self.imgBg:SetNativeSize()
      self.imgBg:SetAnchoredPositionXY(3, 3.3)
    end
  else
    self:SetActive(false)
  end
end

function UIFlowerTrainRedPoint:SetActive(active)
  if self.priority == nil then
    return
  end
  if active then
    Logger.LogError("UIFlowerTrainRedPoint Invalid active !")
    base.SetActive(self, false)
    return
  end
  if self.extraType == CommonRedPointExtraType.Hide then
    base.SetActive(self, false)
    return
  end
  base.SetActive(self, active)
end

function UIFlowerTrainRedPoint:SetViewed()
  if not self.redPointId then
    return
  end
  if not self:GetActive() then
    return
  end
  if DataCenter.CommonRedPointManager:Hide(self.redPointId) then
    base.SetActive(self, false)
  end
end

return UIFlowerTrainRedPoint
