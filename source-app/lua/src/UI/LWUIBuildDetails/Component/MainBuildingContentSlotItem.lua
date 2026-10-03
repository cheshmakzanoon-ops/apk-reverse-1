local MainBuildingContentSlotItem = BaseClass("MainBuildingContentSlotItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local worker_effect_content_path = "workerEffectContent"
local empty_content_path = "emptyContent"
local worker_cell_path = "workerInfoContent/workerCell"
local u_i_worker_show_cell_path = "workerInfoContent/workerCell/UIWorkerShowCell"
local mask_path = "workerInfoContent/workerCell/mask"
local arrow_img_path = "workerInfoContent/workerCell/arrowImg"
local first_name_path = "workerInfoContent/firstName"
local name_path = "workerInfoContent/name"
local info_txt_path = "workerInfoContent/InfoTxt"
local not_owned_path = "workerInfoContent/notOwned"
local dispatchable_path = "workerInfoContent/dispatchable"
local jump_btn_path = "workerInfoContent/jumpBtn"
local use_btn_path = "workerInfoContent/useBtn"
local effect_item_path = "workerEffectContent/effectItem"
local effectShowNum = 3
local WorkerType = {
  FragNotEnough = 1,
  FragEnough = 2,
  NotUse = 3,
  Use = 4
}

function MainBuildingContentSlotItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function MainBuildingContentSlotItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MainBuildingContentSlotItem:DataDefine()
  self.slot = nil
  self.workerTemp = nil
  self.curBuildIndex = nil
  self.buildingData = nil
  self.buildingTemp = nil
  self.rankBaseTemp = nil
  self.workerData = nil
  self.workerType = nil
  self.maxRankEffectNum = nil
end

function MainBuildingContentSlotItem:DataDestroy()
  self.slot = nil
  self.workerTemp = nil
  self.curBuildIndex = nil
  self.buildingData = nil
  self.buildingTemp = nil
  self.rankBaseTemp = nil
  self.workerData = nil
  self.workerType = nil
  self.maxRankEffectNum = nil
end

function MainBuildingContentSlotItem:ComponentDefine()
  self.worker_effect_content = self:AddComponent(UILayoutElement, worker_effect_content_path)
  self.empty_content = self:AddComponent(UILayoutElement, empty_content_path)
  self.worker_cell = self:AddComponent(UIButton, worker_cell_path)
  self.u_i_worker_show_cell = self:AddComponent(UIWorkerShowCell, u_i_worker_show_cell_path)
  self.mask = self:AddComponent(UIRawImage, mask_path)
  self.arrow_img = self:AddComponent(UIImage, arrow_img_path)
  self.first_name = self:AddComponent(UITextMeshProUGUIEx, first_name_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.info_txt = self:AddComponent(UITextMeshProUGUIEx, info_txt_path)
  self.not_owned = self:AddComponent(UIImage, not_owned_path)
  self.dispatchable = self:AddComponent(UIImage, dispatchable_path)
  self.jump_btn = self:AddComponent(UIButton, jump_btn_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.worker_cell:SetOnClick(function()
    self:OnWorkerCellClick()
  end)
  self.jump_btn:SetOnClick(function()
    self:OnJumpBtnClick()
  end)
  self.use_btn:SetOnClick(function()
    self:OnUseBtnClick()
  end)
  self.effectItems = {}
  for i = 1, effectShowNum do
    local effectItem = self:AddComponent(UIBaseContainer, effect_item_path .. i)
    self.effectItems[i] = {
      root = effectItem,
      infoTxt = effectItem:AddComponent(UITextMeshProUGUI, "infoTxt"),
      valTxt = effectItem:AddComponent(UIText, "valTxt")
    }
    self.effectItems[i].root:SetActive(false)
  end
end

function MainBuildingContentSlotItem:ComponentDestroy()
  self.worker_effect_content = nil
  self.empty_content = nil
  self.worker_cell = nil
  self.u_i_worker_show_cell = nil
  self.mask = nil
  self.arrow_img = nil
  self.first_name = nil
  self.name = nil
  self.info_txt = nil
  self.not_owned = nil
  self.dispatchable = nil
  self.jump_btn = nil
  self.use_btn = nil
  self.effectItems = nil
end

function MainBuildingContentSlotItem:ReInit(slot, workerTemp, curBuildIndex, buildingData, buildingTemp)
  self.slot = slot
  self.workerTemp = workerTemp
  self.curBuildIndex = curBuildIndex
  self.buildingData = buildingData
  self.buildingTemp = buildingTemp
  self:SetExtraData()
  self:RefreshView()
end

function MainBuildingContentSlotItem:SetExtraData()
  self.rankBaseTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerTemp.id, 1)
  local workerUuid = DataCenter.WorkerDataManager:GetWorkerById(self.workerTemp.id)
  self.workerData = nil
  if workerUuid then
    self.workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(workerUuid)
  end
  if not self.workerData then
    local isFragEnough = false
    local fragData = DataCenter.WorkerDataManager:GetFragDataById(self.workerTemp.id)
    if fragData then
      local needNum = fragData.needNum
      local goodsId = fragData.itemCfg.id
      local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
      if needNum <= curNum then
        isFragEnough = true
      end
    end
    if isFragEnough then
      self.workerType = WorkerType.FragEnough
    else
      self.workerType = WorkerType.FragNotEnough
    end
  else
    local isUse = false
    local workerList = self.view.ctrl:GetTrenchDataList(self.curBuildIndex)
    for i, v in ipairs(workerList) do
      if v.type == BuildDisPatchingHeroTrenchState.HERO and v.workerData.uid == self.workerData.uid then
        isUse = true
        break
      end
    end
    if isUse then
      self.workerType = WorkerType.Use
    else
      self.workerType = WorkerType.NotUse
    end
  end
  self.maxRankEffectNum = 0
  local rankNum = self.rankBaseTemp.max_rank
  local rankLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerTemp.id, rankNum)
  local effectData = {}
  local curEffectData = {}
  table.insert(curEffectData, self.workerTemp.effectData)
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
  self.maxRankEffectNum = #effectData
end

function MainBuildingContentSlotItem:RefreshView()
  local oneEffectH = 50
  local contentH = self.maxRankEffectNum * oneEffectH + 2 + 2 + (self.maxRankEffectNum - 1) * 3
  if self.workerType == WorkerType.Use then
    self.worker_effect_content:SetActive(true)
    self.empty_content:SetActive(false)
    self.worker_effect_content:SetMinHeight(contentH)
    self.worker_effect_content:SetPreferredHeight(contentH)
  else
    self.worker_effect_content:SetActive(false)
    self.empty_content:SetActive(true)
    self.empty_content:SetMinHeight(125)
    self.empty_content:SetPreferredHeight(125)
  end
  local rankNum = 1
  if self.workerData then
    rankNum = self.workerData.rank
  end
  self.u_i_worker_show_cell:SetData(self.workerTemp.id, rankNum)
  self.mask:SetActive(self.workerType ~= WorkerType.Use)
  local isRankEnough = true
  if self.workerData then
    local curRank = self.workerData.rank
    local maxRank = self.rankBaseTemp.max_rank
    if curRank < maxRank then
      local nextRankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerTemp.id, curRank + 1)
      local goodsData = nextRankTemp.rank_goods_data
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
    else
      isRankEnough = false
    end
  else
    isRankEnough = false
  end
  self.arrow_img:SetActive(isRankEnough)
  self.first_name:SetLocalText(self.workerTemp.first_name)
  self.name:SetLocalText(self.workerTemp.last_name)
  local descDict = DataCenter.WorkerDataManager:GetVipWorkerDescDict()
  local descKey = descDict[self.workerTemp.id]
  if not string.IsNullOrEmpty(descKey) then
    self.info_txt:SetLocalText(descKey)
  else
    self.info_txt:SetText("")
  end
  self.not_owned:SetActive(self.workerType == WorkerType.FragNotEnough)
  self.dispatchable:SetActive(self.workerType == WorkerType.FragEnough or self.workerType == WorkerType.NotUse)
  if self.workerType == WorkerType.FragNotEnough then
    self.jump_btn:SetActive(true)
    self.use_btn:SetActive(false)
  elseif self.workerType == WorkerType.FragEnough or self.workerType == WorkerType.NotUse then
    self.jump_btn:SetActive(false)
    self.use_btn:SetActive(true)
  else
    self.jump_btn:SetActive(false)
    self.use_btn:SetActive(false)
  end
  if self.workerType == WorkerType.Use then
    local rankNum = self.workerData.rank
    local rankLvTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.workerTemp.id, rankNum)
    local effectData = {}
    local curEffectData = {}
    table.insert(curEffectData, self.workerTemp.effectData)
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
      if effectData[i] then
        local effectId = effectData[i].id
        local effectVal = effectData[i].curVal
        self.effectItems[i].root:SetActive(true)
        local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
        local effectName = Localization:GetString(effectLine.name)
        local addValue = HeroUtils.GetFormattedPropertyValue(effectId, effectVal)
        local showStr = string.format("%s <b>%s</b>", effectName, addValue)
        self.effectItems[i].infoTxt:SetText(showStr)
        self.effectItems[i].valTxt:SetText("")
      else
        self.effectItems[i].root:SetActive(false)
      end
    end
  end
end

function MainBuildingContentSlotItem:OnWorkerCellClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerInfoDetail, {anim = true}, self.workerTemp.id, self.workerData)
end

function MainBuildingContentSlotItem:OnJumpBtnClick()
  local functionUnlock, tip = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
  if not functionUnlock then
    UIUtil.ShowTipsId(tip)
    return
  end
  local targetLevel
  local fragData = DataCenter.WorkerDataManager:GetFragDataById(self.workerTemp.id)
  local goodsId
  if fragData then
    goodsId = tonumber(fragData.itemCfg.id)
  end
  if goodsId == nil then
    return
  end
  local giftPackId, vipLevel = DataCenter.VIPManager:GetVipPackContainsItem(nil, goodsId, nil)
  GoToUtil.CloseAllWindows()
  if giftPackId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, vipLevel)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip)
  end
end

function MainBuildingContentSlotItem:OnUseBtnClick()
  if self.workerType ~= WorkerType.NotUse and self.workerType ~= WorkerType.FragEnough then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(self.curBuildIndex)
  if buildData == nil then
    return
  end
  local firstSlot = self.slot
  local workerList = self.view.ctrl:GetTrenchDataList(self.curBuildIndex)
  local targetSlot
  if workerList and workerList[firstSlot].type == BuildDisPatchingHeroTrenchState.ADD then
    targetSlot = firstSlot
  else
    for i = 1, #workerList do
      if workerList[i].type == BuildDisPatchingHeroTrenchState.ADD then
        targetSlot = i
        break
      end
    end
  end
  if targetSlot == nil then
    targetSlot = self.slot
  end
  if self.workerType == WorkerType.FragEnough then
    local fragData = DataCenter.WorkerDataManager:GetFragDataById(self.workerTemp.id)
    local goodsId
    if fragData then
      goodsId = fragData.itemCfg.id
    end
    if goodsId then
      SFSNetwork.SendMessage(MsgDefines.WorkerExchangeAssign, buildData.uuid, targetSlot - 1, goodsId)
    end
  elseif self.workerType == WorkerType.NotUse then
    SFSNetwork.SendMessage(MsgDefines.BuildAssignHeroMessage, buildData.uuid, targetSlot - 1, self.workerData.uid)
  end
end

return MainBuildingContentSlotItem
