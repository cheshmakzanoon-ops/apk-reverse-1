local AllianceDeclareWarCreateMessage = BaseClass("AllianceDeclareWarCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, durTime, type, content, anno)
  base.OnCreate(self)
  self.sfsObj:PutInt("durTime", durTime)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("content", content)
  self.sfsObj:PutUtfString("anno", anno)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "season_tips217" and t.coolEndTime then
      local deltaTime = t.coolEndTime - UITimeManager:GetInstance():GetServerSeconds()
      local restTimeStr = UITimeManager:GetInstance():GetFormattedTime(deltaTime)
      UIUtil.ShowTips(Localization:GetString("season_tips217", restTimeStr))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.AllianceDeclareWarManager:CreateWar(t)
  end
end

AllianceDeclareWarCreateMessage.OnCreate = OnCreate
AllianceDeclareWarCreateMessage.HandleMessage = HandleMessage
return AllianceDeclareWarCreateMessage
