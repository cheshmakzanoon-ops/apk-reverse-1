local UIWorkerInfoDetailView = BaseClass("UIWorkerInfoDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource
local LWWorkerRankStar = require("UI.UILWWorker.UIWorkerOverviewList.Component.LWWorkerRankStar")
local UIWorkerRankEffectLine = require("UI.UILWWorker.UIWorkerInfoDetail.Component.UIWorkerRankEffectLine")
local effectShowNum = 4
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "Common_bg_orange/CloseBtn"
local worker_icon_path = "Common_bg_orange/Root/centerContent/infoContent/bg/workerImgContent/workerIcon"
local worker_name_path = "Common_bg_orange/Root/centerContent/infoContent/bg/workerName"
local power_txt_path = "Common_bg_orange/Root/centerContent/infoContent/bg/powerTxt"
local rank_data_content_path = "Common_bg_orange/Root/centerContent/dataContent/rankDataContent"
local effect_content_path = "Common_bg_orange/Root/centerContent/dataContent/effectContent"
local rank_detail_data_content_path = "Common_bg_orange/Root/centerContent/dataContent/rankDetailDataContent"
local hero_rank_star_path = "Common_bg_orange/Root/centerContent/dataContent/rankDataContent/HeroRankStar"
local rank_txt_path = "Common_bg_orange/Root/centerContent/dataContent/rankDataContent/rankTxt"
local content_path = "Common_bg_orange/Root/centerContent/dataContent/rankDetailDataContent/DescLayout/Viewport/Content"
local next_effect_group_path = "Common_bg_orange/Root/centerContent/dataContent/rankDetailDataContent/DescLayout/Viewport/Content/NextEffectGroup"
local rank_up_content_path = "Common_bg_orange/Root/bottomContent/rankUpContent"
local next_effect_value_line_path = "Common_bg_orange/Root/centerContent/dataContent/rankDetailDataContent/DescLayout/Viewport/Content/NextEffectGroup/WorkerNextEffectValueLine"
local view_tip_txt_content_path = "Common_bg_orange/Root/bottomContent/ViewTipTxtContent"
local power_effect_path = "Common_bg_orange/Root/centerContent/infoContent/bg/powerTxt/powerEffect"
local cost_group1_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup1"
local cost_icon1_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup1/CostIcon1"
local cost_text1_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup1/CostText1"
local cost_group2_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup2"
local cost_icon2_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup2/CostIcon2"
local cost_text2_path = "Common_bg_orange/Root/bottomContent/rankUpContent/groupLayOut/CostGroup2/CostText2"
local rank_up_btn_path = "Common_bg_orange/Root/bottomContent/rankUpContent/rankUpBtn"
local rank_up_btn_text_path = "Common_bg_orange/Root/bottomContent/rankUpContent/rankUpBtn/rankUpBtnText"
local view_tip_txt_path = "Common_bg_orange/Root/bottomContent/ViewTipTxtContent/ViewTipTxt"
local sendMsgMaxWaitTime = 5000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.worker_icon = self:AddComponent(UIRawImage, worker_icon_path)
  self.worker_name = self:AddComponent(UIText, worker_name_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.rank_data_content = self:AddComponent(UIBaseContainer, rank_data_content_path)
  self.effect_content = self:AddComponent(UIBaseContainer, effect_content_path)
  self.rank_detail_data_content = self:AddComponent(UIBaseContainer, rank_detail_data_content_path)
  self.hero_rank_star = self:AddComponent(LWWorkerRankStar, hero_rank_star_path)
  self.rank_txt = self:AddComponent(UIText, rank_txt_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
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
      effect = effectItem:AddComponent(UIBaseContainer, "effect")
    }
    self.effectItems[i].effect:SetActive(false)
  end
  self.next_effect_value_line = self:AddComponent(UIBaseContainer, next_effect_value_line_path)
  self.next_effect_value_line:SetActive(false)
  self.next_effect_value_line_go = self.next_effect_value_line.gameObject
  self.next_effect_value_line_go:GameObjectCreatePool()
  self.power_effect = self:AddComponent(UIBaseContainer, power_effect_path)
  self.power_effect:SetActive(false)
end

local function ComponentDestroy(self)
  self.next_effect_group:RemoveComponents(UIWorkerRankEffectLine)
  self.next_effect_value_line_go:GameObjectRecycleAll()
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.worker_icon = nil
  self.worker_name = nil
  self.power_txt = nil
  self.rank_data_content = nil
  self.effect_content = nil
  self.rank_detail_data_content = nil
  self.hero_rank_star = nil
  self.rank_txt = nil
  self.content = nil
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
  self.workerCfgId, self.workerData = self:GetUserData()
  self.isShow = self.workerData == nil
  self.temp = DataCenter.WorkerTemplateManager:GetShowTemplateById(self.workerCfgId)
  self.rankNum = 1
  if self.workerData then
    self.rankNum = self.workerData.rank
  end
  if self.temp == nil then
    return
  end
  self.worker_icon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(self.temp.appearance, HeroIconType.pose_icon_path))
  self.worker_name:SetText(self.temp:GetName())
  self.worker_name:SetColorRGBA(WorkerUtil.GetWorkerNameColor(self.temp.quality))
  if self.temp.star <= 0 then
    self:SetNoRankView()
  else
    self:SetRankView()
  end
end

local function SetNoRankView(self)
  self.rank_data_content:SetActive(false)
  self.rank_detail_data_content:SetActive(false)
  self.rank_up_content:SetActive(false)
  self.view_tip_txt_content:SetActive(false)
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
end

local function SetRankView(self)
  self.rank_data_content:SetActive(true)
  self.rank_detail_data_content:SetActive(true)
  self.rank_up_content:SetActive(false)
  self.view_tip_txt_content:SetActive(false)
  self.rankBaseTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, 1)
  local rankLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum)
  if rankLvTemp == nil then
    return
  end
  local powerNum = self.temp.power + rankLvTemp.power
  self.power_txt:SetText(powerNum)
  local maxRank = self.rankBaseTemp.max_rank
  self.hero_rank_star:ShowRank(self.rankNum, maxRank)
  local rankNum1 = math.floor((self.rankNum - 1) / 5)
  local rankNum2 = (self.rankNum - 1) % 5
  self.rank_txt:SetText(Localization:GetString("worker_ui102", rankNum1, rankNum2))
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

local function SetRankViewBottomContent(self)
  if self.isShow then
    self.view_tip_txt_content:SetActive(false)
  else
    local rankNextLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerCfgId, self.rankNum + 1)
    if rankNextLvTemp then
      self.rank_up_content:SetActive(true)
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
    else
      self.view_tip_txt_content:SetActive(true)
      self.view_tip_txt:SetLocalText("worker_ui105")
    end
  end
end

local function RankUpBtnClickFunc(self)
  if self.isShow then
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
      if self.view then
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
        self.nextSendMsgTime = 0
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
return UIWorkerInfoDetailView
