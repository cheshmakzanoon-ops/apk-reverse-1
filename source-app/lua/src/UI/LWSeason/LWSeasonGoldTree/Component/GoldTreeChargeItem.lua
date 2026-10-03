local base = UIBaseContainer
local GoldTreeChargeItem = BaseClass("GoldTreeChargeItem", base)
local __RankBg = {
  [1] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png",
  [2] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png",
  [3] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png",
  [4] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
}
local __RankIcon = {
  [1] = "Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png",
  [2] = "Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png",
  [3] = "Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png"
}
local __RankColor = {
  [1] = Color(0.67, 0.38, 0, 1),
  [2] = Color(0.24, 0.3, 0.6, 1),
  [3] = Color(0.56, 0.38, 0.3, 1),
  [4] = Color(0.16, 0.16, 0.19, 1)
}
local bgImg_path = "bg"
local head_path = "headRoot/UIPlayerHead"
local name_path = "name"
local iconRank_path = "iconRank"
local rank_path = "rank"
local value_path = "value"

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
  self.bgImg = self:AddComponent(UIImage, bgImg_path)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.name = self:AddComponent(UIText, name_path)
  self.iconRank = self:AddComponent(UIImage, iconRank_path)
  self.rank = self:AddComponent(UIText, rank_path)
  self.value = self:AddComponent(UIText, value_path)
  self.playerIcon = self:AddComponent(UICommonHead, head_path)
  self.playerIcon:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.bgImg = nil
  self.head = nil
  self.name = nil
  self.iconRank = nil
  self.rank = nil
  self.value = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreeChargeItem:SetData(data, index)
  index = index or 0
  self.name:SetText(string.format("[%s]%s", data.abbr, data.name))
  self.playerIcon:SetHeadAndFrame(data.uid, data.pic, data.picver, nil, data.headSkinId, data.headSkinET)
  self.rank:SetText(index)
  self.bgImg:LoadSprite(__RankBg[index] or __RankBg[4])
  local iconPath = __RankIcon[index]
  if iconPath then
    self.iconRank:LoadSprite(iconPath)
    self.iconRank:SetActive(true)
  else
    self.iconRank:SetActive(false)
  end
  local color = __RankColor[index] or __RankColor[4]
  self.name:SetColorRGBA(color)
end

GoldTreeChargeItem.OnCreate = OnCreate
GoldTreeChargeItem.OnDestroy = OnDestroy
GoldTreeChargeItem.OnEnable = OnEnable
GoldTreeChargeItem.OnDisable = OnDisable
GoldTreeChargeItem.ComponentDefine = ComponentDefine
GoldTreeChargeItem.ComponentDestroy = ComponentDestroy
GoldTreeChargeItem.DataDefine = DataDefine
GoldTreeChargeItem.DataDestroy = DataDestroy
return GoldTreeChargeItem
