local UIMainActivityGroupItemBtn = BaseClass("UIMainActivityGroupItemBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local icon_path = "icon"
local timeText_path = "TimeText"
local redPoint_path = "RedPoint"
local redPointTxt_path = "RedPoint/RedPointTxt"
local effect_content_path = "effectContent"

function UIMainActivityGroupItemBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainActivityGroupItemBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainActivityGroupItemBtn:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.nameText = self:AddComponent(UIText, timeText_path)
  self.redPoint = self:AddComponent(UIBaseContainer, redPoint_path)
  self.redPointTxt = self:AddComponent(UIText, redPointTxt_path)
  self.nameText:SetText("")
  self.effect_content = self:AddComponent(UIVfx, effect_content_path)
end

function UIMainActivityGroupItemBtn:ComponentDestroy()
  self.btn = nil
  self.icon = nil
  self.nameText = nil
  self.redPoint = nil
  self.redPointTxt = nil
  self.firstActId = nil
  self.isGroupAct = nil
  self.effect_content = nil
end

function UIMainActivityGroupItemBtn:DataDefine()
  self.groupId = nil
  self.actList = nil
  self.clickFunc = nil
  self.firstActId = nil
  self.isGroupAct = nil
end

function UIMainActivityGroupItemBtn:DataDestroy()
  self.groupId = nil
  self.actList = nil
  self.clickFunc = nil
  self.firstActId = nil
  self.isGroupAct = nil
end

function UIMainActivityGroupItemBtn:SetData(groupId, actList, clickFunc)
  self.clickFunc = clickFunc
  self:Refresh(groupId, actList)
end

function UIMainActivityGroupItemBtn:Refresh(groupId, actList)
  self.groupId = groupId
  self.actList = actList
  self.firstActId = nil
  self.isGroupAct = nil
  if 0 < #actList then
    local actData = actList[1]
    if not string.IsNullOrEmpty(actData.festival_icon) or 0 < actData.festivalEntranceeffect then
      local iconName = ""
      local effectPath = ""
      local itemNameTxt = ""
      local effect_language_para = 1
      if 0 < actData.festivalEntranceeffect then
        local line = LocalController:instance():getLine(TableName.ACTIVITY_ENTRANCE_CONFIG, actData.festivalEntranceeffect)
        if line then
          local picList = string.split(line.pic, "|")
          local effectList = string.split(line.effect, "|")
          local nameList = string.split(line.name, "|")
          local targetIndex = self:GetShowTargetIndex(line)
          if picList and picList[targetIndex] then
            iconName = picList[targetIndex]
          end
          if effectList and effectList[targetIndex] then
            effectPath = effectList[targetIndex]
          end
          if nameList and nameList[targetIndex] then
            itemNameTxt = nameList[targetIndex]
          end
          if line.effect_language_para == "-1" then
            effect_language_para = -1
          end
        end
      else
        iconName = actData.festival_icon
        itemNameTxt = actData.festivalEntranceName
      end
      self.icon:LoadSprite(string.format(LoadPath.ActivityIconPath, iconName))
      self.icon:SetNativeSize()
      if not string.IsNullOrEmpty(effectPath) then
        self.effect_content:Play(effectPath, {
          lifeType = UIVfxLifeType.Stay,
          onLoadComplete = function()
            if not self.effect_content then
              return
            end
            if CommonUtil.IsArabicAutoMirrorOpen() then
              if self.effect_content:HasAnimState("flip") then
                self.effect_content:PlayAnimState("flip")
              end
            elseif self.effect_content:HasAnimState("Default") then
              self.effect_content:PlayAnimState("Default")
            end
          end
        })
      else
        self.effect_content:Remove()
      end
      local effectScaleX = 1
      if CommonUtil.IsArabicAutoMirrorOpen() then
        effectScaleX = effect_language_para
      end
      self.effect_content:SetLocalScaleXYZ(effectScaleX, 1, 1)
      self.icon:SetLocalScaleXYZ(effectScaleX, 1, 1)
      self.nameText:SetLocalText(itemNameTxt)
    end
    self.firstActId = tonumber(actData.id)
    self.isGroupAct = actData.festivalEntrance ~= nil and 0 < actData.festivalEntrance
  end
  local redNum = 0
  if not table.IsNullOrEmpty(actList) then
    table.walk(actList, function(k, v)
      local num = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(v.type, v.id)
      if num == nil then
        num = 0
      end
      if v.type == EnumActivity.CitySkinExchange.Type then
        local isHaveClick = DataCenter.ActivityCommonGroupViewManager:GetClickActIdRecord(tonumber(v.id))
        if isHaveClick then
          num = 0
        end
      end
      redNum = redNum + num
    end)
  end
  self.redPoint:SetActive(0 < redNum)
  self.redPointTxt:SetText(UIUtil.ShowRedNumCheckMax(redNum))
end

function UIMainActivityGroupItemBtn:GetActStartTime(actId)
  local time = 0
  local tabData = LocalController:instance():getLine(TableName.Activity, toInt(actId))
  local AbsoluteTimeType = "101"
  if tabData and tabData.timeType == AbsoluteTimeType then
    local startTimeStr = tabData.para1
    local absoluteTime = UIUtil.GetAbsoluteTimeByStr(startTimeStr)
    if absoluteTime then
      time = absoluteTime * 1000
      time = time - 10000
    end
  end
  return time
end

function UIMainActivityGroupItemBtn:GetShowTargetIndex(line)
  local targetIndex = 1
  if not string.IsNullOrEmpty(line.extra_condition) then
    local dataList = string.string2array_num(line.extra_condition, ";", "|")
    if dataList and #dataList == 2 and #dataList[1] == 1 and #dataList[2] > 0 then
      local actId = dataList[1][1]
      local dayNumList = dataList[2]
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local actStartTime = self:GetActStartTime(actId)
      local curDayNum = math.floor((curTime - actStartTime) / (OneDayTime * 1000)) + 1
      local findIndex = -1
      for i, v in ipairs(dayNumList) do
        if v > curDayNum then
          findIndex = i
          break
        end
      end
      if findIndex <= 0 then
        findIndex = #dayNumList + 1
      end
      targetIndex = findIndex
    end
  end
  return targetIndex
end

function UIMainActivityGroupItemBtn:OnBtnClick()
  if self.clickFunc ~= nil then
    self.clickFunc(self.groupId, self.firstActId, self.isGroupAct)
  end
end

return UIMainActivityGroupItemBtn
