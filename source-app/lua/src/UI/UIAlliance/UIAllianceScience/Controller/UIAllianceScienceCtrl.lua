local UIAllianceScienceCtrl = BaseClass("UIAllianceScienceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceScience)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetScienceRowList(self, tab)
  local showList = {}
  local rowList = DataCenter.AllianceScienceDataManager:GetAllianceScienceListByTab(tab)
  if rowList ~= nil then
    table.walk(rowList, function(k, v)
      local position = v.position
      local position_vec = string.split_ss_array(position, ";")
      if #position_vec == 2 then
        local column = tonumber(position_vec[1])
        if showList[column] == nil then
          showList[column] = {}
        end
        table.insert(showList[column], v)
      end
    end)
  end
  return showList
end

local function HasScienceByIdAndLevel(self, id, level)
  local has = false
  local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(id)
  if data ~= nil and level <= data.curLevel then
    has = true
  end
  return has
end

local function GetCurSearchScience(self)
  return DataCenter.AllianceScienceDataManager:GetCurrentSearchScience()
end

local function OnScienceInfoClick(self, scienceData, tab)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScienceInfo, {anim = true}, scienceData, tab)
end

local function GetShowTab(self, autoOpenRecScience, autoOpenScienceId)
  local canUpdateTab = 0
  local canUpdateCellIdx = 0
  local recommendTab = 0
  local recommendCellIdx = 0
  local unLockTab = 0
  local unLockCellIdx = 0
  local hasUpdate = false
  local showRed1 = false
  local showRed2 = false
  for i = 1, AlScienceMaxTab do
    local scienceList = self:GetScienceRowList(i)
    for j = 1, table.count(scienceList) do
      local listData = scienceList[j]
      local hasUnmax = false
      for k = 1, table.count(listData) do
        local data = listData[k]
        if 0 < autoOpenScienceId and autoOpenScienceId == data.id then
          recommendTab = i
          return recommendTab
        end
        local oneSciencedata = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(data.id)
        if oneSciencedata ~= nil and oneSciencedata.curLevel ~= data.max_lv then
          if oneSciencedata.state == 1 then
            recommendTab = i
            recommendCellIdx = j - 1
          end
          if oneSciencedata.currentPro >= oneSciencedata.needPro and canUpdateTab == 0 and canUpdateCellIdx == 0 then
            canUpdateTab = i
            canUpdateCellIdx = j - 1
            if not showRed1 and i == 1 then
              showRed1 = true
            end
            if not showRed2 and i == 2 then
              showRed2 = true
            end
          end
          if not oneSciencedata.isLock and unLockTab == 0 and unLockCellIdx == 0 then
            unLockTab = i
            unLockCellIdx = j - 1
          end
          if not hasUpdate then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            if curTime < oneSciencedata.finishTime then
              hasUpdate = true
            end
          end
        end
      end
    end
  end
  self.hasUpdate = hasUpdate
  if autoOpenRecScience and recommendTab ~= 0 then
    return recommendTab
  end
  if DataCenter.AllianceBaseDataManager:IsR4orR5() and not hasUpdate then
    if canUpdateTab ~= 0 then
      return canUpdateTab
    elseif recommendTab ~= 0 then
      return recommendTab
    elseif unLockTab ~= 0 then
      return unLockTab
    else
      return 1
    end
  elseif recommendTab ~= 0 then
    return recommendTab
  elseif unLockTab ~= 0 then
    return unLockTab
  else
    return 1
  end
end

local function GetHasUpdate(self)
  if self.hasUpdate ~= nil then
    return self.hasUpdate
  else
    return false
  end
end

local function ChangeAutoDonteState(self, isAuto)
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(120173)
    return
  end
  local autoDonteState = isAuto and 1 or 0
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, autoDonteState)
end

UIAllianceScienceCtrl.CloseSelf = CloseSelf
UIAllianceScienceCtrl.Close = Close
UIAllianceScienceCtrl.GetScienceRowList = GetScienceRowList
UIAllianceScienceCtrl.HasScienceByIdAndLevel = HasScienceByIdAndLevel
UIAllianceScienceCtrl.GetCurSearchScience = GetCurSearchScience
UIAllianceScienceCtrl.OnScienceInfoClick = OnScienceInfoClick
UIAllianceScienceCtrl.GetShowTab = GetShowTab
UIAllianceScienceCtrl.GetHasUpdate = GetHasUpdate
UIAllianceScienceCtrl.ChangeAutoDonteState = ChangeAutoDonteState
return UIAllianceScienceCtrl
