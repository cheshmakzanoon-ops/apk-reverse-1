local UIJeepAdventureMainSpeedPanel = BaseClass("UIJeepAdventureMainSpeedPanel", UIBaseContainer)
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
  self.imgSpeed = self:AddComponent(UIImage, "SpeedImg")
  self.textTip = self:AddComponent(UIText, "TipText")
  self.textSpeed = self:AddComponent(UIText, "SpeedText")
  self.textTip:SetLocalText("armed_truck_speed_name")
  self.headPanel = self:AddComponent(UIBaseContainer, "HeadPanel")
  self.headList = {}
  for i = 0, self.headPanel.transform.childCount - 1 do
    local obj = self.headPanel.transform:GetChild(i).gameObject
    local comp = self.headPanel:AddComponent(UICommonHead, obj.name)
    comp:SetActive(false)
    table.insert(self.headList, comp)
  end
end

local function ComponentDestroy(self)
  self.compSpeed1 = nil
  self.compSpeed2 = nil
  self.compSpeed3 = nil
  self.compSpeed4 = nil
  self.textTip = nil
  self.textSpeed = nil
  self.headPanel = nil
  self.headList = nil
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

local function Refresh(self, param)
  if param == nil then
    self:SetActive(false)
    return
  end
  local speed = param.speed
  local progress = param.progress
  local jumpZombieChangeSpeed = param.jumpZombieChangeSpeed
  local speedBuffJumpZombies = param.speedBuffJumpZombies
  local jumpZombiesChange = param.jumpZombiesChange
  if progress <= 0 then
    self:SetActive(false)
  else
    self:SetActive(true)
    self.imgSpeed:SetFillAmount(progress)
  end
  if jumpZombiesChange then
    for i, v in ipairs(self.headList) do
      local jumpZombie = speedBuffJumpZombies[i]
      if jumpZombie then
        local icon = jumpZombie.cfg.icon
        if icon then
          v:SetHead(nil, icon)
        end
        v:SetActive(true)
      else
        v:SetActive(false)
      end
    end
  end
  if jumpZombieChangeSpeed ~= 0 then
    self.textSpeed:SetText(speed - jumpZombieChangeSpeed .. string.format("<color=#EB1313> %s</color>", jumpZombieChangeSpeed))
  else
    self.textSpeed:SetText(speed)
  end
end

UIJeepAdventureMainSpeedPanel.OnCreate = OnCreate
UIJeepAdventureMainSpeedPanel.OnDestroy = OnDestroy
UIJeepAdventureMainSpeedPanel.OnEnable = OnEnable
UIJeepAdventureMainSpeedPanel.OnDisable = OnDisable
UIJeepAdventureMainSpeedPanel.ComponentDefine = ComponentDefine
UIJeepAdventureMainSpeedPanel.ComponentDestroy = ComponentDestroy
UIJeepAdventureMainSpeedPanel.DataDefine = DataDefine
UIJeepAdventureMainSpeedPanel.DataDestroy = DataDestroy
UIJeepAdventureMainSpeedPanel.OnAddListener = OnAddListener
UIJeepAdventureMainSpeedPanel.OnRemoveListener = OnRemoveListener
UIJeepAdventureMainSpeedPanel.Refresh = Refresh
return UIJeepAdventureMainSpeedPanel
