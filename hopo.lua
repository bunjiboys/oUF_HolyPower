local HolyPower = select(1, GetSpellInfo(85247))

local UnitPower = UnitPower
local UnitHasVehicleUI = UnitHasVehicleUI

local Update = function(self, event, unit, powerType)
   if (unit ~= "player" or powerType ~= "HOLY_POWER") then return end

   local hopo = self.HolyPower
   if (hopo.PreUpdate) then
      hopo:PreUpdated()
   end

   -- Hide holy power, if player is in a vehicle
   local stacks
   if (UnitHasVehicleUI("PLAYER")) then
      stacks = 0
   else
      stacks = UnitPower("PLAYER", SPELL_POWER_HOLY_POWER)
   end

   for i = 1, 5 do
      if (i <= stacks) then
         hopo[i]:Show()
      else
         hopo[i]:Hide()
      end
   end

   if (hopo.PostUpdate) then
      return hopo:PostUpdate()
   end
end

local Path = function(self, ...)
   return (self.HolyPower.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
   return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
   local hopo = self.HolyPower

   if (hopo) then
      hopo.__owner = self
      hopo.ForceUpdate = ForceUpdate

      self:RegisterEvent("UNIT_POWER", Path, true)

      for idx = 1, 5 do
         local hp = hopo[idx]

         if (hp:IsObjectType("Texture") and not hp:GetTexture()) then
            hp:SetTexture([[Interface\AddOns\oUF_HolyPower\hopo.tga]])
         end
         hp:Hide()
      end

      return true
   end
end

local Disable = function(self)
   local hopo = self.HolyPower

   if (hopo) then
      for idx = 1, 5 do
         hopo[idx]:Hide()
      end

      self:UnregisterEvent("UNIT_POWER", Path)
   end
end

oUF:AddElement('HolyPower', Path, Enable, Disable)
