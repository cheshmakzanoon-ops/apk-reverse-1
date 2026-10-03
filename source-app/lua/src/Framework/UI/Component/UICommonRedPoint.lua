local base = UIBaseContainer
local UICommonRedPoint = BaseClass("UICommonRedPoint", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local numIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_hongdian_shuzi.png"
local defaultIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_hongdian_xiao.png"

function UICommonRedPoint:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICommonRedPoint:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonRedPoint:ComponentDefine()
  self.imgBg = self:AddComponent(UIImage, "bg")
  local obj = self.transform:Find("Num")
  if obj ~= nil then
    self.textNum = self:AddComponent(UITextMeshProUGUIEx, "Num")
  else
    obj = self.transform:Find("Text")
    if obj ~= nil then
      self.textNum = self:AddComponent(UITextMeshProUGUIEx, "Text")
    end
  end
  if self.textNum ~= nil then
    self.textNum:SetActive(false)
  end
end

function UICommonRedPoint:ComponentDestroy()
  self.imgBg = nil
  self.textNum = nil
end

function UICommonRedPoint:DataDefine()
  self.rewardIconPath = DataCenter.CommonRedPointManager:GetRewardPointIcon()
end

function UICommonRedPoint:DataDestroy()
end

function UICommonRedPoint:SetId(redPointId)
  self.redPointId = redPointId
end

function UICommonRedPoint:SetType(priority, extraType)
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

function UICommonRedPoint:SetNum(rewardNum, tipNum)
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
    if self.textNum ~= nil then
      self.textNum:SetActive(true)
      self.textNum:SetText(UIUtil.ShowRedNumCheckMax(self.tipNum))
    end
    self.imgBg:SetActive(true)
    if self.imgBg:LoadSprite(numIconPath) then
      self.imgBg:SetNativeSize()
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
    if self.textNum ~= nil then
      self.textNum:SetActive(false)
    end
    self.imgBg:SetActive(true)
    if self.rewardIconPath and self.imgBg:LoadSprite(self.rewardIconPath) then
      self.imgBg:SetNativeSize()
    end
  else
    self:SetActive(false)
  end
end

function UICommonRedPoint:SetDefaultVisible(visible)
  if self.priority == nil then
    return
  end
  if self.textNum ~= nil then
    self.textNum:SetActive(false)
  end
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
    end
  else
    self:SetActive(false)
  end
end

function UICommonRedPoint:SetForceTipNum(tipNum)
  local visible = 0 < tipNum
  if visible then
    base.SetActive(self, true)
    if self.textNum ~= nil then
      self.textNum:SetActive(true)
      self.textNum:SetText(UIUtil.ShowRedNumCheckMax(tipNum))
    end
    self.imgBg:SetActive(true)
    if self.imgBg:LoadSprite(numIconPath) then
      self.imgBg:SetNativeSize()
    end
  else
    self:SetActive(false)
  end
end

function UICommonRedPoint:SetForceTipVisible(visible)
  if self.textNum ~= nil then
    self.textNum:SetActive(false)
  end
  if visible then
    base.SetActive(self, true)
    self.imgBg:SetActive(true)
    if self.imgBg:LoadSprite(defaultIconPath) then
      self.imgBg:SetNativeSize()
    end
  else
    self:SetActive(false)
  end
end

function UICommonRedPoint:SetActive(active)
  if self.priority == nil then
    return
  end
  if active then
    Logger.LogError("UICommonRedPoint Invalid active !")
    base.SetActive(self, false)
    return
  end
  if self.extraType == CommonRedPointExtraType.Hide then
    base.SetActive(self, false)
    return
  end
  base.SetActive(self, active)
end

function UICommonRedPoint:SetViewed()
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

return UICommonRedPoint
