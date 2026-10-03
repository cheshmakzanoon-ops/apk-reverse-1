local GiftPackageChangePreviewManager = BaseClass("GiftPackageChangePreviewManager")
local Localization = CS.GameEntry.Localization
local GiftPackageChangeTemplate = require("DataCenter/GiftPackageChangePreview/GiftPackageChangeTemplate")

function GiftPackageChangePreviewManager:__init()
end

function GiftPackageChangePreviewManager:__delete()
end

function GiftPackageChangePreviewManager:GetAllRewardChargeTemplatesByGroup(group)
  local res = {}
  LocalController:instance():visitTable(TableName.GIFT_PREVIEW_INFO, function(id, lineData)
    if lineData ~= nil and lineData.group == group then
      local template = GiftPackageChangeTemplate.New()
      template:UpdateData(lineData)
      table.insert(res, template)
    end
  end)
  table.sort(res, function(a, b)
    return a.order < b.order
  end)
  return res
end

function GiftPackageChangePreviewManager:IsFunctionOn()
  return LuaEntry.DataConfig:CheckSwitch("gift_preview")
end

function GiftPackageChangePreviewManager:GetRewardChangeShowDataByGiftInfo(giftInfo)
  if giftInfo == nil then
    return nil
  end
  if giftInfo.getRewardChangeGroup == nil then
    return nil
  end
  local group = giftInfo:getRewardChangeGroup()
  if group == nil or group == 0 then
    return nil
  end
  local templates = self:GetAllRewardChargeTemplatesByGroup(group)
  local curTemplate, nextTemplate
  for i, v in ipairs(templates) do
    if v:CheckTimeCondition() and v:CheckServerCondition() then
      curTemplate = v
      break
    end
  end
  if curTemplate == nil then
    return nil
  else
    local curSeason = SeasonUtil.GetSeason()
    local nextOrder = curTemplate.order - 1
    for i, v in ipairs(templates) do
      if v.order == nextOrder then
        local nextSeason = v:GetSeason()
        if curSeason == nextSeason then
          nextTemplate = v
        end
        break
      end
    end
  end
  return curTemplate, nextTemplate
end

return GiftPackageChangePreviewManager
