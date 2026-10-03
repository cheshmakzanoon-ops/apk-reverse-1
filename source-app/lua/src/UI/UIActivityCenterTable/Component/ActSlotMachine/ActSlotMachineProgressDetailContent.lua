local ActSlotMachineProgressDetailContent = BaseClass("ActSlotMachineProgressDetailContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIActSlotProgressItem = require("UI.UIActivityCenterTable.Component.ActSlotMachine.UIActSlotProgressItem")
local detail_progress_bg_path = "maskContent/detaillContent/detailProgressBg"
local detail_progress_img_path = "maskContent/detaillContent/detailProgressBg/detailProgressImg"
local act_slot_machine_progress_item_path = "maskContent/detaillContent/actSlotMachineProgressItem"
local detail_items_path = "maskContent/detaillContent/detailItems"
local progress_txt_path = "maskContent/detaillContent/bg/progressTxt"
local progress_num_path = "maskContent/detaillContent/bg/progressNum"
local progress_back_btn_path = "progressBackBtn"

function ActSlotMachineProgressDetailContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActSlotMachineProgressDetailContent:OnDestroy()
  self:ClearContent()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ActSlotMachineProgressDetailContent:ComponentDefine()
  self.detail_progress_bg = self:AddComponent(UIImage, detail_progress_bg_path)
  self.detail_progress_img = self:AddComponent(UIImage, detail_progress_img_path)
  self.act_slot_machine_progress_item = self:AddComponent(UIBaseContainer, act_slot_machine_progress_item_path)
  self.detail_items = self:AddComponent(UIBaseContainer, detail_items_path)
  self.progress_txt = self:AddComponent(UITextMeshProUGUIEx, progress_txt_path)
  self.progress_num = self:AddComponent(UITextMeshProUGUIEx, progress_num_path)
  self.progress_back_btn = self:AddComponent(UIButton, progress_back_btn_path)
  self.itemList = {}
  self.act_slot_machine_progress_item:SetActive(false)
  self.act_slot_machine_progress_item.gameObject:GameObjectCreatePool()
end

function ActSlotMachineProgressDetailContent:ComponentDestroy()
  self.detail_progress_bg = nil
  self.detail_progress_img = nil
  self.act_slot_machine_progress_item = nil
  self.detail_items = nil
  self.progress_txt = nil
  self.progress_num = nil
  self.progress_back_btn = nil
end

function ActSlotMachineProgressDetailContent:DataDefine()
  self.actId = nil
  self.actinfo = nil
  self.actDetailData = nil
end

function ActSlotMachineProgressDetailContent:DataDestroy()
  self.actId = nil
  self.actinfo = nil
  self.actDetailData = nil
end

function ActSlotMachineProgressDetailContent:SetData(actId, actinfo, actDetailData)
  self.actId = actId
  self.actinfo = actinfo
  self.actDetailData = actDetailData
  self:RefreshView()
end

function ActSlotMachineProgressDetailContent:RefreshView()
  local infoTemp = self.actDetailData.infoTemp
  local scoreRewardData = infoTemp.scoreRewardData
  local scoreRewardShowData = infoTemp.scoreRewardShowData
  local maxNum = scoreRewardData[#scoreRewardData][1]
  local curNum = self.actDetailData.totalScore
  self.progress_num:SetText(string.format("%s/%s", curNum, maxNum))
  local bgSize = self.detail_progress_bg:GetSizeDelta()
  local sizeRate = -1
  for i = 1, #scoreRewardData do
    local preNum = 0
    if 1 < i then
      preNum = scoreRewardData[i - 1][1]
    end
    local curMaxNum = scoreRewardData[i][1]
    if curNum >= preNum and curNum <= curMaxNum then
      sizeRate = (i - 1) / #scoreRewardData + (curNum - preNum) / (curMaxNum - preNum) / #scoreRewardData
      break
    end
  end
  if sizeRate < 0 then
    sizeRate = 1
  end
  self.detail_progress_img:SetSizeDeltaXY(bgSize.x * sizeRate, bgSize.y)
  if #self.itemList ~= #scoreRewardData then
    self:ClearContent()
    local showNum = #scoreRewardData
    if 0 < showNum then
      for i = 1, showNum do
        local showData = scoreRewardData[i]
        local rewardData = scoreRewardShowData[i]
        local item = self.act_slot_machine_progress_item.gameObject:GameObjectSpawn(self.detail_items.transform)
        item.name = i
        local obj = self.detail_items:AddComponent(UIActSlotProgressItem, item.name)
        obj:SetActive(true)
        self.itemList[i] = obj
        obj:SetData(showData, rewardData, i, self.actDetailData)
        obj:SetAnchoredPositionXY(bgSize.x * i / showNum - 10, 0)
      end
    end
  else
    local showNum = #scoreRewardData
    for i = 1, showNum do
      local showData = scoreRewardData[i]
      local rewardData = scoreRewardShowData[i]
      self.itemList[i]:SetData(showData, rewardData, i, self.actDetailData)
    end
  end
end

function ActSlotMachineProgressDetailContent:ClearContent()
  self.detail_items:RemoveComponents(UIActSlotProgressItem)
  for _, v in ipairs(self.detail_items.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.act_slot_machine_progress_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

return ActSlotMachineProgressDetailContent
