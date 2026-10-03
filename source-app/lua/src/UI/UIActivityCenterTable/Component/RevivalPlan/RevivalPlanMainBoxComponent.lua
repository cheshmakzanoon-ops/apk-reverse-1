local base = UIBaseContainer
local RevivalPlanMainBoxComponent = BaseClass("RevivalPlanMainBoxComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local lightPicPath = "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_baoxiang_02.png"
local darkPicPath = "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_baoxiang_03.png"
local keyAnimLength = 1.5

function RevivalPlanMainBoxComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RevivalPlanMainBoxComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RevivalPlanMainBoxComponent:ComponentDefine()
  self.rawImgBoxIcon = self:AddComponent(UIRawImage, "boxIcon")
  self.btnBox = self:AddComponent(UIButton, "boxIcon")
  self.btnBox:SetOnClick(function()
    self:OnBtnBoxClick()
  end)
  self.compKey1 = self:AddComponent(UIBaseContainer, "keys/key1")
  self.compKey2 = self:AddComponent(UIBaseContainer, "keys/key2")
  self.compKey3 = self:AddComponent(UIBaseContainer, "keys/key3")
  self.compKey4 = self:AddComponent(UIBaseContainer, "keys/key4")
  self.compKey5 = self:AddComponent(UIBaseContainer, "keys/key5")
  self.compLight1 = self:AddComponent(UIImage, "lights/light1")
  self.compLight2 = self:AddComponent(UIImage, "lights/light2")
  self.compLight3 = self:AddComponent(UIImage, "lights/light3")
  self.compLight4 = self:AddComponent(UIImage, "lights/light4")
  self.compLight5 = self:AddComponent(UIImage, "lights/light5")
  self.textKeyword = self:AddComponent(UIText, "keywordBg/keyword")
  self.keywordBg = self:AddComponent(UIBaseContainer, "keywordBg")
  self.keysBlack = self:AddComponent(UIButton, "keysBlack")
  self.keysBlack:SetOnClick(function()
    self:OnMaskClick()
  end)
  self.compKey1Anim = self:AddComponent(UISimpleAnimation, "keys/key1")
  self.compKey2Anim = self:AddComponent(UISimpleAnimation, "keys/key2")
  self.compKey3Anim = self:AddComponent(UISimpleAnimation, "keys/key3")
  self.compKey4Anim = self:AddComponent(UISimpleAnimation, "keys/key4")
  self.compKey5Anim = self:AddComponent(UISimpleAnimation, "keys/key5")
  self.boxEffectBg = self:AddComponent(UIBaseContainer, "boxEffectBg")
  self.boxEffectBg:SetActive(false)
  self.boxEffectFg = self:AddComponent(UIBaseContainer, "boxEffectFg")
  self.boxEffectFg:SetActive(false)
  self.keywordEffect = self:AddComponent(UIBaseContainer, "keywordBg/keywordEffect")
  self.keywordEffect:SetActive(false)
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.anim:Enable(true)
  self.compLight1:SetActive(true)
  self.compLight2:SetActive(true)
  self.compLight3:SetActive(true)
  self.compLight4:SetActive(true)
  self.compLight5:SetActive(true)
  self.keys = {
    self.compKey1,
    self.compKey2,
    self.compKey3,
    self.compKey4,
    self.compKey5
  }
  self.lights = {
    self.compLight1,
    self.compLight2,
    self.compLight3,
    self.compLight4,
    self.compLight5
  }
  self.keyAnims = {
    self.compKey1Anim,
    self.compKey2Anim,
    self.compKey3Anim,
    self.compKey4Anim,
    self.compKey5Anim
  }
  self.keysBlack:SetActive(false)
  local time = 0
  self.maskLastClick = time
  self.boxIconLid = self:AddComponent(UIBaseContainer, "boxIcon_Lid")
  self.boxIconLid:SetActive(false)
end

function RevivalPlanMainBoxComponent:ComponentDestroy()
  self.rawImgBoxIcon = nil
  self.compKey1 = nil
  self.compKey2 = nil
  self.compKey3 = nil
  self.compKey4 = nil
  self.compKey5 = nil
  self.compLight1 = nil
  self.compLight2 = nil
  self.compLight3 = nil
  self.compLight4 = nil
  self.compLight5 = nil
  self.textKeyword = nil
  self.compKey1Anim = nil
  self.compKey2Anim = nil
  self.compKey3Anim = nil
  self.compKey4Anim = nil
  self.compKey5Anim = nil
  self.keys = nil
  self.lights = nil
  self.keyAnims = nil
  self.btnBox = nil
  self.keywordEffect = nil
end

function RevivalPlanMainBoxComponent:DataDefine()
end

function RevivalPlanMainBoxComponent:DataDestroy()
  self.activityInfoData = nil
  self:ClearKeyBlackTimer()
  self:ClearKeySequence()
  self:ClearKeywordEffectTimer()
end

function RevivalPlanMainBoxComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnRevivalPlanBoxOpen, self.OnRevivalPlanBoxOpen)
end

function RevivalPlanMainBoxComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.OnRevivalPlanBoxOpen, self.OnRevivalPlanBoxOpen)
  base.OnRemoveListener(self)
end

function RevivalPlanMainBoxComponent:SetData(activityInfoData)
  self.activityInfoData = activityInfoData
  self:RefreshData()
end

function RevivalPlanMainBoxComponent:RefreshData()
  self:RefreshBox()
  local keyCount = #self.keys
  if self.isOpen then
    for i = 1, keyCount do
      self.keyAnims[i]:Enable(false)
      self.keys[i]:SetActive(true)
      local picPath = lightPicPath
      self.lights[i]:LoadSprite(picPath)
    end
    self.anim:Rewind("Default")
    self.anim:Stop()
    return
  end
  local has = 0
  local require = 0
  local keyId = DataCenter.RevivalPlanManager:GetActivityKeyId(self.activityInfoData)
  if 0 < keyId then
    has = DataCenter.ItemData:GetItemCount(keyId)
  end
  self.has = has
  local enough = keyCount <= has
  self.enough = enough
  for i = 1, keyCount do
    local ready = i <= has
    self.keys[i]:SetActive(ready)
    self.keyAnims[i]:Enable(false)
    local picPath = ready and lightPicPath or darkPicPath
    self.lights[i]:LoadSprite(picPath)
  end
  self.textKeyword:SetText(DataCenter.RevivalPlanManager:GetRandomNumberShow(self.activityInfoData.activityId, has))
  require = keyCount - has
  require = Mathf.Max(0, require)
  self.require = require
  if self.enough then
    self.anim:Play("Default")
    self.boxIconLid:SetActive(true)
    self.boxEffectBg:SetActive(true)
    self.boxEffectFg:SetActive(true)
  else
    self.boxIconLid:SetActive(true)
    self.boxEffectBg:SetActive(false)
    self.boxEffectFg:SetActive(false)
  end
end

function RevivalPlanMainBoxComponent:RefreshBox()
  local isOpen = DataCenter.RevivalPlanManager:GetBoxOpened(self.activityInfoData.activityId)
  if isOpen then
    self.rawImgBoxIcon:LoadSprite("Assets/Main/TextureEx/UILWRevivalPlan/FX_fuxingjihua_baoxiang2.png")
    self.keywordBg:SetActive(false)
    self.rawImgBoxIcon:SetNativeSize()
    self:ClearKeyBlackTimer()
    self.boxIconLid:SetActive(false)
    self.boxEffectBg:SetActive(false)
    self.boxEffectFg:SetActive(false)
  else
    self.rawImgBoxIcon:LoadSprite("Assets/Main/TextureEx/UILWRevivalPlan/FX_fuxingjihua_baoxiang.png")
    self.keywordBg:SetActive(true)
    self.rawImgBoxIcon:SetNativeSize()
    self:AddKeywordEffectTimer()
  end
  self.isOpen = isOpen
end

function RevivalPlanMainBoxComponent:OnRevivalPlanBoxOpen()
  self:RefreshData()
end

function RevivalPlanMainBoxComponent:OnBtnBoxClick()
  if self.isOpen then
    return
  end
  if self.keysBlack:GetActive() then
    return
  end
  if self.enough then
    DataCenter.RevivalPlanManager:OpenBox()
    return
  end
  EventManager:GetInstance():Broadcast(EventId.RevivalPlanBoxPreview, self.require)
end

function RevivalPlanMainBoxComponent:ShowChangeKeys(changeKeys)
  if self.isOpen then
    return
  end
  if not self.has then
    return
  end
  local start = self.has - changeKeys + 1
  local keyCount = #self.keys
  if start < 1 or start > keyCount or start > self.has then
    return
  end
  self:ClearKeyBlackTimer()
  self:ClearKeySequence()
  self.anim:Rewind("Default")
  self.anim:Stop()
  self.boxEffectBg:SetActive(false)
  self.boxEffectFg:SetActive(false)
  self.keysBlack:SetActive(true)
  if 1 < changeKeys then
    for i = start, self.has do
      self.keys[i]:SetActive(false)
      self.lights[i]:LoadSprite(darkPicPath)
    end
    self.textKeyword:SetText(DataCenter.RevivalPlanManager:GetRandomNumberShow(self.activityInfoData.activityId, start - 1))
    self.keySequence = CS.DG.Tweening.DOTween.Sequence()
    self.keySequence:AppendInterval(0.1)
    for i = start, self.has do
      self.keySequence:AppendCallback(function()
        if self.keys then
          self.textKeyword:SetText(DataCenter.RevivalPlanManager:GetRandomNumberShow(self.activityInfoData.activityId, i - 1))
          self.keys[i]:SetActive(true)
          self.keyAnims[i]:Enable(true)
          self.keyAnims[i]:Rewind("Default")
          self.keyAnims[i]:Play("Default")
          local light = self.lights[i - 1]
          if light then
            light:LoadSprite(lightPicPath)
          end
        end
      end)
      self.keySequence:AppendInterval(keyAnimLength)
    end
    self.keySequence:AppendCallback(function()
      if self.textKeyword then
        self.textKeyword:SetText(DataCenter.RevivalPlanManager:GetRandomNumberShow(self.activityInfoData.activityId, self.has))
        self.lights[self.has]:LoadSprite(lightPicPath)
      end
      if self.keysBlack then
        self.keysBlack:SetActive(false)
      end
      self.keySequence = nil
      self:RefreshData()
    end)
  else
    local length = keyAnimLength * changeKeys
    for i = start, self.has do
      self.keyAnims[i]:Enable(true)
      self.keyAnims[i]:Rewind("Default")
      self.keyAnims[i]:Play("Default")
      self.lights[i]:LoadSprite(darkPicPath)
    end
    self.textKeyword:SetText(DataCenter.RevivalPlanManager:GetRandomNumberShow(self.activityInfoData.activityId, self.has - 1))
    self.keyBlackTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.textKeyword then
        self.textKeyword:SetText(DataCenter.RevivalPlanManager:GetRandomNumberShow(self.activityInfoData.activityId, self.has))
        self.lights[self.has]:LoadSprite(lightPicPath)
      end
      if self.keysBlack then
        self.keysBlack:SetActive(false)
      end
      self.keyBlackTimer = nil
      self:RefreshData()
    end, length)
  end
end

function RevivalPlanMainBoxComponent:ClearKeyBlackTimer()
  if self.keyBlackTimer then
    self.keyBlackTimer:Stop()
    self.keyBlackTimer = nil
  end
end

function RevivalPlanMainBoxComponent:ClearKeySequence()
  if self.keySequence then
    self.keySequence:Kill()
    self.keySequence = nil
  end
end

function RevivalPlanMainBoxComponent:OnMaskClick()
  local time = Time.realtimeSinceStartup
  if time - self.maskLastClick < 0.5 then
    self.keysBlack:SetActive(false)
    self:ClearKeySequence()
    self:ClearKeyBlackTimer()
    self:RefreshData()
  end
  self.maskLastClick = time
end

function RevivalPlanMainBoxComponent:GetArrowPos()
  return self.keywordBg:GetPosition()
end

function RevivalPlanMainBoxComponent:AddKeywordEffectTimer()
  if self.keywordEffectTimer == nil then
    self.keywordEffectTimer = TimerManager:GetInstance():GetTimer(10, self.ShowKeywordEffect, self, false, false, false)
    self.keywordEffectTimer:Start()
  end
end

function RevivalPlanMainBoxComponent:ShowKeywordEffect()
  if self.keywordEffect then
    self.keywordEffect:SetActive(false)
    self.keywordEffect:SetActive(true)
  end
end

function RevivalPlanMainBoxComponent:ClearKeywordEffectTimer()
  if self.keywordEffectTimer then
    self.keywordEffectTimer:Stop()
    self.keywordEffectTimer = nil
  end
  if self.keywordEffect then
    self.keywordEffect:SetActive(false)
  end
end

return RevivalPlanMainBoxComponent
