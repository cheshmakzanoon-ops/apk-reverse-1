local UILWSeasonOutpostAttackTab0S6 = BaseClass("UILWSeasonOutpostAttackTab0S6", UIBaseContainer)
local base = UIBaseContainer
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")

function UILWSeasonOutpostAttackTab0S6:OnCreate()
  base.OnCreate(self)
  self:InitData()
  self:UpdateData()
end

function UILWSeasonOutpostAttackTab0S6:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostAttackTab0S6:ReInit()
  self:UpdateData()
end

function UILWSeasonOutpostAttackTab0S6:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostListUpdate, self.UpdateOutpostPos)
  self:AddUIListener(EventId.OutpostRepairInfoUpdate, self.UpdateOutpostPos)
end

function UILWSeasonOutpostAttackTab0S6:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostListUpdate, self.UpdateOutpostPos)
  self:RemoveUIListener(EventId.OutpostRepairInfoUpdate, self.UpdateOutpostPos)
  base.OnRemoveListener(self)
end

function UILWSeasonOutpostAttackTab0S6:InitData()
  self.actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type)
  if self.actData == nil then
    return
  end
  self.dataList = DataCenter.SeasonOutpostManager:CalcPutData()
  self:UpdateOutpostPos(nil, true)
end

function UILWSeasonOutpostAttackTab0S6:UpdateOutpostPos(eventData, checkRepairInfo)
  local dataList = self.dataList
  if dataList == nil then
    return
  end
  local theOutpostPosList = DataCenter.SeasonOutpostManager.theOutpostPosList
  if theOutpostPosList then
    for cityIndex, cityInfo in pairs(theOutpostPosList) do
      local data = dataList[toInt(cityIndex)]
      if data then
        data.cityInfo = cityInfo
      end
      if cityInfo then
        local repairInfo = cityInfo.repairInfo
        if repairInfo == nil or repairInfo.outpostInfo == nil or repairInfo.outpostInfo.state ~= 2 then
          FetchOutpostRepairInfo.GetRepairInfo(cityInfo.serverId, cityInfo.cityId, true, checkRepairInfo == true)
        end
      end
    end
  end
  self:UpdateData()
end

function UILWSeasonOutpostAttackTab0S6:Update1000MS()
  if self.end_time then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.end_time - curTime
    if remainTime < 0 then
      self.end_time = nil
      self:UpdateOutpostPos()
    end
  end
end

function UILWSeasonOutpostAttackTab0S6:UpdateData()
  local dataList = self.dataList
  if dataList == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  for _, theCityData in ipairs(dataList) do
    if theCityData == nil then
    elseif now < theCityData.unlock_time then
      self.tipTxt = "s6_outpost_limit_3"
      self.end_time = theCityData.unlock_time
      break
    elseif now < theCityData.put_start_time then
      self.tipTxt = "season_building_UI102"
      self.end_time = theCityData.put_start_time
      break
    elseif now < theCityData.put_end_time then
      self.tipTxt = "s6_outpost_limit_2"
      self.end_time = theCityData.put_end_time
      break
    elseif now < theCityData.finish_time then
      self.end_time = theCityData.finish_time
    end
  end
  if self.PutOutpost == nil then
    local lua = require("UI.LWSeason6.Outpost.UILWSeasonOutpostMainUIS6.Component.UILWSeasonPutOutpostS6")
    local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/LWSeason6/Outpost/Component/OutpostListS6.prefab"
    self.PutOutpost = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
  end
  self.PutOutpost:SetActive(true)
  self.PutOutpost:Refresh(self.actData, dataList, self.tipTxt, self.end_time)
end

return UILWSeasonOutpostAttackTab0S6
