local UIWorkerInfoCell = BaseClass("UIWorkerInfoCell", UIBaseContainer)
local base = UIBaseContainer
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local FullFillImgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_jindutiao_03.png"
local NotFullFillImgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_jindutiao_00.png"
local job_name_path = "AniRoot/Root/InfoPanel/jobName"
local frag_num_content_path = "AniRoot/Root/InfoPanel/fragNumContent"
local frag_num_bg_path = "AniRoot/Root/InfoPanel/fragNumContent/fragNumBg"
local frag_num_img_path = "AniRoot/Root/InfoPanel/fragNumContent/fragNumBg/fragNumImg"
local effect_content_path = "AniRoot/Root/effectContent"
local state_icon_path = "AniRoot/Root/InfoPanel/stateIcon"

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
  self.showData = nil
end

local function DataDestroy(self)
  self.showData = nil
end

local function ComponentDefine(self)
  self.rootNode = self:AddComponent(UIBaseContainer, "AniRoot/Root")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.upLevel = self:AddComponent(UIBaseContainer, "AniRoot/Root/InfoPanel/UpLevel")
  self.blackMask = self:AddComponent(UIBaseContainer, "AniRoot/Root/InfoPanel/blackMask")
  self.uiWorkerShowCell = self:AddComponent(UIWorkerShowCell, "AniRoot/Root/InfoPanel/UIWorkerShowCell")
  self.imgNew = self:AddComponent(UIBaseContainer, "AniRoot/Root/InfoPanel/ImgNew")
  self.fragNumText = self:AddComponent(UITextMeshProUGUIEx, "AniRoot/Root/InfoPanel/fragNumText")
  self.redPoint = self:AddComponent(UIBaseContainer, "AniRoot/Root/InfoPanel/redPoint")
  self.infoPanel = self:AddComponent(UIBaseContainer, "AniRoot/Root/InfoPanel")
  self.frag_num_content = self:AddComponent(UIBaseContainer, frag_num_content_path)
  self.frag_num_bg = self:AddComponent(UIImage, frag_num_bg_path)
  self.frag_num_img = self:AddComponent(UIImage, frag_num_img_path)
  self.job_name = self:AddComponent(UITextMeshProUGUIEx, job_name_path)
  self.effect_content = self:AddComponent(UIBaseContainer, effect_content_path)
  self.state_icon = self:AddComponent(UIImage, state_icon_path)
end

local function ComponentDestroy(self)
  self.rootNode = nil
  self.btn = nil
  self.upLevel = nil
  self.uiWorkerShowCell = nil
  self.imgNew = nil
  self.fragNumText = nil
  self.redPoint = nil
  self.infoPanel = nil
  self.frag_num_content = nil
  self.frag_num_bg = nil
  self.frag_num_img = nil
  self.job_name = nil
  self.effect_content = nil
  self.state_icon = nil
end

local function SetData(self, showData, showDataList, index)
  if showData then
    self.showData = showData
  else
    self.showDataList = showDataList or {}
    self.curIndex = index or 0
    self.showData = showDataList[index]
  end
  self.upLevel:SetActive(false)
  if self.showData.data and 0 < self.showData.temp.star then
    local maxRank = self.showData.rankBaseData.max_rank
    if maxRank > self.showData.data.rank then
      local nextRank = self.showData.data.rank + 1
      local nextRankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.showData.temp.id, nextRank)
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
        self.upLevel:SetActive(isRankEnough)
      end
    end
  end
  local rank = 1
  if self.showData.data then
    rank = self.showData.data.rank
  end
  if self.showData.data then
    self.blackMask:SetActive(false)
    self.uiWorkerShowCell:SetData(self.showData.temp.id, rank)
    local isNew = DataCenter.WorkerDataManager:IsHaveNewTag(self.showData.data.uid)
    self.imgNew:SetActive(isNew)
    self.fragNumText:SetText("")
    self.frag_num_content:SetActive(false)
    self.redPoint:SetActive(false)
    local isWorking = self.showData.data.dispatchingBuildUid ~= nil
    self.state_icon:SetActive(isWorking)
  else
    self.blackMask:SetActive(true)
    self.redPoint:SetActive(false)
    local fragData = DataCenter.WorkerDataManager:GetFragDataById(self.showData.temp.id)
    self.uiWorkerShowCell:SetData(self.showData.temp.id, rank, fragData == nil)
    self.imgNew:SetActive(false)
    self.state_icon:SetActive(false)
    if fragData then
      local needNum = fragData.needNum
      local goodsId = fragData.itemCfg.id
      local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
      self.fragNumText:SetText(string.format("%d/%d", curNum, needNum))
      self.frag_num_content:SetActive(true)
      local bgSize = self.frag_num_bg:GetSizeDelta()
      local numProgress = curNum / needNum
      if 1 <= numProgress then
        numProgress = 1
      end
      self.frag_num_img:SetSizeDeltaXY(bgSize.x * numProgress, bgSize.y - 2)
      local imgPath = NotFullFillImgPath
      if needNum <= curNum then
        self.blackMask:SetActive(true)
        self.redPoint:SetActive(true)
        imgPath = FullFillImgPath
      end
      self.frag_num_img:LoadSprite(imgPath)
    else
      self.fragNumText:SetText("")
      self.frag_num_content:SetActive(false)
    end
  end
  self.job_name:SetLocalText(self.showData.temp.first_name)
  self:SetNormalView()
end

local function OnBtnClick(self)
  local workerCfgId = self.showData.temp.id
  local workerData = self.showData.data
  if workerData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerInfoDetail, {anim = true}, workerCfgId, workerData, self.showDataList, self.curIndex)
    local isNew = DataCenter.WorkerDataManager:IsHaveNewTag(workerData.uid)
    if isNew then
      DataCenter.WorkerDataManager:RemoveNewTag(workerData.uid)
      self.imgNew:SetActive(false)
    end
  else
    local unlockItem = -1
    local isCanUnlock = false
    local fragData = DataCenter.WorkerDataManager:GetFragDataById(workerCfgId)
    if fragData then
      local needNum = fragData.needNum
      local goodsId = fragData.itemCfg.id
      local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
      if needNum <= curNum then
        isCanUnlock = true
        unlockItem = goodsId
      end
    end
    if isCanUnlock then
      SFSNetwork.SendMessage(MsgDefines.WorkerExchange, unlockItem)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerInfoDetail, {anim = true}, workerCfgId, workerData, self.showDataList, self.curIndex)
    end
  end
end

local function SetNormalView(self)
  self.effect_content:SetActive(false)
end

local function PlayOpenCardAni(self)
  self.effect_content:SetActive(false)
  self.effect_content:SetActive(true)
end

UIWorkerInfoCell.OnCreate = OnCreate
UIWorkerInfoCell.OnDestroy = OnDestroy
UIWorkerInfoCell.DataDefine = DataDefine
UIWorkerInfoCell.DataDestroy = DataDestroy
UIWorkerInfoCell.ComponentDefine = ComponentDefine
UIWorkerInfoCell.ComponentDestroy = ComponentDestroy
UIWorkerInfoCell.SetData = SetData
UIWorkerInfoCell.OnBtnClick = OnBtnClick
UIWorkerInfoCell.SetNormalView = SetNormalView
UIWorkerInfoCell.PlayOpenCardAni = PlayOpenCardAni
UIWorkerInfoCell.PlayOpenCardAni = PlayOpenCardAni
return UIWorkerInfoCell
