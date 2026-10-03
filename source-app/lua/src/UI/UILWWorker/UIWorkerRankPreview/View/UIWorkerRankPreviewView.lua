local UIWorkerRankPreviewView = BaseClass("UIWorkerRankPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWWorkerRankStar = require("UI.UILWWorker.UIWorkerOverviewList.Component.LWWorkerRankStar")
local UIWorkerRankEffectLine = require("UI.UILWWorker.UIWorkerInfoDetail.Component.UIWorkerRankEffectLine")
local btn_close_path = "BgContent/bg/BtnClose"
local btn_panel_path = "Panel"
local toggle_path = "mainObj/Tab/Toggle"
local worker_icon_path = "mainObj/MiddleBg/workerInfoContent/infoContent/bg/workerImgContent/workerIcon"
local worker_name_path = "mainObj/MiddleBg/workerInfoContent/infoContent/bg/workerName"
local power_txt_path = "mainObj/MiddleBg/workerInfoContent/infoContent/bg/powerTxt"
local hero_rank_star_path = "mainObj/MiddleBg/workerInfoContent/rankDataContent/HeroRankStar"
local rank_txt_path = "mainObj/MiddleBg/workerInfoContent/rankDataContent/rankTxt"
local effect_content_path = "mainObj/MiddleBg/workerInfoContent/rankDetailDataContent/DescLayout/Viewport/Content/effectContent"
local content_path = "mainObj/MiddleBg/workerInfoContent/rankDetailDataContent/DescLayout/Viewport/Content"
local rank_item_content_path = "mainObj/MiddleBg/workerInfoContent/rankDetailDataContent/DescLayout/Viewport/Content/RankItemContent"
local next_effect_group_path = "mainObj/MiddleBg/workerInfoContent/rankDetailDataContent/DescLayout/Viewport/Content/NextEffectGroup"
local next_effect_value_line_path = "mainObj/MiddleBg/workerInfoContent/rankDetailDataContent/DescLayout/Viewport/Content/NextEffectGroup/WorkerNextEffectValueLine"
local effectShowNum = 4
local viewIndexType = {rankOne = 1, rankMax = 2}
local toggleNum = 2

local function OnCreate(self)
  base.OnCreate(self)
  self.workerCfgId = self:GetUserData()
  self.selectType = viewIndexType.rankMax
  self.temp = DataCenter.WorkerTemplateManager:GetShowTemplateById(self.workerCfgId)
  self.rankBaseTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, 1)
  self.rankNum = 1
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.toggleList = {}
  for i = 1, toggleNum do
    local root = self:AddComponent(UIButton, toggle_path .. i)
    self.toggleList[i] = {
      root = root,
      tab_text = root:AddComponent(UIText, "tab_text"),
      Choose = root:AddComponent(UIBaseContainer, "Choose"),
      tab_text2 = root:AddComponent(UIText, "Choose/tab_text2")
    }
    root:SetOnClick(function()
      self:OnSelectIndex(i)
    end)
  end
  self.panel_close = self:AddComponent(UIButton, btn_panel_path)
  self.panel_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.worker_icon = self:AddComponent(UIRawImage, worker_icon_path)
  self.worker_name = self:AddComponent(UIText, worker_name_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.hero_rank_star = self:AddComponent(LWWorkerRankStar, hero_rank_star_path)
  self.rank_txt = self:AddComponent(UIText, rank_txt_path)
  self.effect_content = self:AddComponent(UIBaseContainer, effect_content_path)
  self.effectItems = {}
  for i = 1, effectShowNum do
    local effectItem = self:AddComponent(UIBaseContainer, effect_content_path .. "/effectItem" .. i)
    self.effectItems[i] = {
      root = effectItem,
      effectTxt = effectItem:AddComponent(UITextMeshProUGUI, "effectTxt"),
      valueText = effectItem:AddComponent(UIText, "ValueContainer/ValueText"),
      nextValueText = effectItem:AddComponent(UIText, "ValueContainer/NextValueText"),
      arrowIcon = effectItem:AddComponent(UIBaseContainer, "ValueContainer/ArrowIcon"),
      effect = effectItem:AddComponent(UIBaseContainer, "effect")
    }
    self.effectItems[i].effect:SetActive(false)
  end
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.rank_item_content = self:AddComponent(UIBaseContainer, rank_item_content_path)
  self.next_effect_group = self:AddComponent(UIBaseContainer, next_effect_group_path)
  self.next_effect_value_line = self:AddComponent(UIBaseContainer, next_effect_value_line_path)
  self.next_effect_value_line:SetActive(false)
  self.next_effect_value_line_go = self.next_effect_value_line.gameObject
  self.next_effect_value_line_go:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.next_effect_group:RemoveComponents(UIWorkerRankEffectLine)
  self.next_effect_value_line_go:GameObjectRecycleAll()
  self.btn_close = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.worker_icon = nil
  self.worker_name = nil
  self.power_txt = nil
  self.hero_rank_star = nil
  self.rank_txt = nil
  self.effect_content = nil
  self.effectItems = nil
  self.content = nil
  self.rank_item_content = nil
  self.next_effect_group = nil
  self.next_effect_group = nil
  self.next_effect_value_line = nil
  self.next_effect_value_line_go:GameObjectRecycleAll()
  self.next_effect_value_line_go = nil
end

local function OnSelectIndex(self, select)
  if select == self.selectType then
    return
  end
  self.selectType = select
  self:RefreshView()
end

local function RefreshView(self)
  for i = 1, toggleNum do
    self.toggleList[i].Choose:SetActive(i == self.selectType)
  end
  if self.selectType == viewIndexType.rankOne then
    self.rankNum = 1
  else
    self.rankNum = self.rankBaseTemp.max_rank
  end
  self.content:SetAnchoredPositionXY(0, 0)
  self.worker_icon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(self.temp.appearance, HeroIconType.pose_icon_path), function(texture)
    if self and self.worker_icon then
      self.worker_icon:SetNativeSize()
    end
  end)
  self.worker_name:SetText(self.temp:GetName())
  self.worker_name:SetColorRGBA(WorkerUtil.GetWorkerNameColor(self.temp.quality))
  local rankLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum)
  local powerNum = self.temp.power + rankLvTemp.power
  self.power_txt:SetText(powerNum)
  local maxRank = self.rankBaseTemp.max_rank
  self.hero_rank_star:ShowRank(self.rankNum, maxRank)
  local rankNum1 = math.floor((self.rankNum - 1) / 5)
  local rankNum2 = (self.rankNum - 1) % 5
  self.rank_txt:SetText(Localization:GetString("worker_ui102", rankNum1, rankNum2))
  self:SetRankViewEffectContent()
  self:SetRankViewRankEffectContent()
end

local function SetRankViewEffectContent(self)
  local rankLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum)
  self.rankUpEffectData = {}
  local effectData = self.rankUpEffectData
  local curEffectData = {}
  table.insert(curEffectData, self.temp.effectData)
  for k, v in ipairs(rankLvTemp.effect_data) do
    table.insert(curEffectData, v)
  end
  table.insert(curEffectData, rankLvTemp.rank_effect_data)
  for _, data in ipairs(curEffectData) do
    if #data == 2 then
      local effectId = data[1]
      local effectVal = data[2]
      local targetData
      for k, v in ipairs(effectData) do
        if v.id == effectId then
          targetData = v
          break
        end
      end
      if targetData == nil then
        targetData = {id = effectId}
        table.insert(effectData, targetData)
      end
      if targetData.curVal then
        targetData.curVal = targetData.curVal + effectVal
      else
        targetData.curVal = effectVal
      end
    end
  end
  for i = 1, effectShowNum do
    local effectItem = self.effectItems[i]
    if effectData[i] then
      effectItem.root:SetActive(true)
      local effectId = effectData[i].id
      local effectVal = effectData[i].curVal
      local effectNextVal = effectData[i].nextVal
      local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
      local effectName = Localization:GetString(effectLine.name)
      local addValue = HeroUtils.GetFormattedPropertyValue(effectId, effectVal)
      effectItem.effectTxt:SetText(effectName)
      effectItem.valueText:SetText(addValue)
      effectItem.nextValueText:SetActive(false)
      effectItem.arrowIcon:SetActive(false)
    else
      effectItem.root:SetActive(false)
    end
  end
end

local function SetRankViewRankEffectContent(self)
  self.next_effect_group:RemoveComponents(UIWorkerRankEffectLine)
  self.next_effect_value_line_go:GameObjectRecycleAll()
  local rankData = {}
  local starNum = math.floor((self.rankBaseTemp.max_rank - 1) / 5)
  for i = 1, starNum do
    local needRank = i * 5 + 1
    local starRankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, needRank)
    local isUnlock = needRank <= self.rankNum
    local outDesc = ""
    local data = starRankTemp.rank_effect_data
    if #data == 2 then
      local effectId = data[1]
      local effectVal = data[2]
      local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
      local effectName = Localization:GetString(effectLine.name)
      local addValue = HeroUtils.GetFormattedPropertyValue(effectId, effectVal)
      if isUnlock then
        outDesc = effectName .. addValue
      else
        outDesc = string.format("<color=#F97077>%s</color> %s", Localization:GetString("worker_ui103", i), effectName .. addValue)
      end
    end
    table.insert(rankData, {
      isUnlock = isUnlock,
      outDesc = outDesc,
      starRankTemp = starRankTemp
    })
  end
  if 0 < #rankData then
    self.next_effect_group:SetActive(true)
    for i = 1, #rankData do
      local item = self.next_effect_value_line_go:GameObjectSpawn(self.next_effect_group.transform)
      item.name = "item" .. i
      local cell = self.next_effect_group:AddComponent(UIWorkerRankEffectLine, item.name)
      cell:SetData(rankData[i].isUnlock, rankData[i].outDesc, nil, rankData[i].starRankTemp)
    end
  else
    self.next_effect_group:SetActive(false)
  end
end

UIWorkerRankPreviewView.OnCreate = OnCreate
UIWorkerRankPreviewView.OnDestroy = OnDestroy
UIWorkerRankPreviewView.ComponentDefine = ComponentDefine
UIWorkerRankPreviewView.ComponentDestroy = ComponentDestroy
UIWorkerRankPreviewView.RefreshView = RefreshView
UIWorkerRankPreviewView.OnSelectIndex = OnSelectIndex
UIWorkerRankPreviewView.SetRankViewEffectContent = SetRankViewEffectContent
UIWorkerRankPreviewView.SetRankViewRankEffectContent = SetRankViewRankEffectContent
return UIWorkerRankPreviewView
