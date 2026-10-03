local UIWorkerInfoDetailView = BaseClass("UIWorkerInfoDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource
local LWWorkerRankStar = require("UI.UILWWorker.UIWorkerOverviewList.Component.LWWorkerRankStar")
local UIWorkerRankEffectLine = require("UI.UILWWorker.UIWorkerInfoDetail.Component.UIWorkerRankEffectLine")
local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "Common_bg_orange/CloseBtn"
local worker_icon_path = "Common_bg_orange/topContent/workerImgContent/workerIcon"
local worker_loading_path = "Common_bg_orange/topContent/workerImgContent/Loading"
local worker_name_path = "Common_bg_orange/topContent/infoContent/workerName"
local worker_first_name_path = "Common_bg_orange/topContent/infoContent/workerFirstName"
local power_txt_path = "Common_bg_orange/topContent/powerImg/powerTxt"
local effect_content_path = "Common_bg_orange/Root/centerContent/ScrollView/Viewport/Content/effectContent"
local hero_rank_star_path = "Common_bg_orange/topContent/HeroRankStar"
local next_effect_group_path = "Common_bg_orange/Root/centerContent/ScrollView/Viewport/Content/NextEffectGroup"
local rank_up_content_path = "Common_bg_orange/Root/bottomContent/rankUpContent"
local next_effect_value_line_path = "Common_bg_orange/Root/centerContent/ScrollView/Viewport/Content/NextEffectGroup/WorkerNextEffectValueLine"
local view_tip_txt_content_path = "Common_bg_orange/Root/bottomContent/ViewTipTxtContent"
local power_effect_path = "Common_bg_orange/topContent/powerImg/powerTxt/powerEffect"
local cost_group1_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup1"
local cost_icon1_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup1/CostIcon1"
local cost_text1_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup1/CostText1"
local cost_group2_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup2"
local cost_icon2_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup2/CostIcon2"
local cost_text2_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup2/CostText2"
local rank_up_btn_path = "Common_bg_orange/Root/bottomContent/rankUpContent/rankUpBtn"
local rank_up_btn_text_path = "Common_bg_orange/Root/bottomContent/rankUpContent/rankUpBtn/rankUpBtnText"
local view_tip_txt_path = "Common_bg_orange/Root/bottomContent/ViewTipTxtContent/ViewTipTxt"
local talk_content_path = "Common_bg_orange/topContent/talkContent"
local plot_content_path = "Common_bg_orange/topContent/talkContent/ScrollView/Viewport/PlotContent"
local worker_color_bg_path = "Common_bg_orange/topContent/workerImgContent/workerColorBg"
local point_building_content_path = "Common_bg_orange/topContent/pointBuildingContent"
local point_building_lv_path = "Common_bg_orange/topContent/pointBuildingContent/pointBuildingLv"
local point_building_name_path = "Common_bg_orange/topContent/pointBuildingContent/pointBuildingName"
local line_content_path = "Common_bg_orange/Root/centerContent/ScrollView/Viewport/Content/LineContent"
local bottom_content_path = "Common_bg_orange/Root/bottomContent"
local bottom_empty_content_path = "Common_bg_orange/Root/bottomEmptyContent"
local center_content_path = "Common_bg_orange/Root/centerContent"
local content_path = "Common_bg_orange/Root/centerContent/ScrollView/Viewport/Content"
local info_content_path = "Common_bg_orange/topContent/infoContent"
local effectShowNum = 4
local WorkerBlackColor = 1.0
local NoRankWorkerContentHeight = 375
local RankWorkerContentHeight = 553
local sendMsgMaxWaitTime = 5000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.workerCfgId, self.workerData, self.showDataList, self.curIndex = self:GetUserData()
  self:OnOpen()
  self:RefreshShortcutShow()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.worker_icon = self:AddComponent(UIRawImage, worker_icon_path)
  self.worker_loading = self:AddComponent(UIImage, worker_loading_path)
  self.worker_name = self:AddComponent(UIText, worker_name_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.worker_first_name = self:AddComponent(UITextMeshProUGUIEx, worker_first_name_path)
  self.effect_content = self:AddComponent(UIBaseContainer, effect_content_path)
  self.hero_rank_star = self:AddComponent(LWWorkerRankStar, hero_rank_star_path)
  self.next_effect_group = self:AddComponent(UIBaseContainer, next_effect_group_path)
  self.rank_up_content = self:AddComponent(UIBaseContainer, rank_up_content_path)
  self.view_tip_txt_content = self:AddComponent(UIBaseContainer, view_tip_txt_content_path)
  self.cost_group1 = self:AddComponent(UIBaseContainer, cost_group1_path)
  self.cost_icon1 = self:AddComponent(UIImage, cost_icon1_path)
  self.cost_text1 = self:AddComponent(UIText, cost_text1_path)
  self.cost_group2 = self:AddComponent(UIBaseContainer, cost_group2_path)
  self.cost_icon2 = self:AddComponent(UIImage, cost_icon2_path)
  self.cost_text2 = self:AddComponent(UIText, cost_text2_path)
  self.rank_up_btn = self:AddComponent(UIButton, rank_up_btn_path)
  self.rank_up_btn_text = self:AddComponent(UIText, rank_up_btn_text_path)
  self.rank_up_btn:SetOnClick(BindCallback(self, self.RankUpBtnClickFunc))
  self.view_tip_txt = self:AddComponent(UIText, view_tip_txt_path)
  self.costItems = {}
  self.costItems[1] = {
    cost_group = self.cost_group1,
    cost_icon = self.cost_icon1,
    cost_text = self.cost_text1
  }
  self.costItems[2] = {
    cost_group = self.cost_group2,
    cost_icon = self.cost_icon2,
    cost_text = self.cost_text2
  }
  self.effectItems = {}
  for i = 1, effectShowNum do
    local effectItem = self:AddComponent(UIBaseContainer, effect_content_path .. "/effectItem" .. i)
    self.effectItems[i] = {
      root = effectItem,
      effectTxt = effectItem:AddComponent(UITextMeshProUGUI, "effectTxt"),
      valueText = effectItem:AddComponent(UIText, "ValueContainer/ValueText"),
      nextValueText = effectItem:AddComponent(UIText, "ValueContainer/NextValueText"),
      arrowIcon = effectItem:AddComponent(UIBaseContainer, "ValueContainer/ArrowIcon"),
      effect = effectItem:AddComponent(UIBaseContainer, "effect"),
      tipBtn = effectItem:AddComponent(UIButton, "tipBtn")
    }
    self.effectItems[i].effect:SetActive(false)
    self.effectItems[i].tipBtn:SetOnClick(function()
      self:OnEffectTipBtnClick(i)
    end)
  end
  self.next_effect_value_line = self:AddComponent(UIBaseContainer, next_effect_value_line_path)
  self.next_effect_value_line:SetActive(false)
  self.next_effect_value_line_go = self.next_effect_value_line.gameObject
  self.next_effect_value_line_go:GameObjectCreatePool()
  self.power_effect = self:AddComponent(UIBaseContainer, power_effect_path)
  self.power_effect:SetActive(false)
  self.talk_content = self:AddComponent(UIBaseContainer, talk_content_path)
  self.plot_content = self:AddComponent(UITextMeshProUGUIEx, plot_content_path)
  self.worker_color_bg = self:AddComponent(UIRawImage, worker_color_bg_path)
  self.point_building_content = self:AddComponent(UIBaseContainer, point_building_content_path)
  self.point_building_lv = self:AddComponent(UITextMeshProUGUIEx, point_building_lv_path)
  self.point_building_name = self:AddComponent(UITextMeshProUGUIEx, point_building_name_path)
  self.line_content = self:AddComponent(UIBaseContainer, line_content_path)
  self.bottom_content = self:AddComponent(UIBaseContainer, bottom_content_path)
  self.bottom_empty_content = self:AddComponent(UIBaseContainer, bottom_empty_content_path)
  self.center_content = self:AddComponent(UILayoutElement, center_content_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.info_content = self:AddComponent(UIRawImage, info_content_path)
  self.btnLeftShortcutKey = self:AddComponent(UIButton, "ShortcutKeyRoot/LeftShortcutKey")
  self.btnLeftShortcutKey:SetOnClick(function()
    if self.OnBtnLeftShortcutKeyClick then
      self:OnBtnLeftShortcutKeyClick()
    end
  end)
  self.btnRightShortcutKey = self:AddComponent(UIButton, "ShortcutKeyRoot/RightShortcutKey")
  self.btnRightShortcutKey:SetOnClick(function()
    if self.OnBtnRightShortcutKeyClick then
      self:OnBtnRightShortcutKeyClick()
    end
  end)
  self.compShortcutKeyRoot = self:AddComponent(UIBaseContainer, "ShortcutKeyRoot")
  self.compLeftShortcutKeyRedPoint = self:AddComponent(UIBaseComponent, "ShortcutKeyRoot/LeftShortcutKey/LeftShortcutKeyRedPoint")
  self.compRightShortcutKeyRedPoint = self:AddComponent(UIBaseComponent, "ShortcutKeyRoot/RightShortcutKey/RightShortcutKeyRedPoint")
end

local function ComponentDestroy(self)
  self.next_effect_group:RemoveComponents(UIWorkerRankEffectLine)
  self.next_effect_value_line_go:GameObjectRecycleAll()
  self.panel = nil
  self.close_btn = nil
  self.worker_icon = nil
  self.worker_name = nil
  self.power_txt = nil
  self.worker_first_name = nil
  self.effect_content = nil
  self.hero_rank_star = nil
  self.next_effect_group = nil
  self.rank_up_content = nil
  self.view_tip_txt_content = nil
  self.cost_group1 = nil
  self.cost_icon1 = nil
  self.cost_text1 = nil
  self.cost_group2 = nil
  self.cost_icon2 = nil
  self.cost_text2 = nil
  self.rank_up_btn = nil
  self.rank_up_btn_text = nil
  self.view_tip_txt = nil
  self.effectItems = nil
  self.next_effect_group = nil
  self.next_effect_value_line = nil
  self.next_effect_value_line_go:GameObjectRecycleAll()
  self.next_effect_value_line_go = nil
  self.power_effect = nil
  self.talk_content = nil
  self.plot_content = nil
  self.worker_color_bg = nil
  self.point_building_content = nil
  self.point_building_lv = nil
  self.point_building_name = nil
  self.line_content = nil
  self.bottom_content = nil
  self.bottom_empty_content = nil
  self.center_content = nil
  self.content = nil
  self.info_content = nil
  self.btnLeftShortcutKey = nil
  self.btnRightShortcutKey = nil
  self.compShortcutKeyRoot = nil
  self.compLeftShortcutKeyRedPoint = nil
  self.compRightShortcutKeyRedPoint = nil
  self.worker_loading = nil
end

local function DataDefine(self)
  self.workerCfgId = nil
  self.workerData = nil
  self.isShow = nil
  self.rankNum = nil
  self.temp = nil
  self.rankBaseTemp = nil
  self.nextSendMsgTime = 0
  self.rankUpEffectData = {}
  self.effectShowData = {}
  self.showDataList = {}
  self.curIndex = 0
end

local function DataDestroy(self)
  self.workerCfgId = nil
  self.workerData = nil
  self.isShow = nil
  self.rankNum = nil
  self.temp = nil
  self.rankBaseTemp = nil
  self.nextSendMsgTime = nil
  self.rankUpEffectData = nil
  self.effectShowData = nil
  self.showDataList = nil
  self.curIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorkerInfoUpdate, self.GetWorkerInfoUpdateMsg)
  self:AddUIListener(EventId.RefreshItems, self.RefreshItemsMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorkerInfoUpdate, self.GetWorkerInfoUpdateMsg)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemsMsg)
end

local function OnOpen(self)
  self.isShow = self.workerData == nil
  self.temp = DataCenter.WorkerTemplateManager:GetShowTemplateById(self.workerCfgId)
  self.rankNum = 1
  if self.workerData then
    self.rankNum = self.workerData.rank
  end
  if self.temp == nil then
    return
  end
  local imgPath = HeroUtils.GetHeroIconPath(self.temp.appearance, HeroIconType.pose_icon_path)
  local hasAsset = UIUtil.CheckAssetDownloaded(imgPath)
  self.worker_loading:SetActive(not hasAsset)
  self.content:SetAnchoredPositionXY(0, 0)
  local workerIconColor = self.isShow and WorkerBlackColor or 1
  local color = self.worker_icon:GetColor()
  local rgbA = 1
  if color then
    rgbA = color.a
  end
  self.worker_icon:SetColorRGBA(workerIconColor, workerIconColor, workerIconColor, rgbA)
  self.worker_icon:LoadSpriteAuto(imgPath, function(texture)
    if not hasAsset and self and self.worker_loading then
      self.worker_loading:SetActive(false)
    end
    if self and self.worker_icon then
      self.worker_icon:SetNativeSize()
    end
  end)
  self.worker_name:SetLocalText(self.temp.last_name)
  self.worker_first_name:SetLocalText(self.temp.first_name)
  self.worker_color_bg:LoadSprite(self:GetWorkerColorBgPath(self.temp.quality))
  self.info_content:LoadSprite(self:GetWorkerNameBgPath(self.temp.quality))
  if self.isShow then
    self.talk_content:SetActive(false)
    self.point_building_content:SetActive(false)
  elseif self.workerData.dispatchingBuildUid then
    self.talk_content:SetActive(false)
    self.point_building_content:SetActive(true)
    local buildingUuid = self.workerData.dispatchingBuildUid
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildingUuid)
    if buildData then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
      local buildLv = buildData.level
      self.point_building_lv:SetLocalText(GameDialogDefine.LEVEL_NUMBER, buildLv)
      self.point_building_name:SetLocalText(buildTemplate.name)
    end
  else
    self.point_building_content:SetActive(false)
    local talkKey = self.temp.worker_dialog_idle
    if string.IsNullOrEmpty(talkKey) then
      self.talk_content:SetActive(false)
    else
      self.talk_content:SetActive(true)
      self.plot_content:SetAnchoredPositionXY(0, 0)
      self.plot_content:SetLocalText(talkKey)
    end
  end
  if 0 >= self.temp.star then
    self:SetNoRankView()
  else
    self:SetRankView()
  end
end

local function SetNoRankView(self)
  self.hero_rank_star:SetActive(false)
  self.bottom_content:SetActive(false)
  self.bottom_empty_content:SetActive(true)
  self.line_content:SetActive(false)
  self.next_effect_group:SetActive(false)
  self.center_content:SetMinHeight(NoRankWorkerContentHeight)
  self.center_content:SetPreferredHeight(NoRankWorkerContentHeight)
  local powerNum = self.temp.power
  self.power_txt:SetText(powerNum)
  local effectData = {
    {
      id = self.temp.effectData[1],
      curVal = self.temp.effectData[2],
      nextVal = nil
    }
  }
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
      local tipKey = effectLine.worker_hall_desc_worker
      local tipShow = not string.IsNullOrEmpty(tipKey)
      effectItem.tipBtn:SetActive(tipShow)
      effectItem.effectTxt:SetText(effectName)
      effectItem.valueText:SetText(addValue)
      if effectNextVal then
        effectItem.nextValueText:SetActive(true)
        effectItem.arrowIcon:SetActive(true)
        local nextValue = HeroUtils.GetFormattedPropertyValue(effectId, effectNextVal)
        effectItem.nextValueText:SetText(nextValue)
      else
        effectItem.nextValueText:SetActive(false)
        effectItem.arrowIcon:SetActive(false)
      end
    else
      effectItem.root:SetActive(false)
    end
  end
  self.effectShowData = effectData
end

local function SetRankView(self)
  self.hero_rank_star:SetActive(true)
  self.bottom_content:SetActive(true)
  self.bottom_empty_content:SetActive(false)
  self.line_content:SetActive(true)
  self.next_effect_group:SetActive(true)
  self.center_content:SetMinHeight(RankWorkerContentHeight)
  self.center_content:SetPreferredHeight(RankWorkerContentHeight)
  self.rankBaseTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, 1)
  local rankLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum)
  if rankLvTemp == nil then
    return
  end
  local powerNum = self.temp.power + rankLvTemp.power
  self.power_txt:SetText(powerNum)
  local maxRank = self.rankBaseTemp.max_rank
  self.hero_rank_star:SetActive(true)
  self.hero_rank_star:ShowRank(self.rankNum, maxRank)
  self:SetRankViewEffectContent()
  self:SetRankViewRankEffectContent()
  self:SetRankViewBottomContent()
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
  if self.rankNum ~= rankLvTemp.max_rank then
    local rankNextLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum + 1)
    if not self.isShow and rankNextLvTemp then
      local nextEffectData = {}
      table.insert(nextEffectData, self.temp.effectData)
      for k, v in ipairs(rankNextLvTemp.effect_data) do
        table.insert(nextEffectData, v)
      end
      table.insert(nextEffectData, rankNextLvTemp.rank_effect_data)
      for _, data in ipairs(nextEffectData) do
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
          if targetData.nextVal then
            targetData.nextVal = targetData.nextVal + effectVal
          else
            targetData.nextVal = effectVal
          end
        end
      end
    end
  end
  for _, data in ipairs(effectData) do
    if data.curVal == nil then
      data.curVal = 0
    end
    if data.curVal == data.nextVal then
      data.nextVal = nil
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
      local tipKey = effectLine.worker_hall_desc_worker
      local tipShow = not string.IsNullOrEmpty(tipKey)
      effectItem.tipBtn:SetActive(tipShow)
      effectItem.effectTxt:SetText(effectName)
      effectItem.valueText:SetText(addValue)
      if effectNextVal then
        effectItem.nextValueText:SetActive(true)
        effectItem.arrowIcon:SetActive(true)
        local nextValue = HeroUtils.GetFormattedPropertyValue(effectId, effectNextVal)
        effectItem.nextValueText:SetText(nextValue)
      else
        effectItem.nextValueText:SetActive(false)
        effectItem.arrowIcon:SetActive(false)
      end
    else
      effectItem.root:SetActive(false)
    end
  end
  self.effectShowData = effectData
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
        outDesc = effectName .. " " .. addValue
      else
        outDesc = effectName .. " " .. addValue
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

local function SetRankViewBottomContent(self)
  if self.isShow then
    self.rank_up_content:SetActive(false)
    self.view_tip_txt_content:SetActive(true)
    self.view_tip_txt:SetLocalText("worker_detail_desc1")
  else
    local rankLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum)
    if self.rankNum ~= rankLvTemp.max_rank then
      local rankNextLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum + 1)
      if rankNextLvTemp then
        self.rank_up_content:SetActive(true)
        self.view_tip_txt_content:SetActive(false)
        for i = 1, #self.costItems do
          self.costItems[i].cost_group:SetActive(false)
        end
        local goodsData = rankNextLvTemp.rank_goods_data
        local isRankEnough = true
        if #goodsData == 0 then
          isRankEnough = false
        else
          for i, data in ipairs(goodsData) do
            local goodsId = data[1]
            local goodsNum = data[2] or 0
            local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
            if goodsNum > curNum then
              isRankEnough = false
            end
            if self.costItems[i] then
              self.costItems[i].cost_group:SetActive(true)
              local fragIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, goodsId)
              self.costItems[i].cost_icon:LoadSprite(fragIcon)
              if goodsNum <= curNum then
                self.costItems[i].cost_text:SetText(string.format("<color=#5FEF87>%d</color>/%d", curNum, goodsNum))
              else
                self.costItems[i].cost_text:SetText(string.format("<color=#F97077>%d</color>/%d", curNum, goodsNum))
              end
            end
          end
        end
        UIGray.SetGray(self.rank_up_btn.transform, not isRankEnough, true)
      end
    else
      self.rank_up_content:SetActive(false)
      self.view_tip_txt_content:SetActive(true)
      self.view_tip_txt:SetLocalText("worker_detail_desc3")
    end
  end
end

local function RankUpBtnClickFunc(self)
  if self.isShow then
    return
  end
  local rankLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum)
  if rankLvTemp == nil or self.rankNum == rankLvTemp.max_rank then
    return
  end
  local rankNextLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum + 1)
  if rankNextLvTemp == nil then
    return
  end
  local goodsData = rankNextLvTemp.rank_goods_data
  local isRankEnough = true
  local lackIndex = -1
  if #goodsData == 0 then
    isRankEnough = false
  else
    for i, data in ipairs(goodsData) do
      local goodsId = data[1]
      local goodsNum = data[2] or 0
      local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
      if goodsNum > curNum then
        isRankEnough = false
        lackIndex = i
        break
      end
    end
  end
  if isRankEnough then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.nextSendMsgTime then
      SFSNetwork.SendMessage(MsgDefines.UpgradeWorkerStar, self.workerData.uid)
      self.nextSendMsgTime = curTime + sendMsgMaxWaitTime
    end
  else
    local lackData = goodsData[lackIndex]
    if lackData then
      local goodsId = lackData[1]
      local goodsNum = lackData[2] or 0
      local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
      local need = goodsNum - curNum
      LWResourceLackUtil:GotoGoodsItemLack(goodsId, need)
    end
  end
end

local function GetWorkerInfoUpdateMsg(self)
  if self.isShow then
    return
  end
  if self.workerData == nil then
    return
  end
  if self.rankNum == self.workerData.rank then
    return
  end
  self.rankNum = self.workerData.rank
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.nextSendMsgTime = curTime
  for i = 1, effectShowNum do
    local effectItem = self.effectItems[i]
    local effectData = self.rankUpEffectData[i]
    if effectData and effectItem and effectData.nextVal then
      effectItem.effect:SetActive(false)
      effectItem.effect:SetActive(true)
    end
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl == nil then
      return
    end
    self:SetRankViewEffectContent()
    local path = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_shengji_jingyan.prefab"
    local src = self.effect_content.transform.position
    local dest = self.power_txt.transform.position
    local parent = UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform
    DataCenter.FlyController.DoFlyWithBezierFunc(path, src, dest, 0.6, parent, function()
      if self.ctrl then
        for i = 1, effectShowNum do
          self.effectItems[i].effect:SetActive(false)
        end
        self.power_effect:SetActive(false)
        self.power_effect:SetActive(true)
        self.rankNum = self.workerData.rank
        if self.temp.star <= 0 then
          self:SetNoRankView()
        else
          self:SetRankView()
        end
      end
    end)
  end, 0.3)
end

local function RefreshItemsMsg(self)
  if self.isShow then
    return
  end
  if self.workerData == nil then
    return
  end
  if self.temp.star <= 0 then
  else
    self:SetRankViewBottomContent()
  end
end

local function GetWorkerColorBgPath(self, quality)
  local bgName = "FX_XCZ_hui"
  if quality == WorkerQualityType.Legendary then
    bgName = "FX_XCZ_cheng"
  elseif quality == WorkerQualityType.Genius then
    bgName = "FX_XCZ_zi"
  elseif quality == WorkerQualityType.Outstanding then
    bgName = "FX_XCZ_lan"
  elseif quality == WorkerQualityType.Excellent then
    bgName = "FX_XCZ_lv"
  elseif quality == WorkerQualityType.Normal then
    bgName = "FX_XCZ_hui"
  end
  local bgPath = string.format(LoadPath.UIWorkerTexturePath, bgName)
  return bgPath
end

local function GetWorkerNameBgPath(self, quality)
  local bgName = "Mjc_xcz_pinzhi_hui"
  if quality == WorkerQualityType.Legendary then
    bgName = "Mjc_xcz_pinzhi_cheng"
  elseif quality == WorkerQualityType.Genius then
    bgName = "Mjc_xcz_pinzhi_zi"
  elseif quality == WorkerQualityType.Outstanding then
    bgName = "Mjc_xcz_pinzhi_lan"
  elseif quality == WorkerQualityType.Excellent then
    bgName = "Mjc_xcz_pinzhi_lv"
  elseif quality == WorkerQualityType.Normal then
    bgName = "Mjc_xcz_pinzhi_hui"
  end
  local bgPath = string.format(LoadPath.UIWorkerTexturePath, bgName)
  return bgPath
end

local function OnEffectTipBtnClick(self, index)
  if self.effectShowData[index] == nil or self.effectItems[index] == nil then
    return
  end
  local effectId = self.effectShowData[index].id
  local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
  local tipKey = effectLine.worker_hall_desc_worker
  local tipShow = not string.IsNullOrEmpty(tipKey)
  if not tipShow then
    return
  end
  local effectItem = self.effectItems[index]
  local content = Localization:GetString(tipKey)
  UIUtil.ShowBubbleTips(content, effectItem.tipBtn.transform.position, 0, -20, 20)
end

function UIWorkerInfoDetailView:RefreshShortcutShow()
  local isShowShortCutKey = not table.IsNullOrEmpty(self.showDataList)
  self.compShortcutKeyRoot:SetActive(isShowShortCutKey)
  if not isShowShortCutKey then
    return
  end
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
end

function UIWorkerInfoDetailView:RefreshShortcutShowAndContent()
  self.showData = self.showDataList[self.curIndex]
  self.workerCfgId = self.showData.temp.id
  self.workerData = self.showData.data
  self:OnOpen()
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
end

function UIWorkerInfoDetailView:RefreshShortcutKeyState()
  self.btnLeftShortcutKey:SetActive(self.curIndex ~= 1)
  self.btnRightShortcutKey:SetActive(self.curIndex ~= #self.showDataList)
end

function UIWorkerInfoDetailView:RefreshShortcutKeyRedPoint()
  local leftCurIndex = math.max(self.curIndex - 1, 1)
  local leftShowData = self.showDataList[leftCurIndex]
  local isShowLeftRedPoint = self:IsShowRedPoint(leftShowData)
  self.compLeftShortcutKeyRedPoint:SetActive(isShowLeftRedPoint)
  local rightCurIndex = math.min(self.curIndex + 1, #self.showDataList)
  local rightShowData = self.showDataList[rightCurIndex]
  local isShowRightRedPoint = self:IsShowRedPoint(rightShowData)
  self.compRightShortcutKeyRedPoint:SetActive(isShowRightRedPoint)
end

function UIWorkerInfoDetailView:IsShowRedPoint(showData)
  if showData == nil then
    return
  end
  if showData.data == nil or showData.temp.star <= 0 then
    return false
  end
  local maxRank = showData.rankBaseData.max_rank
  if maxRank <= showData.data.rank then
    return false
  end
  local nextRank = showData.data.rank + 1
  local nextRankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(showData.temp.id, nextRank)
  if nextRankTemp then
    local goodsData = nextRankTemp.rank_goods_data
    local isRankEnough = true
    if #goodsData == 0 then
      isRankEnough = false
    else
      for _, data in ipairs(goodsData) do
        local goodsId = data[1]
        local goodsNum = data[2] or 0
        local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
        if goodsNum > curNum then
          isRankEnough = false
          break
        end
      end
    end
    return isRankEnough
  end
  return false
end

function UIWorkerInfoDetailView:OnBtnLeftShortcutKeyClick()
  if table.IsNullOrEmpty(self.showDataList) then
    return
  end
  self.curIndex = math.max(self.curIndex - 1, 1)
  self:RefreshShortcutShowAndContent()
end

function UIWorkerInfoDetailView:OnBtnRightShortcutKeyClick()
  if table.IsNullOrEmpty(self.showDataList) then
    return
  end
  self.curIndex = math.min(self.curIndex + 1, #self.showDataList)
  self:RefreshShortcutShowAndContent()
end

UIWorkerInfoDetailView.OnCreate = OnCreate
UIWorkerInfoDetailView.OnDestroy = OnDestroy
UIWorkerInfoDetailView.OnAddListener = OnAddListener
UIWorkerInfoDetailView.OnRemoveListener = OnRemoveListener
UIWorkerInfoDetailView.ComponentDefine = ComponentDefine
UIWorkerInfoDetailView.DataDefine = DataDefine
UIWorkerInfoDetailView.ComponentDestroy = ComponentDestroy
UIWorkerInfoDetailView.DataDestroy = DataDestroy
UIWorkerInfoDetailView.OnOpen = OnOpen
UIWorkerInfoDetailView.SetNoRankView = SetNoRankView
UIWorkerInfoDetailView.SetRankView = SetRankView
UIWorkerInfoDetailView.SetRankViewEffectContent = SetRankViewEffectContent
UIWorkerInfoDetailView.SetRankViewRankEffectContent = SetRankViewRankEffectContent
UIWorkerInfoDetailView.SetRankViewBottomContent = SetRankViewBottomContent
UIWorkerInfoDetailView.RankUpBtnClickFunc = RankUpBtnClickFunc
UIWorkerInfoDetailView.GetWorkerInfoUpdateMsg = GetWorkerInfoUpdateMsg
UIWorkerInfoDetailView.RefreshItemsMsg = RefreshItemsMsg
UIWorkerInfoDetailView.GetWorkerColorBgPath = GetWorkerColorBgPath
UIWorkerInfoDetailView.GetWorkerNameBgPath = GetWorkerNameBgPath
UIWorkerInfoDetailView.OnEffectTipBtnClick = OnEffectTipBtnClick
return UIWorkerInfoDetailView
