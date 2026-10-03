local UIGetDuelScoreTipScoreItem = BaseClass("UIGetDuelScoreTipScoreItem", UIBaseContainer)
local base = UIBaseContainer
local icon_img_path = "IconImg"
local num_text_path = "NumText"
local animtor_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.iconImg = self:AddComponent(UIImage, icon_img_path)
  self.numText = self:AddComponent(UIText, num_text_path)
  self.anim = self:AddComponent(UIAnimator, animtor_path)
end

local function ComponentDestroy(self)
  self.iconImg = nil
  self.numText = nil
  self.anim = nil
end

local function DataDefine(self)
  self.isReach = false
end

local function DataDestroy(self)
  self.isReach = nil
  self.num = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetData(self, num, fullNum, scoreType)
  self.num = num
  self.numText:SetText(string.GetFormattedSeperatorNum(num))
  if num <= fullNum then
    self.numText:SetColorRGBA255(155, 255, 125, 255)
    self.isReach = true
  else
    self.numText:SetColorRGBA255(255, 255, 255, 255)
    self.isReach = false
  end
  self.anim:ResetTrigger()
  if scoreType then
    if scoreType == GetDuelScoreType.Person then
      self.iconImg:LoadSprite("Assets/Main/Sprites/UI/UIPersonalArms/zyf_huodong_gerenjunbei_tubiao_bi.png")
    elseif scoreType == GetDuelScoreType.Ally then
      self.iconImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UIactivities_icon_coin.png")
    end
  end
end

local function CheckShowReachAnim(self, fullNum)
  if not self.isReach and fullNum >= self.num then
    self.anim:SetTrigger("Reward")
    self.numText:SetColorRGBA255(155, 255, 125, 255)
    self.isReach = true
  end
end

UIGetDuelScoreTipScoreItem.OnCreate = OnCreate
UIGetDuelScoreTipScoreItem.OnDestroy = OnDestroy
UIGetDuelScoreTipScoreItem.OnEnable = OnEnable
UIGetDuelScoreTipScoreItem.OnDisable = OnDisable
UIGetDuelScoreTipScoreItem.ComponentDefine = ComponentDefine
UIGetDuelScoreTipScoreItem.ComponentDestroy = ComponentDestroy
UIGetDuelScoreTipScoreItem.DataDefine = DataDefine
UIGetDuelScoreTipScoreItem.DataDestroy = DataDestroy
UIGetDuelScoreTipScoreItem.OnAddListener = OnAddListener
UIGetDuelScoreTipScoreItem.OnRemoveListener = OnRemoveListener
UIGetDuelScoreTipScoreItem.OnRemoveListener = OnRemoveListener
UIGetDuelScoreTipScoreItem.SetData = SetData
UIGetDuelScoreTipScoreItem.CheckShowReachAnim = CheckShowReachAnim
return UIGetDuelScoreTipScoreItem
