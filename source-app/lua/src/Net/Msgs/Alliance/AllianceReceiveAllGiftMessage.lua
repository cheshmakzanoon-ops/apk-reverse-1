local AllianceReceiveAllGiftMessage = BaseClass("AllianceReceiveAllGiftMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.receiveResult ~= nil then
    local receiveResult = t.receiveResult
    local type = t.type
    if receiveResult == 1 then
      SFSNetwork.SendMessage(MsgDefines.AllianceGiftList, 0, 1000, type)
      DataCenter.AllianceGiftDataManager:RetBaseData(t)
      if t.results then
        for i, v in ipairs(t.results) do
          DataCenter.AllianceGiftDataManager:SetGiftReceive(v.uuid, v.receiveTime)
        end
      end
      if t.allianceNewMail ~= nil then
        DataCenter.AllianceGiftDataManager:UpdateGiftNum(t.allianceNewMail)
        EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGiftNum)
      end
      if t.info ~= nil and 0 < #t.info then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWAllianceGift)
        local lastType = 1
        if window ~= nil then
          local view = window.View
          for _, reward in pairs(t.info) do
            local tempType = reward.type
            lastType = tempType
            local tempId = reward.value.id
            local pic = RewardUtil.GetPic(tempType, tempId)
            UIUtil.DoFly(tonumber(tempType), 5, pic, view.scrollView.transform.position, UIUtil.GetFlyTargetByRewardType(tonumber(tempType)))
          end
          local targetPos = view.scoreFlyTarget.transform.position
          local scorePic = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox_exp.png"
          UIUtil.DoFly(tonumber(lastType), 5, scorePic, view.scrollView.transform.position, targetPos, 40, 40)
        end
      end
      DataCenter.RewardManager:AddRewardsAndRes(t)
      if type ~= nil then
        local tips = ""
        local receiveNum = t.receiveNum or 0
        if type == 1 then
          tips = Localization:GetString("alliance_system025", receiveNum)
        else
          tips = Localization:GetString("alliance_system024", receiveNum)
        end
        if t.reward ~= nil then
          local count = table.count(t.reward)
          if 0 < count then
            DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, nil, tips)
          else
            Logger.LogInfo("\230\173\164\230\172\161\230\137\185\233\135\143\233\162\134\229\143\150\231\154\132\229\144\140\231\155\159\229\165\150\229\138\177\228\184\186\231\169\186")
          end
        end
      end
      EventManager:GetInstance():Broadcast(EventId.RefreshAllianceGift)
      UIUtil.ShowTipsId(170003)
    end
  end
end

AllianceReceiveAllGiftMessage.OnCreate = OnCreate
AllianceReceiveAllGiftMessage.HandleMessage = HandleMessage
return AllianceReceiveAllGiftMessage
