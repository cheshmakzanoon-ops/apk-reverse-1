local LWUIActivityRewardChangePreview_AccuRechargeCtrl = BaseClass("LWUIActivityRewardChangePreview_AccuRechargeCtrl", UIBaseCtrl)

function LWUIActivityRewardChangePreview_AccuRechargeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActivityRewardChangePreview_AccuRecharge, {anim = false})
end

function LWUIActivityRewardChangePreview_AccuRechargeCtrl:GetUpdateShowData(activityInfo, templates)
  local res = {}
  if activityInfo == nil or table.IsNullOrEmpty(templates) then
    return res
  end
  local needSort = true
  for _, template in ipairs(templates) do
    if tonumber(template.type_para1) == 0 then
      local rewardParaStrList = string.split(template.type_para2, ",")
      if #rewardParaStrList == 2 then
        local preRewardParaStrList = string.split(rewardParaStrList[1], ";")
        local newRewardParaStrList = string.split(rewardParaStrList[2], ";")
        if #preRewardParaStrList == 3 and #newRewardParaStrList == 3 then
          local preRewardData = {
            count = tonumber(preRewardParaStrList[3]),
            itemId = tonumber(preRewardParaStrList[2]),
            rewardType = tonumber(preRewardParaStrList[1])
          }
          local newRewardData = {
            count = tonumber(newRewardParaStrList[3]),
            itemId = tonumber(newRewardParaStrList[2]),
            rewardType = tonumber(newRewardParaStrList[1])
          }
          local stages = self:GetStages(activityInfo)
          if not table.IsNullOrEmpty(stages) then
            for i, v in ipairs(stages) do
              local score = v.needScore
              local data = {
                score = score,
                preRewardData = preRewardData,
                newRewardData = newRewardData
              }
              table.insert(res, data)
            end
          end
        end
      end
    elseif template.change_type == DataCenter.ActivityRewardChangePreviewManager.ChangeType.DailyAct_Update then
      needSort = false
      local para1StrList = string.split(template.type_para1, "|")
      local para2StrList = string.split(template.type_para2, "|")
      if #para1StrList == #para2StrList then
        for i, v in ipairs(para2StrList) do
          local preRewardParaStrList = string.split(para1StrList[i], ";")
          local newRewardParaStrList = string.split(v, ";")
          if #preRewardParaStrList == 3 and #newRewardParaStrList == 3 then
            local preRewardData = {
              count = tonumber(preRewardParaStrList[3]),
              itemId = tonumber(preRewardParaStrList[2]),
              rewardType = tonumber(preRewardParaStrList[1])
            }
            local newRewardData = {
              count = tonumber(newRewardParaStrList[3]),
              itemId = tonumber(newRewardParaStrList[2]),
              rewardType = tonumber(newRewardParaStrList[1])
            }
            local data = {
              score = i,
              preRewardData = preRewardData,
              newRewardData = newRewardData
            }
            table.insert(res, data)
          end
        end
      end
    else
      local para1StrList = string.split(template.type_para1, "|")
      local para2StrList = string.split(template.type_para2, "|")
      if #para1StrList == #para2StrList then
        for i, v in ipairs(para2StrList) do
          local rewardParaStrList = string.split(v, ",")
          if #rewardParaStrList == 2 then
            local preRewardParaStrList = string.split(rewardParaStrList[1], ";")
            local newRewardParaStrList = string.split(rewardParaStrList[2], ";")
            if #preRewardParaStrList == 3 and #newRewardParaStrList == 3 then
              local preRewardData = {
                count = tonumber(preRewardParaStrList[3]),
                itemId = tonumber(preRewardParaStrList[2]),
                rewardType = tonumber(preRewardParaStrList[1])
              }
              local newRewardData = {
                count = tonumber(newRewardParaStrList[3]),
                itemId = tonumber(newRewardParaStrList[2]),
                rewardType = tonumber(newRewardParaStrList[1])
              }
              local data = {
                score = checknumber(para1StrList[i]),
                preRewardData = preRewardData,
                newRewardData = newRewardData
              }
              table.insert(res, data)
            end
          end
        end
      end
    end
  end
  if needSort then
    table.sort(res, function(a, b)
      return a.score < b.score
    end)
  end
  return res
end

function LWUIActivityRewardChangePreview_AccuRechargeCtrl:GetNewShowData(activityInfo, templates)
  local res = {}
  if activityInfo == nil or table.IsNullOrEmpty(templates) then
    return res
  end
  local needSort = true
  for _, template in ipairs(templates) do
    if tonumber(template.type_para1) == 0 then
      local stages = self:GetStages(activityInfo)
      if not table.IsNullOrEmpty(stages) then
        for i, v in ipairs(stages) do
          local rewardParaStrList = string.split(template.type_para2, "|")
          if rewardParaStrList[i] ~= nil then
            local rewardParaStrList2 = string.split(rewardParaStrList[i], ";")
            if #rewardParaStrList2 == 3 then
              local rewardData = {
                count = tonumber(rewardParaStrList2[3]),
                itemId = tonumber(rewardParaStrList2[2]),
                rewardType = tonumber(rewardParaStrList2[1])
              }
              local score = v.needScore
              local data = {score = score, rewardData = rewardData}
              table.insert(res, data)
            end
          end
        end
      end
    elseif template.change_type == DataCenter.ActivityRewardChangePreviewManager.ChangeType.DailyAct_New then
      needSort = false
      local para1StrList = string.split(template.type_para1, "|")
      local para2StrList = string.split(template.type_para2, "|")
      local isHaveStages = true
      if string.IsNullOrEmpty(template.type_para1) then
        isHaveStages = false
      end
      for i, v in ipairs(para2StrList) do
        local rewardParaStrList = string.split(v, ";")
        local stageParaStrList = {}
        if isHaveStages then
          stageParaStrList = string.split(para1StrList[i], ";")
        end
        if #rewardParaStrList == 3 then
          local rewardData = {
            count = tonumber(rewardParaStrList[3]),
            itemId = tonumber(rewardParaStrList[2]),
            rewardType = tonumber(rewardParaStrList[1])
          }
          local score = isHaveStages and checknumber(stageParaStrList[3]) or i
          local stageItemId = isHaveStages and checknumber(stageParaStrList[2]) or 0
          local iconPath = DataCenter.ItemTemplateManager:GetIconPath(stageItemId)
          local data = {
            score = score,
            rewardData = rewardData,
            scoreIconPath = iconPath,
            hideStage = not isHaveStages
          }
          table.insert(res, data)
        end
      end
    else
      local para1StrList = string.split(template.type_para1, "|")
      local para2StrList = string.split(template.type_para2, "|")
      if #para1StrList == #para2StrList then
        for i, v in ipairs(para2StrList) do
          local rewardParaStrList = string.split(v, ";")
          if #rewardParaStrList == 3 then
            local rewardData = {
              count = tonumber(rewardParaStrList[3]),
              itemId = tonumber(rewardParaStrList[2]),
              rewardType = tonumber(rewardParaStrList[1])
            }
            local score = checknumber(para1StrList[i])
            local data = {score = score, rewardData = rewardData}
            table.insert(res, data)
          end
        end
      end
    end
  end
  if needSort then
    table.sort(res, function(a, b)
      return a.score < b.score
    end)
  end
  return res
end

function LWUIActivityRewardChangePreview_AccuRechargeCtrl:GetStages(activityInfo)
  local actInfo = DataCenter.CumulativeRechargeManager:GetRechargeStage(activityInfo.activityId)
  if actInfo then
    local stages = actInfo.stageInfo
    if not table.IsNullOrEmpty(stages) then
      return stages
    end
  end
end

function LWUIActivityRewardChangePreview_AccuRechargeCtrl:GetScoreIconPath(activityInfo)
  local res = DefaultRechargePointIconPath
  if activityInfo and not string.IsNullOrEmpty(activityInfo.para) then
    res = activityInfo.para
  end
  return string.format(LoadPath.ItemPath, res)
end

return LWUIActivityRewardChangePreview_AccuRechargeCtrl
