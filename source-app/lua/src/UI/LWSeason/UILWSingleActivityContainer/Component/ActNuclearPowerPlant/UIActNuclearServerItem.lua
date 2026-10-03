local base = UIBaseContainer
local UIActNuclearServerItem = BaseClass("UIActNuclearServerItem", base)
local Localization = CS.GameEntry.Localization
local rank_path = "rank"
local serverId_path = "serverId"
local progressFront_path = "progressArea/progress/progressFront"
local progressDes_path = "progressArea/progress/progressDes"
local temperature_path = "progressArea/temperature"
local serverIcon_path = "serverIcon"
local progressArea_path = "progressArea"
local completeArea_path = "completeArea"
local bg_path = "bg"
local medal_path = "medal"
local finishDes_path = "completeArea/finishDes"
local finishTime_path = "completeArea/finishTime"
local progressValue_path = "progressArea/progress/progressValueDes"

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
  self.rank = self:AddComponent(UIText, rank_path)
  self.serverId = self:AddComponent(UIText, serverId_path)
  self.progressFront = self:AddComponent(UIBaseContainer, progressFront_path)
  self.progressDes = self:AddComponent(UIText, progressDes_path)
  self.temperature = self:AddComponent(UIText, temperature_path)
  self.serverIcon = self:AddComponent(UIImage, serverIcon_path)
  self.progressArea = self:AddComponent(UIBaseContainer, progressArea_path)
  self.completeArea = self:AddComponent(UIBaseContainer, completeArea_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.medal = self:AddComponent(UIImage, medal_path)
  self.finishDes = self:AddComponent(UIText, finishDes_path)
  self.finishTime = self:AddComponent(UIText, finishTime_path)
  self.progressValue = self:AddComponent(UIText, progressValue_path)
end

local function ComponentDestroy(self)
  self.rank = nil
  self.serverId = nil
  self.progressFront = nil
  self.progressDes = nil
  self.temperature = nil
  self.serverIcon = nil
  self.progressArea = nil
  self.completeArea = nil
  self.bg = nil
  self.medal = nil
  self.finishDes = nil
  self.finishTime = nil
  self.progressValue = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIActNuclearServerItem:SetData(data, maxValue, temperature)
  self.rank:SetText(data.rank)
  self.serverId:SetText("#" .. data.serverId)
  local r = data.score / maxValue
  if 1 < r then
    r = 1
  end
  self.progressDes:SetText(Localization:GetString("season_s2_activity_1000047_description_10") .. ":" .. string.format("%.2f", tostring(r * 100)) .. "%")
  self.progressFront:SetLocalScaleXYZ(r, 1, 1)
  self.progressValue:SetText("")
  local textColor
  if data.rank == 1 then
    textColor = Color.FromHex("915000")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_1.png")
    self.medal:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png")
    self.medal:SetActive(true)
  elseif data.rank == 2 then
    textColor = Color.FromHex("4b5aa4")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_2.png")
    self.medal:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png")
    self.medal:SetActive(true)
  elseif data.rank == 3 then
    textColor = Color.FromHex("8c5a40")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_3.png")
    self.medal:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png")
    self.medal:SetActive(true)
  else
    self.medal:SetActive(false)
    textColor = Color.FromHex("373232")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_4.png")
  end
  self.finishDes:SetColor(textColor)
  self.finishTime:SetColor(textColor)
  self.progressDes:SetColor(textColor)
  self.completeArea:SetActive(false)
  self.progressArea:SetActive(true)
  self.completeArea:SetActive(false)
  if data.serverInfo then
    self.cfgId = data.serverInfo.cfgId or 511001
  else
    self.cfgId = 511001
  end
  if self.cfgId then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(self.cfgId)
    if itemCfg ~= nil then
      self.serverIcon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
end

UIActNuclearServerItem.OnCreate = OnCreate
UIActNuclearServerItem.OnDestroy = OnDestroy
UIActNuclearServerItem.OnEnable = OnEnable
UIActNuclearServerItem.OnDisable = OnDisable
UIActNuclearServerItem.ComponentDefine = ComponentDefine
UIActNuclearServerItem.ComponentDestroy = ComponentDestroy
UIActNuclearServerItem.DataDefine = DataDefine
UIActNuclearServerItem.DataDestroy = DataDestroy
return UIActNuclearServerItem
