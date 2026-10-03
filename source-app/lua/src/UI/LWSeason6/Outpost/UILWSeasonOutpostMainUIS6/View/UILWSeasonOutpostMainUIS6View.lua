local UILWSeasonOutpostMainUIS6View = BaseClass("UILWSeasonOutpostMainUIS6View", UIBaseView)
local base = UIBaseView
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")
local content_path = "Root/Container/Content"
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"

function UILWSeasonOutpostMainUIS6View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
  self:UpdateData()
end

function UILWSeasonOutpostMainUIS6View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostMainUIS6View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostListUpdate, self.UpdateOutpostPos)
end

function UILWSeasonOutpostMainUIS6View:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostListUpdate, self.UpdateOutpostPos)
  base.OnRemoveListener(self)
end

function UILWSeasonOutpostMainUIS6View:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.text_title:SetLocalText("war_zone_outpost_1")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UILWSeasonOutpostMainUIS6View:ComponentDestroy()
  self.content = nil
  self.text_title = nil
  self.btn_back = nil
end

function UILWSeasonOutpostMainUIS6View:InitData()
  self.actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type)
  if self.actData == nil then
    return
  end
  self.dataList = DataCenter.SeasonOutpostManager:CalcPutData()
  self:UpdateOutpostPos()
end

function UILWSeasonOutpostMainUIS6View:UpdateOutpostPos()
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
    end
  end
  self:UpdateData()
end

function UILWSeasonOutpostMainUIS6View:Update1000MS()
  if self.end_time then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.end_time - curTime
    if remainTime < 0 then
      self.end_time = nil
      self:UpdateOutpostPos()
    end
  end
end

function UILWSeasonOutpostMainUIS6View:UpdateData()
  local dataList = self.dataList
  if dataList == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local theCityData
  local showFixUI = false
  for i = 1, 4 do
    theCityData = dataList[i]
    if now < theCityData.put_start_time then
      self.tipTxt = "s6_outpost_limit_3"
      self.end_time = theCityData.put_start_time
      break
    elseif now < theCityData.put_end_time then
      self.tipTxt = "s6_outpost_limit_2"
      self.end_time = theCityData.put_end_time
      break
    elseif now < theCityData.finish_time then
      self.end_time = theCityData.finish_time
      if theCityData.cityInfo ~= nil and theCityData.cityInfo.repairInfo ~= nil and theCityData.cityInfo.repairInfo.outpostInfo ~= nil and theCityData.cityInfo.repairInfo.outpostInfo.state == 0 then
        showFixUI = true
        break
      end
    end
  end
  if theCityData.cityInfo ~= nil and theCityData.cityInfo.repairInfo ~= nil and theCityData.cityInfo.repairInfo.outpostInfo ~= nil and theCityData.cityInfo.repairInfo.outpostInfo.state == 0 then
    showFixUI = true
  end
  if showFixUI then
    if self.PutOutpost ~= nil then
      self.PutOutpost:SetActive(false)
    end
    if self.FixOutpost == nil then
      local lua = require("UI.LWSeason6.Outpost.UILWSeasonOutpostMainUIS6.Component.UILWSeasonFixOutpostS6")
      local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/LWSeason6/Outpost/Component/OutpostFixS6.prefab"
      self.FixOutpost = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
    end
    self.FixOutpost:SetActive(true)
    self.FixOutpost:Refresh(theCityData.index, self.actData, theCityData.cityInfo, dataList)
    self.btn_back:SetActive(false)
  else
    if self.FixOutpost ~= nil then
      self.FixOutpost:SetActive(false)
    end
    if self.PutOutpost == nil then
      local lua = require("UI.LWSeason6.Outpost.UILWSeasonOutpostMainUIS6.Component.UILWSeasonPutOutpostS6")
      local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/LWSeason6/Outpost/Component/OutpostListS6.prefab"
      self.PutOutpost = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
    end
    self.PutOutpost:SetActive(true)
    self.PutOutpost:Refresh(self.actData, dataList, self.tipTxt, self.end_time)
    self.btn_back:SetActive(true)
  end
end

return UILWSeasonOutpostMainUIS6View
