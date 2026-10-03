local UIRecruitLotteryTip = BaseClass("UIRecruitLotteryTip", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.sliderGreen = self:AddComponent(UISlider, "Root/SliderGreen")
  self.sliderYellow = self:AddComponent(UISlider, "Root/SliderYellow")
  self.textName = self:AddComponent(UIText, "Root/TextName")
  self.textNum = self:AddComponent(UIText, "Root/TextNum")
  self.imgItemIcon = self:AddComponent(UIImage, "Root/ImageItem")
  self.imgIcon1 = self:AddComponent(UIImage, "Root/ImageIcon1")
  self.imgIcon2 = self:AddComponent(UIImage, "Root/ImageIcon2")
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.animator = self:AddComponent(UIAnimator, "")
  local itemId = DataCenter.LotteryDataManager.needTipItemId
  local nameStr = DataCenter.ItemTemplateManager:GetName(itemId)
  self.textName:SetText(nameStr)
  self.imgItemIcon:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(itemId).icon))
  self.heroDebris = self:AddComponent(UIBaseContainer, "Root/HeroDebris")
  self.heroDebris:SetActive(false)
end

local function ComponentDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.animator:Enable(true)
  local rootRt = self.root.transform
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(1, 1, 1)
  local param, total, last, threshold, reached
  local para1, add, itemId = self:GetUserData()
  if type(para1) == "table" then
    param = para1
    total = param.total
    add = param.add
    last = param.total - param.add
    threshold = param.threshold
    reached = last >= threshold
    self.textName:SetText(param.name)
    self.imgItemIcon:SetActive(true)
    self.imgItemIcon:LoadSprite(param.icon)
  else
    total = para1
    if itemId == nil then
      itemId = DataCenter.LotteryDataManager.needTipItemId
    end
    local nameStr = DataCenter.ItemTemplateManager:GetName(itemId)
    self.textName:SetText(nameStr)
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    self.imgItemIcon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    last = total - add
    threshold = DataCenter.LotteryDataManager:GetNeedTipItemMaxNum(itemId)
    reached = 1 <= last / threshold
  end
  self.sliderGreen:SetActive(not reached)
  self.sliderYellow:SetActive(reached)
  self.imgIcon1:SetActive(false)
  self.imgIcon2:SetActive(reached)
  self.textNum:SetText(last .. "/" .. threshold)
  self.sliderGreen:SetValue(last / threshold)
  local ret, time = self.animator:GetAnimationReturnTime("UIRecruitLotteryTip_show")
  local showTime = (ret and time or 0) + 0.2
  print("showTime:" .. showTime)
  local from = last / threshold
  local to = total / threshold
  
  local function OnProAniEnd()
    self.textNum:SetText(total .. "/" .. threshold)
    local bFull = 1 <= total / threshold
    if bFull then
      self.sliderGreen:SetActive(false)
      self.sliderYellow:SetActive(true)
      self.imgIcon1:SetActive(false)
      self.imgIcon2:SetActive(true)
      self.animator:SetTrigger("change")
    end
    local changeTime = bFull and 1.6 or 0.5
    print("changeTime:" .. changeTime)
    TimerManager:GetInstance():DelayInvoke(function()
      self.animator:Enable(false)
      DOTween.Kill(rootRt)
      rootRt:Set_localScale(1, 1, 1)
      rootRt:DOScale(Vector3.New(1.2, 1.2, 1.2), 0.15):OnComplete(function()
        rootRt:DOScale(Vector3.zero, 0.25):OnComplete(function()
          self.ctrl:CloseSelf()
        end)
      end)
    end, changeTime)
  end
  
  local function OnProGet()
    return from
  end
  
  local function OnProSet(x)
    self.sliderGreen:SetValue(math.min(1, x))
    local t = Mathf.InverseLerp(from, to, x)
    local num = math.floor(last + add * t)
    self.textNum:SetText(num .. "/" .. threshold)
  end
  
  DOTween.To(OnProGet, OnProSet, to, 0.6):OnComplete(OnProAniEnd):SetDelay(showTime)
end

UIRecruitLotteryTip.OnCreate = OnCreate
UIRecruitLotteryTip.OnDestroy = OnDestroy
UIRecruitLotteryTip.OnEnable = OnEnable
UIRecruitLotteryTip.ComponentDefine = ComponentDefine
UIRecruitLotteryTip.ComponentDestroy = ComponentDestroy
return UIRecruitLotteryTip
