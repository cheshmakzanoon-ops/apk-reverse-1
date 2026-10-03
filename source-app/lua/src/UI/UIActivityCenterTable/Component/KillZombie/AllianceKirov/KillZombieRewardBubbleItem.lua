local base = UIBaseContainer
local KillZombieRewardBubbleItem = BaseClass("KillZombieRewardBubbleItem", base)
local Localization = CS.GameEntry.Localization
local icon1_path = "Bg/Reward/Icon1"
local count_text1_path = "Bg/Reward/CountText1"
local symbol_path = "Bg/Symbol"
local reward2_path = "Bg/Reward2"
local icon2_path = "Bg/Reward2/Icon2"
local count_text2_path = "Bg/Reward2/CountText2"
local dmg_text_path = "DmgText"
local count_1_path = "Bg/Reward/Count1"
local count_2_path = "Bg/Reward2/Count2"

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
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.count_text1 = self:AddComponent(UITextMeshProUGUIEx, count_text1_path)
  self.symbol = self:AddComponent(UIImage, symbol_path)
  self.reward2 = self:AddComponent(UIBaseContainer, reward2_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.count_text2 = self:AddComponent(UITextMeshProUGUIEx, count_text2_path)
  self.dmg_text = self:AddComponent(UITextMeshProUGUIEx, dmg_text_path)
  self.count_1 = self:AddComponent(UITextMeshProUGUIEx, count_1_path)
  self.count_2 = self:AddComponent(UITextMeshProUGUIEx, count_2_path)
end

local function ComponentDestroy(self)
  self.icon1 = nil
  self.count_text1 = nil
  self.symbol = nil
  self.reward2 = nil
  self.icon2 = nil
  self.count_text2 = nil
  self.dmg_text = nil
  self.count_1 = nil
  self.count_2 = nil
end

local function DataDefine(self)
  self.type = nil
  self.index = nil
end

local function DataDestroy(self)
  self.type = nil
  self.index = nil
end

local function RefreshInfo(self, param)
  if param == nil then
    self:SetActive(false)
    return
  end
  if not self:GetActive() then
    self:SetActive(true)
  end
  local rewardStr = param.reward
  local type = param.type
  local index = param.index
  local nodeDmg = param.nodeDmg
  if self.type == type and self.index == index then
    return
  end
  self.type = type
  self.index = index
  if rewardStr ~= nil and rewardStr ~= "" then
    local rewardArr = string.split(rewardStr, ";")
    if rewardArr then
      local arr1 = string.split(rewardArr[1], ",")
      if arr1 then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(arr1[1])
        local num = tonumber(arr1[3])
        self.count_text1:SetText("x" .. num)
        if goods ~= nil then
          self.icon1:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
          if not string.IsNullOrEmpty(goods.para2) then
            self.count_1:SetText(string.GetFormattedStr(tonumber(goods.para2)))
          else
            self.count_1:SetText("")
          end
        end
      end
      if #rewardArr == 2 then
        local arr2 = string.split(rewardArr[2], ",")
        if arr2 then
          local goods = DataCenter.ItemTemplateManager:GetItemTemplate(arr2[1])
          local num = tonumber(arr2[3])
          self.count_text2:SetText("x" .. num)
          if goods ~= nil then
            self.icon2:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
            if not string.IsNullOrEmpty(goods.para2) then
              self.count_2:SetText(string.GetFormattedStr(tonumber(goods.para2)))
            else
              self.count_2:SetText("")
            end
          end
        end
        self.symbol:SetActive(true)
        self.reward2:SetActive(true)
      else
        self.symbol:SetActive(false)
        self.reward2:SetActive(false)
      end
    end
  end
  if nodeDmg then
    local dmgText = string.GetFormattedGiga2(tonumber(nodeDmg))
    self.dmg_text:SetText(dmgText)
  else
    self.dmg_text:SetText("")
  end
end

local function ResetData(self)
  self.type = nil
  self.index = nil
end

KillZombieRewardBubbleItem.OnCreate = OnCreate
KillZombieRewardBubbleItem.OnDestroy = OnDestroy
KillZombieRewardBubbleItem.OnEnable = OnEnable
KillZombieRewardBubbleItem.OnDisable = OnDisable
KillZombieRewardBubbleItem.ComponentDefine = ComponentDefine
KillZombieRewardBubbleItem.ComponentDestroy = ComponentDestroy
KillZombieRewardBubbleItem.DataDefine = DataDefine
KillZombieRewardBubbleItem.DataDestroy = DataDestroy
KillZombieRewardBubbleItem.RefreshInfo = RefreshInfo
KillZombieRewardBubbleItem.ResetData = ResetData
return KillZombieRewardBubbleItem
