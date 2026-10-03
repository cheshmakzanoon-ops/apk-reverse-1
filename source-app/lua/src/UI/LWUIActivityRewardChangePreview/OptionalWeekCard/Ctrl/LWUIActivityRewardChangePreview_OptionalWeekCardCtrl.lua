local LWUIActivityRewardChangePreview_OptionalWeekCardCtrl = BaseClass("LWUIActivityRewardChangePreview_OptionalWeekCardCtrl", UIBaseCtrl)

function LWUIActivityRewardChangePreview_OptionalWeekCardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActivityRewardChangePreview_OptionalWeekCard, {
    anim = true,
    UIMainAnim = "CommonPopup_moveout"
  })
end

function LWUIActivityRewardChangePreview_OptionalWeekCardCtrl:GetCloseShowEffectData(updateTemplates, newTemplates)
  local normalMustData = {}
  local normalSelectData = {}
  local advanceMustData = {}
  local advanceSelectData = {}
  if not table.IsNullOrEmpty(updateTemplates) then
    local normalTemplateUpdate, advanceTemplateUpdate
    for i, v in ipairs(updateTemplates) do
      local class = v:GetOptionalWeekCardClass()
      if class == 1 then
        normalTemplateUpdate = v
      elseif class == 2 then
        advanceTemplateUpdate = v
      end
    end
    if normalTemplateUpdate then
      local rewardDataMustNormal = normalTemplateUpdate:GetOptionalWeekCardRewardDataMustGet()
      local showDataMustNormal = self:GetUpdateShowData(rewardDataMustNormal)
      if not table.IsNullOrEmpty(showDataMustNormal) then
        normalMustData.updateData = showDataMustNormal
      end
      local rewardDataSelectNormal = normalTemplateUpdate:GetOptionalWeekCardRewardDataSelect()
      local showDataSelectNormal = self:GetUpdateShowData(rewardDataSelectNormal)
      if not table.IsNullOrEmpty(showDataSelectNormal) then
        normalSelectData.updateData = showDataSelectNormal
      end
    end
    if advanceTemplateUpdate then
      local rewardDataMustAdvance = advanceTemplateUpdate:GetOptionalWeekCardRewardDataMustGet()
      local showDataMustAdvance = self:GetUpdateShowData(rewardDataMustAdvance)
      if not table.IsNullOrEmpty(showDataMustAdvance) then
        advanceMustData.updateData = showDataMustAdvance
      end
      local rewardDataSelectAdvance = advanceTemplateUpdate:GetOptionalWeekCardRewardDataSelect()
      local showDataSelectAdvance = self:GetUpdateShowData(rewardDataSelectAdvance)
      if not table.IsNullOrEmpty(showDataSelectAdvance) then
        advanceSelectData.updateData = showDataSelectAdvance
      end
    end
  end
  if not table.IsNullOrEmpty(newTemplates) then
    local normalTemplateNew, advanceTemplateNew
    for i, v in ipairs(newTemplates) do
      local class = v:GetOptionalWeekCardClass()
      if class == 1 then
        normalTemplateNew = v
      elseif class == 2 then
        advanceTemplateNew = v
      end
    end
    if normalTemplateNew then
      local rewardDataMustNormal = normalTemplateNew:GetOptionalWeekCardRewardDataMustGet()
      local showDataMustNormal = self:GetUpdateShowData(rewardDataMustNormal)
      if not table.IsNullOrEmpty(showDataMustNormal) then
        normalMustData.newData = showDataMustNormal
      end
      local rewardDataSelectNormal = normalTemplateNew:GetOptionalWeekCardRewardDataSelect()
      local showDataSelectNormal = self:GetUpdateShowData(rewardDataSelectNormal)
      if not table.IsNullOrEmpty(showDataSelectNormal) then
        normalSelectData.newData = showDataSelectNormal
      end
    end
    if advanceTemplateNew then
      local rewardDataMustAdvance = advanceTemplateNew:GetOptionalWeekCardRewardDataMustGet()
      local showDataMustAdvance = self:GetNewShowData(rewardDataMustAdvance)
      if not table.IsNullOrEmpty(showDataMustAdvance) then
        advanceMustData.newData = showDataMustAdvance
      end
      local rewardDataSelectAdvance = advanceTemplateNew:GetOptionalWeekCardRewardDataSelect()
      local showDataSelectAdvance = self:GetNewShowData(rewardDataSelectAdvance)
      if not table.IsNullOrEmpty(showDataSelectAdvance) then
        advanceSelectData.newData = showDataSelectAdvance
      end
    end
  end
  return {
    normalMustData = normalMustData,
    normalSelectData = normalSelectData,
    advanceMustData = advanceMustData,
    advanceSelectData = advanceSelectData
  }
end

function LWUIActivityRewardChangePreview_OptionalWeekCardCtrl:GetUpdateShowData(rewardData)
  if rewardData == nil then
    return nil
  end
  local res = {}
  if not string.IsNullOrEmpty(rewardData.rewardsStr) then
    local rewardsStrList = string.split(rewardData.rewardsStr, ",")
    for i, v in ipairs(rewardsStrList) do
      local rewardParaStrList = string.split(v, "#")
      if #rewardParaStrList == 2 then
        local preRewardParaStrList = string.split(rewardParaStrList[1], ";")
        local newRewardParaStrList = string.split(rewardParaStrList[2], ";")
        if #preRewardParaStrList == 3 and #newRewardParaStrList == 3 then
          local preReward = {
            count = tonumber(preRewardParaStrList[3]),
            itemId = tonumber(preRewardParaStrList[2]),
            rewardType = tonumber(preRewardParaStrList[1])
          }
          local newReward = {
            count = tonumber(newRewardParaStrList[3]),
            itemId = tonumber(newRewardParaStrList[2]),
            rewardType = tonumber(newRewardParaStrList[1])
          }
          table.insert(res, {preReward = preReward, newReward = newReward})
        end
      end
    end
  end
  return res
end

function LWUIActivityRewardChangePreview_OptionalWeekCardCtrl:GetNewShowData(rewardData)
  if rewardData == nil then
    return nil
  end
  local res = {}
  if not string.IsNullOrEmpty(rewardData.rewardsStr) then
    local rewardsStrList = string.split(rewardData.rewardsStr, ",")
    for i, v in ipairs(rewardsStrList) do
      local rewardParaStrList = string.split(v, ";")
      if #rewardParaStrList == 3 then
        local reward = {
          count = tonumber(rewardParaStrList[3]),
          itemId = tonumber(rewardParaStrList[2]),
          rewardType = tonumber(rewardParaStrList[1])
        }
        table.insert(res, reward)
      end
    end
  end
  return res
end

return LWUIActivityRewardChangePreview_OptionalWeekCardCtrl
