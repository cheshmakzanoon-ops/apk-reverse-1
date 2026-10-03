local LWUIActMeteoriteAwardItemRenderer = BaseClass("LWUIActMeteoriteAwardItemRenderer", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local model = {
  false,
  false,
  true,
  true
}
local key = {
  {
    "yuntieBattle_interface_1026"
  },
  {
    "yuntieBattle_interface_1027"
  },
  {
    "yuntieBattle_interface_1028",
    "yuntieBattle_interface_1028"
  },
  {
    "yuntieBattle_interface_1029",
    "yuntieBattle_interface_1029"
  }
}
local picPath = {
  {
    "Assets/Main/TextureEx/LWActMeteorite/part2/zxl_yunshi_renwu1.png"
  },
  {
    "Assets/Main/TextureEx/LWActMeteorite/part2/zxl_yunshi_renwu2.png"
  },
  {
    "Assets/Main/TextureEx/LWActMeteorite/part2/zxl_yunshi_renwu3.png",
    "Assets/Main/TextureEx/LWActMeteorite/part2/zxl_yunshi_renwu5.png"
  },
  {
    "Assets/Main/TextureEx/LWActMeteorite/part2/zxl_yunshi_renwu4.png",
    "Assets/Main/TextureEx/LWActMeteorite/part2/zxl_yunshi_renwu6.png"
  }
}
local scaleX = {
  {1},
  {1},
  {1, 1},
  {1, 1}
}
local specialIconPath = {
  {},
  {},
  {
    "Assets/Main/Sprites/UI/LWActMeteorite/mjc_zhouliuhuodong_jifenqiehuan_caiji.png",
    "Assets/Main/Sprites/UI/LWActMeteorite/mjc_zhouliuhuodong_jifenqiehuan_yunshu.png"
  },
  {
    "Assets/Main/Sprites/UI/LWActMeteorite/mjc_zhouliuhuodong_jifenqiehuan_caiji.png",
    "Assets/Main/Sprites/UI/LWActMeteorite/mjc_zhouliuhuodong_jifenqiehuan_yunshu.png"
  }
}

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
  self.btnLWUIActMeteoriteAwardItemRenderer = self:AddComponent(UIButton, "")
  self.btnLWUIActMeteoriteAwardItemRenderer:SetOnClick(function()
    self:OnBtnLWUIActMeteoriteAwardItemRendererClick()
  end)
  self.rawImgIcon = self:AddComponent(UIRawImage, "Icon")
  self.btnJump = self:AddComponent(UIButton, "Btn")
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.textBtn = self:AddComponent(UITextMeshProUGUIEx, "Btn/BtnText")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "ModelNode/SBg/NumText")
  self.btnTitle = self:AddComponent(UIButton, "ModelNode/SBg")
  self.btnTitle:SetOnClick(function()
    self:OnBtnTitleClick()
  end)
  self.compTip = self:AddComponent(UIBaseComponent, "ModelNode/SBg/Tip")
  self.compModelNode = self:AddComponent(UIBaseComponent, "ModelNode")
  self.imgModeIcon = self:AddComponent(UIImage, "ModelNode/ModeIcon")
  self.compEffNode = self:AddComponent(UIBaseComponent, "EffNode")
  self.animator = self:AddComponent(UIAnimator, "")
  self.mode = 1
  self.compEffNode:SetActive(false)
  self.effParticle = self.compEffNode.gameObject:GetComponent(TypeOfParticleSystem)
  self.effParticle:Stop()
  self.specialBg = self.compModelNode.transform:Find("ModelBg").gameObject
end

local function ComponentDestroy(self)
  self:ClearAnim()
  self.btnLWUIActMeteoriteAwardItemRenderer = nil
  self.rawImgIcon = nil
  self.btnJump = nil
  self.textBtn = nil
  self.textNum = nil
  self.btnTitle = nil
  self.compTip = nil
  self.compModelNode = nil
  self.imgModeIcon = nil
  self.compEffNode = nil
  self.animator = nil
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

local function OnBtnLWUIActMeteoriteAwardItemRendererClick(self)
  if self.isFlipping then
    return
  end
  if self:NeedGuide() then
    self:PlayGuide()
    return
  end
  if model[self.index] then
    self.mode = self.mode == 1 and 2 or 1
    self:PlayEffect()
    self:RefreshMode()
  end
end

local function OnBtnJumpClick(self)
  if self.hostView then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.hostView:JumpTo(self.index)
  end
end

local function OnBtnTitleClick(self)
  if self.hostView then
    self:ShowJumpTip(self.compTip, self.index)
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
end

function LWUIActMeteoriteAwardItemRenderer:Setup(args)
  self.index = args.index
  self.hostView = args.view
  self:RefreshMode()
  self:ClearAnim()
end

function LWUIActMeteoriteAwardItemRenderer:RefreshMode()
  local btnKey = key[self.index] and key[self.index][self.mode] or ""
  local pic = picPath[self.index] and picPath[self.index][self.mode] or ""
  local specialIcon = specialIconPath[self.index] and specialIconPath[self.index][self.mode] or ""
  self.textBtn:SetLocalText(btnKey)
  self.rawImgIcon:LoadSpriteAuto(pic)
  if string.IsNullOrEmpty(specialIcon) then
    self.specialBg:SetActive(false)
    self.imgModeIcon:SetActive(false)
  else
    self.specialBg:SetActive(true)
    self.imgModeIcon:SetActive(true)
    self.imgModeIcon:LoadSpriteAuto(specialIcon)
  end
  self.textNum:SetText(string.format("%s/s", self:GetExtraCount()))
end

function LWUIActMeteoriteAwardItemRenderer:GetExtraCount()
  if self.index == 1 then
    return LuaEntry.DataConfig:TryGetNum("yunshi_para", "k11", 0)
  else
    local configLineData = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(98 + self.index)
    if configLineData == nil then
      return 0
    else
      return configLineData:getIntValue(self.mode == 1 and "point_produce_per_second" or "point_produce_per_second_on_base") or 0
    end
  end
end

function LWUIActMeteoriteAwardItemRenderer:ShowJumpTip(item, idx)
  local tmpIdx, extra1, extra2, extra3
  if idx == 1 then
    tmpIdx = 4
    extra1 = LuaEntry.DataConfig:TryGetNum("yunshi_para", "k11", 0)
  else
    tmpIdx = idx - 1
    local configLineData = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(99 + tmpIdx)
    extra1 = configLineData ~= nil and configLineData:getIntValue("point_produce_per_second") or 0
    extra2 = configLineData ~= nil and configLineData:getIntValue("point_last") or 0
    if tmpIdx ~= 1 then
      extra3 = configLineData ~= nil and configLineData:getIntValue("point_produce_per_second_on_base") or 0
    end
  end
  local strTip = "<b><size=30>" .. Localization:GetString("yuntieBattle_entity_name_100" .. tmpIdx) .. "</size></b>\n" .. Localization:GetString("yuntieBattle_entity_desc_100" .. tmpIdx, extra1, extra2, extra3)
  UIUtil.ShowBubbleTips(strTip, item.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

function LWUIActMeteoriteAwardItemRenderer:DoFlip()
end

function LWUIActMeteoriteAwardItemRenderer:ClearAnim()
  if not self.rawImgIcon then
    return
  end
  DOTween.Kill(self.rawImgIcon.transform)
  self.rawImgIcon.localRotation = Quaternion.Euler(0, 0, 0)
  self.isFlipping = false
end

function LWUIActMeteoriteAwardItemRenderer:GetGuideKey()
  return string.format("%s_%s", SettingKeys.METEORITE_AWARD_ITEM_GUIDE, self.index)
end

function LWUIActMeteoriteAwardItemRenderer:NeedGuide()
  if not model[self.index] then
    return false
  end
  local check = CommonUtil.PlayerPrefsGetBool(self:GetGuideKey(), false)
  return not check
end

function LWUIActMeteoriteAwardItemRenderer:PlayEffect()
  self.compEffNode:SetActive(true)
  self.effParticle:Stop()
  self.effParticle:Play()
end

function LWUIActMeteoriteAwardItemRenderer:PlayGuide()
  if self.isFlipping then
    return
  end
  CommonUtil.PlayerPrefsSetBool(self:GetGuideKey(), true)
  self.isFlipping = true
  local seq = DOTween.Sequence()
  seq:AppendCallback(function()
    UIUtil.ShowBubbleTips(Localization:GetString("yuntieBattle_tips_1037"), self.rawImgIcon.transform.position, 0, 50, 0, nil, nil, {reversal = true})
  end)
  seq:AppendInterval(1.5)
  seq:AppendCallback(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonTips)
    self.animator:Play("Change")
  end)
  seq:AppendInterval(1.25)
  seq:AppendCallback(function()
    self:PlayEffect()
    self.mode = self.mode == 1 and 2 or 1
    self:RefreshMode()
  end)
  seq:AppendCallback(function()
    self.isFlipping = false
  end)
end

LWUIActMeteoriteAwardItemRenderer.OnCreate = OnCreate
LWUIActMeteoriteAwardItemRenderer.OnDestroy = OnDestroy
LWUIActMeteoriteAwardItemRenderer.OnEnable = OnEnable
LWUIActMeteoriteAwardItemRenderer.OnDisable = OnDisable
LWUIActMeteoriteAwardItemRenderer.ComponentDefine = ComponentDefine
LWUIActMeteoriteAwardItemRenderer.ComponentDestroy = ComponentDestroy
LWUIActMeteoriteAwardItemRenderer.DataDefine = DataDefine
LWUIActMeteoriteAwardItemRenderer.DataDestroy = DataDestroy
LWUIActMeteoriteAwardItemRenderer.OnAddListener = OnAddListener
LWUIActMeteoriteAwardItemRenderer.OnRemoveListener = OnRemoveListener
LWUIActMeteoriteAwardItemRenderer.OnBtnLWUIActMeteoriteAwardItemRendererClick = OnBtnLWUIActMeteoriteAwardItemRendererClick
LWUIActMeteoriteAwardItemRenderer.OnBtnJumpClick = OnBtnJumpClick
LWUIActMeteoriteAwardItemRenderer.OnBtnTitleClick = OnBtnTitleClick
return LWUIActMeteoriteAwardItemRenderer
