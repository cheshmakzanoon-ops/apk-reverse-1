local base = UIBaseContainer
local GiftIconShowContent = BaseClass("GiftIconShowContent", base)
local gift_icon_path = "giftIcon"
local gift_prefab_path = "giftPrefab"

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

function GiftIconShowContent:ComponentDefine()
  self.gift_icon = self:AddComponent(UIImage, gift_icon_path)
  self.gift_prefab = self:AddComponent(UIVfx, gift_prefab_path)
  self.gift_icon:SetActive(false)
  self.gift_prefab:SetActive(false)
end

local function ComponentDestroy(self)
  self.gift_icon = nil
  self.gift_prefab:Remove()
  self.gift_prefab = nil
end

local function DataDefine(self)
  self.cfgId = nil
  self.num = nil
end

local function DataDestroy(self)
  self.cfgId = nil
  self.num = nil
end

function GiftIconShowContent:SetShowData(cfgId, num)
  if self.cfgId == cfgId and self.num == num then
    return
  end
  self.cfgId = cfgId
  self.num = num
  self:RefreshView()
end

function GiftIconShowContent:RefreshView()
  local temp = DataCenter.GiftSystemManager:GetGiftGoods(self.cfgId)
  if temp == nil then
    return
  end
  local groupId = -1
  local giftNum = self.num and self.num or 0
  for i, v in ipairs(temp.group_id) do
    if giftNum >= tonumber(v) then
      groupId = i
    else
      break
    end
  end
  if groupId == -1 then
    groupId = 1
  end
  if 0 < #temp.show_fx then
    local reqName
    if groupId > #temp.show_fx then
      reqName = temp.show_fx[#temp.show_fx]
    else
      reqName = temp.show_fx[groupId]
    end
    self.gift_prefab:SetActive(true)
    local fPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/IconEffect/%s.prefab"
    self.gift_prefab:PlayByStay(string.format(fPath, reqName), {isBreak = true})
  else
    self.gift_prefab:SetActive(false)
  end
end

GiftIconShowContent.OnCreate = OnCreate
GiftIconShowContent.OnDestroy = OnDestroy
GiftIconShowContent.OnEnable = OnEnable
GiftIconShowContent.OnDisable = OnDisable
GiftIconShowContent.ComponentDestroy = ComponentDestroy
GiftIconShowContent.DataDefine = DataDefine
GiftIconShowContent.DataDestroy = DataDestroy
return GiftIconShowContent
