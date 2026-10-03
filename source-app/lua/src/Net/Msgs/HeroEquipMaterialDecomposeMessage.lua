local HeroEquipMaterialDecomposeMessage = BaseClass("HeroEquipMaterialDecomposeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cfgId, count)
  base.OnCreate(self)
  self.sfsObj:PutLong("useCfgId", cfgId)
  self.sfsObj:PutInt("useCount", count)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.gotCfgId then
      local getMaterailTempalte = DataCenter.EquipMaterialDataManager:GetTemplate(message.gotCfgId)
      if getMaterailTempalte then
        local materailName = Localization:GetString(getMaterailTempalte.name)
        local materailCount = message.gotCount
        if not string.IsNullOrEmpty(materailName) and 0 < materailCount then
          local tips = Localization:GetString(430730, materailName, materailCount)
          UIUtil.ShowTips(tips)
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.HeroEquipMaterialDecompose, message.gotCfgId)
  end
end

HeroEquipMaterialDecomposeMessage.OnCreate = OnCreate
HeroEquipMaterialDecomposeMessage.HandleMessage = HandleMessage
return HeroEquipMaterialDecomposeMessage
