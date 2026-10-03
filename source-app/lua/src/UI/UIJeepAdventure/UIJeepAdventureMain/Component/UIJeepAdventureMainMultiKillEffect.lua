local UIJeepAdventureMainMultiKillEffect = BaseClass("UIJeepAdventureMainMultiKillEffect", UIBaseContainer)
local base = UIBaseContainer
local kill_icon_path = "MultiKill/KillIcon"
local kill_icon_zidan1_path = "MultiKill/KillIcon_zidan (1)"
local kill_icon_zidan2_path = "MultiKill/KillIcon_zidan (2)"
local kill_icon_zidan3_path = "MultiKill/KillIcon_zidan (3)"
local numRoot_path = "MultiKill/NumRoot"
local num1_path = "MultiKill/NumRoot/Num1"
local plus1_path = "MultiKill/NumRoot/Plus1"
local NUMBER_PATH = {
  [0] = "Assets/Main/Sprites/UI/UIMultiKill/number_0.png",
  [1] = "Assets/Main/Sprites/UI/UIMultiKill/number_1.png",
  [2] = "Assets/Main/Sprites/UI/UIMultiKill/number_2.png",
  [3] = "Assets/Main/Sprites/UI/UIMultiKill/number_3.png",
  [4] = "Assets/Main/Sprites/UI/UIMultiKill/number_4.png",
  [5] = "Assets/Main/Sprites/UI/UIMultiKill/number_5.png",
  [6] = "Assets/Main/Sprites/UI/UIMultiKill/number_6.png",
  [7] = "Assets/Main/Sprites/UI/UIMultiKill/number_7.png",
  [8] = "Assets/Main/Sprites/UI/UIMultiKill/number_8.png",
  [9] = "Assets/Main/Sprites/UI/UIMultiKill/number_9.png"
}

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
  self.kill_icon = self:AddComponent(UIImage, kill_icon_path)
  self.kill_icon_zidan1 = self:AddComponent(UIImage, kill_icon_zidan1_path)
  self.kill_icon_zidan2 = self:AddComponent(UIImage, kill_icon_zidan2_path)
  self.kill_icon_zidan3 = self:AddComponent(UIImage, kill_icon_zidan3_path)
  self.num1 = self:AddComponent(UIImage, num1_path)
  self.plus1 = self:AddComponent(UIImage, plus1_path)
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.numRoot = self:AddComponent(UIBaseContainer, numRoot_path)
  self.plus1:SetActive(false)
  self.numImgs = {}
  table.insert(self.numImgs, self.num1)
  self.numItem = self.num1.gameObject
  self.numItem:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.numImgs = nil
  self.numRoot:RemoveComponents(UIImage)
  self.numItem:GameObjectRecycleAll()
  self.numItem = nil
  self.kill_icon = nil
  self.kill_icon_zidan1 = nil
  self.kill_icon_zidan2 = nil
  self.kill_icon_zidan3 = nil
  self.num1 = nil
  self.plus1 = nil
  self.anim = nil
  self.numRoot = nil
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

local function DataDefine(self)
  self.bigScale = Vector3.one * 1.5
end

local function DataDestroy(self)
  self.maxNum = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetData(self, maxNum)
  self.maxNum = maxNum
  self.overMaxNum = false
end

local function Refresh(self, num)
  if num <= 0 then
    self:SetActive(false)
  else
    self:SetActive(true)
    if self.maxNum == nil then
      self.maxNum = 99
    end
    local needRefresh = true
    if num > self.maxNum then
      num = self.maxNum
      self.plus1:SetActive(true)
      if self.overMaxNum then
        needRefresh = false
      else
        self.overMaxNum = true
      end
    else
      self.plus1:SetActive(false)
    end
    if needRefresh then
      local numStr = tostring(num)
      for index = 1, #numStr do
        local digit = tonumber(numStr:sub(index, index))
        local numImg = self.numImgs[index]
        if numImg == nil then
          numImg = self.numItem:GameObjectSpawn(self.numRoot.transform)
          numImg.name = "Num" .. index
          numImg = self.numRoot:AddComponent(UIImage, numImg.name)
          table.insert(self.numImgs, numImg)
        end
        numImg:LoadSprite(NUMBER_PATH[digit])
      end
      if #numStr < #self.numImgs then
        for i = #numStr, #self.numImgs do
          self.numImgs[i]:SetActive(false)
        end
      end
      local transform = self.numRoot.transform
      if self.sequence then
        self.sequence:Kill()
      end
      self.sequence = CS.DG.Tweening.DOTween.Sequence()
      if self.sequence then
        self.sequence:Append(transform:DOScale(self.bigScale, 0.2):SetEase(CS.DG.Tweening.Ease.InQuad))
        self.sequence:Append(transform:DOScale(Vector3.one, 0.2):SetEase(CS.DG.Tweening.Ease.InQuad))
      end
    end
  end
end

UIJeepAdventureMainMultiKillEffect.OnCreate = OnCreate
UIJeepAdventureMainMultiKillEffect.OnDestroy = OnDestroy
UIJeepAdventureMainMultiKillEffect.OnEnable = OnEnable
UIJeepAdventureMainMultiKillEffect.OnDisable = OnDisable
UIJeepAdventureMainMultiKillEffect.ComponentDefine = ComponentDefine
UIJeepAdventureMainMultiKillEffect.ComponentDestroy = ComponentDestroy
UIJeepAdventureMainMultiKillEffect.DataDefine = DataDefine
UIJeepAdventureMainMultiKillEffect.DataDestroy = DataDestroy
UIJeepAdventureMainMultiKillEffect.OnAddListener = OnAddListener
UIJeepAdventureMainMultiKillEffect.OnRemoveListener = OnRemoveListener
UIJeepAdventureMainMultiKillEffect.SetData = SetData
UIJeepAdventureMainMultiKillEffect.Refresh = Refresh
return UIJeepAdventureMainMultiKillEffect
