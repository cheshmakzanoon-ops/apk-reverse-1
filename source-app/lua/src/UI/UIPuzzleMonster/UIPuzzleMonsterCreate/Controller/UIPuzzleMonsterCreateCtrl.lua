local UIPuzzleMonsterCreateCtrl = BaseClass("UIPuzzleMonsterCreateCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIPuzzleMonsterCreate)
end

local function GetPanelData(self)
  local list = DataCenter.ActivityPuzzleMonsterTemplateManager:GetAllTemplate()
  local result = {}
  local lockFind = false
  local monsterData = DataCenter.ActivityPuzzleDataManager:GetPuzzleData()
  local preName = ""
  if list ~= nil and monsterData ~= nil then
    table.walk(list, function(_, v)
      local data = {}
      data.name = v.name
      data.id = v.id
      data.monsterId = v.monsterId
      data.consumeType = v.consumeType
      data.consumeId = v.consumeId
      data.consumeNum = v.consumeNum
      data.consumeIcon = ""
      data.showRedDot = DataCenter.ActivityPuzzleDataManager:GetBossRewardRedDot(v.id, monsterData.puzzleBossExpireTime)
      data.isLeftArrow = data.id == 1
      local unlock, need, current = DataCenter.ActivityPuzzleDataManager:IsBossUnlock(v.id)
      data.unlock = unlock
      data.unlockStr = ""
      local isAnimationPlayed = DataCenter.ActivityPuzzleDataManager:GetBossUnlockAnimationPlay(v.id)
      data.needShowUnlockAnimation = unlock and not isAnimationPlayed and need ~= 0
      if not data.unlock and not lockFind then
        if data.id == 2 then
          data.unlockStr = Localization:GetString("170516", current, need)
        else
          data.unlockStr = Localization:GetString("170517", current, need)
        end
        lockFind = true
      end
      preName = Localization:GetString(v.name)
      if data.consumeType == ConsumeType.ConsumeType_Resource_Item then
        local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(data.consumeId)
        if template ~= nil then
          data.consumeIcon = template:GetIconPath()
        end
      elseif data.consumeType == ConsumeType.ConsumeType_Resource then
        data.consumeIcon = DataCenter.ResourceManager:GetResourceIconByType(data.consumeId)
      elseif data.consumeType == ConsumeType.ConsumeType_Item then
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(data.consumeId)
        if template ~= nil then
          data.consumeIcon = string.format(LoadPath.ItemPath, template.icon)
        end
      end
      local rewardList = {}
      local vec1 = string.split(v.rewardShow, "|")
      table.walk(vec1, function(_, v)
        local vec2 = string.split(v, ";")
        if table.count(vec2) == 2 then
          local param = {}
          param.itemId = toInt(vec2[1])
          param.rewardType = toInt(vec2[2])
          param.count = 1
          table.insert(rewardList, param)
        end
      end)
      data.rewardList = rewardList
      local rewardDetailList = {}
      local reward_detailVec = string.split(v.reward_detail, "|")
      table.walk(reward_detailVec, function(_, v)
        local vec2 = string.split(v, ";")
        if table.count(vec2) == 3 then
          local param = {}
          param.itemId = toInt(vec2[1])
          param.rewardType = toInt(vec2[2])
          param.count = toInt(vec2[3])
          table.insert(rewardDetailList, param)
        end
      end)
      data.rewardDetailList = rewardDetailList
      table.insert(result, data)
    end)
  end
  return result
end

local function CreatePuzzleMonster(self, data)
  if data == nil then
    return
  end
  if data.consumeType == ConsumeType.ConsumeType_Resource_Item then
    local resourceItem = DataCenter.ResourceItemDataManager:GetItemDataByItemId(data.consumeId)
    if resourceItem == nil or resourceItem.number < data.consumeNum then
      UIUtil.ShowTipsId(120020)
      return
    end
  elseif data.consumeType == ConsumeType.ConsumeType_Resource then
    local num = 0
    if data.consumeId == ResourceType.Gold then
      num = LuaEntry.Player.gold
    else
      num = LuaEntry.Resource:GetCntByResType(data.consumeId)
    end
    if num == nil or num < data.consumeNum then
      local lackTab = {}
      local param = {}
      param.type = ResLackType.Res
      param.resType = data.consumeId
      param.targetNum = data.consumeNum
      table.insert(lackTab, param)
      GoToResLack.GoToItemResLackList(lackTab)
      return
    end
  elseif data.consumeType == ConsumeType.ConsumeType_Item and DataCenter.ItemData:GetItemCount(data.consumeId) < data.consumeNum then
    UIUtil.ShowTipsId(120020)
    return
  end
  DataCenter.ActivityPuzzleDataManager:SendCreatePuzzleBoss(data.monsterId)
  self:CloseSelf()
end

UIPuzzleMonsterCreateCtrl.CloseSelf = CloseSelf
UIPuzzleMonsterCreateCtrl.GetPanelData = GetPanelData
UIPuzzleMonsterCreateCtrl.CreatePuzzleMonster = CreatePuzzleMonster
return UIPuzzleMonsterCreateCtrl
