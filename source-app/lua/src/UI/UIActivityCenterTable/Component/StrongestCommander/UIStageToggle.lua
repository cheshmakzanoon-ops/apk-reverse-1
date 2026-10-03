local UIStageToggle = BaseClass("UIStageToggle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnClickSelf(self)
  if not self.selected and self.callBack then
    self.callBack(self.index)
  end
end

local function ComponentDefine(self)
  self.img = self:AddComponent(UIImage, "")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    OnClickSelf(self)
  end)
  self.stageText = self:AddComponent(UIText, "StageText")
end

local function ComponentDestroy(self)
  self.img = nil
  self.btn = nil
end

local function DataDefine(self)
  self.callBack = nil
end

local function DataDestroy(self)
  self.index = nil
  self.unlocked = nil
  self.selected = nil
  self.callBack = nil
end

local function SetIndex(self, index)
  self.index = index
end

local function SetCallBack(self, callBack)
  self.callBack = callBack
end

local function SetSelected(self, selected, unlocked)
  self.selected = selected
  self.unlocked = unlocked
  if not self.unlocked then
    if self.selected then
      if self.index < 7 then
        self.img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_jieduan_3.png")
      else
        self.img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_jieduan_5.png")
      end
      self.stageText:SetColorRGBA(1, 1, 1, 1)
    else
      if self.index < 7 then
        self.img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_jieduan_1.png")
      else
        self.img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_jieduan_4.png")
      end
      self.stageText:SetColorRGBA(0.67, 0.66, 0.67, 1)
    end
  else
    if self.selected then
      if self.index < 7 then
        self.img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_jieduan_3.png")
      else
        self.img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_jieduan_5.png")
      end
    elseif self.index < 7 then
      self.img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_jieduan_2.png")
    else
      self.img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_jieduan_6.png")
    end
    self.stageText:SetColorRGBA(1, 1, 1, 1)
  end
end

UIStageToggle.OnCreate = OnCreate
UIStageToggle.OnDestroy = OnDestroy
UIStageToggle.ComponentDefine = ComponentDefine
UIStageToggle.ComponentDestroy = ComponentDestroy
UIStageToggle.DataDefine = DataDefine
UIStageToggle.DataDestroy = DataDestroy
UIStageToggle.SetIndex = SetIndex
UIStageToggle.SetSelected = SetSelected
UIStageToggle.SetCallBack = SetCallBack
return UIStageToggle
