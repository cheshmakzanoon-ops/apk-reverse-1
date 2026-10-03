local UIActSlotMachineRecordLogItem = BaseClass("UIActSlotMachineRecordLogItem", UIBaseContainer)
local base = UIBaseContainer
local UIActSlotMachineRecordLogLotteryItem = require("UI.UIActSlotMachine.UIActSlotMachineRecord.Component.UIActSlotMachineRecordLogLotteryItem")
local UIActSlotMachineRecordLogBoxItem = require("UI.UIActSlotMachine.UIActSlotMachineRecord.Component.UIActSlotMachineRecordLogBoxItem")
local top_txt_path = "topTxt"
local time_txt_path = "TimeTxt"
local draw_rate_item_path = "drawRateItem"
local box_reward_item_path = "boxRewardItem"
local reward_num_path = "boxRewardItem/rewardNum"
local reward_item1_path = "boxRewardItem/rewardContent/rewardItem1"
local reward_item2_path = "boxRewardItem/rewardContent/rewardItem2"
local reward_item3_path = "boxRewardItem/rewardContent/rewardItem3"
local bgPath = "bg"

function UIActSlotMachineRecordLogItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActSlotMachineRecordLogItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActSlotMachineRecordLogItem:ComponentDefine()
  self.top_txt = self:AddComponent(UITextMeshProUGUIEx, top_txt_path)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.draw_rate_item = self:AddComponent(UIActSlotMachineRecordLogLotteryItem, draw_rate_item_path)
  self.box_reward_item = self:AddComponent(UIBaseContainer, box_reward_item_path)
  self.reward_num = self:AddComponent(UITextMeshProUGUIEx, reward_num_path)
  self.reward_item1 = self:AddComponent(UIActSlotMachineRecordLogBoxItem, reward_item1_path)
  self.reward_item2 = self:AddComponent(UIActSlotMachineRecordLogBoxItem, reward_item2_path)
  self.reward_item3 = self:AddComponent(UIActSlotMachineRecordLogBoxItem, reward_item3_path)
  self.reward_item_list = {
    self.reward_item1,
    self.reward_item2,
    self.reward_item3
  }
  self.bg = self:AddComponent(UIImage, bgPath)
end

function UIActSlotMachineRecordLogItem:ComponentDestroy()
  self.top_txt = nil
  self.time_txt = nil
  self.draw_rate_item = nil
  self.box_reward_item = nil
  self.reward_num = nil
  self.reward_item1 = nil
  self.reward_item2 = nil
  self.reward_item3 = nil
  self.reward_item_list = nil
  self.bg = nil
end

function UIActSlotMachineRecordLogItem:DataDefine()
end

function UIActSlotMachineRecordLogItem:DataDestroy()
end

function UIActSlotMachineRecordLogItem:SetData(activityId, param)
  self.activityId = activityId
  self.param = param
  local timeStr = DataCenter.ActSlotMachineDataManager:GetServerTimeHMSStr(self.param.createTime * 1000)
  self.time_txt:SetText(timeStr)
  if self.param.type == 1 then
    self.draw_rate_item:SetActive(true)
    self.box_reward_item:SetActive(false)
    self.draw_rate_item:SetData(self.param)
    local topTxtKey = "slot_record_desc1"
    if 1 < self.param.num then
      topTxtKey = "slot_record_desc2"
    end
    self.top_txt:SetLocalText(topTxtKey)
  elseif self.param.type == 2 then
    self.draw_rate_item:SetActive(false)
    self.box_reward_item:SetActive(true)
    self.top_txt:SetLocalText("slot_record_desc3")
    self.reward_num:SetText(self.param.cur .. "/" .. self.param.total)
    local reward = self.param.reward
    for i, item in ipairs(self.reward_item_list) do
      if i <= #reward then
        item:SetActive(true)
        item:SetData(reward[i], self.param.num)
      else
        item:SetActive(false)
      end
    end
  end
  self:RefreshBg()
end

function UIActSlotMachineRecordLogItem:RefreshBg()
  local isUse = DataCenter.ActFestivalPopUpManager:CheckActFestivalUseNewSkin(self.activityId, UIWindowNames.UIActSlotMachineRecordCommon)
  if isUse then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    local festivalInterfaceCfgId = activityInfo:GetFestivalInterfaceCfgId()
    local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
    if lineData == nil then
      Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
      return
    end
    local boardBg = lineData.board_list_di
    local imageList = string.split(boardBg, "|")
    if table.length(imageList) == 2 then
      local imagePath = imageList[1]
      local colorArr = imageList[2]
      local colorList = string.split(colorArr, ",")
      if table.length(colorList) == 4 then
        self.bg:LoadSprite(imagePath)
        self.bg:SetColorRGBA255(colorList[1], colorList[2], colorList[3], colorList[4])
      end
    end
  end
end

return UIActSlotMachineRecordLogItem
