local SeasonEasterEggManager = BaseClass("SeasonEasterEggManager")

function SeasonEasterEggManager:__init()
  self:InitVars()
end

function SeasonEasterEggManager:__delete()
end

function SeasonEasterEggManager:InitVars()
  self.TodayNum = 0
  self.UpdateTime = 0
  self.EasterEggPos = Vector3.zero
  self.EasterEggConfigs = {}
  self.EasterEggConfigs.Season_6 = {
    Script = require("UI.LWSeason.LWSeasonEasterEgg.S5.Season5EasterEggComp")
  }
end

function SeasonEasterEggManager:GetConfig(seasonType)
  local key = string.format("Season_%d", checknumber(seasonType))
  return self.EasterEggConfigs[key]
end

function SeasonEasterEggManager:SetEasterEggPos(pos)
  self.EasterEggPos = pos
end

function SeasonEasterEggManager:IsFuncOpen()
  local openSeason = LuaEntry.DataConfig:TryGetNum("clickegg", "k1", 0)
  local curSeason = SeasonUtil.GetSeason()
  return curSeason == openSeason
end

function SeasonEasterEggManager:OnInitMessage(res)
  if res == nil then
    return
  end
  if res.click_chicken_daily_num ~= nil then
    self:UpdateTodayNum(res.click_chicken_daily_num)
  end
end

function SeasonEasterEggManager:UpdateTodayNum(num)
  self.TodayNum = checknumber(num)
  self.UpdateTime = UITimeManager:GetInstance():GetServerSeconds()
  Logger.Log(string.format("\227\128\144\229\176\143\233\184\161\227\128\145 \228\187\138\230\151\165\229\183\178\232\167\166\229\143\145\230\172\161\230\149\176 %d", self.TodayNum))
end

function SeasonEasterEggManager:GetTodayNum()
  if not self:IsFuncOpen() then
    return 0
  end
  local dataValid = UITimeManager:GetInstance():IsSameDayForServer(checknumber(self.UpdateTime), UITimeManager:GetInstance():GetServerSeconds())
  if not dataValid then
    self.TodayNum = 0
    self.UpdateTime = UITimeManager:GetInstance():GetServerSeconds()
  end
  return self.TodayNum
end

function SeasonEasterEggManager:HasTimeToday()
  if not self:IsFuncOpen() then
    return false
  end
  if GMUtils.GetBool(GMConst.S5EasterEggChickenNoTimes) then
    return false
  end
  local maxNum = LuaEntry.DataConfig:TryGetNum("clickegg", "k3", 0)
  return maxNum > self:GetTodayNum()
end

function SeasonEasterEggManager:GetTipCd()
  return LuaEntry.DataConfig:TryGetNum("clickegg", "k5", 60)
end

function SeasonEasterEggManager:IsShockFuncOpen()
  if not self:IsFuncOpen() then
    return false
  end
  return LuaEntry.DataConfig:TryGetNum("clickegg", "k4", 0) == 1
end

function SeasonEasterEggManager:SendClaimReward()
  if not self:IsFuncOpen() then
    return false
  end
  if not self:HasTimeToday() then
    return false
  end
  SFSNetwork.SendMessage(MsgDefines.GetChickenDailyReward)
  return true
end

function SeasonEasterEggManager:OnClaimRewardCallback(res)
  if res == nil then
    return
  end
  self:UpdateTodayNum(checknumber(res.num))
  if not table.IsNullOrEmpty(res.reward) then
    DataCenter.RewardManager:AddRewardsAndRes(res)
    if table.count(res.reward) > 0 and res.reward[1].value ~= nil then
      local item = res.reward[1].value
      local count = checknumber(item.rewardAdd)
      local showCount = count < 12 and count or 10 + math.floor(count / 6)
      local icon = DataCenter.ItemTemplateManager:GetIconPath(item.itemId)
      local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(self.EasterEggPos)
      UIUtil.DoFly(RewardType.GOODS, showCount, icon, uiPos, Vector3.zero)
      local effReq = CS.GameEntry.Resource:InstantiateAsync(UIAssets.ProductLineFlyText)
      effReq:completed("+", function(req)
        if req.isError then
          return
        end
        local tf = req.gameObject.transform
        local text = tf:Find("num"):GetComponent(typeof(CS.SuperTextMesh))
        local sprite = tf:Find("num/icon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        tf.position = self.EasterEggPos
        local v3 = Vector3.one:Mul(0.4)
        sprite.gameObject.transform.localScale = v3
        tf.localScale = Vector3.New(2, 2, 2)
        text.text = "+" .. count
        sprite:LoadSprite(icon)
        TimerManager:GetInstance():DelayInvoke(function()
          if req ~= nil then
            req:Destroy()
          end
        end, 3)
      end)
      DataCenter.LWSoundManager:PlaySound(5100024)
    end
  end
end

function SeasonEasterEggManager:TestFly(val, mul)
  if self.EasterEggConfigs ~= nil then
    local icon = DataCenter.ItemTemplateManager:GetIconPath("640083")
    local pos = CS.CSUtils.WorldPositionToUISpacePosition(self.EasterEggPos)
    UIUtil.DoFly(RewardType.GOODS, val, icon, pos, Vector3.zero)
    local effReq = CS.GameEntry.Resource:InstantiateAsync(UIAssets.ProductLineFlyText)
    effReq:completed("+", function(req)
      if req.isError then
        return
      end
      local tf = req.gameObject.transform
      local text = tf:Find("num"):GetComponent(typeof(CS.SuperTextMesh))
      local sprite = tf:Find("num/icon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      tf.position = self.EasterEggPos
      local v3 = Vector3.one:Mul(mul)
      sprite.gameObject.transform.localScale = v3
      tf.localScale = Vector3.New(2, 2, 2)
      text.text = "+" .. val
      sprite:LoadSprite(icon)
      TimerManager:GetInstance():DelayInvoke(function()
        if req ~= nil then
          req:Destroy()
        end
      end, 3)
    end)
  end
end

return SeasonEasterEggManager
