local HeroEntrustManager = BaseClass("HeroEntrustManager")
local HeroEntrustInfo = require("DataCenter.HeroEntrustManager.HeroEntrustInfo")
local Localization = CS.GameEntry.Localization

function HeroEntrustManager:__init()
  self.allHeroEntrust = {}
  self.reward = nil
  self.showNpcName = {}
end

function HeroEntrustManager:__delete()
  self.allHeroEntrust = {}
  self.reward = nil
  self.showNpcName = {}
end

function HeroEntrustManager:InitData(message)
  self.allHeroEntrust = {}
  if message.heroEntrusts ~= nil then
    for k, v in pairs(message.heroEntrusts) do
      self:AddOneHeroEntrust(v)
    end
  end
end

function HeroEntrustManager:AddOneHeroEntrust(message)
  if message ~= nil then
    local id = message.id
    local one = self:GetHeroEntrustById(id)
    if one == nil then
      one = HeroEntrustInfo.New()
      one:UpdateInfo(message)
      self.allHeroEntrust[id] = one
    else
      one:UpdateInfo(message)
    end
    if one:IsAllComplete() then
      self:RemoveOneHeroEntrust(id)
    else
      local template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(id)
      if template ~= nil then
        local posArr = {}
        table.insert(posArr, template:GetTilePosition())
        DataCenter.CityNpcManager:AddOneNpc(template.Npc_Model, posArr, nil, nil, nil)
        self.showNpcName[template.Npc_Model] = true
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshHeroEntrust, id)
  end
end

function HeroEntrustManager:RemoveOneHeroEntrust(id)
  self.allHeroEntrust[id] = nil
  local template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(id)
  if template ~= nil and self.showNpcName[template.Npc_Model] ~= nil then
    self.showNpcName[template.Npc_Model] = nil
    if not DataCenter.GuideManager:InGuide() then
      DataCenter.CityNpcManager:RemoveOneNpc(template.Npc_Model)
      CityPioneerArchive:GetInstance():Save()
    else
      local npc = DataCenter.CityNpcManager:GetNpcObjectByName(template.Npc_Model)
      if npc ~= nil then
        EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
          target = npc.transform
        })
      end
    end
  end
end

function HeroEntrustManager:GetHeroEntrustById(id)
  return self.allHeroEntrust[id]
end

function HeroEntrustManager:Startup()
end

function HeroEntrustManager:PayForHeroEntrustHandle(message)
  if message.errorCode == nil then
    local entrust = message.entrust
    if entrust ~= nil then
      self:AddOneHeroEntrust(entrust)
    end
    DataCenter.RewardManager:AddRewardsAndRes(message)
    local reward = message.reward
    if reward ~= nil and table.count(reward) > 0 then
      if DataCenter.GuideManager:InGuide() then
        self:AddShowReward(message)
      else
        DataCenter.RewardManager:ShowCommonReward(message)
      end
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

function HeroEntrustManager:PushNewEntrustHandle(message)
  if message.heroEntrusts ~= nil then
    for k, v in pairs(message.heroEntrusts) do
      self:AddOneHeroEntrust(v)
    end
  end
end

function HeroEntrustManager:SendPayForHeroEntrust(id, index)
  SFSNetwork.SendMessage(MsgDefines.PayForHeroEntrust, {id = id, index = index})
end

function HeroEntrustManager:GetHeroEntrustByNpcName(npcName)
  for k, v in pairs(self.allHeroEntrust) do
    if not v:IsAllComplete() then
      local template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(k)
      if template ~= nil and template.Npc_Model == npcName then
        return v
      end
    end
  end
end

function HeroEntrustManager:IsCompleteByIndex(id, index)
  local info = self:GetHeroEntrustById(id)
  if info ~= nil then
    return info:IsCompleteByIndex(index)
  end
  return true
end

function HeroEntrustManager:GetInitNeedShowHeroEntrust()
  local result = {}
  for k, v in pairs(self.allHeroEntrust) do
    if not v:IsAllComplete() then
      local template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(k)
      if template ~= nil then
        local model = DataCenter.CityNpcManager:GetNpcObjectByName(template.Npc_Model)
        if model ~= nil then
          local talkParam = {}
          talkParam.talkType = NpcTalkType.HeroEntrust
          talkParam.target = model.transform
          talkParam.offset = Vector3.New(0, 1, 0)
          talkParam.id = k
          table.insert(result, talkParam)
        end
      end
    end
  end
  return result
end

function HeroEntrustManager:AddShowReward(reward)
  if self.reward == nil then
    self.reward = reward
  elseif reward.reward ~= nil then
    for k, v in ipairs(reward.reward) do
      table.insert(self.reward.reward, v)
    end
  end
end

function HeroEntrustManager:GetShowReward()
  return self.reward
end

function HeroEntrustManager:CheckShowReward()
  if self.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(self.reward)
    self.reward = nil
  end
end

return HeroEntrustManager
