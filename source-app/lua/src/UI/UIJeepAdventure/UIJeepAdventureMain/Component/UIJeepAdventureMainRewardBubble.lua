local UIJeepAdventureMainRewardBubble = BaseClass("UIJeepAdventureMainRewardBubble", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.imgBg = self:AddComponent(UIImage, "")
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.textNum = self:AddComponent(UIText, "NumText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
end

local function ComponentDestroy(self)
  self.imgBg = nil
  self.imgIcon = nil
  self.textNum = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, pageType, num, canGet, cfg)
  self.pageType = pageType
  self.canGet = canGet
  self.cfg = cfg
  if 1 < num then
    self.textNum:SetActive(true)
    self.textNum:SetText(num)
  else
    self.textNum:SetActive(false)
  end
  if canGet then
    self.imgBg:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, "lrb_guaji_shoushajiangli_qipao_kelingqu"))
    self:PlayPointsIconSequence()
  else
    self.imgBg:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, "lrb_guaji_shoushajiangli_qipao_bukelingqu"))
    self:StopPointsIconSequence()
  end
end

local function OnClickBtn(self)
  if self.canGet then
    self.view.ctrl:SendGetFirstReward(self.pageType, -1)
  else
    local showRewardList = self.cfg:GetStageRewardShowData()
    if showRewardList then
      local param = {}
      param.width = 445
      param.alignObject = self.transform
      param.yPosFix = 40
      param.showArrow = true
      param.showRewardList = showRewardList
      param.tipsText = Localization:GetString("zone_mobilization_stage_reward_title")
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardPreviewTip, {anim = true}, param)
    end
  end
end

local function PlayPointsIconSequence(self)
  self:StopPointsIconSequence()
  self.imgIcon.transform.localRotation = Quaternion.identity
  self.pointsIconSequence = CS.DG.Tweening.DOTween.Sequence()
  self.pointsIconSequence:Append(self.imgIcon.transform:DOLocalRotate(Vector3.New(0, 0, -30), 0.1))
  self.pointsIconSequence:Append(self.imgIcon.transform:DOLocalRotate(Vector3.New(0, 0, 30), 0.1))
  self.pointsIconSequence:Append(self.imgIcon.transform:DOLocalRotate(Vector3.New(0, 0, -10), 0.1))
  self.pointsIconSequence:Append(self.imgIcon.transform:DOLocalRotate(Vector3.New(0, 0, 10), 0.1))
  self.pointsIconSequence:Append(self.imgIcon.transform:DOLocalRotate(Vector3.New(0, 0, 0), 0.1))
  self.pointsIconSequence:AppendInterval(2)
  self.pointsIconSequence:SetLoops(-1)
end

local function StopPointsIconSequence(self)
  if self.pointsIconSequence then
    self.pointsIconSequence:Kill()
    self.pointsIconSequence = nil
  end
end

UIJeepAdventureMainRewardBubble.OnCreate = OnCreate
UIJeepAdventureMainRewardBubble.OnDestroy = OnDestroy
UIJeepAdventureMainRewardBubble.OnEnable = OnEnable
UIJeepAdventureMainRewardBubble.OnDisable = OnDisable
UIJeepAdventureMainRewardBubble.ComponentDefine = ComponentDefine
UIJeepAdventureMainRewardBubble.ComponentDestroy = ComponentDestroy
UIJeepAdventureMainRewardBubble.DataDefine = DataDefine
UIJeepAdventureMainRewardBubble.DataDestroy = DataDestroy
UIJeepAdventureMainRewardBubble.OnAddListener = OnAddListener
UIJeepAdventureMainRewardBubble.OnRemoveListener = OnRemoveListener
UIJeepAdventureMainRewardBubble.SetData = SetData
UIJeepAdventureMainRewardBubble.OnClickBtn = OnClickBtn
UIJeepAdventureMainRewardBubble.PlayPointsIconSequence = PlayPointsIconSequence
UIJeepAdventureMainRewardBubble.StopPointsIconSequence = StopPointsIconSequence
return UIJeepAdventureMainRewardBubble
