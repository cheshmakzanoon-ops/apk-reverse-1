local UIAllianceScienceInfoCtrl = BaseClass("UIAllianceScienceInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceScienceInfo)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function HasScienceByIdAndLevel(self, id, level)
  local has = false
  local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(id)
  if data ~= nil and level <= data.curLevel then
    has = true
  end
  return has
end

local function GetScienceDataById(self, id)
  local showData = {}
  showData.scienceId = id
  local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(id)
  local level = data == nil and 0 or data.curLevel
  local template = DataCenter.AllianceScienceTemplateManager:GetAlScienceTemplate(id + level)
  if data ~= nil and template ~= nil then
    showData.icon = template.icon
    showData.name = template.name
    showData.curLevel = data.curLevel
    showData.maxLevel = template.max_lv
    showData.recommend = data.state == 1
    showData.des = template.description
    showData.nextLevel = -1
    showData.desList = {}
    local oneData = {}
    oneData.lineActive = false
    oneData.desName = Localization:GetString("390003")
    if template.show == 1 then
      oneData.curValue = template.effectNum .. "%"
    else
      oneData.curValue = string.GetFormattedSeperatorNum(template.effectNum)
    end
    if template.max_lv - data.curLevel >= 1 then
      showData.nextLevel = data.curLevel + 1
      local addEffect = template.effectNum
      local addValue = "+" .. tonumber(addEffect) - tonumber(template.effectNum)
      if template.show == 1 then
        addValue = addValue .. "%"
      else
        addValue = string.GetFormattedSeperatorNum(addValue)
      end
      oneData.addValue = addValue
    else
      oneData.addValue = ""
    end
    table.insert(showData.desList, oneData)
    showData.currentPro = data.currentPro
    showData.maxProNum = template.maxProNum
    showData.contribution = template.contribution
    showData.expAdd = template.expAdd
    showData.useNum = DataCenter.AllianceScienceDataManager:GetResDonateRestCount()
    showData.maxNum = DataCenter.AllianceScienceDataManager:GetResDonateMaxCount()
    showData.maxGoldNum = DataCenter.AllianceScienceDataManager:GetGoldDonateMaxCount()
    showData.useGoldNum = DataCenter.AllianceScienceDataManager:GetGoldDonateRestCount()
    showData.timePoint = DataCenter.AllianceScienceDataManager:GetTimePoint()
    showData.refreshTimeBlock = DataCenter.AllianceScienceDataManager:GetRefreshTimeBlock()
    showData.resType = data.res
    showData.resNum = data.resNum
    showData.goldNum = data.goldNum
    showData.canDonate = false
    showData.isResearching = false
    showData.canResearch = false
    local unLock = true
    showData.needScienceList = {}
    if template.condition ~= nil then
      for k, v in ipairs(template.condition) do
        if self:HasScienceByIdAndLevel(v.scienceId, v.level) == false then
          unLock = false
          local needTemplate = DataCenter.AllianceScienceTemplateManager:GetAlScienceTemplate(v.scienceId + v.level)
          if needTemplate ~= nil then
            local needScience = {}
            needScience.icon = needTemplate.icon
            needScience.scienceId = v.scienceId
            needScience.scienceLv = v.level
            needScience.scienceName = needTemplate.name
            table.insert(showData.needScienceList, needScience)
          end
        end
      end
    end
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    showData.finishTime = data.finishTime
    showData.startTime = data.startTime
    showData.isResearching = curTime < data.finishTime
    showData.canDonate = data.currentPro < template.maxProNum and unLock and showData.isResearching == false
    showData.canResearch = data.currentPro >= template.maxProNum and unLock and isR4orR5 and showData.nextLevel > -1 and showData.isResearching == false
    showData.canRecommend = isR4orR5
    if 0 > showData.nextLevel and unLock and showData.isResearching == false then
      showData.noReason = Localization:GetString("120174")
    elseif isR4orR5 == false and data.currentPro >= template.maxProNum and unLock and showData.isResearching == false then
      showData.noReason = Localization:GetString("390258")
    else
      showData.noReason = ""
    end
  end
  return showData
end

local function GetScienceDetailListById(self, id)
  local showData = {}
  showData.titleData = {}
  showData.titleData.name1 = Localization:GetString(GameDialogDefine.LEVEL)
  showData.titleData.name2 = Localization:GetString("390003")
  showData.levelDetailList = {}
  local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(id)
  local level = data == nil and 0 or data.curLevel
  local template = DataCenter.AllianceScienceTemplateManager:GetAlScienceTemplate(id + level)
  if data ~= nil and template ~= nil then
    local maxLv = template.max_lv
    for i = 1, maxLv do
      local oneData = {}
      oneData.name1 = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, i)
      local addEffect = template.effectNum
      if template.show == 1 then
        addEffect = addEffect .. "%"
      else
        addEffect = string.GetFormattedSeperatorNum(addEffect)
      end
      oneData.name2 = addEffect
      table.insert(showData.levelDetailList, oneData)
    end
  end
  return showData
end

local function OnResDonateClick(self, scienceId, resType, resNum, btnPos, techPointPos)
  local cnt = LuaEntry.Resource:GetCntByResType(resType)
  if resNum > cnt then
    UIUtil.ShowTipsId(120020)
    local data = {}
    table.insert(data, {resType = resType, need = resNum})
    LWResourceLackUtil:GotoResLack(data)
    return false
  else
    if resType == ResourceType.Wood then
      local donateNum = DataCenter.AllianceScienceDataManager:GetResDonateRestCount()
      if donateNum <= 0 then
        UIUtil.ShowTipsId(120471)
        return false
      end
    end
    SFSNetwork.SendMessage(MsgDefines.AlScienceDonate, scienceId, 1, btnPos, techPointPos)
    return true
  end
end

local function OnGoldDonateClick(self, scienceId, goldNum, btnPos, techPointPos)
  local cnt = LuaEntry.Player.gold
  if goldNum > cnt then
    UIUtil.ShowTipsId(120027)
  else
    SFSNetwork.SendMessage(MsgDefines.AlScienceGoldDonate, scienceId, btnPos, techPointPos)
  end
end

local function ChanceRecommendState(self, scienceId, state)
  local recommend = 0
  if state then
    recommend = 1
  end
  for i = 1, AlScienceMaxTab do
    local showList = {}
    local rowList = DataCenter.AllianceScienceDataManager:GetAllianceScienceListByTab(i)
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
    for j = 1, table.count(showList) do
      local listData = showList[j]
      for k = 1, table.count(listData) do
        local data = listData[k]
        local oneSciencedata = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(data.id)
        if oneSciencedata ~= nil then
          oneSciencedata.state = oneSciencedata.scienceId == scienceId and recommend or 0
        end
      end
    end
  end
  SFSNetwork.SendMessage(MsgDefines.AlScienceRecommend, scienceId, recommend)
end

local function OnResearchClick(self, scienceId)
  local Researching = DataCenter.AllianceScienceDataManager:GetCurrentSearchScience()
  if Researching ~= nil then
    UIUtil.ShowTipsId(390462)
  else
    SFSNetwork.SendMessage(MsgDefines.AlScienceResearch, scienceId)
    self:CloseSelf()
  end
end

local function GotoScience(self, scienceId, name)
  self:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScienceInfo, scienceId, name)
end

UIAllianceScienceInfoCtrl.CloseSelf = CloseSelf
UIAllianceScienceInfoCtrl.Close = Close
UIAllianceScienceInfoCtrl.GetScienceDataById = GetScienceDataById
UIAllianceScienceInfoCtrl.GetScienceDetailListById = GetScienceDetailListById
UIAllianceScienceInfoCtrl.HasScienceByIdAndLevel = HasScienceByIdAndLevel
UIAllianceScienceInfoCtrl.OnResDonateClick = OnResDonateClick
UIAllianceScienceInfoCtrl.OnGoldDonateClick = OnGoldDonateClick
UIAllianceScienceInfoCtrl.ChanceRecommendState = ChanceRecommendState
UIAllianceScienceInfoCtrl.OnResearchClick = OnResearchClick
UIAllianceScienceInfoCtrl.GotoScience = GotoScience
return UIAllianceScienceInfoCtrl
