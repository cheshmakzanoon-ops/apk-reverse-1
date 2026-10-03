local MultiKillEff = BaseClass("MultiKillEff", UIBaseContainer)
local base = UIBaseContainer
local kill_icon_path = "MultiKill/KillIcon"
local kill_icon_zidan1_path = "MultiKill/KillIcon_zidan (1)"
local kill_icon_zidan2_path = "MultiKill/KillIcon_zidan (2)"
local kill_icon_zidan3_path = "MultiKill/KillIcon_zidan (3)"
local num1_path = "MultiKill/Num1"
local num2_path = "MultiKill/Num2"
local num3_path = "MultiKill/Num3"
local num4_path = "MultiKill/Num4"
local plus1_path = "MultiKill/Plus1"
local plus2_path = "MultiKill/Plus2"
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
local PVE_PATH = {
  [0] = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon1.png",
  [1] = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon2_1.png",
  [2] = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon2_2.png",
  [3] = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon2_3.png"
}
local PVP_PATH = {
  [0] = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon3.png",
  [1] = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon4_1.png",
  [2] = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon4_2.png",
  [3] = "Assets/Main/Sprites/UI/UIMultiKill/mjc_liansheng_icon4_3.png"
}

function MultiKillEff:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MultiKillEff:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function MultiKillEff:ComponentDefine()
  self.kill_icon = self:AddComponent(UIImage, kill_icon_path)
  self.kill_icon_zidan1 = self:AddComponent(UIImage, kill_icon_zidan1_path)
  self.kill_icon_zidan2 = self:AddComponent(UIImage, kill_icon_zidan2_path)
  self.kill_icon_zidan3 = self:AddComponent(UIImage, kill_icon_zidan3_path)
  self.num1 = self:AddComponent(UIImage, num1_path)
  self.num2 = self:AddComponent(UIImage, num2_path)
  self.num3 = self:AddComponent(UIImage, num3_path)
  self.num4 = self:AddComponent(UIImage, num4_path)
  self.plus1 = self:AddComponent(UIImage, plus1_path)
  self.plus2 = self:AddComponent(UIImage, plus2_path)
  self.anim = self:AddComponent(UISimpleAnimation, "")
end

function MultiKillEff:ComponentDestroy()
  self.kill_icon = nil
  self.kill_icon_zidan1 = nil
  self.kill_icon_zidan2 = nil
  self.kill_icon_zidan3 = nil
  self.num1 = nil
  self.num2 = nil
  self.num3 = nil
  self.num4 = nil
  self.anim = nil
  self.plus1 = nil
  self.plus2 = nil
end

function MultiKillEff:DataDefine()
end

function MultiKillEff:DataDestroy()
end

function MultiKillEff:OnEnable()
  base.OnEnable(self)
end

function MultiKillEff:OnDisable()
  base.OnDisable(self)
end

function MultiKillEff:OnDisable()
  base.OnDisable(self)
end

function MultiKillEff:SetData(num, isPve)
  self.num = num
  if num < 10 then
    self.num2:SetEnable(false)
    self.plus1:SetEnable(false)
    self.num1:LoadSprite(NUMBER_PATH[num])
  else
    local showNum
    if num <= 99 then
      showNum = num
      self.plus1:SetEnable(false)
    else
      showNum = 99
      self.plus1:SetEnable(true)
    end
    self.num2:SetEnable(true)
    self.num1:LoadSprite(NUMBER_PATH[showNum // 10])
    self.num2:LoadSprite(NUMBER_PATH[showNum % 10])
  end
  self.anim:Rewind("Small")
  self.anim:Play("Small")
  self:RefreshPE(isPve)
end

function MultiKillEff:ResetData(num, isPve)
  if self.num == nil then
    self:SetData(num, isPve)
    return
  end
  local oldNum = self.num
  if oldNum < 10 then
    self.num2:SetEnable(false)
    self.plus1:SetEnable(false)
    self.num1:LoadSprite(NUMBER_PATH[oldNum])
  else
    local showNum
    if oldNum <= 99 then
      showNum = oldNum
      self.plus1:SetEnable(false)
    else
      showNum = 99
      self.plus1:SetEnable(true)
    end
    self.num2:SetEnable(true)
    self.num1:LoadSprite(NUMBER_PATH[showNum // 10])
    self.num2:LoadSprite(NUMBER_PATH[showNum % 10])
  end
  if num < 10 then
    self.num4:SetEnable(false)
    self.num3:LoadSprite(NUMBER_PATH[num])
    self.plus2:SetEnable(false)
  else
    local showNum
    if num <= 99 then
      showNum = num
      self.plus2:SetEnable(false)
    else
      showNum = 99
      self.plus2:SetEnable(true)
    end
    self.num4:SetEnable(true)
    self.num3:LoadSprite(NUMBER_PATH[showNum // 10])
    self.num4:LoadSprite(NUMBER_PATH[showNum % 10])
  end
  self.num = num
  self.anim:Rewind("Default")
  self.anim:Play("Default")
  self:RefreshPE(isPve)
end

function MultiKillEff:RefreshPE(isPve)
  if self.isPve == isPve then
    return
  end
  self.isPve = isPve
  if isPve then
    self.kill_icon:LoadSprite(PVE_PATH[0])
    self.kill_icon_zidan1:LoadSprite(PVE_PATH[1])
    self.kill_icon_zidan2:LoadSprite(PVE_PATH[2])
    self.kill_icon_zidan3:LoadSprite(PVE_PATH[3])
  else
    self.kill_icon:LoadSprite(PVP_PATH[0])
    self.kill_icon_zidan1:LoadSprite(PVP_PATH[1])
    self.kill_icon_zidan2:LoadSprite(PVP_PATH[2])
    self.kill_icon_zidan3:LoadSprite(PVP_PATH[3])
  end
end

return MultiKillEff
