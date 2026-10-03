local UILWSeasonPutOutpostS6 = BaseClass("UILWSeasonPutOutpostS6", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local OutpostNode = require("UI.LWSeason6.Outpost.UILWSeasonOutpostMainUIS6.Component.UILWSeasonOutpostNodeS6")
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
local tips_path = "tips"
local title_text_path = "TopBar/TitleText"
local btn_info_path = "TopBar/BtnInfo"
local btn_info_text_path = "TopBar/BtnInfo/BtnInfoText"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local tick_path = "TopBar/Tick"
local tick_time_path = "TopBar/Tick/bg/TickTime"
local outpost1_path = "ScrollView/Viewport/Content/Outpost1"
local outpost2_path = "ScrollView/Viewport/Content/Outpost2"
local outpost3_path = "ScrollView/Viewport/Content/Outpost3"
local outpost4_path = "ScrollView/Viewport/Content/Outpost4"

function UILWSeasonPutOutpostS6:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self.count_tips = self:AddComponent(UITextMeshProUGUIEx, "TopBar/GameObject/CountTips")
  self.tickRoot2 = self:AddComponent(UIImage, tick_path)
  self.tickTime2 = self:AddComponent(UITextMeshProUGUIEx, tick_time_path)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info_text = self:AddComponent(UITextMeshProUGUIEx, btn_info_text_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.outpost1 = self:AddComponent(OutpostNode, outpost1_path)
  self.outpost2 = self:AddComponent(OutpostNode, outpost2_path)
  self.outpost3 = self:AddComponent(OutpostNode, outpost3_path)
  self.outpost4 = self:AddComponent(OutpostNode, outpost4_path)
  self.btn_info:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600009}
    })
  end)
  self.tips_text:SetLocalText("s6_outpost_limit_19")
  self.btn_info_text:SetLocalText("war_zone_outpost_93")
  self.scroll_view:SetVerticalNormalizedPosition(1)
end

function UILWSeasonPutOutpostS6:OnDestroy()
  self.count_tips = nil
  self.tickTime2 = nil
  self.tickRoot2 = nil
  self.tips_text = nil
  self.title_text = nil
  self.btn_info = nil
  self.scroll_view = nil
  self.content = nil
  self.outpost1 = nil
  self.outpost2 = nil
  self.outpost3 = nil
  self.outpost4 = nil
  self.btn_info_text = nil
  base.OnDestroy(self)
end

function UILWSeasonPutOutpostS6:Refresh(actData, dataList, tipTxtStrKey, end_time)
  self.actData = actData
  self.dataList = dataList
  self.tipTxtStrKey = tipTxtStrKey
  self.end_time = actData.endTime
  local now = UITimeManager:GetInstance():GetServerTime()
  for _, theCityData in ipairs(dataList) do
    if theCityData == nil then
    elseif now < theCityData.put_start_time then
      self.put_start_time = theCityData.put_start_time
      self.put_end_time = theCityData.put_end_time
      break
    elseif now < theCityData.put_end_time then
      self.put_start_time = theCityData.put_start_time
      self.put_end_time = theCityData.put_end_time
      break
    end
  end
  self:UpdateData()
end

function UILWSeasonPutOutpostS6:UpdateData()
  if self.actData and self.dataList and self:AsyncLoadDone() then
    self.title_text:SetLocalText("s6_outpost_repari_howtoplay_title")
    if self.end_time then
      self.tickRoot2:SetActive(true)
      self:Update1000MS()
    else
      self.tickTime2:SetText("")
      self.tickRoot2:SetActive(false)
    end
    local now_put_data, next_put_data
    local now = UITimeManager:GetInstance():GetServerTime()
    local put_count = 0
    local step_index = 1
    local show_fix_time = false
    for i, data in ipairs(self.dataList) do
      local outpost = self["outpost" .. i]
      if outpost then
        outpost:Refresh(self.actData, data, self.dataList)
      end
      local cityInfo = data.cityInfo
      if cityInfo ~= nil then
        put_count = put_count + 1
      end
      if cityInfo == nil and now_put_data == nil then
        now_put_data = data
      elseif now >= data.put_start_time and now < data.put_end_time then
        if now_put_data == nil then
          now_put_data = data
        end
      elseif now < data.put_start_time and next_put_data == nil then
        next_put_data = data
      end
      if now >= data.unlock_time and now < data.finish_time then
        step_index = i
      end
      if cityInfo then
        local repairInfo = cityInfo.repairInfo
        if repairInfo == nil or repairInfo.outpostInfo == nil or repairInfo.outpostInfo.state == 0 then
          show_fix_time = true
        end
      end
    end
    self.put_count = put_count
    self.step_index = step_index
    self.cur_put_data = now_put_data or next_put_data
    if self.scroll_view ~= nil and self.content ~= nil and self.cur_put_data ~= nil and self.cur_put_data.index ~= nil then
      if self.cur_put_data.index > 2 then
        self.scroll_view:SetVerticalNormalizedPosition(0)
      else
        self.scroll_view:SetVerticalNormalizedPosition(1)
      end
    end
    if show_fix_time then
      local canRepairCount = 0
      if self.actData then
        canRepairCount = toInt(self.actData.para_4)
      end
      local repairCount = FetchOutpostRepairInfo.GetTodayRepairCount()
      local msgRepair = Localization:GetString("140403", canRepairCount - repairCount)
      local msgPut = Localization:GetString("s6_outpost_limit_19")
      self.tips_text:SetText(msgRepair .. "\n" .. msgPut)
    else
      self.tips_text:SetLocalText("s6_outpost_limit_19")
    end
    self:Update1000MS()
  end
end

function UILWSeasonPutOutpostS6:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.end_time then
    local remainTime = self.end_time - curTime
    if 0 < remainTime then
      self.tickTime2:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.tickRoot2:SetActive(false)
      self.end_time = nil
    end
  end
  if self.cur_put_data ~= nil then
    local msg = Localization:GetString("s6_outpost_limit_1", self.step_index, 4)
    if self.put_start_time == nil then
      self.count_tips:SetText(msg)
    elseif curTime < self.put_start_time then
      local remainTime = self.put_start_time - curTime
      local msg2 = Localization:GetString("s6_outpost_limit_16", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.count_tips:SetText(msg .. "\n" .. msg2)
    elseif curTime < self.put_end_time then
      local remainTime = self.put_end_time - curTime
      local msg2 = Localization:GetString("s6_outpost_limit_17", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.count_tips:SetText(msg .. "\n" .. msg2)
    else
      self.count_tips:SetText(msg)
    end
  else
    self.count_tips:SetLocalText("s6_outpost_limit_1", 4, 4)
  end
end

return UILWSeasonPutOutpostS6
