local WorldNoticeDataInfo = BaseClass("WorldNoticeDataInfo")
local rapidjson = require("rapidjson")
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")

function WorldNoticeDataInfo:__init()
  self.uuid = nil
  self.noticeId = nil
  self.createTime = nil
  self.status = nil
  self.rewardStatus = nil
  self.title = nil
  self.content = nil
  self.subTitle = nil
end

function WorldNoticeDataInfo:__delete()
  self.uuid = nil
  self.noticeId = nil
  self.createTime = nil
  self.status = nil
  self.rewardStatus = nil
  self.title = nil
  self.content = nil
  self.subTitle = nil
end

function WorldNoticeDataInfo:UpdateDataInfo(message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.noticeId ~= nil then
    self.noticeId = message.noticeId
  end
  if message.createTime ~= nil then
    self.createTime = message.createTime
  end
  if message.status then
    self.status = message.status
  end
  if message.rewardStatus ~= nil then
    self.rewardStatus = message.rewardStatus
  end
  if message.title ~= nil then
    local title = rapidjson.decode(message.title) or {}
    if title.h ~= nil then
      self.title = MailParseHelper:DecodeMessage(title.h.title)
    else
      self.title = ""
    end
  end
  if message.content ~= nil then
    self.content = rapidjson.decode(message.content) or {}
  end
  self.subTitle = ""
  local reward = self:GetMailReward()
  if not reward then
    self.rewardStatus = 1
  end
end

function WorldNoticeDataInfo:GetMailMessage()
  return MailParseHelper:DecodeMessage(self.content.b.content)
end

function WorldNoticeDataInfo:GetMailPay()
  if self.content.b == nil then
    return nil
  end
  return self.content.b.pay
end

function WorldNoticeDataInfo:GetMailReward()
  if self.content.b == nil then
    return nil
  end
  local reward = self.content.b.reward
  if reward ~= nil and reward.rewardInfo ~= nil then
    local rewardInfo = reward.rewardInfo
    local showReward = {}
    for k, v in pairs(rewardInfo) do
      local needInsert = true
      if 0 < #showReward then
        for i = 1, #showReward do
          if needInsert == true then
            local data = showReward[i]
            if data.type == v.type then
              local itemId = data.id
              if itemId ~= nil and itemId ~= 0 and itemId ~= "" then
                if itemId == v.id then
                  data.num = data.num + v.num
                  needInsert = false
                end
              else
                data.num = data.num + v.num
                needInsert = false
              end
            end
          end
        end
      end
      if needInsert then
        table.insert(showReward, v)
      end
    end
    reward.rewardInfo = showReward
  end
  return reward
end

function WorldNoticeDataInfo:GetMailUserInfo()
  if self.content.b == nil then
    return nil
  end
  return self.content.b.userInfo
end

return WorldNoticeDataInfo
