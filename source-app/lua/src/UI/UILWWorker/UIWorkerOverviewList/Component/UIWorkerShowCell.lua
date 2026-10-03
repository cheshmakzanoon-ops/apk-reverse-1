local UIWorkerShowCell = BaseClass("UIWorkerShowCell", UIBaseContainer)
local base = UIBaseContainer
local LWWorkerRankStar = require("UI.UILWWorker.UIWorkerOverviewList.Component.LWWorkerRankStar")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local bg_path = "Root/Bg"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.cfgId = nil
  self.rankNum = nil
  self.temp = nil
  self.isShowRank = nil
end

local function DataDestroy(self)
  self.cfgId = nil
  self.rankNum = nil
  self.temp = nil
  self.isShowRank = nil
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, "Root/WorkerNameText")
  self.qualityBg = self:AddComponent(UIImage, "Root/Bg/LayerNormal/ImgBg")
  self.icon = self:AddComponent(UIImage, "Root/Bg/LayerNormal/ImgBg/Mask/ImgIcon1")
  self.loading = self:TryAddComponent(UIImage, "Root/Bg/LayerNormal/ImgBg/Mask/Loading")
  self.hero_rank_star = self:AddComponent(LWWorkerRankStar, "Root/HeroRankStar")
  self.bg = self:AddComponent(UIImage, bg_path)
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.qualityBg = nil
  self.icon = nil
  self.hero_rank_star = nil
  self.bg = nil
  self.loading = nil
end

local function SetData(self, cfgId, rankNum, isShowRank)
  self.cfgId = cfgId
  self.rankNum = rankNum or 1
  self.isShowRank = true
  if isShowRank ~= nil then
    self.isShowRank = isShowRank
  end
  self.temp = DataCenter.WorkerTemplateManager:GetShowTemplateById(self.cfgId)
  if self.temp == nil then
    return
  end
  local imgPath = HeroUtils.GetHeroIconPath(self.temp.appearance, HeroIconType.half_portrait)
  if self.icon and not string.IsNullOrEmpty(imgPath) then
    local nameLength = #imgPath
    if 4 < nameLength and string.find(imgPath, ".png", nameLength - 3, true) == nil then
      imgPath = imgPath .. ".png"
    end
    local hasAsset = UIUtil.CheckAssetDownloaded(imgPath)
    if self.loading then
      self.loading:SetActive(not hasAsset)
    end
    self.icon:LoadSpriteAsyncWithCallback(imgPath, function(texture)
      if not hasAsset and self.loading then
        self.loading:SetActive(false)
      end
    end)
  end
  self.nameText:SetText(Localization:GetString(self.temp.last_name))
  self.qualityBg:LoadSpriteAuto(WorkerUtil.GetWorkerQualityBg(self.temp.quality))
  self.bg:LoadSpriteAuto(WorkerUtil.GetWorkerQualityColorBottomBg(self.temp.quality))
  if self.temp.star <= 0 or self.isShowRank == false then
    self.hero_rank_star:SetActive(false)
  else
    local rankBaseTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.cfgId, 1)
    if rankBaseTemp then
      self.hero_rank_star:SetActive(true)
      local maxRank = rankBaseTemp.max_rank
      self.hero_rank_star:ShowRank(self.rankNum, maxRank)
    else
      self.hero_rank_star:SetActive(false)
    end
  end
end

UIWorkerShowCell.OnCreate = OnCreate
UIWorkerShowCell.OnDestroy = OnDestroy
UIWorkerShowCell.DataDefine = DataDefine
UIWorkerShowCell.DataDestroy = DataDestroy
UIWorkerShowCell.ComponentDefine = ComponentDefine
UIWorkerShowCell.ComponentDestroy = ComponentDestroy
UIWorkerShowCell.SetData = SetData
return UIWorkerShowCell
