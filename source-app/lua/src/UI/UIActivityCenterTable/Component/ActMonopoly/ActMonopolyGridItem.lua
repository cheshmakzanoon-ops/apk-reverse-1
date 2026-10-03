local ActMonopolyGridItem = BaseClass("ActMonopolyGridItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIActMonopolyGridTipView = require("UI.UIActMonopoly.UIActMonopolyGridTip.View.UIActMonopolyGridTipView")
local root_path = ""
local oneIcon_path = "oneIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, root_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.oneIcon = self:AddComponent(UIBaseContainer, oneIcon_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.oneIcon = nil
end

local function DataDefine(self)
  self.actId = nil
  self.actDetailData = nil
  self.index = nil
  self.temp = nil
  self.curData = nil
  self.recordLv = nil
  self.recordExp = nil
end

local function DataDestroy(self)
  self.actId = nil
  self.actDetailData = nil
  self.index = nil
  self.temp = nil
  self.curData = nil
  self.recordLv = nil
  self.recordExp = nil
end

local function SetData(self, actId, actDetailData, index, temp)
  self.actId = actId
  self.actDetailData = actDetailData
  self.index = index
  self.temp = temp
  self.curData = self.actDetailData:GetGridItemDatabyIndex(self.index)
  self.recordLv = 1
  if self.curData and self.curData.lv then
    self.recordLv = self.curData.lv
  end
  self.recordExp = 0
  if self.curData and self.curData.exp then
    self.recordExp = self.curData.exp
  end
end

local function CheckIsHaveChange(self)
  local isHaveChange = false
  self.curData = self.actDetailData:GetGridItemDatabyIndex(self.index)
  if self.curData and self.curData.lv and self.recordLv ~= self.curData.lv then
    self.recordLv = self.curData.lv
    isHaveChange = true
  end
  if self.curData and self.curData.exp and self.recordExp ~= self.curData.exp then
    self.recordExp = self.curData.exp
    isHaveChange = true
  end
  return isHaveChange
end

local function OnBtnClick(self)
  local curData = self.actDetailData:GetGridItemDatabyIndex(self.index)
  local param = UIActMonopolyGridTipView.ParamDataClass.New()
  param.targetPos = self.oneIcon.transform.position
  if self.temp.type == ActMonopolyGridType.StartIndex then
    param.showTitle = ""
    param.showTxt = ""
    if self.temp.grid_descList and #self.temp.grid_descList >= 2 then
      param.showTitle = Localization:GetString(self.temp.grid_descList[1])
      param.showTxt = Localization:GetString(self.temp.grid_descList[2])
    end
  elseif self.temp.type == ActMonopolyGridType.Event then
    param.showTitle = ""
    param.showTxt = ""
    if self.temp.grid_descList and #self.temp.grid_descList >= 1 then
      param.showTitle = Localization:GetString(self.temp.grid_descList[1])
    end
    if self.temp.grid_descList and #self.temp.grid_descList >= 2 then
      param.showTxt = Localization:GetString(self.temp.grid_descList[2])
    else
      local eventId = -1
      if self.temp.eventList and self.temp.eventList[1] and self.temp.eventList[1][1] then
        eventId = self.temp.eventList[1][1]
        if 0 < eventId then
          local line = LocalController:instance():getLine(TableName.RichManEvent, eventId)
          if line then
            local content = Localization:GetString(line.desc)
            param.showTxt = content
          end
        end
      end
    end
    local eventList = {}
    local totalNum = 0
    if self.temp.eventListDropShow then
      for i = 1, #self.temp.eventListDropShow do
        local data = self.temp.eventListDropShow[i]
        if data[2] > 0 then
          totalNum = totalNum + data[2]
          table.insert(eventList, {
            eventId = data[1],
            rateNum = data[2] / 100
          })
        end
      end
    end
    if 0 < #eventList then
      param.eventList = eventList
    end
  elseif self.temp.type == ActMonopolyGridType.Exp then
    local curLv = curData.lv or 1
    local curExp = curData.exp or 0
    local curMaxExp = 0
    if self.temp.expList and curLv <= #self.temp.expList then
      curMaxExp = self.temp.expList[curLv]
    end
    local gridData = {
      curLv = curLv,
      curExp = curExp,
      curMaxExp = curMaxExp
    }
    param.gridData = gridData
    local gridRewardData
    if self.actDetailData.richManGridRewards then
      for _, v in pairs(self.actDetailData.richManGridRewards) do
        if v.order == self.index then
          gridRewardData = v
          break
        end
      end
    end
    local curLvReward, nextLvReward
    if gridRewardData then
      local targetLv = curLv
      if gridRewardData.rewards and gridRewardData.rewards[targetLv] then
        curLvReward = gridRewardData.rewards[targetLv].reward
      end
      targetLv = curLv + 1
      if gridRewardData.rewards and gridRewardData.rewards[targetLv] then
        nextLvReward = gridRewardData.rewards[targetLv].reward
      end
    end
    if curLvReward then
      param.gridCurRewarrd = DataCenter.RewardManager:ReturnRewardParamForView(curLvReward)
    end
    if nextLvReward then
      param.gridNextRewarrd = DataCenter.RewardManager:ReturnRewardParamForView(nextLvReward)
    end
  end
  local boxData = self.actDetailData.boxGrid
  if boxData and boxData.order == self.index then
    local rewardList = {
      {
        rewardType = RewardType.GOODS,
        itemId = boxData.goodsId,
        count = boxData.num
      }
    }
    param.boxReward = rewardList
  end
  local bossDamageData = self.actDetailData.bossDamage[self.index]
  if bossDamageData then
    local rewardList = {
      {
        rewardType = RewardType.GOODS,
        itemId = bossDamageData.goodsId,
        count = bossDamageData.num
      }
    }
    param.bossDamageReward = rewardList
    local titleStr
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
    local bossTempId = tonumber(activityInfo.boss_type)
    if bossTempId and 0 < bossTempId then
      local bossDamageTemp = DataCenter.ActMonopolyDataManager:GetMonopolyBossTempById(bossTempId)
      local damage1, damage2 = bossDamageTemp:GetAtkGoodsDamage()
      titleStr = string.format("%s~%s", damage1, damage2)
    end
    param.bossDamageTitle = Localization:GetString("richman_boss_desc6") .. titleStr
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyGridTip, {anim = false}, param)
end

local function TryPlayLevelUpEffect(self, level)
  local curLv = self.recordLv
  local inputLv = curLv
  if level then
    inputLv = level
  else
    self.curData = self.actDetailData:GetGridItemDatabyIndex(self.index)
    if self.curData and self.curData.lv then
      inputLv = self.curData.lv
    end
  end
  if curLv < inputLv then
    return inputLv
  end
  return -1
end

ActMonopolyGridItem.OnCreate = OnCreate
ActMonopolyGridItem.OnDestroy = OnDestroy
ActMonopolyGridItem.ComponentDefine = ComponentDefine
ActMonopolyGridItem.ComponentDestroy = ComponentDestroy
ActMonopolyGridItem.DataDefine = DataDefine
ActMonopolyGridItem.DataDestroy = DataDestroy
ActMonopolyGridItem.SetData = SetData
ActMonopolyGridItem.CheckIsHaveChange = CheckIsHaveChange
ActMonopolyGridItem.OnBtnClick = OnBtnClick
ActMonopolyGridItem.TryPlayLevelUpEffect = TryPlayLevelUpEffect
return ActMonopolyGridItem
