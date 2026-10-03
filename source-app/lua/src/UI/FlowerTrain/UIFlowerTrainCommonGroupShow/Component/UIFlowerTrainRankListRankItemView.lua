local base = UIBaseContainer
local UIFlowerTrainRankListRankItemView = BaseClass("UIFlowerTrainRankListRankItemView", base)
local womenIconPath = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nv.png"
local manIconPath = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nan.png"
local bg_path = "Bg"
local rankTxt_path = "RankTxt"
local playerHead_path = "HeadContent/PlayerHead"
local playerLevel_path = "HorLayout/PlayerLevelText"
local playerName_path = "HorLayout/PlayerNameText"
local heatIconImg_path = "HeatIcon"
local heatNumTxt_path = "HeatIcon/HeatTxt"
local bgSelf_path = "BgSelf"
local gender_path = "HorLayout/PlayerGenderIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.RefreshUserInfo)
end

local function OnDestroy(self)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.RefreshUserInfo)
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
  self.bg = self:AddComponent(UIImage, bg_path)
  self.rankTxt = self:AddComponent(UIText, rankTxt_path)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.playerLevel = self:AddComponent(UIText, playerLevel_path)
  self.playerName = self:AddComponent(UIText, playerName_path)
  self.heatIconImg = self:AddComponent(UIImage, heatIconImg_path)
  self.heatNumTxt = self:AddComponent(UIText, heatNumTxt_path)
  self.bgSelf = self:AddComponent(UIBaseContainer, bgSelf_path)
  self.playerHeadComponent = self:AddComponent(UICommonHead, playerHead_path)
  self.gender = self:AddComponent(UIImage, gender_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.rankTxt = nil
  self.playerHead = nil
  self.playerLevel = nil
  self.playerName = nil
  self.heatIconImg = nil
  self.heatNumTxt = nil
  self.bgSelf = nil
  self.playerHeadComponent = nil
  self.gender = nil
end

local function DataDefine(self)
  self.uid = ""
end

local function DataDestroy(self)
  self.uid = ""
end

function UIFlowerTrainRankListRankItemView:ReInit(data, itemId, actBanquetTemplate)
  if next(data) == nil then
    return
  end
  self.actBanquetTemplate = actBanquetTemplate
  self.uid = data.uid
  self.rankTxt:SetText(data.rank)
  local isSelf = self.uid == LuaEntry.Player.uid
  self.bg:SetActive(not isSelf)
  self.bgSelf:SetActive(isSelf)
  self:RefreshHeat(data, itemId)
  self:RefreshPlayerInfo(data)
  self:ModifyPanelPacking()
end

function UIFlowerTrainRankListRankItemView:ModifyPanelPacking()
  if self.actBanquetTemplate ~= nil then
    local configList = string.split(self.actBanquetTemplate.treasure_para, "|")
    if configList[20] then
      self.bg:LoadSpriteAsync(string.format(UIAssets.UIActMonopolySpritePath, configList[20]))
    end
  end
end

function UIFlowerTrainRankListRankItemView:ReInitSelf(data, itemId)
  self.uid = LuaEntry.Player.uid
  local dataEmpty = next(data) == nil
  local paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(itemId)
  if dataEmpty or paraMeta and toInt(data.score) < toInt(paraMeta.rank_need) then
    self.rankTxt:SetText("-")
  else
    local rank = data.rank
    if paraMeta and data.rank > tonumber(paraMeta.para8) then
      rank = tostring(paraMeta.para8) .. "+"
    end
    self.rankTxt:SetText(rank)
  end
  self:RefreshUserInfo(self.uid)
  self:RefreshHeat(data, itemId)
end

function UIFlowerTrainRankListRankItemView:RefreshUserInfo(uid)
  if uid ~= self.uid then
    return
  end
  local user = UIUtil.GetPlayerInfoShowByUid(uid)
  self:RefreshPlayerInfo(user)
end

function UIFlowerTrainRankListRankItemView:RefreshPlayerInfo(data)
  self.playerHeadComponent:ParseHeadInfo(data)
  self.playerLevel:SetText("LV." .. (data.level or 0))
  local name = data.name
  if data.uid == LuaEntry.Player.uid then
    name = string.format("<color=#099B4A>%s</color>", name)
  end
  self.playerName:SetText(name)
  if data.gender == 1 then
    self.gender:SetActive(true)
    self.gender:LoadSprite(manIconPath)
  elseif data.gender == 2 then
    self.gender:SetActive(true)
    self.gender:LoadSprite(womenIconPath)
  else
    self.gender:SetActive(false)
  end
end

function UIFlowerTrainRankListRankItemView:RefreshHeat(data, itemId)
  if next(data) == nil then
    return
  end
  if itemId == nil then
    return
  end
  local paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(itemId)
  local expFireConfigList = FlowerTrainUtils.ParesExpFireImgPath(paraMeta.id)
  local path = FlowerTrainUtils.GetExpFireImgPath(expFireConfigList, tonumber(data.score))
  self.heatIconImg:LoadSprite(path)
  self.heatNumTxt:SetText(data.score)
end

UIFlowerTrainRankListRankItemView.OnCreate = OnCreate
UIFlowerTrainRankListRankItemView.OnDestroy = OnDestroy
UIFlowerTrainRankListRankItemView.OnEnable = OnEnable
UIFlowerTrainRankListRankItemView.OnDisable = OnDisable
UIFlowerTrainRankListRankItemView.ComponentDefine = ComponentDefine
UIFlowerTrainRankListRankItemView.ComponentDestroy = ComponentDestroy
UIFlowerTrainRankListRankItemView.DataDefine = DataDefine
UIFlowerTrainRankListRankItemView.DataDestroy = DataDestroy
return UIFlowerTrainRankListRankItemView
