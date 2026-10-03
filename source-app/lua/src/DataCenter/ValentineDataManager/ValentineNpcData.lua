local ValentineNpcData = BaseClass("ValentineNpcData")

function ValentineNpcData:__init()
end

function ValentineNpcData:__delete()
end

function ValentineNpcData:UpdateData(data)
  self.npcId = data.npcId
  self.rank = data.rank
  self.like = data.like
  self.gift = data.gift
  self.follow = data.follow
  self.createTime = data.createTime
  self:ParseTemplate()
end

function ValentineNpcData:UpdateRewardStatus(msg)
  self.like = msg.like
  self.gift = msg.gift
  self.follow = msg.follow
end

function ValentineNpcData:ParseTemplate()
  self.lineData = LocalController:instance():getLine("activity_Valentine_npc_pic", self.npcId)
  if self.lineData == nil then
    Logger.LogError("lineData is error, id:" .. tostring(self.npcId))
    return
  end
  self.hot = self.lineData.hot
  self.appearance = self.lineData.appearance
  self.gender = self.lineData.gender
  self.heroId = self.lineData.hero_id
  self.name = LocalController:instance():getValue("lw_hero", self.heroId, "first_name")
  local titleParams = self:ParseCardStr(self.lineData.name)
  local descParams = self:ParseCardStr(self.lineData.desc)
  local rewards = self:ParseCardStr(self.lineData.reward)
  self.cardData = {}
  self.cardData[ValentineNpcRewardGetType.Like] = self:GetCardInfoCombine(ValentineNpcRewardGetType.Like, titleParams, descParams, rewards)
  self.cardData[ValentineNpcRewardGetType.Gift] = self:GetCardInfoCombine(ValentineNpcRewardGetType.Gift, titleParams, descParams, rewards)
  self.cardData[ValentineNpcRewardGetType.Follow] = self:GetCardInfoCombine(ValentineNpcRewardGetType.Follow, titleParams, descParams, rewards)
  self:ParseSpineConfig(self.lineData.size)
  self:ParseImageConfig(self.lineData.image)
end

function ValentineNpcData:ParseSpineConfig(spineConfigStr)
  if not string.IsNullOrEmpty(spineConfigStr) then
    local params = string.split(spineConfigStr, ";")
    if params and #params == 3 then
      self.spineConfig = {}
      self.spineConfig.scale = tonumber(params[1])
      self.spineConfig.posX = tonumber(params[2])
      self.spineConfig.posY = tonumber(params[3])
    end
  end
end

function ValentineNpcData:ParseImageConfig(imageFullPathStr)
  if not string.IsNullOrEmpty(imageFullPathStr) then
    local params = string.split(imageFullPathStr, ";")
    if params and 0 < #params then
      self.headIcons = {}
      for i, v in ipairs(params) do
        if not string.IsNullOrEmpty(v) then
          table.insert(self.headIcons, v)
        end
      end
    end
  end
end

function ValentineNpcData:IsGetReward(type)
  if type == ValentineNpcRewardGetType.Like then
    return self.like == 1
  end
  if type == ValentineNpcRewardGetType.Gift then
    return self.gift == 1
  end
  if type == ValentineNpcRewardGetType.Follow then
    return self.follow == 1
  end
  Logger.LogError("type is error.  type:" .. tostring(type))
  return false
end

function ValentineNpcData:GetCardDisplayData(type)
  return self.cardData[type]
end

function ValentineNpcData:ParseCardStr(str)
  if string.IsNullOrEmpty(str) then
    Logger.LogError("error:  str:" .. tostring(str))
    return
  end
  local params = string.split(str, "|")
  if not params or #params ~= 3 then
    Logger.LogError("error:  str:" .. tostring(str))
    return
  end
  return params
end

function ValentineNpcData:GetCardInfoCombine(type, titleParams, descParams, rewards)
  local info = {}
  info.title = titleParams[type] or ""
  info.desc = descParams[type] or ""
  info.reward = tonumber(rewards[type]) or 0
  return info
end

function ValentineNpcData:IsComplete()
  local ifShowFollowBtn = DataCenter.ValentineDataManager:GetIfOpenMatch()
  local isComplete = self.like == 1 and self.gift == 1
  if ifShowFollowBtn then
    isComplete = isComplete and self.follow == 1
  end
  return isComplete
end

function ValentineNpcData:IsNeedBubble(curServerTime)
  local isComplete = self:IsComplete()
  if not isComplete then
    local limitTime = LuaEntry.DataConfig:TryGetNum("Valentine_npc_pic_para", "k1")
    if curServerTime - self.createTime >= limitTime * 60 then
      return true
    end
  end
  return false
end

return ValentineNpcData
